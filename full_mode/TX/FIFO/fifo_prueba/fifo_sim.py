
import os
import sys
from migen import *
from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform

from migen.genlib.io import CRG

sys.path.append("/home/diegoaranda/Documents/Tesis/FIFO")
from asyncfifo import AsyncFIFO


_io = [                             #generic_platform
    ("write_clk", 0,
        Subsignal("p", Pins("X")),
        Subsignal("n", Pins("X"))
    ),
    ("din",0, 
        Subsignal("a", Pins("X")),
        Subsignal("b", Pins("X")),
        Subsignal("c", Pins("X")),
        Subsignal("d", Pins("X"))
    ),
    ("readable",0, Pins("X")),
    ("writable",0, Pins("X")),
    ("re",0, Pins("X")),
    ("we",0, Pins("X"))
   
]


class Platform(XilinxPlatform):
    def __init__(self):
        XilinxPlatform.__init__(self, "", _io)


class GTPSim(Module):
    def __init__(self, platform):
        write_clk = Signal()
        read_clk=Signal()

        self.submodules.crg = CRG(write_clk)
        
        
        write_clk100 = Signal()
        write_clk100_pads = platform.request("write_clk")
        self.specials += [
            Instance("IBUFDS_GTE2",
                i_CEB=0,
                i_I=write_clk100_pads.p,
                i_IB=write_clk100_pads.n,
                o_O=write_clk100),
            Instance("BUFG", i_I=write_clk100, o_O=write_clk)
        ]
        
       
        pll_fb = Signal()
        self.specials += [
            Instance("PLLE2_BASE",
                     p_STARTUP_WAIT="FALSE", #o_LOCKED=,

                     # VCO @ 1GHz
                     p_REF_JITTER1=0.01, p_CLKIN1_PERIOD=10.0,
                     p_CLKFBOUT_MULT=10, p_DIVCLK_DIVIDE=1,
                     i_CLKIN1=write_clk, i_CLKFBIN=pll_fb, o_CLKFBOUT=pll_fb,

                     # 200MHz
                     p_CLKOUT0_DIVIDE=5, p_CLKOUT0_PHASE=0.0, o_CLKOUT0=read_clk
            ),
        ]
        
        async_fifo=AsyncFIFO(width=8, depth=8)
        self.submodules+=async_fifo
        self.din=Signal(4)
        self.writable=Signal()
        self.readable=Signal()
        self.we=Signal()
        self.re=Signal()
        
        self.din=platform.request("din")
        self.writable=platform.request("writable")
        self.readable=platform.request("readable")
        self.we=platform.request("we")
        self.re=platform.request("re")
        

        async_fifo=ClockDomainsRenamer({"write": "sys", 
            "read":"user_domain"})(async_fifo)

        self.clock_domains.cd_read=ClockDomain(name="user_domain")
        self.clock_domains.cd_read_por = ClockDomain(reset_less=True)
        

        int_read_rst = Signal(reset=1)
        self.sync.read_por += int_read_rst.eq(0)
        self.comb += [
            self.cd_read.clk.eq(read_clk),
            self.cd_read.rst.eq(int_read_rst),
            self.cd_read_por.clk.eq(read_clk),
        ]

        self.comb+=[
            async_fifo.din.eq(Cat(self.din.a,self.din.b,self.din.c,self.din.d,)),
            self.readable.eq(async_fifo.readable),
            self.writable.eq(async_fifo.writable),
            async_fifo.re.eq(self.re),
            async_fifo.we.eq(self.we)
           
        ]


        

       
def generate_top():
    platform = Platform()
    soc = GTPSim(platform)
    platform.build(soc, build_dir="./", run=False)

def generate_top_tb():
    f = open("top_tb.v", "w")
    f.write("""
`timescale 1ns/1ps

module top_tb();

reg write_clk;
initial write_clk = 1'b1;
always #5 write_clk = ~write_clk;

reg[3:0] counter;
initial counter=4'b0;    

reg din_a, din_b, din_c, din_d;

reg we, re;
initial we=0;
initial re=0;

wire writable;

top dut (
    .write_clk_p(write_clk),
    .write_clk_n(~write_clk),
    .din_a(din_a),
    .din_b(din_b),
    .din_c(din_c),
    .din_d(din_d),
    .we(we),
    .writable(writable),
    .re(re)
);
reg bandera;
initial bandera=0;
initial begin
    for (integer i=0;i<=37;i=i+1) begin
        #10;
    end
    bandera=1;
end

always @(posedge write_clk)
begin 
    if (bandera) begin    
        if(writable && counter<=7) begin
            counter=counter+1;
            we=1;
            re=0;
            din_a=counter[0];
            din_b=counter[1];
            din_c=counter[2];
            din_d=counter[3];
        end else begin
            we=0;
            re=1;
        end
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
