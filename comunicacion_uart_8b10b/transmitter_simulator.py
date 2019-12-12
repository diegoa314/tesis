from migen import *
from transmitter_8b10b import *
bits=0b00111111
def transmitter_tb(dut):
	yield dut.d.eq(bits)
	yield
	yield
	yield dut.tx_transmitter_ready.eq(1)
	for i in range(200):
		yield

dut=Transmitter(freq=10000,baud_rate=1000)
run_simulation(dut,transmitter_tb(dut), vcd_name="transmitter_tb.vcd")
