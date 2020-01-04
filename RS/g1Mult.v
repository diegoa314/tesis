/* Machine-generated using Migen */
module top(

);

reg [3:0] x = 4'd0;
reg [3:0] y;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on


// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	y <= 4'd0;
	y[0] <= x[0];
	y[1] <= x[1];
	y[2] <= x[2];
	y[3] <= x[3];
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end

endmodule
