from migen import *
from migen.fhdl.structure import *
from migen.fhdl.module import Module
from migen.fhdl.specials import Memory, READ_FIRST
from migen.fhdl.bitcontainer import log2_int
from migen.fhdl.decorators import ClockDomainsRenamer
from migen.genlib.cdc import MultiReg, GrayCounter
from migen.genlib.fifo import *


class _FIFOInterface:
    def __init__(self, width, depth):
        self.we = Signal()
        self.writable = Signal()  # not full
        self.re = Signal()
        self.readable = Signal()  # not empty

        self.din = Signal(width, reset_less=True)
        self.dout = Signal(width, reset_less=True)
        self.width = width
        self.depth = depth

    def read(self):
        """Read method for simulation."""
        value = (yield self.dout)
        yield self.re.eq(0)
        yield
        yield self.re.eq(0)
        yield
        return value

    def write(self, data):
        """Write method for simulation."""
        yield self.din.eq(data)
        yield self.we.eq(1)
        yield
        yield self.we.eq(0)
        yield
"""
class SyncFIFO(Module, _FIFOInterface):
 
    __doc__ = __doc__.format(interface=_FIFOInterface.__doc__)

    def __init__(self, width, d0epth, fwft=True):
        _FIFOInterface.__init__(self, width, depth)

        self.level = Signal(max=depth+1)
        self.replace = Signal()

        ###

        produce = Signal(max=depth)
        consume = Signal(max=depth)
        storage = Memory(self.width, depth)
        self.specials += storage

        wrport = storage.get_port(write_capable=True, mode=READ_FIRST)
        self.specials += wrport
        self.comb += [
            If(self.replace,
                wrport.adr.eq(produce-1)
            ).Else(
                wrport.adr.eq(produce)
            ),
            wrport.dat_w.eq(self.din),
            wrport.we.eq(self.we & (self.writable | self.replace))
        ]
        self.sync += If(self.we & self.writable & ~self.replace,
            _inc(produce, depth))

        do_read = Signal()
        self.comb += do_read.eq(self.readable & self.re)

        rdport = storage.get_port(async_read=fwft, has_re=not fwft, mode=READ_FIRST)
        self.comb += [
            rdport.adr.eq(consume),
            self.dout.eq(rdport.dat_r)
        ]
        if not fwft:
            self.comb += rdport.re.eq(do_read)
        self.sync += If(do_read, _inc(consume, depth))

        self.sync += \
            If(self.we & self.writable & ~self.replace,
                If(~do_read, self.level.eq(self.level + 1))
            ).Elif(do_read,
                self.level.eq(self.level - 1)
            )
        self.comb += [
            self.writable.eq(self.level != depth),
            self.readable.eq(self.level != 0)
        ] """

class SyncFIFOBuffered(Module, _FIFOInterface):
    
    def __init__(self, width, depth):
        _FIFOInterface.__init__(self, width, depth)
        self.submodules.fifo = fifo = SyncFIFO(width, depth, False)

        self.writable = fifo.writable
        self.din = fifo.din
        self.we = fifo.we
        self.dout = fifo.dout
        self.level = Signal(max=depth+2)

        ###

        self.comb += fifo.re.eq(fifo.readable & (~self.readable | self.re))
        self.sync += \
            If(fifo.re,
                self.readable.eq(1),
            ).Elif(self.re,
                self.readable.eq(0),
            )
        self.comb += self.level.eq(fifo.level + self.readable)

       
"""

def _test_fifo(dut):
    for i in range(16):
        yield dut.din.eq(i)
        yield
        yield dut.we.eq(1)
       #write((yield dut))
    yield dut.re.eq(1)
    yield
    yield
    yield


if __name__ == "__main__":
    dut = SyncFIFOBuffered(width=8, depth=32)
    run_simulation(dut, _test_fifo(dut), vcd_name="fifo2.vcd")
    
    """