//--------------------------------------------------------------------------------
// Auto-generated by Migen (--------) & LiteX (690de79) on 2020-01-11 18:18:32
//--------------------------------------------------------------------------------
module top(
	output serial_tx,
	input serial_rx,
	input user_btn,
	(* dont_touch = "true" *)	input clk12
);

wire __main___fsm_v2_tx_10bdone;
wire __main___fsm_v2_trans_en;
wire __main___fsm_v2_fifo_empty;
wire __main___fsm_v2_fifo_full;
reg __main___fsm_v2_prbs_en = 1'd0;
reg __main___fsm_v2_encoder_ready = 1'd0;
reg __main___fsm_v2_change_disp = 1'd0;
reg __main___fsm_v2_tx_en = 1'd0;
reg __main___fsm_v2_fifo_we = 1'd0;
reg __main___fsm_v2_fifo_re = 1'd0;
reg [2:0] __main___fsm_v2_write_cnt = 3'd0;
wire [7:0] __main___encoder_data_in;
wire __main___encoder_k;
reg [9:0] __main___encoder_data_out = 10'd0;
reg __main___encoder_disp_in = 1'd0;
wire __main___encoder_disp_out;
reg [8:0] __main___encoder0 = 9'd0;
reg [6:0] __main___encoder1 = 7'd0;
reg [5:0] __main___encoder2 = 6'd0;
reg [3:0] __main___encoder3 = 4'd0;
reg [5:0] __main___encoder4 = 6'd0;
reg [3:0] __main___encoder5 = 4'd0;
wire __main___encoder_illegalk;
wire __main___encoder_compls6;
reg [1:0] __main___encoder6 = 2'd0;
reg [9:0] __main___transmitter_data_in = 10'd0;
wire __main___transmitter_trans_en;
wire __main___transmitter_tx_serial0;
reg __main___transmitter_tx_10bdone = 1'd0;
reg [10:0] __main___transmitter_tx_counter = 11'd0;
reg __main___transmitter_tx_serial1 = 1'd1;
reg [7:0] __main___transmitter_tx_data = 8'd0;
wire __main___transmitter_tx_strobe;
reg [2:0] __main___transmitter_tx_bitn = 3'd0;
reg __main___transmitter_tx_ready = 1'd0;
reg [7:0] __main___transmitter_tx_latch = 8'd0;
reg __main___transmitter_tx_done = 1'd0;
reg [7:0] __main___o = 8'd0;
reg [23:0] __main___prueba = 24'd0;
wire __main___enable;
reg [23:0] __main___state = 24'd1;
wire __main___re;
reg __main___readable = 1'd0;
wire __main___syncfifo_we;
wire __main___syncfifo_writable;
wire __main___syncfifo_re;
wire __main___syncfifo_readable;
wire [7:0] __main___syncfifo_din;
wire [7:0] __main___syncfifo_dout;
reg [5:0] __main___level0 = 6'd0;
reg __main___replace = 1'd0;
reg [4:0] __main___produce = 5'd0;
reg [4:0] __main___consume = 5'd0;
reg [4:0] __main___wrport_adr = 5'd0;
wire [7:0] __main___wrport_dat_r;
wire __main___wrport_we;
wire [7:0] __main___wrport_dat_w;
wire __main___do_read;
wire [4:0] __main___rdport_adr;
wire [7:0] __main___rdport_dat_r;
wire __main___rdport_re;
wire [5:0] __main___level1;
reg [1:0] platform_fsm_state = 2'd0;
reg [1:0] platform_fsm_next_state = 2'd0;
reg __main___transmitter_tx_ready_transmitter10b_next_value0 = 1'd0;
reg __main___transmitter_tx_ready_transmitter10b_next_value_ce0 = 1'd0;
reg [7:0] __main___transmitter_tx_data_transmitter10b_next_value1 = 8'd0;
reg __main___transmitter_tx_data_transmitter10b_next_value_ce1 = 1'd0;
reg __main___transmitter_tx_10bdone_transmitter10b_next_value2 = 1'd0;
reg __main___transmitter_tx_10bdone_transmitter10b_next_value_ce2 = 1'd0;
reg [1:0] platform_tx_state = 2'd0;
reg [1:0] platform_tx_next_state = 2'd0;
reg [7:0] __main___transmitter_tx_latch_transmitter10b_t_next_value0 = 8'd0;
reg __main___transmitter_tx_latch_transmitter10b_t_next_value_ce0 = 1'd0;
reg [10:0] __main___transmitter_tx_counter_transmitter10b_t_next_value1 = 11'd0;
reg __main___transmitter_tx_counter_transmitter10b_t_next_value_ce1 = 1'd0;
reg __main___transmitter_tx_serial1_transmitter10b_f_next_value = 1'd0;
reg __main___transmitter_tx_serial1_transmitter10b_f_next_value_ce = 1'd0;
reg [2:0] __main___transmitter_tx_bitn_transmitter10b_t_next_value2 = 3'd0;
reg __main___transmitter_tx_bitn_transmitter10b_t_next_value_ce2 = 1'd0;
reg __main___transmitter_tx_done_transmitter10b_t_next_value3 = 1'd0;
reg __main___transmitter_tx_done_transmitter10b_t_next_value_ce3 = 1'd0;
reg [2:0] platform_state = 3'd0;
reg [2:0] platform_next_state = 3'd0;
reg __main___fsm_v2_fifo_re_fsm_v2_t_next_value = 1'd0;
reg __main___fsm_v2_fifo_re_fsm_v2_t_next_value_ce = 1'd0;
reg __main___fsm_v2_prbs_en_fsm_v2_f_next_value = 1'd0;
reg __main___fsm_v2_prbs_en_fsm_v2_f_next_value_ce = 1'd0;
reg __main___fsm_v2_change_disp_fsm_v2_next_value0 = 1'd0;
reg __main___fsm_v2_change_disp_fsm_v2_next_value_ce0 = 1'd0;
reg __main___fsm_v2_fifo_we_fsm_v2_next_value1 = 1'd0;
reg __main___fsm_v2_fifo_we_fsm_v2_next_value_ce1 = 1'd0;
reg [2:0] __main___fsm_v2_write_cnt_fsm_v2_next_value2 = 3'd0;
reg __main___fsm_v2_write_cnt_fsm_v2_next_value_ce2 = 1'd0;
reg __main___fsm_v2_encoder_ready_fsm_v2_next_value3 = 1'd0;
reg __main___fsm_v2_encoder_ready_fsm_v2_next_value_ce3 = 1'd0;
reg __main___fsm_v2_tx_en_fsm_v2_next_value4 = 1'd0;
reg __main___fsm_v2_tx_en_fsm_v2_next_value_ce4 = 1'd0;
wire sys_clk;
wire sys_rst;
wire por_clk;
reg platform_int_rst = 1'd1;

