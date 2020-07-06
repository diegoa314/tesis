
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
    for (integer i=0;i<=1500;i=i+1) begin
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
    for (integer i=0;i<=5000;i=i+1) begin
        #period;
    end

    //Reset
    reset=1'b1;
    #period;
    #period;
    #period;
    reset=1'b0;
    while(!rxinit_done) begin
        #period;
    end
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
endmodule