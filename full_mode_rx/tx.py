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
		
		encoder=Encoder(4,lsb_first=True)
		crc_encoder=TxParallelCrcGenerator(data_width=32, crc_width=20, polynomial=0xc1acf,initial=0xfffff)
	
		stream_controller=Fsm()
		self.submodules+=[encoder, crc_encoder, stream_controller]
		self.comb+=[
			stream_controller.link_ready.eq(self.link_ready),
			stream_controller.fifo_empty.eq(self.fifo_empty),
			stream_controller.data_type.eq(self.data_type_in),
			stream_controller.system_ready.eq(self.tx_init_done & self.pll_lock),
			self.fifo_re.eq(stream_controller.fifo_re),
			If(self.data_type_in!=3,
				crc_encoder.i_data_strobe.eq(stream_controller.strobe_crc)
			),
			crc_encoder.reset.eq(stream_controller.reset_crc),
			If(stream_controller.encoder_ready,
				crc_encoder.i_data_payload.eq(self.data_in),
			),
			If((stream_controller.encoder_ready),
				self.data_out.eq(Cat(encoder.output[0],encoder.output[1],
					encoder.output[2],encoder.output[3])),
			).Else(self.data_out.eq(0)),
		]
		
		self.sync+=[ 
			If((stream_controller.fifo_ready),
				
				encoder.d[0].eq(self.data_in[0:8]),
				encoder.d[1].eq(self.data_in[8:16]),
				encoder.d[2].eq(self.data_in[16:24]),
				encoder.d[3].eq(self.data_in[24:32]),

			),
			If(stream_controller.sop, 
				encoder.d[0].eq(0x3C),
				encoder.k[0].eq(1),
				encoder.d[1].eq(0),
				encoder.d[2].eq(0),
				encoder.d[3].eq(0)  
			),
			If(stream_controller.idle,
				encoder.d[0].eq(0xBC),
				encoder.k[0].eq(1),
				encoder.d[1].eq(0),
				encoder.d[2].eq(0),
				encoder.d[3].eq(0)
			),
			If(stream_controller.ign,
				encoder.d[0].eq(0x5C),
				encoder.k[0].eq(1),
				encoder.d[1].eq(0),
				encoder.d[2].eq(0),
				encoder.d[3].eq(0)
			),
			If(stream_controller.eop,                  
				encoder.d[0].eq(0xDC), 
				encoder.k[0].eq(1),
				encoder.d[1].eq(crc_encoder.o_crc[0:8]),
				encoder.d[2].eq(crc_encoder.o_crc[8:16]),
				encoder.d[3].eq(crc_encoder.o_crc[16:])
				
			),
			If((~stream_controller.idle)&(~stream_controller.eop)&(~stream_controller.sop)&(~stream_controller.ign),
				encoder.k[0].eq(0)	
			),
			encoder.k[1].eq(0),
			encoder.k[2].eq(0),
			encoder.k[3].eq(0),
		]		

