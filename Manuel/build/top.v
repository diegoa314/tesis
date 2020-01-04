//--------------------------------------------------------------------------------
// Auto-generated by Migen (--------) & LiteX (690de79) on 2020-01-04 13:06:50
//--------------------------------------------------------------------------------
module top(
	output user_led,
	output user_led_1,
	output user_led_2,
	output user_led_3,
	output user_led_4,
	output user_led_5,
	output user_led_6,
	output user_led_7,
	(* dont_touch = "true" *)	input clk100
);

reg [24:0] __main___counter = 25'd0;
reg [7:0] __main___scount = 8'd0;
wire sys_clk;
wire sys_rst;
wire por_clk;
reg platform_int_rst = 1'd1;

assign user_led = __main___scount[0];
assign user_led_1 = __main___scount[1];
assign user_led_2 = __main___scount[2];
assign user_led_3 = __main___scount[3];
assign user_led_4 = __main___scount[4];
assign user_led_5 = __main___scount[5];
assign user_led_6 = __main___scount[6];
assign user_led_7 = __main___scount[7];
assign sys_clk = clk100;
assign por_clk = clk100;
assign sys_rst = platform_int_rst;

always @(posedge por_clk) begin
	platform_int_rst <= 1'd0;
end

always @(posedge sys_clk) begin
	if ((__main___counter == 1'd0)) begin
		__main___counter <= 25'd33554431;
		__main___scount <= (__main___scount + 1'd1);
	end else begin
		__main___counter <= (__main___counter - 1'd1);
	end
	if (sys_rst) begin
		__main___counter <= 25'd0;
		__main___scount <= 8'd0;
	end
end

endmodule
