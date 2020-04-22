module asyncFIFO(
	input we,
	output writable,
	input re,
	output readable,
	input [31:0] din,
	output [31:0] dout,
	input read_clk,
	input read_rst,
	input write_clk,
	input write_rst
);

wire graycounter0_ce;
(* no_retiming = "true" *) reg [5:0] graycounter0_q = 6'd0;
wire [5:0] graycounter0_q_next;
reg [5:0] graycounter0_q_binary = 6'd0;
reg [5:0] graycounter0_q_next_binary;
wire graycounter1_ce;
(* no_retiming = "true" *) reg [5:0] graycounter1_q = 6'd0;
wire [5:0] graycounter1_q_next;
reg [5:0] graycounter1_q_binary = 6'd0;
reg [5:0] graycounter1_q_next_binary;
wire [5:0] produce_rdomain;
wire [5:0] consume_wdomain;
wire [4:0] wrport_adr;
wire [31:0] wrport_dat_r;
wire wrport_we;
wire [31:0] wrport_dat_w;
wire [4:0] rdport_adr;
wire [31:0] rdport_dat_r;
(* no_retiming = "true" *) reg [5:0] multiregimpl0_regs0 = 6'd0;
(* no_retiming = "true" *) reg [5:0] multiregimpl0_regs1 = 6'd0;
(* no_retiming = "true" *) reg [5:0] multiregimpl1_regs0 = 6'd0;
(* no_retiming = "true" *) reg [5:0] multiregimpl1_regs1 = 6'd0;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign graycounter0_ce = (writable & we);
assign graycounter1_ce = (readable & re);
assign writable = (((graycounter0_q[5] == consume_wdomain[5]) | (graycounter0_q[4] == consume_wdomain[4])) | (graycounter0_q[3:0] != consume_wdomain[3:0]));
assign readable = (graycounter1_q != produce_rdomain);
assign wrport_adr = graycounter0_q_binary[4:0];
assign wrport_dat_w = din;
assign wrport_we = graycounter0_ce;
assign rdport_adr = graycounter1_q_next_binary[4:0];
assign dout = rdport_dat_r;

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	graycounter0_q_next_binary <= 6'd0;
	if (graycounter0_ce) begin
		graycounter0_q_next_binary <= (graycounter0_q_binary + 1'd1);
	end else begin
		graycounter0_q_next_binary <= graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end
assign graycounter0_q_next = (graycounter0_q_next_binary ^ graycounter0_q_next_binary[5:1]);

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	graycounter1_q_next_binary <= 6'd0;
	if (graycounter1_ce) begin
		graycounter1_q_next_binary <= (graycounter1_q_binary + 1'd1);
	end else begin
		graycounter1_q_next_binary <= graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end
assign graycounter1_q_next = (graycounter1_q_next_binary ^ graycounter1_q_next_binary[5:1]);
assign produce_rdomain = multiregimpl0_regs1;
assign consume_wdomain = multiregimpl1_regs1;

always @(posedge read_clk) begin
	graycounter1_q_binary <= graycounter1_q_next_binary;
	graycounter1_q <= graycounter1_q_next;
	if (read_rst) begin
		graycounter1_q <= 6'd0;
		graycounter1_q_binary <= 6'd0;
	end
	multiregimpl0_regs0 <= graycounter0_q;
	multiregimpl0_regs1 <= multiregimpl0_regs0;
end

always @(posedge write_clk) begin
	graycounter0_q_binary <= graycounter0_q_next_binary;
	graycounter0_q <= graycounter0_q_next;
	if (write_rst) begin
		graycounter0_q <= 6'd0;
		graycounter0_q_binary <= 6'd0;
	end
	multiregimpl1_regs0 <= graycounter1_q;
	multiregimpl1_regs1 <= multiregimpl1_regs0;
end

reg [31:0] storage[0:31];
reg [4:0] memadr;
reg [4:0] memadr_1;
always @(posedge write_clk) begin
	if (wrport_we)
		storage[wrport_adr] <= wrport_dat_w;
	memadr <= wrport_adr;
end

always @(posedge read_clk) begin
	memadr_1 <= rdport_adr;
end

assign wrport_dat_r = storage[memadr];
assign rdport_dat_r = storage[memadr_1];

endmodule
