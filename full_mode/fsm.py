from migen import *
class Fsm(Module):
	def __init__(self):
		#Entradas
		self.link_ready=Signal() #avisa si el usuario solicita la transmision
		self.fifo_empty=Signal() #avisa si el fifo esta vacio
		self.data_type=Signal(2) #tipo de dato
		self.sop=Signal()
		self.eop=Signal()
		self.idle=Signal()
		#Salidas
		self.fifo_ready=Signal()
		self.encoder_ready=Signal() #avisa cuando se ha codificado correctamente la palabra
		self.change_disp=Signal() #habilita el cambio de disparidad
		self.fifo_re=Signal(1) #habilitador de lectura del fifo
		
		self.submodules.fsm=FSM(reset_state="INIT")
		
		
		self.fsm.act("INIT",
			If((self.link_ready),
				NextState("IDLE"),
				NextValue(self.fifo_re,1), #se habilita la lectura
				NextValue(self.change_disp,1)
			).Else(NextState("INIT")),
			
		)

		self.fsm.act("IDLE",
			If(~self.fifo_empty,
				NextState("SOP"),
				NextValue(self.fifo_re,1), #se habilita la lectura
				NextValue(self.sop,1)
			).Else(
				self.idle.eq(1),
				NextValue(self.encoder_ready,1)
			)
		)

		self.fsm.act("SOP", #se codifica el sop y se lee el primer dato
			NextState("READ_AND_CODE"),
			NextValue(self.encoder_ready,1),
			NextValue(self.fifo_ready,1),
			NextValue(self.fifo_re,1),
			NextValue(self.sop,0)
		)	
		
		self.fsm.act("READ_AND_CODE",
			NextValue(self.encoder_ready,1),
			NextValue(self.fifo_ready,1),
			If(self.fifo_empty,
				NextState("INIT")
			).Else(NextValue(self.fifo_re,1)),
			If(self.data_type==2,
				NextValue(self.eop,1),
				NextValue(self.fifo_re,0),
				NextState("EOP")
			)
		)	

		self.fsm.act("EOP",
			NextState("IDLE"),
			NextValue(self.eop,0)
		)
		
		"""
		self.fsm.act("READING",
			NextValue(self.fifo_re,0),
			NextState("ENCODING"),
			self.idle.eq(1),
			self.encoder_ready.eq(1)
		)	
		self.fsm.act("ENCODING",
			self.idle.eq(1),
			self.encoder_ready.eq(1),
			NextState("SENDING"),
			NextValue(self.encoder_ready,1),
			If((self.data_type==1)&(~bandera),
				self.sop.eq(1),
				
			),
			If((self.data_type==2)&(bandera),
				self.eop.eq(1),
				
			),
			NextValue(self.encoder_ready,1),
			NextValue(self.change_disp,0)
			
		)
		self.fsm.act("SENDING",
			NextValue(self.change_disp,1),
			NextState("IDLE"),
			If(((self.data_type==1) | (self.data_type==2))&~bandera,
				NextValue(bandera,1),
				NextState("ENCODING"),

			),
			If(bandera,
				NextState("IDLE"),
				NextValue(bandera,0)
			),
			NextValue(self.change_disp,1),
			NextValue(self.encoder_ready,1),
			If((self.data_type==1)&~bandera,self.sop.eq(1)),
			If((self.data_type==2)&bandera,self.eop.eq(1))

			
			
		)
		"""