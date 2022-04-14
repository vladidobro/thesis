#!/usr/bin/env python3

import pymolzilla.processing as p

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import math, cmath


F = p.FileFemtikStandard('')

samp1 = pd.DataFrame(
        {'phih':[1, 2, 1, 1], 
         'A-B':[2, 3, 4, 5],
         'A+B':[5, 6, 5, 5]})

samp2 = pd.DataFrame({'phih':[1,2,3,1,2,3,1,2,3,1,2],
                     'A-B':[0,0.9,0.5,0.1,1,0.4,0.05,0.8,0.53,0.02,1.1],
                     'A+B':[2,2.3,2.1,1.9,1.8,1.9,2.03,2.06,2.07,1.86,1.83]})

samp3 = pd.DataFrame({'phih':[1,2,3], 'A-B':[0,5,1], 'A+B':[0,1,2]})

F.data = samp3

#F.preprocess_default()
#print(F.data)

df_files = pd.DataFrame({
    'beta':[0,45],
    'file_path':['data/ferh/cross_2/0710H/0000.dat', 'data/ferh/cross_2/0710H/0450.dat'],
    'file_template':['femtik_standard', 'femtik_standard'],
    'file_opts':[{},{}]})

G = p.MeasurementSet(df_files)
G.default_process();
print(G.rotation)
