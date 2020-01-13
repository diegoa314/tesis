from migen import *
class Fsm_v2(Module):
	def  __init__(self):
		#entradas
		self.tx_10bdone=Signal() #avisa cuando se han enviado los 2 bytes 
		self.trans_en=Signal() #avisa cuando el modulo top habilita la transmision
		self.fifo_empty=Signal() #avisa si el fifo esta vacio
		self.fifo_full=Signal() #avisa si el fifo esta lleno
		#salidas
		self.prbs_en=Signal() #habilita la generacion del byte
		self.encoder_ready=Signal() #avisa cuando se ha codificado correctamente la palabra
		self.change_disp=Signal() #habilita el cambio de disparidad
		self.tx_en=Signal() #habilita el modulo transmisor
		self.fifo_we=Signal(1) #habilitador de escritura del fifo
		self.fifo_re=Signal(1) #habilitador de lectura del fifo
		#  #  #
		#Contador para la cantidad de datos generado por el prbs 
		#que se escribiran en el fifo cuando este este vacio
		write_cnt=Signal(3) 
		self.submodules.fsm=FSM(reset_state="IDLE")
		self.fsm.act("IDLE",
			If((self.trans_en & ~self.tx_10bdone & ~self.fifo_empty),
				NextState("READING"),
				NextValue(self.fifo_re,1),
				#la disparidad de entrada debe ser asignada correctamente
				#antes del proceso de codificacion
				#NextValue(self.change_disp,1),
			).Elif((self.trans_en & ~self.tx_10bdone & self.fifo_empty),
				NextState("GENERATING"),
				NextValue(self.prbs_en,1),
			),
			NextValue(self.change_disp,0)

		)
		self.fsm.act("GENERATING",
			NextValue(self.prbs_en,0),
			NextValue(self.fifo_we,1),
			NextState("WRITING")
		)
		self.fsm.act("WRITING",
			NextValue(write_cnt,write_cnt+1),
			If(write_cnt<6 ,
				NextState("GENERATING"),
				NextValue(self.fifo_we,0),
				NextValue(self.prbs_en,1)
				
			),
			If(write_cnt==5,
					NextValue(self.fifo_we,0),
					NextValue(self.prbs_en,0),
					NextValue(write_cnt,0),
					NextState("READING"),
					#la disparidad de entrada debe ser asignada correctamente
					#antes del proceso de codificacion
					#NextValue(self.change_disp,1)
				)
		)
		self.fsm.act("READING",
			NextValue(self.fifo_re,0),
			#ya se ha asignado correctamente la disparidad
			#NextValue(self.change_disp,0),
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
			If(self.tx_10bdone,
				NextState("IDLE"),
				NextValue(self.tx_en,0),
				NextValue(self.change_disp,1)

			)
			
		)