from migen import *
from rs_encoder import *
def tb(dut):
	yield dut.reset.eq(1)
	yield
	yield dut.reset.eq(0)
	for i in range(11):
		yield dut.data_in.eq(i+2)
		yield
	yield
	yield
	yield
	yield


dut=Encoder()
run_simulation(dut,tb(dut),vcd_name="rs_encoder_tb.vcd")
