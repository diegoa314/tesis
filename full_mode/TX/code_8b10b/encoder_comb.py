"""
IBM's 8b/10b Encoding
This scheme is used by a large number of protocols including Display Port, PCI
Express, Gigabit Ethernet, SATA and USB 3.
The encoding is built by combining an 5b/6b and 3b/4b encoding schemes and
guarantees both DC balance and enough bit transitions to recover the clock
signal.
Note: This encoding is *not* used by DVI/HDMI (that uses a *different* 8b/10b
scheme called TMDS).
"""

from migen import *

class SingleEncoder(Module):
    def __init__(self):
        self.d=d=Signal(8)
        self.k=k=Signal()
        self.output=output=Signal(10, reset=0)
        self.disp_in=disp_in=Signal()
        self.disp_out=Signal()
        
        #  #  #
        ai,bi,ci,di,ei,fi,gi,hi,ki=Signal(9)
        self.comb+=[
            ai.eq(d[0]),bi.eq(d[1]),ci.eq(d[2]),
            di.eq(d[3]),ei.eq(d[4]),fi.eq(d[5]),
            gi.eq(d[6]),hi.eq(d[7]),ki.eq(k)
        ]
        aeqb,ceqd,l22,l40,l04,l13,l31=Signal(7)
        self.comb+=[
            aeqb.eq((ai & bi) | (~ai & ~bi)),
            ceqd.eq((ci & di) | (~ci & ~di)),
            l22.eq((ai & bi & ~ci & ~di)|(ci & di & ~ai & ~bi)|(~aeqb & ~ceqd)),
            l40.eq(ai & bi & ci & di),
            l04.eq(~ai & ~bi & ~ci & ~di),
            l13.eq(( ~aeqb & ~ci & ~di) | ( ~ceqd & ~ai & ~bi)),
            l31.eq(( ~aeqb & ci & di) | ( ~ceqd & ai & bi))
        ]
        # Codificacion 5b/6b
        ao,bo,co,do,eo,io=Signal(6)
        self.comb+=[
            ao.eq(ai), bo.eq((bi & ~l40) | l04),
            co.eq(l04 | ci | (ei & di & ~ci & ~bi & ~ai)),
            do.eq(di & ~ (ai & bi & ci)),
            eo.eq((ei | l13) & ~ (ei & di & ~ci & ~bi & ~ai)),
            io.eq((l22 & ~ei) |
                (ei & ~di & ~ci & ~(ai&bi)) |  # D16, D17, D18
                (ei & l40) |
                (ki & ei & di & ci & ~bi & ~ai) | # K.28
                (ei & ~di & ci & ~bi & ~ai)
            )
        ]
        pd1s6,nd1s6,ndos6,pdos6=Signal(4)
        alt7,fo,go,ho,jo,aux=Signal(6)
        self.comb+=[
            #pd1s6 indicates cases where d-1 is assumed + to get our encoded value
            pd1s6.eq((ei & di & ~ci & ~bi & ~ai) | (~ei & ~l22 & ~l31)),
            #nd1s6 indicates cases where d-1 is assumed - to get our encoded value
            nd1s6.eq(ki | (ei & ~l22 & ~l13) | (~ei & ~di & ci & bi & ai)),
            #ndos6 is pd1s6 cases where d-1 is + yields - disp out - all of them
            ndos6.eq(pd1s6),
            #pdos6 is nd1s6 cases where d-1 is - yields + disp out - all but one
            pdos6.eq(ki | (ei & ~l22 & ~l13))           
        ]
        # some Dx.7 and all Kx.7 cases result in run length of 5 case unless
        # an alternate coding is used (referred to as Dx.A7, normal is Dx.P7)
        # specifically, D11, D13, D14, D17, D18, D19.
        self.comb+=[
            If(self.disp_in,
                aux.eq(~ei & di & l31)
            ).Else(aux.eq(ei & ~di & l13)),
            alt7.eq(fi & gi & hi & (ki | aux)),
            fo.eq(fi & ~ alt7),
            go.eq(gi | (~fi & ~gi & ~hi)),
            ho.eq(hi),
            jo.eq((~hi & (gi ^ fi)) | alt7)
        ]

        nd1s4,pd1s4,ndos4,pdos4=Signal(4)
        self.comb+=[
            #nd1s4 is cases where d-1 is assumed - to get our encoded value
            nd1s4.eq(fi & gi),
            #pd1s4 is cases where d-1 is assumed + to get our encoded value
            pd1s4.eq((~fi & ~gi) | (ki & ((fi & ~gi) | (~fi & gi)))),
            #ndos4 is pd1s4 cases where d-1 is + yields - disp out - just some
            ndos4.eq((~fi & ~gi)),
            #pdos4 is nd1s4 cases where d-1 is - yields + disp out 
            pdos4.eq(fi & gi & hi )
        ]
        # only legal K codes are K28.0->.7, K23/27/29/30.7
        #   K28.0->7 is ei=di=ci=1,bi=ai=0
        #   K23 is 10111
        #   K27 is 11011
        #   K29 is 11101
        #   K30 is 11110 - so K23/27/29/30 are ei & l31
        illegalk=Signal()
        self.comb+=illegalk.eq(ki & 
            (ai | bi | ~ci | ~di | ~ei) & # not K28.0->7
            (~fi | ~gi | ~hi | ~ei | ~l31)  # not K23/27/29/30.7
        )
        #now determine whether to do the complementing
        #complement if prev disp is - and pd1s6 is set, or + and nd1s6 is set
        compls6=Signal()
        self.comb+=compls6.eq((pd1s6 & ~disp_in) | (nd1s6 & disp_in))

        # disparity out of 5b6b is disp in with pdso6 and ndso6
        # pd1s6 indicates cases where d-1 is assumed + to get our encoded value
        # ndos6 is cases where d-1 is + yields - disp out
        # nd1s6 indicates cases where d-1 is assumed - to get our encoded value
        # pdos6 is cases where d-1 is - yields + disp out
        # disp toggles in all ndis16 cases, and all but that 1 nd1s6 case
        disp6,compls4=Signal(2)
        
        self.comb+=[disp6.eq(disp_in ^ (ndos6 | pdos6)),
            compls4.eq((pd1s4 & ~disp6) | (nd1s4 & disp6)),
            self.disp_out.eq(disp6 ^ (ndos4 | pdos4))
        ]
        self.sync+=[
        
            output[0].eq((jo ^ compls4)),output[1].eq( (ho ^ compls4)),
            output[2].eq((go ^ compls4)),output[3].eq((fo ^ compls4)),
            output[4].eq((io ^ compls6)),output[5].eq((eo ^ compls6)),
            output[6].eq((do ^ compls6)),output[7].eq((co ^ compls6)),
            output[8].eq((bo ^ compls6)),output[9].eq((ao ^ compls6))
            
        ]   


