import sys
from migen import *
sys.path.append('/root/Tesis/modulo_prueba2/tesis/comunicacion_uart_8b10b')
from memINPUT import * 
 

def Mem_tb(dut):
	yield dut.fifo_we.eq(1)
	yield
	yield dut.re.eq(1)
	yield dut.receiver_en.eq(1)
	for i in range(400):
		yield

dut=mem()
run_simulation(dut,Mem_tb(dut),vcd_name="Mem.vcd")
import subprocess
subprocess.Popen(["gtkwave", "Mem.vcd"])