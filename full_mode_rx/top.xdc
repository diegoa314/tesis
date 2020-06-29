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
 ## we:0
set_property LOC X [get_ports we]
 ## link_ready:0
set_property LOC X [get_ports link_ready]
 ## trans_en:0
set_property LOC X [get_ports trans_en]
 ## rxinit_done:0
set_property LOC X [get_ports rxinit_done]

set_property INTERNAL_VREF 0.750 [get_iobanks 34]

set_false_path -quiet -to [get_nets -quiet -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -quiet -filter {REF_PIN_NAME == PRE} -of [get_cells -quiet -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -quiet -filter {REF_PIN_NAME == Q} -of [get_cells -quiet -filter {ars_ff1 == TRUE}]] -to [get_pins -quiet -filter {REF_PIN_NAME == D} -of [get_cells -quiet -filter {ars_ff2 == TRUE}]]