 ## write_clk:0.p
set_property LOC G5 [get_ports write_clk_p]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports write_clk_p]
 ## write_clk:0.n
set_property LOC F5 [get_ports write_clk_n]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports write_clk_n]
 ## gtp_clk:0.p
set_property LOC AA11 [get_ports gtp_clk_p]
 ## gtp_clk:0.n
set_property LOC AB11 [get_ports gtp_clk_n]
 ## gtp_tx:0.p
set_property LOC AE7 [get_ports gtp_tx_p]
set_property IOSTANDARD LVCMOS25 [get_ports gtp_tx_p]
 ## gtp_tx:0.n
set_property LOC AF7 [get_ports gtp_tx_n]
set_property IOSTANDARD LVCMOS25 [get_ports gtp_tx_n]
 ## gtp_rx:0.p
set_property LOC AE11 [get_ports gtp_rx_p]
set_property IOSTANDARD LVCMOS25 [get_ports gtp_rx_p]
 ## gtp_rx:0.n
set_property LOC AF11 [get_ports gtp_rx_n]
set_property IOSTANDARD LVCMOS25 [get_ports gtp_rx_n]
 ## din:0.a1
set_property LOC X [get_ports din_a1]
 ## din:0.b1
set_property LOC X [get_ports din_b1]
 ## din:0.c1
set_property LOC X [get_ports din_c1]
 ## din:0.d1
set_property LOC X [get_ports din_d1]
 ## din:0.e1
set_property LOC X [get_ports din_e1]
 ## din:0.f1
set_property LOC X [get_ports din_f1]
 ## din:0.g1
set_property LOC X [get_ports din_g1]
 ## din:0.h1
set_property LOC X [get_ports din_h1]
 ## din:0.a2
set_property LOC X [get_ports din_a2]
 ## din:0.b2
set_property LOC X [get_ports din_b2]
 ## din:0.c2
set_property LOC X [get_ports din_c2]
 ## din:0.d2
set_property LOC X [get_ports din_d2]
 ## din:0.e2
set_property LOC X [get_ports din_e2]
 ## din:0.f2
set_property LOC X [get_ports din_f2]
 ## din:0.g2
set_property LOC X [get_ports din_g2]
 ## din:0.h2
set_property LOC X [get_ports din_h2]
 ## din:0.a3
set_property LOC X [get_ports din_a3]
 ## din:0.b3
set_property LOC X [get_ports din_b3]
 ## din:0.c3
set_property LOC X [get_ports din_c3]
 ## din:0.d3
set_property LOC X [get_ports din_d3]
 ## din:0.e3
set_property LOC X [get_ports din_e3]
 ## din:0.f3
set_property LOC X [get_ports din_f3]
 ## din:0.g3
set_property LOC X [get_ports din_g3]
 ## din:0.h3
set_property LOC X [get_ports din_h3]
 ## din:0.a4
set_property LOC X [get_ports din_a4]
 ## din:0.b4
set_property LOC X [get_ports din_b4]
 ## din:0.c4
set_property LOC X [get_ports din_c4]
 ## din:0.d4
set_property LOC X [get_ports din_d4]
 ## din:0.e4
set_property LOC X [get_ports din_e4]
 ## din:0.f4
set_property LOC X [get_ports din_f4]
 ## din:0.g4
set_property LOC X [get_ports din_g4]
 ## din:0.h4
set_property LOC X [get_ports din_h4]
 ## dtin:0.a
set_property LOC X [get_ports dtin_a]
 ## dtin:0.b
set_property LOC X [get_ports dtin_b]
 ## we:0
set_property LOC X [get_ports we]
 ## link_ready:0
set_property LOC X [get_ports link_ready]
 ## rxinit_done:0
set_property LOC X [get_ports rxinit_done]

set_property INTERNAL_VREF 0.750 [get_iobanks 34]

set_false_path -quiet -to [get_nets -quiet -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -quiet -filter {REF_PIN_NAME == PRE} -of [get_cells -quiet -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -quiet -filter {REF_PIN_NAME == Q} -of [get_cells -quiet -filter {ars_ff1 == TRUE}]] -to [get_pins -quiet -filter {REF_PIN_NAME == D} -of [get_cells -quiet -filter {ars_ff2 == TRUE}]]