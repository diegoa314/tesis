from migen import *
import sys
sys.path.append('/home/diegoaranda/Documents/Tesis/Prueba_FPGA')
import cmoda7
sys.path.append('/home/diegoaranda/Documents/Tesis/8b10b')
from encoder_comb import *
sys.path.append('/home/diegoaranda/Documents/Tesis/Prueba_FPGA/FullMode')
from transmitter42b_dtype import *
sys.path.append('/home/diegoaranda/Documents/Tesis/PRBS')
from prbs import *
sys.path.append('/home/diegoaranda/Documents/Tesis/FIFO')
from fifoDT import *
from fsm_v3_1 import *
from memoria import *
from migen.fhdl.specials import Memory, READ_FIRST
class Top_v3_1(Module):
	def __init__(self,platform=0):
		
		self.tx_output=platform.request("serial").tx #salida serila
		self.trans_en=platform.request("user_btn") #habilitador general para el envio
		self.write_en=platform.request("user_btn")
		self.fifo_full_led=platform.request("user_led")
		self.fifo_empty_led=platform.request("user_led")
		
		"""
		#Descomentar para simulacion
		self.tx_output=Signal() 
		self.trans_en=Signal()
		self.write_en=Signal()
		self.fifo_empty_led=Signal()
		self.fifo_full_led=Signal()
		"""
		#  #  #
		self.reset=Signal()
		memoria=mem()
		fsm=Fsm_v3_1() #FSM 
		encoder1=Encoder()
		encoder2=Encoder()
		encoder3=Encoder()
		encoder4=Encoder()
		transmitter=Transmitter42b() #transmisor
		fifo=SyncFIFOBuffered(width=32, depth=32)
		self.submodules+=[memoria,encoder1,encoder2,encoder3,encoder4,transmitter,fsm,fifo]
		self.comb+=[
			#asignaciones de las senhales
			fsm.tx_done.eq(transmitter.tx_42bdone),
			fsm.trans_en.eq(self.trans_en),
			fsm.fifo_empty.eq(~fifo.fifo.readable),
			fsm.fifo_full.eq(~fifo.fifo.writable),
			fsm.write_en.eq(self.write_en),
			transmitter.trans_en.eq(fsm.tx_en),
			fifo.we.eq(fsm.fifo_we),
			fifo.re.eq(fsm.fifo_re),
			self.tx_output.eq(transmitter.tx_serial),
			fifo.din.eq(memoria.data_out),
			fifo.dtin.eq(memoria.type_out),
			encoder1.data_in.eq(fifo.dout[0:8]),
			encoder2.data_in.eq(fifo.dout[8:16]),
			encoder3.data_in.eq(fifo.dout[16:24]),
			encoder4.data_in.eq(fifo.dout[24:32]),
			If(fsm.encoder_ready,
				transmitter.data_in[0:10].eq(encoder1.data_out),
				transmitter.data_in[10:20].eq(encoder2.data_out),
				transmitter.data_in[20:30].eq(encoder3.data_out),
				transmitter.data_in[30:40].eq(encoder4.data_out),
				transmitter.data_in[40:42].eq(fifo.dtout)
			),
			
			#no se realizan el envio de caracteres especiales
			encoder1.k.eq(0),
			encoder2.k.eq(0),
			encoder3.k.eq(0),
			encoder4.k.eq(0),
			self.fifo_full_led.eq(~fifo.fifo.writable),
			self.fifo_empty_led.eq(~fifo.fifo.readable),
			self.reset.eq(self.trans_en & self.write_en)
		]
		self.sync+=[ 
			#La asignacion de disparidad debe ser secuencial debido a la
			#dependecia mutua de ambas senhalas (disp_in y disp_out)
			If(fsm.change_disp,
				encoder1.disp_in.eq(encoder1.disp_out),
				encoder2.disp_in.eq(encoder2.disp_out),
				encoder3.disp_in.eq(encoder3.disp_out),
				encoder4.disp_in.eq(encoder4.disp_out)
			),
			If(fsm.read_next,memoria.index.eq(memoria.index+1))
			
		]	



plat=cmoda7.Platform()
dut=Top_v3_1(platform=plat)
plat.build(dut)

"""

def tb(dut):
	
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

dut=Top_v3_1()
run_simulation(dut,tb(dut),vcd_name="top_v3_1.vcd")

"""