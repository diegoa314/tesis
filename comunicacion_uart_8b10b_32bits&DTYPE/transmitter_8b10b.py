import sys
sys.path.append('/root/Tesis/modulo_prueba2/tesis/UART')
from tx import *
sys.path.append('/root/Tesis/modulo_prueba2/tesis/8b10b')
from encoder import *
sys.path.append('/root/Tesis/modulo_prueba2/tesis/FIFO')
#from fifo2 import *
from fifoDT import * 

class Transmitter(Module):
	def __init__(self, freq=10000, baud_rate=1000):
		self.transmitter_input=Signal(32) #fifo input ################################################
		self.transmitter_intype=Signal(2) ################################### senhal clasificadora
		self.transmitter_tx_ready=Signal(1) #habilitador del rx
		self.transmitter_output=Signal(1)
		self.transmitter_fifo_we=Signal(1) #habilitador de escritura del fifo
		self.transmitter_fifo_re=Signal(1) #habilitador de lectura del fifo
		self.transmitter_tx_done=Signal(1) #finalizacion de transmision
 		#  #  #
		#counter_trans=Signal(3) #contador para el retardo en el habilitador del tx
		counter_disp=Signal(2) #contador para el retardo en la asignacion de disparidad del encoder
		encoder1=SingleEncoder()
		encoder2=SingleEncoder()
		encoder3=SingleEncoder()
		encoder4=SingleEncoder()
		transmitter_tx=tx(freq=freq,baud_rate=baud_rate, n_bits=42)
		fifo=SyncFIFOBuffered(width=32, depth=32)
		self.submodules+=[encoder1,encoder2,encoder3,encoder3,transmitter_tx,fifo]
		change=Signal()
		delay=Signal() 
		self.comb+=[
			fifo.din.eq(self.transmitter_input),   #
			fifo.dtin.eq(self.transmitter_intype), ############################################
			fifo.we.eq(self.transmitter_fifo_we),
			fifo.re.eq(self.transmitter_fifo_re),
			self.transmitter_tx_done.eq(transmitter_tx.tx_done),
			transmitter_tx.tx_ready.eq(self.transmitter_tx_ready),
			self.transmitter_output.eq(transmitter_tx.tx_serial),

		]
		self.sync+=[
			encoder1.data_in.eq(fifo.dout[0:7]),
			encoder2.data_in.eq(fifo.dout[8:15]),
			encoder3.data_in.eq(fifo.dout[16:23]),
			encoder4.data_in.eq(fifo.dout[24:32]),
			encoder1.k.eq(0),
			encoder2.k.eq(0),
			encoder3.k.eq(0),
			encoder4.k.eq(0),
			transmitter_tx.tx_data[0:9].eq(encoder1.output),
			transmitter_tx.tx_data[10:19].eq(encoder2.output),
			transmitter_tx.tx_data[20:29].eq(encoder3.output),
			transmitter_tx.tx_data[30:39].eq(encoder4.output),
			transmitter_tx.tx_data[40:41].eq(fifo.dtout),
			If((transmitter_tx.tx_done) & (counter_disp<0b10),
				counter_disp.eq(counter_disp+1)
			),
			If(counter_disp==0b10,
				encoder1.disp_in.eq(encoder1.disp_out),
				encoder2.disp_in.eq(encoder2.disp_out),
				encoder3.disp_in.eq(encoder3.disp_out),
				encoder4.disp_in.eq(encoder4.disp_out),
				counter_disp.eq(counter_disp+1)
			),
			If(~transmitter_tx.tx_done,
				counter_disp.eq(0)
			)
		]	

