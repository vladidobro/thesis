from pymolzilla.processing.file_import import *

import pandas as pd
import pickle

class Experiment:
    def __init__(self, sample, experiment, set_template='rotmld', group_by='set', filelist='filelist'):
        group_by = [group_by] if not isinstance(group_by, list) else group_by
        groups = load_experiment(sample, experiment, filelist=filelist).groupby(group_by)

        descriptors=['sample','experiment','wavelength','flags']

        def prep(df):
            df.drop(descriptors+group_by, axis=1, inplace=True)
            df.sort_values('beta', ignore_index=True, inplace=True)
            return MeasurementSetFactory(set_template, df)
        
        self.df = pd.DataFrame(
            {'obj':groups.apply(prep)}
            |{key: groups[key].first() for key in 
                ('wavelength','flags')}).reset_index()
        self.df['sample_rotation'] = self.df['flags'].apply(
            lambda flags: 0 if flags is None or 'R' not in flags else -90)
       
    def __getitem__(self, index):
        return self.df['obj'].iloc[index]

    def load(self, progressbar=True):
        for i,f in enumerate(self):
            if progressbar: print("loading set:", i)
            f.load()

    def preprocess(self, progressbar=True):
        for i,f in enumerate(self):
            if progressbar: print("preprocessing set:", i)
            f.preprocess()

    def process(self, progressbar=True):
        for i,f in enumerate(self):
            if progressbar: print("processing set:", i)
            f.process()

    def analyze(self, progressbar=True):
        for i,f in enumerate(self):
            if progressbar: print("analyzing set:", i)
            f.analyze()
        
        if progressbar: print("postprocessing")
        self.postprocess()

    def postprocess(self):
        pass

class ExperimentRotmld(Experiment):
    def __init__(self, sample, experiment, filelist='filelist', set_template='rotmld'):
        super().__init__(sample, experiment, filelist=filelist, set_template=set_template)
        self.df['hext'] = self.df['flags'].apply(
            lambda flags: 207 if flags is None or 'L' not in flags else 50
            )
        self._update_hext()

    def _update_hext(self):
        def upd(row):
            row['obj'].hext = row['hext']
        self.df.apply(upd, axis=1)

    def postprocess(self):
        self.df['k_canon'] = self.df.apply(lambda row: row['obj'].fit_anisotropy.free_energy.k_canon, axis=1)

class cofe_room_t(ExperimentRotmld):
    def __init__(self):
        super().__init__('cofe', 'room_t')
        for f1 in self:
            for f2 in f1:
                f2.opts |= {'normalize_factor': 100 / 1000}

class cofe_low_t(ExperimentRotmld):
    def __init__(self):
        super().__init__('cofe', 'low_t')
        for f1 in self:
            for f2 in f1:
                f2.opts |= {'normalize_factor': 100 / 1000}

class ferh_fm_zeynab(ExperimentRotmld):
    def __init__(self):
        super().__init__('ferh', 'fm_zeynab')
        for f1 in self:
            for f2 in f1:
                f2.opts |= {'normalize_factor': 10 / 1000}

class bridge_tests(ExperimentRotmld):
    def __init__(self):
        super().__init__('cofe', 'bridge_tests')
        self.df = self.df.iloc[1:]
        self.df.reset_index(drop=True, inplace=True)
        for f1 in self:
            f1.df.drop(f1.df[f1.df['beta']==360.].index, inplace=True)
            for f2 in f1:
                f2.opts |= {'normalize_factor': 100 / 1000}


class stokes_tests(ExperimentRotmld):
    def __init__(self):
        super().__init__('stokes', 'stokes', set_template='rotmld_stokes', filelist='fl_stokes')
        self[0].df['f_sens'] = self[0].df.apply(lambda row: f"files/stokes/stokes/1050_xA/stokes/{int(row['beta']):03d}_0/sens.csv", axis=1)
        self[0].df['f_full'] = self[0].df.apply(lambda row: f"files/stokes/stokes/1050_xA/stokes/{int(row['beta']):03d}_0/full.csv", axis=1)

SETS = {'cofe_room_t': cofe_room_t,
        'cofe_low_t': cofe_low_t,
        'ferh_fm_zeynab': ferh_fm_zeynab,
        'bridge_tests': bridge_tests,
        'stokes_tests': stokes_tests}

PICKLEDIR = 'files/pkl/'

def analyze_and_pkl(name, pkl=True):
    f = SETS[name]()
    f.load()
    f.preprocess()
    f.process()
    f.analyze()
    if pkl:
        with open(PICKLEDIR+name+'.pkl', 'wb') as outp:
            pickle.dump(f, outp, pickle.HIGHEST_PROTOCOL)
    return f

def unpkl_analyzed(name):
    with open(PICKLEDIR+name+'.pkl', 'rb') as inp:
        return pickle.load(inp)

