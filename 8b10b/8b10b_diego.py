from migen import *
#funcion para calcular la disparidad
def disparity (word, nbits):
	n0=0
	n1=0
	for i in range(nbits):
		if word & (1<<i):
			n1+=1
		else:
			n0+=1
	return n1-n0
#funcion para calcular la tabla de decodificacion
def reverse_table_flip(words, flips, n):
	output=[None]*2**n
	for i, (word,flip) in enumerate(zip(words,flips)):
		if output[word] is not None:
			raise ValueError
		output[word]=i
		if flip:
			word=(2**n-1)-word
			if output[word] is not None:
				raise ValueError
			output[word]=i

	for i in range(len(output)):
		if output[i] is None:
			output[i]=0

	return output

#funcion de inversion de tabla para decodificacion de caracteres especiales
def reverse_table(words, n):
	output=[None]*2**n
	for i, word in enumerate(words):
		if output[word] is not None:
			raise ValueError
		output[word]=i
		
	for i in range(len(output)):
		if output[i] is None:
			output[i]=0

	return output


#tablas de codificacion
table_5b6b = [ #words con disparidad -2 o 0
    0b011000,
    0b100010,
    0b010010,
    0b110001,
    0b001010,
    0b101001,
    0b011001,
    0b000111,
    0b000110,
    0b100101,
    0b010101,
    0b110100,
    0b001101,
    0b101100,
    0b011100,
    0b101000,
    0b100100,
    0b100011,
    0b010011,
    0b110010,
    0b001011,
    0b101010,
    0b011010,
    0b000101,
    0b001100,
    0b100110,
    0b010110,
    0b001001,
    0b001110,
    0b010001,
    0b100001,
    0b010100,
]
#tabla que indica si hay disparidad o no en table_5b6b
table_5b6b_unbalanced=[bool(disparity(x,6)) for x in table_5b6b]
#Para el caso donde 6b puede ser 111000 o 000111
table_5b6b_unbalanced[7]=True;
#tabla de decodificacion
table_6b5b=reverse_table_flip(table_5b6b, table_5b6b_unbalanced, 6)
#k.28
table_6b5b[0b001111]=0b11100
table_6b5b[0b111100]=0b11100


table_3b4b = [ #words con disparidad -2 o 0
    0b0100,
    0b1001,
    0b0101,
    0b0011,
    0b0010,
    0b1010,
    0b0110,
    0b0001,  # D.x.7 por defecto o primario
]

table_3b4b_unbalanced=[bool(disparity(x,4)) for x in table_3b4b]
table_4b3b=reverse_table_flip(table_3b4b, table_3b4b_unbalanced, 4)
#D.x.A7
table_4b3b[0b0111]=0b111
table_4b3b[0b1000]=0b111

#tablas para 4b3b cuando se tiene caracter especial para RD=-1 y RD=+1 respectivamente
table_kn_4b3b=reverse_table(table_3b4b,4)
table_kp_4b3b=reverse_table([~x & 0b1111 for x in table_3b4b],4)
#D.x.7
table_kn_4b3b[0b1000] = 0b111
table_kp_4b3b[0b0111] = 0b111

