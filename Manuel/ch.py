from migen import *
import nexys_video

class Contador(Module):
    def __init__(self,platform):
        # Un contador para contar los ciclos de la fpga
        self.counter = contador = Signal(25)
        # Un contador lento para sumar cada 2 ** 25 ciclos de reloj (~3Hz)
        self.scount  = scontado = Signal(8)
        # Sync hace una combinatoria sólo cuando sube la bandera del clk
        self.sync += \
            If(contador == 0,
                #contador.eq(33554432 - 1),scontado.eq(scontado+1)
		contador.eq(335 - 1),scontado.eq(scontado+1)
            ).Else(
                contador.eq(contador - 1)
            )
        # En este vector se guarda el número binario y se asigna cada componente 
        # a cada led
        Vector =[0,0,0,0,0,0,0,0]
        for i in range(0,8):          
            self.led = led = platform.request("user_led")
            Vector[i] = scontado[i]
            self.comb += led.eq(Vector[i])
   # Este es un test bench integrado que simula las señales de entrada (clk)
   # e imprimer las señales de counter scounter y de led (simulación)
def blinky_test(dut):
    for i in range(3000):
        print("{} {} {}".format((yield dut.counter),(yield dut.scount),(yield dut.led)))
        yield
           
# Constructores
platform = nexys_video.Platform()
dut = Contador(platform)
# Constructor
#platform.build(dut)
#platform.load()
# Simulador
run_simulation(dut, blinky_test(dut), vcd_name="blinky.vcd")
