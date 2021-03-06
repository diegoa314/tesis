//--------------------------------------------------------------------------------
// Auto-generated by Migen (--------) & LiteX (690de79) on 2020-01-13 17:08:34
//--------------------------------------------------------------------------------
module top(
	output serial_tx,
	input serial_rx,
	input user_btn,
	input user_btn_1,
	(* dont_touch = "true" *)	input clk12
);

wire fsm_v1_tx_10bdone;
wire fsm_v1_trans_en;
reg fsm_v1_prbs_en = 1'd0;
reg fsm_v1_encoder_ready = 1'd0;
reg fsm_v1_change_disp = 1'd0;
reg fsm_v1_tx_en = 1'd0;
wire [7:0] encoder_data_in;
wire encoder_k;
reg [9:0] encoder_data_out = 10'd0;
reg encoder_disp_in = 1'd0;
wire encoder_disp_out;
reg [8:0] encoder0 = 9'd0;
reg [6:0] encoder1 = 7'd0;
reg [5:0] encoder2 = 6'd0;
reg [3:0] encoder3 = 4'd0;
reg [5:0] encoder4 = 6'd0;
reg [3:0] encoder5 = 4'd0;
wire encoder_illegalk;
wire encoder_compls6;
reg [1:0] encoder6 = 2'd0;
reg [9:0] transmitter_data_in = 10'd0;
wire transmitter_trans_en;
wire transmitter_tx_serial0;
reg transmitter_tx_10bdone = 1'd0;
reg transmitter_tx_counter = 1'd0;
reg transmitter_tx_serial1 = 1'd1;
reg [7:0] transmitter_tx_data = 8'd0;
wire transmitter_tx_strobe;
reg [2:0] transmitter_tx_bitn = 3'd0;
reg transmitter_tx_ready = 1'd0;
reg [7:0] transmitter_tx_latch = 8'd0;
reg transmitter_tx_done = 1'd0;
reg [7:0] data = 8'd0;
reg [1:0] fsm_state = 2'd0;
reg [1:0] fsm_next_state = 2'd0;
reg transmitter_tx_ready_transmitter10b_next_value0 = 1'd0;
reg transmitter_tx_ready_transmitter10b_next_value_ce0 = 1'd0;
reg [7:0] transmitter_tx_data_transmitter10b_next_value1 = 8'd0;
reg transmitter_tx_data_transmitter10b_next_value_ce1 = 1'd0;
reg transmitter_tx_10bdone_transmitter10b_next_value2 = 1'd0;
reg transmitter_tx_10bdone_transmitter10b_next_value_ce2 = 1'd0;
reg [1:0] tx_state = 2'd0;
reg [1:0] tx_next_state = 2'd0;
reg [7:0] transmitter_tx_latch_transmitter10b_t_next_value0 = 8'd0;
reg transmitter_tx_latch_transmitter10b_t_next_value_ce0 = 1'd0;
reg transmitter_tx_counter_transmitter10b_t_next_value1 = 1'd0;
reg transmitter_tx_counter_transmitter10b_t_next_value_ce1 = 1'd0;
reg transmitter_tx_serial1_transmitter10b_f_next_value = 1'd0;
reg transmitter_tx_serial1_transmitter10b_f_next_value_ce = 1'd0;
reg [2:0] transmitter_tx_bitn_transmitter10b_t_next_value2 = 3'd0;
reg transmitter_tx_bitn_transmitter10b_t_next_value_ce2 = 1'd0;
reg transmitter_tx_done_transmitter10b_t_next_value3 = 1'd0;
reg transmitter_tx_done_transmitter10b_t_next_value_ce3 = 1'd0;
reg [1:0] state = 2'd0;
reg [1:0] next_state = 2'd0;
reg fsm_v1_prbs_en_fsm_v1_next_value0 = 1'd0;
reg fsm_v1_prbs_en_fsm_v1_next_value_ce0 = 1'd0;
reg fsm_v1_change_disp_fsm_v1_next_value1 = 1'd0;
reg fsm_v1_change_disp_fsm_v1_next_value_ce1 = 1'd0;
reg fsm_v1_encoder_ready_fsm_v1_next_value2 = 1'd0;
reg fsm_v1_encoder_ready_fsm_v1_next_value_ce2 = 1'd0;
reg fsm_v1_tx_en_fsm_v1_next_value3 = 1'd0;
reg fsm_v1_tx_en_fsm_v1_next_value_ce3 = 1'd0;
wire sys_clk;
wire sys_rst;
wire por_clk;
reg int_rst = 1'd1;

