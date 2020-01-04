from migen import *
from migen.fhdl.verilog import convert
class g2Mult(Module):
	def __init__(self):
		self.x=x=Signal(4) #entrada
		self.y=y=Signal(4) #salida
		#  #  #
		#g2=3
		self.comb+=[
			y[0].eq(x[3]^x[0]),
			y[1].eq(x[3]^x[1]^x[0]),
			y[2].eq(x[1]^x[2]),
			y[3].eq(x[2]^x[3])
		]
convert(g2Mult()).write('g2Mult.v')