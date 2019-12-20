from migen import *
from transmitter_8b10b import *
from receiver_8b10b import *
from fsm import *
class full(Module):
	def __init__(self):
		self.input=Signal(8)
		self.output=Signal(8)
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
			transmitter.transmitter_input.eq(self.input),
			transmitter.transmitter_fifo_re.eq(fsm.fifo_re),
			transmitter.transmitter_fifo_we.eq(self.fifo_we),
			transmitter.transmitter_tx_ready.eq(fsm.tx_ready),
			fsm.tx_done.eq(transmitter.transmitter_tx_done),

			receiver.receiver_serial.eq(transmitter.transmitter_output),
			receiver.receiver_read_enable.eq(self.receiver_en),
			self.output.eq(receiver.receiver_output)

		]
