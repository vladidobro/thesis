import numpy as np
import pandas as pd
import statsmodels.api as sm
import math
import functools

def load_femtik(path, femtik_colnames=None, **kwargs):
    '''IMPLEMENT'''
    return pd.read_csv(path, sep=' ', header=0, names=femtik_colnames)

def load_example(path, **kwargs):
    return pd.DataFrame({'phih':[0,90,180],'A-B':[0,1,0.2],'A+B':[1,0.9,1.1]})

def load_py_legacy(path, **kwargs):
    raise NotImplementedError
 
class MolzillaFile:
    def __init__(self, path, **opts):
        self.path = path
        self.opts = opts

    def default_preprocess(self, **kwargs):
        '''This is to be overriden by child classes
        But provides a sensible default, so child can only set self.opts'''
        def_opts = {'file_format': 'femtik',
                    'split_col': 'phih',
                    'throw_unfinished': True,
                    'subs_cols': ['A-B','A+B'],
                    'subs_col_by': 'phih',
                    'sym_h_cols_dict': {'phih':'angle','A-B':'avg','A+B':'avg'},
                    'normalize_col': 'A-B',
                    'normalize_by_col': 'A+B',
                    'normalize_method': 'intensity',
                    'keep_and_rename': {'phih':'phih','A-B':'rotation','A+B':'intensity'}}
        opts = def_opts | self.opts | kwargs #default is overriden first by self.opts, then kwargs
        
        self.default_load(**opts)
        self.average_cycles(**opts)
        self.substract_endpoints(**opts)
        self.symmetrize_h(**opts)
        self.normalize(**opts)
        
        self.data = self.data[opts['keep_and_rename'].keys()]
        self.data.rename(columns=opts['keep_and_rename'], inplace=True)


    def default_load(self, file_format='example', **kwargs):
        def_opts = {'file_format':'femtik'}
        opts = def_opts | self.opts | kwargs
        load_fun = {'example': load_example,
                    'femtik': load_femtik,
                    'py_legacy': load_py_legacy}
        self.data = load_fun[file_format](self.path, **opts)

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
        col_by_normalized = (self.data[subs_col_by]-self.data[subs_col_by].iloc[0]) / self.data[subs_col_by].iloc[-1] - 0.5
        for col in subs_cols: #substract each specified column
            self.data[col]-=(self.data[col].iloc[-1] - self.data[col].iloc[0]) * col_by_normalized
        self.data.drop(self.data.tail(1).index, inplace=True) #drop last

    def substract_mean(self, subs_col='A-B', **kwargs):
        self.data[subs_col] -= self.data[subs_col].mean()

    def normalize(self, normalize_col='A-B', normalize_method='intensity', **kwargs):
        normalize_fun = {'intensity': self._normalize_intensity,
                         'custom': self._normalize_custom,
                         'stokes': self._normalize_stokes}
        self.data[normalize_col] *= normalize_fun[normalize_method](**kwargs)

    def _normalize_intensity(self, normalize_by_col='A+B', **kwargs):
        return 0.5*self._normalize_by_col_mean(normalize_by_col=normalize_by_col, **kwargs)

    def _normalize_by_col_mean(self, normalize_by_col = 'A+B', **kwargs):
        return 1/self.data[normalize_by_col].mean()

    def _normalize_stokes(self, **kwargs):
        raise NotImplementedError

    def _normalize_custom(self, **kwargs):
        raise NotImplementedError

class FileFemtikStandard(MolzillaFile):
    default_opts = {'file_format':'femtik',
                    'femtik_colnames':['phih','A-B','A-B phase','A+B','A+B phase']}
    def __init__(self, path, **opts):
        super().__init__(path, **opts)
        self.opts = self.default_opts | opts
