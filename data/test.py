#!/usr/bin/env python3

import pymolzilla.processing as p

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import math, cmath

rnd = lambda: np.random.standard_normal()

F = p.FreeEnergy({1: 1, 2: 0.5+0.5j})
#F.k_canon = {'kc': 1}


phih = np.linspace(0,2*math.pi,50)
phim = F.phih2phim(phih, hext=100)
print(phim)



fig, (ax, ax2) = plt.subplots(2, 1)
F.plot(ax)
F.plot(ax,derivative=1)
F.rotate(10).plot(ax)
ax2.plot(phih,phim)
fig.savefig('a.png')
