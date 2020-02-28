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
        self.sync += [
            self.gttxreset.eq(gttxreset),
            self.txdlysreset.eq(txdlysreset),
            self.txphinit.eq(txphinit),
            self.txphalign.eq(txphalign),
            self.txdlyen.eq(txdlyen),
            self.txuserrdy.eq(txuserrdy)
        ]

        # PLL reset must be at least 500us
        pll_reset_cycles = ceil(500e-9*sys_clk_freq)
        pll_reset_timer = WaitTimer(pll_reset_cycles)
        self.submodules += pll_reset_timer

        startup_fsm_rx = ResetInserter()(FSM(reset_state="PLL_RESET"))
        self.submodules += startup_fsm_rx

        ready_timer = WaitTimer(int(1e-3*sys_clk_freq))
        self.submodules += ready_timer
        self.comb += [
            ready_timer.wait.eq(~self.done & ~startup_fsm_rx.reset),
            startup_fsm_rx.reset.eq(self.restart | ready_timer.done)
        ]

        txphaligndone_r = Signal(reset=1)
        txphaligndone_rising = Signal()
        self.sync += txphaligndone_r.eq(txphaligndone)
        self.comb += txphaligndone_rising.eq(txphaligndone & ~txphaligndone_r)

        startup_fsm_rx.act("PLL_RESET", #0
            pll_reset_timer.wait.eq(1),
            If(pll_reset_timer.done,
                self.pllreset.eq(1),
                NextState("GTP_RESET")
            )
        )
        startup_fsm_rx.act("GTP_RESET", #1
            gttxreset.eq(1),
            If(plllock,
                NextState("WAIT_GTP_RESET_DONE")
            )
        )
        # Release GTP reset and wait for GTP resetdone
        # (from UG482, GTP is reset on falling edge
        # of gttxreset)
        startup_fsm_rx.act("WAIT_GTP_RESET_DONE", #2
            gttxreset.eq(0),
            txuserrdy.eq(1),
            If(txresetdone, NextState("ALIGN"))
        )
        # Start delay alignment
        startup_fsm_rx.act("ALIGN", #3
            txuserrdy.eq(1),
            txdlysreset.eq(1),
            If(txdlysresetdone,
                NextState("PHALIGN")
            )
        )
        # Start phase alignment
        startup_fsm_rx.act("PHALIGN", #4
            txuserrdy.eq(1),
            txphinit.eq(1),
            If(txphinitdone,
                NextState("WAIT_FIRST_ALIGN_DONE")
            )
        )
        # Wait 2 rising edges of Xxphaligndone
        # (from UG482 in TX Buffer Bypass in Single-Lane Auto Mode)
        startup_fsm_rx.act("WAIT_FIRST_ALIGN_DONE", #5
            txuserrdy.eq(1),
            txphalign.eq(1),
            If(txphaligndone_rising,
                NextState("WAIT_SECOND_ALIGN_DONE")
            )
        )
        startup_fsm_rx.act("WAIT_SECOND_ALIGN_DONE", #6
            txuserrdy.eq(1),
            txdlyen.eq(1),
            If(txphaligndone_rising,
                NextState("READY")
            )
        )
        startup_fsm_rx.act("READY", #7
            txuserrdy.eq(1),
            self.done.eq(1),
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
            #If(drpmask,
            #    self.drpdi.eq(drpvalue & 0xf7ff)
            #).Else(
            #    self.drpdi.eq(drpvalue)
            #)
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
        self.specials += [
            MultiReg(self.plllock, plllock),
            MultiReg(self.rxresetdone, rxresetdone),
            MultiReg(self.rxdlysresetdone, rxdlysresetdone),
            MultiReg(self.rxsyncdone, rxsyncdone)
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

        ready_timer = WaitTimer(int(4e-3*sys_clk_freq))
        self.submodules += ready_timer
        self.comb += [
            ready_timer.wait.eq(~self.done & ~startup_fsm_rx.reset),
            startup_fsm_rx.reset.eq(self.restart | ready_timer.done)
        ]

        cdr_stable_timer = WaitTimer(1024)
        self.submodules += cdr_stable_timer

        self.st_gtp_pd=Signal()
        self.st_gtp_pll_wait=Signal()
        self.state_1=Signal()
        self.state_2=Signal()
        self.state_3=Signal()
        self.state_4=Signal()
        self.state_5=Signal()
        self.state_6=Signal()
        self.state_7=Signal()
        self.state_8=Signal()
        self.state_9=Signal()
        self.state_10=Signal()
        self.state_11=Signal()
        self.state_12=Signal()
        self.state_13=Signal()
        self.state_14=Signal()
        """
        
        startup_fsm_rx.act("GTP_PD",
            self.drp_mux_sel.eq(1),
            gtrxpd.eq(1),
            pll_reset_timer.wait.eq(1),
            If(pll_reset_timer.done,
                #gtrxreset.eq(1),
                NextState("GTP_PLL_WAIT")
            ),
            self.state_1.eq(1)
        )

        startup_fsm_rx.act("GTP_PLL_WAIT",
            self.drp_mux_sel.eq(1),
            gtrxreset.eq(1),
            If(plllock,
                NextState("DRP_READ_ISSUE")
                
            ),
            self.state_2.eq(1)
        )

        startup_fsm_rx.act("WAIT_RD_DATA"

        )

        startup_fsm_rx.act("DRP_READ_ISSUE", #wr_16
            self.drp_mux_sel.eq(1),
            gtrxreset.eq(1),
            self.drpen.eq(1),
            NextState("DRP_READ_WAIT"),
            self.state_3.eq(1)
        )
        startup_fsm_rx.act("DRP_READ_WAIT", #wait_wr_done1
            self.drp_mux_sel.eq(1),
            gtrxreset.eq(1),
            If(self.drprdy,
                NextValue(drpvalue, self.drpdo),
                NextState("DRPRDY_DEASSERT")
            ),
            self.state_4.eq(1)
        )

        startup_fsm_rx.act("DRPRDY_DEASSERT",
            self.drp_mux_sel.eq(1),
            gtrxreset.eq(1),
            If(~self.drprdy,
                NextState("DRP_MOD_ISSUE")
            ),
            self.state_5.eq(1)
        )

        startup_fsm_rx.act("DRP_MOD_ISSUE",
            self.drp_mux_sel.eq(1),
            gtrxreset.eq(1),
            drpmask.eq(1),
            self.drpen.eq(1),
            self.drpwe.eq(1),
            NextState("DRP_MOD_WAIT"),
            self.state_6.eq(1)
        )
        startup_fsm_rx.act("DRP_MOD_WAIT",
            self.drp_mux_sel.eq(1),
            gtrxreset.eq(1),
            If(self.drprdy,
                gtrxreset.eq(0),
                NextState("WAIT_PMARST_FALL")
            ),
            self.state_7.eq(1)
        )
        startup_fsm_rx.act("WAIT_PMARST_FALL",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            If(rxpmaresetdone_r & ~rxpmaresetdone,
                NextState("DRP_RESTORE_ISSUE")
            ),
            self.state_8.eq(1)
        )
        startup_fsm_rx.act("DRP_RESTORE_ISSUE",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            self.drpen.eq(1),
            self.drpwe.eq(1),
            NextState("DRP_RESTORE_WAIT"),
            self.state_9.eq(1)
        )
        startup_fsm_rx.act("DRP_RESTORE_WAIT",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            If(self.drprdy,
                NextState("WAIT_GTP_RESET_DONE")
            )
        )
        
        # Release GTP reset and wait for GTP resetdone
        # (from UG482, GTP is reset on falling edge
        # of gtrxreset)
        startup_fsm_rx.act("WAIT_GTP_RESET_DONE",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            cdr_stable_timer.wait.eq(1),
            If(rxresetdone & cdr_stable_timer.done,
                NextState("ALIGN")
            ),
            self.state_10.eq(1)
        )
        # Start delay alignment
        startup_fsm_rx.act("ALIGN",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            rxdlysreset.eq(1),
            If(rxdlysresetdone,
                NextState("WAIT_ALIGN_DONE")
            ),
            self.state_11.eq(1)
        )
        # Wait for delay alignment
        startup_fsm_rx.act("WAIT_ALIGN_DONE",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            If(rxsyncdone,
                NextState("READY")
            ),
            self.state_12.eq(1)
        )
        startup_fsm_rx.act("READY",
            #self.drp_mux_sel.eq(0),
            rxuserrdy.eq(1),
            self.done.eq(1),
            If(self.restart, NextState("GTP_PD")
            ),
            self.state_13.eq(1)
        )
        """
        self.flag=flag=Signal()
        self.rd_data=rd_data=Signal(16)
        self.next_rd_data=next_rd_data=Signal(16)
        self.original_rd_data=original_rd_data=Signal(16)
        self.st_drp_rd=Signal()
        self.st_wait_rd_data=Signal()
        self.st_wr_16=Signal()
        self.st_wait_wr_done1=Signal()
        self.st_wait_pmareset=Signal()
        self.st_wr_20=Signal()
        self.st_drprdy_deassert=Signal()
        self.st_wait_wr_done2=Signal()
        self.sync+=[
            If((self.st_wr_16 | self.st_wait_pmareset | self.st_wr_20 | self.st_wait_wr_done1),
                flag.eq(1)        
            ).Elif(self.st_wait_wr_done2, flag.eq(0))
        ]
        self.sync+=[
            If((self.st_wait_rd_data & self.drprdy & ~flag),
                self.original_rd_data.eq(self.drpdo)
            )
        ]

        startup_fsm_rx.act("GTP_PD",
            self.drp_mux_sel.eq(1),
            gtrxpd.eq(1),
            pll_reset_timer.wait.eq(1),
            If(pll_reset_timer.done,
                #gtrxreset.eq(1),
                NextState("GTP_PLL_WAIT")
            ),
            self.st_gtp_pd.eq(1)
        )

        startup_fsm_rx.act("GTP_PLL_WAIT",
            self.drp_mux_sel.eq(1),
            If(plllock,
                NextState("DRP_RD")
            ),
            self.st_gtp_pll_wait.eq(1)
        )

        startup_fsm_rx.act("DRP_RD",
            NextState("WAIT_RD_DATA"),
            self.st_drp_rd.eq(1)
        )

        startup_fsm_rx.act("WAIT_RD_DATA",
            
            If(self.drprdy,
                NextState("DRPRDY_DEASSERT")
            ),

            self.st_wait_rd_data.eq(1)
        )

        startup_fsm_rx.act("DRPRDY_DEASSERT",
            If(~self.drprdy,
                NextState("WR_16")
            ),
            self.st_drprdy_deassert.eq(1)

        )

        startup_fsm_rx.act("WR_16",
            NextState("WAIT_WR_DONE1"),
            self.st_wr_16.eq(1)
        )

        startup_fsm_rx.act("WAIT_WR_DONE1",
            If(self.drprdy,
                NextState("WAIT_PMARESET")
            ),
            self.st_wait_wr_done1.eq(1)
        )

        startup_fsm_rx.act("WAIT_PMARESET",
            If(rxpmaresetdone_r & ~rxpmaresetdone,
                NextState("WR_20")
            ),
            self.st_wait_pmareset.eq(1)
        )

        startup_fsm_rx.act("WR_20",
            NextState("WAIT_WR_DONE2"),
            self.st_wr_20.eq(1)
        )

        startup_fsm_rx.act("WAIT_WR_DONE2",
            If(self.drprdy,
                NextState("WAIT_GTP_RESET_DONE")
            ),
            self.st_wait_wr_done2.eq(1)
        )


        # Release GTP reset and wait for GTP resetdone
        # (from UG482, GTP is reset on falling edge
        # of gtrxreset)
        startup_fsm_rx.act("WAIT_GTP_RESET_DONE",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            cdr_stable_timer.wait.eq(1),
            If(rxresetdone & cdr_stable_timer.done,
                NextState("ALIGN")
            ),
            self.state_10.eq(1)
        )
        # Start delay alignment
        startup_fsm_rx.act("ALIGN",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            rxdlysreset.eq(1),
            If(rxdlysresetdone,
                NextState("WAIT_ALIGN_DONE")
            ),
            self.state_11.eq(1)
        )
        # Wait for delay alignment
        startup_fsm_rx.act("WAIT_ALIGN_DONE",
            self.drp_mux_sel.eq(1),
            rxuserrdy.eq(1),
            If(rxsyncdone,
                NextState("READY")
            ),
            self.state_12.eq(1)
        )
        startup_fsm_rx.act("READY",
            #self.drp_mux_sel.eq(0),
            rxuserrdy.eq(1),
            self.done.eq(1),
            If(self.restart, NextState("GTP_PD")
            ),
            self.state_13.eq(1)
        )

       
        self.comb+=[
            If(self.st_gtp_pll_wait,
                gtrxreset.eq(1),
            ).Elif(self.st_drp_rd,
                gtrxreset.eq(1),
                self.drpen.eq(1),
                self.drpwe.eq(0),
            ).Elif(self.st_wait_rd_data,
                gtrxreset.eq(1),
                If((self.drprdy & ~flag),
                   next_rd_data.eq(self.drpdo) 
                ).Elif((self.drprdy & flag),
                    next_rd_data.eq(original_rd_data)
                ).Else(next_rd_data.eq(rd_data))
            ).Elif(self.st_drprdy_deassert,
                gtrxreset.eq(1),
            ).Elif(self.st_wr_16,
                gtrxreset.eq(1),
                self.drpen.eq(1),
                self.drpwe.eq(1),
                self.drpdi.eq(rd_data^0b0000100000000000)

            ).Elif(self.st_wait_wr_done1,
                gtrxreset.eq(1)
            ).Elif(self.st_wait_pmareset,
                gtrxreset.eq(0)
            ).Elif(self.st_wr_20,
                self.drpen.eq(1),
                self.drpwe.eq(1),
                self.drpdi.eq(rd_data)
            ).Else(
                next_rd_data.eq(rd_data)
            )
        ]
        
        self.sync+=[rd_data.eq(next_rd_data)]

