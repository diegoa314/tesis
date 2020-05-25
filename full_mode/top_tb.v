
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
    .gtp_rx_p(gtp_p),
    .gtp_rx_n(gtp_n),
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
endmodule