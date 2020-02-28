vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vcom -work xil_defaultlib -64 -93 \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_GT_master/example_design/multifpga_gt_master_tx_startup_fsm.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_GT_master/example_design/multifpga_gt_master_rx_startup_fsm.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_gt_master_init.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_gt_master_gt.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_gt_master_multi_gt.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_GT_master/example_design/multifpga_gt_master_gtrxreset_seq.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_GT_master/example_design/multifpga_gt_master_rxpmarst_seq.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_GT_master/example_design/multifpga_gt_master_rxrate_seq.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_GT_master/example_design/multifpga_gt_master_sync_block.vhd" \
"../../../../multifpga_GT_master_ex.srcs/sources_1/ip/multifpga_GT_master/multifpga_gt_master.vhd" \


