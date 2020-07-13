from migen import *
from migen.fhdl import verilog

class Alignment_Corrector(Module):
	def __init__(self):
		self.din=din=Signal(32)
		self.aligned=aligned=Signal()
		self.dout=dout=Signal(32)
		self.correction_done=Signal()
		#	#	#
		first_half=Signal(16)
		first_half1=Signal(16)
		second_half=Signal(16)
		self.submodules.fsm=FSM(reset_state="IDLE")
		self.fsm.act("IDLE",
			If(aligned, 
				NextState("INIT"),
			)
		)
		self.fsm.act("INIT",
			NextState("DONE"),
			NextValue(first_half,din[16:]),
			NextValue(self.correction_done,1)
		)
		self.fsm.act("DONE",
			dout.eq(Cat(first_half,din[:16])),
			NextValue(first_half,din[16:]),
			NextState("DONE")

		)
	
#example = Alignment_Corrector()
#verilog.convert(example, {example.din, example.dout, example.aligned, example.correction_done}).write("alignment_corrector.v")



	
"""
def tb(dut):
	yield	
	for i in range(10):
		yield dut.din.eq(0x62cfa9d274) 
		yield dut.aligned.eq(1)
		yield
		yield dut.din.eq(0x9d30562d8b)
		yield

dut=Alignment_Corrector()
run_simulation(dut,tb(dut),vcd_name="alignment_tb.vcd")
"""

