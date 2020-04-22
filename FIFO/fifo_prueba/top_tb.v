
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



endmodule