from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Prueba/UART')
from rx import *
sys.path.append('/home/diegoaranda/Documents/Prueba/8b10b')
from decoder import *

class Receiver(Module):
	def __init__(self,freq,baud_rate):
		self.receiver_serial=Signal()
		self.receiver_read_enable=Signal()
		self.receiver_output=Signal(8)
		#   #  #
		ready=Signal()
		receiver_rx=rx(freq=freq,baud_rate=baud_rate,n_bits=10)
		receiver_decoder=Decoder(lsb_first=False)
		self.submodules+=[receiver_rx,receiver_decoder]
		self.comb+=[
			receiver_rx.rx_read_enable.eq(self.receiver_read_enable),
			receiver_rx.rx_serial.eq(self.receiver_serial),
			If(receiver_rx.rx_ready,
				ready.eq(1)
			),
			If(ready,
				receiver_decoder.decoder_input.eq(receiver_rx.rx_data),
				receiver_decoder.decoder_k.eq(0),
				self.receiver_output.eq(receiver_decoder.decoder_output)
			)
		]

		
