
from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer
from migen.genlib.cdc import *
from gtp_7series_init import GTPTXInit, GTPRXInit
import os

class GTPQuadPLL(Module):
    def __init__(self, refclk, refclk_freq, linerate):
        self.clk = Signal() 
        self.refclk = Signal() 
        self.reset=Signal()
        self.lock = Signal()
        self.config = self.compute_config(refclk_freq, linerate)

        # # #

        self.specials += \
            Instance("GTPE2_COMMON",
                # common
                i_GTREFCLK0=refclk,
                i_BGBYPASSB=1,
                i_BGMONITORENB=1,
                i_BGPDB=1,
                i_BGRCALOVRD=0b11111,
                i_RCALENB=1,

                # pll0
                p_PLL0_FBDIV=self.config["n2"],
                p_PLL0_FBDIV_45=self.config["n1"],
                p_PLL0_REFCLK_DIV=self.config["m"],
                i_PLL0LOCKEN=1,
                i_PLL0PD=0,
                i_PLL0REFCLKSEL=0b001,
                i_PLL0RESET=self.reset,
                o_PLL0LOCK=self.lock,
                o_PLL0OUTCLK=self.clk,
                o_PLL0OUTREFCLK=self.refclk,

                # pll1 (not used: power down)
                i_PLL1PD=1,
             )

    @staticmethod
    def compute_config(refclk_freq, linerate):
        for n1 in 4, 5:
            for n2 in 1, 2, 3, 4, 5:
                for m in 1, 2:
                    vco_freq = refclk_freq*(n1*n2)/m
                    if 1.6e9 <= vco_freq <= 3.3e9:
                        for d in 1, 2, 4, 8:
                            current_linerate = vco_freq*2/d
                            if current_linerate == linerate:
                                return {"n1": n1, "n2": n2, "m": m, "d": d,
                                        "vco_freq": vco_freq,
                                        "clkin": refclk_freq,
                                        "linerate": linerate}
        msg = "No config found for {:3.2f} MHz refclk / {:3.2f} Gbps linerate."
        raise ValueError(msg.format(refclk_freq/1e6, linerate/1e9))

    def __repr__(self):
        r = """
GTPQuadPLL
==============
  overview:
  ---------
       +--------------------------------------------------+
       |                                                  |
       |   +-----+  +---------------------------+ +-----+ |
       |   |     |  | Phase Frequency Detector  | |     | |
CLKIN +----> /M  +-->       Charge Pump         +-> VCO +---> CLKOUT
       |   |     |  |       Loop Filter         | |     | |
       |   +-----+  +---------------------------+ +--+--+ |
       |              ^                              |    |
       |              |    +-------+    +-------+    |    |
       |              +----+  /N2  <----+  /N1  <----+    |
       |                   +-------+    +-------+         |
       +--------------------------------------------------+
                            +-------+
                   CLKOUT +->  2/D  +-> LINERATE
                            +-------+
  config:
  -------
    CLKIN    = {clkin}MHz
    CLKOUT   = CLKIN x (N1 x N2) / M = {clkin}MHz x ({n1} x {n2}) / {m}
             = {vco_freq}GHz
    LINERATE = CLKOUT x 2 / D = {vco_freq}GHz x 2 / {d}
             = {linerate}GHz
""".format(clkin=self.config["clkin"]/1e6,
           n1=self.config["n1"],
           n2=self.config["n2"],
           m=self.config["m"],
           vco_freq=self.config["vco_freq"]/1e9,
           d=self.config["d"],
           linerate=self.config["linerate"]/1e9)
        return r


