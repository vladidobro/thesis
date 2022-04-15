from pymolzilla.processing.file_import import *

import pandas as pd




class Experiment:
    def __init__(self, sample, experiment, group_by='set'):
        self.df_sets = load_experiment(sample, experiment).groupby(group_by)
    
    def process(self):
        self.results = self.df_sets.apply(self.process_set).to_frame('results')
        self.postprocess()
        return self.results

    def postprocess(self):
        pass

    @staticmethod
    def process_set(df):
        return False

class ExperimentRotmld(Experiment):
    @staticmethod
    def process_set(df):
        measurement_set = MeasurementSetFactory('rotmld', df)
        measurement_set.default_process()
        return measurement_set

    def postprocess(self):
        pass


