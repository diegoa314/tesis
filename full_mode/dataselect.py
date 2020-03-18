from migen import *
from migen.fhdl import verilog

class DataSelect(Module):
	def __init__(self):
		self.data_in=data_in=Signal(32)
		self.datapackage=datapackage=Signal(32)
		self.busy=busy=Signal(4)
		self.select=select=Signal()
		self.data_out=data_out=Signal(32)

		self.comb += [
			If(select,
				data_out.eq(data_in)
			).Else(
				data_out.eq(datapackage),
				data_out[28:31].eq(busy),
			)
		]
