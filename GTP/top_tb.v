
`timescale 1ns/1ps

module top_tb();

reg gtp_refclk;
initial gtp_refclk = 1'b1;
always #5 gtp_refclk = ~gtp_refclk;

wire gtp_p;
wire gtp_n;

top dut (
    .gtp_refclk_p(gtp_refclk),
    .gtp_refclk_n(~gtp_refclk),
    .gtp_tx_p(gtp_p),
    .gtp_tx_n(gtp_n),
    .gtp_rx_p(gtp_p),
    .gtp_rx_n(gtp_n)
);

endmodule