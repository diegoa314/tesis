/* Machine-generated using Migen */
module top(
	input sys_clk,
	input sys_rst
);

reg [3:0] encoder_data_in = 4'd0;
reg [3:0] encoder_data_output;
reg encoder_reset = 1'd0;
reg [3:0] encoder;
reg [3:0] encoder_reg0 = 4'd0;
reg [3:0] encoder_reg1 = 4'd0;
reg [3:0] encoder_reg2 = 4'd0;
reg [3:0] encoder_reg3 = 4'd0;
wire [3:0] encoder_u0_x;
reg [3:0] encoder_u0_y;
wire [3:0] encoder_u1_x;
reg [3:0] encoder_u1_y;
wire [3:0] encoder_u2_x;
reg [3:0] encoder_u2_y;
wire [3:0] encoder_u3_x;
reg [3:0] encoder_u3_y;
reg [3:0] encoder_counter = 4'd0;
reg [3:0] encoder_feedback;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on


// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	encoder <= 4'd0;
	encoder[0] <= encoder_u0_y;
	encoder[1] <= encoder_u1_y;
	encoder[2] <= encoder_u2_y;
	encoder[3] <= encoder_u3_y;
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	encoder_feedback <= 4'd0;
	if ((encoder_counter >= 4'd11)) begin
		encoder_feedback <= 1'd0;
	end else begin
		encoder_feedback <= (encoder_data_in ^ encoder_reg3);
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end
assign encoder_u0_x = encoder_feedback;
assign encoder_u1_x = encoder_feedback;
assign encoder_u2_x = encoder_feedback;
assign encoder_u3_x = encoder_feedback;

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	if (encoder_reset) begin
	end
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	encoder_data_output <= 4'd0;
	if ((encoder_counter < 4'd11)) begin
		encoder_data_output <= encoder_data_in;
	end else begin
		encoder_data_output <= encoder_reg3;
	end
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	encoder_u0_y <= 4'd0;
	encoder_u0_y[0] <= (encoder_u0_x[1] ^ encoder_u0_x[2]);
	encoder_u0_y[1] <= (encoder_u0_x[1] ^ encoder_u0_x[3]);
	encoder_u0_y[2] <= (encoder_u0_x[0] ^ encoder_u0_x[2]);
	encoder_u0_y[3] <= ((encoder_u0_x[0] ^ encoder_u0_x[1]) ^ encoder_u0_x[3]);
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	encoder_u1_y <= 4'd0;
	encoder_u1_y[0] <= encoder_u1_x[0];
	encoder_u1_y[1] <= encoder_u1_x[1];
	encoder_u1_y[2] <= encoder_u1_x[2];
	encoder_u1_y[3] <= encoder_u1_x[3];
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	encoder_u2_y <= 4'd0;
	encoder_u2_y[0] <= (encoder_u2_x[3] ^ encoder_u2_x[0]);
	encoder_u2_y[1] <= ((encoder_u2_x[3] ^ encoder_u2_x[1]) ^ encoder_u2_x[0]);
	encoder_u2_y[2] <= (encoder_u2_x[1] ^ encoder_u2_x[2]);
	encoder_u2_y[3] <= (encoder_u2_x[2] ^ encoder_u2_x[3]);
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	encoder_u3_y <= 4'd0;
	encoder_u3_y[0] <= (((encoder_u3_x[0] ^ encoder_u3_x[1]) ^ encoder_u3_x[2]) ^ encoder_u3_x[3]);
	encoder_u3_y[1] <= encoder_u3_x[0];
	encoder_u3_y[2] <= (encoder_u3_x[0] ^ encoder_u3_x[1]);
	encoder_u3_y[3] <= ((encoder_u3_x[0] ^ encoder_u3_x[1]) ^ encoder_u3_x[2]);
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end

always @(posedge sys_clk) begin
	if (encoder_reset) begin
		encoder_counter <= 1'd0;
	end else begin
		encoder_counter <= (encoder_counter + 1'd1);
	end
	if ((~encoder_reset)) begin
		encoder_reg0 <= encoder_u0_y;
		encoder_reg1 <= (encoder_u1_y ^ encoder_reg0);
		encoder_reg2 <= (encoder_u2_y ^ encoder_reg1);
		encoder_reg3 <= (encoder_u3_y ^ encoder_reg2);
	end
	if (sys_rst) begin
		encoder_reg0 <= 4'd0;
		encoder_reg1 <= 4'd0;
		encoder_reg2 <= 4'd0;
		encoder_reg3 <= 4'd0;
		encoder_counter <= 4'd0;
	end
end

endmodule
