import sys
sys.path.append('/home/diegoaranda/Documents/Prueba/UART')
from tx import *
sys.path.append('/home/diegoaranda/Documents/Prueba/8b10b')
from encoder import *

class Transmitter(Module):
	def __init__(self, freq, baud_rate):
		self.transmitter_input=Signal(8)
		self.transmitter_ready=Signal(1)
		self.transmitter_output=Signal(1)
		#  #  #
		encoder=SingleEncoder()
		self.submodules+=encoder
		transmitter_tx=tx(freq=freq,baud_rate=baud_rate, n_bits=10)
		self.submodules+=transmitter_tx
		self.comb+=[
			encoder.data_in.eq(self.transmitter_input),
			encoder.k.eq(0),
			encoder.disp_in.eq(0)
		]
		self.sync+=[
			transmitter_tx.tx_data.eq(encoder.output),
			self.transmitter_output.eq(transmitter_tx.tx_serial),
			transmitter_tx.tx_ready.eq(self.transmitter_ready)
		]

