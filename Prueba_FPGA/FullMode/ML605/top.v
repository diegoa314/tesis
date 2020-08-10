/* Machine-generated using Migen */
module top(
	input link_ready,
	input reset,
	output [39:0] tx_data_out,
	input tx_init_done,
	input write_clk,
	input tx_clk,
	input [39:0] rx_data_in,
	input rx_init_done,
	input trans_en,
	input tx_serial,
	input rx_clk
);

reg we = 1'd0;
wire tx_link_ready;
reg [31:0] tx_data_in;
reg [1:0] tx_data_type_in;
reg [39:0] tx_data_out1;
wire tx_fifo_empty0;
wire tx_fifo_re;
wire tx_tx_init_done0;
reg [7:0] tx_d0;
reg [7:0] tx_d1;
reg [7:0] tx_d2;
reg [7:0] tx_d3;
reg tx_k0;
wire tx_k1;
wire tx_k2;
wire tx_k3;
reg [9:0] tx_output0 = 10'd0;
reg [9:0] tx_output1 = 10'd0;
reg [9:0] tx_output2 = 10'd0;
reg [9:0] tx_output3 = 10'd0;
reg tx_disparity0 = 1'd0;
reg tx_disparity1 = 1'd0;
reg tx_disparity2 = 1'd0;
reg tx_disparity3 = 1'd0;
wire [7:0] tx_singleencoder0_d;
wire tx_singleencoder0_k;
reg tx_singleencoder0_disp_in = 1'd0;
reg [9:0] tx_singleencoder0_output;
reg tx_singleencoder0_disp_out;
reg [5:0] tx_singleencoder0_code6b = 6'd0;
reg tx_singleencoder0_code6b_unbalanced = 1'd0;
reg tx_singleencoder0_code6b_flip = 1'd0;
reg [3:0] tx_singleencoder0_code4b = 4'd0;
reg tx_singleencoder0_code4b_unbalanced = 1'd0;
reg tx_singleencoder0_code4b_flip = 1'd0;
reg tx_singleencoder0_alt7_rd0 = 1'd0;
reg tx_singleencoder0_alt7_rd1 = 1'd0;
reg [5:0] tx_singleencoder0_output_6b;
wire tx_singleencoder0_disp_inter;
reg [3:0] tx_singleencoder0_output_4b;
wire [9:0] tx_singleencoder0_output_msb_first;
wire [7:0] tx_singleencoder1_d;
wire tx_singleencoder1_k;
wire tx_singleencoder1_disp_in;
reg [9:0] tx_singleencoder1_output;
reg tx_singleencoder1_disp_out;
reg [5:0] tx_singleencoder1_code6b = 6'd0;
reg tx_singleencoder1_code6b_unbalanced = 1'd0;
reg tx_singleencoder1_code6b_flip = 1'd0;
reg [3:0] tx_singleencoder1_code4b = 4'd0;
reg tx_singleencoder1_code4b_unbalanced = 1'd0;
reg tx_singleencoder1_code4b_flip = 1'd0;
reg tx_singleencoder1_alt7_rd0 = 1'd0;
reg tx_singleencoder1_alt7_rd1 = 1'd0;
reg [5:0] tx_singleencoder1_output_6b;
wire tx_singleencoder1_disp_inter;
reg [3:0] tx_singleencoder1_output_4b;
wire [9:0] tx_singleencoder1_output_msb_first;
wire [7:0] tx_singleencoder2_d;
wire tx_singleencoder2_k;
wire tx_singleencoder2_disp_in;
reg [9:0] tx_singleencoder2_output;
reg tx_singleencoder2_disp_out;
reg [5:0] tx_singleencoder2_code6b = 6'd0;
reg tx_singleencoder2_code6b_unbalanced = 1'd0;
reg tx_singleencoder2_code6b_flip = 1'd0;
reg [3:0] tx_singleencoder2_code4b = 4'd0;
reg tx_singleencoder2_code4b_unbalanced = 1'd0;
reg tx_singleencoder2_code4b_flip = 1'd0;
reg tx_singleencoder2_alt7_rd0 = 1'd0;
reg tx_singleencoder2_alt7_rd1 = 1'd0;
reg [5:0] tx_singleencoder2_output_6b;
wire tx_singleencoder2_disp_inter;
reg [3:0] tx_singleencoder2_output_4b;
wire [9:0] tx_singleencoder2_output_msb_first;
wire [7:0] tx_singleencoder3_d;
wire tx_singleencoder3_k;
wire tx_singleencoder3_disp_in;
reg [9:0] tx_singleencoder3_output;
reg tx_singleencoder3_disp_out;
reg [5:0] tx_singleencoder3_code6b = 6'd0;
reg tx_singleencoder3_code6b_unbalanced = 1'd0;
reg tx_singleencoder3_code6b_flip = 1'd0;
reg [3:0] tx_singleencoder3_code4b = 4'd0;
reg tx_singleencoder3_code4b_unbalanced = 1'd0;
reg tx_singleencoder3_code4b_flip = 1'd0;
reg tx_singleencoder3_alt7_rd0 = 1'd0;
reg tx_singleencoder3_alt7_rd1 = 1'd0;
reg [5:0] tx_singleencoder3_output_6b;
wire tx_singleencoder3_disp_inter;
reg [3:0] tx_singleencoder3_output_4b;
wire [9:0] tx_singleencoder3_output_msb_first;
reg [31:0] tx_crc_encoder_i_data_payload;
reg tx_crc_encoder_i_data_strobe;
wire tx_crc_encoder_reset;
wire [19:0] tx_crc_encoder_o_crc;
wire [31:0] tx_crc_encoder_crc_dat;
reg [19:0] tx_crc_encoder_crc_cur = 20'd1048575;
reg [19:0] tx_crc_encoder_crc_next;
wire tx_stream_controller_link_ready;
wire tx_stream_controller_fifo_empty;
wire [1:0] tx_stream_controller_data_type;
wire tx_stream_controller_tx_init_done;
reg tx_stream_controller_sop = 1'd0;
reg tx_stream_controller_eop = 1'd0;
reg tx_stream_controller_ign;
reg tx_stream_controller_idle = 1'd0;
reg tx_stream_controller_intermediate = 1'd0;
reg tx_stream_controller_encoder_ready = 1'd0;
reg tx_stream_controller_fifo_re = 1'd0;
reg tx_stream_controller_strobe_crc = 1'd0;
reg tx_stream_controller_reset_crc = 1'd0;
reg tx_stream_controller_aux_ign = 1'd0;
reg tx_stream_controller_reset = 1'd0;
wire tx_tx_init_done1;
wire tx_fifo_empty1;
wire [39:0] rx_rx_data_in;
wire rx_rx_init_done;
wire rx_trans_en0;
reg rx_tx_serial0;
wire [9:0] rx_decoder1_input;
wire [7:0] rx_decoder1_d;
reg rx_decoder1_k = 1'd0;
wire rx_decoder1_invalid;
reg [9:0] rx_decoder1_input_msb_first;
wire [4:0] rx_decoder1_code5b;
reg [2:0] rx_decoder1_code3b = 3'd0;
wire [5:0] rx_decoder1_adr;
wire [4:0] rx_decoder1_dat_r;
reg [3:0] rx_decoder1_ones = 4'd0;
wire [9:0] rx_decoder2_input;
wire [7:0] rx_decoder2_d;
reg rx_decoder2_k = 1'd0;
wire rx_decoder2_invalid;
reg [9:0] rx_decoder2_input_msb_first;
wire [4:0] rx_decoder2_code5b;
reg [2:0] rx_decoder2_code3b = 3'd0;
wire [5:0] rx_decoder2_adr;
wire [4:0] rx_decoder2_dat_r;
reg [3:0] rx_decoder2_ones = 4'd0;
wire [9:0] rx_decoder3_input;
wire [7:0] rx_decoder3_d;
reg rx_decoder3_k = 1'd0;
wire rx_decoder3_invalid;
reg [9:0] rx_decoder3_input_msb_first;
wire [4:0] rx_decoder3_code5b;
reg [2:0] rx_decoder3_code3b = 3'd0;
wire [5:0] rx_decoder3_adr;
wire [4:0] rx_decoder3_dat_r;
reg [3:0] rx_decoder3_ones = 4'd0;
wire [9:0] rx_decoder4_input;
wire [7:0] rx_decoder4_d;
reg rx_decoder4_k = 1'd0;
wire rx_decoder4_invalid;
reg [9:0] rx_decoder4_input_msb_first;
wire [4:0] rx_decoder4_code5b;
reg [2:0] rx_decoder4_code3b = 3'd0;
wire [5:0] rx_decoder4_adr;
wire [4:0] rx_decoder4_dat_r;
reg [3:0] rx_decoder4_ones = 4'd0;
wire [31:0] rx_decoder_out;
wire [31:0] rx_data_in1;
wire rx_trans_en1;
wire rx_tx_serial1;
reg rx_tx_32bdone = 1'd0;
wire rx_fifoEmpty;
reg [4:0] rx_tx_counter = 5'd0;
reg rx_tx_serial2 = 1'd1;
reg [7:0] rx_tx_data = 8'd0;
wire rx_tx_strobe;
reg [2:0] rx_tx_bitn = 3'd0;
reg rx_tx_ready = 1'd0;
reg [7:0] rx_tx_latch = 8'd0;
reg rx_tx_done = 1'd0;
reg [3:0] rx_byte_cnt = 4'd0;
wire rx_re;
reg rx_readable = 1'd0;
reg rx_syncfifo_we;
wire rx_syncfifo_writable;
wire rx_syncfifo_re;
wire rx_syncfifo_readable;
wire [31:0] rx_syncfifo_din;
wire [31:0] rx_syncfifo_dout;
reg [4:0] rx_level0 = 5'd0;
reg rx_replace = 1'd0;
reg [4:0] rx_produce = 5'd0;
reg [4:0] rx_consume = 5'd0;
reg [4:0] rx_wrport_adr;
wire [31:0] rx_wrport_dat_r;
wire rx_wrport_we;
wire [31:0] rx_wrport_dat_w;
wire rx_do_read;
wire [4:0] rx_rdport_adr;
wire [31:0] rx_rdport_dat_r;
wire rx_rdport_re;
wire [4:0] rx_level1;
wire fifo_asyncfifo_we;
wire fifo_asyncfifo_writable;
wire fifo_asyncfifo_re;
wire fifo_asyncfifo_readable;
wire [33:0] fifo_asyncfifo_din;
wire [33:0] fifo_asyncfifo_dout;
wire fifo_graycounter0_ce;
(* no_retiming = "true" *) reg [5:0] fifo_graycounter0_q = 6'd0;
wire [5:0] fifo_graycounter0_q_next;
reg [5:0] fifo_graycounter0_q_binary = 6'd0;
reg [5:0] fifo_graycounter0_q_next_binary;
wire fifo_graycounter1_ce;
(* no_retiming = "true" *) reg [5:0] fifo_graycounter1_q = 6'd0;
wire [5:0] fifo_graycounter1_q_next;
reg [5:0] fifo_graycounter1_q_binary = 6'd0;
reg [5:0] fifo_graycounter1_q_next_binary;
wire [5:0] fifo_produce_rdomain;
wire [5:0] fifo_consume_wdomain;
wire [4:0] fifo_wrport_adr;
wire [33:0] fifo_wrport_dat_r;
wire fifo_wrport_we;
wire [33:0] fifo_wrport_dat_w;
wire [4:0] fifo_rdport_adr;
wire [33:0] fifo_rdport_dat_r;
reg [31:0] o = 32'd0;
wire enable;
reg [6:0] state = 7'd1;
reg prbs_en = 1'd0;
reg [1:0] data_type = 2'd0;
reg [2:0] index = 3'd0;
wire [1:0] i_ignored;
reg write_fifo = 1'd0;
wire tx_clk_1;
wire tx_rst;
wire rx_clk_1;
wire rx_rst;
wire write_clk_1;
wire write_rst;
reg [2:0] tx_state = 3'd0;
reg [2:0] tx_next_state;
reg tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0;
reg tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0;
reg tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1;
reg tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1;
reg tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2;
reg tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2;
reg tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value0;
reg tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value_ce0;
reg tx_stream_controller_intermediate_clockdomainsrenamer0_next_value1;
reg tx_stream_controller_intermediate_clockdomainsrenamer0_next_value_ce1;
reg tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value2;
reg tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value_ce2;
reg tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value0;
reg tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value_ce0;
reg tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value1;
reg tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value_ce1;
reg tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value2;
reg tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value_ce2;
reg [1:0] rx_fsm_state = 2'd0;
reg [1:0] rx_fsm_next_state;
reg rx_tx_ready_clockdomainsrenamer1_next_value0;
reg rx_tx_ready_clockdomainsrenamer1_next_value_ce0;
reg [7:0] rx_tx_data_clockdomainsrenamer1_next_value1;
reg rx_tx_data_clockdomainsrenamer1_next_value_ce1;
reg rx_tx_32bdone_clockdomainsrenamer1_next_value2;
reg rx_tx_32bdone_clockdomainsrenamer1_next_value_ce2;
reg [3:0] rx_byte_cnt_clockdomainsrenamer1_next_value3;
reg rx_byte_cnt_clockdomainsrenamer1_next_value_ce3;
reg [1:0] rx_tx_state = 2'd0;
reg [1:0] rx_tx_next_state;
reg [7:0] rx_tx_latch_clockdomainsrenamer1_t_next_value0;
reg rx_tx_latch_clockdomainsrenamer1_t_next_value_ce0;
reg [4:0] rx_tx_counter_clockdomainsrenamer1_t_next_value1;
reg rx_tx_counter_clockdomainsrenamer1_t_next_value_ce1;
reg rx_tx_serial2_clockdomainsrenamer1_f_next_value;
reg rx_tx_serial2_clockdomainsrenamer1_f_next_value_ce;
reg [2:0] rx_tx_bitn_clockdomainsrenamer1_t_next_value2;
reg rx_tx_bitn_clockdomainsrenamer1_t_next_value_ce2;
reg rx_tx_done_clockdomainsrenamer1_t_next_value3;
reg rx_tx_done_clockdomainsrenamer1_t_next_value_ce3;
reg [1:0] rx_state = 2'd0;
reg [1:0] rx_next_state;
reg [2:0] fsm_state = 3'd0;
reg [2:0] fsm_next_state;
reg prbs_en_clockdomainsrenamer2_next_value0;
reg prbs_en_clockdomainsrenamer2_next_value_ce0;
reg [1:0] data_type_clockdomainsrenamer2_next_value1;
reg data_type_clockdomainsrenamer2_next_value_ce1;
reg write_fifo_clockdomainsrenamer2_next_value2;
reg write_fifo_clockdomainsrenamer2_next_value_ce2;
reg [2:0] index_clockdomainsrenamer2_next_value3;
reg index_clockdomainsrenamer2_next_value_ce3;
reg [2:0] t_array_muxed0;
reg [2:0] t_array_muxed1;
reg [2:0] f_array_muxed0;
reg [2:0] t_array_muxed2;
reg [2:0] t_array_muxed3;
reg [2:0] f_array_muxed1;
reg [2:0] t_array_muxed4;
reg [2:0] t_array_muxed5;
reg [2:0] f_array_muxed2;
reg [2:0] t_array_muxed6;
reg [2:0] t_array_muxed7;
reg [2:0] f_array_muxed3;
reg [5:0] rhs_array_muxed0;
reg rhs_array_muxed1;
reg rhs_array_muxed2;
reg [3:0] rhs_array_muxed3;
reg rhs_array_muxed4;
reg rhs_array_muxed5;
reg [5:0] rhs_array_muxed6;
reg rhs_array_muxed7;
reg rhs_array_muxed8;
reg [3:0] rhs_array_muxed9;
reg rhs_array_muxed10;
reg rhs_array_muxed11;
reg [5:0] rhs_array_muxed12;
reg rhs_array_muxed13;
reg rhs_array_muxed14;
reg [3:0] rhs_array_muxed15;
reg rhs_array_muxed16;
reg rhs_array_muxed17;
reg [5:0] rhs_array_muxed18;
reg rhs_array_muxed19;
reg rhs_array_muxed20;
reg [3:0] rhs_array_muxed21;
reg rhs_array_muxed22;
reg rhs_array_muxed23;
(* no_retiming = "true" *) reg multiregimpl0_regs0 = 1'd0;
(* no_retiming = "true" *) reg multiregimpl0_regs1 = 1'd0;
(* no_retiming = "true" *) reg multiregimpl1_regs0 = 1'd0;
(* no_retiming = "true" *) reg multiregimpl1_regs1 = 1'd0;
(* no_retiming = "true" *) reg [5:0] multiregimpl2_regs0 = 6'd0;
(* no_retiming = "true" *) reg [5:0] multiregimpl2_regs1 = 6'd0;
(* no_retiming = "true" *) reg [5:0] multiregimpl3_regs0 = 6'd0;
(* no_retiming = "true" *) reg [5:0] multiregimpl3_regs1 = 6'd0;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign i_ignored = 2'd2;
assign fifo_asyncfifo_din = {data_type, o};
assign enable = prbs_en;
assign fifo_asyncfifo_we = write_fifo;
assign fifo_asyncfifo_re = tx_fifo_re;
assign tx_link_ready = link_ready;
assign tx_fifo_empty0 = (~fifo_asyncfifo_readable);
assign tx_tx_init_done0 = tx_init_done;

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	tx_data_in <= 32'd0;
	tx_data_type_in <= 2'd0;
	if ((link_ready & fifo_asyncfifo_readable)) begin
		tx_data_type_in <= fifo_asyncfifo_dout[33:32];
		tx_data_in <= fifo_asyncfifo_dout[31:0];
	end
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end
assign tx_data_out = tx_data_out1;
assign rx_rx_data_in = rx_data_in;
assign rx_rx_init_done = rx_init_done;
assign rx_trans_en0 = trans_en;
assign tx_rst = reset;
assign tx_clk_1 = tx_clk;
assign rx_rst = reset;
assign rx_clk_1 = rx_clk;
assign write_clk_1 = write_clk;
assign write_rst = reset;
assign fifo_graycounter0_ce = (fifo_asyncfifo_writable & fifo_asyncfifo_we);
assign fifo_graycounter1_ce = (fifo_asyncfifo_readable & fifo_asyncfifo_re);
assign fifo_asyncfifo_writable = (((fifo_graycounter0_q[5] == fifo_consume_wdomain[5]) | (fifo_graycounter0_q[4] == fifo_consume_wdomain[4])) | (fifo_graycounter0_q[3:0] != fifo_consume_wdomain[3:0]));
assign fifo_asyncfifo_readable = (fifo_graycounter1_q != fifo_produce_rdomain);
assign fifo_wrport_adr = fifo_graycounter0_q_binary[4:0];
assign fifo_wrport_dat_w = fifo_asyncfifo_din;
assign fifo_wrport_we = fifo_graycounter0_ce;
assign fifo_rdport_adr = fifo_graycounter1_q_next_binary[4:0];
assign fifo_asyncfifo_dout = fifo_rdport_dat_r;

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	fifo_graycounter0_q_next_binary <= 6'd0;
	if (fifo_graycounter0_ce) begin
		fifo_graycounter0_q_next_binary <= (fifo_graycounter0_q_binary + 1'd1);
	end else begin
		fifo_graycounter0_q_next_binary <= fifo_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end
assign fifo_graycounter0_q_next = (fifo_graycounter0_q_next_binary ^ fifo_graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	fifo_graycounter1_q_next_binary <= 6'd0;
	if (fifo_graycounter1_ce) begin
		fifo_graycounter1_q_next_binary <= (fifo_graycounter1_q_binary + 1'd1);
	end else begin
		fifo_graycounter1_q_next_binary <= fifo_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end
assign fifo_graycounter1_q_next = (fifo_graycounter1_q_next_binary ^ fifo_graycounter1_q_next_binary[5:1]);
assign tx_stream_controller_link_ready = tx_link_ready;
assign tx_stream_controller_fifo_empty = tx_fifo_empty1;
assign tx_stream_controller_data_type = tx_data_type_in;
assign tx_stream_controller_tx_init_done = tx_tx_init_done1;
assign tx_fifo_re = tx_stream_controller_fifo_re;

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	tx_crc_encoder_i_data_strobe <= 1'd0;
	if ((tx_data_type_in != 2'd3)) begin
		tx_crc_encoder_i_data_strobe <= tx_stream_controller_strobe_crc;
	end
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end
assign tx_crc_encoder_reset = tx_stream_controller_reset_crc;

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	tx_crc_encoder_i_data_payload <= 32'd0;
	if (tx_stream_controller_encoder_ready) begin
		tx_crc_encoder_i_data_payload <= tx_data_in;
	end
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	tx_data_out1 <= 40'd0;
	if (tx_stream_controller_encoder_ready) begin
		tx_data_out1 <= {tx_output3, tx_output2, tx_output1, tx_output0};
	end else begin
		tx_data_out1 <= 1'd0;
	end
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	tx_d0 <= 8'd0;
	tx_d1 <= 8'd0;
	tx_d2 <= 8'd0;
	tx_d3 <= 8'd0;
	tx_k0 <= 1'd0;
	if (tx_stream_controller_idle) begin
		tx_d0 <= 8'd188;
		tx_k0 <= 1'd1;
		tx_d1 <= 1'd0;
		tx_d2 <= 1'd0;
		tx_d3 <= 1'd0;
	end
	if (tx_stream_controller_sop) begin
		tx_d0 <= 6'd60;
		tx_k0 <= 1'd1;
		tx_d1 <= 1'd0;
		tx_d2 <= 1'd0;
		tx_d3 <= 1'd0;
	end
	if (tx_stream_controller_intermediate) begin
		tx_d0 <= tx_data_in[7:0];
		tx_d1 <= tx_data_in[15:8];
		tx_d2 <= tx_data_in[23:16];
		tx_d3 <= tx_data_in[31:24];
	end
	if (tx_stream_controller_ign) begin
		tx_d0 <= 7'd92;
		tx_k0 <= 1'd1;
		tx_d1 <= 1'd0;
		tx_d2 <= 1'd0;
		tx_d3 <= 1'd0;
	end
	if (tx_stream_controller_eop) begin
		tx_d0 <= 8'd220;
		tx_k0 <= 1'd1;
		tx_d1 <= tx_crc_encoder_o_crc[7:0];
		tx_d2 <= tx_crc_encoder_o_crc[15:8];
		tx_d3 <= tx_crc_encoder_o_crc[19:16];
	end
	if (((((~tx_stream_controller_idle) & (~tx_stream_controller_eop)) & (~tx_stream_controller_sop)) & (~tx_stream_controller_ign))) begin
		tx_k0 <= 1'd0;
	end
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end
assign tx_k1 = 1'd0;
assign tx_k2 = 1'd0;
assign tx_k3 = 1'd0;
assign tx_singleencoder1_disp_in = tx_singleencoder0_disp_out;
assign tx_singleencoder2_disp_in = tx_singleencoder1_disp_out;
assign tx_singleencoder3_disp_in = tx_singleencoder2_disp_out;
assign tx_singleencoder0_d = tx_d0;
assign tx_singleencoder0_k = tx_k0;
assign tx_singleencoder1_d = tx_d1;
assign tx_singleencoder1_k = tx_k1;
assign tx_singleencoder2_d = tx_d2;
assign tx_singleencoder2_k = tx_k2;
assign tx_singleencoder3_d = tx_d3;
assign tx_singleencoder3_k = tx_k3;
assign tx_singleencoder0_disp_inter = (tx_singleencoder0_disp_in ^ tx_singleencoder0_code6b_unbalanced);

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	tx_singleencoder0_output_6b <= 6'd0;
	if (((~tx_singleencoder0_disp_in) & tx_singleencoder0_code6b_flip)) begin
		tx_singleencoder0_output_6b <= (~tx_singleencoder0_code6b);
	end else begin
		tx_singleencoder0_output_6b <= tx_singleencoder0_code6b;
	end
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	tx_singleencoder0_disp_out <= 1'd0;
	tx_singleencoder0_output_4b <= 4'd0;
	if (((~tx_singleencoder0_disp_inter) & tx_singleencoder0_alt7_rd0)) begin
		tx_singleencoder0_disp_out <= (~tx_singleencoder0_disp_inter);
		tx_singleencoder0_output_4b <= 3'd7;
	end else begin
		if ((tx_singleencoder0_disp_inter & tx_singleencoder0_alt7_rd1)) begin
			tx_singleencoder0_disp_out <= (~tx_singleencoder0_disp_inter);
			tx_singleencoder0_output_4b <= 4'd8;
		end else begin
			tx_singleencoder0_disp_out <= (tx_singleencoder0_disp_inter ^ tx_singleencoder0_code4b_unbalanced);
			if (((~tx_singleencoder0_disp_inter) & tx_singleencoder0_code4b_flip)) begin
				tx_singleencoder0_output_4b <= (~tx_singleencoder0_code4b);
			end else begin
				tx_singleencoder0_output_4b <= tx_singleencoder0_code4b;
			end
		end
	end
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end
assign tx_singleencoder0_output_msb_first = {tx_singleencoder0_output_6b, tx_singleencoder0_output_4b};

// synthesis translate_off
reg dummy_d_9;
// synthesis translate_on
always @(*) begin
	tx_singleencoder0_output <= 10'd0;
	tx_singleencoder0_output[0] <= tx_singleencoder0_output_msb_first[9];
	tx_singleencoder0_output[1] <= tx_singleencoder0_output_msb_first[8];
	tx_singleencoder0_output[2] <= tx_singleencoder0_output_msb_first[7];
	tx_singleencoder0_output[3] <= tx_singleencoder0_output_msb_first[6];
	tx_singleencoder0_output[4] <= tx_singleencoder0_output_msb_first[5];
	tx_singleencoder0_output[5] <= tx_singleencoder0_output_msb_first[4];
	tx_singleencoder0_output[6] <= tx_singleencoder0_output_msb_first[3];
	tx_singleencoder0_output[7] <= tx_singleencoder0_output_msb_first[2];
	tx_singleencoder0_output[8] <= tx_singleencoder0_output_msb_first[1];
	tx_singleencoder0_output[9] <= tx_singleencoder0_output_msb_first[0];
// synthesis translate_off
	dummy_d_9 <= dummy_s;
// synthesis translate_on
end
assign tx_singleencoder1_disp_inter = (tx_singleencoder1_disp_in ^ tx_singleencoder1_code6b_unbalanced);

// synthesis translate_off
reg dummy_d_10;
// synthesis translate_on
always @(*) begin
	tx_singleencoder1_output_6b <= 6'd0;
	if (((~tx_singleencoder1_disp_in) & tx_singleencoder1_code6b_flip)) begin
		tx_singleencoder1_output_6b <= (~tx_singleencoder1_code6b);
	end else begin
		tx_singleencoder1_output_6b <= tx_singleencoder1_code6b;
	end
// synthesis translate_off
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_11;
// synthesis translate_on
always @(*) begin
	tx_singleencoder1_disp_out <= 1'd0;
	tx_singleencoder1_output_4b <= 4'd0;
	if (((~tx_singleencoder1_disp_inter) & tx_singleencoder1_alt7_rd0)) begin
		tx_singleencoder1_disp_out <= (~tx_singleencoder1_disp_inter);
		tx_singleencoder1_output_4b <= 3'd7;
	end else begin
		if ((tx_singleencoder1_disp_inter & tx_singleencoder1_alt7_rd1)) begin
			tx_singleencoder1_disp_out <= (~tx_singleencoder1_disp_inter);
			tx_singleencoder1_output_4b <= 4'd8;
		end else begin
			tx_singleencoder1_disp_out <= (tx_singleencoder1_disp_inter ^ tx_singleencoder1_code4b_unbalanced);
			if (((~tx_singleencoder1_disp_inter) & tx_singleencoder1_code4b_flip)) begin
				tx_singleencoder1_output_4b <= (~tx_singleencoder1_code4b);
			end else begin
				tx_singleencoder1_output_4b <= tx_singleencoder1_code4b;
			end
		end
	end
// synthesis translate_off
	dummy_d_11 <= dummy_s;
// synthesis translate_on
end
assign tx_singleencoder1_output_msb_first = {tx_singleencoder1_output_6b, tx_singleencoder1_output_4b};

// synthesis translate_off
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	tx_singleencoder1_output <= 10'd0;
	tx_singleencoder1_output[0] <= tx_singleencoder1_output_msb_first[9];
	tx_singleencoder1_output[1] <= tx_singleencoder1_output_msb_first[8];
	tx_singleencoder1_output[2] <= tx_singleencoder1_output_msb_first[7];
	tx_singleencoder1_output[3] <= tx_singleencoder1_output_msb_first[6];
	tx_singleencoder1_output[4] <= tx_singleencoder1_output_msb_first[5];
	tx_singleencoder1_output[5] <= tx_singleencoder1_output_msb_first[4];
	tx_singleencoder1_output[6] <= tx_singleencoder1_output_msb_first[3];
	tx_singleencoder1_output[7] <= tx_singleencoder1_output_msb_first[2];
	tx_singleencoder1_output[8] <= tx_singleencoder1_output_msb_first[1];
	tx_singleencoder1_output[9] <= tx_singleencoder1_output_msb_first[0];
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end
assign tx_singleencoder2_disp_inter = (tx_singleencoder2_disp_in ^ tx_singleencoder2_code6b_unbalanced);

// synthesis translate_off
reg dummy_d_13;
// synthesis translate_on
always @(*) begin
	tx_singleencoder2_output_6b <= 6'd0;
	if (((~tx_singleencoder2_disp_in) & tx_singleencoder2_code6b_flip)) begin
		tx_singleencoder2_output_6b <= (~tx_singleencoder2_code6b);
	end else begin
		tx_singleencoder2_output_6b <= tx_singleencoder2_code6b;
	end
// synthesis translate_off
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_14;
// synthesis translate_on
always @(*) begin
	tx_singleencoder2_disp_out <= 1'd0;
	tx_singleencoder2_output_4b <= 4'd0;
	if (((~tx_singleencoder2_disp_inter) & tx_singleencoder2_alt7_rd0)) begin
		tx_singleencoder2_disp_out <= (~tx_singleencoder2_disp_inter);
		tx_singleencoder2_output_4b <= 3'd7;
	end else begin
		if ((tx_singleencoder2_disp_inter & tx_singleencoder2_alt7_rd1)) begin
			tx_singleencoder2_disp_out <= (~tx_singleencoder2_disp_inter);
			tx_singleencoder2_output_4b <= 4'd8;
		end else begin
			tx_singleencoder2_disp_out <= (tx_singleencoder2_disp_inter ^ tx_singleencoder2_code4b_unbalanced);
			if (((~tx_singleencoder2_disp_inter) & tx_singleencoder2_code4b_flip)) begin
				tx_singleencoder2_output_4b <= (~tx_singleencoder2_code4b);
			end else begin
				tx_singleencoder2_output_4b <= tx_singleencoder2_code4b;
			end
		end
	end
// synthesis translate_off
	dummy_d_14 <= dummy_s;
// synthesis translate_on
end
assign tx_singleencoder2_output_msb_first = {tx_singleencoder2_output_6b, tx_singleencoder2_output_4b};

// synthesis translate_off
reg dummy_d_15;
// synthesis translate_on
always @(*) begin
	tx_singleencoder2_output <= 10'd0;
	tx_singleencoder2_output[0] <= tx_singleencoder2_output_msb_first[9];
	tx_singleencoder2_output[1] <= tx_singleencoder2_output_msb_first[8];
	tx_singleencoder2_output[2] <= tx_singleencoder2_output_msb_first[7];
	tx_singleencoder2_output[3] <= tx_singleencoder2_output_msb_first[6];
	tx_singleencoder2_output[4] <= tx_singleencoder2_output_msb_first[5];
	tx_singleencoder2_output[5] <= tx_singleencoder2_output_msb_first[4];
	tx_singleencoder2_output[6] <= tx_singleencoder2_output_msb_first[3];
	tx_singleencoder2_output[7] <= tx_singleencoder2_output_msb_first[2];
	tx_singleencoder2_output[8] <= tx_singleencoder2_output_msb_first[1];
	tx_singleencoder2_output[9] <= tx_singleencoder2_output_msb_first[0];
// synthesis translate_off
	dummy_d_15 <= dummy_s;
// synthesis translate_on
end
assign tx_singleencoder3_disp_inter = (tx_singleencoder3_disp_in ^ tx_singleencoder3_code6b_unbalanced);

// synthesis translate_off
reg dummy_d_16;
// synthesis translate_on
always @(*) begin
	tx_singleencoder3_output_6b <= 6'd0;
	if (((~tx_singleencoder3_disp_in) & tx_singleencoder3_code6b_flip)) begin
		tx_singleencoder3_output_6b <= (~tx_singleencoder3_code6b);
	end else begin
		tx_singleencoder3_output_6b <= tx_singleencoder3_code6b;
	end
// synthesis translate_off
	dummy_d_16 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_17;
// synthesis translate_on
always @(*) begin
	tx_singleencoder3_disp_out <= 1'd0;
	tx_singleencoder3_output_4b <= 4'd0;
	if (((~tx_singleencoder3_disp_inter) & tx_singleencoder3_alt7_rd0)) begin
		tx_singleencoder3_disp_out <= (~tx_singleencoder3_disp_inter);
		tx_singleencoder3_output_4b <= 3'd7;
	end else begin
		if ((tx_singleencoder3_disp_inter & tx_singleencoder3_alt7_rd1)) begin
			tx_singleencoder3_disp_out <= (~tx_singleencoder3_disp_inter);
			tx_singleencoder3_output_4b <= 4'd8;
		end else begin
			tx_singleencoder3_disp_out <= (tx_singleencoder3_disp_inter ^ tx_singleencoder3_code4b_unbalanced);
			if (((~tx_singleencoder3_disp_inter) & tx_singleencoder3_code4b_flip)) begin
				tx_singleencoder3_output_4b <= (~tx_singleencoder3_code4b);
			end else begin
				tx_singleencoder3_output_4b <= tx_singleencoder3_code4b;
			end
		end
	end
// synthesis translate_off
	dummy_d_17 <= dummy_s;
// synthesis translate_on
end
assign tx_singleencoder3_output_msb_first = {tx_singleencoder3_output_6b, tx_singleencoder3_output_4b};

// synthesis translate_off
reg dummy_d_18;
// synthesis translate_on
always @(*) begin
	tx_singleencoder3_output <= 10'd0;
	tx_singleencoder3_output[0] <= tx_singleencoder3_output_msb_first[9];
	tx_singleencoder3_output[1] <= tx_singleencoder3_output_msb_first[8];
	tx_singleencoder3_output[2] <= tx_singleencoder3_output_msb_first[7];
	tx_singleencoder3_output[3] <= tx_singleencoder3_output_msb_first[6];
	tx_singleencoder3_output[4] <= tx_singleencoder3_output_msb_first[5];
	tx_singleencoder3_output[5] <= tx_singleencoder3_output_msb_first[4];
	tx_singleencoder3_output[6] <= tx_singleencoder3_output_msb_first[3];
	tx_singleencoder3_output[7] <= tx_singleencoder3_output_msb_first[2];
	tx_singleencoder3_output[8] <= tx_singleencoder3_output_msb_first[1];
	tx_singleencoder3_output[9] <= tx_singleencoder3_output_msb_first[0];
// synthesis translate_off
	dummy_d_18 <= dummy_s;
// synthesis translate_on
end
assign tx_crc_encoder_crc_dat = tx_crc_encoder_i_data_payload;
assign tx_crc_encoder_o_crc = tx_crc_encoder_crc_cur;

// synthesis translate_off
reg dummy_d_19;
// synthesis translate_on
always @(*) begin
	tx_crc_encoder_crc_next <= 20'd597792;
	tx_crc_encoder_crc_next[0] <= (((((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[13]) ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[27]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[15]);
	tx_crc_encoder_crc_next[1] <= (((((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[14]) ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[27]) ^ tx_crc_encoder_crc_dat[28]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[15]) ^ tx_crc_encoder_crc_cur[16]);
	tx_crc_encoder_crc_next[2] <= (((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[28]) ^ tx_crc_encoder_crc_dat[29]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[16]) ^ tx_crc_encoder_crc_cur[17]);
	tx_crc_encoder_crc_next[3] <= (((((((((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[27]) ^ tx_crc_encoder_crc_dat[29]) ^ tx_crc_encoder_crc_dat[30]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[15]) ^ tx_crc_encoder_crc_cur[17]) ^ tx_crc_encoder_crc_cur[18]);
	tx_crc_encoder_crc_next[4] <= (((((((((((((((((((((((tx_crc_encoder_crc_dat[13] ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[28]) ^ tx_crc_encoder_crc_dat[30]) ^ tx_crc_encoder_crc_dat[31]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[16]) ^ tx_crc_encoder_crc_cur[18]) ^ tx_crc_encoder_crc_cur[19]);
	tx_crc_encoder_crc_next[5] <= (((((((((((((((((((((tx_crc_encoder_crc_dat[14] ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[29]) ^ tx_crc_encoder_crc_dat[31]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[17]) ^ tx_crc_encoder_crc_cur[19]);
	tx_crc_encoder_crc_next[6] <= (((((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[13]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[30]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[18]);
	tx_crc_encoder_crc_next[7] <= (((((((((((((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[14]) ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[31]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[19]);
	tx_crc_encoder_crc_next[8] <= (((((((((((((((((((((((((tx_crc_encoder_crc_dat[13] ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[27]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[15]);
	tx_crc_encoder_crc_next[9] <= (((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[13]) ^ tx_crc_encoder_crc_dat[14]) ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[28]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[16]);
	tx_crc_encoder_crc_next[10] <= (((((((((((((((((tx_crc_encoder_crc_dat[13] ^ tx_crc_encoder_crc_dat[14]) ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[29]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[17]);
	tx_crc_encoder_crc_next[11] <= (((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[13]) ^ tx_crc_encoder_crc_dat[14]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[27]) ^ tx_crc_encoder_crc_dat[30]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[15]) ^ tx_crc_encoder_crc_cur[18]);
	tx_crc_encoder_crc_next[12] <= (((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[14]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[27]) ^ tx_crc_encoder_crc_dat[28]) ^ tx_crc_encoder_crc_dat[31]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[15]) ^ tx_crc_encoder_crc_cur[16]) ^ tx_crc_encoder_crc_cur[19]);
	tx_crc_encoder_crc_next[13] <= (((((((((((((((tx_crc_encoder_crc_dat[13] ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[28]) ^ tx_crc_encoder_crc_dat[29]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[16]) ^ tx_crc_encoder_crc_cur[17]);
	tx_crc_encoder_crc_next[14] <= (((((((((((((((tx_crc_encoder_crc_dat[14] ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[27]) ^ tx_crc_encoder_crc_dat[29]) ^ tx_crc_encoder_crc_dat[30]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[15]) ^ tx_crc_encoder_crc_cur[17]) ^ tx_crc_encoder_crc_cur[18]);
	tx_crc_encoder_crc_next[15] <= (((((((((((((((tx_crc_encoder_crc_dat[15] ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[28]) ^ tx_crc_encoder_crc_dat[30]) ^ tx_crc_encoder_crc_dat[31]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[16]) ^ tx_crc_encoder_crc_cur[18]) ^ tx_crc_encoder_crc_cur[19]);
	tx_crc_encoder_crc_next[16] <= (((((((((((((tx_crc_encoder_crc_dat[16] ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[20]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[29]) ^ tx_crc_encoder_crc_dat[31]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[8]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[17]) ^ tx_crc_encoder_crc_cur[19]);
	tx_crc_encoder_crc_next[17] <= (((((((((((tx_crc_encoder_crc_dat[17] ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[21]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[30]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[9]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[18]);
	tx_crc_encoder_crc_next[18] <= (((((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[13]) ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[16]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[22]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[25]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_dat[31]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[1]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[4]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[10]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[13]) ^ tx_crc_encoder_crc_cur[14]) ^ tx_crc_encoder_crc_cur[19]);
	tx_crc_encoder_crc_next[19] <= (((((((((((((((((tx_crc_encoder_crc_dat[12] ^ tx_crc_encoder_crc_dat[14]) ^ tx_crc_encoder_crc_dat[15]) ^ tx_crc_encoder_crc_dat[17]) ^ tx_crc_encoder_crc_dat[18]) ^ tx_crc_encoder_crc_dat[19]) ^ tx_crc_encoder_crc_dat[23]) ^ tx_crc_encoder_crc_dat[24]) ^ tx_crc_encoder_crc_dat[26]) ^ tx_crc_encoder_crc_cur[0]) ^ tx_crc_encoder_crc_cur[2]) ^ tx_crc_encoder_crc_cur[3]) ^ tx_crc_encoder_crc_cur[5]) ^ tx_crc_encoder_crc_cur[6]) ^ tx_crc_encoder_crc_cur[7]) ^ tx_crc_encoder_crc_cur[11]) ^ tx_crc_encoder_crc_cur[12]) ^ tx_crc_encoder_crc_cur[14]);
// synthesis translate_off
	dummy_d_19 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_20;
// synthesis translate_on
always @(*) begin
	tx_stream_controller_ign <= 1'd0;
	tx_next_state <= 3'd0;
	tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd0;
	tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd0;
	tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1 <= 1'd0;
	tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1 <= 1'd0;
	tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2 <= 1'd0;
	tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2 <= 1'd0;
	tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value0 <= 1'd0;
	tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value_ce0 <= 1'd0;
	tx_stream_controller_intermediate_clockdomainsrenamer0_next_value1 <= 1'd0;
	tx_stream_controller_intermediate_clockdomainsrenamer0_next_value_ce1 <= 1'd0;
	tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value2 <= 1'd0;
	tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value_ce2 <= 1'd0;
	tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value0 <= 1'd0;
	tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value_ce0 <= 1'd0;
	tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value1 <= 1'd0;
	tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value_ce1 <= 1'd0;
	tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value2 <= 1'd0;
	tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value_ce2 <= 1'd0;
	tx_next_state <= tx_state;
	case (tx_state)
		1'd1: begin
			tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value0 <= 1'd1;
			tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value_ce0 <= 1'd1;
			if (tx_stream_controller_fifo_empty) begin
				tx_next_state <= 1'd1;
			end else begin
				if ((tx_stream_controller_link_ready & (tx_stream_controller_data_type == 1'd1))) begin
					tx_next_state <= 2'd2;
					tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd1;
					tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
					tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1 <= 1'd1;
					tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1 <= 1'd1;
					tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2 <= 1'd0;
					tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2 <= 1'd1;
				end
			end
		end
		2'd2: begin
			tx_next_state <= 2'd3;
			tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value0 <= 1'd1;
			tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value_ce0 <= 1'd1;
			tx_stream_controller_intermediate_clockdomainsrenamer0_next_value1 <= 1'd1;
			tx_stream_controller_intermediate_clockdomainsrenamer0_next_value_ce1 <= 1'd1;
			tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd1;
			tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
			tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1 <= 1'd0;
			tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1 <= 1'd1;
			tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value2 <= 1'd1;
			tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value_ce2 <= 1'd1;
		end
		2'd3: begin
			if (tx_stream_controller_fifo_empty) begin
				tx_next_state <= 1'd0;
			end else begin
				tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd1;
				tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
			end
			if ((~tx_stream_controller_fifo_empty)) begin
				case (tx_stream_controller_data_type)
					1'd0: begin
						tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value0 <= 1'd1;
						tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value_ce0 <= 1'd1;
						tx_stream_controller_intermediate_clockdomainsrenamer0_next_value1 <= 1'd1;
						tx_stream_controller_intermediate_clockdomainsrenamer0_next_value_ce1 <= 1'd1;
						tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value2 <= 1'd1;
						tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value_ce2 <= 1'd1;
						tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd1;
						tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
						tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value0 <= 1'd0;
						tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value_ce0 <= 1'd1;
					end
					1'd1: begin
						tx_next_state <= 2'd2;
						tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd1;
						tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
						tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1 <= 1'd1;
						tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1 <= 1'd1;
					end
					2'd2: begin
						tx_next_state <= 3'd4;
						tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value1 <= 1'd1;
						tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value_ce1 <= 1'd1;
						tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value2 <= 1'd0;
						tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value_ce2 <= 1'd1;
						tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value2 <= 1'd1;
						tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value_ce2 <= 1'd1;
						tx_stream_controller_intermediate_clockdomainsrenamer0_next_value1 <= 1'd0;
						tx_stream_controller_intermediate_clockdomainsrenamer0_next_value_ce1 <= 1'd1;
						tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value0 <= 1'd0;
						tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value_ce0 <= 1'd1;
					end
					2'd3: begin
						tx_next_state <= 2'd3;
						tx_stream_controller_ign <= 1'd1;
					end
				endcase
			end
		end
		3'd4: begin
			tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value1 <= 1'd0;
			tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value_ce1 <= 1'd1;
			tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value2 <= 1'd0;
			tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value_ce2 <= 1'd1;
			if (((~tx_stream_controller_fifo_empty) & (tx_stream_controller_data_type == 1'd1))) begin
				tx_next_state <= 2'd2;
				tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd1;
				tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
				tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1 <= 1'd1;
				tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1 <= 1'd1;
			end else begin
				tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2 <= 1'd1;
				tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2 <= 1'd1;
				tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd0;
				tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
				tx_next_state <= 1'd1;
			end
		end
		default: begin
			if (tx_stream_controller_tx_init_done) begin
				if (tx_stream_controller_link_ready) begin
					if (((tx_stream_controller_link_ready & (~tx_stream_controller_fifo_empty)) & (tx_stream_controller_data_type == 1'd1))) begin
						tx_next_state <= 2'd2;
						tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0 <= 1'd1;
						tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0 <= 1'd1;
						tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1 <= 1'd1;
						tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1 <= 1'd1;
						tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2 <= 1'd0;
						tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2 <= 1'd1;
					end else begin
						tx_next_state <= 1'd1;
						tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2 <= 1'd1;
						tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2 <= 1'd1;
					end
				end else begin
					tx_next_state <= 1'd1;
					tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2 <= 1'd1;
					tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2 <= 1'd1;
				end
			end else begin
				tx_next_state <= 1'd0;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_20 <= dummy_s;
// synthesis translate_on
end
assign rx_decoder1_input = rx_rx_data_in[9:0];
assign rx_decoder2_input = rx_rx_data_in[19:10];
assign rx_decoder3_input = rx_rx_data_in[29:20];
assign rx_decoder4_input = rx_rx_data_in[39:30];
assign rx_decoder_out = {rx_decoder4_d, rx_decoder3_d, rx_decoder2_d, rx_decoder1_d};
assign rx_syncfifo_din = rx_decoder_out;
assign rx_re = rx_tx_32bdone;
assign rx_data_in1 = rx_syncfifo_dout;

// synthesis translate_off
reg dummy_d_21;
// synthesis translate_on
always @(*) begin
	rx_tx_serial0 <= 1'd0;
	rx_tx_serial0 <= tx_serial;
	rx_tx_serial0 <= rx_tx_serial1;
// synthesis translate_off
	dummy_d_21 <= dummy_s;
// synthesis translate_on
end
assign rx_trans_en1 = rx_trans_en0;
assign rx_fifoEmpty = (~rx_readable);
assign rx_tx_serial1 = rx_tx_serial2;

// synthesis translate_off
reg dummy_d_22;
// synthesis translate_on
always @(*) begin
	rx_fsm_next_state <= 2'd0;
	rx_tx_ready_clockdomainsrenamer1_next_value0 <= 1'd0;
	rx_tx_ready_clockdomainsrenamer1_next_value_ce0 <= 1'd0;
	rx_tx_data_clockdomainsrenamer1_next_value1 <= 8'd0;
	rx_tx_data_clockdomainsrenamer1_next_value_ce1 <= 1'd0;
	rx_tx_32bdone_clockdomainsrenamer1_next_value2 <= 1'd0;
	rx_tx_32bdone_clockdomainsrenamer1_next_value_ce2 <= 1'd0;
	rx_byte_cnt_clockdomainsrenamer1_next_value3 <= 4'd0;
	rx_byte_cnt_clockdomainsrenamer1_next_value_ce3 <= 1'd0;
	rx_fsm_next_state <= rx_fsm_state;
	case (rx_fsm_state)
		1'd1: begin
			if (rx_tx_done) begin
				rx_byte_cnt_clockdomainsrenamer1_next_value3 <= (rx_byte_cnt + 1'd1);
				rx_byte_cnt_clockdomainsrenamer1_next_value_ce3 <= 1'd1;
				if ((rx_byte_cnt < 2'd3)) begin
					rx_tx_ready_clockdomainsrenamer1_next_value0 <= 1'd1;
					rx_tx_ready_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
					rx_fsm_next_state <= 2'd2;
				end else begin
					rx_fsm_next_state <= 1'd0;
					rx_tx_32bdone_clockdomainsrenamer1_next_value2 <= 1'd1;
					rx_tx_32bdone_clockdomainsrenamer1_next_value_ce2 <= 1'd1;
					rx_tx_ready_clockdomainsrenamer1_next_value0 <= 1'd0;
					rx_tx_ready_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
					rx_byte_cnt_clockdomainsrenamer1_next_value3 <= 1'd0;
					rx_byte_cnt_clockdomainsrenamer1_next_value_ce3 <= 1'd1;
				end
			end
		end
		2'd2: begin
			case (rx_byte_cnt)
				1'd1: begin
					rx_tx_data_clockdomainsrenamer1_next_value1 <= rx_data_in1[15:8];
					rx_tx_data_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
				end
				2'd2: begin
					rx_tx_data_clockdomainsrenamer1_next_value1 <= rx_data_in1[23:16];
					rx_tx_data_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
				end
				2'd3: begin
					rx_tx_data_clockdomainsrenamer1_next_value1 <= rx_data_in1[31:24];
					rx_tx_data_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
				end
			endcase
			if ((~rx_tx_done)) begin
				rx_fsm_next_state <= 1'd1;
			end
		end
		default: begin
			if (((rx_trans_en1 & (~rx_tx_done)) & (~rx_fifoEmpty))) begin
				rx_fsm_next_state <= 1'd1;
				rx_tx_ready_clockdomainsrenamer1_next_value0 <= 1'd1;
				rx_tx_ready_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
				rx_tx_data_clockdomainsrenamer1_next_value1 <= rx_data_in1[7:0];
				rx_tx_data_clockdomainsrenamer1_next_value_ce1 <= 1'd1;
			end else begin
				rx_fsm_next_state <= 1'd0;
				rx_tx_ready_clockdomainsrenamer1_next_value0 <= 1'd0;
				rx_tx_ready_clockdomainsrenamer1_next_value_ce0 <= 1'd1;
			end
			rx_tx_32bdone_clockdomainsrenamer1_next_value2 <= 1'd0;
			rx_tx_32bdone_clockdomainsrenamer1_next_value_ce2 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_22 <= dummy_s;
// synthesis translate_on
end
assign rx_tx_strobe = (rx_tx_counter == 1'd0);

// synthesis translate_off
reg dummy_d_23;
// synthesis translate_on
always @(*) begin
	rx_tx_next_state <= 2'd0;
	rx_tx_latch_clockdomainsrenamer1_t_next_value0 <= 8'd0;
	rx_tx_latch_clockdomainsrenamer1_t_next_value_ce0 <= 1'd0;
	rx_tx_counter_clockdomainsrenamer1_t_next_value1 <= 5'd0;
	rx_tx_counter_clockdomainsrenamer1_t_next_value_ce1 <= 1'd0;
	rx_tx_serial2_clockdomainsrenamer1_f_next_value <= 1'd0;
	rx_tx_serial2_clockdomainsrenamer1_f_next_value_ce <= 1'd0;
	rx_tx_bitn_clockdomainsrenamer1_t_next_value2 <= 3'd0;
	rx_tx_bitn_clockdomainsrenamer1_t_next_value_ce2 <= 1'd0;
	rx_tx_done_clockdomainsrenamer1_t_next_value3 <= 1'd0;
	rx_tx_done_clockdomainsrenamer1_t_next_value_ce3 <= 1'd0;
	rx_tx_next_state <= rx_tx_state;
	case (rx_tx_state)
		1'd1: begin
			if (rx_tx_strobe) begin
				rx_tx_serial2_clockdomainsrenamer1_f_next_value <= 1'd0;
				rx_tx_serial2_clockdomainsrenamer1_f_next_value_ce <= 1'd1;
				rx_tx_next_state <= 2'd2;
			end
		end
		2'd2: begin
			if (rx_tx_strobe) begin
				rx_tx_serial2_clockdomainsrenamer1_f_next_value <= rx_tx_latch[0];
				rx_tx_serial2_clockdomainsrenamer1_f_next_value_ce <= 1'd1;
				rx_tx_latch_clockdomainsrenamer1_t_next_value0 <= {1'd0, rx_tx_latch[7:1]};
				rx_tx_latch_clockdomainsrenamer1_t_next_value_ce0 <= 1'd1;
				rx_tx_bitn_clockdomainsrenamer1_t_next_value2 <= (rx_tx_bitn + 1'd1);
				rx_tx_bitn_clockdomainsrenamer1_t_next_value_ce2 <= 1'd1;
				if ((rx_tx_bitn == 3'd7)) begin
					rx_tx_next_state <= 2'd3;
					rx_tx_bitn_clockdomainsrenamer1_t_next_value2 <= 1'd0;
					rx_tx_bitn_clockdomainsrenamer1_t_next_value_ce2 <= 1'd1;
					rx_tx_done_clockdomainsrenamer1_t_next_value3 <= 1'd1;
					rx_tx_done_clockdomainsrenamer1_t_next_value_ce3 <= 1'd1;
				end
			end
		end
		2'd3: begin
			if (rx_tx_strobe) begin
				rx_tx_serial2_clockdomainsrenamer1_f_next_value <= 1'd1;
				rx_tx_serial2_clockdomainsrenamer1_f_next_value_ce <= 1'd1;
				rx_tx_done_clockdomainsrenamer1_t_next_value3 <= 1'd0;
				rx_tx_done_clockdomainsrenamer1_t_next_value_ce3 <= 1'd1;
				rx_tx_next_state <= 1'd0;
			end
		end
		default: begin
			if (rx_tx_ready) begin
				rx_tx_latch_clockdomainsrenamer1_t_next_value0 <= rx_tx_data;
				rx_tx_latch_clockdomainsrenamer1_t_next_value_ce0 <= 1'd1;
				rx_tx_counter_clockdomainsrenamer1_t_next_value1 <= 5'd29;
				rx_tx_counter_clockdomainsrenamer1_t_next_value_ce1 <= 1'd1;
				rx_tx_next_state <= 1'd1;
			end else begin
				rx_tx_serial2_clockdomainsrenamer1_f_next_value <= 1'd1;
				rx_tx_serial2_clockdomainsrenamer1_f_next_value_ce <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_23 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_24;
// synthesis translate_on
always @(*) begin
	rx_decoder1_input_msb_first <= 10'd0;
	rx_decoder1_input_msb_first[0] <= rx_decoder1_input[9];
	rx_decoder1_input_msb_first[1] <= rx_decoder1_input[8];
	rx_decoder1_input_msb_first[2] <= rx_decoder1_input[7];
	rx_decoder1_input_msb_first[3] <= rx_decoder1_input[6];
	rx_decoder1_input_msb_first[4] <= rx_decoder1_input[5];
	rx_decoder1_input_msb_first[5] <= rx_decoder1_input[4];
	rx_decoder1_input_msb_first[6] <= rx_decoder1_input[3];
	rx_decoder1_input_msb_first[7] <= rx_decoder1_input[2];
	rx_decoder1_input_msb_first[8] <= rx_decoder1_input[1];
	rx_decoder1_input_msb_first[9] <= rx_decoder1_input[0];
// synthesis translate_off
	dummy_d_24 <= dummy_s;
// synthesis translate_on
end
assign rx_decoder1_adr = rx_decoder1_input_msb_first[9:4];
assign rx_decoder1_code5b = rx_decoder1_dat_r;
assign rx_decoder1_d = {rx_decoder1_code3b, rx_decoder1_code5b};
assign rx_decoder1_invalid = (((rx_decoder1_ones != 3'd4) & (rx_decoder1_ones != 3'd5)) & (rx_decoder1_ones != 3'd6));

// synthesis translate_off
reg dummy_d_25;
// synthesis translate_on
always @(*) begin
	rx_decoder2_input_msb_first <= 10'd0;
	rx_decoder2_input_msb_first[0] <= rx_decoder2_input[9];
	rx_decoder2_input_msb_first[1] <= rx_decoder2_input[8];
	rx_decoder2_input_msb_first[2] <= rx_decoder2_input[7];
	rx_decoder2_input_msb_first[3] <= rx_decoder2_input[6];
	rx_decoder2_input_msb_first[4] <= rx_decoder2_input[5];
	rx_decoder2_input_msb_first[5] <= rx_decoder2_input[4];
	rx_decoder2_input_msb_first[6] <= rx_decoder2_input[3];
	rx_decoder2_input_msb_first[7] <= rx_decoder2_input[2];
	rx_decoder2_input_msb_first[8] <= rx_decoder2_input[1];
	rx_decoder2_input_msb_first[9] <= rx_decoder2_input[0];
// synthesis translate_off
	dummy_d_25 <= dummy_s;
// synthesis translate_on
end
assign rx_decoder2_adr = rx_decoder2_input_msb_first[9:4];
assign rx_decoder2_code5b = rx_decoder2_dat_r;
assign rx_decoder2_d = {rx_decoder2_code3b, rx_decoder2_code5b};
assign rx_decoder2_invalid = (((rx_decoder2_ones != 3'd4) & (rx_decoder2_ones != 3'd5)) & (rx_decoder2_ones != 3'd6));

// synthesis translate_off
reg dummy_d_26;
// synthesis translate_on
always @(*) begin
	rx_decoder3_input_msb_first <= 10'd0;
	rx_decoder3_input_msb_first[0] <= rx_decoder3_input[9];
	rx_decoder3_input_msb_first[1] <= rx_decoder3_input[8];
	rx_decoder3_input_msb_first[2] <= rx_decoder3_input[7];
	rx_decoder3_input_msb_first[3] <= rx_decoder3_input[6];
	rx_decoder3_input_msb_first[4] <= rx_decoder3_input[5];
	rx_decoder3_input_msb_first[5] <= rx_decoder3_input[4];
	rx_decoder3_input_msb_first[6] <= rx_decoder3_input[3];
	rx_decoder3_input_msb_first[7] <= rx_decoder3_input[2];
	rx_decoder3_input_msb_first[8] <= rx_decoder3_input[1];
	rx_decoder3_input_msb_first[9] <= rx_decoder3_input[0];
// synthesis translate_off
	dummy_d_26 <= dummy_s;
// synthesis translate_on
end
assign rx_decoder3_adr = rx_decoder3_input_msb_first[9:4];
assign rx_decoder3_code5b = rx_decoder3_dat_r;
assign rx_decoder3_d = {rx_decoder3_code3b, rx_decoder3_code5b};
assign rx_decoder3_invalid = (((rx_decoder3_ones != 3'd4) & (rx_decoder3_ones != 3'd5)) & (rx_decoder3_ones != 3'd6));

// synthesis translate_off
reg dummy_d_27;
// synthesis translate_on
always @(*) begin
	rx_decoder4_input_msb_first <= 10'd0;
	rx_decoder4_input_msb_first[0] <= rx_decoder4_input[9];
	rx_decoder4_input_msb_first[1] <= rx_decoder4_input[8];
	rx_decoder4_input_msb_first[2] <= rx_decoder4_input[7];
	rx_decoder4_input_msb_first[3] <= rx_decoder4_input[6];
	rx_decoder4_input_msb_first[4] <= rx_decoder4_input[5];
	rx_decoder4_input_msb_first[5] <= rx_decoder4_input[4];
	rx_decoder4_input_msb_first[6] <= rx_decoder4_input[3];
	rx_decoder4_input_msb_first[7] <= rx_decoder4_input[2];
	rx_decoder4_input_msb_first[8] <= rx_decoder4_input[1];
	rx_decoder4_input_msb_first[9] <= rx_decoder4_input[0];
// synthesis translate_off
	dummy_d_27 <= dummy_s;
// synthesis translate_on
end
assign rx_decoder4_adr = rx_decoder4_input_msb_first[9:4];
assign rx_decoder4_code5b = rx_decoder4_dat_r;
assign rx_decoder4_d = {rx_decoder4_code3b, rx_decoder4_code5b};
assign rx_decoder4_invalid = (((rx_decoder4_ones != 3'd4) & (rx_decoder4_ones != 3'd5)) & (rx_decoder4_ones != 3'd6));
assign rx_syncfifo_re = (rx_syncfifo_readable & ((~rx_readable) | rx_re));
assign rx_level1 = (rx_level0 + rx_readable);

// synthesis translate_off
reg dummy_d_28;
// synthesis translate_on
always @(*) begin
	rx_wrport_adr <= 5'd0;
	if (rx_replace) begin
		rx_wrport_adr <= (rx_produce - 1'd1);
	end else begin
		rx_wrport_adr <= rx_produce;
	end
// synthesis translate_off
	dummy_d_28 <= dummy_s;
// synthesis translate_on
end
assign rx_wrport_dat_w = rx_syncfifo_din;
assign rx_wrport_we = (rx_syncfifo_we & (rx_syncfifo_writable | rx_replace));
assign rx_do_read = (rx_syncfifo_readable & rx_syncfifo_re);
assign rx_rdport_adr = rx_consume;
assign rx_syncfifo_dout = rx_rdport_dat_r;
assign rx_rdport_re = rx_do_read;
assign rx_syncfifo_writable = (rx_level0 != 5'd20);
assign rx_syncfifo_readable = (rx_level0 != 1'd0);

// synthesis translate_off
reg dummy_d_29;
// synthesis translate_on
always @(*) begin
	rx_syncfifo_we <= 1'd0;
	rx_next_state <= 2'd0;
	rx_next_state <= rx_state;
	case (rx_state)
		1'd1: begin
			if (((rx_decoder_out[7:0] == 6'd60) & rx_decoder1_k)) begin
				rx_syncfifo_we <= 1'd1;
				rx_next_state <= 2'd2;
			end
		end
		2'd2: begin
			rx_syncfifo_we <= 1'd1;
			if (((rx_decoder_out[7:0] == 8'd220) & rx_decoder1_k)) begin
				rx_next_state <= 1'd1;
			end
		end
		default: begin
			if (rx_rx_init_done) begin
				rx_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_29 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_30;
// synthesis translate_on
always @(*) begin
	fsm_next_state <= 3'd0;
	prbs_en_clockdomainsrenamer2_next_value0 <= 1'd0;
	prbs_en_clockdomainsrenamer2_next_value_ce0 <= 1'd0;
	data_type_clockdomainsrenamer2_next_value1 <= 2'd0;
	data_type_clockdomainsrenamer2_next_value_ce1 <= 1'd0;
	write_fifo_clockdomainsrenamer2_next_value2 <= 1'd0;
	write_fifo_clockdomainsrenamer2_next_value_ce2 <= 1'd0;
	index_clockdomainsrenamer2_next_value3 <= 3'd0;
	index_clockdomainsrenamer2_next_value_ce3 <= 1'd0;
	fsm_next_state <= fsm_state;
	case (fsm_state)
		1'd1: begin
			data_type_clockdomainsrenamer2_next_value1 <= 1'd0;
			data_type_clockdomainsrenamer2_next_value_ce1 <= 1'd1;
			index_clockdomainsrenamer2_next_value3 <= (index + 1'd1);
			index_clockdomainsrenamer2_next_value_ce3 <= 1'd1;
			fsm_next_state <= 2'd2;
		end
		2'd2: begin
			if ((index < 3'd5)) begin
				if ((index == (i_ignored - 1'd1))) begin
					data_type_clockdomainsrenamer2_next_value1 <= 1'd0;
					data_type_clockdomainsrenamer2_next_value_ce1 <= 1'd1;
				end else begin
					data_type_clockdomainsrenamer2_next_value1 <= 1'd0;
					data_type_clockdomainsrenamer2_next_value_ce1 <= 1'd1;
				end
				index_clockdomainsrenamer2_next_value3 <= (index + 1'd1);
				index_clockdomainsrenamer2_next_value_ce3 <= 1'd1;
				fsm_next_state <= 2'd2;
			end else begin
				fsm_next_state <= 2'd3;
				data_type_clockdomainsrenamer2_next_value1 <= 2'd2;
				data_type_clockdomainsrenamer2_next_value_ce1 <= 1'd1;
				index_clockdomainsrenamer2_next_value3 <= 1'd0;
				index_clockdomainsrenamer2_next_value_ce3 <= 1'd1;
			end
		end
		2'd3: begin
			prbs_en_clockdomainsrenamer2_next_value0 <= 1'd0;
			prbs_en_clockdomainsrenamer2_next_value_ce0 <= 1'd1;
			write_fifo_clockdomainsrenamer2_next_value2 <= 1'd0;
			write_fifo_clockdomainsrenamer2_next_value_ce2 <= 1'd1;
			fsm_next_state <= 3'd4;
		end
		3'd4: begin
			if ((~we)) begin
				fsm_next_state <= 1'd0;
			end
		end
		default: begin
			if (we) begin
				prbs_en_clockdomainsrenamer2_next_value0 <= 1'd1;
				prbs_en_clockdomainsrenamer2_next_value_ce0 <= 1'd1;
				data_type_clockdomainsrenamer2_next_value1 <= 1'd1;
				data_type_clockdomainsrenamer2_next_value_ce1 <= 1'd1;
				write_fifo_clockdomainsrenamer2_next_value2 <= 1'd1;
				write_fifo_clockdomainsrenamer2_next_value_ce2 <= 1'd1;
				fsm_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_30 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_31;
// synthesis translate_on
always @(*) begin
	t_array_muxed0 <= 3'd0;
	case (rx_decoder1_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed0 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed0 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed0 <= 3'd4;
		end
		2'd3: begin
			t_array_muxed0 <= 2'd3;
		end
		3'd4: begin
			t_array_muxed0 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed0 <= 2'd2;
		end
		3'd6: begin
			t_array_muxed0 <= 3'd6;
		end
		3'd7: begin
			t_array_muxed0 <= 1'd0;
		end
		4'd8: begin
			t_array_muxed0 <= 3'd7;
		end
		4'd9: begin
			t_array_muxed0 <= 1'd1;
		end
		4'd10: begin
			t_array_muxed0 <= 3'd5;
		end
		4'd11: begin
			t_array_muxed0 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed0 <= 1'd0;
		end
		4'd13: begin
			t_array_muxed0 <= 1'd0;
		end
		4'd14: begin
			t_array_muxed0 <= 1'd0;
		end
		default: begin
			t_array_muxed0 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_31 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_32;
// synthesis translate_on
always @(*) begin
	t_array_muxed1 <= 3'd0;
	case (rx_decoder1_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed1 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed1 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed1 <= 1'd0;
		end
		2'd3: begin
			t_array_muxed1 <= 1'd0;
		end
		3'd4: begin
			t_array_muxed1 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed1 <= 3'd5;
		end
		3'd6: begin
			t_array_muxed1 <= 1'd1;
		end
		3'd7: begin
			t_array_muxed1 <= 3'd7;
		end
		4'd8: begin
			t_array_muxed1 <= 1'd0;
		end
		4'd9: begin
			t_array_muxed1 <= 3'd6;
		end
		4'd10: begin
			t_array_muxed1 <= 2'd2;
		end
		4'd11: begin
			t_array_muxed1 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed1 <= 2'd3;
		end
		4'd13: begin
			t_array_muxed1 <= 3'd4;
		end
		4'd14: begin
			t_array_muxed1 <= 1'd0;
		end
		default: begin
			t_array_muxed1 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_32 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_33;
// synthesis translate_on
always @(*) begin
	f_array_muxed0 <= 3'd0;
	case (rx_decoder1_input_msb_first[3:0])
		1'd0: begin
			f_array_muxed0 <= 1'd0;
		end
		1'd1: begin
			f_array_muxed0 <= 3'd7;
		end
		2'd2: begin
			f_array_muxed0 <= 3'd4;
		end
		2'd3: begin
			f_array_muxed0 <= 2'd3;
		end
		3'd4: begin
			f_array_muxed0 <= 1'd0;
		end
		3'd5: begin
			f_array_muxed0 <= 2'd2;
		end
		3'd6: begin
			f_array_muxed0 <= 3'd6;
		end
		3'd7: begin
			f_array_muxed0 <= 3'd7;
		end
		4'd8: begin
			f_array_muxed0 <= 3'd7;
		end
		4'd9: begin
			f_array_muxed0 <= 1'd1;
		end
		4'd10: begin
			f_array_muxed0 <= 3'd5;
		end
		4'd11: begin
			f_array_muxed0 <= 1'd0;
		end
		4'd12: begin
			f_array_muxed0 <= 2'd3;
		end
		4'd13: begin
			f_array_muxed0 <= 3'd4;
		end
		4'd14: begin
			f_array_muxed0 <= 3'd7;
		end
		default: begin
			f_array_muxed0 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_33 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_34;
// synthesis translate_on
always @(*) begin
	t_array_muxed2 <= 3'd0;
	case (rx_decoder2_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed2 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed2 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed2 <= 3'd4;
		end
		2'd3: begin
			t_array_muxed2 <= 2'd3;
		end
		3'd4: begin
			t_array_muxed2 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed2 <= 2'd2;
		end
		3'd6: begin
			t_array_muxed2 <= 3'd6;
		end
		3'd7: begin
			t_array_muxed2 <= 1'd0;
		end
		4'd8: begin
			t_array_muxed2 <= 3'd7;
		end
		4'd9: begin
			t_array_muxed2 <= 1'd1;
		end
		4'd10: begin
			t_array_muxed2 <= 3'd5;
		end
		4'd11: begin
			t_array_muxed2 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed2 <= 1'd0;
		end
		4'd13: begin
			t_array_muxed2 <= 1'd0;
		end
		4'd14: begin
			t_array_muxed2 <= 1'd0;
		end
		default: begin
			t_array_muxed2 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_34 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_35;
// synthesis translate_on
always @(*) begin
	t_array_muxed3 <= 3'd0;
	case (rx_decoder2_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed3 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed3 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed3 <= 1'd0;
		end
		2'd3: begin
			t_array_muxed3 <= 1'd0;
		end
		3'd4: begin
			t_array_muxed3 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed3 <= 3'd5;
		end
		3'd6: begin
			t_array_muxed3 <= 1'd1;
		end
		3'd7: begin
			t_array_muxed3 <= 3'd7;
		end
		4'd8: begin
			t_array_muxed3 <= 1'd0;
		end
		4'd9: begin
			t_array_muxed3 <= 3'd6;
		end
		4'd10: begin
			t_array_muxed3 <= 2'd2;
		end
		4'd11: begin
			t_array_muxed3 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed3 <= 2'd3;
		end
		4'd13: begin
			t_array_muxed3 <= 3'd4;
		end
		4'd14: begin
			t_array_muxed3 <= 1'd0;
		end
		default: begin
			t_array_muxed3 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_35 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_36;
// synthesis translate_on
always @(*) begin
	f_array_muxed1 <= 3'd0;
	case (rx_decoder2_input_msb_first[3:0])
		1'd0: begin
			f_array_muxed1 <= 1'd0;
		end
		1'd1: begin
			f_array_muxed1 <= 3'd7;
		end
		2'd2: begin
			f_array_muxed1 <= 3'd4;
		end
		2'd3: begin
			f_array_muxed1 <= 2'd3;
		end
		3'd4: begin
			f_array_muxed1 <= 1'd0;
		end
		3'd5: begin
			f_array_muxed1 <= 2'd2;
		end
		3'd6: begin
			f_array_muxed1 <= 3'd6;
		end
		3'd7: begin
			f_array_muxed1 <= 3'd7;
		end
		4'd8: begin
			f_array_muxed1 <= 3'd7;
		end
		4'd9: begin
			f_array_muxed1 <= 1'd1;
		end
		4'd10: begin
			f_array_muxed1 <= 3'd5;
		end
		4'd11: begin
			f_array_muxed1 <= 1'd0;
		end
		4'd12: begin
			f_array_muxed1 <= 2'd3;
		end
		4'd13: begin
			f_array_muxed1 <= 3'd4;
		end
		4'd14: begin
			f_array_muxed1 <= 3'd7;
		end
		default: begin
			f_array_muxed1 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_36 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_37;
// synthesis translate_on
always @(*) begin
	t_array_muxed4 <= 3'd0;
	case (rx_decoder3_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed4 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed4 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed4 <= 3'd4;
		end
		2'd3: begin
			t_array_muxed4 <= 2'd3;
		end
		3'd4: begin
			t_array_muxed4 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed4 <= 2'd2;
		end
		3'd6: begin
			t_array_muxed4 <= 3'd6;
		end
		3'd7: begin
			t_array_muxed4 <= 1'd0;
		end
		4'd8: begin
			t_array_muxed4 <= 3'd7;
		end
		4'd9: begin
			t_array_muxed4 <= 1'd1;
		end
		4'd10: begin
			t_array_muxed4 <= 3'd5;
		end
		4'd11: begin
			t_array_muxed4 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed4 <= 1'd0;
		end
		4'd13: begin
			t_array_muxed4 <= 1'd0;
		end
		4'd14: begin
			t_array_muxed4 <= 1'd0;
		end
		default: begin
			t_array_muxed4 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_37 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_38;
// synthesis translate_on
always @(*) begin
	t_array_muxed5 <= 3'd0;
	case (rx_decoder3_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed5 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed5 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed5 <= 1'd0;
		end
		2'd3: begin
			t_array_muxed5 <= 1'd0;
		end
		3'd4: begin
			t_array_muxed5 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed5 <= 3'd5;
		end
		3'd6: begin
			t_array_muxed5 <= 1'd1;
		end
		3'd7: begin
			t_array_muxed5 <= 3'd7;
		end
		4'd8: begin
			t_array_muxed5 <= 1'd0;
		end
		4'd9: begin
			t_array_muxed5 <= 3'd6;
		end
		4'd10: begin
			t_array_muxed5 <= 2'd2;
		end
		4'd11: begin
			t_array_muxed5 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed5 <= 2'd3;
		end
		4'd13: begin
			t_array_muxed5 <= 3'd4;
		end
		4'd14: begin
			t_array_muxed5 <= 1'd0;
		end
		default: begin
			t_array_muxed5 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_38 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_39;
// synthesis translate_on
always @(*) begin
	f_array_muxed2 <= 3'd0;
	case (rx_decoder3_input_msb_first[3:0])
		1'd0: begin
			f_array_muxed2 <= 1'd0;
		end
		1'd1: begin
			f_array_muxed2 <= 3'd7;
		end
		2'd2: begin
			f_array_muxed2 <= 3'd4;
		end
		2'd3: begin
			f_array_muxed2 <= 2'd3;
		end
		3'd4: begin
			f_array_muxed2 <= 1'd0;
		end
		3'd5: begin
			f_array_muxed2 <= 2'd2;
		end
		3'd6: begin
			f_array_muxed2 <= 3'd6;
		end
		3'd7: begin
			f_array_muxed2 <= 3'd7;
		end
		4'd8: begin
			f_array_muxed2 <= 3'd7;
		end
		4'd9: begin
			f_array_muxed2 <= 1'd1;
		end
		4'd10: begin
			f_array_muxed2 <= 3'd5;
		end
		4'd11: begin
			f_array_muxed2 <= 1'd0;
		end
		4'd12: begin
			f_array_muxed2 <= 2'd3;
		end
		4'd13: begin
			f_array_muxed2 <= 3'd4;
		end
		4'd14: begin
			f_array_muxed2 <= 3'd7;
		end
		default: begin
			f_array_muxed2 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_39 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_40;
// synthesis translate_on
always @(*) begin
	t_array_muxed6 <= 3'd0;
	case (rx_decoder4_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed6 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed6 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed6 <= 3'd4;
		end
		2'd3: begin
			t_array_muxed6 <= 2'd3;
		end
		3'd4: begin
			t_array_muxed6 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed6 <= 2'd2;
		end
		3'd6: begin
			t_array_muxed6 <= 3'd6;
		end
		3'd7: begin
			t_array_muxed6 <= 1'd0;
		end
		4'd8: begin
			t_array_muxed6 <= 3'd7;
		end
		4'd9: begin
			t_array_muxed6 <= 1'd1;
		end
		4'd10: begin
			t_array_muxed6 <= 3'd5;
		end
		4'd11: begin
			t_array_muxed6 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed6 <= 1'd0;
		end
		4'd13: begin
			t_array_muxed6 <= 1'd0;
		end
		4'd14: begin
			t_array_muxed6 <= 1'd0;
		end
		default: begin
			t_array_muxed6 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_40 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_41;
// synthesis translate_on
always @(*) begin
	t_array_muxed7 <= 3'd0;
	case (rx_decoder4_input_msb_first[3:0])
		1'd0: begin
			t_array_muxed7 <= 1'd0;
		end
		1'd1: begin
			t_array_muxed7 <= 1'd0;
		end
		2'd2: begin
			t_array_muxed7 <= 1'd0;
		end
		2'd3: begin
			t_array_muxed7 <= 1'd0;
		end
		3'd4: begin
			t_array_muxed7 <= 1'd0;
		end
		3'd5: begin
			t_array_muxed7 <= 3'd5;
		end
		3'd6: begin
			t_array_muxed7 <= 1'd1;
		end
		3'd7: begin
			t_array_muxed7 <= 3'd7;
		end
		4'd8: begin
			t_array_muxed7 <= 1'd0;
		end
		4'd9: begin
			t_array_muxed7 <= 3'd6;
		end
		4'd10: begin
			t_array_muxed7 <= 2'd2;
		end
		4'd11: begin
			t_array_muxed7 <= 1'd0;
		end
		4'd12: begin
			t_array_muxed7 <= 2'd3;
		end
		4'd13: begin
			t_array_muxed7 <= 3'd4;
		end
		4'd14: begin
			t_array_muxed7 <= 1'd0;
		end
		default: begin
			t_array_muxed7 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_41 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_42;
// synthesis translate_on
always @(*) begin
	f_array_muxed3 <= 3'd0;
	case (rx_decoder4_input_msb_first[3:0])
		1'd0: begin
			f_array_muxed3 <= 1'd0;
		end
		1'd1: begin
			f_array_muxed3 <= 3'd7;
		end
		2'd2: begin
			f_array_muxed3 <= 3'd4;
		end
		2'd3: begin
			f_array_muxed3 <= 2'd3;
		end
		3'd4: begin
			f_array_muxed3 <= 1'd0;
		end
		3'd5: begin
			f_array_muxed3 <= 2'd2;
		end
		3'd6: begin
			f_array_muxed3 <= 3'd6;
		end
		3'd7: begin
			f_array_muxed3 <= 3'd7;
		end
		4'd8: begin
			f_array_muxed3 <= 3'd7;
		end
		4'd9: begin
			f_array_muxed3 <= 1'd1;
		end
		4'd10: begin
			f_array_muxed3 <= 3'd5;
		end
		4'd11: begin
			f_array_muxed3 <= 1'd0;
		end
		4'd12: begin
			f_array_muxed3 <= 2'd3;
		end
		4'd13: begin
			f_array_muxed3 <= 3'd4;
		end
		4'd14: begin
			f_array_muxed3 <= 3'd7;
		end
		default: begin
			f_array_muxed3 <= 1'd0;
		end
	endcase
// synthesis translate_off
	dummy_d_42 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_43;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed0 <= 6'd0;
	case (tx_singleencoder0_d[4:0])
		1'd0: begin
			rhs_array_muxed0 <= 5'd24;
		end
		1'd1: begin
			rhs_array_muxed0 <= 6'd34;
		end
		2'd2: begin
			rhs_array_muxed0 <= 5'd18;
		end
		2'd3: begin
			rhs_array_muxed0 <= 6'd49;
		end
		3'd4: begin
			rhs_array_muxed0 <= 4'd10;
		end
		3'd5: begin
			rhs_array_muxed0 <= 6'd41;
		end
		3'd6: begin
			rhs_array_muxed0 <= 5'd25;
		end
		3'd7: begin
			rhs_array_muxed0 <= 3'd7;
		end
		4'd8: begin
			rhs_array_muxed0 <= 3'd6;
		end
		4'd9: begin
			rhs_array_muxed0 <= 6'd37;
		end
		4'd10: begin
			rhs_array_muxed0 <= 5'd21;
		end
		4'd11: begin
			rhs_array_muxed0 <= 6'd52;
		end
		4'd12: begin
			rhs_array_muxed0 <= 4'd13;
		end
		4'd13: begin
			rhs_array_muxed0 <= 6'd44;
		end
		4'd14: begin
			rhs_array_muxed0 <= 5'd28;
		end
		4'd15: begin
			rhs_array_muxed0 <= 6'd40;
		end
		5'd16: begin
			rhs_array_muxed0 <= 6'd36;
		end
		5'd17: begin
			rhs_array_muxed0 <= 6'd35;
		end
		5'd18: begin
			rhs_array_muxed0 <= 5'd19;
		end
		5'd19: begin
			rhs_array_muxed0 <= 6'd50;
		end
		5'd20: begin
			rhs_array_muxed0 <= 4'd11;
		end
		5'd21: begin
			rhs_array_muxed0 <= 6'd42;
		end
		5'd22: begin
			rhs_array_muxed0 <= 5'd26;
		end
		5'd23: begin
			rhs_array_muxed0 <= 3'd5;
		end
		5'd24: begin
			rhs_array_muxed0 <= 4'd12;
		end
		5'd25: begin
			rhs_array_muxed0 <= 6'd38;
		end
		5'd26: begin
			rhs_array_muxed0 <= 5'd22;
		end
		5'd27: begin
			rhs_array_muxed0 <= 4'd9;
		end
		5'd28: begin
			rhs_array_muxed0 <= 4'd14;
		end
		5'd29: begin
			rhs_array_muxed0 <= 5'd17;
		end
		5'd30: begin
			rhs_array_muxed0 <= 6'd33;
		end
		default: begin
			rhs_array_muxed0 <= 5'd20;
		end
	endcase
// synthesis translate_off
	dummy_d_43 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_44;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed1 <= 1'd0;
	case (tx_singleencoder0_d[4:0])
		1'd0: begin
			rhs_array_muxed1 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed1 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed1 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed1 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed1 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed1 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed1 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed1 <= 1'd0;
		end
		4'd8: begin
			rhs_array_muxed1 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed1 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed1 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed1 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed1 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed1 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed1 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed1 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed1 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed1 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed1 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed1 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed1 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed1 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed1 <= 1'd1;
		end
		default: begin
			rhs_array_muxed1 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_44 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_45;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed2 <= 1'd0;
	case (tx_singleencoder0_d[4:0])
		1'd0: begin
			rhs_array_muxed2 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed2 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed2 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed2 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed2 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed2 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed2 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed2 <= 1'd1;
		end
		4'd8: begin
			rhs_array_muxed2 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed2 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed2 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed2 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed2 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed2 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed2 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed2 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed2 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed2 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed2 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed2 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed2 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed2 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed2 <= 1'd1;
		end
		default: begin
			rhs_array_muxed2 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_45 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_46;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed3 <= 4'd0;
	case (tx_singleencoder0_d[7:5])
		1'd0: begin
			rhs_array_muxed3 <= 3'd4;
		end
		1'd1: begin
			rhs_array_muxed3 <= 4'd9;
		end
		2'd2: begin
			rhs_array_muxed3 <= 3'd5;
		end
		2'd3: begin
			rhs_array_muxed3 <= 2'd3;
		end
		3'd4: begin
			rhs_array_muxed3 <= 2'd2;
		end
		3'd5: begin
			rhs_array_muxed3 <= 4'd10;
		end
		3'd6: begin
			rhs_array_muxed3 <= 3'd6;
		end
		default: begin
			rhs_array_muxed3 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_46 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_47;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed4 <= 1'd0;
	case (tx_singleencoder0_d[7:5])
		1'd0: begin
			rhs_array_muxed4 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed4 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed4 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed4 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed4 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed4 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed4 <= 1'd0;
		end
		default: begin
			rhs_array_muxed4 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_47 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_48;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed5 <= 1'd0;
	case (tx_singleencoder0_d[7:5])
		1'd0: begin
			rhs_array_muxed5 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed5 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed5 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed5 <= 1'd1;
		end
		3'd4: begin
			rhs_array_muxed5 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed5 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed5 <= 1'd0;
		end
		default: begin
			rhs_array_muxed5 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_48 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_49;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed6 <= 6'd0;
	case (tx_singleencoder1_d[4:0])
		1'd0: begin
			rhs_array_muxed6 <= 5'd24;
		end
		1'd1: begin
			rhs_array_muxed6 <= 6'd34;
		end
		2'd2: begin
			rhs_array_muxed6 <= 5'd18;
		end
		2'd3: begin
			rhs_array_muxed6 <= 6'd49;
		end
		3'd4: begin
			rhs_array_muxed6 <= 4'd10;
		end
		3'd5: begin
			rhs_array_muxed6 <= 6'd41;
		end
		3'd6: begin
			rhs_array_muxed6 <= 5'd25;
		end
		3'd7: begin
			rhs_array_muxed6 <= 3'd7;
		end
		4'd8: begin
			rhs_array_muxed6 <= 3'd6;
		end
		4'd9: begin
			rhs_array_muxed6 <= 6'd37;
		end
		4'd10: begin
			rhs_array_muxed6 <= 5'd21;
		end
		4'd11: begin
			rhs_array_muxed6 <= 6'd52;
		end
		4'd12: begin
			rhs_array_muxed6 <= 4'd13;
		end
		4'd13: begin
			rhs_array_muxed6 <= 6'd44;
		end
		4'd14: begin
			rhs_array_muxed6 <= 5'd28;
		end
		4'd15: begin
			rhs_array_muxed6 <= 6'd40;
		end
		5'd16: begin
			rhs_array_muxed6 <= 6'd36;
		end
		5'd17: begin
			rhs_array_muxed6 <= 6'd35;
		end
		5'd18: begin
			rhs_array_muxed6 <= 5'd19;
		end
		5'd19: begin
			rhs_array_muxed6 <= 6'd50;
		end
		5'd20: begin
			rhs_array_muxed6 <= 4'd11;
		end
		5'd21: begin
			rhs_array_muxed6 <= 6'd42;
		end
		5'd22: begin
			rhs_array_muxed6 <= 5'd26;
		end
		5'd23: begin
			rhs_array_muxed6 <= 3'd5;
		end
		5'd24: begin
			rhs_array_muxed6 <= 4'd12;
		end
		5'd25: begin
			rhs_array_muxed6 <= 6'd38;
		end
		5'd26: begin
			rhs_array_muxed6 <= 5'd22;
		end
		5'd27: begin
			rhs_array_muxed6 <= 4'd9;
		end
		5'd28: begin
			rhs_array_muxed6 <= 4'd14;
		end
		5'd29: begin
			rhs_array_muxed6 <= 5'd17;
		end
		5'd30: begin
			rhs_array_muxed6 <= 6'd33;
		end
		default: begin
			rhs_array_muxed6 <= 5'd20;
		end
	endcase
// synthesis translate_off
	dummy_d_49 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_50;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed7 <= 1'd0;
	case (tx_singleencoder1_d[4:0])
		1'd0: begin
			rhs_array_muxed7 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed7 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed7 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed7 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed7 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed7 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed7 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed7 <= 1'd0;
		end
		4'd8: begin
			rhs_array_muxed7 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed7 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed7 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed7 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed7 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed7 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed7 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed7 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed7 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed7 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed7 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed7 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed7 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed7 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed7 <= 1'd1;
		end
		default: begin
			rhs_array_muxed7 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_50 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_51;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed8 <= 1'd0;
	case (tx_singleencoder1_d[4:0])
		1'd0: begin
			rhs_array_muxed8 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed8 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed8 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed8 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed8 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed8 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed8 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed8 <= 1'd1;
		end
		4'd8: begin
			rhs_array_muxed8 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed8 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed8 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed8 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed8 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed8 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed8 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed8 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed8 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed8 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed8 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed8 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed8 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed8 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed8 <= 1'd1;
		end
		default: begin
			rhs_array_muxed8 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_51 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_52;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed9 <= 4'd0;
	case (tx_singleencoder1_d[7:5])
		1'd0: begin
			rhs_array_muxed9 <= 3'd4;
		end
		1'd1: begin
			rhs_array_muxed9 <= 4'd9;
		end
		2'd2: begin
			rhs_array_muxed9 <= 3'd5;
		end
		2'd3: begin
			rhs_array_muxed9 <= 2'd3;
		end
		3'd4: begin
			rhs_array_muxed9 <= 2'd2;
		end
		3'd5: begin
			rhs_array_muxed9 <= 4'd10;
		end
		3'd6: begin
			rhs_array_muxed9 <= 3'd6;
		end
		default: begin
			rhs_array_muxed9 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_52 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_53;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed10 <= 1'd0;
	case (tx_singleencoder1_d[7:5])
		1'd0: begin
			rhs_array_muxed10 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed10 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed10 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed10 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed10 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed10 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed10 <= 1'd0;
		end
		default: begin
			rhs_array_muxed10 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_53 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_54;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed11 <= 1'd0;
	case (tx_singleencoder1_d[7:5])
		1'd0: begin
			rhs_array_muxed11 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed11 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed11 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed11 <= 1'd1;
		end
		3'd4: begin
			rhs_array_muxed11 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed11 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed11 <= 1'd0;
		end
		default: begin
			rhs_array_muxed11 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_54 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_55;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed12 <= 6'd0;
	case (tx_singleencoder2_d[4:0])
		1'd0: begin
			rhs_array_muxed12 <= 5'd24;
		end
		1'd1: begin
			rhs_array_muxed12 <= 6'd34;
		end
		2'd2: begin
			rhs_array_muxed12 <= 5'd18;
		end
		2'd3: begin
			rhs_array_muxed12 <= 6'd49;
		end
		3'd4: begin
			rhs_array_muxed12 <= 4'd10;
		end
		3'd5: begin
			rhs_array_muxed12 <= 6'd41;
		end
		3'd6: begin
			rhs_array_muxed12 <= 5'd25;
		end
		3'd7: begin
			rhs_array_muxed12 <= 3'd7;
		end
		4'd8: begin
			rhs_array_muxed12 <= 3'd6;
		end
		4'd9: begin
			rhs_array_muxed12 <= 6'd37;
		end
		4'd10: begin
			rhs_array_muxed12 <= 5'd21;
		end
		4'd11: begin
			rhs_array_muxed12 <= 6'd52;
		end
		4'd12: begin
			rhs_array_muxed12 <= 4'd13;
		end
		4'd13: begin
			rhs_array_muxed12 <= 6'd44;
		end
		4'd14: begin
			rhs_array_muxed12 <= 5'd28;
		end
		4'd15: begin
			rhs_array_muxed12 <= 6'd40;
		end
		5'd16: begin
			rhs_array_muxed12 <= 6'd36;
		end
		5'd17: begin
			rhs_array_muxed12 <= 6'd35;
		end
		5'd18: begin
			rhs_array_muxed12 <= 5'd19;
		end
		5'd19: begin
			rhs_array_muxed12 <= 6'd50;
		end
		5'd20: begin
			rhs_array_muxed12 <= 4'd11;
		end
		5'd21: begin
			rhs_array_muxed12 <= 6'd42;
		end
		5'd22: begin
			rhs_array_muxed12 <= 5'd26;
		end
		5'd23: begin
			rhs_array_muxed12 <= 3'd5;
		end
		5'd24: begin
			rhs_array_muxed12 <= 4'd12;
		end
		5'd25: begin
			rhs_array_muxed12 <= 6'd38;
		end
		5'd26: begin
			rhs_array_muxed12 <= 5'd22;
		end
		5'd27: begin
			rhs_array_muxed12 <= 4'd9;
		end
		5'd28: begin
			rhs_array_muxed12 <= 4'd14;
		end
		5'd29: begin
			rhs_array_muxed12 <= 5'd17;
		end
		5'd30: begin
			rhs_array_muxed12 <= 6'd33;
		end
		default: begin
			rhs_array_muxed12 <= 5'd20;
		end
	endcase
// synthesis translate_off
	dummy_d_55 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_56;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed13 <= 1'd0;
	case (tx_singleencoder2_d[4:0])
		1'd0: begin
			rhs_array_muxed13 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed13 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed13 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed13 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed13 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed13 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed13 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed13 <= 1'd0;
		end
		4'd8: begin
			rhs_array_muxed13 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed13 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed13 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed13 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed13 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed13 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed13 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed13 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed13 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed13 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed13 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed13 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed13 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed13 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed13 <= 1'd1;
		end
		default: begin
			rhs_array_muxed13 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_56 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_57;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed14 <= 1'd0;
	case (tx_singleencoder2_d[4:0])
		1'd0: begin
			rhs_array_muxed14 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed14 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed14 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed14 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed14 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed14 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed14 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed14 <= 1'd1;
		end
		4'd8: begin
			rhs_array_muxed14 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed14 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed14 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed14 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed14 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed14 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed14 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed14 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed14 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed14 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed14 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed14 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed14 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed14 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed14 <= 1'd1;
		end
		default: begin
			rhs_array_muxed14 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_57 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_58;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed15 <= 4'd0;
	case (tx_singleencoder2_d[7:5])
		1'd0: begin
			rhs_array_muxed15 <= 3'd4;
		end
		1'd1: begin
			rhs_array_muxed15 <= 4'd9;
		end
		2'd2: begin
			rhs_array_muxed15 <= 3'd5;
		end
		2'd3: begin
			rhs_array_muxed15 <= 2'd3;
		end
		3'd4: begin
			rhs_array_muxed15 <= 2'd2;
		end
		3'd5: begin
			rhs_array_muxed15 <= 4'd10;
		end
		3'd6: begin
			rhs_array_muxed15 <= 3'd6;
		end
		default: begin
			rhs_array_muxed15 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_58 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_59;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed16 <= 1'd0;
	case (tx_singleencoder2_d[7:5])
		1'd0: begin
			rhs_array_muxed16 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed16 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed16 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed16 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed16 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed16 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed16 <= 1'd0;
		end
		default: begin
			rhs_array_muxed16 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_59 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_60;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed17 <= 1'd0;
	case (tx_singleencoder2_d[7:5])
		1'd0: begin
			rhs_array_muxed17 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed17 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed17 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed17 <= 1'd1;
		end
		3'd4: begin
			rhs_array_muxed17 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed17 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed17 <= 1'd0;
		end
		default: begin
			rhs_array_muxed17 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_60 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_61;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed18 <= 6'd0;
	case (tx_singleencoder3_d[4:0])
		1'd0: begin
			rhs_array_muxed18 <= 5'd24;
		end
		1'd1: begin
			rhs_array_muxed18 <= 6'd34;
		end
		2'd2: begin
			rhs_array_muxed18 <= 5'd18;
		end
		2'd3: begin
			rhs_array_muxed18 <= 6'd49;
		end
		3'd4: begin
			rhs_array_muxed18 <= 4'd10;
		end
		3'd5: begin
			rhs_array_muxed18 <= 6'd41;
		end
		3'd6: begin
			rhs_array_muxed18 <= 5'd25;
		end
		3'd7: begin
			rhs_array_muxed18 <= 3'd7;
		end
		4'd8: begin
			rhs_array_muxed18 <= 3'd6;
		end
		4'd9: begin
			rhs_array_muxed18 <= 6'd37;
		end
		4'd10: begin
			rhs_array_muxed18 <= 5'd21;
		end
		4'd11: begin
			rhs_array_muxed18 <= 6'd52;
		end
		4'd12: begin
			rhs_array_muxed18 <= 4'd13;
		end
		4'd13: begin
			rhs_array_muxed18 <= 6'd44;
		end
		4'd14: begin
			rhs_array_muxed18 <= 5'd28;
		end
		4'd15: begin
			rhs_array_muxed18 <= 6'd40;
		end
		5'd16: begin
			rhs_array_muxed18 <= 6'd36;
		end
		5'd17: begin
			rhs_array_muxed18 <= 6'd35;
		end
		5'd18: begin
			rhs_array_muxed18 <= 5'd19;
		end
		5'd19: begin
			rhs_array_muxed18 <= 6'd50;
		end
		5'd20: begin
			rhs_array_muxed18 <= 4'd11;
		end
		5'd21: begin
			rhs_array_muxed18 <= 6'd42;
		end
		5'd22: begin
			rhs_array_muxed18 <= 5'd26;
		end
		5'd23: begin
			rhs_array_muxed18 <= 3'd5;
		end
		5'd24: begin
			rhs_array_muxed18 <= 4'd12;
		end
		5'd25: begin
			rhs_array_muxed18 <= 6'd38;
		end
		5'd26: begin
			rhs_array_muxed18 <= 5'd22;
		end
		5'd27: begin
			rhs_array_muxed18 <= 4'd9;
		end
		5'd28: begin
			rhs_array_muxed18 <= 4'd14;
		end
		5'd29: begin
			rhs_array_muxed18 <= 5'd17;
		end
		5'd30: begin
			rhs_array_muxed18 <= 6'd33;
		end
		default: begin
			rhs_array_muxed18 <= 5'd20;
		end
	endcase
// synthesis translate_off
	dummy_d_61 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_62;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed19 <= 1'd0;
	case (tx_singleencoder3_d[4:0])
		1'd0: begin
			rhs_array_muxed19 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed19 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed19 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed19 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed19 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed19 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed19 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed19 <= 1'd0;
		end
		4'd8: begin
			rhs_array_muxed19 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed19 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed19 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed19 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed19 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed19 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed19 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed19 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed19 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed19 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed19 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed19 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed19 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed19 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed19 <= 1'd1;
		end
		default: begin
			rhs_array_muxed19 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_62 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_63;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed20 <= 1'd0;
	case (tx_singleencoder3_d[4:0])
		1'd0: begin
			rhs_array_muxed20 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed20 <= 1'd1;
		end
		2'd2: begin
			rhs_array_muxed20 <= 1'd1;
		end
		2'd3: begin
			rhs_array_muxed20 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed20 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed20 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed20 <= 1'd0;
		end
		3'd7: begin
			rhs_array_muxed20 <= 1'd1;
		end
		4'd8: begin
			rhs_array_muxed20 <= 1'd1;
		end
		4'd9: begin
			rhs_array_muxed20 <= 1'd0;
		end
		4'd10: begin
			rhs_array_muxed20 <= 1'd0;
		end
		4'd11: begin
			rhs_array_muxed20 <= 1'd0;
		end
		4'd12: begin
			rhs_array_muxed20 <= 1'd0;
		end
		4'd13: begin
			rhs_array_muxed20 <= 1'd0;
		end
		4'd14: begin
			rhs_array_muxed20 <= 1'd0;
		end
		4'd15: begin
			rhs_array_muxed20 <= 1'd1;
		end
		5'd16: begin
			rhs_array_muxed20 <= 1'd1;
		end
		5'd17: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd18: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd19: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd20: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd21: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd22: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd23: begin
			rhs_array_muxed20 <= 1'd1;
		end
		5'd24: begin
			rhs_array_muxed20 <= 1'd1;
		end
		5'd25: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd26: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd27: begin
			rhs_array_muxed20 <= 1'd1;
		end
		5'd28: begin
			rhs_array_muxed20 <= 1'd0;
		end
		5'd29: begin
			rhs_array_muxed20 <= 1'd1;
		end
		5'd30: begin
			rhs_array_muxed20 <= 1'd1;
		end
		default: begin
			rhs_array_muxed20 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_63 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_64;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed21 <= 4'd0;
	case (tx_singleencoder3_d[7:5])
		1'd0: begin
			rhs_array_muxed21 <= 3'd4;
		end
		1'd1: begin
			rhs_array_muxed21 <= 4'd9;
		end
		2'd2: begin
			rhs_array_muxed21 <= 3'd5;
		end
		2'd3: begin
			rhs_array_muxed21 <= 2'd3;
		end
		3'd4: begin
			rhs_array_muxed21 <= 2'd2;
		end
		3'd5: begin
			rhs_array_muxed21 <= 4'd10;
		end
		3'd6: begin
			rhs_array_muxed21 <= 3'd6;
		end
		default: begin
			rhs_array_muxed21 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_64 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_65;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed22 <= 1'd0;
	case (tx_singleencoder3_d[7:5])
		1'd0: begin
			rhs_array_muxed22 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed22 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed22 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed22 <= 1'd0;
		end
		3'd4: begin
			rhs_array_muxed22 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed22 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed22 <= 1'd0;
		end
		default: begin
			rhs_array_muxed22 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_65 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_66;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed23 <= 1'd0;
	case (tx_singleencoder3_d[7:5])
		1'd0: begin
			rhs_array_muxed23 <= 1'd1;
		end
		1'd1: begin
			rhs_array_muxed23 <= 1'd0;
		end
		2'd2: begin
			rhs_array_muxed23 <= 1'd0;
		end
		2'd3: begin
			rhs_array_muxed23 <= 1'd1;
		end
		3'd4: begin
			rhs_array_muxed23 <= 1'd1;
		end
		3'd5: begin
			rhs_array_muxed23 <= 1'd0;
		end
		3'd6: begin
			rhs_array_muxed23 <= 1'd0;
		end
		default: begin
			rhs_array_muxed23 <= 1'd1;
		end
	endcase
// synthesis translate_off
	dummy_d_66 <= dummy_s;
// synthesis translate_on
end
assign tx_tx_init_done1 = multiregimpl0_regs1;
assign tx_fifo_empty1 = multiregimpl1_regs1;
assign fifo_produce_rdomain = multiregimpl2_regs1;
assign fifo_consume_wdomain = multiregimpl3_regs1;

always @(posedge rx_clk_1) begin
	rx_fsm_state <= rx_fsm_next_state;
	if (rx_tx_ready_clockdomainsrenamer1_next_value_ce0) begin
		rx_tx_ready <= rx_tx_ready_clockdomainsrenamer1_next_value0;
	end
	if (rx_tx_data_clockdomainsrenamer1_next_value_ce1) begin
		rx_tx_data <= rx_tx_data_clockdomainsrenamer1_next_value1;
	end
	if (rx_tx_32bdone_clockdomainsrenamer1_next_value_ce2) begin
		rx_tx_32bdone <= rx_tx_32bdone_clockdomainsrenamer1_next_value2;
	end
	if (rx_byte_cnt_clockdomainsrenamer1_next_value_ce3) begin
		rx_byte_cnt <= rx_byte_cnt_clockdomainsrenamer1_next_value3;
	end
	if ((rx_tx_counter == 1'd0)) begin
		rx_tx_counter <= 5'd29;
	end else begin
		rx_tx_counter <= (rx_tx_counter - 1'd1);
	end
	rx_tx_state <= rx_tx_next_state;
	if (rx_tx_latch_clockdomainsrenamer1_t_next_value_ce0) begin
		rx_tx_latch <= rx_tx_latch_clockdomainsrenamer1_t_next_value0;
	end
	if (rx_tx_counter_clockdomainsrenamer1_t_next_value_ce1) begin
		rx_tx_counter <= rx_tx_counter_clockdomainsrenamer1_t_next_value1;
	end
	if (rx_tx_serial2_clockdomainsrenamer1_f_next_value_ce) begin
		rx_tx_serial2 <= rx_tx_serial2_clockdomainsrenamer1_f_next_value;
	end
	if (rx_tx_bitn_clockdomainsrenamer1_t_next_value_ce2) begin
		rx_tx_bitn <= rx_tx_bitn_clockdomainsrenamer1_t_next_value2;
	end
	if (rx_tx_done_clockdomainsrenamer1_t_next_value_ce3) begin
		rx_tx_done <= rx_tx_done_clockdomainsrenamer1_t_next_value3;
	end
	rx_decoder1_k <= 1'd0;
	if ((rx_decoder1_input_msb_first[9:4] == 4'd15)) begin
		rx_decoder1_k <= 1'd1;
		rx_decoder1_code3b <= t_array_muxed0;
	end else begin
		if ((rx_decoder1_input_msb_first[9:4] == 6'd48)) begin
			rx_decoder1_k <= 1'd1;
			rx_decoder1_code3b <= t_array_muxed1;
		end else begin
			if (((rx_decoder1_input_msb_first[3:0] == 3'd7) | (rx_decoder1_input_msb_first[3:0] == 4'd8))) begin
				if (((((((rx_decoder1_input_msb_first[9:4] != 6'd35) & (rx_decoder1_input_msb_first[9:4] != 5'd19)) & (rx_decoder1_input_msb_first[9:4] != 4'd11)) & (rx_decoder1_input_msb_first[9:4] != 6'd52)) & (rx_decoder1_input_msb_first[9:4] != 6'd44)) & (rx_decoder1_input_msb_first[9:4] != 5'd28))) begin
					rx_decoder1_k <= 1'd1;
				end
			end
			rx_decoder1_code3b <= f_array_muxed0;
		end
	end
	rx_decoder1_ones <= (((((((((rx_decoder1_input[0] + rx_decoder1_input[1]) + rx_decoder1_input[2]) + rx_decoder1_input[3]) + rx_decoder1_input[4]) + rx_decoder1_input[5]) + rx_decoder1_input[6]) + rx_decoder1_input[7]) + rx_decoder1_input[8]) + rx_decoder1_input[9]);
	rx_decoder2_k <= 1'd0;
	if ((rx_decoder2_input_msb_first[9:4] == 4'd15)) begin
		rx_decoder2_k <= 1'd1;
		rx_decoder2_code3b <= t_array_muxed2;
	end else begin
		if ((rx_decoder2_input_msb_first[9:4] == 6'd48)) begin
			rx_decoder2_k <= 1'd1;
			rx_decoder2_code3b <= t_array_muxed3;
		end else begin
			if (((rx_decoder2_input_msb_first[3:0] == 3'd7) | (rx_decoder2_input_msb_first[3:0] == 4'd8))) begin
				if (((((((rx_decoder2_input_msb_first[9:4] != 6'd35) & (rx_decoder2_input_msb_first[9:4] != 5'd19)) & (rx_decoder2_input_msb_first[9:4] != 4'd11)) & (rx_decoder2_input_msb_first[9:4] != 6'd52)) & (rx_decoder2_input_msb_first[9:4] != 6'd44)) & (rx_decoder2_input_msb_first[9:4] != 5'd28))) begin
					rx_decoder2_k <= 1'd1;
				end
			end
			rx_decoder2_code3b <= f_array_muxed1;
		end
	end
	rx_decoder2_ones <= (((((((((rx_decoder2_input[0] + rx_decoder2_input[1]) + rx_decoder2_input[2]) + rx_decoder2_input[3]) + rx_decoder2_input[4]) + rx_decoder2_input[5]) + rx_decoder2_input[6]) + rx_decoder2_input[7]) + rx_decoder2_input[8]) + rx_decoder2_input[9]);
	rx_decoder3_k <= 1'd0;
	if ((rx_decoder3_input_msb_first[9:4] == 4'd15)) begin
		rx_decoder3_k <= 1'd1;
		rx_decoder3_code3b <= t_array_muxed4;
	end else begin
		if ((rx_decoder3_input_msb_first[9:4] == 6'd48)) begin
			rx_decoder3_k <= 1'd1;
			rx_decoder3_code3b <= t_array_muxed5;
		end else begin
			if (((rx_decoder3_input_msb_first[3:0] == 3'd7) | (rx_decoder3_input_msb_first[3:0] == 4'd8))) begin
				if (((((((rx_decoder3_input_msb_first[9:4] != 6'd35) & (rx_decoder3_input_msb_first[9:4] != 5'd19)) & (rx_decoder3_input_msb_first[9:4] != 4'd11)) & (rx_decoder3_input_msb_first[9:4] != 6'd52)) & (rx_decoder3_input_msb_first[9:4] != 6'd44)) & (rx_decoder3_input_msb_first[9:4] != 5'd28))) begin
					rx_decoder3_k <= 1'd1;
				end
			end
			rx_decoder3_code3b <= f_array_muxed2;
		end
	end
	rx_decoder3_ones <= (((((((((rx_decoder3_input[0] + rx_decoder3_input[1]) + rx_decoder3_input[2]) + rx_decoder3_input[3]) + rx_decoder3_input[4]) + rx_decoder3_input[5]) + rx_decoder3_input[6]) + rx_decoder3_input[7]) + rx_decoder3_input[8]) + rx_decoder3_input[9]);
	rx_decoder4_k <= 1'd0;
	if ((rx_decoder4_input_msb_first[9:4] == 4'd15)) begin
		rx_decoder4_k <= 1'd1;
		rx_decoder4_code3b <= t_array_muxed6;
	end else begin
		if ((rx_decoder4_input_msb_first[9:4] == 6'd48)) begin
			rx_decoder4_k <= 1'd1;
			rx_decoder4_code3b <= t_array_muxed7;
		end else begin
			if (((rx_decoder4_input_msb_first[3:0] == 3'd7) | (rx_decoder4_input_msb_first[3:0] == 4'd8))) begin
				if (((((((rx_decoder4_input_msb_first[9:4] != 6'd35) & (rx_decoder4_input_msb_first[9:4] != 5'd19)) & (rx_decoder4_input_msb_first[9:4] != 4'd11)) & (rx_decoder4_input_msb_first[9:4] != 6'd52)) & (rx_decoder4_input_msb_first[9:4] != 6'd44)) & (rx_decoder4_input_msb_first[9:4] != 5'd28))) begin
					rx_decoder4_k <= 1'd1;
				end
			end
			rx_decoder4_code3b <= f_array_muxed3;
		end
	end
	rx_decoder4_ones <= (((((((((rx_decoder4_input[0] + rx_decoder4_input[1]) + rx_decoder4_input[2]) + rx_decoder4_input[3]) + rx_decoder4_input[4]) + rx_decoder4_input[5]) + rx_decoder4_input[6]) + rx_decoder4_input[7]) + rx_decoder4_input[8]) + rx_decoder4_input[9]);
	if (rx_syncfifo_re) begin
		rx_readable <= 1'd1;
	end else begin
		if (rx_re) begin
			rx_readable <= 1'd0;
		end
	end
	if (((rx_syncfifo_we & rx_syncfifo_writable) & (~rx_replace))) begin
		if ((rx_produce == 5'd19)) begin
			rx_produce <= 1'd0;
		end else begin
			rx_produce <= (rx_produce + 1'd1);
		end
	end
	if (rx_do_read) begin
		if ((rx_consume == 5'd19)) begin
			rx_consume <= 1'd0;
		end else begin
			rx_consume <= (rx_consume + 1'd1);
		end
	end
	if (((rx_syncfifo_we & rx_syncfifo_writable) & (~rx_replace))) begin
		if ((~rx_do_read)) begin
			rx_level0 <= (rx_level0 + 1'd1);
		end
	end else begin
		if (rx_do_read) begin
			rx_level0 <= (rx_level0 - 1'd1);
		end
	end
	rx_state <= rx_next_state;
	if (rx_rst) begin
		rx_decoder1_k <= 1'd0;
		rx_decoder1_code3b <= 3'd0;
		rx_decoder1_ones <= 4'd0;
		rx_decoder2_k <= 1'd0;
		rx_decoder2_code3b <= 3'd0;
		rx_decoder2_ones <= 4'd0;
		rx_decoder3_k <= 1'd0;
		rx_decoder3_code3b <= 3'd0;
		rx_decoder3_ones <= 4'd0;
		rx_decoder4_k <= 1'd0;
		rx_decoder4_code3b <= 3'd0;
		rx_decoder4_ones <= 4'd0;
		rx_tx_32bdone <= 1'd0;
		rx_tx_counter <= 5'd0;
		rx_tx_serial2 <= 1'd1;
		rx_tx_data <= 8'd0;
		rx_tx_bitn <= 3'd0;
		rx_tx_ready <= 1'd0;
		rx_tx_latch <= 8'd0;
		rx_tx_done <= 1'd0;
		rx_byte_cnt <= 4'd0;
		rx_readable <= 1'd0;
		rx_level0 <= 5'd0;
		rx_produce <= 5'd0;
		rx_consume <= 5'd0;
		rx_fsm_state <= 2'd0;
		rx_tx_state <= 2'd0;
		rx_state <= 2'd0;
	end
end

always @(posedge tx_clk_1) begin
	fifo_graycounter1_q_binary <= fifo_graycounter1_q_next_binary;
	fifo_graycounter1_q <= fifo_graycounter1_q_next;
	tx_singleencoder0_disp_in <= tx_singleencoder3_disp_out;
	tx_output0 <= tx_singleencoder0_output;
	tx_disparity0 <= tx_singleencoder0_disp_out;
	tx_output1 <= tx_singleencoder1_output;
	tx_disparity1 <= tx_singleencoder1_disp_out;
	tx_output2 <= tx_singleencoder2_output;
	tx_disparity2 <= tx_singleencoder2_disp_out;
	tx_output3 <= tx_singleencoder3_output;
	tx_disparity3 <= tx_singleencoder3_disp_out;
	if ((tx_singleencoder0_k & (tx_singleencoder0_d[4:0] == 5'd28))) begin
		tx_singleencoder0_code6b <= 6'd48;
		tx_singleencoder0_code6b_unbalanced <= 1'd1;
		tx_singleencoder0_code6b_flip <= 1'd1;
	end else begin
		tx_singleencoder0_code6b <= rhs_array_muxed0;
		tx_singleencoder0_code6b_unbalanced <= rhs_array_muxed1;
		tx_singleencoder0_code6b_flip <= rhs_array_muxed2;
	end
	tx_singleencoder0_code4b <= rhs_array_muxed3;
	tx_singleencoder0_code4b_unbalanced <= rhs_array_muxed4;
	if (tx_singleencoder0_k) begin
		tx_singleencoder0_code4b_flip <= 1'd1;
	end else begin
		tx_singleencoder0_code4b_flip <= rhs_array_muxed5;
	end
	tx_singleencoder0_alt7_rd0 <= 1'd0;
	tx_singleencoder0_alt7_rd1 <= 1'd0;
	if ((tx_singleencoder0_d[7:5] == 3'd7)) begin
		if ((((tx_singleencoder0_d[4:0] == 5'd17) | (tx_singleencoder0_d[4:0] == 5'd18)) | (tx_singleencoder0_d[4:0] == 5'd20))) begin
			tx_singleencoder0_alt7_rd0 <= 1'd1;
		end
		if ((((tx_singleencoder0_d[4:0] == 4'd11) | (tx_singleencoder0_d[4:0] == 4'd13)) | (tx_singleencoder0_d[4:0] == 4'd14))) begin
			tx_singleencoder0_alt7_rd1 <= 1'd1;
		end
		if (tx_singleencoder0_k) begin
			tx_singleencoder0_alt7_rd0 <= 1'd1;
			tx_singleencoder0_alt7_rd1 <= 1'd1;
		end
	end
	if ((tx_singleencoder1_k & (tx_singleencoder1_d[4:0] == 5'd28))) begin
		tx_singleencoder1_code6b <= 6'd48;
		tx_singleencoder1_code6b_unbalanced <= 1'd1;
		tx_singleencoder1_code6b_flip <= 1'd1;
	end else begin
		tx_singleencoder1_code6b <= rhs_array_muxed6;
		tx_singleencoder1_code6b_unbalanced <= rhs_array_muxed7;
		tx_singleencoder1_code6b_flip <= rhs_array_muxed8;
	end
	tx_singleencoder1_code4b <= rhs_array_muxed9;
	tx_singleencoder1_code4b_unbalanced <= rhs_array_muxed10;
	if (tx_singleencoder1_k) begin
		tx_singleencoder1_code4b_flip <= 1'd1;
	end else begin
		tx_singleencoder1_code4b_flip <= rhs_array_muxed11;
	end
	tx_singleencoder1_alt7_rd0 <= 1'd0;
	tx_singleencoder1_alt7_rd1 <= 1'd0;
	if ((tx_singleencoder1_d[7:5] == 3'd7)) begin
		if ((((tx_singleencoder1_d[4:0] == 5'd17) | (tx_singleencoder1_d[4:0] == 5'd18)) | (tx_singleencoder1_d[4:0] == 5'd20))) begin
			tx_singleencoder1_alt7_rd0 <= 1'd1;
		end
		if ((((tx_singleencoder1_d[4:0] == 4'd11) | (tx_singleencoder1_d[4:0] == 4'd13)) | (tx_singleencoder1_d[4:0] == 4'd14))) begin
			tx_singleencoder1_alt7_rd1 <= 1'd1;
		end
		if (tx_singleencoder1_k) begin
			tx_singleencoder1_alt7_rd0 <= 1'd1;
			tx_singleencoder1_alt7_rd1 <= 1'd1;
		end
	end
	if ((tx_singleencoder2_k & (tx_singleencoder2_d[4:0] == 5'd28))) begin
		tx_singleencoder2_code6b <= 6'd48;
		tx_singleencoder2_code6b_unbalanced <= 1'd1;
		tx_singleencoder2_code6b_flip <= 1'd1;
	end else begin
		tx_singleencoder2_code6b <= rhs_array_muxed12;
		tx_singleencoder2_code6b_unbalanced <= rhs_array_muxed13;
		tx_singleencoder2_code6b_flip <= rhs_array_muxed14;
	end
	tx_singleencoder2_code4b <= rhs_array_muxed15;
	tx_singleencoder2_code4b_unbalanced <= rhs_array_muxed16;
	if (tx_singleencoder2_k) begin
		tx_singleencoder2_code4b_flip <= 1'd1;
	end else begin
		tx_singleencoder2_code4b_flip <= rhs_array_muxed17;
	end
	tx_singleencoder2_alt7_rd0 <= 1'd0;
	tx_singleencoder2_alt7_rd1 <= 1'd0;
	if ((tx_singleencoder2_d[7:5] == 3'd7)) begin
		if ((((tx_singleencoder2_d[4:0] == 5'd17) | (tx_singleencoder2_d[4:0] == 5'd18)) | (tx_singleencoder2_d[4:0] == 5'd20))) begin
			tx_singleencoder2_alt7_rd0 <= 1'd1;
		end
		if ((((tx_singleencoder2_d[4:0] == 4'd11) | (tx_singleencoder2_d[4:0] == 4'd13)) | (tx_singleencoder2_d[4:0] == 4'd14))) begin
			tx_singleencoder2_alt7_rd1 <= 1'd1;
		end
		if (tx_singleencoder2_k) begin
			tx_singleencoder2_alt7_rd0 <= 1'd1;
			tx_singleencoder2_alt7_rd1 <= 1'd1;
		end
	end
	if ((tx_singleencoder3_k & (tx_singleencoder3_d[4:0] == 5'd28))) begin
		tx_singleencoder3_code6b <= 6'd48;
		tx_singleencoder3_code6b_unbalanced <= 1'd1;
		tx_singleencoder3_code6b_flip <= 1'd1;
	end else begin
		tx_singleencoder3_code6b <= rhs_array_muxed18;
		tx_singleencoder3_code6b_unbalanced <= rhs_array_muxed19;
		tx_singleencoder3_code6b_flip <= rhs_array_muxed20;
	end
	tx_singleencoder3_code4b <= rhs_array_muxed21;
	tx_singleencoder3_code4b_unbalanced <= rhs_array_muxed22;
	if (tx_singleencoder3_k) begin
		tx_singleencoder3_code4b_flip <= 1'd1;
	end else begin
		tx_singleencoder3_code4b_flip <= rhs_array_muxed23;
	end
	tx_singleencoder3_alt7_rd0 <= 1'd0;
	tx_singleencoder3_alt7_rd1 <= 1'd0;
	if ((tx_singleencoder3_d[7:5] == 3'd7)) begin
		if ((((tx_singleencoder3_d[4:0] == 5'd17) | (tx_singleencoder3_d[4:0] == 5'd18)) | (tx_singleencoder3_d[4:0] == 5'd20))) begin
			tx_singleencoder3_alt7_rd0 <= 1'd1;
		end
		if ((((tx_singleencoder3_d[4:0] == 4'd11) | (tx_singleencoder3_d[4:0] == 4'd13)) | (tx_singleencoder3_d[4:0] == 4'd14))) begin
			tx_singleencoder3_alt7_rd1 <= 1'd1;
		end
		if (tx_singleencoder3_k) begin
			tx_singleencoder3_alt7_rd0 <= 1'd1;
			tx_singleencoder3_alt7_rd1 <= 1'd1;
		end
	end
	if (tx_crc_encoder_i_data_strobe) begin
		tx_crc_encoder_crc_cur <= tx_crc_encoder_crc_next;
	end
	if (tx_crc_encoder_reset) begin
		tx_crc_encoder_crc_cur <= 20'd1048575;
	end
	tx_state <= tx_next_state;
	if (tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value_ce0) begin
		tx_stream_controller_fifo_re <= tx_stream_controller_fifo_re_clockdomainsrenamer0_t_next_value0;
	end
	if (tx_stream_controller_sop_clockdomainsrenamer0_t_next_value_ce1) begin
		tx_stream_controller_sop <= tx_stream_controller_sop_clockdomainsrenamer0_t_next_value1;
	end
	if (tx_stream_controller_idle_clockdomainsrenamer0_t_next_value_ce2) begin
		tx_stream_controller_idle <= tx_stream_controller_idle_clockdomainsrenamer0_t_next_value2;
	end
	if (tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value_ce0) begin
		tx_stream_controller_encoder_ready <= tx_stream_controller_encoder_ready_clockdomainsrenamer0_next_value0;
	end
	if (tx_stream_controller_intermediate_clockdomainsrenamer0_next_value_ce1) begin
		tx_stream_controller_intermediate <= tx_stream_controller_intermediate_clockdomainsrenamer0_next_value1;
	end
	if (tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value_ce2) begin
		tx_stream_controller_strobe_crc <= tx_stream_controller_strobe_crc_clockdomainsrenamer0_next_value2;
	end
	if (tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value_ce0) begin
		tx_stream_controller_aux_ign <= tx_stream_controller_aux_ign_clockdomainsrenamer0_cases_next_value0;
	end
	if (tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value_ce1) begin
		tx_stream_controller_eop <= tx_stream_controller_eop_clockdomainsrenamer0_cases_next_value1;
	end
	if (tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value_ce2) begin
		tx_stream_controller_reset_crc <= tx_stream_controller_reset_crc_clockdomainsrenamer0_cases_next_value2;
	end
	if (tx_stream_controller_reset) begin
		tx_stream_controller_sop <= 1'd0;
		tx_stream_controller_eop <= 1'd0;
		tx_stream_controller_idle <= 1'd0;
		tx_stream_controller_intermediate <= 1'd0;
		tx_stream_controller_encoder_ready <= 1'd0;
		tx_stream_controller_fifo_re <= 1'd0;
		tx_stream_controller_strobe_crc <= 1'd0;
		tx_stream_controller_reset_crc <= 1'd0;
		tx_stream_controller_aux_ign <= 1'd0;
		tx_state <= 3'd0;
	end
	if (tx_rst) begin
		tx_output0 <= 10'd0;
		tx_output1 <= 10'd0;
		tx_output2 <= 10'd0;
		tx_output3 <= 10'd0;
		tx_disparity0 <= 1'd0;
		tx_disparity1 <= 1'd0;
		tx_disparity2 <= 1'd0;
		tx_disparity3 <= 1'd0;
		tx_singleencoder0_disp_in <= 1'd0;
		tx_singleencoder0_code6b <= 6'd0;
		tx_singleencoder0_code6b_unbalanced <= 1'd0;
		tx_singleencoder0_code6b_flip <= 1'd0;
		tx_singleencoder0_code4b <= 4'd0;
		tx_singleencoder0_code4b_unbalanced <= 1'd0;
		tx_singleencoder0_code4b_flip <= 1'd0;
		tx_singleencoder0_alt7_rd0 <= 1'd0;
		tx_singleencoder0_alt7_rd1 <= 1'd0;
		tx_singleencoder1_code6b <= 6'd0;
		tx_singleencoder1_code6b_unbalanced <= 1'd0;
		tx_singleencoder1_code6b_flip <= 1'd0;
		tx_singleencoder1_code4b <= 4'd0;
		tx_singleencoder1_code4b_unbalanced <= 1'd0;
		tx_singleencoder1_code4b_flip <= 1'd0;
		tx_singleencoder1_alt7_rd0 <= 1'd0;
		tx_singleencoder1_alt7_rd1 <= 1'd0;
		tx_singleencoder2_code6b <= 6'd0;
		tx_singleencoder2_code6b_unbalanced <= 1'd0;
		tx_singleencoder2_code6b_flip <= 1'd0;
		tx_singleencoder2_code4b <= 4'd0;
		tx_singleencoder2_code4b_unbalanced <= 1'd0;
		tx_singleencoder2_code4b_flip <= 1'd0;
		tx_singleencoder2_alt7_rd0 <= 1'd0;
		tx_singleencoder2_alt7_rd1 <= 1'd0;
		tx_singleencoder3_code6b <= 6'd0;
		tx_singleencoder3_code6b_unbalanced <= 1'd0;
		tx_singleencoder3_code6b_flip <= 1'd0;
		tx_singleencoder3_code4b <= 4'd0;
		tx_singleencoder3_code4b_unbalanced <= 1'd0;
		tx_singleencoder3_code4b_flip <= 1'd0;
		tx_singleencoder3_alt7_rd0 <= 1'd0;
		tx_singleencoder3_alt7_rd1 <= 1'd0;
		tx_crc_encoder_crc_cur <= 20'd1048575;
		tx_stream_controller_sop <= 1'd0;
		tx_stream_controller_eop <= 1'd0;
		tx_stream_controller_idle <= 1'd0;
		tx_stream_controller_intermediate <= 1'd0;
		tx_stream_controller_encoder_ready <= 1'd0;
		tx_stream_controller_fifo_re <= 1'd0;
		tx_stream_controller_strobe_crc <= 1'd0;
		tx_stream_controller_reset_crc <= 1'd0;
		tx_stream_controller_aux_ign <= 1'd0;
		fifo_graycounter1_q <= 6'd0;
		fifo_graycounter1_q_binary <= 6'd0;
		tx_state <= 3'd0;
	end
	multiregimpl0_regs0 <= tx_tx_init_done0;
	multiregimpl0_regs1 <= multiregimpl0_regs0;
	multiregimpl1_regs0 <= tx_fifo_empty0;
	multiregimpl1_regs1 <= multiregimpl1_regs0;
	multiregimpl2_regs0 <= fifo_graycounter0_q;
	multiregimpl2_regs1 <= multiregimpl2_regs0;
end

always @(posedge write_clk_1) begin
	fifo_graycounter0_q_binary <= fifo_graycounter0_q_next_binary;
	fifo_graycounter0_q <= fifo_graycounter0_q_next;
	if (enable) begin
		state <= {(((((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])) ^ (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1]))) ^ ((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2])))), (((((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))) ^ (((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0]))) ^ ((((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])) ^ (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])))), (((((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))) ^ (((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6])))) ^ ((((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))) ^ (((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])))), (((((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))) ^ (((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5])))) ^ ((((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))) ^ (((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))))), (((((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3]))) ^ (((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4])))) ^ ((((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))) ^ (((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))))), ((((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2]))) ^ (((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3])))) ^ ((((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3]))) ^ (((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))))), ((((((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])) ^ (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1]))) ^ ((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2])))) ^ (((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2]))) ^ (((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3])))))};
		o <= {(state[5] ^ state[6]), (state[4] ^ state[5]), (state[3] ^ state[4]), (state[2] ^ state[3]), (state[1] ^ state[2]), (state[0] ^ state[1]), ((state[5] ^ state[6]) ^ state[0]), ((state[4] ^ state[5]) ^ (state[5] ^ state[6])), ((state[3] ^ state[4]) ^ (state[4] ^ state[5])), ((state[2] ^ state[3]) ^ (state[3] ^ state[4])), ((state[1] ^ state[2]) ^ (state[2] ^ state[3])), ((state[0] ^ state[1]) ^ (state[1] ^ state[2])), (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])), (((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])), (((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))), (((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))), (((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))), (((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3]))), ((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2]))), ((((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])) ^ (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1]))), ((((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))) ^ (((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0]))), ((((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))) ^ (((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6])))), ((((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))) ^ (((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5])))), ((((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3]))) ^ (((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4])))), (((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2]))) ^ (((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3])))), (((((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])) ^ (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1]))) ^ ((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2])))), (((((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))) ^ (((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0]))) ^ ((((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])) ^ (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])))), (((((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))) ^ (((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6])))) ^ ((((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))) ^ (((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])))), (((((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))) ^ (((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5])))) ^ ((((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))) ^ (((state[3] ^ state[4]) ^ (state[4] ^ state[5])) ^ ((state[4] ^ state[5]) ^ (state[5] ^ state[6]))))), (((((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3]))) ^ (((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4])))) ^ ((((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))) ^ (((state[2] ^ state[3]) ^ (state[3] ^ state[4])) ^ ((state[3] ^ state[4]) ^ (state[4] ^ state[5]))))), ((((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2]))) ^ (((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3])))) ^ ((((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3]))) ^ (((state[1] ^ state[2]) ^ (state[2] ^ state[3])) ^ ((state[2] ^ state[3]) ^ (state[3] ^ state[4]))))), ((((((state[4] ^ state[5]) ^ (state[5] ^ state[6])) ^ ((state[5] ^ state[6]) ^ state[0])) ^ (((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1]))) ^ ((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2])))) ^ (((((state[5] ^ state[6]) ^ state[0]) ^ (state[0] ^ state[1])) ^ ((state[0] ^ state[1]) ^ (state[1] ^ state[2]))) ^ (((state[0] ^ state[1]) ^ (state[1] ^ state[2])) ^ ((state[1] ^ state[2]) ^ (state[2] ^ state[3])))))};
	end
	fsm_state <= fsm_next_state;
	if (prbs_en_clockdomainsrenamer2_next_value_ce0) begin
		prbs_en <= prbs_en_clockdomainsrenamer2_next_value0;
	end
	if (data_type_clockdomainsrenamer2_next_value_ce1) begin
		data_type <= data_type_clockdomainsrenamer2_next_value1;
	end
	if (write_fifo_clockdomainsrenamer2_next_value_ce2) begin
		write_fifo <= write_fifo_clockdomainsrenamer2_next_value2;
	end
	if (index_clockdomainsrenamer2_next_value_ce3) begin
		index <= index_clockdomainsrenamer2_next_value3;
	end
	if (write_rst) begin
		fifo_graycounter0_q <= 6'd0;
		fifo_graycounter0_q_binary <= 6'd0;
		o <= 32'd0;
		state <= 7'd1;
		prbs_en <= 1'd0;
		data_type <= 2'd0;
		index <= 3'd0;
		write_fifo <= 1'd0;
		fsm_state <= 3'd0;
	end
	multiregimpl3_regs0 <= fifo_graycounter1_q;
	multiregimpl3_regs1 <= multiregimpl3_regs0;
end

reg [4:0] mem_6b5b[0:63];
reg [5:0] memadr;
always @(posedge rx_clk_1) begin
	memadr <= rx_decoder1_adr;
end

assign rx_decoder1_dat_r = mem_6b5b[memadr];

initial begin
	$readmemh("mem_6b5b.init", mem_6b5b);
end

reg [4:0] mem_6b5b_1[0:63];
reg [5:0] memadr_1;
always @(posedge rx_clk_1) begin
	memadr_1 <= rx_decoder2_adr;
end

assign rx_decoder2_dat_r = mem_6b5b_1[memadr_1];

initial begin
	$readmemh("mem_6b5b_1.init", mem_6b5b_1);
end

reg [4:0] mem_6b5b_2[0:63];
reg [5:0] memadr_2;
always @(posedge rx_clk_1) begin
	memadr_2 <= rx_decoder3_adr;
end

assign rx_decoder3_dat_r = mem_6b5b_2[memadr_2];

initial begin
	$readmemh("mem_6b5b_2.init", mem_6b5b_2);
end

reg [4:0] mem_6b5b_3[0:63];
reg [5:0] memadr_3;
always @(posedge rx_clk_1) begin
	memadr_3 <= rx_decoder4_adr;
end

assign rx_decoder4_dat_r = mem_6b5b_3[memadr_3];

initial begin
	$readmemh("mem_6b5b_3.init", mem_6b5b_3);
end

reg [31:0] storage[0:19];
reg [31:0] memdat;
reg [31:0] memdat_1;
always @(posedge rx_clk_1) begin
	if (rx_wrport_we)
		storage[rx_wrport_adr] <= rx_wrport_dat_w;
	memdat <= storage[rx_wrport_adr];
end

always @(posedge rx_clk_1) begin
	if (rx_rdport_re)
		memdat_1 <= storage[rx_rdport_adr];
end

assign rx_wrport_dat_r = memdat;
assign rx_rdport_dat_r = memdat_1;

reg [33:0] storage_1[0:31];
reg [4:0] memadr_4;
reg [4:0] memadr_5;
always @(posedge write_clk_1) begin
	if (fifo_wrport_we)
		storage_1[fifo_wrport_adr] <= fifo_wrport_dat_w;
	memadr_4 <= fifo_wrport_adr;
end

always @(posedge tx_clk_1) begin
	memadr_5 <= fifo_rdport_adr;
end

assign fifo_wrport_dat_r = storage_1[memadr_4];
assign fifo_rdport_dat_r = storage_1[memadr_5];

endmodule
