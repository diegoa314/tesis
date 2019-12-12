from migen import *
from tx_migen import *
from rx_migen import *

frequency=10000
baud=1000
bits=[0,1,0,0,1,0,0,1]
def _divisor(freq_in, freq_out, max_ppm=None):
    divisor = freq_in // freq_out
    if divisor <= 0:
        raise ArgumentError("output frequency is too high")

    ppm = 1000000 * ((freq_in / divisor) - freq_out) / freq_out
    if max_ppm is not None and ppm > max_ppm:
        raise ArgumentError("output frequency deviation is too high")

    return divisor

def uart_tb(dut): 	
	for i in range(1,8):
		yield dut.tx_data[i].eq(bits[i])
	 	
	yield dut.tx_serial.eq(1)
	yield 
	yield dut.tx_ready.eq(1)	
	yield 
	yield dut.tx_ready.eq(0)

	
	for i in range(130):
		yield dut.rx_serial.eq(dut.tx_serial) 
		yield
dut = rx(freq=frequency,baud_rate=baud)
run_simulation(dut,uart_tb(dut),vcd_name="tx_tb.vcd")		