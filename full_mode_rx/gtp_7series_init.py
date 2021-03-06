from math import ceil

from migen import *
from migen.genlib.cdc import MultiReg, PulseSynchronizer
from migen.genlib.misc import WaitTimer


__all__ = ["GTPTXInit", "GTPRXInit"]


class GTPTXInit(Module):
    def __init__(self, sys_clk_freq):
        self.done = Signal()
        self.restart = Signal()

        # GTP signals
        self.plllock = Signal()
        self.pllreset = Signal()
        self.gttxreset = Signal()
        self.txresetdone = Signal()
        self.txdlysreset = Signal()
        self.txdlysresetdone = Signal()
        self.txphinit = Signal()
        self.txphinitdone = Signal()
        self.txphalign = Signal()
        self.txphaligndone = Signal()
        self.txdlyen = Signal()
        self.txuserrdy = Signal()

        # # #

        # Double-latch transceiver asynch outputs
        plllock = Signal()
        txresetdone = Signal()
        txdlysresetdone = Signal()
        txphinitdone = Signal()
        txphaligndone = Signal()
        self.specials += [
            MultiReg(self.plllock, plllock),
            MultiReg(self.txresetdone, txresetdone),
            MultiReg(self.txdlysresetdone, txdlysresetdone),
            MultiReg(self.txphinitdone, txphinitdone),
            MultiReg(self.txphaligndone, txphaligndone)
        ]

        # Deglitch FSM outputs driving transceiver asynch inputs
        gttxreset = Signal()
        txdlysreset = Signal()
        txphinit = Signal()
        txphalign = Signal()
        txdlyen = Signal()
        txuserrdy = Signal()
        done = Signal()
        self.sync += [
            self.gttxreset.eq(gttxreset),
            self.txdlysreset.eq(txdlysreset),
            self.txphinit.eq(txphinit),
            self.txphalign.eq(txphalign),
            self.txdlyen.eq(txdlyen),
            self.txuserrdy.eq(txuserrdy),
            self.done.eq(done)
        ]

        # PLL reset must be at least 500us
        pll_reset_cycles = ceil(500e-9*sys_clk_freq)
        pll_reset_timer = WaitTimer(pll_reset_cycles)
        self.submodules += pll_reset_timer

        startup_fsm = ResetInserter()(FSM(reset_state="PLL_RESET"))
        self.submodules += startup_fsm

        ready_timer = WaitTimer(int(1e-3*sys_clk_freq))
        self.submodules += ready_timer
        self.comb += [
            ready_timer.wait.eq(~done & ~startup_fsm.reset),
            startup_fsm.reset.eq(self.restart | ready_timer.done)
            #startup_fsm.reset.eq(self.restart)
        ]

        txphaligndone_r = Signal(reset=1)
        txphaligndone_rising = Signal()
        self.sync += txphaligndone_r.eq(txphaligndone)
        self.comb += txphaligndone_rising.eq(txphaligndone & ~txphaligndone_r)

        startup_fsm.act("PLL_RESET",
            pll_reset_timer.wait.eq(1),
            If(pll_reset_timer.done,
                self.pllreset.eq(1),
                NextState("GTP_RESET")
            )
        )
        startup_fsm.act("GTP_RESET", #1
            gttxreset.eq(1),
            If(plllock,
                NextState("WAIT_GTP_RESET_DONE")
            )
        )
        # Release GTP reset and wait for GTP resetdone
        # (from UG482, GTP is reset on falling edge
        # of gttxreset)
        startup_fsm.act("WAIT_GTP_RESET_DONE", #2
            gttxreset.eq(0),
            txuserrdy.eq(1),
            If(txresetdone, NextState("ALIGN"))
        )
        # Start delay alignment
        startup_fsm.act("ALIGN", #3
            txuserrdy.eq(1),
            txdlysreset.eq(1),
            If(txdlysresetdone,
                NextState("PHALIGN")
            )
        )
        # Start phase alignment
        startup_fsm.act("PHALIGN", #4
            txuserrdy.eq(1),
            txphinit.eq(1),
            If(txphinitdone,
                NextState("WAIT_FIRST_ALIGN_DONE")
            )
        )
        # Wait 2 rising edges of Xxphaligndone
        # (from UG482 in TX Buffer Bypass in Single-Lane Auto Mode)
        startup_fsm.act("WAIT_FIRST_ALIGN_DONE",
            txuserrdy.eq(1),
            txphalign.eq(1),
            If(txphaligndone_rising,
                NextState("WAIT_SECOND_ALIGN_DONE")
            )
        )
        startup_fsm.act("WAIT_SECOND_ALIGN_DONE",
            txuserrdy.eq(1),
            txdlyen.eq(1),
            If(txphaligndone_rising,
                NextState("READY")
            )
        )
        startup_fsm.act("READY",
            txuserrdy.eq(1),
            done.eq(1),
            If(self.restart, NextState("PLL_RESET"))
        )

