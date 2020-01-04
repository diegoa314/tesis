from migen import *
class g3Mult(Module):
	def __init__(self):
		self.x=x=Signal(4) #entrada
		self.y=y=Signal(4) #salida
		#  #  #
		#g3=15
		self.comb+=[
			y[0].eq(x[0]^x[1]^x[2]^x[3]),
			y[1].eq(x[0]),
			y[2].eq(x[0]^x[1]),
			y[3].eq(x[0]^x[1]^x[2])
		]