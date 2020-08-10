set_max_delay -datapath_only -from [get_cells gtp_tx_init_done1_reg] -to [get_cells xilinxmultiregimpl11_regs0_reg] 10.000
## reset:0
set_property PACKAGE_PIN C3 [get_ports reset]
set_property IOSTANDARD LVCMOS15 [get_ports reset]
## write_clk:0.p
set_property IOSTANDARD DIFF_SSTL18_II [get_ports write_clk_p]
## write_clk:0.n
set_property PACKAGE_PIN G5 [get_ports write_clk_p]
set_property PACKAGE_PIN F5 [get_ports write_clk_n]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports write_clk_n]
## gtp_clk:0.p
## gtp_clk:0.n
set_property PACKAGE_PIN AA13 [get_ports gtp_clk_p]
set_property PACKAGE_PIN AB13 [get_ports gtp_clk_n]
## clk62_5:0
set_property PACKAGE_PIN AA4 [get_ports clk62_5]
set_property IOSTANDARD LVCMOS15 [get_ports clk62_5]
## gtp_tx:0.p
## gtp_tx:0.n
## gtp_rx:0.p
## gtp_rx:0.n
set_property PACKAGE_PIN AD12 [get_ports gtp_rx_n]
set_property PACKAGE_PIN AC12 [get_ports gtp_rx_p]
set_property PACKAGE_PIN AD10 [get_ports gtp_tx_n]
set_property PACKAGE_PIN AC10 [get_ports gtp_tx_p]
## we:0
set_property PACKAGE_PIN A2 [get_ports we]
set_property IOSTANDARD LVCMOS15 [get_ports we]
## link_ready:0
set_property PACKAGE_PIN D3 [get_ports link_ready]
set_property IOSTANDARD LVCMOS15 [get_ports link_ready]
## trans_en:0
set_property PACKAGE_PIN F3 [get_ports trans_en]
set_property IOSTANDARD LVCMOS15 [get_ports trans_en]
## rxinit_done:0
set_property PACKAGE_PIN A3 [get_ports rxinit_done]
set_property IOSTANDARD LVCMOS15 [get_ports rxinit_done]

set_property INTERNAL_VREF 0.75 [get_iobanks 34]

create_clock -period 2.500 -name write_clk_p [get_nets write_clk_p]

create_clock -period 4.166 -name gtp_clk_p [get_nets gtp_clk_p]

create_clock -period 10.000 -name sys_clk [get_nets clk62_5]

create_clock -period 8.333 -name tx_clk [get_nets tx_clk]

create_clock -period 8.333 -name rx_clk [get_nets rx_clk]




set_max_delay -datapath_only -from graycounter0_q_reg[3] -to xilinxmultiregimpl13_regs0_reg[3] 2.500
set_max_delay -datapath_only -from graycounter0_q_reg[0] -to xilinxmultiregimpl13_regs0_reg[0] 2.500
set_max_delay -datapath_only -from graycounter0_q_reg[1] -to xilinxmultiregimpl13_regs0_reg[1] 2.500
set_max_delay -datapath_only -from graycounter0_q_reg[2] -to xilinxmultiregimpl13_regs0_reg[2] 2.500
set_max_delay -datapath_only -from graycounter0_q_reg[4] -to xilinxmultiregimpl13_regs0_reg[4] 2.500
set_max_delay -datapath_only -from graycounter0_q_reg[5] -to xilinxmultiregimpl13_regs0_reg[5] 2.500
set_max_delay -datapath_only -from graycounter1_q_reg[5] -to xilinxmultiregimpl14_regs0_reg[5] 8.333
set_max_delay -datapath_only -from graycounter1_q_reg[4] -to xilinxmultiregimpl14_regs0_reg[4] 8.333
set_max_delay -datapath_only -from graycounter1_q_reg[3] -to xilinxmultiregimpl14_regs0_reg[3] 8.333
set_max_delay -datapath_only -from graycounter1_q_reg[2] -to xilinxmultiregimpl14_regs0_reg[2] 8.333
set_max_delay -datapath_only -from graycounter1_q_reg[1] -to xilinxmultiregimpl14_regs0_reg[1] 8.333
set_max_delay -datapath_only -from gtp_tx_init_done1_reg -to xilinxmultiregimpl11_regs0_reg 10.000


set_max_delay -from gtp_tx_init_done1_reg -to xilinxmultiregimpl10_regs0_reg 10.000

set_max_delay -from graycounter1_q_reg[0] -to xilinxmultiregimpl14_regs0_reg[0] 8.333