assign __main___fsm_v2_tx_10bdone = __main___transmitter_tx_10bdone;
assign __main___fsm_v2_trans_en = user_btn;
assign __main___fsm_v2_fifo_empty = (~__main___readable);
assign __main___fsm_v2_fifo_full = (~__main___syncfifo_writable);
assign __main___transmitter_trans_en = __main___fsm_v2_tx_en;
assign __main___enable = __main___fsm_v2_prbs_en;
assign __main___syncfifo_we = __main___fsm_v2_fifo_we;
assign __main___re = __main___fsm_v2_fifo_re;
assign serial_tx = __main___transmitter_tx_serial0;
assign __main___syncfifo_din = __main___o;
assign __main___encoder_data_in = __main___syncfifo_dout;
always @(*) begin
	__main___transmitter_data_in <= 10'd0;
	if (__main___fsm_v2_encoder_ready) begin
		__main___transmitter_data_in <= __main___encoder_data_out;
	end
end
assign __main___encoder_k = 1'd0;
always @(*) begin
	__main___encoder0 <= 9'd0;
	__main___encoder0[0] <= __main___encoder_data_in[0];
	__main___encoder0[1] <= __main___encoder_data_in[1];
	__main___encoder0[2] <= __main___encoder_data_in[2];
	__main___encoder0[3] <= __main___encoder_data_in[3];
	__main___encoder0[4] <= __main___encoder_data_in[4];
	__main___encoder0[5] <= __main___encoder_data_in[5];
	__main___encoder0[6] <= __main___encoder_data_in[6];
	__main___encoder0[7] <= __main___encoder_data_in[7];
	__main___encoder0[8] <= __main___encoder_k;
end
always @(*) begin
	__main___encoder1 <= 7'd0;
	__main___encoder1[0] <= ((__main___encoder0[0] & __main___encoder0[1]) | ((~__main___encoder0[0]) & (~__main___encoder0[1])));
	__main___encoder1[1] <= ((__main___encoder0[2] & __main___encoder0[3]) | ((~__main___encoder0[2]) & (~__main___encoder0[3])));
	__main___encoder1[2] <= (((((__main___encoder0[0] & __main___encoder0[1]) & (~__main___encoder0[2])) & (~__main___encoder0[3])) | (((__main___encoder0[2] & __main___encoder0[3]) & (~__main___encoder0[0])) & (~__main___encoder0[1]))) | ((~__main___encoder1[0]) & (~__main___encoder1[1])));
	__main___encoder1[3] <= (((__main___encoder0[0] & __main___encoder0[1]) & __main___encoder0[2]) & __main___encoder0[3]);
	__main___encoder1[4] <= ((((~__main___encoder0[0]) & (~__main___encoder0[1])) & (~__main___encoder0[2])) & (~__main___encoder0[3]));
	__main___encoder1[5] <= ((((~__main___encoder1[0]) & (~__main___encoder0[2])) & (~__main___encoder0[3])) | (((~__main___encoder1[1]) & (~__main___encoder0[0])) & (~__main___encoder0[1])));
	__main___encoder1[6] <= ((((~__main___encoder1[0]) & __main___encoder0[2]) & __main___encoder0[3]) | (((~__main___encoder1[1]) & __main___encoder0[0]) & __main___encoder0[1]));
