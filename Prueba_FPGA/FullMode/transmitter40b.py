#Modulo encargado de controlar las transiciones de estado para el envio de 
#una palabra de 40 bits dividiendola en 8 bytes (2 bytes por cada 10 bits)
#utilizando un modulo tx
from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Tesis/tesis/UART')
from tx_uart import *
class Transmitter40b(Module):
	def __init__(self):
		self.data_in=Signal(40) #los 10 bits a enviar
		self.trans_en=Signal() #habilitador para el envio
		self.tx_serial=Signal() #senhal serial de salida
		self.tx_40bdone=Signal() #se activa cuando se han enviado los dos bytes
		#  #  #
		self.submodules.trans_fsm=FSM(reset_state="IDLE")
		#ATENCIOOOOOONNNNNN CON LA FRECUENCIA
		#En las simulaciones trabajar a la misma frecuencia del hardware para detectar errores
		#transmitter=tx(freq=12000000, baud_rate=4000000, n_bits=8)
		transmitter=tx(freq=22000, baud_rate=9600, n_bits=8)
		self.byte_cnt=Signal(4) #Contador de bytes enviados
		self.submodules+=transmitter
		self.comb+=self.tx_serial.eq(transmitter.tx_serial)
		self.trans_fsm.act("IDLE",
			If((self.trans_en & ~transmitter.tx_done),
				NextState("SENDING_BYTE"),
				#Se acitva el modulo tx y se envian los primeros 5 bits menos significativos
				NextValue(transmitter.tx_ready,1),
				NextValue(transmitter.tx_data,self.data_in[0:5])
			).Else(NextState("IDLE"),
				NextValue(transmitter.tx_ready,0)
			),
			NextValue(self.tx_40bdone,0)
		)
		
		self.trans_fsm.act("SENDING_BYTE",
			If(transmitter.tx_done,
				NextValue(self.byte_cnt,self.byte_cnt+1),
				If(self.byte_cnt<7, 
					NextValue(transmitter.tx_ready,1),
					NextState("WAITING")
				).Else(
					NextState("IDLE"),
					NextValue(self.tx_40bdone,1),
					NextValue(transmitter.tx_ready,0),
					NextValue(self.byte_cnt,0)
				)
			)
		)
		#Se espera que el transmisor termine de resetear su senhal tx_done
		self.trans_fsm.act("WAITING",
			Case(self.byte_cnt,{
					1:	NextValue(transmitter.tx_data,self.data_in[5:10]),
					2:	NextValue(transmitter.tx_data,self.data_in[10:15]),
					3:	NextValue(transmitter.tx_data,self.data_in[15:20]),
					4:	NextValue(transmitter.tx_data,self.data_in[20:25]),
					5:	NextValue(transmitter.tx_data,self.data_in[25:30]),
					6:	NextValue(transmitter.tx_data,self.data_in[30:35]),
					7:	NextValue(transmitter.tx_data,self.data_in[35:40])
				}),
			If(~transmitter.tx_done,
				NextState("SENDING_BYTE")
			)
		)
