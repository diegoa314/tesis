onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+multifpga_GT_master -L xil_defaultlib -L secureip -O5 xil_defaultlib.multifpga_GT_master

do {wave.do}

view wave
view structure

do {multifpga_GT_master.udo}

run -all

endsim

quit -force
