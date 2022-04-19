import pymolzilla.processing as pm

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

F = pm.FreeEnergy({2:1+2j, 4:2-1j})
phih = np.linspace(0,180)
phim = np.array(F.phih2phim(np.radians(phih), hext=207))
c = np.cos(2*phim)
s = np.sin(2*phim)
data = pd.DataFrame({0.:3*c+2*s, 45.:-2*c+3*s})
df_data = pd.concat([pd.DataFrame({'phih':np.linspace(0,180)}), data], axis=1)

def pl():
    fig, ((ax1,ax2),(ax3,ax4)) = plt.subplots(2,2)
    data.plot('phih',0.,ax=ax1)
    data.plot('phih',45.,ax=ax1)
    F.plot(ax=ax2)
    ax3.plot(data['phih'],phim)


ani = pm.FitCubic(df_data)
pmld = pm.FitPmld(data)
