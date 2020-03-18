from migen import *
from migen.fhdl import verilog
from dataselect import *
from fsm import * 

class Empaquetador(Module):
	def __init__(self):
		self.signal_in=signal_in=Signal(32)
		self.signal_out=signal_out=Signal(32)
		self.re=re=Signal()
		self.fifoE=fifoE=Signal()
		self.fifo_re=fifo_re=Signal()
		self.datatype=datatype=Signal(2)
		self.busy=busy=Signal(4)

		signalConector=Signal(32)
		selectConector=Signal()

		fsm2=fsm1()
		selector=DataSelect()
		self.submodules+=[fsm2,selector]
		self.comb+=[
			fsm2.re.eq(re),
			fsm2.data_type.eq(datatype),
			fsm2.fifo_empty.eq(fifoE),
			fifo_re.eq(fsm2.fifo_re),
			signalConector.eq(fsm2.dataPackage),
			selectConector.eq(fsm2.select),
			selector.data_in.eq(signal_in),
			selector.datapackage.eq(signalConector),
			selector.busy.eq(busy),
			selector.select.eq(selectConector),
			signal_out.eq(selector.data_out)
		]

def empaquetador_tb(dut):
	yield dut.re.eq(0)
	yield
	yield dut.signal_in.eq(0b11001100110011001100110011001100)
	yield
	yield dut.datatype.eq(0b01)
	yield
	yield dut.fifoE.eq(0)
	yield
	yield dut.busy.eq(0b1010)
	yield
	yield dut.re.eq(1)
	yield
	yield dut.signal_in.eq(0b11001100110011001100110011001100)
	yield
	yield dut.datatype.eq(0b01)
	yield
	yield dut.fifoE.eq(0)
	yield
	yield dut.busy.eq(0b1010)
	yield
	yield dut.signal_in.eq(0b11010010110011100101101001010011)
	yield
	yield dut.datatype.eq(0b00)
	yield
	yield dut.fifoE.eq(0)
	yield
	yield dut.busy.eq(0b1010)
	yield
	yield dut.signal_in.eq(0b11111111111111110000000000000000)
	yield
	yield dut.datatype.eq(0b00)
	yield
	yield dut.fifoE.eq(0)
	yield
	yield dut.busy.eq(0b1010)
	yield
	yield
	yield dut.signal_in.eq(0b11111111111111110000000000000000)
	yield
	yield dut.datatype.eq(0b10)
	yield
	yield dut.fifoE.eq(0)
	yield
	yield dut.busy.eq(0b1010)
	yield

dut=Empaquetador()
run_simulation(dut,empaquetador_tb(dut),vcd_name="empa.vcd")
import subprocess
subprocess.Popen(["gtkwave", "empa.vcd"])