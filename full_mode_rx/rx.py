from litex.soc.cores.code_8b10b import Decoder
from transmitter32b import Transmitter32b
from alignment_corrector import Alignment_Corrector
from migen.genlib.fifo import *
from migen import *
class RX(Module):
	def __init__(self):
		self.data_in=Signal(40)
		self.rx_init_done = rx_init_done = Signal()
		
		self.trans_en = trans_en = Signal() #habilitador para el envio
		self.tx_serial= tx_serial = Signal() #senhal serial de salida
		self.aligned=Signal()
		#	#	#
		corrector=Alignment_Corrector()
		data_32b=Signal(32)
		rx_k0=Signal()
		decoder1=Decoder(lsb_first=True)
		decoder2=Decoder(lsb_first=True)
		decoder3=Decoder(lsb_first=True)
		decoder4=Decoder(lsb_first=True)
		uart_transmitter = Transmitter32b()
		fifo = SyncFIFOBuffered(32,20)
		self.submodules+=[corrector,uart_transmitter,decoder1,decoder2,decoder3,decoder4]
		#self.submodules+=[uart_transmitter,fifo]
		self.comb+=[
			decoder1.input.eq(self.data_in[:10]),
			decoder2.input.eq(self.data_in[10:20]),
			decoder3.input.eq(self.data_in[20:30]),
			decoder4.input.eq(self.data_in[30:]),
			
			corrector.aligned.eq(self.aligned),
			corrector.din[:8].eq(decoder1.d),
			corrector.din[8:16].eq(decoder2.d),
			corrector.din[16:24].eq(decoder3.d),
			corrector.din[24:].eq(decoder4.d),
			data_32b.eq(corrector.dout),
			fifo.din.eq(data_32b),
			fifo.re.eq(uart_transmitter.tx_32bdone),
			uart_transmitter.data_in.eq(fifo.dout),
			tx_serial.eq(uart_transmitter.tx_serial),
			uart_transmitter.trans_en.eq(trans_en),
			uart_transmitter.fifoEmpty.eq(~fifo.readable)
			
			
		]
		self.sync+=[
			rx_k0.eq(decoder3.k),
		]
		
		"""
		self.submodules.fsm=FSM(reset_state="INIT")
		self.fsm.act("INIT",
			If((rx_init_done ),
				NextState("WAITING_SOP")
			)
		)

		self.fsm.act("WAITING_SOP",
			If(((data_32b[:8]==0x3c) & (rx_k0)), #SOP 
				fifo.we.eq(1),
				NextState("WAITING_EOP")
			)
		)

		self.fsm.act("WAITING_EOP",
			fifo.we.eq(1),
			If(((data_32b[:8]==0xdc) & (rx_k0)), #EOP
				NextState("WAITING_SOP")
			)

		)
		"""
		