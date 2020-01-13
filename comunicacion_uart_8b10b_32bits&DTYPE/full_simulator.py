from migen import *
from full import * 
bits=[0b00111111001111110011111100111111, 0b10010010100100101001001010010010, 0b00110011001100110011001100110011,0b11010010110100101101001011010010]

bits2=[0b01, 0b10, 0b11, 0b00]

def full_tb(dut):
	yield dut.fifo_we.eq(1)
	yield dut.input.eq(Array(bits)[0])
	yield dut.intype.eq(Array(bits2)[0])
	yield
	yield dut.input.eq(Array(bits)[1])
	yield dut.intype.eq(Array(bits2)[1])
	yield
	yield dut.input.eq(Array(bits)[2])
	yield dut.intype.eq(Array(bits2)[2])
	yield
	yield dut.input.eq(Array(bits)[3])
	yield dut.intype.eq(Array(bits2)[3]) 
	yield
	yield dut.re.eq(1)
	yield dut.receiver_en.eq(1)
	for i in range(400):
		yield

dut=full()
run_simulation(dut,full_tb(dut),vcd_name="full_tb.vcd")
import subprocess
subprocess.Popen(["gtkwave", "full_tb.vcd"])


	