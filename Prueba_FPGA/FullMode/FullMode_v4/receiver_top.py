from migen import *
from migen.fhdl import verilog
from Transmitter40b2 import Transmitter40b
#from fifoDT import *
from migen.genlib.fifo import *

class Receiver_top(Module):
	def __init__(self):
		self.writable = writable = Signal()
		self.readable = readable = Signal()
		self.din = din = Signal(40)
		#self.dtin = dtin = Signal(2)
		#self.we = we = Signal()
		self.tx_40done = Signal()
		self.tx_init_done = tx_init_done = Signal()
		self.pll_lock = pll_lock = Signal()
		#self.re = re = Signal()
		##########3
		self.trans_en = trans_en = Signal() #habilitador para el envio
		self.tx_serial= tx_serial = Signal() #senhal serial de salida
		#self.tx_40bdone=Signal() #se activa cuando se han enviado los dos bytes
		tx_transmitter = Transmitter40b()
		fifo = SyncFIFOBuffered(40,10)
		self.submodules+=[tx_transmitter, fifo]
		self.comb+=[
			writable.eq(fifo.writable),
			readable.eq(fifo.readable),
			fifo.din.eq(din),
			fifo.re.eq(tx_transmitter.re),
			tx_transmitter.data_in.eq(fifo.dout),
			tx_serial.eq(tx_transmitter.tx_serial),
			tx_transmitter.trans_en.eq(trans_en),
			tx_transmitter.fifoEmpty.eq(~fifo.readable),
			#stateM.trans_en.eq(trans_en),
			self.tx_40done.eq(tx_transmitter.tx_40bdone)
		]

		self.submodules.fsm=FSM(reset_state="INIT")

		self.fsm.act("INIT",
			If((tx_init_done & pll_lock),
				NextState("WAITING_SOP")
			)
		)

		self.fsm.act("WAITING_SOP",
			If(((din[:10]==0b1100000110) | (din[:10]==0b0011111001)), #BC 
				fifo.we.eq(1),
				NextState("WAITING_EOP")
			)
		)

		self.fsm.act("WAITING_EOP",
			fifo.we.eq(1),
			If(((din[:10]==0b0011110110) | (din[:10]==0b1100001001 )), #DC 
				NextState("WAITING_SOP")
			)

		)
