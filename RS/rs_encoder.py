from migen import *
from g0mult import *
from g1mult import *
from g2mult import *
from g3mult import *
from migen.fhdl.verilog import convert
class Encoder(Module):
	def __init__(self):
		self.data_in=Signal(4)
		self.data_output=Signal(4)
		self.reset=Signal(1) #reset para registros
		#  #  #
		mult_g0,mult_g1,mult_g2,mult_g3=Signal(4) #resultados de las multiplicaciones
		self.reg0=reg0=Signal(4)
		self.reg1=reg1=Signal(4)
		self.reg2=reg2=Signal(4)
		self.reg3=reg3=Signal(4) #registros de desplazamiento
		u0=g0Mult() #modulos multiplicadores
		u1=g1Mult()
		u2=g2Mult()
		u3=g3Mult()
		self.submodules+=[u0,u1,u2,u3]
		#asignacion de los resultados
		self.comb+=[mult_g0.eq(u0.y),mult_g1.eq(u1.y),mult_g2.eq(u2.y),mult_g3.eq(u3.y)]
		counter=Signal(max=11) #contador para los switches
		self.sync+=[
			#If(counter<11,counter.eq(0)
			#).Else(counter.eq(counter+1))
			If(self.reset,counter.eq(0)
			).Else(counter.eq(counter+1))
			
		] 
		feedback=Signal(4) #switch 2
		self.comb+=[
			If(counter>=11,
				feedback.eq(0)
			).Else(feedback.eq(self.data_in^reg3))
		]
		self.comb+=[u0.x.eq(feedback),u1.x.eq(feedback),u2.x.eq(feedback),u3.x.eq(feedback)]
		#registros
		self.comb+=[
			If(self.reset,
				#reg0.eq(0),reg1.eq(0),reg2.eq(0),reg3.eq(0)
			)
		]
		
		#asignacion de valores en los registros
		self.sync+=[
			
			If(~self.reset,
				reg0.eq(u0.y),reg1.eq(u1.y^reg0),
				reg2.eq(u2.y^reg1),reg3.eq(u3.y^reg2)
			)
		]
		#output
		self.comb+=[
			If(counter<11,
				self.data_output.eq(self.data_in)
			).Else(self.data_output.eq(reg3))
		]
convert(Encoder()).write('re_encoder.v')