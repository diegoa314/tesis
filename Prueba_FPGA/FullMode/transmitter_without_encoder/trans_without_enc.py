#Envia una palabra de 10b en 2 bytes (FUNCA)
from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Tesis/Prueba_FPGA/UART')
from transmitter10b import *
sys.path.append('/home/diegoaranda/Documents/Tesis/Prueba_FPGA')
import cmoda7
from migen.build.generic_platform import *
class Transmitter(Module):
	def __init__(self,platform=0):	
		self.data_in=Signal(10)
		self.trans_ready=Signal()
		self.tx_serial=Signal()
		#self.trans_ready=platform.request("user_btn")
		#self.tx_serial=platform.request("serial").tx
		#  #  #
		transmitter10b=Transmitter10b()
		self.submodules+=transmitter10b
		self.comb+=[
			self.data_in.eq(0b1100110111), 
			transmitter10b.data_in.eq(self.data_in),
			transmitter10b.trans_ready.eq(self.trans_ready),
			self.tx_serial.eq(transmitter10b.tx_serial)
		]
""""
plat=cmoda7.Platform()
dut=Transmitter(plat)
plat.build(dut)
"""
def tb(dut):
	for i in range(100):
		yield
	yield dut.trans_ready.eq(1)
	for i in range(100000):
		yield

dut=Transmitter()
run_simulation(dut,tb(dut),vcd_name="trans_without_enc.vcd")
