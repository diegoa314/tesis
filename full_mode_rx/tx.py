from migen import *
from fsm import Fsm
from crc import TxParallelCrcGenerator
from litex.soc.cores.code_8b10b import Encoder
class TX(Module):
	def __init__(self):
		self.link_ready=Signal()
		self.data_in=Signal(32)
		self.data_type_in=Signal(2)
		self.data_out=Signal(40)
		self.fifo_empty=Signal()
		self.fifo_re=Signal()
		self.tx_init_done=Signal()
		self.pll_lock=Signal()

		
		#  #  #
		
		encoder=Encoder(4)
		crc_encoder=TxParallelCrcGenerator(data_width=32, crc_width=20, polynomial=0xc1acf,initial=0xfffff)
	
		fsm=Fsm()
		self.submodules+=[encoder, crc_encoder, fsm]
		self.comb+=[
			fsm.link_ready.eq(self.link_ready),
			fsm.fifo_empty.eq(self.fifo_empty),
			fsm.data_type.eq(self.data_type_in),
			
			fsm.system_ready.eq(self.tx_init_done & self.pll_lock),
			self.fifo_re.eq(fsm.fifo_re),
			crc_encoder.i_data_strobe.eq(fsm.strobe_crc),
			crc_encoder.reset.eq(fsm.reset_crc),
			If(fsm.encoder_ready,
				crc_encoder.i_data_payload.eq(self.data_in),
			),
		

			If((fsm.encoder_ready),
				self.data_out.eq(Cat(encoder.output[0],encoder.output[1],
					encoder.output[2],encoder.output[3])),
			).Else(self.data_out.eq(0)),
				
			

		]
		
		self.sync+=[ 
			If((fsm.fifo_ready),
				
				encoder.d[0].eq(self.data_in[0:8]),
				encoder.d[1].eq(self.data_in[8:16]),
				encoder.d[2].eq(self.data_in[16:24]),
				encoder.d[3].eq(self.data_in[24:32]),

			),
			If(fsm.sop, 
				encoder.d[0].eq(0x3C),
				encoder.k[0].eq(1),
				encoder.d[1].eq(0),
				encoder.d[2].eq(0),
				encoder.d[3].eq(0)  
			),
			If(fsm.idle,
				encoder.d[0].eq(0xBC),
				encoder.k[0].eq(1),
				encoder.d[1].eq(0),
				encoder.d[2].eq(0),
				encoder.d[3].eq(0)
			),
			If(fsm.eop,                  
				encoder.d[0].eq(0xDC), #0xDC
				encoder.k[0].eq(1),
				encoder.d[1].eq(crc_encoder.o_crc[0:8]),
				encoder.d[2].eq(crc_encoder.o_crc[8:16]),
				encoder.d[3].eq(crc_encoder.o_crc[16:])
				
			),
			If((~fsm.idle)&(~fsm.eop)&(~fsm.sop),
				encoder.k[0].eq(0)	
			),
			encoder.k[1].eq(0),
			encoder.k[2].eq(0),
			encoder.k[3].eq(0),
		]		
		
