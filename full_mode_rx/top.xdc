 ## reset:0
set_property LOC C3 [get_ports reset]
set_property IOSTANDARD LVCMOS15 [get_ports reset]
 ## write_clk:0.p
set_property LOC G5 [get_ports write_clk_p]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports write_clk_p]
 ## write_clk:0.n
set_property LOC F5 [get_ports write_clk_n]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports write_clk_n]
 ## gtp_clk:0.p
set_property LOC AA13 [get_ports gtp_clk_p]
 ## gtp_clk:0.n
set_property LOC AB13 [get_ports gtp_clk_n]
 ## clk62_5:0
set_property LOC AA4 [get_ports clk62_5]
set_property IOSTANDARD LVCMOS15 [get_ports clk62_5]
 ## gtp_tx:0.p
set_property LOC AC10 [get_ports gtp_tx_p]
 ## gtp_tx:0.n
set_property LOC AD10 [get_ports gtp_tx_n]
 ## gtp_rx:0.p
set_property LOC AC12 [get_ports gtp_rx_p]
 ## gtp_rx:0.n
set_property LOC AD12 [get_ports gtp_rx_n]
 ## we:0
set_property LOC A2 [get_ports we]
set_property IOSTANDARD LVCMOS15 [get_ports we]
 ## link_ready:0
set_property LOC D3 [get_ports link_ready]
set_property IOSTANDARD LVCMOS15 [get_ports link_ready]
 ## trans_en:0
set_property LOC F3 [get_ports trans_en]
set_property IOSTANDARD LVCMOS15 [get_ports trans_en]
 ## rxinit_done:0
set_property LOC A3 [get_ports rxinit_done]
set_property IOSTANDARD LVCMOS15 [get_ports rxinit_done]

set_property INTERNAL_VREF 0.750 [get_iobanks 34]

create_clock -name write_clk_p -period 2.5 [get_nets write_clk_p]

create_clock -name gtp_clk_p -period 4.166 [get_nets gtp_clk_p]

create_clock -name clk62_5 -period 10.0 [get_nets clk62_5]

create_clock -name tx_clk -period 8.333 [get_nets tx_clk]

create_clock -name rx_clk -period 8.333 [get_nets rx_clk]

set_false_path -quiet -to [get_nets -quiet -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -quiet -filter {REF_PIN_NAME == PRE} -of [get_cells -quiet -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -quiet -filter {REF_PIN_NAME == Q} -of [get_cells -quiet -filter {ars_ff1 == TRUE}]] -to [get_pins -quiet -filter {REF_PIN_NAME == D} -of [get_cells -quiet -filter {ars_ff2 == TRUE}]]