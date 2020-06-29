
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
reg trans_en;
initial we='b0;
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
    .rxinit_done(rxinit_done)
   
    
);

//Se espera que se inicie el GTP
always begin 
    for (integer i=0;i<=400;i=i+1) begin
        #period;
    end
    
    while(!rxinit_done) begin
        #period;
    end
    /*Se habilita la transmision, como no hay nada en el fifo
    enviara idle */
    link_ready=1'b1; 
    
    for (integer i=0;i<=100;i=i+1) begin
        #period;
    end
    
    //ahora se escriben palabras y empieza a enviar 
    we=1'b1;
    for (integer i=0;i<=200;i=i+1) begin
        #period;
    end

    for (integer i=0;i<=1000;i=i+1) begin
        trans_en=1'b1;
        #period;
    end
    we=1'b0;
    for (integer i=0;i<=10;i=i+1) begin
        #period;
    end
    we=1'b1;
    for (integer i=0;i<=1000;i=i+1) begin
        #period;
    end
end
endmodule