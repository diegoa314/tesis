from migen import *
import cmoda7
from migen.build.generic_platform import *

class Blinky(Module):
    def __init__(self,platform):
        self.led = led  =platform.request("user_led")
        self.button=button=platform.request("user_btn")
        self.comb += If(button,led.eq(1))

plat=cmoda7.Platform()
dut=Blinky(plat)
plat.build(dut)
#plat.load()