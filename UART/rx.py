from migen import *
bits=[1,0,1,0,0,1,0,0,1,1,0,0]
frequency=10000
baud=1000

def _divisor(freq_in, freq_out):
	divisor=freq_in//freq_out
	if divisor<=0:
		raise ArgumentError("Frequencia de salida muy alta")
	return divisor

class rx(Module):
	def __init__(self,freq,baud_rate,n_bits):
		
		self.rx_serial=rx_serial=Signal(reset=1)
		self.rx_data=Signal(n_bits)
		self.rx_read_enable=Signal()
		self.rx_ready=Signal()
		self.rx_ack=rx_ack=Signal()
		self.bit_n=bit_n=Signal(max=n_bits)
		self.rx_error=rx_error=Signal()
		divisor=_divisor(freq,baud_rate)
		rx_counter=Signal(max=divisor) 
		self.rx_strobe=rx_strobe=Signal()
		self.comb+=rx_strobe.eq(rx_counter==0)
		self.sync+=\
			If(rx_counter==0,
				rx_counter.eq(divisor-1),
				
			).Else(
				rx_counter.eq(rx_counter-1)
				
			)
		self.submodules.rx_fsm=FSM(reset_state="IDLE")
		self.rx_fsm.act("IDLE",
			If(~rx_serial & self.rx_read_enable,
				NextValue(rx_counter,divisor//2),
				NextState("START")
			)
		)
		self.rx_fsm.act("START",
			If(rx_strobe,
				NextState("DATA")
			)
		)
		self.rx_fsm.act("DATA",
			If(rx_strobe,
				NextValue(self.rx_data,Cat(self.rx_data[1:n_bits],rx_serial)),
				NextValue(bit_n,bit_n+1),
				If(bit_n == n_bits-1,
					NextState("STOP")
				)
			)
		)
		self.rx_fsm.act("STOP",
			If(rx_strobe,
				If(~rx_serial,
					NextState("ERROR")
				).Else(
					NextState("FULL")
				)	
			)
		)
		self.rx_fsm.act("FULL",
			self.rx_ready.eq(1),
			If(self.rx_ack,
				NextState("IDLE")
			).Elif(~rx_serial,
				NextState("ERROR")
			)
		)
		self.rx_fsm.act("ERROR",
			self.rx_error.eq(1)
		)
		
		

"""
def rx_tb(dut): 	
	for i in range(_divisor(frequency,baud)*len(bits)):
		ii=i//_divisor(frequency,baud)
		yield dut.rx_serial.eq(bits[ii])
		yield
dut = UART(freq=frequency,baud_rate=baud)
run_simulation(dut,rx_tb(dut),vcd_name="uart.vcd")		
"""
