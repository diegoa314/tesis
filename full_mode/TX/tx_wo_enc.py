from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Tesis')
from full_mode.FSM.fsm import Fsm
from crc.crc_v1 import TxParallelCrcGenerator
class TX(Module):
	def __init__(self):
		self.link_ready=Signal()
		self.data_in=Signal(32)
		self.data_type_in=Signal(2)
		self.data_out=Signal(32)
		self.fifo_empty=Signal()
		self.fifo_re=Signal()
		self.tx_init_done=Signal()
		self.pll_lock=Signal()
		self.k=Signal()

		self.reset=Signal()
		#  #  #
		crc_encoder=TxParallelCrcGenerator(data_width=32, crc_width=20, polynomial=0xc1acf,initial=0xfffff)
		fsm=Fsm()
		self.submodules+=[crc_encoder, fsm]
		self.comb+=[
			fsm.link_ready.eq(self.link_ready),
			fsm.fifo_empty.eq(self.fifo_empty),
			fsm.data_type.eq(self.data_type_in),
			fsm.reset.eq(self.reset),
			fsm.system_ready.eq(self.tx_init_done & self.pll_lock),
			self.fifo_re.eq(fsm.fifo_re),
			crc_encoder.i_data_strobe.eq(fsm.strobe_crc),
			#se hace combinacional para no tener que esperar un ciclo extra para el resultado crc
			If(fsm.encoder_ready,
				crc_encoder.i_data_payload.eq(self.data_in),
			),
			
		]
		
		self.sync+=[ 
			If(fsm.sop, 
				self.data_out.eq(0x3C),
				self.k.eq(1)
			).Elif(fsm.eop,                  
				self.data_out.eq(Cat(0xDC,crc_encoder.o_crc)),
				self.k.eq(1)
			).Elif(fsm.idle,
				self.data_out.eq(0xBC),
				self.k.eq(1)
			).Else(
				self.data_out.eq(self.data_in),
				self.k.eq(0)
			)
		]
				