class GTP(Module):
    def __init__(self, qpll,tx_pads, rx_pads, sys_clk_freq):
        
        self.tx_polarity = Signal()
        self.rx_polarity = Signal()
        self.loopback = Signal(3)
        self.txprecursor = Signal(5)
        self.txpostcursor = Signal(5)
        self.diffctrl = Signal(4) 
        self.reset=Signal()  
       
     
        self.tx_clk_freq = qpll.config["linerate"]/40

        # DRP signals

        self.drpaddr = Signal(9)
        self.drpen = Signal()
        self.drpdi = Signal(16)
        self.drprdy = Signal()
        self.drpdo = Signal(16)
        self.drpwe = Signal()

       
        #   #   #
        self.tx_data=Signal(40)
        self.tx_k=Signal()
        self.tx_init_done=Signal()

        self.rx_data=Signal(40)
        self.rxbytealigned=Signal()
        self.rxcommmadet=Signal()
        
        tx_init = GTPTXInit(sys_clk_freq)
        rx_init = ClockDomainsRenamer("tx")(GTPRXInit(self.tx_clk_freq))
        self.submodules += [tx_init]
        self.submodules += [rx_init]
        # debug
        self.tx_init = tx_init
        self.rx_init = rx_init

       
        # transceiver direct clock outputs
        # useful to specify clock constraints in a way palatable to Vivado
        self._txoutclk = _txoutclk= Signal()
        self.rxoutclk = Signal()

        
        self.txusrclk=txusrclk=Signal()
        self.txusrclk2=txusrclk2=Signal()
        self._txusrclk=_txusrclk=Signal()
        self._txusrclk2=_txusrclk2=Signal()
        self.txoutclk = txoutclk=Signal()
        pll_fb2=Signal()
        self.pll_lock=pll_lock=Signal()
        self.specials += [
            Instance("PLLE2_BASE",
                     p_STARTUP_WAIT="FALSE", o_LOCKED=pll_lock,
                     
                     p_REF_JITTER1=0.01, p_CLKIN1_PERIOD=4.166667,
                     p_CLKFBOUT_MULT=5, p_DIVCLK_DIVIDE=1,
                     i_CLKIN1=self.txoutclk, i_CLKFBIN=pll_fb2, o_CLKFBOUT=pll_fb2,

                     #240 MHz and 120 MHz required
                     p_CLKOUT0_DIVIDE=5, p_CLKOUT0_PHASE=0.0, o_CLKOUT0=_txusrclk,
                     p_CLKOUT1_DIVIDE=10, p_CLKOUT1_PHASE=0.0, o_CLKOUT1=_txusrclk2,
            ),
            Instance("BUFG", i_I=_txoutclk, o_O=txoutclk),
            Instance("BUFG", i_I=_txusrclk2, o_O=txusrclk2),
            Instance("BUFG", i_I=_txusrclk, o_O=txusrclk)
        ]
       
        self.rxinit_done=Signal()

        self.comb += [
            tx_init.restart.eq(self.reset),
            rx_init.restart.eq(self.reset),
            tx_init.plllock.eq(qpll.lock),
            rx_init.plllock.eq(qpll.lock),
            qpll.reset.eq(tx_init.pllreset),
            self.tx_init_done.eq(tx_init.done),
            self.rxinit_done.eq(rx_init.done),
        ]

        # DRP Mux selected by rx_init
        self.comb +=[
    	self.drpaddr.eq(rx_init.drpaddr),
    	self.drpdi.eq(rx_init.drpdi),
    	rx_init.drpdo.eq(self.drpdo),
    	self.drpen.eq(rx_init.drpen),
    	self.drpwe.eq(rx_init.drpwe),
    	rx_init.drprdy.eq(self.drprdy)
    	]
        
        #TX signals 
        
      
        assert qpll.config["linerate"] < 6.6e9
        # rxcdr_cfgs = {
        #      1 : 0x0001107FE206021041010,
        #      2 : 0x0001107FE206021081010,
        #      4 : 0x0001107FE086021101010,
        #      8 : 0x0001107FE086021101010
        # }
        rxcdr_cfgs = {
            1 : 0x0000107FE406001041010,
            2 : 0x0000107FE206001041010,
            4 : 0x0000107FE106001041010,
            8 : 0x0000107FE086001041010
        }

        rxphaligndone = Signal()
        self.specials += \
            Instance("GTPE2_CHANNEL",
                i_GTRESETSEL=0,
                i_RESETOVRD=0,
                p_SIM_RESET_SPEEDUP="TRUE",

                # DRP
                i_DRPADDR=self.drpaddr,
                i_DRPCLK=ClockSignal("tx"),
                i_DRPDI=self.drpdi,
                o_DRPDO=self.drpdo,
                i_DRPEN=self.drpen,
                o_DRPRDY=self.drprdy,
                i_DRPWE=self.drpwe,

                # PMA Attributes
                p_PMA_RSV=0x333,
                p_PMA_RSV2=0x2040,
                p_PMA_RSV3=0,
                p_PMA_RSV4=0,
                p_RX_BIAS_CFG=0b0000111100110011,
                p_RX_CM_SEL=0b01,
                p_RX_CM_TRIM=0b1010,
                p_RX_OS_CFG=0b10000000,
                p_RXLPM_IPCM_CFG=1,
                i_RXOOBRESET=0,
                i_RXELECIDLEMODE=0b11,
                i_RXOSINTCFG=0b0010,
                i_RXOSINTEN=1,

                #Power-Down Attributes
                p_PD_TRANS_TIME_FROM_P2=0x3c,
                p_PD_TRANS_TIME_NONE_P2=0x3c,
                p_PD_TRANS_TIME_TO_P2=0x64,

                # QPLL
                i_PLL0CLK=qpll.clk,
                i_PLL0REFCLK=qpll.refclk,

                #TX clock
                o_TXOUTCLK=self._txoutclk,
                p_TXOUT_DIV=qpll.config["d"],
                i_TXRATE=0b000,
                i_TXSYSCLKSEL=0b00,
                i_TXOUTCLKSEL=0b11,

                # TX Startup/Reset
                i_GTTXRESET=tx_init.gttxreset,
                i_RXPD=Cat(rx_init.gtrxpd, rx_init.gtrxpd),
                i_TXPMARESET=0,
                i_TXPCSRESET=0,
                o_TXRESETDONE=tx_init.txresetdone,
                i_TXSYNCMODE=0,
                i_TXPHDLYRESET=0,
                i_TXDLYBYPASS=0,
                i_TXSYNCALLIN=0,
                i_TXSYNCIN=0,
                i_TXDLYSRESET=tx_init.txdlysreset,
                o_TXDLYSRESETDONE=tx_init.txdlysresetdone,
                i_TXPHINIT=tx_init.txphinit,
                o_TXPHINITDONE=tx_init.txphinitdone,
                i_TXPHALIGNEN=1,
                i_TXPHALIGN=tx_init.txphalign,
                o_TXPHALIGNDONE=tx_init.txphaligndone,
                i_TXDLYEN=tx_init.txdlyen,
                i_TXUSERRDY=tx_init.txuserrdy,

                # TX Buffer Attributes
                p_TXBUF_EN="FALSE",
                p_TX_XCLK_SEL="TXUSR",
                p_TXSYNC_MULTILANE=0,
                p_TXSYNC_SKIP_DA=0,
                p_TXSYNC_OVRD=1,

                #8b10b
                i_TX8B10BEN=0,
                
                # TX data
                p_TX_DATA_WIDTH=40,
                i_TXCHARDISPMODE=Cat(self.tx_data[9],self.tx_data[19],
                    self.tx_data[29],self.tx_data[39]),
                i_TXCHARDISPVAL=Cat(self.tx_data[8],self.tx_data[18],
                    self.tx_data[28],self.tx_data[38]),
                i_TXDATA=Cat(self.tx_data[:8], self.tx_data[10:18],
                    self.tx_data[20:28], self.tx_data[30:38]),
                i_TXUSRCLK=txusrclk,
                i_TXUSRCLK2=txusrclk2,
                # TX electrical
                i_TXBUFDIFFCTRL=0b100,
                i_TXDIFFCTRL=self.diffctrl,
                i_TXELECIDLE=0,
                i_TXINHIBIT=0,
                i_TXPOSTCURSOR=self.txpostcursor,
                i_TXPRECURSOR=self.txprecursor,

                # Internal Loopback
                i_LOOPBACK=self.loopback,

                # RX Startup/Reset
                i_GTRXRESET=rx_init.gtrxreset,
                o_RXRESETDONE=rx_init.rxresetdone,
                i_RXDLYSRESET=rx_init.rxdlysreset,
                o_RXDLYSRESETDONE=rx_init.rxdlysresetdone,
                o_RXPHALIGNDONE=rxphaligndone,
                i_RXSYNCALLIN=rxphaligndone,
                i_RXUSERRDY=rx_init.rxuserrdy,
                i_RXCDRRESET=0,
                i_RXCDRFREQRESET=0,
                i_RXPMARESET=0,
                i_RXLPMRESET=0,
                i_EYESCANRESET=0,
                i_RXPCSRESET=0,
                i_RXBUFRESET=0,
                i_RXSYNCIN=0,
                i_RXSYNCMODE=1,
                p_RXSYNC_MULTILANE=0,
                p_RXSYNC_OVRD=0,
                o_RXSYNCDONE=rx_init.rxsyncdone,
                p_RXPMARESET_TIME=0b11,
                o_RXPMARESETDONE=rx_init.rxpmaresetdone,

                # RX clock
                p_RX_CLK25_DIV=5,
                p_TX_CLK25_DIV=5,
                p_RX_XCLK_SEL="RXUSR",
                i_RXRATE=0b000,
                p_RXOUT_DIV=qpll.config["d"],
                i_RXSYSCLKSEL=0b00,
                i_RXOUTCLKSEL=0b010,
                o_RXOUTCLK=self.rxoutclk,
                i_RXUSRCLK=txusrclk,
                i_RXUSRCLK2=txusrclk2,
                p_RXCDR_CFG=rxcdr_cfgs[qpll.config["d"]],
                p_RXPI_CFG1=1,
                p_RXPI_CFG2=1,

                # RX Clock Correction Attributes
                p_CLK_CORRECT_USE="FALSE",

                # RX data
                i_RX8B10BEN=0,
                p_RXBUF_EN="FALSE",
                p_RXDLY_CFG=0x001f,
                p_RXDLY_LCFG=0x030,
                p_RXPHDLY_CFG=0x084020,
                p_RXPH_CFG=0xc00002,
                p_RX_DATA_WIDTH=40,
                i_RXDLYBYPASS=0,
                i_RXDDIEN=1,
                o_RXDISPERR=Cat(self.rx_data[9], self.rx_data[19],
                    self.rx_data[29], self.rx_data[39]),
                o_RXCHARISK=Cat(self.rx_data[8], self.rx_data[18],
                    self.rx_data[28], self.rx_data[38]),
                o_RXDATA=Cat(self.rx_data[:8], self.rx_data[10:18],
                     self.rx_data[20:28], self.rx_data[30:38]),

                #Aligment
                o_RXBYTEISALIGNED=self.rxbytealigned,
                o_RXCOMMADET=self.rxcommmadet,
                i_RXPCOMMAALIGNEN=1,
                i_RXMCOMMAALIGNEN=1,    
                i_RXCOMMADETEN=1,

                p_ALIGN_COMMA_WORD=2,
                p_ALIGN_COMMA_ENABLE=0b1111111111,
                p_ALIGN_COMMA_DOUBLE="FALSE",
                p_SHOW_REALIGN_COMMA="TRUE",
                p_RXSLIDE_MODE="OFF",
                p_RXSLIDE_AUTO_WAIT=7,
                p_RX_SIG_VALID_DLY=10,
                
                p_ALIGN_MCOMMA_VALUE=0b1100000101, 
                p_ALIGN_MCOMMA_DET="TRUE",
                p_ALIGN_PCOMMA_VALUE=0b0011111010,
                p_ALIGN_PCOMMA_DET="TRUE",



                # Polarity
                i_TXPOLARITY=self.tx_polarity,
                i_RXPOLARITY=self.rx_polarity,

                # Pads
                i_GTPRXP=rx_pads.p,
                i_GTPRXN=rx_pads.n,
                o_GTPTXP=tx_pads.p,
                o_GTPTXN=tx_pads.n
            )


        
        # tx clocking
        self.clock_domains.cd_tx = ClockDomain()
        self.comb+=self.cd_tx.rst.eq(self.reset)
        self.specials += Instance("BUFG", i_I=self.txusrclk2, o_O=self.cd_tx.clk)

        