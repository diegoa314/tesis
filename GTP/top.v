//--------------------------------------------------------------------------------
// Auto-generated by Migen (--------) & LiteX (690de79) on 2020-03-04 16:38:25
//--------------------------------------------------------------------------------
module top(
	input gtp_refclk_p,
	input gtp_refclk_n,
	output gtp_tx_p,
	output gtp_tx_n,
	input gtp_rx_p,
	input gtp_rx_n
);

wire sys_clk_1;
wire sys_clk;
wire sys_rst;
wire por_clk;
reg int_rst = 1'd1;
wire refclk100;
wire refclk0;
wire pll_fb;
wire clk;
wire refclk1;
wire reset;
wire lock;
wire plllock;
reg [2:0] loopback = 3'd0;
reg tx_polarity = 1'd0;
reg rx_polarity = 1'd0;
reg [3:0] diffctrl = 4'd0;
reg [4:0] txprecursor = 5'd0;
reg [4:0] txpostcursor = 5'd0;
reg tx_reset_host = 1'd0;
wire rx_reset_ack;
wire tx_reset_ack;
wire [8:0] drpaddr;
wire drpen;
wire [15:0] drpdi;
wire drprdy;
wire [15:0] drpdo;
wire drpwe;
reg [19:0] txdata = 20'd0;
reg [11:0] count = 12'd0;
wire [19:0] rxdata;
reg tx_init_done = 1'd0;
wire tx_init_restart;
wire tx_init_plllock0;
reg tx_init_pllreset = 1'd0;
reg tx_init_gttxreset0 = 1'd0;
wire tx_init_txresetdone0;
reg tx_init_txdlysreset0 = 1'd0;
wire tx_init_txdlysresetdone0;
reg tx_init_txphinit0 = 1'd0;
wire tx_init_txphinitdone0;
reg tx_init_txphalign0 = 1'd0;
wire tx_init_txphaligndone0;
reg tx_init_txdlyen0 = 1'd0;
reg tx_init_txuserrdy0 = 1'd0;
wire tx_init_plllock1;
wire tx_init_txresetdone1;
wire tx_init_txdlysresetdone1;
wire tx_init_txphinitdone1;
wire tx_init_txphaligndone1;
reg tx_init_gttxreset1 = 1'd0;
reg tx_init_txdlysreset1 = 1'd0;
reg tx_init_txphinit1 = 1'd0;
reg tx_init_txphalign1 = 1'd0;
reg tx_init_txdlyen1 = 1'd0;
reg tx_init_txuserrdy1 = 1'd0;
reg tx_init_pll_reset_timer_wait = 1'd0;
wire tx_init_pll_reset_timer_done;
reg [5:0] tx_init_pll_reset_timer_count = 6'd50;
wire tx_init_reset;
wire tx_init_ready_timer_wait;
wire tx_init_ready_timer_done;
reg [16:0] tx_init_ready_timer_count = 17'd100000;
reg tx_init_txphaligndone_r = 1'd1;
wire tx_init_txphaligndone_rising;
reg gtprxinit_done = 1'd0;
reg gtprxinit_restart = 1'd0;
wire gtprxinit_plllock0;
reg gtprxinit_gtrxreset0 = 1'd0;
reg gtprxinit_gtrxpd0 = 1'd0;
wire gtprxinit_rxresetdone0;
reg gtprxinit_rxdlysreset0 = 1'd0;
wire gtprxinit_rxdlysresetdone0;
reg gtprxinit_rxphalign0 = 1'd0;
reg gtprxinit_rxdlyen0 = 1'd0;
reg gtprxinit_rxuserrdy0 = 1'd0;
wire gtprxinit_rxsyncdone0;
wire gtprxinit_rxpmaresetdone0;
wire [8:0] gtprxinit_drpaddr;
reg gtprxinit_drpen = 1'd0;
reg [15:0] gtprxinit_drpdi = 16'd0;
wire gtprxinit_drprdy;
wire [15:0] gtprxinit_drpdo;
reg gtprxinit_drpwe = 1'd0;
reg gtprxinit_drp_mux_sel = 1'd0;
wire gtprxinit_rxpmaresetdone1;
reg gtprxinit_rxpmaresetdone_r = 1'd0;
wire gtprxinit_plllock1;
wire gtprxinit_rxresetdone1;
wire gtprxinit_rxdlysresetdone1;
wire gtprxinit_rxsyncdone1;
reg gtprxinit_gtrxreset1 = 1'd0;
reg gtprxinit_gtrxpd1 = 1'd0;
reg gtprxinit_rxdlysreset1 = 1'd0;
reg gtprxinit_rxphalign1 = 1'd0;
reg gtprxinit_rxdlyen1 = 1'd0;
reg gtprxinit_rxuserrdy1 = 1'd0;
reg gtprxinit_pll_reset_timer_wait = 1'd0;
wire gtprxinit_pll_reset_timer_done;
reg [6:0] gtprxinit_pll_reset_timer_count = 7'd120;
wire gtprxinit_reset;
wire gtprxinit_ready_timer_wait;
wire gtprxinit_ready_timer_done;
reg [19:0] gtprxinit_ready_timer_count = 20'd960000;
reg gtprxinit_cdr_stable_timer_wait = 1'd0;
wire gtprxinit_cdr_stable_timer_done;
reg [10:0] gtprxinit_cdr_stable_timer_count = 11'd1024;
reg gtprxinit_st_gtp_pd = 1'd0;
reg gtprxinit_st_gtp_pll_wait = 1'd0;
reg gtprxinit_state_10 = 1'd0;
reg gtprxinit_state_11 = 1'd0;
reg gtprxinit_state_12 = 1'd0;
reg gtprxinit_state_13 = 1'd0;
reg gtprxinit_flag = 1'd0;
reg [15:0] gtprxinit_rd_data = 16'd0;
reg [15:0] gtprxinit_next_rd_data = 16'd0;
reg [15:0] gtprxinit_original_rd_data = 16'd0;
reg gtprxinit_st_drp_rd = 1'd0;
reg gtprxinit_st_wait_rd_data = 1'd0;
reg gtprxinit_st_wr_16 = 1'd0;
reg gtprxinit_st_wait_wr_done1 = 1'd0;
reg gtprxinit_st_wait_pmareset = 1'd0;
reg gtprxinit_st_wr_20 = 1'd0;
reg gtprxinit_st_drprdy_deassert = 1'd0;
reg gtprxinit_st_wait_wr_done2 = 1'd0;
wire txoutclk;
wire rxoutclk;
wire rxphaligndone;
wire rx_aligned0;
wire aligment_en0;
wire coma_detected0;
wire rx_aligned1;
reg aligment_en1 = 1'd0;
wire coma_detected1;
wire rx_init_done;
wire tx_clk;
reg tx_rst = 1'd0;
wire rx_clk;
reg [2:0] gtptxinit_state = 3'd0;
reg [2:0] gtptxinit_next_state = 3'd0;
reg [3:0] clockdomainsrenamer_state = 4'd0;
reg [3:0] clockdomainsrenamer_next_state = 4'd0;
reg [1:0] commaaligner_state = 2'd0;
reg [1:0] commaaligner_next_state = 2'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl0_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl0_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl1_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl1_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl2_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl2_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl3_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl3_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl4_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl4_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl5_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl5_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl6_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl6_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl7_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl7_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl8_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl8_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl9_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl9_regs1 = 1'd0;

