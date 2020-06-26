from migen import *
from migen.fhdl import verilog

class Alignment_Corrector(Module):
	def __init__(self):
		self.din=din=Signal(40)
		self.aligned=aligned=Signal()
		self.dout=dout=Signal(40)
		self.correction_done=Signal(1)
		#	#	#
		first_half=Signal(20)
		first_half1=Signal(20)
		second_half=Signal(20)
		self.submodules.fsm=FSM(reset_state="INIT")
		self.fsm.act("INIT",
			If(aligned, 
				NextState("FIRST_HALF"),
				
			)
		)
		self.fsm.act("FIRST_HALF",
			NextState("SECOND_HALF"),
			
			NextValue(first_half,din[20:]),
			NextValue(self.correction_done,1)
			

		)
		self.fsm.act("SECOND_HALF",
			NextValue(dout,Cat(first_half,din[:20])),
			NextValue(first_half,din[20:]),
			NextState("SECOND_HALF")

		)
	
example = Alignment_Corrector()
verilog.convert(example, {example.din, example.dout, example.aligned, example.correction_done}).write("alignment_corrector.v")



	
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

