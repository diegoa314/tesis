import os
import sys
import random
from migen import *
from migen.genlib.io import CRG
from gtp import GTPQuadPLL, GTP
from daphne_platforms import Platform
from tx import TX
from rx import RX
from prbs import PRBSGenerator
from asyncfifoDT import AsyncFIFO
from alignment_corrector import Alignment_Corrector
from memory import mem
class FullModeSim(Module):
    def __init__(self, platform):
        """
        we: Write button. When is asserted, all data and data type from 
        memory is written into the FIFO. 
        link_ready: When is asserted, the transmision starts.
        trans_en: When is asserted, the transmision of data received in
        RX to the PC via UART starts.
        """
        self.we=Signal() 
        self.link_ready=Signal()
        self.trans_en=Signal()
        self.reset=Signal() 
        #   #   #
        self.reset=platform.request("reset")

        write_clk = Signal() #clock that drives fifo writing 
        write_clk_bufg = Signal()
        write_clk_pads = platform.request("write_clk") #differential clock
        self.specials += [
            Instance("IBUFGDS",
                i_I=write_clk_pads.p,
                i_IB=write_clk_pads.n,
                o_O=write_clk_bufg), 
            Instance("BUFG", i_I=write_clk_bufg, o_O=write_clk)
        ]
        self.clock_domains.cd_write=ClockDomain(name="write") #fifo writing clock domain
      
        
        gtp_clk=Signal() #gtp reference clk
        gtp_clk_bufg=Signal()
        gtp_clk_freq=240e6
        gtp_clk_pads = platform.request("gtp_clk")
        self.specials +=[
            Instance("IBUFDS_GTE2",
                    i_CEB=0,
                    i_I=gtp_clk_pads.p,
                    i_IB=gtp_clk_pads.n,
                    o_O=gtp_clk_bufg),
            Instance("BUFG", i_I=gtp_clk_bufg, o_O=gtp_clk)
        ]
        self.submodules.crg = CRG(gtp_clk,rst=self.reset) #tx_init clock region
        self.comb += [
          
        ]        
        qpll = GTPQuadPLL(gtp_clk, gtp_clk_freq, 4.8e9)
        print(qpll)
        self.submodules += qpll

        tx_pads = platform.request("gtp_tx")
        rx_pads = platform.request("gtp_rx")
        gtp = GTP(qpll, tx_pads, rx_pads, gtp_clk_freq)
        self.submodules += gtp
  
        
        self.we=platform.request("we")
        self.link_ready=platform.request("link_ready")
        self.trans_en=platform.request("trans_en")
        
        tx=TX()
        tx=ClockDomainsRenamer("tx")(tx)
        rx=RX()
        rx=ClockDomainsRenamer("tx")(rx)
        fifo=AsyncFIFO(width=32,depth=32)
        fifo=ClockDomainsRenamer({"read":"tx"})(fifo)
        corrector=ClockDomainsRenamer("tx")(Alignment_Corrector())
        
        self.submodules+=[fifo,tx,corrector,rx]
        
        generator_sel=0 #1 for memory, 0 for PRBS
        n_data=10 #number of data generated by the PRBS
        if generator_sel:
            memory=mem()
            memory=ClockDomainsRenamer("write")(memory)
            self.submodules+=memory
            index=Signal(5) #Memory index
            write_fifo=Signal() #fifo write enable
            #FSM to control the FIFO writing process
            self.submodules.memory_fsm=FSM(reset_state="INIT")
            self.memory_fsm=ClockDomainsRenamer("write")(self.memory_fsm)
            self.memory_fsm.act("INIT",
                If(self.we,
                    NextValue(index,1),
                    NextState("WRITING"),
                    NextValue(write_fifo,1),
                )
            )
            self.memory_fsm.act("WRITING",
                
                NextValue(index,index+1),
                If(index==(memory.n_value), #Last word reached
                    
                    NextValue(index,0),
                    NextState("WRITING_EOP"),
                    NextValue(write_fifo,0)
                )    
            )
            self.memory_fsm.act("WRITING_EOP",
                NextState("IDLE"),
                
            )
            self.memory_fsm.act("IDLE",
                If(~self.we, #Process starts again
                    NextState("INIT")
                )
            )
            self.comb+=[
                fifo.din.eq(memory.data_out),
                fifo.dtin.eq(memory.type_out),
                fifo.we.eq(write_fifo),
                memory.index.eq(index)
            ]

        else:
            prbs=PRBSGenerator(n_out=32)
            prbs=ClockDomainsRenamer("write")(prbs)
            self.submodules+=prbs
            prbs_en=Signal()
            data_type=Signal(2)
            index=Signal(max=n_data+2)
            i_ignored=Signal(max=n_data-1)
            write_fifo=Signal()
            self.comb+=i_ignored.eq(random.randint(2,n_data-1))
            self.submodules.prbs_fsm=FSM(reset_state="INIT")
            self.prbs_fsm=ClockDomainsRenamer("write")(self.prbs_fsm)
            self.prbs_fsm.act("INIT",
                If(self.we,
                    NextValue(prbs_en,1),
                    NextValue(data_type,1),
                    NextValue(write_fifo,1),
                    NextState("SOP")
                )
            )
            self.prbs_fsm.act("SOP",
                NextValue(data_type,0),
                NextValue(index,index+1),
                NextState("MIDDLE_WORD")
            )    
            
            self.prbs_fsm.act("MIDDLE_WORD",
                If(index<n_data,
                    If(index==i_ignored-1,
                        NextValue(data_type,0b11)
                    ).Else(
                        NextValue(data_type,0b00)
                    ),
                    NextValue(index,index+1),
                    NextState("MIDDLE_WORD")
                ).Else(
                    NextState("EOP"),
                    NextValue(data_type,0b10),
                    NextValue(index,0)
                )
            )
            self.prbs_fsm.act("EOP",
                NextValue(prbs_en,0),
                NextValue(write_fifo,0),
                NextState("WAITS_RESET")
            )
            self.prbs_fsm.act("WAITS_RESET",
                If(~self.we,
                    NextState("INIT")

                )
            )

            self.comb+=[
                fifo.din.eq(prbs.o),
                fifo.dtin.eq(data_type),
                prbs.enable.eq(prbs_en),
                fifo.we.eq(write_fifo),
            ]



        self.rxinit_done=Signal()  
        #rx_init_done signal goes to tb only for simulation purposes
        self.rxinit_done=platform.request("rxinit_done")    
       

        self.comb+=[
            gtp.reset.eq(self.reset),
            fifo.re.eq(tx.fifo_re),
            tx.link_ready.eq(self.link_ready),
            tx.fifo_empty.eq(~fifo.readable),
            tx.tx_init_done.eq(gtp.tx_init_done),
            tx.pll_lock.eq(gtp.pll_lock),
            If((self.link_ready & fifo.readable), 
                tx.data_type_in.eq(fifo.dtout),
                tx.data_in.eq(fifo.dout), 
            ),
            gtp.tx_data.eq(tx.data_out),
            corrector.din.eq(gtp.rx_data),
            corrector.aligned.eq(gtp.rxbytealigned),
            rx.data_in.eq(corrector.dout),
            rx.rx_init_done.eq(gtp.rxinit_done),
            rx.pll_lock.eq(gtp.pll_lock),
            rx.trans_en.eq(self.trans_en),
            self.rxinit_done.eq(gtp.rxinit_done),
            #self.rxinit_done.eq(gtp.tx_init_done),

            self.cd_write.clk.eq(write_clk),
            self.cd_write.rst.eq(self.reset)
           
          
            
        ]

