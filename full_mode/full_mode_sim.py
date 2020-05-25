import os
import sys
from migen import *
from migen.genlib.io import CRG

from gtp import GTPQuadPLL, GTP
from daphne_platforms import Platform
from TX.tx import TX
from TX.FIFO.asyncfifoDT import AsyncFIFOBuffered 
class FullModeSim(Module):
    def __init__(self, platform):
        self.din=Signal(8) #data to write in the fifo
        self.dtin=Signal(2) #data type to write in the fifo
        self.we=Signal() #fifo write enable
        self.link_ready=Signal() #starts transmision
        #   #   #

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
        self.comb += [
            self.cd_write.clk.eq(write_clk),
        ]        
        
        gtp_clk_bufg=Signal()
        gtp_clk=Signal()
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
        self.submodules.crg = CRG(gtp_clk) #tx_init clock region
        qpll = GTPQuadPLL(gtp_clk, gtp_clk_freq, 4.8e9)
        print(qpll)
        self.submodules += qpll

        tx_pads = platform.request("gtp_tx")
        gtp = GTP(qpll, tx_pads, rx_pads, gtp_clk_freq)
        self.submodules += gtp

       
        self.din=platform.request("din")
        self.dtin=platform.request("dtin")
        self.we=platform.request("we")
        self.link_ready=platform.request("link_ready")
        zeros=Signal(24) #completes the remaining 24 bits 
        
        tx=TX()
        tx=ClockDomainsRenamer("tx")(tx)
        fifo=AsyncFIFOBuffered(width=32,depth=32)
        fifo=ClockDomainsRenamer({"read":"tx"})(fifo)
        self.submodules+=[fifo,tx]

        self.txdata=Signal(40) #salida de tx
        self.tx_k=Signal() 

        self.comb+=[
            fifo.din.eq(Cat(self.din.a,self.din.b,self.din.c,
                self.din.d,self.din.e,self.din.f,self.din.g,self.din.h,zeros)),
            fifo.dtin.eq(Cat(self.dtin.a, self.dtin.b)),
            fifo.we.eq(self.we),
            If(~fifo.fifo.readable,
                fifo.re.eq(0)
            ).Else(fifo.re.eq(tx.fifo_re)),
            tx.link_ready.eq(self.link_ready),
            tx.fifo_empty.eq(~fifo.fifo.readable),
            #tx.reset.eq(self.re),
            tx.tx_init_done.eq(gtp.tx_init_done),
            tx.pll_lock.eq(gtp.pll_lock),
            If((self.link_ready & fifo.fifo.readable), 
                tx.data_in.eq(fifo.fifo.dout),   
               
            ),  
            If((self.link_ready & fifo.fifo.readable), 
                tx.data_type_in.eq(fifo.fifo.dtout),
            ),
            gtp.tx_data.eq(tx.data_out)
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
always #1.25 write_clk = ~write_clk;

reg gtp_clk;
initial gtp_clk = 1'b1;
always #2.08333 gtp_clk = ~gtp_clk;

integer period =10;

reg[7:0] value;
initial value='b0;    
reg[1:0] type;
initial type=2'b0;    
reg link_ready;
initial link_ready=0;
reg we;
initial we=0;
wire gtp_p;
wire gtp_n;

top dut (
    .gtp_tx_p(gtp_p),
    .gtp_tx_n(gtp_n),
    .write_clk_p(write_clk),
    .write_clk_n(~write_clk),
    .gtp_clk_p(gtp_clk),
    .gtp_clk_n(~gtp_clk),
    .din_a(value[0]),
    .din_b(value[1]),
    .din_c(value[2]),
    .din_d(value[3]),
    .din_e(value[4]),
    .din_f(value[5]),
    .din_g(value[6]),
    .din_h(value[7]),
    .dtin_a(type[0]),
    .dtin_b(type[1]),
    .we(we),
    .link_ready(link_ready)
);

always begin 
    for (integer i=0;i<=2500;i=i+1) begin
        #period;
        
    end
    
    we=1'b1;
    #period;    

    type=2'b01;
    value=8'hAA;
    we=1'b1;
    #period;

    type=2'b00;
    value='h1A;
    we=1'b1;
    #period;

    type=2'b00;
    value='h1B;
    we=1'b1;
    #period;

    type=2'b00;
    value='h1C;
    we=1'b1;
    #period;

    type=2'b00;
    value='h1D;
    we=1'b1;
    #period;

    type=2'b00;
    value='h1F;
    we=1'b1;
    #period;

    type=2'b00;
    value='h2A;
    we=1'b1;
    #period;

    type=2'b00;
    value='h2B;
    we=1'b1;
    #period;


    type=2'b10;
    value='h2C;
    we=1'b1;
    #period;

    
    for (integer i=0;i<=500;i=i+1) begin
        we=1'b0;
        link_ready=1'b1;
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