assign fsm_v1_tx_10bdone = transmitter_tx_10bdone;
assign fsm_v1_trans_en = user_btn;
assign transmitter_trans_en = fsm_v1_tx_en;
assign serial_tx = transmitter_tx_serial0;
assign encoder_data_in = data;
always @(*) begin
	transmitter_data_in <= 10'd0;
	if (fsm_v1_encoder_ready) begin
		transmitter_data_in <= encoder_data_out;
	end
end
assign encoder_k = 1'd0;
always @(*) begin
	encoder0 <= 9'd0;
	encoder0[0] <= encoder_data_in[0];
	encoder0[1] <= encoder_data_in[1];
	encoder0[2] <= encoder_data_in[2];
	encoder0[3] <= encoder_data_in[3];
	encoder0[4] <= encoder_data_in[4];
	encoder0[5] <= encoder_data_in[5];
	encoder0[6] <= encoder_data_in[6];
	encoder0[7] <= encoder_data_in[7];
	encoder0[8] <= encoder_k;
end
always @(*) begin
	encoder1 <= 7'd0;
	encoder1[0] <= ((encoder0[0] & encoder0[1]) | ((~encoder0[0]) & (~encoder0[1])));
	encoder1[1] <= ((encoder0[2] & encoder0[3]) | ((~encoder0[2]) & (~encoder0[3])));
	encoder1[2] <= (((((encoder0[0] & encoder0[1]) & (~encoder0[2])) & (~encoder0[3])) | (((encoder0[2] & encoder0[3]) & (~encoder0[0])) & (~encoder0[1]))) | ((~encoder1[0]) & (~encoder1[1])));
	encoder1[3] <= (((encoder0[0] & encoder0[1]) & encoder0[2]) & encoder0[3]);
	encoder1[4] <= ((((~encoder0[0]) & (~encoder0[1])) & (~encoder0[2])) & (~encoder0[3]));
	encoder1[5] <= ((((~encoder1[0]) & (~encoder0[2])) & (~encoder0[3])) | (((~encoder1[1]) & (~encoder0[0])) & (~encoder0[1])));
	encoder1[6] <= ((((~encoder1[0]) & encoder0[2]) & encoder0[3]) | (((~encoder1[1]) & encoder0[0]) & encoder0[1]));
end
always @(*) begin
	encoder2 <= 6'd0;
	encoder2[0] <= encoder0[0];
	encoder2[1] <= ((encoder0[1] & (~encoder1[3])) | encoder1[4]);
	encoder2[2] <= ((encoder1[4] | encoder0[2]) | ((((encoder0[4] & encoder0[3]) & (~encoder0[2])) & (~encoder0[1])) & (~encoder0[0])));
	encoder2[3] <= (encoder0[3] & (~((encoder0[0] & encoder0[1]) & encoder0[2])));
	encoder2[4] <= ((encoder0[4] | encoder1[5]) & (~((((encoder0[4] & encoder0[3]) & (~encoder0[2])) & (~encoder0[1])) & (~encoder0[0]))));
	encoder2[5] <= (((((encoder1[2] & (~encoder0[4])) | (((encoder0[4] & (~encoder0[3])) & (~encoder0[2])) & (~(encoder0[0] & encoder0[1])))) | (encoder0[4] & encoder1[3])) | (((((encoder0[8] & encoder0[4]) & encoder0[3]) & encoder0[2]) & (~encoder0[1])) & (~encoder0[0]))) | ((((encoder0[4] & (~encoder0[3])) & encoder0[2]) & (~encoder0[1])) & (~encoder0[0])));
