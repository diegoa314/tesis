from migen import *
from migen.fhdl import verilog
from migen.fhdl.structure import *
from migen.fhdl.module import Module
from migen.fhdl.specials import Memory, READ_FIRST
from migen.fhdl.bitcontainer import log2_int
from migen.fhdl.decorators import ClockDomainsRenamer
from migen.genlib.cdc import MultiReg, GrayCounter
#from migen.genlib.fifo import *



__all__ = ["SyncFIFO", "SyncFIFOBuffered"]


def _inc(signal, modulo):
    if modulo == 2**len(signal):
        return signal.eq(signal + 1)
    else:
        return If(signal == (modulo - 1),
            signal.eq(0)
        ).Else(
            signal.eq(signal + 1)
        )


class _FIFOInterface:
    def __init__(self, width, depth):
        self.we = Signal()
        self.writable = Signal()  # not full
        self.re = Signal()
        self.readable = Signal()  # not empty

        self.din = Signal(width, reset_less=True)
        self.dtin = Signal(2)
        self.dtout = Signal(2)
        self.dout = Signal(width, reset_less=True)
        self.width = width
        self.depth = depth

    def read(self):
        """Read method for simulation."""
        value = (yield self.dout)
        yield self.re.eq(1)
        yield
        yield self.re.eq(0)
        yield
        return value

    def readtype(self):
        """Read method for simulation."""
        valuety = (yield self.dtout)
        yield self.re.eq(1)
        yield
        yield self.re.eq(0)
        yield
        return valuety

    def write(self, data):
        """Write method for simulation."""
        yield self.din.eq(data)
        yield self.we.eq(1)
        yield
        yield self.we.eq(0)
        yield

    def writetype(self, data):
        """Write method for simulation."""
        yield self.dtin.eq(data)
        yield self.we.eq(1)
        yield
        yield self.we.eq(0)
        yield


##############################################################################################3333
class SyncFIFO(Module, _FIFOInterface):
    """Synchronous FIFO (first in, first out)

    Read and write interfaces are accessed from the same clock domain.
    If different clock domains are needed, use :class:`AsyncFIFO`.

    {interface}
    level : out
        Number of unread entries.
    replace : in
        Replaces the last entry written into the FIFO with `din`. Does nothing
        if that entry has already been read (i.e. the FIFO is empty).
        Assert in conjunction with `we`.
    """
    __doc__ = __doc__.format(interface=_FIFOInterface.__doc__)

    def __init__(self, width, depth, fwft=True):
        _FIFOInterface.__init__(self, width, depth)

        self.level = Signal(max=depth+1)
        self.replace = Signal()
        self.replacet = Signal()

        ###

        produce = Signal(max=depth)
        consume = Signal(max=depth)
        storage = Memory(self.width, depth, name="DATA")
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
        self.specials += rdport
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
        ]

#################################### BLOQUE DE DATA_TYPE ########################################


        producet = Signal(max=depth)
        consumet = Signal(max=depth)
        storaget = Memory(2, depth, name="TYPE")
        self.specials += storaget

        wrportTYPE = storaget.get_port(write_capable=True, mode=READ_FIRST)
        self.specials += wrportTYPE
        self.comb += [
            If(self.replace,
                wrportTYPE.adr.eq(producet-1)
            ).Else(
                wrportTYPE.adr.eq(producet)
            ),
            wrportTYPE.dat_w.eq(self.dtin),
            wrportTYPE.we.eq(self.we & (self.writable | self.replace))
        ]
        self.sync += If(self.we & self.writable & ~self.replace,
            _inc(producet, depth))

        do_readTYPE = Signal()
        self.comb += do_readTYPE.eq(self.readable & self.re)

        rdportTYPE = storaget.get_port(async_read=fwft, has_re=not fwft, mode=READ_FIRST)
        self.specials += rdportTYPE
        self.comb += [
            rdportTYPE.adr.eq(consumet),
            self.dtout.eq(rdportTYPE.dat_r)
        ]
        if not fwft:
            self.comb += rdportTYPE.re.eq(do_readTYPE)
        self.sync += If(do_readTYPE, _inc(consumet, depth))

        self.sync += \
            If(self.we & self.writable & ~self.replace,
                If(~do_readTYPE, self.level.eq(self.level + 1))
            ).Elif(do_readTYPE,
                self.level.eq(self.level - 1)
            )
        self.comb += [
            self.writable.eq(self.level != depth),
            self.readable.eq(self.level != 0)
        ]

#################################################################################################

class SyncFIFOBuffered(Module, _FIFOInterface):
    
    def __init__(self, width, depth):
        _FIFOInterface.__init__(self, width, depth)
        self.submodules.fifo = fifo = SyncFIFO(width, depth, False)

        self.writable = fifo.writable
        self.din = fifo.din
        self.dtin = fifo.dtin
        self.we = fifo.we
        self.dout = fifo.dout
        self.dtout = fifo.dtout
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
        self.comb += fifo.re.eq(self.re | ~self.readable) 
   

"""
def _test_fifo(dut):
    for i in range(8):
        yield dut.din.eq(i)
        yield dut.dtin.eq(i)
       # yield
        yield dut.we.eq(1)
        yield
        yield dut.re.eq(1)
       #write((yield dut))

if __name__ == "__main__":
    dut = SyncFIFOBuffered(width=8, depth=32)
    run_simulation(dut, _test_fifo(dut), vcd_name="fifoDT.vcd")
    import subprocess
    subprocess.Popen(["gtkwave", "fifoDT.vcd"])
"""
    
    