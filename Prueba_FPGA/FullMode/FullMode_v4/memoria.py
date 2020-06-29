from migen import *

from migen.fhdl.specials import Memory, READ_FIRST

"""Consideraciones para los valores de prueba
   - lugares impares intype = 0b01
   - lugares pares intype = 0b11
   - palabras en el 16 y 17, lugares del medio intype = 0b10

"""

value_input = [ #valores para verificacion de transmision de datos 
    0xffffffff,
    0xa1a2a3a4,
    0xb1b2b3b4,
    0xc1c2c3c4,
    0xd1d2d3d4,
    0xf1f2f3f4,
]

value_type = [
	0b11,
	0b11,
	0b11,	
	0b01,   #sop
	0b00,
	0b00,
	0b00,
	0b00,
	0b10
]


class mem(Module):
	def __init__(self):

		self.index=Signal(5)
		self.data_out=Signal(32)
		self.type_out=Signal(2)

		
		table1 = Memory(32, len(value_input), init = Array(value_input), name="INPUT") 
		self.specials += table1

		wrport1 = table1.get_port(write_capable=False, mode=READ_FIRST) 
		self.specials += wrport1

		table2 = Memory(2, len(value_type), init = Array(value_type), name="TYPE") 
		self.specials += table2

		wrport2 = table2.get_port(write_capable=False, mode=READ_FIRST) 
		self.specials += wrport2

		self.comb += [
			wrport1.adr.eq(self.index),
			wrport2.adr.eq(self.index),
			self.data_out.eq(wrport1.dat_r),
			self.type_out.eq(wrport2.dat_r)
			#index.eq(index + 1)
		]	

print(len(value_input))
print(len(value_type))	
def tb(dut):
	
	for i in range(40):
		yield
		yield dut.index.eq(i)
dut=mem()
run_simulation(dut,tb(dut),vcd_name="prueba_mem.vcd")