end
always @(*) begin
	encoder3 <= 4'd0;
	encoder3[0] <= (((((encoder0[4] & encoder0[3]) & (~encoder0[2])) & (~encoder0[1])) & (~encoder0[0])) | (((~encoder0[4]) & (~encoder1[2])) & (~encoder1[6])));
	encoder3[1] <= ((encoder0[8] | ((encoder0[4] & (~encoder1[2])) & (~encoder1[5]))) | (((((~encoder0[4]) & (~encoder0[3])) & encoder0[2]) & encoder0[1]) & encoder0[0]));
	encoder3[2] <= encoder3[0];
	encoder3[3] <= (encoder0[8] | ((encoder0[4] & (~encoder1[2])) & (~encoder1[5])));
end
always @(*) begin
	encoder4 <= 6'd0;
	if (encoder_disp_in) begin
		encoder4[5] <= (((~encoder0[4]) & encoder0[3]) & encoder1[6]);
	end else begin
		encoder4[5] <= ((encoder0[4] & (~encoder0[3])) & encoder1[5]);
	end
	encoder4[0] <= (((encoder0[5] & encoder0[6]) & encoder0[7]) & (encoder0[8] | encoder4[5]));
	encoder4[1] <= (encoder0[5] & (~encoder4[0]));
	encoder4[2] <= (encoder0[6] | (((~encoder0[5]) & (~encoder0[6])) & (~encoder0[7])));
	encoder4[3] <= encoder0[7];
	encoder4[4] <= (((~encoder0[7]) & (encoder0[6] ^ encoder0[5])) | encoder4[0]);
end
always @(*) begin
	encoder5 <= 4'd0;
	encoder5[0] <= (encoder0[5] & encoder0[6]);
	encoder5[1] <= (((~encoder0[5]) & (~encoder0[6])) | (encoder0[8] & ((encoder0[5] & (~encoder0[6])) | ((~encoder0[5]) & encoder0[6]))));
	encoder5[2] <= ((~encoder0[5]) & (~encoder0[6]));
	encoder5[3] <= ((encoder0[5] & encoder0[6]) & encoder0[7]);
end
assign encoder_illegalk = ((encoder0[8] & ((((encoder0[0] | encoder0[1]) | (~encoder0[2])) | (~encoder0[3])) | (~encoder0[4]))) & (((((~encoder0[5]) | (~encoder0[6])) | (~encoder0[7])) | (~encoder0[4])) | (~encoder1[6])));
assign encoder_compls6 = ((encoder3[0] & (~encoder_disp_in)) | (encoder3[1] & encoder_disp_in));
always @(*) begin
	encoder6 <= 2'd0;
	encoder6[0] <= (encoder_disp_in ^ (encoder3[2] | encoder3[3]));
	encoder6[1] <= ((encoder5[1] & (~encoder6[0])) | (encoder5[0] & encoder6[0]));
end
assign encoder_disp_out = (encoder6[0] ^ (encoder5[2] | encoder5[3]));
always @(*) begin
	encoder_data_out <= 10'd0;
	encoder_data_out[0] <= (encoder4[4] ^ encoder6[1]);
	encoder_data_out[1] <= (encoder4[3] ^ encoder6[1]);
	encoder_data_out[2] <= (encoder4[2] ^ encoder6[1]);
	encoder_data_out[3] <= (encoder4[1] ^ encoder6[1]);
	encoder_data_out[4] <= (encoder2[5] ^ encoder_compls6);
	encoder_data_out[5] <= (encoder2[4] ^ encoder_compls6);
	encoder_data_out[6] <= (encoder2[3] ^ encoder_compls6);
	encoder_data_out[7] <= (encoder2[2] ^ encoder_compls6);
	encoder_data_out[8] <= (encoder2[1] ^ encoder_compls6);
	encoder_data_out[9] <= (encoder2[0] ^ encoder_compls6);
