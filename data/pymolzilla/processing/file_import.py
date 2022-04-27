from pymolzilla.processing.mld import *

import numpy as np
import pandas as pd
import statsmodels.api as sm
import math
import functools
import matplotlib.pyplot as plt


FILES_PATH='files/'

def read_filelist(filelist='filelist'):
    df = pd.read_csv(FILES_PATH+filelist)
    df['file_path'] = FILES_PATH+df['file_path']
    return df

def list_experiments():
    return read_filelist().groupby(['sample','experiment']).groups.keys()

def load_experiment(sample, experiment, filelist='filelist'):
    df = read_filelist(filelist=filelist)
    df.drop(df[(df['sample']!=sample) | (df['experiment']!=experiment)].index,
            inplace=True)
    df.sort_values('set', inplace=True, ignore_index=True)
    return df


def load_femtik(path, femtik_colnames=None, **kwargs):
    with open(path) as f:
        first_line = f.readline()
    
    if first_line[0] in "#A": #there is header. always comment or "Alpha"
        return pd.read_csv(path, sep=' ', header=0, names=femtik_colnames)
    else:
        return pd.read_csv(path, sep=' ', header=None, names=femtik_colnames)

def load_example(path, **kwargs):
    return pd.DataFrame({'phih':[0,90,180],'A-B':[0,1,0.2],'A+B':[1,0.9,1.1]})

def load_py_legacy(path, **kwargs):
    raise NotImplementedError
 
# MolzillaFile class
####################

class MolzillaFile:
    default_opts = {}
    def __init__(self, path, **opts):
        self.path = path
        self.opts = self.default_opts | opts

    def preprocess(self, **kwargs):
        self.default_preprocess(**kwargs)

    def default_preprocess(self, **kwargs):
        '''This is to be overriden by child classes
        But provides a sensible default, so child can only set self.opts
        Should return self'''
        def_opts = {'split_col': 'phih',
                    'throw_unfinished': True,
                    'subs_cols': ['A-B'],
                    'subs_col_by': 'phih',
                    'sym_h_cols_dict': {'phih':'angle','A-B':'avg','A+B':'avg'},
                    'normalize_col': 'A-B',
                    'normalize_by_col': 'A+B',
                    'normalize_method': 'intensity',
                    'keep_and_rename': {'phih':'phih','A-B':'rotation','A+B':'intensity'},
                    'symmetrize_h': True}
        opts = def_opts | self.opts | kwargs #default is overriden first by self.opts, then kwargs
        
        self.average_cycles(**opts)
        self.substract_endpoints(**opts)
        self.substract_mean(**opts)
        if opts['symmetrize_h']: self.symmetrize_h(**opts)
        self.normalize(**opts)
        
        self.data = self.data[opts['keep_and_rename'].keys()]
        self.data.rename(columns=opts['keep_and_rename'], inplace=True)

        return self

    def load(self, **kwargs):
        def_opts = {'file_format':'femtik'}
        opts = def_opts | self.opts | kwargs
        load_fun = {'example': load_example,
                    'femtik': load_femtik,
                    'py_legacy': load_py_legacy}
        self.data = load_fun[opts['file_format']](self.path, **opts)

    def default_plot(self, ax, y='A-B'):
        return ax.plot(self.data['phih'], self.data[y])


    def average_cycles(self, split_col='phih', throw_unfinished=True, **kwargs):
        split_data = self.split_cycles(split_col=split_col, throw_unfinished=throw_unfinished, **kwargs)
        self.data = functools.reduce(lambda x,y: x.add(y.reset_index(drop=True), fill_value=0),split_data)
        self.data.iloc[0:len(split_data[-1])]/=len(split_data)
        self.data.iloc[len(split_data[-1]):]/=len(split_data)-1

    def split_cycles(self, split_col='phih', throw_unfinished=True, **kwargs):
        '''
        Returns list of dataframes split by cycles of split_col
        '''
        period = self.detect_period(self.data[split_col])
        number = (math.floor if throw_unfinished else math.ceil)(len(self.data)/period)
        return list(map(lambda i: self.data.iloc[(i*period):((i+1)*period)] ,range(number)))

    @staticmethod
    def detect_period(col):
        '''Checks col for possible periods, 
        returns shortest if found, otherwise full length'''
        adepts = np.where(col == col[0])[0][1:] #find duplicate occurences of first element
        def check_period(adept): #check if truly period
            for start_point in range(adept, len(col), adept):
                test = col[start_point:(start_point+adept)]
                if not np.array_equal(test, col[:len(test)]):#allow unfinished last cycle
                    return False
            return True
        for adept in adepts: #check each
            if check_period(adept):
                return adept #return smallest
        return len(col) #if not found            

    def symmetrize_h(self, sym_h_cols_dict=None, sym_h_method='naive', **kwargs):
        sym_h_fun = {'naive': self._sym_h_naive}
        sym_h_cols_dict = {'phih':'angle', 'A-B':'avg'} if sym_h_cols_dict is None else sym_h_cols_dict
        sym_h_cols_dict = {col: 'leave' for col in self.data.columns} | sym_h_cols_dict
        self.data = sym_h_fun[sym_h_method](self.data, sym_h_cols_dict, **kwargs)

    @staticmethod
    def _sym_h_naive(data, cols_dict, **kwargs):
        '''separates data in half. returns average inplace and difference in extra col (-)
        needs data with even length, otherwise deletes last'''
        len_half = int(len(data)/2)
        second_half = data[len_half:2*len_half].reset_index(drop=True)
        for c, role in cols_dict.items():
            if role == 'leave':
                data["(-) "+c] = second_half[c]
            elif role == 'avg':
                data["(-) "+c] = data[c] - second_half[c]
                data[c] = 0.5 * (data[c] + second_half[c])
            elif role == 'angle':
                data["(-) "+c] = data[c] - (second_half[c] - 180)
                data[c] = 0.5 * (data[c] + (second_half[c] - 180))
        data.drop(data.index[len_half:], inplace=True)
        return data
            

    def substract_linear(self, subs_col='A-B', subs_col_by='phih', **kwargs):
        X = sm.add_constant(self.data[subs_col_by])
        model = sm.OLS(self.data[subs_col], X)
        res = model.fit()
        self.data[subs_col] -= res.fittedvalues

    def substract_endpoints(self, subs_cols='A-B', subs_col_by='phih', **kwargs):
        if not isinstance(subs_cols, list): #subs_col can be a list of cols
            subs_cols = [subs_cols]
        col_by_normalized = ((self.data[subs_col_by]
                             - self.data[subs_col_by].iloc[0]) 
                             / self.data[subs_col_by].iloc[-1] - 0.5)
        for col in subs_cols: #substract each specified column
            substract_col = (self.data[col].iloc[-1]
                             - self.data[col].iloc[0]) * col_by_normalized
            self.data[col]-= substract_col
        
        self.data.drop(self.data.tail(1).index, inplace=True) #drop last

    def substract_mean(self, subs_cols='A-B', **kwargs):
        if not isinstance(subs_cols, list): subs_cols = [subs_cols]
        for col in subs_cols:
            self.data[col] -= self.data[col].mean()

    def normalize(self, normalize_col='A-B', normalize_method='intensity', normalize_factor=1, **kwargs):
        normalize_fun = {'intensity': self._normalize_intensity,
                         'by_col_mean': self._normalize_by_col_mean,
                         'factor': self._normalize_factor}
        self.data[normalize_col] /= normalize_factor * normalize_fun[normalize_method](**kwargs)

    def _normalize_intensity(self, normalize_by_col='A+B', **kwargs):
        return 2*self._normalize_by_col_mean(normalize_by_col=normalize_by_col, **kwargs)

    def _normalize_by_col_mean(self, normalize_by_col = 'A+B', **kwargs):
        return self.data[normalize_by_col].mean()

    def _normalize_factor(self, **kwargs):
        return 1

