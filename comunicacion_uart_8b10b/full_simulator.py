from migen import *
from full import * 
bits=[0b00111111, 0b10010010, 0b00110011,0b11010010]
def full_tb(dut):
	yield dut.fifo_we.eq(1)
	yield dut.input.eq(Array(bits)[0])
	yield
	yield dut.input.eq(Array(bits)[1])
	yield
	yield dut.input.eq(Array(bits)[2])
	yield
	yield dut.input.eq(Array(bits)[3]) 
	yield
	yield dut.re.eq(1)
	yield dut.receiver_en.eq(1)
	for i in range(400):
		yield

dut=full()
run_simulation(dut,full_tb(dut),vcd_name="full_tb.vcd")


	