from pymolzilla.processing.file_import import MolzillaFileFactory

import pandas as pd
import numpy as np
import statsmodels.api as sm
import math
import functools

class MeasurementSet:
    def __init__(self, df_files):
        '''Expects a specific format of df_files'''
        self.df_files = df_files

   
    def default_process(self):
        self.rotation = self.collect_merge_data()

    def default_load(self, load_inplace=False, **kwargs):
        file_data = self.df_files.apply(lambda row: MolzillaFileFactory(
            row['file_template'], row['file_path'], **row['file_opts']).default_preprocess().data,
            axis=1)
        if load_inplace: self.df_files['file_data'] = file_data
        return file_data

    def collect_merge_data(self, file_data='default_load', col='rotation', col_merge_by='phih', **kwargs):
        if file_data == 'default_load':
            if 'file_data' in self.df_files: file_data = self.df_files['file_data']
            else: file_data = self.default_load()
        return functools.reduce(
            lambda x,y: pd.merge(x ,y, how='outer', on=col_merge_by),
            map(
                lambda tupl: (tupl[0][[col_merge_by, col]].rename(columns={col:tupl[1]})), 
                zip(file_data, self.df_files.index)
            ),
            pd.DataFrame(columns=[col_merge_by]))

    def symmetrize_beta(self):
        pass

    def fourier2_beta(self):
        pass

class SetRotmld(MeasurementSet):
    pass

class SetRotmldStokes(MeasurementSet):
    pass

class SetFieldCooling(MeasurementSet):
    pass

def MeasurementSetFactory(template, df_files):
    template_classes = {
        'rotmld': SetRotmld,
        'rotmld_stokes': SetRotmldStokes,
        'field_cooling': SetFieldCooling}