assign sys_clk = sys_clk_1;
assign por_clk = sys_clk_1;
assign sys_rst = int_rst;
assign tx_reset_ack = tx_init_done;
assign rx_reset_ack = gtprxinit_done;
assign tx_init_restart = tx_reset_host;
assign plllock = lock;
assign tx_init_plllock0 = lock;
assign gtprxinit_plllock0 = lock;
assign reset = tx_init_pllreset;
assign drpaddr = gtprxinit_drpaddr;
assign drpdi = gtprxinit_drpdi;
assign gtprxinit_drpdo = drpdo;
assign drpen = gtprxinit_drpen;
assign drpwe = gtprxinit_drpwe;
assign gtprxinit_drprdy = drprdy;
assign rx_aligned1 = rx_aligned0;
assign aligment_en0 = aligment_en1;
assign coma_detected1 = coma_detected0;
assign rx_init_done = gtprxinit_done;
always @(*) begin
	txdata <= 20'd0;
	if ((count != 1'd0)) begin
		txdata <= 9'd380;
	end else begin
		txdata <= 20'd790275;
	end
end
assign tx_init_ready_timer_wait = ((~tx_init_done) & (~tx_init_reset));
assign tx_init_reset = (tx_init_restart | tx_init_ready_timer_done);
assign tx_init_txphaligndone_rising = (tx_init_txphaligndone1 & (~tx_init_txphaligndone_r));
assign tx_init_pll_reset_timer_done = (tx_init_pll_reset_timer_count == 1'd0);
always @(*) begin
	tx_init_txdlyen1 <= 1'd0;
	tx_init_txuserrdy1 <= 1'd0;
	tx_init_pll_reset_timer_wait <= 1'd0;
	tx_init_done <= 1'd0;
	tx_init_pllreset <= 1'd0;
	gtptxinit_next_state <= 3'd0;
	tx_init_gttxreset1 <= 1'd0;
	tx_init_txdlysreset1 <= 1'd0;
	tx_init_txphinit1 <= 1'd0;
	tx_init_txphalign1 <= 1'd0;
	gtptxinit_next_state <= gtptxinit_state;
	case (gtptxinit_state)
		1'd1: begin
			tx_init_gttxreset1 <= 1'd1;
			if (tx_init_plllock1) begin
				gtptxinit_next_state <= 2'd2;
			end
		end
		2'd2: begin
			tx_init_gttxreset1 <= 1'd0;
			tx_init_txuserrdy1 <= 1'd1;
			if (tx_init_txresetdone1) begin
				gtptxinit_next_state <= 2'd3;
			end
		end
		2'd3: begin
			tx_init_txuserrdy1 <= 1'd1;
			tx_init_txdlysreset1 <= 1'd1;
			if (tx_init_txdlysresetdone1) begin
				gtptxinit_next_state <= 3'd4;
			end
		end
		3'd4: begin
			tx_init_txuserrdy1 <= 1'd1;
			tx_init_txphinit1 <= 1'd1;
			if (tx_init_txphinitdone1) begin
				gtptxinit_next_state <= 3'd5;
			end
		end
		3'd5: begin
			tx_init_txuserrdy1 <= 1'd1;
			tx_init_txphalign1 <= 1'd1;
			if (tx_init_txphaligndone_rising) begin
				gtptxinit_next_state <= 3'd6;
			end
		end
		3'd6: begin
			tx_init_txuserrdy1 <= 1'd1;
			tx_init_txdlyen1 <= 1'd1;
			if (tx_init_txphaligndone_rising) begin
				gtptxinit_next_state <= 3'd7;
			end
		end
		3'd7: begin
			tx_init_txuserrdy1 <= 1'd1;
			tx_init_done <= 1'd1;
			if (tx_init_restart) begin
				gtptxinit_next_state <= 1'd0;
			end
		end
		default: begin
			tx_init_pll_reset_timer_wait <= 1'd1;
			if (tx_init_pll_reset_timer_done) begin
				tx_init_pllreset <= 1'd1;
				gtptxinit_next_state <= 1'd1;
			end
		end
	endcase
end
assign tx_init_ready_timer_done = (tx_init_ready_timer_count == 1'd0);
assign gtprxinit_drpaddr = 5'd17;
assign gtprxinit_ready_timer_wait = ((~gtprxinit_done) & (~gtprxinit_reset));
assign gtprxinit_reset = (gtprxinit_restart | gtprxinit_ready_timer_done);
always @(*) begin
	gtprxinit_drpen <= 1'd0;
	gtprxinit_drpdi <= 16'd0;
	gtprxinit_gtrxreset1 <= 1'd0;
	gtprxinit_drpwe <= 1'd0;
	gtprxinit_next_rd_data <= 16'd0;
	if (gtprxinit_st_gtp_pll_wait) begin
		gtprxinit_gtrxreset1 <= 1'd1;
	end else begin
		if (gtprxinit_st_drp_rd) begin
			gtprxinit_gtrxreset1 <= 1'd1;
			gtprxinit_drpen <= 1'd1;
			gtprxinit_drpwe <= 1'd0;
		end else begin
			if (gtprxinit_st_wait_rd_data) begin
				gtprxinit_gtrxreset1 <= 1'd1;
				if ((gtprxinit_drprdy & (~gtprxinit_flag))) begin
					gtprxinit_next_rd_data <= gtprxinit_drpdo;
				end else begin
					if ((gtprxinit_drprdy & gtprxinit_flag)) begin
						gtprxinit_next_rd_data <= gtprxinit_original_rd_data;
					end else begin
						gtprxinit_next_rd_data <= gtprxinit_rd_data;
					end
				end
			end else begin
				if (gtprxinit_st_drprdy_deassert) begin
					gtprxinit_gtrxreset1 <= 1'd1;
				end else begin
					if (gtprxinit_st_wr_16) begin
						gtprxinit_gtrxreset1 <= 1'd1;
						gtprxinit_drpen <= 1'd1;
						gtprxinit_drpwe <= 1'd1;
						gtprxinit_drpdi <= (gtprxinit_rd_data ^ 12'd2048);
					end else begin
						if (gtprxinit_st_wait_wr_done1) begin
							gtprxinit_gtrxreset1 <= 1'd1;
						end else begin
							if (gtprxinit_st_wait_pmareset) begin
								gtprxinit_gtrxreset1 <= 1'd0;
							end else begin
								if (gtprxinit_st_wr_20) begin
									gtprxinit_drpen <= 1'd1;
									gtprxinit_drpwe <= 1'd1;
									gtprxinit_drpdi <= gtprxinit_rd_data;
								end else begin
									gtprxinit_next_rd_data <= gtprxinit_rd_data;
								end
							end
						end
					end
				end
			end
		end
	end
end
assign gtprxinit_pll_reset_timer_done = (gtprxinit_pll_reset_timer_count == 1'd0);
always @(*) begin
	gtprxinit_state_12 <= 1'd0;
	gtprxinit_state_13 <= 1'd0;
	gtprxinit_st_drp_rd <= 1'd0;
	gtprxinit_st_wait_rd_data <= 1'd0;
	gtprxinit_st_wr_16 <= 1'd0;
	gtprxinit_st_wait_wr_done1 <= 1'd0;
	gtprxinit_st_wait_pmareset <= 1'd0;
	gtprxinit_st_wr_20 <= 1'd0;
	gtprxinit_st_drprdy_deassert <= 1'd0;
	gtprxinit_drp_mux_sel <= 1'd0;
	gtprxinit_st_wait_wr_done2 <= 1'd0;
	gtprxinit_cdr_stable_timer_wait <= 1'd0;
	gtprxinit_st_gtp_pd <= 1'd0;
	gtprxinit_st_gtp_pll_wait <= 1'd0;
	clockdomainsrenamer_next_state <= 4'd0;
	gtprxinit_gtrxpd1 <= 1'd0;
	gtprxinit_done <= 1'd0;
	gtprxinit_rxdlysreset1 <= 1'd0;
	gtprxinit_state_10 <= 1'd0;
	gtprxinit_rxuserrdy1 <= 1'd0;
	gtprxinit_state_11 <= 1'd0;
	gtprxinit_pll_reset_timer_wait <= 1'd0;
	clockdomainsrenamer_next_state <= clockdomainsrenamer_state;
	case (clockdomainsrenamer_state)
		1'd1: begin
			gtprxinit_drp_mux_sel <= 1'd1;
			if (gtprxinit_plllock1) begin
				clockdomainsrenamer_next_state <= 2'd2;
			end
			gtprxinit_st_gtp_pll_wait <= 1'd1;
		end
		2'd2: begin
			clockdomainsrenamer_next_state <= 2'd3;
			gtprxinit_st_drp_rd <= 1'd1;
		end
		2'd3: begin
			if (gtprxinit_drprdy) begin
				clockdomainsrenamer_next_state <= 3'd4;
			end
			gtprxinit_st_wait_rd_data <= 1'd1;
		end
		3'd4: begin
			if ((~gtprxinit_drprdy)) begin
				clockdomainsrenamer_next_state <= 3'd5;
			end
			gtprxinit_st_drprdy_deassert <= 1'd1;
		end
		3'd5: begin
			clockdomainsrenamer_next_state <= 3'd6;
			gtprxinit_st_wr_16 <= 1'd1;
		end
		3'd6: begin
			if (gtprxinit_drprdy) begin
				clockdomainsrenamer_next_state <= 3'd7;
			end
			gtprxinit_st_wait_wr_done1 <= 1'd1;
		end
		3'd7: begin
			if ((gtprxinit_rxpmaresetdone_r & (~gtprxinit_rxpmaresetdone1))) begin
				clockdomainsrenamer_next_state <= 4'd8;
			end
			gtprxinit_st_wait_pmareset <= 1'd1;
		end
		4'd8: begin
			clockdomainsrenamer_next_state <= 4'd9;
			gtprxinit_st_wr_20 <= 1'd1;
		end
		4'd9: begin
			if (gtprxinit_drprdy) begin
				clockdomainsrenamer_next_state <= 4'd10;
			end
			gtprxinit_st_wait_wr_done2 <= 1'd1;
		end
		4'd10: begin
			gtprxinit_drp_mux_sel <= 1'd1;
			gtprxinit_rxuserrdy1 <= 1'd1;
			gtprxinit_cdr_stable_timer_wait <= 1'd1;
			if ((gtprxinit_rxresetdone1 & gtprxinit_cdr_stable_timer_done)) begin
				clockdomainsrenamer_next_state <= 4'd11;
			end
			gtprxinit_state_10 <= 1'd1;
		end
		4'd11: begin
			gtprxinit_drp_mux_sel <= 1'd1;
			gtprxinit_rxuserrdy1 <= 1'd1;
			gtprxinit_rxdlysreset1 <= 1'd1;
			if (gtprxinit_rxdlysresetdone1) begin
				clockdomainsrenamer_next_state <= 4'd12;
			end
			gtprxinit_state_11 <= 1'd1;
		end
		4'd12: begin
			gtprxinit_drp_mux_sel <= 1'd1;
			gtprxinit_rxuserrdy1 <= 1'd1;
			if (gtprxinit_rxsyncdone1) begin
				clockdomainsrenamer_next_state <= 4'd13;
			end
			gtprxinit_state_12 <= 1'd1;
		end
		4'd13: begin
			gtprxinit_rxuserrdy1 <= 1'd1;
			gtprxinit_done <= 1'd1;
			if (gtprxinit_restart) begin
				clockdomainsrenamer_next_state <= 1'd0;
			end
			gtprxinit_state_13 <= 1'd1;
		end
		default: begin
			gtprxinit_drp_mux_sel <= 1'd1;
			gtprxinit_gtrxpd1 <= 1'd1;
			gtprxinit_pll_reset_timer_wait <= 1'd1;
			if (gtprxinit_pll_reset_timer_done) begin
				clockdomainsrenamer_next_state <= 1'd1;
			end
			gtprxinit_st_gtp_pd <= 1'd1;
		end
	endcase
end
assign gtprxinit_ready_timer_done = (gtprxinit_ready_timer_count == 1'd0);
assign gtprxinit_cdr_stable_timer_done = (gtprxinit_cdr_stable_timer_count == 1'd0);
always @(*) begin
	commaaligner_next_state <= 2'd0;
	aligment_en1 <= 1'd0;
	commaaligner_next_state <= commaaligner_state;
	case (commaaligner_state)
		1'd1: begin
			aligment_en1 <= 1'd1;
			if (coma_detected1) begin
				commaaligner_next_state <= 2'd2;
			end
		end
		2'd2: begin
			aligment_en1 <= 1'd1;
			if (rx_aligned1) begin
				commaaligner_next_state <= 2'd3;
				aligment_en1 <= 1'd1;
			end
		end
		2'd3: begin
			aligment_en1 <= 1'd1;
		end
		default: begin
			if (rx_init_done) begin
				commaaligner_next_state <= 1'd1;
			end
		end
	endcase
end
assign tx_init_plllock1 = xilinxmultiregimpl0_regs1;
assign tx_init_txresetdone1 = xilinxmultiregimpl1_regs1;
assign tx_init_txdlysresetdone1 = xilinxmultiregimpl2_regs1;
assign tx_init_txphinitdone1 = xilinxmultiregimpl3_regs1;
assign tx_init_txphaligndone1 = xilinxmultiregimpl4_regs1;
assign gtprxinit_rxpmaresetdone1 = xilinxmultiregimpl5_regs1;
assign gtprxinit_plllock1 = xilinxmultiregimpl6_regs1;
assign gtprxinit_rxresetdone1 = xilinxmultiregimpl7_regs1;
assign gtprxinit_rxdlysresetdone1 = xilinxmultiregimpl8_regs1;
assign gtprxinit_rxsyncdone1 = xilinxmultiregimpl9_regs1;

always @(posedge por_clk) begin
	int_rst <= 1'd0;
end

always @(posedge sys_clk) begin
	tx_init_gttxreset0 <= tx_init_gttxreset1;
	tx_init_txdlysreset0 <= tx_init_txdlysreset1;
	tx_init_txphinit0 <= tx_init_txphinit1;
	tx_init_txphalign0 <= tx_init_txphalign1;
	tx_init_txdlyen0 <= tx_init_txdlyen1;
	tx_init_txuserrdy0 <= tx_init_txuserrdy1;
	tx_init_txphaligndone_r <= tx_init_txphaligndone1;
	if (tx_init_pll_reset_timer_wait) begin
		if ((~tx_init_pll_reset_timer_done)) begin
			tx_init_pll_reset_timer_count <= (tx_init_pll_reset_timer_count - 1'd1);
		end
	end else begin
		tx_init_pll_reset_timer_count <= 6'd50;
	end
	gtptxinit_state <= gtptxinit_next_state;
	if (tx_init_reset) begin
		gtptxinit_state <= 3'd0;
	end
	if (tx_init_ready_timer_wait) begin
		if ((~tx_init_ready_timer_done)) begin
			tx_init_ready_timer_count <= (tx_init_ready_timer_count - 1'd1);
		end
	end else begin
		tx_init_ready_timer_count <= 17'd100000;
	end
	commaaligner_state <= commaaligner_next_state;
	if (sys_rst) begin
		tx_init_gttxreset0 <= 1'd0;
		tx_init_txdlysreset0 <= 1'd0;
		tx_init_txphinit0 <= 1'd0;
		tx_init_txphalign0 <= 1'd0;
		tx_init_txdlyen0 <= 1'd0;
		tx_init_txuserrdy0 <= 1'd0;
		tx_init_pll_reset_timer_count <= 6'd50;
		tx_init_ready_timer_count <= 17'd100000;
		tx_init_txphaligndone_r <= 1'd1;
		gtptxinit_state <= 3'd0;
		commaaligner_state <= 2'd0;
	end
	xilinxmultiregimpl0_regs0 <= tx_init_plllock0;
	xilinxmultiregimpl0_regs1 <= xilinxmultiregimpl0_regs0;
	xilinxmultiregimpl1_regs0 <= tx_init_txresetdone0;
	xilinxmultiregimpl1_regs1 <= xilinxmultiregimpl1_regs0;
	xilinxmultiregimpl2_regs0 <= tx_init_txdlysresetdone0;
	xilinxmultiregimpl2_regs1 <= xilinxmultiregimpl2_regs0;
	xilinxmultiregimpl3_regs0 <= tx_init_txphinitdone0;
	xilinxmultiregimpl3_regs1 <= xilinxmultiregimpl3_regs0;
	xilinxmultiregimpl4_regs0 <= tx_init_txphaligndone0;
	xilinxmultiregimpl4_regs1 <= xilinxmultiregimpl4_regs0;
end

always @(posedge tx_clk) begin
	count <= (count + 1'd1);
	gtprxinit_rxpmaresetdone_r <= gtprxinit_rxpmaresetdone1;
	gtprxinit_gtrxreset0 <= gtprxinit_gtrxreset1;
	gtprxinit_gtrxpd0 <= gtprxinit_gtrxpd1;
	gtprxinit_rxdlysreset0 <= gtprxinit_rxdlysreset1;
	gtprxinit_rxphalign0 <= gtprxinit_rxphalign1;
	gtprxinit_rxdlyen0 <= gtprxinit_rxdlyen1;
	gtprxinit_rxuserrdy0 <= gtprxinit_rxuserrdy1;
	if ((((gtprxinit_st_wr_16 | gtprxinit_st_wait_pmareset) | gtprxinit_st_wr_20) | gtprxinit_st_wait_wr_done1)) begin
		gtprxinit_flag <= 1'd1;
	end else begin
		if (gtprxinit_st_wait_wr_done2) begin
			gtprxinit_flag <= 1'd0;
		end
	end
	if (((gtprxinit_st_wait_rd_data & gtprxinit_drprdy) & (~gtprxinit_flag))) begin
		gtprxinit_original_rd_data <= gtprxinit_drpdo;
	end
	gtprxinit_rd_data <= gtprxinit_next_rd_data;
	if (gtprxinit_pll_reset_timer_wait) begin
		if ((~gtprxinit_pll_reset_timer_done)) begin
			gtprxinit_pll_reset_timer_count <= (gtprxinit_pll_reset_timer_count - 1'd1);
		end
	end else begin
		gtprxinit_pll_reset_timer_count <= 7'd120;
	end
	clockdomainsrenamer_state <= clockdomainsrenamer_next_state;
	if (gtprxinit_reset) begin
		clockdomainsrenamer_state <= 4'd0;
	end
	if (gtprxinit_ready_timer_wait) begin
		if ((~gtprxinit_ready_timer_done)) begin
			gtprxinit_ready_timer_count <= (gtprxinit_ready_timer_count - 1'd1);
		end
	end else begin
		gtprxinit_ready_timer_count <= 20'd960000;
	end
	if (gtprxinit_cdr_stable_timer_wait) begin
		if ((~gtprxinit_cdr_stable_timer_done)) begin
			gtprxinit_cdr_stable_timer_count <= (gtprxinit_cdr_stable_timer_count - 1'd1);
		end
	end else begin
		gtprxinit_cdr_stable_timer_count <= 11'd1024;
	end
	if (tx_rst) begin
		count <= 12'd0;
		gtprxinit_gtrxreset0 <= 1'd0;
		gtprxinit_gtrxpd0 <= 1'd0;
		gtprxinit_rxdlysreset0 <= 1'd0;
		gtprxinit_rxphalign0 <= 1'd0;
		gtprxinit_rxdlyen0 <= 1'd0;
		gtprxinit_rxuserrdy0 <= 1'd0;
		gtprxinit_rxpmaresetdone_r <= 1'd0;
		gtprxinit_pll_reset_timer_count <= 7'd120;
		gtprxinit_ready_timer_count <= 20'd960000;
		gtprxinit_cdr_stable_timer_count <= 11'd1024;
		gtprxinit_flag <= 1'd0;
		gtprxinit_rd_data <= 16'd0;
		gtprxinit_original_rd_data <= 16'd0;
		clockdomainsrenamer_state <= 4'd0;
	end
	xilinxmultiregimpl5_regs0 <= gtprxinit_rxpmaresetdone0;
	xilinxmultiregimpl5_regs1 <= xilinxmultiregimpl5_regs0;
	xilinxmultiregimpl6_regs0 <= gtprxinit_plllock0;
	xilinxmultiregimpl6_regs1 <= xilinxmultiregimpl6_regs0;
	xilinxmultiregimpl7_regs0 <= gtprxinit_rxresetdone0;
	xilinxmultiregimpl7_regs1 <= xilinxmultiregimpl7_regs0;
	xilinxmultiregimpl8_regs0 <= gtprxinit_rxdlysresetdone0;
	xilinxmultiregimpl8_regs1 <= xilinxmultiregimpl8_regs0;
	xilinxmultiregimpl9_regs0 <= gtprxinit_rxsyncdone0;
	xilinxmultiregimpl9_regs1 <= xilinxmultiregimpl9_regs0;
end

IBUFDS_GTE2 IBUFDS_GTE2(
	.CEB(1'd0),
	.I(gtp_refclk_p),
	.IB(gtp_refclk_n),
	.O(refclk100)
);

BUFG BUFG(
	.I(refclk100),
	.O(sys_clk_1)
);

PLLE2_BASE #(
	.CLKFBOUT_MULT(4'd10),
	.CLKIN1_PERIOD(10.0),
	.CLKOUT0_DIVIDE(3'd5),
	.CLKOUT0_PHASE(0.0),
	.DIVCLK_DIVIDE(1'd1),
	.REF_JITTER1(0.01),
	.STARTUP_WAIT("FALSE")
) PLLE2_BASE (
	.CLKFBIN(pll_fb),
	.CLKIN1(sys_clk_1),
	.CLKFBOUT(pll_fb),
	.CLKOUT0(refclk0)
);

GTPE2_COMMON #(
	.PLL0_FBDIV(2'd3),
	.PLL0_FBDIV_45(3'd4),
	.PLL0_REFCLK_DIV(1'd1)
) GTPE2_COMMON (
	.BGBYPASSB(1'd1),
	.BGMONITORENB(1'd1),
	.BGPDB(1'd1),
	.BGRCALOVRD(5'd31),
	.GTREFCLK0(refclk0),
	.PLL0LOCKEN(1'd1),
	.PLL0PD(1'd0),
	.PLL0REFCLKSEL(1'd1),
	.PLL0RESET(reset),
	.PLL1PD(1'd1),
	.RCALENB(1'd1),
	.PLL0LOCK(lock),
	.PLL0OUTCLK(clk),
	.PLL0OUTREFCLK(refclk1)
);

GTPE2_CHANNEL #(
	.ALIGN_COMMA_DOUBLE("TRUE"),
	.ALIGN_COMMA_ENABLE(10'd1023),
	.ALIGN_COMMA_WORD(1'd1),
	.ALIGN_MCOMMA_DET("TRUE"),
	.ALIGN_PCOMMA_DET("TRUE"),
	.ALIGN_PCOMMA_VALUE(10'd771),
	.CLK_CORRECT_USE("FALSE"),
	.PD_TRANS_TIME_FROM_P2(6'd60),
	.PD_TRANS_TIME_NONE_P2(6'd60),
	.PD_TRANS_TIME_TO_P2(7'd100),
	.PMA_RSV(10'd819),
	.PMA_RSV2(14'd8256),
	.PMA_RSV3(1'd0),
	.PMA_RSV4(1'd0),
	.RXBUF_EN("FALSE"),
	.RXCDR_CFG(65'd19022712657137635344),
	.RXDLY_CFG(5'd31),
	.RXDLY_LCFG(6'd48),
	.RXLPM_IPCM_CFG(1'd1),
	.RXOUT_DIV(1'd1),
	.RXPHDLY_CFG(20'd540704),
	.RXPH_CFG(24'd12582914),
	.RXPI_CFG1(1'd1),
	.RXPI_CFG2(1'd1),
	.RXPMARESET_TIME(2'd3),
	.RXSYNC_MULTILANE(1'd0),
	.RXSYNC_OVRD(1'd0),
	.RX_BIAS_CFG(12'd3891),
	.RX_CLK25_DIV(3'd5),
	.RX_CM_SEL(1'd1),
	.RX_CM_TRIM(4'd10),
	.RX_DATA_WIDTH(5'd20),
	.RX_OS_CFG(8'd128),
	.RX_XCLK_SEL("RXUSR"),
	.SIM_RESET_SPEEDUP("FALSE"),
	.TXBUF_EN("FALSE"),
	.TXOUT_DIV(1'd1),
	.TXSYNC_MULTILANE(1'd0),
	.TXSYNC_OVRD(1'd1),
	.TXSYNC_SKIP_DA(1'd0),
	.TX_CLK25_DIV(3'd5),
	.TX_DATA_WIDTH(5'd20),
	.TX_XCLK_SEL("TXUSR")
) GTPE2_CHANNEL (
	.DRPADDR(drpaddr),
	.DRPCLK(tx_clk),
	.DRPDI(drpdi),
	.DRPEN(drpen),
	.DRPWE(drpwe),
	.EYESCANRESET(1'd0),
	.GTPRXN(gtp_rx_n),
	.GTPRXP(gtp_rx_p),
	.GTRESETSEL(1'd0),
	.GTRXRESET(gtprxinit_gtrxreset0),
	.GTTXRESET(tx_init_gttxreset0),
	.LOOPBACK(loopback),
	.PLL0CLK(clk),
	.PLL0REFCLK(refclk1),
	.RESETOVRD(1'd0),
	.RX8B10BEN(1'd0),
	.RXBUFRESET(1'd0),
	.RXCDRFREQRESET(1'd0),
	.RXCDRRESET(1'd0),
	.RXCOMMADETEN(1'd1),
	.RXDDIEN(1'd1),
	.RXDLYBYPASS(1'd0),
	.RXDLYSRESET(gtprxinit_rxdlysreset0),
	.RXELECIDLEMODE(2'd3),
	.RXLPMRESET(1'd0),
	.RXOOBRESET(1'd0),
	.RXOSINTCFG(2'd2),
	.RXOSINTEN(1'd1),
	.RXOUTCLKSEL(2'd2),
	.RXPCSRESET(1'd0),
	.RXPD({gtprxinit_gtrxpd0, gtprxinit_gtrxpd0}),
	.RXPMARESET(1'd0),
	.RXPOLARITY(rx_polarity),
	.RXRATE(1'd0),
	.RXSYNCALLIN(rxphaligndone),
	.RXSYNCIN(1'd0),
	.RXSYNCMODE(1'd1),
	.RXSYSCLKSEL(1'd0),
	.RXUSERRDY(gtprxinit_rxuserrdy0),
	.RXUSRCLK(rx_clk),
	.RXUSRCLK2(rx_clk),
	.TX8B10BEN(1'd0),
	.TXBUFDIFFCTRL(3'd4),
	.TXCHARDISPMODE(1'd0),
	.TXCHARDISPVAL(1'd0),
	.TXDATA(txdata),
	.TXDIFFCTRL(diffctrl),
	.TXDLYBYPASS(1'd0),
	.TXDLYEN(tx_init_txdlyen0),
	.TXDLYSRESET(tx_init_txdlysreset0),
	.TXELECIDLE(1'd0),
	.TXINHIBIT(1'd0),
	.TXOUTCLKSEL(2'd3),
	.TXPCSRESET(1'd0),
	.TXPHALIGN(tx_init_txphalign0),
	.TXPHALIGNEN(1'd1),
	.TXPHDLYRESET(1'd0),
	.TXPHINIT(tx_init_txphinit0),
	.TXPMARESET(1'd0),
	.TXPOLARITY(tx_polarity),
	.TXPOSTCURSOR(txpostcursor),
	.TXPRECURSOR(txprecursor),
	.TXRATE(1'd0),
	.TXSYNCALLIN(1'd0),
	.TXSYNCIN(1'd0),
	.TXSYNCMODE(1'd0),
	.TXSYSCLKSEL(1'd0),
	.TXUSERRDY(tx_init_txuserrdy0),
	.TXUSRCLK(tx_clk),
	.TXUSRCLK2(tx_clk),
	.DRPDO(drpdo),
	.DRPRDY(drprdy),
	.GTPTXN(gtp_tx_n),
	.GTPTXP(gtp_tx_p),
	.RXBYTEISALIGNED(rx_aligned0),
	.RXCHARISK({rxdata[18], rxdata[8]}),
	.RXCOMMADET(coma_detected0),
	.RXDATA({rxdata[17:10], rxdata[7:0]}),
	.RXDISPERR({rxdata[19], rxdata[9]}),
	.RXDLYSRESETDONE(gtprxinit_rxdlysresetdone0),
	.RXOUTCLK(rxoutclk),
	.RXPHALIGNDONE(rxphaligndone),
	.RXPMARESETDONE(gtprxinit_rxpmaresetdone0),
	.RXRESETDONE(gtprxinit_rxresetdone0),
	.RXSYNCDONE(gtprxinit_rxsyncdone0),
	.TXDLYSRESETDONE(tx_init_txdlysresetdone0),
	.TXOUTCLK(txoutclk),
	.TXPHALIGNDONE(tx_init_txphaligndone0),
	.TXPHINITDONE(tx_init_txphinitdone0),
	.TXRESETDONE(tx_init_txresetdone0)
);

BUFG BUFG_1(
	.I(txoutclk),
	.O(tx_clk)
);

BUFG BUFG_2(
	.I(rxoutclk),
	.O(rx_clk)
);

endmodule
