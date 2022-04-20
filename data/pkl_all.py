#!/usr/bin/env python
import pymolzilla.processing as pm

for st in pm.SETS:
    print('experiment:', st)
    pm.analyze_and_pkl(st)
    print('pickled:', st)
