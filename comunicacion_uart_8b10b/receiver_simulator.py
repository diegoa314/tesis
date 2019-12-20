from migen import *
from receiver_8b10b import *
#0b1010111001
bits=[1,1,0,1,0,1,0,1,1,1,0,0,1,1]
def receiver_tb(dut):
	yield dut.receiver_serial.eq(1)
	yield
	yield
	yield dut.receiver_read_enable.eq(1)
	for i in range (len(bits)*10):
		yield dut.receiver_serial.eq(bits[i//10])
		yield
	for i in range(20):
		yield
		
dut=Receiver(freq=10000, baud_rate=1000)
run_simulation(dut,receiver_tb(dut), vcd_name="receiver_tb.vcd")
