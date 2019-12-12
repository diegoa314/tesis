from migen import *
from receiver_8b10b import *
from transmitter_8b10b import *

class rxtx(Module):
	def __init__(self, freq, baud_rate):
		self.rxtx_input=Signal(8)
		self.rxtx_transmitter_ready=Signal()
		self.rxtx_receiver_read_enable=Signal()
		self.rxtx_output=Signal(8)
		#  #  #
		receiver=Receiver(freq,baud_rate)
		transmitter=Transmitter(freq,baud_rate)
		self.submodules+=[receiver, transmitter]
		self.comb+=[
			transmitter.transmitter_input.eq(self.rxtx_input),
			transmitter.transmitter_ready.eq(self.rxtx_transmitter_ready),
			receiver.receiver_read_enable.eq(self.rxtx_receiver_read_enable)
		]
		self.sync+=[
			receiver.receiver_serial.eq(transmitter.transmitter_output),
			self.rxtx_output.eq(receiver.receiver_output)

		]

