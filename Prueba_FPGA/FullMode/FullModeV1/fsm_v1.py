#Modulo FSM del modulo top
#Controla las transiciones de los estados de generacion del byte,
#codificacion del mismo y posterior envio de la palabra codificada
from migen import *
class Fsm_v1(Module):
	def  __init__(self):
		#entradas
		self.tx_10bdone=Signal() #avisa cuando se han enviado los 2 bytes 
		self.trans_en=Signal() #avisa cuando el modulo top habilita la transmision
		#salidas
		self.prbs_en=Signal() #habilita la generacion del byte
		self.encoder_ready=Signal() #avisa cuando se ha codificado correctamente la palabra
		self.change_disp=Signal() #habilita el cambio de disparidad
		self.tx_en=Signal() #habilita el modulo transmisor
		#  #  #
		self.submodules.fsm=FSM(reset_state="IDLE")
		self.fsm.act("IDLE",
			If((self.trans_en & ~self.tx_10bdone),
				NextState("GENERATING"),
				NextValue(self.prbs_en,1),
				#la disparidad de entrada debe ser asignada correctamente
				#antes del proceso de codificacion
				NextValue(self.change_disp,1) 
			)
		)
		self.fsm.act("GENERATING",
			NextState("ENCODING"),
			NextValue(self.prbs_en,0),
			#ya se ha asignado correctamente la disparidad
			NextValue(self.change_disp,0)
			
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
				NextValue(self.tx_en,0)
			)
			
		)
