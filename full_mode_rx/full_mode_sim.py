import os
import sys
from migen import *
from migen.genlib.io import CRG
from gtp import GTPQuadPLL, GTP
from daphne_platforms import Platform
from tx import TX
from rx import RX
from asyncfifoDT import AsyncFIFO
from alignment_corrector import Alignment_Corrector
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
        rx_pads = platform.request("gtp_rx")
     
        gtp = GTP(qpll, tx_pads, rx_pads, gtp_clk_freq)
        self.submodules += gtp

       
        self.din=platform.request("din")
        self.dtin=platform.request("dtin")
        self.we=platform.request("we")
        self.link_ready=platform.request("link_ready")
        
        tx=TX()
        tx=ClockDomainsRenamer("tx")(tx)
        rx=RX()
        rx=ClockDomainsRenamer("tx")(rx)
        fifo=AsyncFIFO(width=32,depth=32)
        fifo=ClockDomainsRenamer({"read":"tx"})(fifo)
        corrector=ClockDomainsRenamer("tx")(Alignment_Corrector())
        self.submodules+=[fifo,tx,corrector,rx]

        self.txdata=Signal(40) #salida de tx
        self.tx_k=Signal() 

        self.data_received=Signal(32)  
        self.rxinit_done=Signal()  
        self.rxinit_done=platform.request("rxinit_done")    
        self.comb+=[
            fifo.din.eq(Cat(
                self.din.a1,self.din.b1,self.din.c1,self.din.d1,
                self.din.e1,self.din.f1,self.din.g1,self.din.h1,
                self.din.a2,self.din.b2,self.din.c2,self.din.d2,
                self.din.e2,self.din.f2,self.din.g2,self.din.h2,
                self.din.a3,self.din.b3,self.din.c3,self.din.d3,
                self.din.e3,self.din.f3,self.din.g3,self.din.h3,
                self.din.a4,self.din.b4,self.din.c4,self.din.d4,
                self.din.e4,self.din.f4,self.din.g4,self.din.h4,
                )
            ),
            fifo.dtin.eq(Cat(self.dtin.a, self.dtin.b)),
            fifo.we.eq(self.we),
            fifo.re.eq(tx.fifo_re),
            tx.link_ready.eq(self.link_ready),
            tx.fifo_empty.eq(~fifo.readable),
            #tx.reset.eq(self.re),
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
            self.data_received.eq(rx.data_out),
            self.rxinit_done.eq(gtp.rxinit_done)
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
always #1.25 write_clk = ~write_clk; //1.25 es semiperiodo del clk de 400 MHz

reg gtp_clk;
initial gtp_clk = 1'b1;
always #2.08333 gtp_clk = ~gtp_clk; //2.08333 es semiperiodo del clk de 240 MHz

real period =2.5; //periodo de 400 MHz

reg[31:0] value;
initial value='b0;    
reg[1:0] type;
initial type=2'b0;    
reg link_ready;
initial link_ready=0;
reg we;
initial we=0;
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
    .rxinit_done(rxinit_done),
    
    .din_a1(value[0]),
    .din_b1(value[1]),
    .din_c1(value[2]),
    .din_d1(value[3]),
    .din_e1(value[4]),
    .din_f1(value[5]),
    .din_g1(value[6]),
    .din_h1(value[7]),
    
    .din_a2(value[8]),
    .din_b2(value[9]),
    .din_c2(value[10]),
    .din_d2(value[11]),
    .din_e2(value[12]),
    .din_f2(value[13]),
    .din_g2(value[14]),
    .din_h2(value[15]),
    
    .din_a3(value[16]),
    .din_b3(value[17]),
    .din_c3(value[18]),
    .din_d3(value[19]),
    .din_e3(value[20]),
    .din_f3(value[21]),
    .din_g3(value[22]),
    .din_h3(value[23]),
    
    .din_a4(value[24]),
    .din_b4(value[25]),
    .din_c4(value[26]),
    .din_d4(value[27]),
    .din_e4(value[28]),
    .din_f4(value[29]),
    .din_g4(value[30]),
    .din_h4(value[31]),
    
    .dtin_a(type[0]),
    .dtin_b(type[1])
    
);

//Se espera que se inicie el GTP
always begin 
    for (integer i=0;i<=4000;i=i+1) begin
        #period;
    end
    
    while(!rxinit_done) begin
        #period;
    end
    /*Se habilita la transmision, como no hay nada en el fifo
    enviara idle */
    link_ready=1'b1; 
    
    for (integer i=0;i<=300;i=i+1) begin
        #period;
    end
    

        //ahora se escriben palabras y empieza a enviar 

        type=2'b01;
        value='h12345678;
        we=1'b1;
        #period;

        type=2'b00;
        value='hA1A2A3A4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hB1B2B3B4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hC1C2C3C4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hD1D2D3D4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hE1E2E3E4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hF1F2F3F4;
        we=1'b1;
        #period;

        type=2'b10;
        value='hABCDEF12;
        we=1'b1;
        #period;
        we=1'b0;
      
        we=1'b0;
        #period;

        for (integer i=0;i<=1500;i=i+1) begin
            #period;
        end



        type=2'b01;
        value='h12345678;
        we=1'b1;
        #period;

        type=2'b00;
        value='hA1A2A3A4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hB1B2B3B4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hC1C2C3C4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hD1D2D3D4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hE1E2E3E4;
        we=1'b1;
        #period;

        type=2'b00;
        value='hF1F2F3F4;
        we=1'b1;
        #period;

        type=2'b10;
        value='hABCDEF12;
        we=1'b1;
        #period;
        we=1'b0;
      
        we=1'b0;
        #period;
  
     
    

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