end
assign transmitter_tx_serial0 = transmitter_tx_serial1;
always @(*) begin
	transmitter_tx_ready_transmitter10b_next_value0 <= 1'd0;
	transmitter_tx_10bdone_transmitter10b_next_value_ce2 <= 1'd0;
	transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd0;
	transmitter_tx_data_transmitter10b_next_value1 <= 8'd0;
	transmitter_tx_data_transmitter10b_next_value_ce1 <= 1'd0;
	fsm_next_state <= 2'd0;
	transmitter_tx_10bdone_transmitter10b_next_value2 <= 1'd0;
	fsm_next_state <= fsm_state;
	case (fsm_state)
		1'd1: begin
			if (transmitter_tx_done) begin
				fsm_next_state <= 2'd2;
				transmitter_tx_ready_transmitter10b_next_value0 <= 1'd1;
				transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
				transmitter_tx_data_transmitter10b_next_value1 <= transmitter_data_in[9:5];
				transmitter_tx_data_transmitter10b_next_value_ce1 <= 1'd1;
			end
		end
		2'd2: begin
			if ((~transmitter_tx_done)) begin
				fsm_next_state <= 2'd3;
			end
		end
		2'd3: begin
			if (transmitter_tx_done) begin
				fsm_next_state <= 1'd0;
				transmitter_tx_10bdone_transmitter10b_next_value2 <= 1'd1;
				transmitter_tx_10bdone_transmitter10b_next_value_ce2 <= 1'd1;
				transmitter_tx_ready_transmitter10b_next_value0 <= 1'd0;
				transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
			end
		end
		default: begin
			if ((transmitter_trans_en & (~transmitter_tx_done))) begin
				fsm_next_state <= 1'd1;
				transmitter_tx_ready_transmitter10b_next_value0 <= 1'd1;
				transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
				transmitter_tx_data_transmitter10b_next_value1 <= transmitter_data_in[4:0];
				transmitter_tx_data_transmitter10b_next_value_ce1 <= 1'd1;
			end else begin
				fsm_next_state <= 1'd0;
				transmitter_tx_ready_transmitter10b_next_value0 <= 1'd0;
				transmitter_tx_ready_transmitter10b_next_value_ce0 <= 1'd1;
			end
			transmitter_tx_10bdone_transmitter10b_next_value2 <= 1'd0;
			transmitter_tx_10bdone_transmitter10b_next_value_ce2 <= 1'd1;
		end
	endcase