end
always @(*) begin
	__main___encoder2 <= 6'd0;
	__main___encoder2[0] <= __main___encoder0[0];
	__main___encoder2[1] <= ((__main___encoder0[1] & (~__main___encoder1[3])) | __main___encoder1[4]);
	__main___encoder2[2] <= ((__main___encoder1[4] | __main___encoder0[2]) | ((((__main___encoder0[4] & __main___encoder0[3]) & (~__main___encoder0[2])) & (~__main___encoder0[1])) & (~__main___encoder0[0])));
	__main___encoder2[3] <= (__main___encoder0[3] & (~((__main___encoder0[0] & __main___encoder0[1]) & __main___encoder0[2])));
	__main___encoder2[4] <= ((__main___encoder0[4] | __main___encoder1[5]) & (~((((__main___encoder0[4] & __main___encoder0[3]) & (~__main___encoder0[2])) & (~__main___encoder0[1])) & (~__main___encoder0[0]))));
	__main___encoder2[5] <= (((((__main___encoder1[2] & (~__main___encoder0[4])) | (((__main___encoder0[4] & (~__main___encoder0[3])) & (~__main___encoder0[2])) & (~(__main___encoder0[0] & __main___encoder0[1])))) | (__main___encoder0[4] & __main___encoder1[3])) | (((((__main___encoder0[8] & __main___encoder0[4]) & __main___encoder0[3]) & __main___encoder0[2]) & (~__main___encoder0[1])) & (~__main___encoder0[0]))) | ((((__main___encoder0[4] & (~__main___encoder0[3])) & __main___encoder0[2]) & (~__main___encoder0[1])) & (~__main___encoder0[0])));
end
always @(*) begin
	__main___encoder3 <= 4'd0;
	__main___encoder3[0] <= (((((__main___encoder0[4] & __main___encoder0[3]) & (~__main___encoder0[2])) & (~__main___encoder0[1])) & (~__main___encoder0[0])) | (((~__main___encoder0[4]) & (~__main___encoder1[2])) & (~__main___encoder1[6])));
	__main___encoder3[1] <= ((__main___encoder0[8] | ((__main___encoder0[4] & (~__main___encoder1[2])) & (~__main___encoder1[5]))) | (((((~__main___encoder0[4]) & (~__main___encoder0[3])) & __main___encoder0[2]) & __main___encoder0[1]) & __main___encoder0[0]));
	__main___encoder3[2] <= __main___encoder3[0];
	__main___encoder3[3] <= (__main___encoder0[8] | ((__main___encoder0[4] & (~__main___encoder1[2])) & (~__main___encoder1[5])));
end
always @(*) begin
	__main___encoder4 <= 6'd0;
	if (__main___encoder_disp_in) begin
		__main___encoder4[5] <= (((~__main___encoder0[4]) & __main___encoder0[3]) & __main___encoder1[6]);
	end else begin
		__main___encoder4[5] <= ((__main___encoder0[4] & (~__main___encoder0[3])) & __main___encoder1[5]);
	end
	__main___encoder4[0] <= (((__main___encoder0[5] & __main___encoder0[6]) & __main___encoder0[7]) & (__main___encoder0[8] | __main___encoder4[5]));
	__main___encoder4[1] <= (__main___encoder0[5] & (~__main___encoder4[0]));
	__main___encoder4[2] <= (__main___encoder0[6] | (((~__main___encoder0[5]) & (~__main___encoder0[6])) & (~__main___encoder0[7])));
	__main___encoder4[3] <= __main___encoder0[7];
	__main___encoder4[4] <= (((~__main___encoder0[7]) & (__main___encoder0[6] ^ __main___encoder0[5])) | __main___encoder4[0]);
end
always @(*) begin
	__main___encoder5 <= 4'd0;
	__main___encoder5[0] <= (__main___encoder0[5] & __main___encoder0[6]);
	__main___encoder5[1] <= (((~__main___encoder0[5]) & (~__main___encoder0[6])) | (__main___encoder0[8] & ((__main___encoder0[5] & (~__main___encoder0[6])) | ((~__main___encoder0[5]) & __main___encoder0[6]))));
	__main___encoder5[2] <= ((~__main___encoder0[5]) & (~__main___encoder0[6]));
	__main___encoder5[3] <= ((__main___encoder0[5] & __main___encoder0[6]) & __main___encoder0[7]);
