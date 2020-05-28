from migen import *
from migen.fhdl import verilog
from migen.fhdl.structure import *
from migen.fhdl.module import Module
from migen.fhdl.specials import Memory, READ_FIRST
from migen.fhdl.bitcontainer import log2_int
from migen.fhdl.decorators import ClockDomainsRenamer
from migen.genlib.cdc import MultiReg, GrayCounter


__all__ = ["AsyncFIFO", "AsyncFIFOBuffered"]


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
        self.dout = Signal(width, reset_less=True)
        self.dtin = Signal(2, reset_less=True)
        self.dtout = Signal(2, reset_less=True)
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

    def write(self, data):
        """Write method for simulation."""
        yield self.din.eq(data)
        yield self.we.eq(1)
        yield
        yield self.we.eq(0)
        yield

    def readtype(self):
        """Read method for simulation."""
        value = (yield self.dtout)
        yield self.re.eq(1)
        yield
        yield self.re.eq(0)
        yield
        return value

    def writetype(self, data):
        """Write method for simulation."""
        yield self.dtin.eq(data)
        yield self.we.eq(1)
        yield
        yield self.we.eq(0)
        yield

class AsyncFIFO(Module, _FIFOInterface):
    """Asynchronous FIFO (first in, first out)

    Read and write interfaces are accessed from different clock domains,
    named `read` and `write`. Use `ClockDomainsRenamer` to rename to
    other names.

    {interface}
    """
    __doc__ = __doc__.format(interface=_FIFOInterface.__doc__)

    def __init__(self, width, depth):
        _FIFOInterface.__init__(self, width, depth)

        ###

        depth_bits = log2_int(depth, True)                 

        produce = ClockDomainsRenamer("write")(GrayCounter(depth_bits+1))
        consume = ClockDomainsRenamer("read")(GrayCounter(depth_bits+1))
        self.submodules += produce, consume
        self.comb += [
            produce.ce.eq(self.writable & self.we),
            consume.ce.eq(self.readable & self.re)
        ]

        produce_rdomain = Signal(depth_bits+1)
        produce.q.attr.add("no_retiming")
        self.specials += MultiReg(produce.q, produce_rdomain, "read")
        consume_wdomain = Signal(depth_bits+1)
        consume.q.attr.add("no_retiming")
        self.specials += MultiReg(consume.q, consume_wdomain, "write")
        if depth_bits == 1:
            self.comb += self.writable.eq((produce.q[-1] == consume_wdomain[-1])
                | (produce.q[-2] == consume_wdomain[-2]))
        else:
            self.comb += [
                self.writable.eq((produce.q[-1] == consume_wdomain[-1])
                | (produce.q[-2] == consume_wdomain[-2])
                | (produce.q[:-2] != consume_wdomain[:-2]))
            ]
        self.comb += self.readable.eq(consume.q != produce_rdomain)
        storage = Memory(self.width, depth)
        self.specials += storage
        wrport = storage.get_port(write_capable=True, clock_domain="write")
        self.specials += wrport
        self.comb += [
            wrport.adr.eq(produce.q_binary[:-1]),
            wrport.dat_w.eq(self.din),
            wrport.we.eq(produce.ce)
        ]
        rdport = storage.get_port(clock_domain="read")
        self.specials += rdport
        self.comb += [
            rdport.adr.eq(consume.q_next_binary[:-1]),
            self.dout.eq(rdport.dat_r)
        ]

        #### BLOQUE DE DATA TYPE #####

        storaget = Memory(2, depth)
        self.specials += storaget
        wrport1 = storaget.get_port(write_capable=True, clock_domain="write")
        self.specials += wrport1
        self.comb += [
            wrport1.adr.eq(produce.q_binary[:-1]),
            wrport1.dat_w.eq(self.dtin),
            wrport1.we.eq(produce.ce)
        ]
        rdport1 = storaget.get_port(clock_domain="read")
        self.specials += rdport1
        self.comb += [
            rdport1.adr.eq(consume.q_next_binary[:-1]),
            self.dtout.eq(rdport1.dat_r)
        ]

class AsyncFIFOBuffered(Module, _FIFOInterface):
    """Improves timing when it breaks due to sluggish clock-to-output
    delay in e.g. Xilinx block RAMs. Increases latency by one cycle."""
    def __init__(self, width, depth):
        _FIFOInterface.__init__(self, width, depth)
        self.submodules.fifo = fifo = AsyncFIFO(width, depth)

        self.writable = fifo.writable
        self.din = fifo.din
        self.dtin = fifo.dtin
        self.we = fifo.we
       

        self.sync.read += \
            If(self.re | ~self.readable,
                self.dout.eq(fifo.dout),
                self.dtout.eq(fifo.dtout),
                self.readable.eq(fifo.readable)
            )
        self.comb += fifo.re.eq(self.re | ~self.readable)

#example = AsyncFIFO(width=32, depth=32)
#print(verilog.convert(example, {example.writable, example.din, example.dtin, example.we, example.dout, example.dtout, example.readable, example.re}))


"""def _test_fifo(dut):
    for i in range(8):
        yield dut.din.eq(i)
        yield
        yield dut.we.eq(1)
        yield
        yield dut.re.eq(1)

       #write((yield dut))

if __name__ == "__main__":
    dut = AsyncFIFO(width=8, depth=32)
    run_simulation(dut, _test_fifo(dut), clocks={"write":1,"read":100}, vcd_name="fifo_full.vcd")
    import subprocess
    subprocess.Popen(["gtkwave", "fifo_full.vcd"])"""