end
assign transmitter_tx_strobe = (transmitter_tx_counter == 1'd0);
always @(*) begin
	transmitter_tx_bitn_transmitter10b_t_next_value2 <= 3'd0;
	transmitter_tx_bitn_transmitter10b_t_next_value_ce2 <= 1'd0;
	tx_next_state <= 2'd0;
	transmitter_tx_latch_transmitter10b_t_next_value0 <= 8'd0;
	transmitter_tx_done_transmitter10b_t_next_value3 <= 1'd0;
	transmitter_tx_latch_transmitter10b_t_next_value_ce0 <= 1'd0;
	transmitter_tx_done_transmitter10b_t_next_value_ce3 <= 1'd0;
	transmitter_tx_counter_transmitter10b_t_next_value1 <= 1'd0;
	transmitter_tx_counter_transmitter10b_t_next_value_ce1 <= 1'd0;
	transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd0;
	transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd0;
	tx_next_state <= tx_state;
	case (tx_state)
		1'd1: begin
			if (transmitter_tx_strobe) begin
				transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd0;
				transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
				tx_next_state <= 2'd2;
			end
		end
		2'd2: begin
			if (transmitter_tx_strobe) begin
				transmitter_tx_serial1_transmitter10b_f_next_value <= transmitter_tx_latch[0];
				transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
				transmitter_tx_latch_transmitter10b_t_next_value0 <= {1'd0, transmitter_tx_latch[7:1]};
				transmitter_tx_latch_transmitter10b_t_next_value_ce0 <= 1'd1;
				transmitter_tx_bitn_transmitter10b_t_next_value2 <= (transmitter_tx_bitn + 1'd1);
				transmitter_tx_bitn_transmitter10b_t_next_value_ce2 <= 1'd1;
				if ((transmitter_tx_bitn == 3'd7)) begin
					tx_next_state <= 2'd3;
					transmitter_tx_bitn_transmitter10b_t_next_value2 <= 1'd0;
					transmitter_tx_bitn_transmitter10b_t_next_value_ce2 <= 1'd1;
					transmitter_tx_done_transmitter10b_t_next_value3 <= 1'd1;
					transmitter_tx_done_transmitter10b_t_next_value_ce3 <= 1'd1;
				end
			end
		end
		2'd3: begin
			if (transmitter_tx_strobe) begin
				transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd1;
				transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
				transmitter_tx_done_transmitter10b_t_next_value3 <= 1'd0;
				transmitter_tx_done_transmitter10b_t_next_value_ce3 <= 1'd1;
				tx_next_state <= 1'd0;
			end
		end
		default: begin
			if (transmitter_tx_ready) begin
				transmitter_tx_latch_transmitter10b_t_next_value0 <= transmitter_tx_data;
				transmitter_tx_latch_transmitter10b_t_next_value_ce0 <= 1'd1;
				transmitter_tx_counter_transmitter10b_t_next_value1 <= 1'd1;
				transmitter_tx_counter_transmitter10b_t_next_value_ce1 <= 1'd1;
				tx_next_state <= 1'd1;
			end else begin
				transmitter_tx_serial1_transmitter10b_f_next_value <= 1'd1;
				transmitter_tx_serial1_transmitter10b_f_next_value_ce <= 1'd1;
			end
		end
	endcase
end
always @(*) begin
	fsm_v1_prbs_en_fsm_v1_next_value0 <= 1'd0;
	fsm_v1_prbs_en_fsm_v1_next_value_ce0 <= 1'd0;
	fsm_v1_change_disp_fsm_v1_next_value1 <= 1'd0;
	fsm_v1_change_disp_fsm_v1_next_value_ce1 <= 1'd0;
	fsm_v1_encoder_ready_fsm_v1_next_value2 <= 1'd0;
	fsm_v1_encoder_ready_fsm_v1_next_value_ce2 <= 1'd0;
	fsm_v1_tx_en_fsm_v1_next_value3 <= 1'd0;
	fsm_v1_tx_en_fsm_v1_next_value_ce3 <= 1'd0;
	next_state <= 2'd0;
	next_state <= state;
	case (state)
		1'd1: begin
			next_state <= 2'd2;
			fsm_v1_prbs_en_fsm_v1_next_value0 <= 1'd0;
			fsm_v1_prbs_en_fsm_v1_next_value_ce0 <= 1'd1;
			fsm_v1_change_disp_fsm_v1_next_value1 <= 1'd0;
			fsm_v1_change_disp_fsm_v1_next_value_ce1 <= 1'd1;
		end
		2'd2: begin
			next_state <= 2'd3;
			fsm_v1_encoder_ready_fsm_v1_next_value2 <= 1'd1;
			fsm_v1_encoder_ready_fsm_v1_next_value_ce2 <= 1'd1;
			fsm_v1_tx_en_fsm_v1_next_value3 <= 1'd1;
			fsm_v1_tx_en_fsm_v1_next_value_ce3 <= 1'd1;
		end
		2'd3: begin
			fsm_v1_tx_en_fsm_v1_next_value3 <= 1'd1;
			fsm_v1_tx_en_fsm_v1_next_value_ce3 <= 1'd1;
			if (fsm_v1_tx_10bdone) begin
				next_state <= 1'd0;
				fsm_v1_tx_en_fsm_v1_next_value3 <= 1'd0;
				fsm_v1_tx_en_fsm_v1_next_value_ce3 <= 1'd1;
			end
		end
		default: begin
			if ((fsm_v1_trans_en & (~fsm_v1_tx_10bdone))) begin
				next_state <= 1'd1;
				fsm_v1_prbs_en_fsm_v1_next_value0 <= 1'd1;
				fsm_v1_prbs_en_fsm_v1_next_value_ce0 <= 1'd1;
				fsm_v1_change_disp_fsm_v1_next_value1 <= 1'd1;
				fsm_v1_change_disp_fsm_v1_next_value_ce1 <= 1'd1;
			end
		end
	endcase
end
assign sys_clk = clk12;
assign por_clk = clk12;
assign sys_rst = int_rst;

always @(posedge por_clk) begin
	int_rst <= 1'd0;
end

always @(posedge sys_clk) begin
	if (fsm_v1_change_disp) begin
		encoder_disp_in <= encoder_disp_out;
	end
	if ((fsm_v1_prbs_en & (~user_btn_1))) begin
		data <= (data + 1'd1);
	end
	if (user_btn_1) begin
		data <= 1'd0;
	end
	if ((data == 8'd255)) begin
		data <= 1'd0;
	end
	fsm_state <= fsm_next_state;
	if (transmitter_tx_ready_transmitter10b_next_value_ce0) begin
		transmitter_tx_ready <= transmitter_tx_ready_transmitter10b_next_value0;
	end
	if (transmitter_tx_data_transmitter10b_next_value_ce1) begin
		transmitter_tx_data <= transmitter_tx_data_transmitter10b_next_value1;
	end
	if (transmitter_tx_10bdone_transmitter10b_next_value_ce2) begin
		transmitter_tx_10bdone <= transmitter_tx_10bdone_transmitter10b_next_value2;
	end
	if ((transmitter_tx_counter == 1'd0)) begin
		transmitter_tx_counter <= 1'd1;
	end else begin
		transmitter_tx_counter <= (transmitter_tx_counter - 1'd1);
	end
	tx_state <= tx_next_state;
	if (transmitter_tx_latch_transmitter10b_t_next_value_ce0) begin
		transmitter_tx_latch <= transmitter_tx_latch_transmitter10b_t_next_value0;
	end
	if (transmitter_tx_counter_transmitter10b_t_next_value_ce1) begin
		transmitter_tx_counter <= transmitter_tx_counter_transmitter10b_t_next_value1;
	end
	if (transmitter_tx_serial1_transmitter10b_f_next_value_ce) begin
		transmitter_tx_serial1 <= transmitter_tx_serial1_transmitter10b_f_next_value;
	end
	if (transmitter_tx_bitn_transmitter10b_t_next_value_ce2) begin
		transmitter_tx_bitn <= transmitter_tx_bitn_transmitter10b_t_next_value2;
	end
	if (transmitter_tx_done_transmitter10b_t_next_value_ce3) begin
		transmitter_tx_done <= transmitter_tx_done_transmitter10b_t_next_value3;
	end
	state <= next_state;
	if (fsm_v1_prbs_en_fsm_v1_next_value_ce0) begin
		fsm_v1_prbs_en <= fsm_v1_prbs_en_fsm_v1_next_value0;
	end
	if (fsm_v1_change_disp_fsm_v1_next_value_ce1) begin
		fsm_v1_change_disp <= fsm_v1_change_disp_fsm_v1_next_value1;
	end
	if (fsm_v1_encoder_ready_fsm_v1_next_value_ce2) begin
		fsm_v1_encoder_ready <= fsm_v1_encoder_ready_fsm_v1_next_value2;
	end
	if (fsm_v1_tx_en_fsm_v1_next_value_ce3) begin
		fsm_v1_tx_en <= fsm_v1_tx_en_fsm_v1_next_value3;
	end
	if (sys_rst) begin
		fsm_v1_prbs_en <= 1'd0;
		fsm_v1_encoder_ready <= 1'd0;
		fsm_v1_change_disp <= 1'd0;
		fsm_v1_tx_en <= 1'd0;
		encoder_disp_in <= 1'd0;
		transmitter_tx_10bdone <= 1'd0;
		transmitter_tx_counter <= 1'd0;
		transmitter_tx_serial1 <= 1'd1;
		transmitter_tx_data <= 8'd0;
		transmitter_tx_bitn <= 3'd0;
		transmitter_tx_ready <= 1'd0;
		transmitter_tx_latch <= 8'd0;
		transmitter_tx_done <= 1'd0;
		data <= 8'd0;
		fsm_state <= 2'd0;
		tx_state <= 2'd0;
		state <= 2'd0;
	end
end

endmodule