def generate_top():
    platform = Platform()
    soc = FullModeSim(platform)
    platform.build(soc, build_dir="./", run=False)

def generate_top_tb():
    f = open("top_tb.v", "w")
    f.write("""
`timescale 1ns/1ps

module top_tb();

reg write_clk;
initial write_clk = 1'b1;
always #1.25 write_clk = ~write_clk; //1.25 is half period of 400 MHz write clk

reg gtp_clk;
initial gtp_clk = 1'b1;
always #2.08333 gtp_clk = ~gtp_clk; //2.08333 is half period of 240 MHz gtp clk

real period =2.5; //400 MHz period

reg link_ready;
initial link_ready=0;
reg we;
reg trans_en;
reg reset;
initial reset='b0;
initial we='b0;
initial trans_en='b0;
wire gtp_p;
wire gtp_n;

wire rxinit_done;

top dut (
    .gtp_tx_p(gtp_p),
    .gtp_tx_n(gtp_n),
    .gtp_rx_p(gtp_p),
    .gtp_rx_n(gtp_n),
    .write_clk_p(write_clk),
    .write_clk_n(~write_clk),
    .gtp_clk_p(gtp_clk),
    .gtp_clk_n(~gtp_clk),
    .we(we),
    .link_ready(link_ready),
    .trans_en(trans_en),
    .rxinit_done(rxinit_done),
    .reset(reset)
    
);


always begin 
    //Waits signals initialization
    for (integer i=0;i<=400;i=i+1) begin
        #period;
    end
    //Waits rx initialization (tx is always(?) initialized first)
    while(!rxinit_done) begin
        #period;
    end
    //Starts transmision. It will send IDLE because FIFO is empty yet
    link_ready=1'b1; 
    for (integer i=0;i<=100;i=i+1) begin
        #period;
    end
    
    //The writing process starts
    we=1'b1;
    for (integer i=0;i<=100;i=i+1) begin
        #period;
    end
    
    /*
    //The transmision via UART starts
    trans_en=1'b1;
    for (integer i=0;i<=10000;i=i+1) begin
        #period;
    end
    */

    we=1'b0;
    #period;
    we=1'b1;
    //The writing process starts again
    for (integer i=0;i<=100;i=i+1) begin
        #period;
    end

    //Reset
    reset=1'b1;
    #period;
    #period;
    #period;
    reset=1'b0;

    for (integer i=0;i<=100;i=i+1) begin
        #period;
    end
    
    we=1'b0;
    #period;
    we=1'b1;
    //The writing process starts again
    for (integer i=0;i<=100;i=i+1) begin
        #period;
    end
end
endmodule""")
    f.close()

def run_sim():
    os.system("rm -rf xsim.dir")
    os.system("xvlog glbl.v")
    os.system("xvlog top.v")
    os.system("xvlog top_tb.v")
    os.system("xelab -debug typical top_tb glbl -s top_tb_sim -L unisims_ver -L unimacro_ver -L SIMPRIM_VER -L secureip -L $xsimdir/xil_defaultlib -timescale 1ns/1ps")
    os.system("xsim top_tb_sim -gui")

def main():
    generate_top()
    generate_top_tb()
    run_sim()

if __name__ == "__main__":
    main()