class GTPRXInit(Module):
    def __init__(self, sys_clk_freq):
        self.done = Signal()
        self.restart = Signal()

        # GTP signals
        self.plllock = Signal()
        self.gtrxreset = Signal()
        self.gtrxpd = Signal()
        self.rxresetdone = Signal()
        self.rxdlysreset = Signal()
        self.rxdlysresetdone = Signal()
        self.rxphalign = Signal()
        self.rxdlyen = Signal()
        self.rxuserrdy = Signal()
        self.rxsyncdone = Signal()
        self.rxpmaresetdone = Signal()
        self.rxphdlypd = Signal(reset=1)
        self.pll_rxusrclk_rst = Signal()
        self.pll_rxusrclk_lock = Signal()


        self.drpaddr = Signal(9)
        self.drpen = Signal()
        self.drpdi = Signal(16)
        self.drprdy = Signal()
        self.drpdo = Signal(16)
        self.drpwe = Signal()
        self.drp_mux_sel = Signal()

        # # #

        drpvalue = Signal(16)
        drpmask = Signal()
        self.comb += [
            self.drpaddr.eq(0x011),
            If(drpmask,
                self.drpdi.eq(drpvalue & 0xf7ff) #bit[11]=0
            ).Else(
                self.drpdi.eq(drpvalue)
            )
        ]

        rxpmaresetdone = Signal()
        self.specials += MultiReg(self.rxpmaresetdone, rxpmaresetdone)
        rxpmaresetdone_r = Signal()
        self.sync += rxpmaresetdone_r.eq(rxpmaresetdone)

        # Double-latch transceiver asynch outputs
        plllock = Signal()
        rxresetdone = Signal()
        rxdlysresetdone = Signal()
        rxsyncdone = Signal()
        restart = Signal()
        self.specials += [
            MultiReg(self.plllock, plllock),
            MultiReg(self.rxresetdone, rxresetdone),
            MultiReg(self.rxdlysresetdone, rxdlysresetdone),
            MultiReg(self.rxsyncdone, rxsyncdone),
            MultiReg(self.restart,restart)
        ]

        # Deglitch FSM outputs driving transceiver asynch inputs
        gtrxreset = Signal()
        gtrxpd = Signal()
        rxdlysreset = Signal()
        rxphalign = Signal()
        rxdlyen = Signal()
        rxuserrdy = Signal()


        self.sync += [
            self.gtrxreset.eq(gtrxreset),
            self.gtrxpd.eq(gtrxpd),
            self.rxdlysreset.eq(rxdlysreset),
            self.rxphalign.eq(rxphalign),
            self.rxdlyen.eq(rxdlyen),
            self.rxuserrdy.eq(rxuserrdy)
        ]

        # After configuration, transceiver resets have to stay low for
        # at least 500ns (see AR43482)
        pll_reset_cycles = ceil(500e-9*sys_clk_freq)
        pll_reset_timer = WaitTimer(pll_reset_cycles)
        self.submodules += pll_reset_timer

        startup_fsm_rx = ResetInserter()(FSM(reset_state="GTP_PD"))
        self.submodules += startup_fsm_rx

        #ready_timer = WaitTimer(int(4e-3*sys_clk_freq))
        #self.submodules += ready_timer
        self.comb += [
            #ready_timer.wait.eq(~self.done & ~startup_fsm_rx.reset),
            #startup_fsm_rx.reset.eq(self.restart | ready_timer.done)
            startup_fsm_rx.reset.eq(restart )
        ]

        cdr_stable_timer = WaitTimer(1024)
        self.submodules += cdr_stable_timer

        startup_fsm_rx.act("GTP_PD", #0
            NextValue(self.rxphdlypd,0),
           
            gtrxpd.eq(1),
            pll_reset_timer.wait.eq(1),
            If(pll_reset_timer.done,
                #gtrxreset.eq(1),
                NextState("GTP_PLL_WAIT")
            )
        )

        startup_fsm_rx.act("GTP_PLL_WAIT", #1
            gtrxreset.eq(1),
            If(plllock,
                NextState("DRP_READ_ISSUE")
            )
        )

        startup_fsm_rx.act("DRP_READ_ISSUE", #2
        
            gtrxreset.eq(1),
            self.drpen.eq(1),
            NextState("DRP_READ_WAIT")
        )
        startup_fsm_rx.act("DRP_READ_WAIT", #3
         
            gtrxreset.eq(1),
            If(self.drprdy,
                NextValue(drpvalue, self.drpdo),
                NextState("DRPRDY_DEASSERT")
            )
        )

        startup_fsm_rx.act("DRPRDY_DEASSERT", #4
       
            gtrxreset.eq(1),
            If(~self.drprdy,
                NextState("DRP_MOD_ISSUE")
            )
        )

        startup_fsm_rx.act("DRP_MOD_ISSUE", #5
        
            gtrxreset.eq(1),
            drpmask.eq(1),
            self.drpen.eq(1),
            self.drpwe.eq(1),
            NextState("DRP_MOD_WAIT")
        )
        startup_fsm_rx.act("DRP_MOD_WAIT", #6
        
            gtrxreset.eq(1),
            If(self.drprdy,
                gtrxreset.eq(0),
                NextState("WAIT_PMARST_FALL")
            )
        )
        startup_fsm_rx.act("WAIT_PMARST_FALL", #7
         
            rxuserrdy.eq(1),
            If(rxpmaresetdone_r & ~rxpmaresetdone,
                NextState("DRP_RESTORE_ISSUE")
            )
        )
        startup_fsm_rx.act("DRP_RESTORE_ISSUE", #8
         
            rxuserrdy.eq(1),
            self.drpen.eq(1),
            self.drpwe.eq(1),
            NextState("DRP_RESTORE_WAIT")
        )
        startup_fsm_rx.act("DRP_RESTORE_WAIT", #9
    
            rxuserrdy.eq(1),
            If(self.drprdy,
                NextState("WAIT_GTP_RESET_DONE")
            )
        )
        # Release GTP reset and wait for GTP resetdone
        # (from UG482, GTP is reset on falling edge
        # of gtrxreset)
        startup_fsm_rx.act("WAIT_GTP_RESET_DONE", #10
         
            rxuserrdy.eq(1),
            cdr_stable_timer.wait.eq(1),
            If(rxresetdone & cdr_stable_timer.done,
                NextState("WAIT_PLL_RXUSRCLK_LOCK"),
                NextValue(self.pll_rxusrclk_rst,1)
            )
        )

        startup_fsm_rx.act("WAIT_PLL_RXUSRCLK_LOCK",
            NextValue(self.pll_rxusrclk_rst,0),
            rxuserrdy.eq(1),
            If(self.pll_rxusrclk_lock,
                NextState("ALIGN")
            )
        )
        # Start delay alignment
        startup_fsm_rx.act("ALIGN",
       
            rxuserrdy.eq(1),
            rxdlysreset.eq(1),
            If(rxdlysresetdone,
                NextState("WAIT_ALIGN_DONE")
            )
        )
        # Wait for delay alignment
        startup_fsm_rx.act("WAIT_ALIGN_DONE",
         
            rxuserrdy.eq(1),
            If(rxsyncdone,
                NextState("READY")
            )
        )
        startup_fsm_rx.act("READY",
   
            rxuserrdy.eq(1),
            self.done.eq(1),
            If(restart, NextState("GTP_PD")
            )
        )