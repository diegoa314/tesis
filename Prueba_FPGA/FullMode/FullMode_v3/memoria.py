from migen import *

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

		self.index=index= Signal(5)
		self.data_out=Signal(32)
		self.type_out=Signal(2)

		table1 = Memory(32, 32, init = Array(value_input), name="INPUT") 
		self.specials += table1

		wrport1 = table1.get_port(write_capable=True, mode=READ_FIRST) 
		self.specials += wrport1

		table2 = Memory(2, 32, init = Array(value_type), name="TYPE") 
		self.specials += table2

		wrport2 = table2.get_port(write_capable=True, mode=READ_FIRST) 
		self.specials += wrport2

		self.sync += [
			wrport1.adr.eq(index),
			wrport2.adr.eq(index),
			self.data_out.eq(wrport1.dat_r),
			self.type_out.eq(wrport2.dat_r)
			#index.eq(index + 1)
		]	

