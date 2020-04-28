"""

"""

import os
import sys
from migen import *
from migen.genlib.io import CRG

from gtp_wo_enc import GTPQuadPLL, GTP
from daphne_platforms import Platform

class FullModeSim(Module):
    def __init__(self, platform):
       
        #   #   #
        write_clk = Signal()
        write_clk100 = Signal()
        write_clk100_pads = platform.request("clk0")
        self.specials += [
            Instance("IBUFDS_GTE2",
                i_CEB=0,
                i_I=write_clk100_pads.clk_p,
                i_IB=write_clk100_pads.clk_n,
                o_O=write_clk100),
            Instance("BUFG", i_I=write_clk100, o_O=write_clk)
        ]
        self.clock_domains.cd_write=ClockDomain(name="write")
        self.comb += [
            self.cd_write.clk.eq(write_clk),
        ]        

        sys_clk = Signal()
        self.submodules.crg = CRG(sys_clk)
        refclk625_platform = Signal()
        sys_clk_freq=62.5e6
        clk62_5=Signal()
        clk62_5 = platform.request("clk62_5")
        self.specials+=[
            Instance("BUFG", i_I=clk62_5, o_O=sys_clk)
        ]    

        gtp_refclk=Signal()
        gtp_refclk=platform.request("gtp_refclk")

        self.comb+=[gtp_refclk.p.eq(sys_clk), gtp_refclk.n.eq(~sys_clk)]

        refclk = Signal()
        pll_fb = Signal()
        self.specials += [
            Instance("PLLE2_BASE",
                     p_STARTUP_WAIT="FALSE", #o_LOCKED=,

                     # VCO @ 1.5 GHz
                     p_REF_JITTER1=0.01, p_CLKIN1_PERIOD=16.0,
                     p_CLKFBOUT_MULT=24, p_DIVCLK_DIVIDE=1,
                     i_CLKIN1=sys_clk, i_CLKFBIN=pll_fb, o_CLKFBOUT=pll_fb,

                     # 
                     p_CLKOUT0_DIVIDE=5, p_CLKOUT0_PHASE=0.0, o_CLKOUT0=refclk
            ),
        ]
            
        qpll = GTPQuadPLL(refclk, 300e6, 4.8e9)
        print(qpll)
        self.submodules += qpll

        tx_pads = platform.request("gtp_tx")
        rx_pads = platform.request("gtp_rx")
        gtp = GTP(qpll, tx_pads, rx_pads, sys_clk_freq)
        self.submodules += gtp

        self.din=Signal(8)
        self.dtin=Signal(2)
        self.writable=Signal()
        self.we=Signal()
        self.re=Signal()
        self.link_ready=Signal()

        self.din=platform.request("din")
        self.dtin=platform.request("dtin")
        self.we=platform.request("we")
        self.link_ready=platform.request("link_ready")
        zeros=Signal(24)
        
        self.comb+=[
            gtp.we.eq(self.we),
            gtp.link_ready.eq(self.link_ready),
            gtp.din.eq(Cat(self.din.a,self.din.b,self.din.c,
                self.din.d,self.din.e,self.din.f,self.din.g,self.din.h,zeros)),
            gtp.dtin.eq(Cat(self.dtin.a, self.dtin.b)),
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

reg clk0;
initial clk0 = 1'b1;
always #5 clk0 = ~clk0;

reg clk62_5;
initial clk62_5 = 1'b1;
always #8 clk62_5 = ~clk62_5;

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
    .gtp_rx_p(gtp_p),
    .gtp_rx_n(gtp_n),
    .clk0_clk_p(clk0),
    .clk0_clk_n(~clk0),
    .clk62_5(clk62_5),
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