class FileFemtikStandard(MolzillaFile):
    default_opts = {
        'file_format': 'femtik',
        'femtik_colnames': ['phih','A-B','A-B phase','A+B','A+B phase']}

class FileFemtikSwitch(MolzillaFile):
    default_opts = {
        'file_format':'femtik',
        'femtik_colnames': ['phih','A+B','A+B phase','A-B','A-B phase']}

def MolzillaFileFactory(template, path, **opts):
    template_classes = {
        'default': MolzillaFile,
        'femtik_standard': FileFemtikStandard,
        'femtik_switch': FileFemtikSwitch}
    return template_classes[template](path, **opts)


# MeasurementSet class
######################

class MeasurementSet:
    def __init__(self, df_files, f_opts=None):
        '''Expects a specific format of df_files'''
        if f_opts is None: f_opts = {}
        self.df = df_files
        def prep(row):
            return MolzillaFileFactory(
            row['file_template'], row['file_path'], 
            **((row['file_opts'] if 'file_opts' in row else {})|f_opts))
        self.df['obj'] = self.df.apply(prep, axis=1) 


    def __getitem__(self, index):
        return self.df['obj'].iloc[index]

    def load(self, **kwargs):
        for f in self:
            f.load(**kwargs)

    def preprocess(self, **kwargs):
        for f in self:
            f.preprocess(**kwargs)

    def process(self):
        self.default_process()
        return self

    def analyze(self):
        pass

    def default_process(self):
        self.collect_merge()
        self.symmetrize_beta()
        self.fourier2_beta()
        return self

    def collect_merge(self, col='rotation', col_merge_by='phih',
                           index='beta', inplace=True, **kwargs):
        N=1000
        for f in self:
            f.data[col_merge_by] = np.round(N*f.data[col_merge_by]).astype(int)
        new_data = functools.reduce(
            lambda x,y: pd.merge(x ,y, how='outer', on=col_merge_by),
            map(
                lambda tupl: (tupl[0].data[[col_merge_by, col]].rename(columns={col:tupl[1]})), 
                zip(self.df['obj'], self.df[index])
            ),
            pd.DataFrame(columns=[col_merge_by]))

        for f in self:
            f.data[col_merge_by] /=N
        new_data[col_merge_by] /=N

        if inplace: self.data = new_data
        return new_data

    def symmetrize_beta(self, inplace=True):
        #first find those that have duplicate +180
        betas = self.data.drop('phih', axis=1).columns
        cols = {}
        for beta in betas:
            if beta-180 in betas: cols[beta-180] += [beta]
            else: cols |= {beta: [beta]}

        new_data = pd.DataFrame(columns=['phih']+list(cols.keys()))
        for col, subcols in cols.items():
            new_data[col] = np.zeros(shape=len(self.data))
            for subcol in subcols:
                new_data[col] += self.data[subcol]
            new_data[col] /= len(subcols)
        new_data['phih'] = self.data['phih']
        if inplace: self.data = new_data
        return new_data

    @property
    def betas(self):
        return self.data.drop('phih', axis=1).columns

    def fourier2_beta(self, inplace=True):
        betas = self.betas
        betas_num = np.array(betas, dtype=float)
        c = np.cos(2*np.radians(betas_num)) / len(betas) * 2
        s = np.sin(2*np.radians(betas_num)) / len(betas) * 2
        new_data = pd.DataFrame({'phih': self.data['phih'],
                                 0.: np.zeros(len(self.data)),
                                 45.: np.zeros(len(self.data))})
        new_data['phih'] = self.data['phih']
        for col, cn, sn in zip(betas, c, s):
            new_data[0.] += self.data[col]*cn
            new_data[45.] += self.data[col]*sn

        if inplace: self.data = new_data
        return new_data

    def plot_all(self, ax=None, **kwargs):
        if ax is None:
            fig, ax = plt.subplots()
        for beta in self.betas:
            self.data.plot(x='phih', y=beta, label=beta, ax=ax)
        ax.legend()


