from migen import *
from full import * 
from migen.fhdl.specials import Memory, READ_FIRST

"""Consideraciones para los valores de prueba
   - lugares impares intype = 0b01
   - lugares pares intype = 0b11
   - palabras en el 16 y 17, lugares del medio intype = 0b10

"""

value_input = [ #valores para verificacion de transmision de datos 
    0b00000000000000000000000000000001,
    0b00000000000000000000000000000011,
    0b00000000000000000000000000000111,
    0b00000000000000000000000000001111,
    0b00000000000000000000000000011111,
    0b00000000000000000000000000111111,
    0b00000000000000000000000001111111,
    0b00000000000000000000000011111111,
    0b00000000000000000000000111111111,
    0b00000000000000000000001111111111,
    0b00000000000000000000011111111111,
    0b00000000000000000000111111111111,
    0b00000000000000000001111111111111,
    0b00000000000000000011111111111111,
    0b00000000000000000111111111111111, 
    0b00000000000000001111111111111111,   #[16]
    0b00000000000000011111111111111111,	  #[17] 
    0b00000000000000111111111111111111,
    0b00000000000001111111111111111111,
    0b00000000000011111111111111111111,
    0b00000000000111111111111111111111,
    0b00000000001111111111111111111111,
    0b00000000011111111111111111111111,
    0b00000000111111111111111111111111,
    0b00000001111111111111111111111111,
    0b00000011111111111111111111111111,
    0b00000111111111111111111111111111,
    0b00001111111111111111111111111111,
    0b00011111111111111111111111111111,
    0b00111111111111111111111111111111,
    0b01111111111111111111111111111111,
    0b11111111111111111111111111111111
]

value_type = [
	0b01,   #impar
	0b11,
	0b01,	#impar
	0b11, 	
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b10, #PALABRA DEL MEDIO
	0b10, #PALABRA DEL MEDIO
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11, 
	0b01,	#impar
	0b11 

]


class mem(Module):
	def __init__(self):

		self.fifo_we=Signal()  
		self.re=Signal()
		self.receiver_en=Signal()
		index = Signal(32)

		table1 = Memory(32, 32, init = Array(value_input), name="INPUT")  #Se genera un BlockRAM donde se cargan los valores del vector 5b6b
		self.specials += table1

		wrport1 = table1.get_port(write_capable=True, mode=READ_FIRST) # Elemento de referencia del bloque "TABLE_5b6b"
		self.specials += wrport1

		table2 = Memory(2, 23, init = Array(value_type), name="TYPE") #Se genera un BlockRAM donde se cargan los valores del vector 3b4b
		self.specials += table2

		wrport2 = table2.get_port(write_capable=True, mode=READ_FIRST) # Elemento de referencia del bloque "TABLE_3b4b"
		self.specials += wrport2

		fulltransmiter = full()
		self.submodules+= [fulltransmiter]

		#i = 0b0
		#for i in range (32):
		#	wrport1.adr.eq(i)
		#	wrport2.adr.eq(i)

		
		self.comb += [
			 	fulltransmiter.fifo_we.eq(self.fifo_we),
			 	fulltransmiter.re.eq(self.re),
				fulltransmiter.receiver_en.eq(self.receiver_en),
			#	fulltransmiter.input.eq(wrport1.dat_r),
			#	fulltransmiter.intype.eq(wrport2.dat_r)
		]


		self.sync += [
			wrport1.adr.eq(index),
			wrport2.adr.eq(index),
			fulltransmiter.input.eq(wrport1.dat_r),
			fulltransmiter.intype.eq(wrport2.dat_r),
			index.eq(index + 1)
		]	