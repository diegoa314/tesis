from migen import *
from transmitter_8b10b import *
class fsm_transmitter(Module):
	def __init__(self):
		self.re=re=Signal() 
		self.tx_ready=tx_ready=Signal()
		self.fifo_re=fifo_re=Signal()
		self.tx_done=tx_done=Signal()
		self.fifo_empty=fifo_empty=Signal()
		#	#	#
		counter_tx_ready=Signal(2)
		self.sync+=[
			If(counter_tx_ready==0b11,
				counter_tx_ready.eq(0)
			)
		]
		self.submodules.fsm=FSM(reset_state="IDLE")
		self.fsm.act("IDLE",
			If(re,
				NextValue(fifo_re,1),
				NextState("READ_START")			
			).Elif(fifo_empty,
				NextState("FIFO_EMPTY")
			)
		)
		self.fsm.act("READ_START",
			NextState("READ_DELAY"),
			If(fifo_empty,
				NextState("FIFO_EMPTY")
			).Elif(fifo_empty,
				NextState("FIFO_EMPTY")
			),
			NextValue(fifo_re,0),
		)
		self.fsm.act("READ_DELAY",
			NextValue(counter_tx_ready,counter_tx_ready+1),
			If(counter_tx_ready==0b11,
				NextValue(tx_ready,1),
				NextState("WAITING")
			)
		)
		self.fsm.act("WAITING",
			NextValue(tx_ready,0),
			If(tx_done,
				NextState("IDLE")
			)
		)
		self.fsm.act("FIFO_EMPTY",
			If(~fifo_empty,
				NextState("IDLE")
			)
		)
