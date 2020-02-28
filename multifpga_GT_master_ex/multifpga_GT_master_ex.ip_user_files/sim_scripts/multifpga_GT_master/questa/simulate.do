onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib multifpga_GT_master_opt

do {wave.do}

view wave
view structure
view signals

do {multifpga_GT_master.udo}

run -all

quit -force
