from migen import *
from transmitter_8b10b import *
bits=[0b00111111, 0b10010010, 0b00110011]
def transmitter_tb(dut):
	yield dut.transmitter_fifo_re.eq(0)
	yield dut.transmitter_input.eq(Array(bits)[0])
	yield dut.transmitter_fifo_we.eq(1)
	yield
	yield dut.transmitter_input.eq(Array(bits)[1])
	yield
	yield dut.transmitter_input.eq(Array(bits)[2])
	yield 
	yield
	yield dut.transmitter_fifo_re.eq(1)
	yield
	yield dut.transmitter_fifo_re.eq(0)
	yield
	yield
	yield 
	yield dut.transmitter_tx_ready.eq(1)
	yield 
	for i in range(121):
		yield
	yield dut.transmitter_fifo_re.eq(1)	
	yield
	yield dut.transmitter_fifo_re.eq(0)
	yield
	yield
	yield dut.transmitter_tx_ready.eq(1)
	for i in range(122):
		yield
	
		
dut=Transmitter(freq=10000,baud_rate=1000)
run_simulation(dut,transmitter_tb(dut), vcd_name="transmitter_tb.vcd")
