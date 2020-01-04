 ## user_led:0
set_property LOC T14 [get_ports user_led]
set_property IOSTANDARD LVCMOS25 [get_ports user_led]
 ## user_led:1
set_property LOC T15 [get_ports user_led_1]
set_property IOSTANDARD LVCMOS25 [get_ports user_led_1]
 ## user_led:2
set_property LOC T16 [get_ports user_led_2]
set_property IOSTANDARD LVCMOS25 [get_ports user_led_2]
 ## user_led:3
set_property LOC U16 [get_ports user_led_3]
set_property IOSTANDARD LVCMOS25 [get_ports user_led_3]
 ## user_led:4
set_property LOC V15 [get_ports user_led_4]
set_property IOSTANDARD LVCMOS25 [get_ports user_led_4]
 ## user_led:5
set_property LOC W16 [get_ports user_led_5]
set_property IOSTANDARD LVCMOS25 [get_ports user_led_5]
 ## user_led:6
set_property LOC W15 [get_ports user_led_6]
set_property IOSTANDARD LVCMOS25 [get_ports user_led_6]
 ## user_led:7
set_property LOC Y13 [get_ports user_led_7]
set_property IOSTANDARD LVCMOS25 [get_ports user_led_7]
 ## clk100:0
set_property LOC R4 [get_ports clk100]
set_property IOSTANDARD LVCMOS33 [get_ports clk100]

set_property INTERNAL_VREF 0.750 [get_iobanks 35]

create_clock -name clk100 -period 10.0 [get_nets clk100]

set_false_path -quiet -to [get_nets -quiet -filter {mr_ff == TRUE}]

set_false_path -quiet -to [get_pins -quiet -filter {REF_PIN_NAME == PRE} -of [get_cells -quiet -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]

set_max_delay 2 -quiet -from [get_pins -quiet -filter {REF_PIN_NAME == Q} -of [get_cells -quiet -filter {ars_ff1 == TRUE}]] -to [get_pins -quiet -filter {REF_PIN_NAME == D} -of [get_cells -quiet -filter {ars_ff2 == TRUE}]]