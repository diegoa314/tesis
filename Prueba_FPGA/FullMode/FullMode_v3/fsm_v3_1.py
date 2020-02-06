#FSM para la escritura de datos y tipo de datos leidos de una memoria en un FIFO, 
#lectura y decodificacion de los datos y envio de los mismos y sus tipos
from migen import *
class Fsm_v3_1(Module):
	def  __init__(self):
		#entradas
		self.tx_done=Signal() #avisa cuando se han enviado los bytes 
		self.trans_en=Signal() #avisa cuando el modulo top habilita la transmision
		self.write_en=Signal() #avisa cuando el modulo top habilita la escritura
		self.fifo_empty=Signal() #avisa si el fifo esta vacio
		self.fifo_full=Signal() #avisa si el fifo esta lleno
		#salidas
		self.read_next=Signal() #aumenta el indice de la palabra leida de la memoria
		self.encoder_ready=Signal() #avisa cuando se ha codificado correctamente la palabra
		self.change_disp=Signal() #habilita el cambio de disparidad
		self.tx_en=Signal() #habilita el modulo transmisor
		self.fifo_we=Signal(1) #habilitador de escritura del fifo
		self.fifo_re=Signal(1) #habilitador de lectura del fifo
		self.dtype_ready=Signal(1) #habilitador para el envio del tipo de dato
		#  #  #
		self.submodules.fsm=FSM(reset_state="IDLE")
		self.fsm.act("IDLE",
			If((self.trans_en & ~self.tx_done & ~self.fifo_empty),
				NextState("READING"),
				NextValue(self.fifo_re,1),
				#la disparidad de entrada debe ser asignada correctamente
				#antes del proceso de codificacion
				#NextValue(self.change_disp,1),
			).Elif((self.write_en & ~self.tx_done & ~self.fifo_full),
				NextState("READING_FROM_MEM"),
				NextValue(self.read_next,1)				
			),
			NextValue(self.change_disp,0)
			
		)
		self.fsm.act("READING_FROM_MEM",
			If(~self.fifo_full,	
				NextValue(self.fifo_we,1),
				NextState("WRITING"),
				NextValue(self.read_next,0)
			).Else(NextState("IDLE"))
		)
		self.fsm.act("WRITING",
			NextValue(self.fifo_we,0),
			If(self.trans_en,
				NextState("READING"),
				NextValue(self.fifo_re,1)
			).Else(NextState("IDLE"))
		)			
		
		self.fsm.act("READING",
			NextValue(self.fifo_re,0),
			NextState("ENCODING") 
		)
		self.fsm.act("ENCODING",
			NextState("SENDING"),
			NextValue(self.encoder_ready,1),
			#se habilita el transmisor
			NextValue(self.tx_en,1),
		)
		self.fsm.act("SENDING",
			NextValue(self.tx_en,1),
			If(self.tx_done,
				NextState("IDLE"),
				NextValue(self.tx_en,0),
				NextValue(self.change_disp,1)
			)
		)