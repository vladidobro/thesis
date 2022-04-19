#!/usr/bin/env python
import pymolzilla.processing as pm

for st in pm.SETS:
    pm.analyze_and_pkl(st)