class SingleEncoder(Module):
	def __init__(self,lsb_first=False):
		self.data_in=Signal(8) #senal de entrada
		self.disp_in=Signal() #disparidad de entrada o anterior, 0 para RD=-1 y 1 para RD=+1
		self.k=Signal() #caracter especial

		self.output=Signal(10) #senal de salida
		self.disp_out=Signal() #disparidad de salida

		#codificacion 5b/6b y 3b/4b
		code5b=self.data_in[:5]		
		code6b=Signal(6)
		code6b_unbalanced=Signal() #indica si no se tiene misma cantidad de ceros y unos
		self.sync+=[
			If(self.k & (code5b==28),
				code6b.eq(0b110000), #codificacion para k.28 con RD=+1
				code6b_unbalanced.eq(1)
			).Else(
				code6b.eq(Array(table_5b6b)[code5b]),
				code6b_unbalanced.eq(Array(table_5b6b_unbalanced)[code5b])
			)
		]

		code3b=self.data_in[5:]
		code4b=Signal(4)
		code4b_unbalanced=Signal()
		self.sync+=[
			code4b.eq(Array(table_3b4b)[code3b]),
			code4b_unbalanced.eq(Array(table_3b4b_unbalanced)[code3b])
		]

		#cuando code3b==7 se tienen dos caminos, dependiendo de code5b
		alt7_rd0=Signal() #disparidad -1
		alt7_rd1=Signal() #disparidad +1
		self.sync+=[
			alt7_rd0.eq(0),
			alt7_rd1.eq(0),
			If(code4b==7,	
				If((code5b==17) | (code5b==18) | (code5b==20),
					alt7_rd0.eq(1)
				),
				If((code5b==11) | (code5b==13) | (code5b==14),
					alt7_rd1.eq(1)
				)
			)
		]
			#control de disparidad
		#etapa 5b6b
		output_6b=Signal(6) #salida final de la codificacion 5b6b
		flip_6b=Signal() #1 si se debe invertir la palabra
		disp_in_3b4b=Signal() #disparidad de entrada a la etapa de 3b4b, 0 para RD=-1 y 1 para RD=+1
		self.comb+= [
			disp_in_3b4b.eq(self.disp_in ^ code6b_unbalanced ),
			flip_6b.eq(~self.disp_in & code6b_unbalanced),
			If(flip_6b,
				output_6b.eq(~code6b)
			).Else(
				output_6b.eq(code6b)
			)
		]
		#etapa 3b4b
		output_4b=Signal(4)
		flip_4b=Signal() #si se debe invertir la palabra
		self.comb+= [
			If(~disp_in_3b4b & alt7_rd0,
				output_4b.eq(0b0111),
				self.disp_out.eq(~disp_in_3b4b)
			).Elif(disp_in_3b4b & alt7_rd1,
				output_4b.eq(0b1000),
				self.disp_out.eq(~disp_in_3b4b)
			).Else(
				flip_4b.eq(~disp_in_3b4b & code4b_unbalanced),
				self.disp_out.eq(disp_in_3b4b ^ code4b_unbalanced),
				If(flip_4b,
					output_4b.eq(~code4b)
				).Else(
					output_4b.eq(code4b)
				)
			)
		]
		output_msb_first=Signal(10)
		self.comb+=output_msb_first.eq(Cat(output_4b,output_6b))
		if lsb_first:
			for i in range(10):
				self.comb+=self.output[i].eq(output_msb_first[9-i])
		else:
			self.comb+=self.output.eq(output_msb_first)

class Encoder(Module):
	def __init__(self,nwords=1,lsb_first=False):
		self.datas_in=[Signal(8) for _ in range(nwords)]
		self.ks=[Signal() for _ in range(nwords)]
		self.outputs=[Signal(10) for _ in range(nwords)]
		self.disparity=[Signal() for _ in range(nwords)]
		
		# # #

		#Se generan nwords encoders y se agrega como submodulo
		encoders=[SingleEncoder(lsb_first) for _ in range(nwords)]
		self.submodules+=encoders
		#se inicializa la disparidad de entrada del primer encoder con la disparidad de salida del ultimo	
		self.sync+=encoders[0].disp_in.eq(encoders[-1].disp_out) 
		for e1,e2 in zip(encoders,encoders[1:]):
			#la salidad de disparidad de cada encoder con la entrada de disparidad del siguiente
			self.comb+=e2.disp_in.eq(e1.disp_out)
		for data_in, k, output, encoder, disparity in \
				zip(self.datas_in,self.ks, self.outputs,encoders,self.disparity):
			self.comb+=[
				encoder.data_in.eq(data_in),
				encoder.k.eq(k)
			]
			self.sync+=[
				output.eq(encoder.output),
				disparity.eq(encoder.disp_out)
			]

class Decoder(Module):
	def __init__(self, lsb_first=False):
		self.input=Signal(10)
		self.d=Signal(8)
		self.k=Signal()
		#  #  #	
		input_final=Signal(10)
		if lsb_first:
			for i in range(10):
				self.comb+= input_final[i].eq(self.input[9-i])
		else:
			self.comb+=input_final.eq(self.input)
		code5b=Signal(5)
		code6b=input_final[4:]
		code3b=Signal(3)
		code4b=input_final[:4]
		self.sync+=[
			self.k.eq(0),
			If(code6b==0b001111,
				self.k.eq(1),
				code3b.eq(Array(table_kn_4b3b)[code4b])
			).Elif(code6b==0b110000,
				self.k.eq(1),
				code3b.eq(Array(table_kp_4b3b)[code4b])
			).Else(
				If((code4b==0b0111) | (code4b==0b1000),
					 If((code6b != 0b100011) & ##
                       (code6b != 0b010011) &
                       (code6b != 0b001011) &
                       (code6b != 0b110100) &
                       (code6b != 0b101100) &
                       (code6b != 0b011100), self.k.eq(1))
				),
				code3b.eq(Array(table_4b3b)[code4b])
			),
			code5b.eq(Array(table_6b5b)[code6b])
		]
		self.comb+=self.d.eq(Cat(code5b,code3b))



#testbench
bits=[0b10101100, 0b10001110, 0b10011110, 
0b00011100, 0b11100011, 0b10101010, 0b11001101,
0b11100000, 0b01101101, 0b00000000 ]

bit10b=0b0101001001 

n=len(bits)
def decoder_tb(dut):
	yield dut.input.eq(bit10b)
	for i in range(2):
		yield

dut=Decoder()
run_simulation(dut, decoder_tb(dut), vcd_name="8b10b_tb.vcd")
