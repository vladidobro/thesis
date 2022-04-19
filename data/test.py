#!/usr/bin/env python3

import pymolzilla.processing as p

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import math, cmath

print(p.list_experiments())

a = p.cofe_room_t
print(a.df)


print(a[0].df)