end
assign __main___encoder_illegalk = ((__main___encoder0[8] & ((((__main___encoder0[0] | __main___encoder0[1]) | (~__main___encoder0[2])) | (~__main___encoder0[3])) | (~__main___encoder0[4]))) & (((((~__main___encoder0[5]) | (~__main___encoder0[6])) | (~__main___encoder0[7])) | (~__main___encoder0[4])) | (~__main___encoder1[6])));
assign __main___encoder_compls6 = ((__main___encoder3[0] & (~__main___encoder_disp_in)) | (__main___encoder3[1] & __main___encoder_disp_in));
always @(*) begin
	__main___encoder6 <= 2'd0;
	__main___encoder6[0] <= (__main___encoder_disp_in ^ (__main___encoder3[2] | __main___encoder3[3]));
	__main___encoder6[1] <= ((__main___encoder5[1] & (~__main___encoder6[0])) | (__main___encoder5[0] & __main___encoder6[0]));
end
assign __main___encoder_disp_out = (__main___encoder6[0] ^ (__main___encoder5[2] | __main___encoder5[3]));
always @(*) begin
	__main___encoder_data_out <= 10'd0;
	__main___encoder_data_out[0] <= (__main___encoder4[4] ^ __main___encoder6[1]);
	__main___encoder_data_out[1] <= (__main___encoder4[3] ^ __main___encoder6[1]);
	__main___encoder_data_out[2] <= (__main___encoder4[2] ^ __main___encoder6[1]);
	__main___encoder_data_out[3] <= (__main___encoder4[1] ^ __main___encoder6[1]);
	__main___encoder_data_out[4] <= (__main___encoder2[5] ^ __main___encoder_compls6);
	__main___encoder_data_out[5] <= (__main___encoder2[4] ^ __main___encoder_compls6);
	__main___encoder_data_out[6] <= (__main___encoder2[3] ^ __main___encoder_compls6);
	__main___encoder_data_out[7] <= (__main___encoder2[2] ^ __main___encoder_compls6);
	__main___encoder_data_out[8] <= (__main___encoder2[1] ^ __main___encoder_compls6);
	__main___encoder_data_out[9] <= (__main___encoder2[0] ^ __main___encoder_compls6);
end
assign __main___transmitter_tx_serial0 = __main___transmitter_tx_serial1;
always @(*) begin
	__main___transmitter_tx_10bdone_transmitter10b_next_value2 <= 1'd0;
	__main___transmitter_tx_10bdone_transmitter10b_next_value_ce2 <= 1'd0;
	__main___transmitter_tx_ready_transmitter10b_next_value0 <= 1'd0;
	__main___transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd0;
	__main___transmitter_tx_data_transmitter10b_next_value1 <= 8'd0;
	__main___transmitter_tx_data_transmitter10b_next_value_ce1 <= 1'd0;
	platform_fsm_next_state <= 2'd0;
	platform_fsm_next_state <= platform_fsm_state;
	case (platform_fsm_state)
		1'd1: begin
			if (__main___transmitter_tx_done) begin
				platform_fsm_next_state <= 2'd2;
				__main___transmitter_tx_ready_transmitter10b_next_value0 <= 1'd1;
				__main___transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
				__main___transmitter_tx_data_transmitter10b_next_value1 <= __main___transmitter_data_in[9:5];
				__main___transmitter_tx_data_transmitter10b_next_value_ce1 <= 1'd1;
			end
		end
		2'd2: begin
			if ((~__main___transmitter_tx_done)) begin
				platform_fsm_next_state <= 2'd3;
			end
		end
		2'd3: begin
			if (__main___transmitter_tx_done) begin
				platform_fsm_next_state <= 1'd0;
				__main___transmitter_tx_10bdone_transmitter10b_next_value2 <= 1'd1;
				__main___transmitter_tx_10bdone_transmitter10b_next_value_ce2 <= 1'd1;
				__main___transmitter_tx_ready_transmitter10b_next_value0 <= 1'd0;
				__main___transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
			end
		end
		default: begin
			if ((__main___transmitter_trans_en & (~__main___transmitter_tx_done))) begin
				platform_fsm_next_state <= 1'd1;
				__main___transmitter_tx_ready_transmitter10b_next_value0 <= 1'd1;
				__main___transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
				__main___transmitter_tx_data_transmitter10b_next_value1 <= __main___transmitter_data_in[4:0];
				__main___transmitter_tx_data_transmitter10b_next_value_ce1 <= 1'd1;
			end else begin
				platform_fsm_next_state <= 1'd0;
				__main___transmitter_tx_ready_transmitter10b_next_value0 <= 1'd0;
				__main___transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
			end
			__main___transmitter_tx_10bdone_transmitter10b_next_value2 <= 1'd0;
			__main___transmitter_tx_10bdone_transmitter10b_next_value_ce2 <= 1'd1;
		end
	endcase
