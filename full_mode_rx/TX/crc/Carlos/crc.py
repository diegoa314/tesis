#import numpy as np

CRC_Width = 20
#Poly = 0b11000001101011001111
Poly = 0b11000001101011001111
InitVal= 0b11111111111111111111
unit = 0b00000000000000000001
zero = 0b00000000000000000000

def ToIndirectInitVal (Direct):
	Direct = InitVal
	InDirect = zero
	for k in range(CRC_Width):
		if (k==0):
			InDirect = Direct
		else:
			if(InDirect & unit):
				InDirect = (InDirect >> 1) ^ ((unit<<(19)) | (Poly >> 1))
			else:
				InDirect = InDirect >> 1	
	print (InDirect) 
	print ('siguiente paso')
	return InDirect

data = [1,0,1,0,1,1,0,1,1,1,1,1,1,0,1,0,1,1,1,0,1,0,1,0,1,1,0,1,0,1,1,1]


Reg = zero      ## 20 bits
ApplyPoly = zero ## un bit
ones = zero ## 20 bits
ones =(unit<<(CRC_Width)) - unit
#Reg = ToIndirectInitVal(InitVal)
length = 32
for i in range(length):
	for k in range(32):
		m1 = 32 - k
		if(Reg & (unit<<(19))):
			Reg=((Reg<<1) | (( data [i]>>(m1)) & unit) ^ Poly)
		else:
			Reg=((Reg<<1) | (( data [i]>>(m1)) & unit))
		
	Reg=(Reg & ones)
for k in range(CRC_Width):
	m2 = 19
	if(Reg & (unit<<(m2))):
		Reg=((Reg<<1)^Poly) 
	else:
	 	Reg=((Reg<<1))
	print (Reg)	 



	