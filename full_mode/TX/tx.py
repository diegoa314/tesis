from migen import *
from .fsm import Fsm
from .crc import TxParallelCrcGenerator
from .encoder import Encoder
class TX(Module):
	def __init__(self):
		self.link_ready=Signal()
		self.data_in=Signal(32)
		self.data_type_in=Signal(2)
		self.data_out=Signal(40)
		self.fifo_empty=Signal(reset=1)
		self.fifo_re=Signal()
		self.tx_init_done=Signal()
		self.pll_lock=Signal()

		self.reset=Signal()
		#  #  #
		
		encoder=Encoder(4)
		crc_encoder=TxParallelCrcGenerator(data_width=32, crc_width=20, polynomial=0xc1acf,initial=0xfffff)
	
		fsm=Fsm()
		#fsm=ClockDomainsRenamer("user_domain")(fsm)
		self.submodules+=[encoder, crc_encoder, fsm]
		self.comb+=[
			fsm.link_ready.eq(self.link_ready),
			fsm.fifo_empty.eq(self.fifo_empty),
			fsm.data_type.eq(self.data_type_in),
			fsm.reset.eq(self.reset),
			fsm.system_ready.eq(self.tx_init_done & self.pll_lock),
			self.fifo_re.eq(fsm.fifo_re),
			crc_encoder.i_data_strobe.eq(fsm.strobe_crc),
			crc_encoder.reset.eq(fsm.reset_crc),
			#se hace combinacional para no tener que esperar un ciclo extra para el resultado crc
			If(fsm.encoder_ready,
				crc_encoder.i_data_payload.eq(self.data_in),
			),
		

			If((fsm.encoder_ready),
				self.data_out.eq(Cat(encoder.output[0],encoder.output[1],
					encoder.output[2],encoder.output[3])),
			).Else(self.data_out.eq(0)),
				
			

		]
		
		self.sync+=[ 
			
			#La asignacion de disparidad debe ser secuencial debido a la
			#dependecia mutua de ambas senhalas (disp_in y disp_out)
			
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
				#encoder2.data_in.eq(0xaa),
				#encoder3.data_in.eq(0xbb),
				#encoder4.data_in.eq(0xcc)
			),
			encoder.k[1].eq(0),
			encoder.k[2].eq(0),
			encoder.k[3].eq(0),
		]		
		
"""
def tb(dut):
	yield dut.link_ready.eq(0)
	yield dut.fifo_we.eq(1)
	yield dut.self.data_in.eq(0xAAAAAAAA)
	yield dut.data_type_in.eq(0b01)	
	yield
	yield dut.fifo_we.eq(1)
	yield dut.data_type_in.eq(0b00)
	yield dut.self.data_in.eq(0xBBBBBBBB)
	yield
	yield dut.data_type_in.eq(0b00)
	yield dut.fifo_we.eq(1)
	yield dut.self.data_in.eq(0xCCCCCCCC)
	yield
	yield dut.fifo_we.eq(1)
	yield dut.self.data_in.eq(0xDDDDDDDD)
	yield dut.data_type_in.eq(0b00)
	yield
	yield dut.fifo_we.eq(1)
	yield dut.self.data_in.eq(0xEEEEEEEE)
	yield dut.data_type_in.eq(0b00)
	yield
	yield dut.fifo_we.eq(1)
	yield dut.self.data_in.eq(0xFFFFFFFF)
	yield dut.data_type_in.eq(0b10)
	yield
	yield dut.fifo_we.eq(0)
	for i in range(40):
		yield
		yield dut.link_ready.eq(1)
dut=TX()
run_simulation(dut,tb(dut),vcd_name="tx.vcd")
"""
