from migen import *
from migen.fhdl import verilog

class fsm1(Module):
	def __init__(self):
		self.re=re=Signal() 
		self.fifo_re=fifo_re=Signal()
		self.fifo_empty=fifo_empty=Signal()
		self.data_type= data_type=Signal(2)
		self.select=select=Signal() 
		self.dataPackage=dataPackage=Signal(32)
		#	#	#
		self.submodules.fsm=FSM(reset_state="INIT")
		self.fsm.act("INIT",
			NextState("IDLE"),
			NextValue(dataPackage[0:8],0b10111100),
			NextValue(select,0), 	
		)
		self.fsm.act("IDLE",
			If(re,
				If(~fifo_empty,NextValue(fifo_re,1)),					
				If(data_type == 0b01,
					NextState("SOP"), 
					NextValue(dataPackage[0:8],0b00111100), 	
					
				).Elif(fifo_empty,
					NextState("FIFO_EMPTY")
				)
			)
		)
		self.fsm.act("SOP",
			NextState("READ_START"),
			NextValue(select,1) 	
		)

		self.fsm.act("READ_START",
			If(data_type == 0b10,
				NextState("EOP"),
				NextValue(fifo_re,0), 
				NextValue(dataPackage[0:8],(0b11011100)),
				NextValue(select,0), 	
			)
		)
		self.fsm.act("EOP",
			NextState("IDLE"),
			NextValue(dataPackage[0:8],0b10111100) 
			
		)
		self.fsm.act("FIFO_EMPTY",
			If(~fifo_empty,
				NextState("IDLE"),
				NextValue(dataPackage[0:8],0b10111100) 
			)
		)

"""def fsm_tb(dut):
	yield dut.re.eq(0)
	yield
	yield dut.data_type.eq(0b01)
	yield
	yield dut.fifo_empty.eq(0)
	yield
	yield dut.re.eq(1)
	yield
	yield dut.data_type.eq(0b01)
	yield
	yield dut.fifo_empty.eq(0)
	yield
	yield dut.re.eq(1)
	yield
	yield dut.data_type.eq(0b10)
	yield
	yield dut.fifo_empty.eq(1)
	yield
	yield dut.re.eq(1)
	yield
	yield dut.data_type.eq(0b01)
	yield
	yield dut.fifo_empty.eq(0)
	yield
	yield dut.re.eq(0)
	yield dut.data_type.eq(0b10)
	yield dut.re.eq(1)
	yield dut.data_type.eq(0b01)
	yield
	yield dut.re.eq(1)
	yield dut.data_type.eq(0b10)
	yield dut.re.eq(1)
	yield dut.data_type.eq(0b01)
	yield

dut=fsm1()
run_simulation(dut,fsm_tb(dut),vcd_name="fsm_tb.vcd")
import subprocess
subprocess.Popen(["gtkwave", "fsm_tb.vcd"])"""
