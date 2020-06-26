from litex.soc.cores.code_8b10b import Decoder
from migen import *
class RX(Module):
	def __init__(self):
		self.data_in=Signal(40)
		self.data_out=Signal(32)
		#	#	#
		decoder1=Decoder()
		decoder2=Decoder()
		decoder3=Decoder()
		decoder4=Decoder()
		self.submodules+=[decoder1,decoder2,decoder3,decoder4]
		self.comb+=[
			decoder1.input.eq(self.data_in[0:10]),
			decoder2.input.eq(self.data_in[10:20]),
			decoder3.input.eq(self.data_in[20:30]),
			decoder4.input.eq(self.data_in[30:40]),

			self.data_out[:8].eq(decoder1.d),
			self.data_out[8:16].eq(decoder2.d),
			self.data_out[16:24].eq(decoder3.d),
			self.data_out[24:32].eq(decoder4.d)
		]