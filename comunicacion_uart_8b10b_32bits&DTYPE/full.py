from migen import *
from transmitter_8b10b import *
from receiver_8b10b import *
from fsm import *
class full(Module):
	def __init__(self):
		self.input=Signal(32) # senhal de entrada de 4 bytes ##################################
		self.intype=Signal(2)#####################################senhal de clasificacion de palabras 
		self.output=Signal(32)  # Senhal de salida ##############################################
		#self.otype=Signal(2)######################################
		self.fifo_we=Signal()  
		self.re=Signal()
		self.receiver_en=Signal()
		#	#	#
		transmitter=Transmitter()
		receiver=Receiver()
		fsm=fsm_transmitter()
		receiver=Receiver()
		self.submodules+=[transmitter,fsm,receiver]
		self.comb+=[
			fsm.re.eq(self.re),
			transmitter.transmitter_input.eq(self.input),   # senhal de entrada al modulo
			transmitter.transmitter_intype.eq(self.intype), ############################################ senhal de entrada al modulo
			transmitter.transmitter_fifo_re.eq(fsm.fifo_re), # senhal de habilitador de lectura del fifo (salida del fsm)
			transmitter.transmitter_fifo_we.eq(self.fifo_we), # senhal de habilitador de escritura del fifo 
			transmitter.transmitter_tx_ready.eq(fsm.tx_ready), # senhal de habilitacion de transmicion (salida del fsm)
			fsm.tx_done.eq(transmitter.transmitter_tx_done), # senhal de transmicion completa (entrada al fsm)

			#receiver.receiver_input.eq(transmitter.transmitter_)
			receiver.receiver_serial.eq(transmitter.transmitter_output), 
			receiver.receiver_read_enable.eq(self.receiver_en),
			self.output.eq(receiver.receiver_output)
			#self.otype.eq(receiver.receiver_otype) ########################################################33

		]
