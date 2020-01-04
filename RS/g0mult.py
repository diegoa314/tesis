from migen import *
class g0Mult(Module):
	def __init__(self):
		self.x=x=Signal(4) #entrada
		self.y=y=Signal(4) #salida
		#  #  #
		#g0=12
		self.comb+=[ 
			y[0].eq(x[1]^x[2]),
			y[1].eq(x[1]^x[3]),
			y[2].eq(x[0]^x[2]),
			y[3].eq(x[0]^x[1]^x[3])
		]