end
assign __main___transmitter_tx_strobe = (__main___transmitter_tx_counter == 1'd0);
always @(*) begin
	__main___transmitter_tx_counter_transmitter10b_t_next_value1 <= 11'd0;
	__main___transmitter_tx_counter_transmitter10b_t_next_value_ce1 <= 1'd0;
	__main___transmitter_tx_done_transmitter10b_t_next_value3 <= 1'd0;
	__main___transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd0;
	__main___transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd0;
	__main___transmitter_tx_done_transmitter10b_t_next_value_ce3 <= 1'd0;
	__main___transmitter_tx_bitn_transmitter10b_t_next_value2 <= 3'd0;
	__main___transmitter_tx_bitn_transmitter10b_t_next_value_ce2 <= 1'd0;
	platform_tx_next_state <= 2'd0;
	__main___transmitter_tx_latch_transmitter10b_t_next_value0 <= 8'd0;
	__main___transmitter_tx_latch_transmitter10b_t_next_value_ce0 <= 1'd0;
	platform_tx_next_state <= platform_tx_state;
	case (platform_tx_state)
		1'd1: begin
			if (__main___transmitter_tx_strobe) begin
				__main___transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd0;
				__main___transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
				platform_tx_next_state <= 2'd2;
			end
		end
		2'd2: begin
			if (__main___transmitter_tx_strobe) begin
				__main___transmitter_tx_serial1_transmitter10b_f_next_value <= __main___transmitter_tx_latch[0];
				__main___transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
				__main___transmitter_tx_latch_transmitter10b_t_next_value0 <= {1'd0, __main___transmitter_tx_latch[7:1]};
				__main___transmitter_tx_latch_transmitter10b_t_next_value_ce0 <= 1'd1;
				__main___transmitter_tx_bitn_transmitter10b_t_next_value2 <= (__main___transmitter_tx_bitn + 1'd1);
				__main___transmitter_tx_bitn_transmitter10b_t_next_value_ce2 <= 1'd1;
				if ((__main___transmitter_tx_bitn == 3'd7)) begin
					platform_tx_next_state <= 2'd3;
					__main___transmitter_tx_bitn_transmitter10b_t_next_value2 <= 1'd0;
					__main___transmitter_tx_bitn_transmitter10b_t_next_value_ce2 <= 1'd1;
					__main___transmitter_tx_done_transmitter10b_t_next_value3 <= 1'd1;
					__main___transmitter_tx_done_transmitter10b_t_next_value_ce3 <= 1'd1;
				end
			end
		end
		2'd3: begin
			if (__main___transmitter_tx_strobe) begin
				__main___transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd1;
				__main___transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
				__main___transmitter_tx_done_transmitter10b_t_next_value3 <= 1'd0;
				__main___transmitter_tx_done_transmitter10b_t_next_value_ce3 <= 1'd1;
				platform_tx_next_state <= 1'd0;
			end
		end
		default: begin
			if (__main___transmitter_tx_ready) begin
				__main___transmitter_tx_latch_transmitter10b_t_next_value0 <= __main___transmitter_tx_data;
				__main___transmitter_tx_latch_transmitter10b_t_next_value_ce0 <= 1'd1;
				__main___transmitter_tx_counter_transmitter10b_t_next_value1 <= 11'd1249;
				__main___transmitter_tx_counter_transmitter10b_t_next_value_ce1 <= 1'd1;
				platform_tx_next_state <= 1'd1;
			end else begin
				__main___transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd1;
				__main___transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
			end
		end
	endcase
end
always @(*) begin
	__main___prueba <= 24'd0;
	if (__main___enable) begin
		__main___prueba <= {__main___state[22], __main___state[21], __main___state[20], __main___state[19], __main___state[18], __main___state[17], __main___state[16], __main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22])};
	end
	if (__main___enable) begin
		__main___prueba <= {__main___state[21], __main___state[20], __main___state[19], __main___state[18], __main___state[17], __main___state[16], __main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21])};
	end
	if (__main___enable) begin
		__main___prueba <= {__main___state[20], __main___state[19], __main___state[18], __main___state[17], __main___state[16], __main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20])};
	end
	if (__main___enable) begin
		__main___prueba <= {__main___state[19], __main___state[18], __main___state[17], __main___state[16], __main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20]), (__main___state[7] ^ __main___state[19])};
	end
	if (__main___enable) begin
		__main___prueba <= {__main___state[18], __main___state[17], __main___state[16], __main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20]), (__main___state[7] ^ __main___state[19]), (__main___state[6] ^ __main___state[18])};
	end
	if (__main___enable) begin
		__main___prueba <= {__main___state[17], __main___state[16], __main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20]), (__main___state[7] ^ __main___state[19]), (__main___state[6] ^ __main___state[18]), (__main___state[5] ^ __main___state[17])};
	end
	if (__main___enable) begin
		__main___prueba <= {__main___state[16], __main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20]), (__main___state[7] ^ __main___state[19]), (__main___state[6] ^ __main___state[18]), (__main___state[5] ^ __main___state[17]), (__main___state[4] ^ __main___state[16])};
	end
	if (__main___enable) begin
		__main___prueba <= {__main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20]), (__main___state[7] ^ __main___state[19]), (__main___state[6] ^ __main___state[18]), (__main___state[5] ^ __main___state[17]), (__main___state[4] ^ __main___state[16]), (__main___state[3] ^ __main___state[15])};
	end
