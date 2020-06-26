from migen import *
import sys
from migen.fhdl.specials import Memory, READ_FIRST
sys.path.append('/home/diegoaranda/Documents/Tesis/tesis/Prueba_FPGA')
import cmoda7
sys.path.append('/home/diegoaranda/Documents/Tesis/tesis/full_mode/TX')
from tx import TX
from memoria import *
from receiver_top import Receiver_top
class top(Module):
	def __init__(self, platform=0):
		
		#self.fifo_readable_btn=platform.request("user_btn") 
		#self.trans_en=platform.request("user_btn") 
		#self.tx_serial=platform.request("serial").tx

		self.fifo_readable_btn=Signal() 
		self.trans_en=Signal()
		self.tx_serial=Signal()
		#	#	#
		self.counter=Signal(4)
		tx=TX()
		memoria=mem()
		receiver_top=Receiver_top()
		self.submodules+=[tx,memoria,receiver_top]
		self.comb+=[
			tx.data_in.eq(memoria.data_out),
			tx.data_type_in.eq(memoria.type_out),
			tx.link_ready.eq(1),
			self.tx_serial.eq(receiver_top.tx_serial),
			
			tx.tx_init_done.eq(1),
			tx.pll_lock.eq(1),
			receiver_top.din.eq(tx.data_out),
			receiver_top.trans_en.eq(self.trans_en),
			receiver_top.tx_init_done.eq(1),
			receiver_top.pll_lock.eq(1)

		]
		self.sync+=[
			If(tx.fifo_re,memoria.index.eq(memoria.index+1)),
			
			If(self.fifo_readable_btn ,
				If(self.counter<9, 
					self.counter.eq(self.counter+1),
					tx.fifo_empty.eq(0)
				).Else(tx.fifo_empty.eq(1))
			).Else(tx.fifo_empty.eq(1),self.counter.eq(0))
		]
"""
plat=cmoda7.Platform()
dut=top(platform=plat)
plat.build(dut)
"""
def tb(dut):
	
	for i in range(20):
		yield
	yield dut.fifo_readable_btn.eq(1)
	for i in range(20):
		yield
	yield dut.fifo_readable_btn.eq(0)
	yield dut.trans_en.eq(1)
	for i in range(3000):
		yield
	yield dut.trans_en.eq(0)
	yield
	yield dut.fifo_readable_btn.eq(1)
	for i in range(20):
		yield
	yield dut.trans_en.eq(1)
	for i in range(3000):
		yield
	

dut=top()
run_simulation(dut,tb(dut),vcd_name="top_tb.vcd")
