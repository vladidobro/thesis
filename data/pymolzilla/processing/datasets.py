from pymolzilla.processing.file_import import *

import pandas as pd

def read_filelist():
    return pd.read_csv('files')

