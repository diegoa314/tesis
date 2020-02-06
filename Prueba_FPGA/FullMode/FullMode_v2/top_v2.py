from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Tesis/Prueba_FPGA')
import cmoda7
sys.path.append('/home/diegoaranda/Documents/Tesis/8b10b')
from encoder_comb import *
sys.path.append('/home/diegoaranda/Documents/Tesis/Prueba_FPGA/FullMode')
from transmitter10b import *
sys.path.append('/home/diegoaranda/Documents/Tesis/PRBS')
from prbs import *
sys.path.append('/home/diegoaranda/Documents/Tesis/FIFO')
from fifo2 import *
from fsm_v2 import *
class Top_v2(Module):
	def __init__(self,platform=0):
		#self.tx_output=platform.request("serial").tx #salida serila
		#self.trans_en=platform.request("user_btn") #habilitador general para el envio
		#Descomentar para simulacion
		self.tx_output=Signal() 
		self.trans_en=Signal()
		
		#  #  #
		fsm_v2=Fsm_v2() #FSM 
		encoder=Encoder() #encoder 8b/10b combinacional
		transmitter=Transmitter10b() #transmisor de 10b
		prbs=PRBSGenerator() #Generador PRBS
		fifo=SyncFIFOBuffered(width=8, depth=32)
		self.submodules+=[encoder,transmitter,prbs,fsm_v2,fifo]
		self.comb+=[
			#asignaciones de las senhales
			fsm_v2.tx_10bdone.eq(transmitter.tx_10bdone),
			fsm_v2.trans_en.eq(self.trans_en),
			fsm_v2.fifo_empty.eq(~fifo.readable),
			fsm_v2.fifo_full.eq(~fifo.writable),
			transmitter.trans_en.eq(fsm_v2.tx_en),
			prbs.enable.eq(fsm_v2.prbs_en),
			fifo.we.eq(fsm_v2.fifo_we),
			fifo.re.eq(fsm_v2.fifo_re),
			self.tx_output.eq(transmitter.tx_serial),
			fifo.din.eq(prbs.o),
			encoder.data_in.eq(fifo.dout),
			If(fsm_v2.encoder_ready,transmitter.data_in.eq(encoder.data_out)),
			#no se realizan el envio de caracteres especiales
			encoder.k.eq(0)
		]
		self.sync+=[ 
			#La asignacion de disparidad debe ser secuencial debido a la
			#dependecia mutua de ambas senhalas (disp_in y disp_out)
			If(fsm_v2.change_disp,encoder.disp_in.eq(encoder.disp_out))
				
		]	
plat=cmoda7.Platform()
dut=Top_v2(platform=plat)
plat.build(dut)
"""
def tb(dut):
	for i in range(50):
		yield
	yield dut.trans_en.eq(1)
	for i in range(80000):
		yield
dut=Top_v2()
run_simulation(dut,tb(dut),vcd_name="top_v2.vcd")
"""
