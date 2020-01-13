from migen import *
import sys
sys.path.append('/root/Tesis/modulo_prueba2/tesis/UART')
from rx import *
sys.path.append('/root/Tesis/modulo_prueba2/tesis/8b10b')
from decoder import *
from transmitter_8b10b import * ############################### TEEE QUEDASTEEE ACAAAA   >>>> VIERNES 10 ENERO

class Receiver(Module):
	def __init__(self,freq=10000,baud_rate=1000):
		self.receiver_input = Signal(42)
		self.receiver_serial=Signal()
		self.receiver_read_enable=Signal()
		self.receiver_output=Signal(32) ################################################33
		#   #  #
		ready=Signal()
		receiver_rx=rx(freq=freq,baud_rate=baud_rate,n_bits=40)
		receiver_decoder1=Decoder(lsb_first=False)
		receiver_decoder2=Decoder(lsb_first=False)
		receiver_decoder3=Decoder(lsb_first=False)
		receiver_decoder4=Decoder(lsb_first=False)
		self.submodules+=[receiver_rx,receiver_decoder1,receiver_decoder2,receiver_decoder3,receiver_decoder4]
		self.comb+=[
			receiver_rx.rx_read_enable.eq(self.receiver_read_enable),
			receiver_rx.rx_serial.eq(self.receiver_serial),
			receiver_rx.rx_data.eq(self.receiver_input),
			If(receiver_rx.rx_ready,
				ready.eq(1)
			),
			If(ready,
				receiver_decoder1.decoder_input.eq(receiver_rx.rx_data[0:9]),
				receiver_decoder2.decoder_input.eq(receiver_rx.rx_data[10:19]),
				receiver_decoder3.decoder_input.eq(receiver_rx.rx_data[20:29]),
				receiver_decoder4.decoder_input.eq(receiver_rx.rx_data[30:39]),
				receiver_decoder1.decoder_k.eq(0),
				receiver_decoder2.decoder_k.eq(0),
				receiver_decoder3.decoder_k.eq(0),
				receiver_decoder4.decoder_k.eq(0),
				self.receiver_output[0:7].eq(receiver_decoder1.decoder_output),
				self.receiver_output[8:15].eq(receiver_decoder2.decoder_output),
				self.receiver_output[16:23].eq(receiver_decoder3.decoder_output),
				self.receiver_output[24:31].eq(receiver_decoder4.decoder_output),
			)
		]

		
