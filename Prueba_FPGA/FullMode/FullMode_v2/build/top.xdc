 ## serial:0.tx
set_property LOC J18 [get_ports serial_tx]
set_property IOSTANDARD LVCMOS33 [get_ports serial_tx]
 ## serial:0.rx
set_property LOC J17 [get_ports serial_rx]
set_property IOSTANDARD LVCMOS33 [get_ports serial_rx]
 ## user_btn:0
set_property LOC A18 [get_ports user_btn]
set_property IOSTANDARD LVCMOS33 [get_ports user_btn]
 ## clk12:0
set_property LOC L17 [get_ports clk12]
set_property IOSTANDARD LVCMOS33 [get_ports clk12]

set_property INTERNAL_VREF 0.750 [get_iobanks 34]

create_clock -name clk12 -period 83.333 [get_nets clk12]

set_false_path -quiet -to [get_nets -quiet -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -quiet -filter {REF_PIN_NAME == PRE} -of [get_cells -quiet -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -quiet -filter {REF_PIN_NAME == Q} -of [get_cells -quiet -filter {ars_ff1 == TRUE}]] -to [get_pins -quiet -filter {REF_PIN_NAME == D} -of [get_cells -quiet -filter {ars_ff2 == TRUE}]]