end
always @(*) begin
	__main___fsm_v2_prbs_en_fsm_v2_f_next_value <= 1'd0;
	__main___fsm_v2_prbs_en_fsm_v2_f_next_value_ce <= 1'd0;
	__main___fsm_v2_change_disp_fsm_v2_next_value0 <= 1'd0;
	__main___fsm_v2_change_disp_fsm_v2_next_value_ce0 <= 1'd0;
	__main___fsm_v2_encoder_ready_fsm_v2_next_value3 <= 1'd0;
	__main___fsm_v2_fifo_we_fsm_v2_next_value1 <= 1'd0;
	platform_next_state <= 3'd0;
	__main___fsm_v2_fifo_we_fsm_v2_next_value_ce1 <= 1'd0;
	__main___fsm_v2_encoder_ready_fsm_v2_next_value_ce3 <= 1'd0;
	__main___fsm_v2_tx_en_fsm_v2_next_value4 <= 1'd0;
	__main___fsm_v2_tx_en_fsm_v2_next_value_ce4 <= 1'd0;
	__main___fsm_v2_write_cnt_fsm_v2_next_value2 <= 3'd0;
	__main___fsm_v2_fifo_re_fsm_v2_t_next_value <= 1'd0;
	__main___fsm_v2_write_cnt_fsm_v2_next_value_ce2 <= 1'd0;
	__main___fsm_v2_fifo_re_fsm_v2_t_next_value_ce <= 1'd0;
	platform_next_state <= platform_state;
	case (platform_state)
		1'd1: begin
			__main___fsm_v2_prbs_en_fsm_v2_f_next_value <= 1'd0;
			__main___fsm_v2_prbs_en_fsm_v2_f_next_value_ce <= 1'd1;
			__main___fsm_v2_fifo_we_fsm_v2_next_value1 <= 1'd1;
			__main___fsm_v2_fifo_we_fsm_v2_next_value_ce1 <= 1'd1;
			platform_next_state <= 2'd2;
		end
		2'd2: begin
			__main___fsm_v2_write_cnt_fsm_v2_next_value2 <= (__main___fsm_v2_write_cnt + 1'd1);
			__main___fsm_v2_write_cnt_fsm_v2_next_value_ce2 <= 1'd1;
			if ((__main___fsm_v2_write_cnt < 3'd6)) begin
				platform_next_state <= 1'd1;
				__main___fsm_v2_fifo_we_fsm_v2_next_value1 <= 1'd0;
				__main___fsm_v2_fifo_we_fsm_v2_next_value_ce1 <= 1'd1;
				__main___fsm_v2_prbs_en_fsm_v2_f_next_value <= 1'd1;
				__main___fsm_v2_prbs_en_fsm_v2_f_next_value_ce <= 1'd1;
			end
			if ((__main___fsm_v2_write_cnt == 3'd5)) begin
				__main___fsm_v2_fifo_we_fsm_v2_next_value1 <= 1'd0;
				__main___fsm_v2_fifo_we_fsm_v2_next_value_ce1 <= 1'd1;
				__main___fsm_v2_prbs_en_fsm_v2_f_next_value <= 1'd0;
				__main___fsm_v2_prbs_en_fsm_v2_f_next_value_ce <= 1'd1;
				__main___fsm_v2_write_cnt_fsm_v2_next_value2 <= 1'd0;
				__main___fsm_v2_write_cnt_fsm_v2_next_value_ce2 <= 1'd1;
				platform_next_state <= 2'd3;
			end
		end
		2'd3: begin
			__main___fsm_v2_fifo_re_fsm_v2_t_next_value <= 1'd0;
			__main___fsm_v2_fifo_re_fsm_v2_t_next_value_ce <= 1'd1;
			platform_next_state <= 3'd4;
		end
		3'd4: begin
			platform_next_state <= 3'd5;
			__main___fsm_v2_encoder_ready_fsm_v2_next_value3 <= 1'd1;
			__main___fsm_v2_encoder_ready_fsm_v2_next_value_ce3 <= 1'd1;
			__main___fsm_v2_tx_en_fsm_v2_next_value4 <= 1'd1;
			__main___fsm_v2_tx_en_fsm_v2_next_value_ce4 <= 1'd1;
		end
		3'd5: begin
			__main___fsm_v2_tx_en_fsm_v2_next_value4 <= 1'd1;
			__main___fsm_v2_tx_en_fsm_v2_next_value_ce4 <= 1'd1;
			if (__main___fsm_v2_tx_10bdone) begin
				platform_next_state <= 1'd0;
				__main___fsm_v2_tx_en_fsm_v2_next_value4 <= 1'd0;
				__main___fsm_v2_tx_en_fsm_v2_next_value_ce4 <= 1'd1;
				__main___fsm_v2_change_disp_fsm_v2_next_value0 <= 1'd1;
				__main___fsm_v2_change_disp_fsm_v2_next_value_ce0 <= 1'd1;
			end
		end
		default: begin
			if (((__main___fsm_v2_trans_en & (~__main___fsm_v2_tx_10bdone)) & (~__main___fsm_v2_fifo_empty))) begin
				platform_next_state <= 2'd3;
				__main___fsm_v2_fifo_re_fsm_v2_t_next_value <= 1'd1;
				__main___fsm_v2_fifo_re_fsm_v2_t_next_value_ce <= 1'd1;
			end else begin
				if (((__main___fsm_v2_trans_en & (~__main___fsm_v2_tx_10bdone)) & __main___fsm_v2_fifo_empty)) begin
					platform_next_state <= 1'd1;
					__main___fsm_v2_prbs_en_fsm_v2_f_next_value <= 1'd1;
					__main___fsm_v2_prbs_en_fsm_v2_f_next_value_ce <= 1'd1;
				end
			end
			__main___fsm_v2_change_disp_fsm_v2_next_value0 <= 1'd0;
			__main___fsm_v2_change_disp_fsm_v2_next_value_ce0 <= 1'd1;
		end
	endcase
end
assign __main___syncfifo_re = (__main___syncfifo_readable & ((~__main___readable) | __main___re));
assign __main___level1 = (__main___level0 + __main___readable);
always @(*) begin
	__main___wrport_adr <= 5'd0;
	if (__main___replace) begin
		__main___wrport_adr <= (__main___produce - 1'd1);
	end else begin
		__main___wrport_adr <= __main___produce;
	end
end
assign __main___wrport_dat_w = __main___syncfifo_din;
assign __main___wrport_we = (__main___syncfifo_we & (__main___syncfifo_writable | __main___replace));
assign __main___do_read = (__main___syncfifo_readable & __main___syncfifo_re);
assign __main___rdport_adr = __main___consume;
assign __main___syncfifo_dout = __main___rdport_dat_r;
assign __main___rdport_re = __main___do_read;
assign __main___syncfifo_writable = (__main___level0 != 6'd32);
assign __main___syncfifo_readable = (__main___level0 != 1'd0);
assign sys_clk = clk12;
assign por_clk = clk12;
assign sys_rst = platform_int_rst;

always @(posedge por_clk) begin
	platform_int_rst <= 1'd0;
end

always @(posedge sys_clk) begin
	if (__main___fsm_v2_change_disp) begin
		__main___encoder_disp_in <= __main___encoder_disp_out;
	end
	platform_fsm_state <= platform_fsm_next_state;
	if (__main___transmitter_tx_ready_transmitter10b_next_value_ce0) begin
		__main___transmitter_tx_ready <= __main___transmitter_tx_ready_transmitter10b_next_value0;
	end
	if (__main___transmitter_tx_data_transmitter10b_next_value_ce1) begin
		__main___transmitter_tx_data <= __main___transmitter_tx_data_transmitter10b_next_value1;
	end
	if (__main___transmitter_tx_10bdone_transmitter10b_next_value_ce2) begin
		__main___transmitter_tx_10bdone <= __main___transmitter_tx_10bdone_transmitter10b_next_value2;
	end
	if ((__main___transmitter_tx_counter == 1'd0)) begin
		__main___transmitter_tx_counter <= 11'd1249;
	end else begin
		__main___transmitter_tx_counter <= (__main___transmitter_tx_counter - 1'd1);
	end
	platform_tx_state <= platform_tx_next_state;
	if (__main___transmitter_tx_latch_transmitter10b_t_next_value_ce0) begin
		__main___transmitter_tx_latch <= __main___transmitter_tx_latch_transmitter10b_t_next_value0;
	end
	if (__main___transmitter_tx_counter_transmitter10b_t_next_value_ce1) begin
		__main___transmitter_tx_counter <= __main___transmitter_tx_counter_transmitter10b_t_next_value1;
	end
	if (__main___transmitter_tx_serial1_transmitter10b_f_next_value_ce) begin
		__main___transmitter_tx_serial1 <= __main___transmitter_tx_serial1_transmitter10b_f_next_value;
	end
	if (__main___transmitter_tx_bitn_transmitter10b_t_next_value_ce2) begin
		__main___transmitter_tx_bitn <= __main___transmitter_tx_bitn_transmitter10b_t_next_value2;
	end
	if (__main___transmitter_tx_done_transmitter10b_t_next_value_ce3) begin
		__main___transmitter_tx_done <= __main___transmitter_tx_done_transmitter10b_t_next_value3;
	end
	if (__main___enable) begin
		__main___state <= {__main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20]), (__main___state[7] ^ __main___state[19]), (__main___state[6] ^ __main___state[18]), (__main___state[5] ^ __main___state[17]), (__main___state[4] ^ __main___state[16]), (__main___state[3] ^ __main___state[15])};
		__main___o <= {__main___state[15], __main___state[14], __main___state[13], __main___state[12], __main___state[11], __main___state[10], __main___state[9], __main___state[8], __main___state[7], __main___state[6], __main___state[5], __main___state[4], __main___state[3], __main___state[2], __main___state[1], __main___state[0], (__main___state[10] ^ __main___state[22]), (__main___state[9] ^ __main___state[21]), (__main___state[8] ^ __main___state[20]), (__main___state[7] ^ __main___state[19]), (__main___state[6] ^ __main___state[18]), (__main___state[5] ^ __main___state[17]), (__main___state[4] ^ __main___state[16]), (__main___state[3] ^ __main___state[15])};
	end
	platform_state <= platform_next_state;
	if (__main___fsm_v2_fifo_re_fsm_v2_t_next_value_ce) begin
		__main___fsm_v2_fifo_re <= __main___fsm_v2_fifo_re_fsm_v2_t_next_value;
	end
	if (__main___fsm_v2_prbs_en_fsm_v2_f_next_value_ce) begin
		__main___fsm_v2_prbs_en <= __main___fsm_v2_prbs_en_fsm_v2_f_next_value;
	end
	if (__main___fsm_v2_change_disp_fsm_v2_next_value_ce0) begin
		__main___fsm_v2_change_disp <= __main___fsm_v2_change_disp_fsm_v2_next_value0;
	end
	if (__main___fsm_v2_fifo_we_fsm_v2_next_value_ce1) begin
		__main___fsm_v2_fifo_we <= __main___fsm_v2_fifo_we_fsm_v2_next_value1;
	end
	if (__main___fsm_v2_write_cnt_fsm_v2_next_value_ce2) begin
		__main___fsm_v2_write_cnt <= __main___fsm_v2_write_cnt_fsm_v2_next_value2;
	end
	if (__main___fsm_v2_encoder_ready_fsm_v2_next_value_ce3) begin
		__main___fsm_v2_encoder_ready <= __main___fsm_v2_encoder_ready_fsm_v2_next_value3;
	end
	if (__main___fsm_v2_tx_en_fsm_v2_next_value_ce4) begin
		__main___fsm_v2_tx_en <= __main___fsm_v2_tx_en_fsm_v2_next_value4;
	end
	if (__main___syncfifo_re) begin
		__main___readable <= 1'd1;
	end else begin
		if (__main___re) begin
			__main___readable <= 1'd0;
		end
	end
	if (((__main___syncfifo_we & __main___syncfifo_writable) & (~__main___replace))) begin
		__main___produce <= (__main___produce + 1'd1);
	end
	if (__main___do_read) begin
		__main___consume <= (__main___consume + 1'd1);
	end
	if (((__main___syncfifo_we & __main___syncfifo_writable) & (~__main___replace))) begin
		if ((~__main___do_read)) begin
			__main___level0 <= (__main___level0 + 1'd1);
		end
	end else begin
		if (__main___do_read) begin
			__main___level0 <= (__main___level0 - 1'd1);
		end
	end
	if (sys_rst) begin
		__main___fsm_v2_prbs_en <= 1'd0;
		__main___fsm_v2_encoder_ready <= 1'd0;
		__main___fsm_v2_change_disp <= 1'd0;
		__main___fsm_v2_tx_en <= 1'd0;
		__main___fsm_v2_fifo_we <= 1'd0;
		__main___fsm_v2_fifo_re <= 1'd0;
		__main___fsm_v2_write_cnt <= 3'd0;
		__main___encoder_disp_in <= 1'd0;
		__main___transmitter_tx_10bdone <= 1'd0;
		__main___transmitter_tx_counter <= 11'd0;
		__main___transmitter_tx_serial1 <= 1'd1;
		__main___transmitter_tx_data <= 8'd0;
		__main___transmitter_tx_bitn <= 3'd0;
		__main___transmitter_tx_ready <= 1'd0;
		__main___transmitter_tx_latch <= 8'd0;
		__main___transmitter_tx_done <= 1'd0;
		__main___o <= 8'd0;
		__main___state <= 24'd1;
		__main___readable <= 1'd0;
		__main___level0 <= 6'd0;
		__main___produce <= 5'd0;
		__main___consume <= 5'd0;
		platform_fsm_state <= 2'd0;
		platform_tx_state <= 2'd0;
		platform_state <= 3'd0;
	end
end

reg [7:0] storage[0:31];
reg [7:0] memdat;
reg [7:0] memdat_1;
always @(posedge sys_clk) begin
	if (__main___wrport_we)
		storage[__main___wrport_adr] <= __main___wrport_dat_w;
	memdat <= storage[__main___wrport_adr];
end

always @(posedge sys_clk) begin
	if (__main___rdport_re)
		memdat_1 <= storage[__main___rdport_adr];
end

assign __main___wrport_dat_r = memdat;
assign __main___rdport_dat_r = memdat_1;

endmodule