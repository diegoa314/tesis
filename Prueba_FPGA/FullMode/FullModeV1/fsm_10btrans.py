from migen import *

class Fsm_10btrans(Module):
	def  __init__(self):
		self.tx_10bdone=Signal() #entradas
		self.tx_ready=Signal()
		#salidas
		self.prbs_en=Signal()
		self.encoder_ready=Signal()
		self.encoder_en=Signal()
		self.change_disp=Signal()
		self.tx_en=Signal()
		#  #  #
		
		self.submodules.fsm=FSM(reset_state="IDLE")
		self.fsm.act("IDLE",
			If((self.tx_ready & ~self.tx_10bdone),
				NextState("GENERATING"),
				NextValue(self.prbs_en,1),
				NextValue(self.change_disp,1)
				
			)
		)
		self.fsm.act("GENERATING",
			NextState("ENCODING"),
			NextValue(self.prbs_en,0),
			NextValue(self.encoder_en,1),
			NextValue(self.change_disp,0)
			
		)
		self.fsm.act("ENCODING",
			NextState("SENDING"),
			NextValue(self.encoder_ready,1),
			NextValue(self.encoder_en,0),
			NextValue(self.tx_en,1),
		)
		self.fsm.act("SENDING",
			NextValue(self.tx_en,1),
			If(self.tx_10bdone,
				NextState("IDLE"),
				NextValue(self.tx_en,0)
			)
			
		)
