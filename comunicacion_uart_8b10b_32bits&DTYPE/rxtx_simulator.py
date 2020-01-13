from migen import *
from rxtx_8b10b import *
bits=0b00111111
def rxtx_tb(dut):
	yield dut.rxtx_input.eq(bits)
	yield dut.rxtx_fifo_we.eq(1)
	yield
	yield dut.rxtx_transmitter_ready.eq(1)
	yield
	yield dut.rxtx_receiver_read_enable.eq(1)
	for i in range(400):
		yield

dut=rxtx(10000,1000)
run_simulation(dut,rxtx_tb(dut),vcd_name="rxtx_tb.vcd")