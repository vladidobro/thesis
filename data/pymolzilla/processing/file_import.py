import numpy as np
import pandas as pd

def femtik_load(path):
    return 1*path

def pymolzilla_legacy_load(path):
    return 2*path



def file_load(path, form):
    _FORMAT_LOADERS={'femtik': femtik_load, 'pymolzilla_legacy': pymolzilla_legacy_load}
    return _FORMAT_LOADERS[form](path)

def basic_preprocess(fil):
    pass
