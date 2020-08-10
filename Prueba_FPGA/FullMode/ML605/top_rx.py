from litex.soc.cores.code_8b10b import Decoder
from transmitter32b import Transmitter32b

from migen.genlib.fifo import *
from migen import *
class RX(Module):
	def __init__(self):
		self.rx_data_in=Signal(40)
		self.rx_init_done = rx_init_done = Signal()
		self.trans_en = trans_en = Signal() #habilitador para el envio
		self.tx_serial= tx_serial = Signal() #senhal serial de salida
		
		
		#	#	#
		
		data_32b=Signal(32)
		
		decoder1=Decoder(lsb_first=True)
		decoder2=Decoder(lsb_first=True)
		decoder3=Decoder(lsb_first=True)
		decoder4=Decoder(lsb_first=True)
		decoder_out=Signal(32)
		uart_transmitter = Transmitter32b()
		fifo = SyncFIFOBuffered(32,20)
		
		self.submodules+=[uart_transmitter,decoder1,decoder2,decoder3,decoder4,fifo]
		self.comb+=[
			decoder1.input.eq(self.rx_data_in[:10]),
			decoder2.input.eq(self.rx_data_in[10:20]),
			decoder3.input.eq(self.rx_data_in[20:30]),
			decoder4.input.eq(self.rx_data_in[30:]),
			decoder_out.eq(Cat(decoder1.d,decoder2.d,decoder3.d,decoder4.d,)),
			fifo.din.eq(decoder_out),
			fifo.re.eq(uart_transmitter.tx_32bdone),
			uart_transmitter.data_in.eq(fifo.dout),
			tx_serial.eq(uart_transmitter.tx_serial),
			uart_transmitter.trans_en.eq(trans_en),
			uart_transmitter.fifoEmpty.eq(~fifo.readable)
		]
		
		self.submodules.fsm=FSM(reset_state="INIT")
	
		self.fsm.act("INIT",
			If((rx_init_done),
				NextState("WAITING_SOP")
			)
		)

		self.fsm.act("WAITING_SOP",
			If(((decoder_out[:8]==0x3c) & (decoder1.k)), #SOP 
				fifo.we.eq(1),
				NextState("WAITING_EOP")
			)
		)

		self.fsm.act("WAITING_EOP",
			fifo.we.eq(1),
			If(((decoder_out[:8]==0xdc) & (decoder1.k)), #EOP
				NextState("WAITING_SOP")
			)

		)
		
		