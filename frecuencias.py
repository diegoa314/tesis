def compute_config(refclk_freq, linerate):
    for n1 in 4, 5:
        for n2 in 1, 2, 3, 4, 5:
            for m in 1, 2:
                vco_freq = refclk_freq*(n1*n2)/m
                if 1.6e9 <= vco_freq <= 3.3e9:
                    for d in 1, 2, 4, 8:
                        current_linerate = vco_freq*2/d
                        if current_linerate == linerate:
                            return {"n1": n1, "n2": n2, "m": m, "d": d,
                                    "vco_freq": vco_freq,
                                    "clkin": refclk_freq,
                                    "linerate": linerate}
    msg = "No config found for {:3.2f} MHz refclk / {:3.2f} Gbps linerate."
    raise ValueError(msg.format(refclk_freq/1e6, linerate/1e9))

compute_config(96e6,4.8e9)
"""
for i in range(50):
    refclk_freq=(80+i*5)*1e6
    linerate=4.8e9
    print(compute_config(refclk_freq,linerate))
"""