class SetRotmld(MeasurementSet):
    def analyze(self):
        self.fit_anisotropy = FitCubic(self.data, hext=self.hext)
        self.fit_anisotropy.fit()
        return self.fit_anisotropy

class SetRotmldStokes(SetRotmld):
    def __init__(self, df_files):
        super().__init__(df_files, f_opts={'normalize_method': 'factor'})

    def process(self):
        self.collect_merge()
        self.stokes_dbeta()
        self.stokes_dchi()
        self.stokes_rotation()

    def stokes_rotation(self, inplace=True):
        new_data = pd.DataFrame()
        new_data['phih'] = self.data['phih']
        new_data[0.] = self.data[0.] - self.data[90.]

    def stokes_dbeta(self):
        def f(row):
            sens = pd.read_csv(row['f_sens'], index_col=0)
            ols = sm.OLS(sens['A-B X'],sm.add_constant(sens['Beta']))
            res = ols.fit()
            return np.degrees(res.params['Beta']) #prevadi se 1/deg na 1/rad
        self.df['dbeta'] = self.df.apply(f, axis=1)

    def stokes_combine_rows(self, row1, row2):
        db1 = self.df[self.df['beta']==row1]['dbeta']
        dc1 = self.df[self.df['beta']==row1]['dchi']
        db2 = self.df[self.df['beta']==row2]['dbeta']
        dc2 = self.df[self.df['beta']==row2]['dchi']
        r1 = self.data[row1]
        r2 = self.data[row2]

        return (r1*dc2 + r2*dc1)



    def stokes_dchi(self):
        def f(row):
            full = pd.read_csv(row['f_full'], index_col=0)
            def pars(col):
                ols = sm.OLS(full[col],sm.add_constant(
                        pd.DataFrame({'cos': np.cos(2*np.radians(full['Beta'])),
                                      'sin': np.sin(2*np.radians(full['Beta']))}
                                    )))
                res = ols.fit()
                return res.params['const']**2 / (res.params['cos']**2 + res.params['sin']**2) 
            return (np.sqrt(max(pars('A')-1,0)) * np.sqrt(max(pars('B')-1,0)))**0.5 / np.sqrt(1-pars('A-B')) * row['dbeta']

        self.df['dchi'] = self.df.apply(f, axis=1)


class SetFieldCooling(MeasurementSet):
    pass

def MeasurementSetFactory(template, df_files):
    template_classes = {
        'rotmld': SetRotmld,
        'rotmld_stokes': SetRotmldStokes,
        'field_cooling': SetFieldCooling}
    return template_classes[template](df_files)


