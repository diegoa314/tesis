/* Machine-generated using Migen */
module top(
	output reg [7:0] o,
	input enable,
	input sys_clk,
	input sys_rst
);

reg [6:0] state = 7'd1;


always @(posedge sys_clk) begin
	if (enable) begin
		state <= {(state[4] ^ state[5]), (state[3] ^ state[4]), (state[2] ^ state[3]), (state[1] ^ state[2]), (state[0] ^ state[1]), ((state[5] ^ state[6]) ^ state[0]), ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))};
		o <= {(state[5] ^ state[6]), (state[4] ^ state[5]), (state[3] ^ state[4]), (state[2] ^ state[3]), (state[1] ^ state[2]), (state[0] ^ state[1]), ((state[5] ^ state[6]) ^ state[0]), ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))};
	end
	if (sys_rst) begin
		o <= 8'd0;
		state <= 7'd1;
	end
end

endmodule
