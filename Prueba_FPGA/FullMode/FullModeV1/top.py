#Modulo top que realiza la conexion entre los submodulos fsm_v1, encoder, transmitter10b
#y prbs.
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
from fsm_v1 import *
class Top(Module):
	def __init__(self, platform=0 ,freq=12000000, baud_rate=9600):
		#self.tx_output=platform.request("serial").tx #salida serila
		#self.trans_en=platform.request("user_btn") #habilitador general para el envio
		#Descomentar para simulacion
		self.tx_output=Signal() 
		self.trans_en=Signal() 
		#  #  #
		fsm_v1=Fsm_v1() #FSM 
		encoder=Encoder() #encoder 8b/10b combinacional
		transmitter=Transmitter10b() #transmisor de 10b
		prbs=PRBSGenerator() #Generador PRBS
		self.submodules+=[encoder,transmitter,prbs,fsm_v1]
		self.comb+=[
			#asignaciones de las senhales
			fsm_v1.tx_10bdone.eq(transmitter.tx_10bdone),
			fsm_v1.trans_en.eq(self.trans_en),
			transmitter.trans_en.eq(fsm_v1.tx_en),
			self.tx_output.eq(transmitter.tx_serial),
			prbs.enable.eq(fsm_v1.prbs_en),
			encoder.data_in.eq(prbs.o),
			If(fsm_v1.encoder_ready,transmitter.data_in.eq(encoder.data_out)),
			#no se realizan el envio de caracteres especiales
			encoder.k.eq(0)
		]
		self.sync+=[ 
			#La asignacion de disparidad debe ser secuencial debido a la
			#dependecia mutua de ambas senhalas (disp_in y disp_out)
			If(fsm_v1.change_disp,encoder.disp_in.eq(encoder.disp_out))
				
		]	
"""			
plat=cmoda7.Platform()
dut=Top(platform=plat)
plat.build(dut)
"""
def tb(dut):
	for i in range(50):
		yield
	yield dut.trans_en.eq(1)
	for i in range(80000):
		yield
dut=Top()
run_simulation(dut,tb(dut),vcd_name="Top.vcd")

