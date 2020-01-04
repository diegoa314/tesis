import sys
sys.path.append('/home/diegoaranda/Documents/Tesis/UART')
from tx import *
sys.path.append('/home/diegoaranda/Documents/Tesis/8b10b')
from encoder import *
sys.path.append('/home/diegoaranda/Documents/Tesis/FIFO')
from fifo2 import *
import cmoda7
from migen.build.generic_platform import *

class Transmitter(Module):
	def __init__(self, platform, freq=120000, baud_rate=9600):
		self.transmitter_input=Signal(8) #fifo input
		self.transmitter_tx_ready=Signal(1) #habilitador del rx
		#self.transmitter_output=Signal(1)
		self.transmitter_output=platform.request("serial").tx
		self.transmitter_fifo_we=Signal(1) #habilitador de escritura del fifo
		self.transmitter_fifo_re=Signal(1) #habilitador de lectura del fifo
		self.transmitter_tx_done=Signal(1) #finalizacion de transmision
 		#  #  #
		#counter_trans=Signal(3) #contador para el retardo en el habilitador del tx
		counter_disp=Signal(2) #contador para el retardo en la asignacion de disparidad del encoder
		encoder=SingleEncoder()
		transmitter_tx=tx(freq=freq,baud_rate=baud_rate, n_bits=10)
		fifo=SyncFIFOBuffered(width=8, depth=32)
		self.submodules+=[encoder,transmitter_tx,fifo]
		change=Signal()
		delay=Signal() 
		self.comb+=[
			fifo.din.eq(self.transmitter_input),
			fifo.we.eq(self.transmitter_fifo_we),
			fifo.re.eq(self.transmitter_fifo_re),
			self.transmitter_tx_done.eq(transmitter_tx.tx_done),
			transmitter_tx.tx_ready.eq(self.transmitter_tx_ready),
			self.transmitter_output.eq(transmitter_tx.tx_serial),

		]
		self.sync+=[
			encoder.data_in.eq(fifo.dout),
			encoder.k.eq(0),
			transmitter_tx.tx_data.eq(encoder.output),
			If((transmitter_tx.tx_done) & (counter_disp<0b10),
				counter_disp.eq(counter_disp+1)
			),
			If(counter_disp==0b10,
				encoder.disp_in.eq(encoder.disp_out),
				counter_disp.eq(counter_disp+1)
			),
			If(~transmitter_tx.tx_done,
				counter_disp.eq(0)
			)
		]	

plat=cmoda7.Platform()
dut=Transmitter(plat)
plat.build(dut)

