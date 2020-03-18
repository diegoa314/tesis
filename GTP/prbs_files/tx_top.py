from migen import *
from litex.soc.cores.code_8b10b import *
#from prbs import *
from prbs_files.prbs import *


class _TX(Module):
	def __init__ (self,data_width=20,reverse=False):
		self.txdata=txdata=Signal(data_width)
		#seldata 0 - PRBS output
		#seldata 1 - input to module
		count=Signal(12)
		self.sync+= count.eq(count+1)
		self.comb += [
			If(count!=0,
				txdata.eq(0b0101111100),
			

			#).Else(txdata.eq(0b11000001011100000101)) #coma no anduvo asi
			).Else(txdata.eq(0b11000000111100000011))
		] 

