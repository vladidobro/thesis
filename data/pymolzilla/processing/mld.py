from .file_import import *

import pandas as pd
import numpy as np
import statsmodels.api as sm
import math
import functools

class MLDSet:
    def __init__(self, df_files):
        self.df_files = df_files

    def load_standard(self, **kwargs):
        map(lambda f: f.preprocess_standard(**kwargs), self.df_files['files'])

    def symmetrize_beta(self):
        pass

    def fourier2_beta(self):
        pass