class Encoder(Module):
    def __init__(self, nwords=1, lsb_first=False):
        self.d = [Signal(8) for _ in range(nwords)]
        self.k = [Signal() for _ in range(nwords)]
        self.output = [Signal(10) for _ in range(nwords)]
        self.disparity = [Signal() for _ in range(nwords)]

        # # #

        encoders = [SingleEncoder() for _ in range(nwords)]
        self.submodules += encoders

        self.sync += encoders[0].disp_in.eq(encoders[-1].disp_out)
        for e1, e2 in zip(encoders, encoders[1:]):
            self.comb += e2.disp_in.eq(e1.disp_out)

        for d, k, output, disparity, encoder in \
                zip(self.d, self.k, self.output, self.disparity, encoders):
            self.comb += [
                encoder.d.eq(d),
                encoder.k.eq(k)
            ]
            self.sync += [
                output.eq(encoder.output),
                disparity.eq(encoder.disp_out)
            ]


class Decoder(Module):
    def __init__(self, lsb_first=False):
        self.input = Signal(10)
        self.d = Signal(8)
        self.k = Signal()

        # # #

        input_msb_first = Signal(10)
        if lsb_first:
            for i in range(10):
                self.comb += input_msb_first[i].eq(self.input[9-i])
        else:
            self.comb += input_msb_first.eq(self.input)

        code6b = input_msb_first[4:]
        code5b = Signal(5)
        code4b = input_msb_first[:4]
        code3b = Signal(3)
        self.sync += [
            self.k.eq(0),
            If(code6b == 0b001111,
                self.k.eq(1),
                code3b.eq(Array(table_4b3b_kn)[code4b])
            ).Elif(code6b == 0b110000,
                self.k.eq(1),
                code3b.eq(Array(table_4b3b_kp)[code4b])
            ).Else(
                If((code4b == 0b0111) | (code4b == 0b1000),  # D.x.A7/K.x.7
                    If((code6b != 0b100011) &
                       (code6b != 0b010011) &
                       (code6b != 0b001011) &
                       (code6b != 0b110100) &
                       (code6b != 0b101100) &
                       (code6b != 0b011100), self.k.eq(1))
                ),
                code3b.eq(Array(table_4b3b)[code4b])
            ),
            code5b.eq(Array(table_6b5b)[code6b])
        ]

        self.comb += self.d.eq(Cat(code5b, code3b))


bits=[0b10101100, 0b10001110, 0b10011110, 
0b00011100, 0b11100011, 0b10101010, 0b11001101, 0b11100000, 0b01101101, 0b00000000 ]
n=len(bits)
def encoder_tb(dut):
    for i in range(n):
        yield dut.d[i].eq(bits[i])
    yield
    yield
    yield

dut=Encoder(nwords=n)
run_simulation(dut, encoder_tb(dut), vcd_name="8b10b_tb.vcd")
