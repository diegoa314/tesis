from litex.soc.cores.code_8b10b import Decoder
from transmitter32b import Transmitter32b
from migen.genlib.fifo import *
from migen import *
class RX(Module):
	def __init__(self):
		self.data_in=Signal(40)
		self.rx_init_done = rx_init_done = Signal()
		self.pll_lock = pll_lock = Signal()
		self.trans_en = trans_en = Signal() #habilitador para el envio
		self.tx_serial= tx_serial = Signal() #senhal serial de salida
		#	#	#
		data_32b=Signal(32)
		rx_k=Signal(4)
		decoder1=Decoder()
		decoder2=Decoder()
		decoder3=Decoder()
		decoder4=Decoder()
		uart_transmitter = Transmitter32b()
		fifo = SyncFIFOBuffered(32,20)
		self.submodules+=[uart_transmitter,fifo,decoder1,decoder2,decoder3,decoder4]
		self.comb+=[
			decoder1.input.eq(self.data_in[:10]),
			decoder2.input.eq(self.data_in[10:20]),
			decoder3.input.eq(self.data_in[20:30]),
			decoder4.input.eq(self.data_in[30:]),
			rx_k[0].eq(decoder1.k),
			rx_k[1].eq(decoder2.k),
			rx_k[2].eq(decoder3.k),
			rx_k[3].eq(decoder4.k),
			data_32b[:8].eq(decoder1.d),
			data_32b[8:16].eq(decoder2.d),
			data_32b[16:24].eq(decoder3.d),
			data_32b[24:32].eq(decoder4.d),
			#writable.eq(fifo.writable),
			#readable.eq(fifo.readable),
			fifo.din.eq(data_32b),
			fifo.re.eq(uart_transmitter.tx_32bdone),
			uart_transmitter.data_in.eq(fifo.dout),
			tx_serial.eq(uart_transmitter.tx_serial),
			uart_transmitter.trans_en.eq(trans_en),
			uart_transmitter.fifoEmpty.eq(~fifo.readable)
			
			
		]
		
		self.submodules.fsm=FSM(reset_state="INIT")
		self.fsm.act("INIT",
			If((rx_init_done & pll_lock),
				NextState("WAITING_SOP")
			)
		)

		self.fsm.act("WAITING_SOP",
			If(((data_32b[:8]==0x3c) & (rx_k[0])), #SOP 
				fifo.we.eq(1),
				NextState("WAITING_EOP")
			)
		)

		self.fsm.act("WAITING_EOP",
			fifo.we.eq(1),
			If(((data_32b[:8]==0xdc) & (rx_k[0])), #EOP
				NextState("WAITING_SOP")
			)

		)

def tb(dut):
	yield dut 