from migen import *
from migen.fhdl import *
from extension import *



class CRC(Module):    ###Es necesario declarar length
	def __init__(self):
		self.data_32 = data_32 = Signal(32)
		self.crcData = crcData = Signal(20)
		self.comb+=crcData.eq(loop(data_32))	

def crc_tb(dut):
	yield dut.data_32.eq(0b11010111011111011001010101110101)
	yield
	yield dut.data_32.eq(0b00000000111001111100000001111000)
	yield
	yield dut.data_32.eq(0b10101010101010101010101010101010)
	yield
	yield dut.data_32.eq(0b11111111111111111111000000000000)
	yield
	yield dut.data_32.eq(0b11000000000000000000011111111111)
	yield

dut=CRC()
run_simulation(dut,crc_tb(dut),vcd_name="crc.vcd")
import subprocess
subprocess.Popen(["gtkwave", "crc.vcd"])		

