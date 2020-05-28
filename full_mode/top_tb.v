
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

top dut (
    .gtp_tx_p(gtp_p),
    .gtp_tx_n(gtp_n),
    .write_clk_p(write_clk),
    .write_clk_n(~write_clk),
    .gtp_clk_p(gtp_clk),
    .gtp_clk_n(~gtp_clk),
    .we(we),
    .link_ready(link_ready),
    
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
    for (integer i=0;i<=2800;i=i+1) begin
        #period;
    end
    
    /*Se habilita la transmision, como no hay nada en el fifo
    enviara idle */
    link_ready=1'b1; 

    for (integer i=0;i<=1500;i=i+1) begin
        #period;
    end
    
     
    //ahora se escriben palabras y empieza a enviar 

    type=2'b01;
    value='h12345678;
    we=1'b1;
    #period;

    type=2'b00;
    value='hAAAAAAAA;
    we=1'b1;
    #period;

    type=2'b00;
    value='hBBBBBBBB;
    we=1'b1;
    #period;

    type=2'b00;
    value='hCCCCCCCC;
    we=1'b1;
    #period;

    type=2'b00;
    value='hDDDDDDDD;
    we=1'b1;
    #period;

    type=2'b00;
    value='hEEEEEEEE;
    we=1'b1;
    #period;


    type=2'b00;
    value='hFFFFFFFF;
    we=1'b1;
    #period;

    type=2'b10;
    value='hFAAAAAAC;
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
    value='hAAAAAAAA;
    we=1'b1;
    #period;

    type=2'b00;
    value='hBBBBBBBB;
    we=1'b1;
    #period;

    type=2'b00;
    value='hCCCCCCCC;
    we=1'b1;
    #period;

    type=2'b00;
    value='hDDDDDDDD;
    we=1'b1;
    #period;

    type=2'b00;
    value='hEEEEEEEE;
    we=1'b1;
    #period;


    type=2'b00;
    value='hFFFFFFFF;
    we=1'b1;
    #period;

    type=2'b10;
    value='hFAAAAAAC;
    we=1'b1;
    #period;
    we=1'b0;
  
    we=1'b0;
    #period;


    

end
endmodule