from migen import *
from litex.soc.cores.code_8b10b import *
#from prbs import *
from prbs_files.prbs import *

class _RX(Module):
	def __init__(self, data_width = 20,reverse=False):
		
		self.rxdata = rxdata = Signal(data_width)
		