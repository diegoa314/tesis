 ## clk0:0.clk_p
set_property LOC G5 [get_ports clk0_clk_p]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports clk0_clk_p]
 ## clk0:0.clk_n
set_property LOC F5 [get_ports clk0_clk_n]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports clk0_clk_n]
 ## clk62_5:0
set_property LOC AA4 [get_ports clk62_5]
set_property IOSTANDARD LVCMOS15 [get_ports clk62_5]
 ## gtp_refclk:0.p
set_property LOC AA11 [get_ports gtp_refclk_p]
 ## gtp_refclk:0.n
set_property LOC AB11 [get_ports gtp_refclk_n]
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
 ## din:0.a
set_property LOC X [get_ports din_a]
 ## din:0.b
set_property LOC X [get_ports din_b]
 ## din:0.c
set_property LOC X [get_ports din_c]
 ## din:0.d
set_property LOC X [get_ports din_d]
 ## din:0.e
set_property LOC X [get_ports din_e]
 ## din:0.f
set_property LOC X [get_ports din_f]
 ## din:0.g
set_property LOC X [get_ports din_g]
 ## din:0.h
set_property LOC X [get_ports din_h]
 ## dtin:0.a
set_property LOC X [get_ports dtin_a]
 ## dtin:0.b
set_property LOC X [get_ports dtin_b]
 ## we:0
set_property LOC X [get_ports we]
 ## link_ready:0
set_property LOC X [get_ports link_ready]

set_property INTERNAL_VREF 0.750 [get_iobanks 34]

set_false_path -quiet -to [get_nets -quiet -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -quiet -filter {REF_PIN_NAME == PRE} -of [get_cells -quiet -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -quiet -filter {REF_PIN_NAME == Q} -of [get_cells -quiet -filter {ars_ff1 == TRUE}]] -to [get_pins -quiet -filter {REF_PIN_NAME == D} -of [get_cells -quiet -filter {ars_ff2 == TRUE}]]