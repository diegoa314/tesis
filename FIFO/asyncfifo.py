from migen.fhdl.structure import *
from migen.fhdl import verilog
from migen.fhdl.module import Module
from migen.fhdl.specials import Memory, READ_FIRST
from migen.fhdl.bitcontainer import log2_int
from migen.fhdl.decorators import ClockDomainsRenamer
from migen.genlib.cdc import MultiReg, GrayCounter
from migen import *
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
    """
    Data written to the input interface (`din`, `we`, `writable`) is
    buffered and can be read at the output interface (`dout`, `re`,
    `readable`). The data entry written first to the input
    also appears first on the output.

    Parameters
    ----------
    width : int
        Bit width for the data.
    depth : int
        Depth of the FIFO.

    Attributes
    ----------
    din : in, width
        Input data
    writable : out
        There is space in the FIFO and `we` can be asserted to load new data.
    we : in
        Write enable signal to latch `din` into the FIFO. Does nothing if
        `writable` is not asserted.
    dout : out, width
        Output data. Only valid if `readable` is asserted.
    readable : out
        Output data `dout` valid, FIFO not empty.
    re : in
        Acknowledge `dout`. If asserted, the next entry will be
        available on the next cycle (if `readable` is high then).
    """
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


#example = AsyncFIFO(width=32, depth=32)
#print(verilog.convert(example, {example.writable, example.din, example.we, example.dout, example.readable, example.re}))
"""
def tb(dut):
    yield dut.din.eq(0xaa)
    yield dut.we.e1(1)
    yield
    yield dut.din.eq(0xbb)
    yield
    yield dut.din.eq(0xcc)
    yield
    yield dut.re.eq(1)
    yield dut.we.eq(0)
    yield
    yield
    yield
    

dut = AsyncFIFO(width=32, depth=32)
run_simulation(dut, tb(dut), vcd_name="async_fifo.vcd")
"""