import os
import sys
from migen import *
from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform
from migen.genlib.io import CRG
from tx import *
from gtp_7series import *
sys.path.append('/home/diegoaranda/Documents/Tesis/FIFO')
from asyncfifoDT import AsyncFIFOBuffered 


_io = [                             #generic_platform
    ("gtp_tx", 0,
        Subsignal("p", Pins("X")),
        Subsignal("n", Pins("X"))
    ),
    ("write_clk", 0,
        Subsignal("p", Pins("X")),
        Subsignal("n", Pins("X"))
    ),
    ("write_clk", 0,
        Subsignal("p", Pins("X")),
        Subsignal("n", Pins("X"))
    ),
    ("din",0, 
        Subsignal("a", Pins("X")),
        Subsignal("b", Pins("X")),
        Subsignal("c", Pins("X")),
        Subsignal("d", Pins("X")),
        Subsignal("e", Pins("X")),
        Subsignal("f", Pins("X")),
        Subsignal("g", Pins("X")),
        Subsignal("h", Pins("X"))
    ),
    ("dtin",0, 
        Subsignal("a", Pins("X")),
        Subsignal("b", Pins("X"))
    ),
    ("writable",0, Pins("X")),
    ("re",0, Pins("X")),
    ("we",0, Pins("X")),
    
    ("link_ready",0, Pins("X"))
]

class Platform(XilinxPlatform):
    def __init__(self):
        XilinxPlatform.__init__(self, "", _io)


class FullModeSim(Module):
    def __init__(self, platform):
        self.din=Signal(8)
        self.dtin=Signal(2)
        self.writable=Signal()
        self.we=Signal()
        self.re=Signal()
        
        self.link_ready=Signal()
        #   #   #
        write_clk = Signal()
        self.submodules.crg = CRG(write_clk)
        write_clk100 = Signal()
        write_clk100_pads = platform.request("write_clk")
        self.din=platform.request("din")
        self.dtin=platform.request("dtin")
        self.writable=platform.request("writable")
        self.we=platform.request("we")
        self.re=platform.request("re")
     
        self.link_ready=platform.request("link_ready")
        
        self.specials += [
            Instance("IBUFDS_GTE2",
                i_CEB=0,
                i_I=write_clk100_pads.p,
                i_IB=write_clk100_pads.n,
                o_O=write_clk100),
            Instance("BUFG", i_I=write_clk100, o_O=write_clk)
        ]
        
        read_clk=Signal()
        pll_fb = Signal()
        self.specials += [
            Instance("PLLE2_BASE",
                     p_STARTUP_WAIT="FALSE", #o_LOCKED=,

                     
                     p_REF_JITTER1=0.01, p_CLKIN1_PERIOD=10,
                     p_CLKFBOUT_MULT=10, p_DIVCLK_DIVIDE=1,
                     i_CLKIN1=write_clk, i_CLKFBIN=pll_fb, o_CLKFBOUT=pll_fb,

                     # 200MHz
                     p_CLKOUT0_DIVIDE=5, p_CLKOUT0_PHASE=0.0, o_CLKOUT0=read_clk
            ),
        ]
        self.clock_domains.cd_tx=ClockDomain(name="tx")
        #self.clock_domains.cd_tx_por = ClockDomain(reset_less=True)
        
        #int_read_rst = Signal(reset=1)
        #self.sync.read_por += int_read_rst.eq(0)
        self.comb += [
            self.cd_tx.clk.eq(read_clk),
            #self.cd_tx.rst.eq(int_read_rst),
            #self.cd_tx_por.clk.eq(read_clk),
        ]

        tx=TX()
        tx=ClockDomainsRenamer("tx")(tx)
        fifo=AsyncFIFOBuffered(width=32,depth=32)
        fifo=ClockDomainsRenamer({"write": "sys", 
            "read":"tx"})(fifo)
        self.submodules+=[fifo,tx]
        
       
        relleno=Signal(24)
        self.comb+=[
            self.writable.eq(fifo.fifo.writable),

            fifo.din.eq(Cat(self.din.a,self.din.b,self.din.c,
                self.din.d,self.din.e,self.din.f,self.din.g,self.din.h,relleno)),
            fifo.dtin.eq(Cat(self.dtin.a, self.dtin.b)),
            fifo.we.eq(self.we),
            #fifo.re.eq(self.re),
            If(~fifo.fifo.readable,
                fifo.re.eq(0)
            ).Else(fifo.re.eq(tx.fifo_re)),
                
            
            tx.link_ready.eq(self.link_ready),
            

            tx.fifo_empty.eq(~fifo.fifo.readable),
            tx.reset.eq(self.re)    
        ]

        self.comb+=[
            If((self.link_ready & fifo.fifo.readable), 
                tx.data_in.eq(fifo.fifo.dout),   
               
            ),  
            If((self.link_ready & fifo.fifo.readable), 
                tx.data_type_in.eq(fifo.fifo.dtout),
            )    
        ]
        read_clk_freq=200e6       
        qpll = GTPQuadPLL(read_clk, read_clk_freq, 4.8e9)
      
        self.submodules += qpll


        tx_pads = platform.request("gtp_tx")
        gtp = GTP(qpll=qpll, tx_pads=tx_pads,
            sys_clk_freq=read_clk_freq , clock_aligner=True)
        self.submodules += gtp

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
always #5 write_clk = ~write_clk;

reg read_clk;
initial read_clk = 1'b1;
always #5 read_clk = ~read_clk;

integer period =10;

reg[7:0] value;
initial value='b0;    
reg[1:0] type;
initial type=2'b0;    



reg link_ready;
initial link_ready=0;
reg we, re;
initial we=0;
initial re=0;

wire gtp_p;
wire gtp_n;


wire writable;

top dut (
    .gtp_tx_p(gtp_p),
    .gtp_tx_n(gtp_n),

    .write_clk_p(write_clk),
    .write_clk_n(~write_clk),
    .read_clk_p(read_clk),
    .read_clk_n(~read_clk),
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
    .re(re),
    
    .writable(writable),
    .link_ready(link_ready)
);
reg bandera;
initial bandera=0;
initial begin
    
    
end



always begin 
    for (integer i=0;i<=37;i=i+1) begin
        #10;
        we=0;
        re=0;
    end
    for (integer i=0;i<=10;i=i+1) begin
        we=1'b0;
        link_ready=1'b1;
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

"""
type=2'b00;
    value=8'hDD;
    we=1'b1;
    #period;

    type=2'b00;
    value=8'hEE;
    we=1'b1;
    #period;

    type=2'b10;
    value=8'hFF;
    we=1'b1;
    #period;

    re=1'b1;
    #period;
    re=1'b0;
    #period;
    
"""