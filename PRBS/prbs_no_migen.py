from operator import xor, add
from functools import reduce

def PRBSGenerator(n_out,taps=[10, 22]):
    state = [1,]*n_out
    for i in range(1): 
        for j in range(n_out):
            nv = reduce(xor, [state[tap] for tap in taps])
            state.insert(0, nv) #Inserta al comienzo el nuevo valor
            state.pop() #Elimina el ultimo
            print("state",state)
        #words[i]=state
        #print(state)

prbs=PRBSGenerator(n_out=5, taps=[1,3])


