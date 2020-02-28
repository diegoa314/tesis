onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.multifpga_GT_master

do {wave.do}

view wave
view structure
view signals

do {multifpga_GT_master.udo}

run -all

quit -force
