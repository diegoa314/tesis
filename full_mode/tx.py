from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Tesis/8b10b')
from encoder_comb import *
sys.path.append('/home/diegoaranda/Documents/Tesis/FIFO')
#from fifo2 import *
from fifoDT import * 
from fsm import *
class TX(Module):
	def __init__(self):
		self.link_ready=Signal()
		self.fifo_we=Signal()
		self.data_in=Signal(32)
		self.data_type_in=Signal(2)
		self.data_out=Signal(40)
		#  #  #
		encoder1=Encoder()
		encoder2=Encoder()
		encoder3=Encoder()
		encoder4=Encoder()
		fifo=SyncFIFOBuffered(width=32, depth=32)
		fsm=Fsm()
		self.submodules+=[encoder1, encoder2,encoder3,encoder4,fifo,fsm]
		self.comb+=[
			fsm.link_ready.eq(self.link_ready),
			fsm.fifo_empty.eq(~fifo.fifo.readable),
			fsm.data_type.eq(fifo.dtout),
			fifo.din.eq(self.data_in),   #
			fifo.dtin.eq(self.data_type_in), ############################################
			fifo.we.eq(self.fifo_we),
			fifo.re.eq(fsm.fifo_re)
			
		]

		self.sync+=[ 
			#La asignacion de disparidad debe ser secuencial debido a la
			#dependecia mutua de ambas senhalas (disp_in y disp_out)
			If(fsm.change_disp,
				encoder1.disp_in.eq(encoder4.disp_out),
				encoder2.disp_in.eq(encoder1.disp_out),
				encoder3.disp_in.eq(encoder2.disp_out),
				encoder4.disp_in.eq(encoder3.disp_out)
			),
			If(fsm.encoder_ready,
				self.data_out[0:10].eq(encoder1.output),
				self.data_out[10:20].eq(encoder2.output),
				self.data_out[20:30].eq(encoder3.output),
				self.data_out[30:40].eq(encoder4.output),
			),
			If(fsm.fifo_ready,
				encoder1.data_in.eq(fifo.dout[0:8]),
				encoder2.data_in.eq(fifo.dout[8:16]),
				encoder3.data_in.eq(fifo.dout[16:24]),
				encoder4.data_in.eq(fifo.dout[24:32]),
			),
			If(fsm.sop, 
				encoder1.data_in.eq(0x3C),
				encoder1.k.eq(1),  
			).Elif(fsm.eop,
				encoder1.data_in.eq(0xDC), #0xDC
				encoder1.k.eq(1),
			).Elif(fsm.idle,
				encoder1.data_in.eq(0xBC),
				encoder1.k.eq(1),
			)
			
		]	
def tb(dut):
	yield dut.link_ready.eq(0)
	yield dut.fifo_we.eq(1)
	yield dut.data_in.eq(0xAAAAAAAA)
	yield dut.data_type_in.eq(0b01)	
	yield
	yield dut.fifo_we.eq(1)
	yield dut.data_type_in.eq(0b00)
	yield dut.data_in.eq(0xBBBBBBBB)
	yield
	yield dut.data_type_in.eq(0b00)
	yield dut.fifo_we.eq(1)
	yield dut.data_in.eq(0xCCCCCCCC)
	yield
	yield dut.fifo_we.eq(1)
	yield dut.data_in.eq(0xDDDDDDDD)
	yield dut.data_type_in.eq(0b00)
	yield
	yield dut.fifo_we.eq(1)
	yield dut.data_in.eq(0xEEEEEEEE)
	yield dut.data_type_in.eq(0b00)
	yield
	yield dut.fifo_we.eq(1)
	yield dut.data_in.eq(0xFFFFFFFF)
	yield dut.data_type_in.eq(0b10)
	yield
	yield dut.fifo_we.eq(0)
	for i in range(40):
		yield
		yield dut.link_ready.eq(1)
dut=TX()
run_simulation(dut,tb(dut),vcd_name="tx.vcd")
