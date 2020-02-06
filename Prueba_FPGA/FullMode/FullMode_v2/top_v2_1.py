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
from fsm_v2_1 import *
class Top_v2_1(Module):
	def __init__(self,platform=0):
		self.tx_output=platform.request("serial").tx #salida serila
		self.trans_en=platform.request("user_btn") #habilitador general para el envio
		self.write_en=platform.request("user_btn")
		self.fifo_full_led=platform.request("user_led")
		self.fifo_empty_led=platform.request("user_led")
		#Descomentar para simulacion
		#self.tx_output=Signal() 
		#self.trans_en=Signal()
		#self.write_en=Signal()
		#self.fifo_empty_led=Signal()
		#self.fifo_full_led=Signal()
		#  #  #
		self.reset=Signal()
		data_gen_en=Signal()
		self.data=Signal(8)
		fsm=Fsm_v2_1() #FSM 
		encoder=Encoder() #encoder 8b/10b combinacional
		transmitter=Transmitter10b() #transmisor de 10b
		fifo=SyncFIFOBuffered(width=8, depth=32)
		self.submodules+=[encoder,transmitter,fsm,fifo]
		self.comb+=[
			#asignaciones de las senhales
			fsm.tx_10bdone.eq(transmitter.tx_10bdone),
			fsm.trans_en.eq(self.trans_en),
			fsm.fifo_empty.eq(~fifo.readable),
			fsm.fifo_full.eq(~fifo.writable),
			fsm.write_en.eq(self.write_en),
			transmitter.trans_en.eq(fsm.tx_en),
			data_gen_en.eq(fsm.data_gen_en),
			fifo.we.eq(fsm.fifo_we),
			fifo.re.eq(fsm.fifo_re),
			self.tx_output.eq(transmitter.tx_serial),
			fifo.din.eq(self.data),
			encoder.data_in.eq(fifo.dout),
			If(fsm.encoder_ready,transmitter.data_in.eq(encoder.data_out)),
			#no se realizan el envio de caracteres especiales
			encoder.k.eq(0),
			self.fifo_full_led.eq(~fifo.writable),
			self.fifo_empty_led.eq(~fifo.readable),
			self.reset.eq(self.trans_en & self.write_en)
		]
		self.sync+=[ 
			#La asignacion de disparidad debe ser secuencial debido a la
			#dependecia mutua de ambas senhalas (disp_in y disp_out)
			If(fsm.change_disp,encoder.disp_in.eq(encoder.disp_out)),
			If(data_gen_en & ~self.reset,self.data.eq(self.data+1)),
			If(self.reset, self.data.eq(0)),
	
		]	
plat=cmoda7.Platform()
dut=Top_v2_1(platform=plat)
plat.build(dut)

"""
def tb(dut):
	yield dut.trans_en.eq(1)
	for i in range(10):
		yield
	yield dut.trans_en.eq(0)
	yield dut.write_en.eq(1)
	for i in range(100):
		yield
	yield dut.write_en.eq(0)	
	for i in range(10):
		yield
	yield dut.trans_en.eq(1)
	for i in range(1000):
		yield
	yield dut.trans_en.eq(1)
	yield dut.write_en.eq(1)
	for i in range(10):
		yield
	yield dut.trans_en.eq(0)
	yield dut.write_en.eq(1)
	for i in range(100):
		yield
	yield dut.write_en.eq(0)	
	for i in range(10):
		yield
	yield dut.trans_en.eq(1)
	for i in range(500):
		yield

dut=Top_v2_1()
run_simulation(dut,tb(dut),vcd_name="top_v2_1.vcd")
"""
