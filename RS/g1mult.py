from migen import *
from migen.fhdl.verilog import convert
class g1Mult(Module):
	def __init__(self):
		self.x=x=Signal(4) #entrada
		self.y=y=Signal(4) #salida
		#  #  #
		#g1=1
		self.comb+=[
			y[0].eq(x[0]),
			y[1].eq(x[1]),
			y[2].eq(x[2]),
			y[3].eq(x[3])
		]

convert(g1Mult()).write('g1Mult.v')