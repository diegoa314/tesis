/* Machine-generated using Migen */
module top(
	input [39:0] din,
	input aligned,
	output reg [39:0] dout,
	output reg correction_done,
	input sys_clk,
	input sys_rst
);

reg [19:0] first_half = 20'd0;
reg [1:0] state = 2'd0;
reg [1:0] next_state;
reg [19:0] first_half_next_value0;
reg first_half_next_value_ce0;
reg correction_done_next_value1;
reg correction_done_next_value_ce1;
reg [39:0] dout_next_value2;
reg dout_next_value_ce2;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on


// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	next_state <= 2'd0;
	first_half_next_value0 <= 20'd0;
	first_half_next_value_ce0 <= 1'd0;
	correction_done_next_value1 <= 1'd0;
	correction_done_next_value_ce1 <= 1'd0;
	dout_next_value2 <= 40'd0;
	dout_next_value_ce2 <= 1'd0;
	next_state <= state;
	case (state)
		1'd1: begin
			next_state <= 2'd2;
			first_half_next_value0 <= din[39:20];
			first_half_next_value_ce0 <= 1'd1;
			correction_done_next_value1 <= 1'd1;
			correction_done_next_value_ce1 <= 1'd1;
		end
		2'd2: begin
			dout_next_value2 <= {din[19:0], first_half};
			dout_next_value_ce2 <= 1'd1;
			first_half_next_value0 <= din[39:20];
			first_half_next_value_ce0 <= 1'd1;
			next_state <= 2'd2;
		end
		default: begin
			if (aligned) begin
				next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end

always @(posedge sys_clk) begin
	state <= next_state;
	if (first_half_next_value_ce0) begin
		first_half <= first_half_next_value0;
	end
	if (correction_done_next_value_ce1) begin
		correction_done <= correction_done_next_value1;
	end
	if (dout_next_value_ce2) begin
		dout <= dout_next_value2;
	end
	if (sys_rst) begin
		dout <= 40'd0;
		correction_done <= 1'd0;
		first_half <= 20'd0;
		state <= 2'd0;
	end
end

endmodule
