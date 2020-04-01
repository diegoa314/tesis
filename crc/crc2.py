from migen import *
from migen.fhdl import *

#CRC_Width = 20
#Poly = 0b11000001101011001111
#InitVal= 0b11111111111111111111
#unit = 0b00000000000000000001
#zero = 0b00000000000000000000

"""
class ToIndirectInitVal (Module):    #Recive el archivo Direct
	def __init__(self):
		self.Direct = Direct =Signal(20)
		self.InDirect = InDirect = Signal(20) 
		#self.comb+=Direct.eq(InitVal)

		unit = Signal(20)
		aux1 = Signal(20)  #cable de asignacion a InDirect
		Poly=Signal(20)
		self.comb+=[unit.eq(0b00000000000000000001), Poly.eq(0b11000001101011001111)]
		
		for k in range(20):
			if k==0:
				self.comb+=[aux1.eq(Direct+1)]
			else:
				
				self.comb+=[
					If(aux1[0] & 1,    #if(InDirect & unit):
						aux1.eq((aux1 >> 1) ^ ((unit<<(19)) | (Poly >> 1)))
					).Else(
						aux1.eq(aux1 >> 1)
					)
				]
				
			
		self.comb+=InDirect.eq(aux1)	
		
"""
class CRC (Module):    ###Es necesario declarar length
	def __init__(self, length=32):
		self.data_32 = data_32 = Signal(32)
		#self.Reg = Reg = Signal(20)     ## 20 bits
		#self.ApplyPoly = ApplyPoly = Signal()   ## 1 bit
		#self.ones = ones = Signal(20)  ## 20 bits
		#self.unit = unit = Signal(20)
		self.Poly = Poly = Signal(20)
		self.reset=Signal()
		self.calc=Signal()
		self.crc=Signal(20)

		self.aux =  aux =Signal(20, reset=0xDCC85)  #Inicializado al valor que genera ToIndirectVal
		#self.aux =  aux =Signal(20)

		#self.comb+=ones.eq((unit<<(20)) - unit)
		#self.comb+=unit.eq(0b00000000000000000001)
		self.comb+=Poly.eq(0b11000001101011001111)
		
		for t in range (31):  #Seria el intento de conseguir el mismo resultado que el for de la linea 67 del VHDL
			self.sync+=[	
				If(self.reset & self.calc,	
					If(aux[19],
						aux.eq((Cat(data_32[31-t],(aux<<1))^Poly))
					).Else(
						aux.eq(Cat(data_32[31-t],(aux<<1)))
					)
				).Elif(self.calc,
					If(aux[19],
						aux.eq(Cat(data_32[31-t],(aux<<1))^Poly)
					).Else(
						aux.eq(Cat(data_32[31-t],(aux<<1)))
					)	
				)	
			]		
		aux2=Signal(20)
		self.sync+=aux2.eq(aux) 

		for k in range(19):
			self.sync+=[
				If(aux2[19],
					aux2.eq((aux<<1)^Poly)
				).Else(
					aux2.eq((aux<<1))
				)
			]
		self.sync+=self.crc.eq(aux2)
	

#class checksum (Module):
#	def __init__(self):
#		self.data_in = data_in = Signal(32)
#		self.crc_data = crc_data = Signal(CRC_Width)
		
#		self.comb+= crc_data.eq(CRC(dataF, 32))


def crc_tb(dut):
	yield dut.data_32.eq(0b11001100110011001100110011001100)
	yield dut.calc.eq(1)
	yield 
	yield
	yield
	yield	
	
dut=CRC()
run_simulation(dut,crc_tb(dut),vcd_name="crc.vcd")
import subprocess
subprocess.Popen(["gtkwave", "crc.vcd"])

