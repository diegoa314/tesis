#Modulo encargado de controlar las transiciones de estado para el envio de 
#una palabra de 10 bits dividiendola en 2 bytes utilizando un modulo tx
from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Tesis/UART')
from tx import *
class Transmitter10b(Module):
	def __init__(self):
		self.data_in=Signal(10) #los 10 bits a enviar
		self.trans_en=Signal() #habilitador para el envio
		self.tx_serial=Signal() #senhal serial de salida
		self.tx_10bdone=Signal() #se activa cuando se han enviado los dos bytes
		#  #  #
		self.submodules.trans_fsm=FSM(reset_state="IDLE")
		#ATENCIOOOOOONNNNNN CON LA FRECUENCIA
		#En las simulaciones trabajar a la misma frecuencia del hardware para detectar errores
		transmitter=tx(freq=12000000, baud_rate=9600, n_bits=8)
		#transmitter=tx(freq=22000, baud_rate=9600, n_bits=8)
		self.submodules+=transmitter
		self.comb+=self.tx_serial.eq(transmitter.tx_serial)
		self.trans_fsm.act("IDLE",
			If((self.trans_en & ~transmitter.tx_done),
				NextState("FIRSTBYTE"),
				#Se acitva el modulo tx y se envian los primeros 5 bits menos significativos
				NextValue(transmitter.tx_ready,1),
				NextValue(transmitter.tx_data,self.data_in[0:5])
			).Else(NextState("IDLE"),
				NextValue(transmitter.tx_ready,0)
			),
			NextValue(self.tx_10bdone,0)
		)
		#Envio del primer byte
		self.trans_fsm.act("FIRSTBYTE",
			If(transmitter.tx_done,
				NextState("WAITING"),
				#Se cargan los demas bits
				NextValue(transmitter.tx_ready,1),
				NextValue(transmitter.tx_data,self.data_in[5:10])
			)
		)
		#Se espera que el transmisor termine de resetear su senhal tx_done
		self.trans_fsm.act("WAITING",
			If(~transmitter.tx_done,
				NextState("SECONDBYTE")
			)
		)
		#Envio del ultimo byte
		self.trans_fsm.act("SECONDBYTE",
			If(transmitter.tx_done,
				NextState("IDLE"),
				NextValue(self.tx_10bdone,1),
				NextValue(transmitter.tx_ready,0)
			)
		)
		