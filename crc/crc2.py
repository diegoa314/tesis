from migen import *
from migen.fhdl import *

#CRC_Width = 20
#Poly = 0b11000001101011001111
#InitVal= 0b11111111111111111111
#unit = 0b00000000000000000001
#zero = 0b00000000000000000000


class ToIndirectInitVal (Module):    #Recive el archivo Direct
	def __init__(self):
		#self.Direct = Direct =Signal(20)
		self.InDirect = InDirect = Signal(20) 
		#self.comb+=Direct.eq(InitVal)

		#unit = Signal(20)
		aux1 = Signal(20)  #cable de asignacion a InDirect
		#self.comb+=unit.eq(0b00000000000000000001)

		for k in range(20):
			If(k==0,
				aux1.eq(InitVal)
			).Else(
				If(aux1 & unit,    #if(InDirect & unit):
					aux1.eq((aux1 >> 1) ^ ((unit<<(19)) | (Poly >> 1)))
				).Else(
					aux1.eq(aux1 >> 1)
				)
			)
		self.comb+=InDirect.eq(aux1)	

class CRC (Module):    ###Es necesario declarar length
	def __init__(self, length):
		self.data_32 = data_32 = Signal(32)
		self.Reg = Reg = Signal(20)     ## 20 bits
		self.ApplyPoly = ApplyPoly = Signal()   ## 1 bit
		self.ones = ones = Signal(20)  ## 20 bits
		self.unit = unit = Signal(20)
		self.Poly = Poly = Signal(20)

		self.aux2 =  aux2 =Signal(20)  #cable de asignacion a Reg
		self.comb+=aux2.eq(0b01111000001111000101)
		self.comb+=ones.eq((unit<<(20)) - unit)
		self.comb+=unit.eq(0b00000000000000000001)
		self.comb+=Poly.eq(0b11000001101011001111)
		

		for i in range(32):
			for k in range(32):
				self.comb+=[
					If(aux2 & (unit<<(19)),
						aux2.eq((aux2<<1) | (( data_32[i]>>(31 - k)) & 1) ^ 0b11000001101011001111)
					).Else(
						aux2.eq((aux2<<1) | (( data_32[i]>>(31 - k)) & 1))
					)
				]
			self.comb+=aux2.eq(aux2 & ones)
		
		for m in range(20):
			self.comb+=[
				If(aux2 & (unit<<(19)),
					aux2.eq((aux2<<1)^0b11000001101011001111) 
				).Else(
		 			aux2.eq((aux2<<1))
		 		)
		 		
		 	]
		self.comb+=Reg.eq(aux2 & ones)

	

#class checksum (Module):
#	def __init__(self):
#		self.data_in = data_in = Signal(32)
#		self.crc_data = crc_data = Signal(CRC_Width)
		
#		self.comb+= crc_data.eq(CRC(dataF, 32))


def crc_tb(dut):
	yield dut.data_32.eq(0b11001100110011001100110011001100)
	yield
	yield dut.data_32.eq(0b11010111011111011001010101110101)
	yield
	yield dut.data_32.eq(0b00000000111001111100000001111000)
	yield
	yield dut.data_32.eq(0b10101010101010101010101010101010)
	yield
	yield dut.data_32.eq(0b11111111111111111111000000000000)
	yield
	yield dut.data_32.eq(0b11000000000000000000011111111111)
	yield

	
dut=CRC(32)
run_simulation(dut,crc_tb(dut),vcd_name="crc.vcd")
import subprocess
subprocess.Popen(["gtkwave", "crc.vcd"])


