from migen import *
#funcion para calcular la tabla de decodificacion
def disparity (word, nbits):
    n0=0
    n1=0
    for i in range(nbits):
        if word & (1<<i):
            n1+=1
        else:
            n0+=1
    return n1-n0
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
class Decoder(Module):
    def __init__(self, lsb_first=False):
        self.decoder_input=Signal(10)
        self.decoder_output=Signal(8)
        self.decoder_k=Signal()
        #  #  # 
        input_final=Signal(10)
        if lsb_first:
            for i in range(10):
                self.comb+= input_final[i].eq(self.decoder_input[9-i])
        else:
            self.comb+=input_final.eq(self.decoder_input)
        code5b=Signal(5)
        code6b=input_final[4:]
        code3b=Signal(3)
        code4b=input_final[:4]
        self.sync+=[
            self.decoder_k.eq(0),
            If(code6b==0b001111,
                self.decoder_k.eq(1),
                code3b.eq(Array(table_kn_4b3b)[code4b])
            ).Elif(code6b==0b110000,
                self.decoder_k.eq(1),
                code3b.eq(Array(table_kp_4b3b)[code4b])
            ).Else(
                If((code4b==0b0111) | (code4b==0b1000),
                     If((code6b != 0b100011) & ##
                       (code6b != 0b010011) &
                       (code6b != 0b001011) &
                       (code6b != 0b110100) &
                       (code6b != 0b101100) &
                       (code6b != 0b011100), self.decoder_k.eq(1))
                ),
                code3b.eq(Array(table_4b3b)[code4b])
            ),
            code5b.eq(Array(table_6b5b)[code6b])
        ]
        self.comb+=self.decoder_output.eq(Cat(code5b,code3b))
