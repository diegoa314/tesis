from migen import *
from litex.soc.cores.code_8b10b import *
#from prbs import *
from prbs_files.prbs import *


class _TX(Module):
	def __init__ (self,data_width=20,reverse=False):
		self.txdata=txdata=Signal(data_width)
		#seldata 0 - PRBS output
		#seldata 1 - input to module
		count=Signal(13)
		self.sync+= count.eq(count+1)
		self.comb += [
			If(count!=0,
				txdata.eq(0b00000000000001001001),
			#).Else(txdata.eq(0b0101111100)) #coma
			#).Else(txdata.eq(0b0011111010)) #coma flipped
			#).Else(txdata.eq(0b1001001))

			).Else(txdata.eq(0b1100000101))
		]

