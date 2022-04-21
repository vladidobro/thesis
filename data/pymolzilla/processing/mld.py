from pymolzilla.processing.magnetic_anisotropy import *

import pandas as pd
import numpy as np
import statsmodels.api as sm
import math
import functools
import scipy.optimize as optim

class FitPmld:
    def __init__(self, data, drop='phih'):
        '''data should be only columns to fit
        but phih is dropped automatically'''
        if drop in data:
            data = data.drop(drop, axis=1)
        self.data = data

    def fit(self, phim=None, degrees=False, X=None):
        '''needs phim in radians'''
        if degrees: phim = np.radians(phim)
        if X is None:
            X = pd.DataFrame({'cos2phim': np.cos(2*np.array(phim)), 
                              'sin2phim': np.sin(2*np.array(phim))})
        X = sm.add_constant(X)
        
        def fit_col(col):
            ols = sm.OLS(col, X)
            return ols.fit()
        self.results = self.data.apply(fit_col)
        
        self.ssr = self.results.apply(lambda res: res.ssr).sum()
        self.centered_tss = self.results.apply(lambda res: res.centered_tss).sum()
        self.nobs = self.results.apply(lambda res: res.nobs).sum()
        self.df_resid = self.results.apply(lambda res: res.df_resid).sum()
        self.rsquared = 1-self.ssr/self.centered_tss
        self.rsquared_adj = 1-(self.nobs-1)/self.df_resid*(1-self.rsquared)

        return self.ssr

class FitAnisotropy:
    def __init__(self, df_data, list_f, hext=207, degrees=True):
        '''df_data is with phih column'''
        self.phih = df_data['phih']
        if degrees: self.phih = np.radians(self.phih)
        self.hext = hext
        self.data = df_data.drop('phih', axis=1)
        self.list_f = list_f
        self.pmldfit = FitPmld(self.data)
        self.x0 = np.zeros(shape=len(self.list_f))

    def obj(self, x, inplace=False, ret='ssr'):
        pmldfit = FitPmld(self.data)
        free_energy = self.x2f(x)
        phim = free_energy.phih2phim(self.phih, hext=self.hext)
        pmldfit.fit(phim)

        if inplace:
            self.pmldfit = pmldfit
            self.free_energy = free_energy
            self.phim = phim
        
        ret_vals = {'ssr': pmldfit.ssr,
                    'rsquared': pmldfit.rsquared,
                    'rsquared_adj': pmldfit.rsquared_adj}

        return ret_vals[ret]

    def x2f(self, x):
        f = FreeEnergy()
        for fi, xi in zip(self.list_f, x):
            f += xi*fi
        return f

    def fit(self, niter=3):
        res = optim.basinhopping(self.obj, self.x0, niter=niter)
        self.free_energy = self.x2f(res.x)
        self.results = res
        self.phim = np.degrees(self.free_energy.phih2phim(self.phih, hext=self.hext))

        return res
            



class FitCubic(FitAnisotropy):
    def __init__(self, df_data, hext=207):
        list_f = [FreeEnergy.single(1 , f=2),
                  FreeEnergy.single(1j, f=2),
                  FreeEnergy.single(1 , f=4),
                  FreeEnergy.single(1j, f=4)]
        super().__init__(df_data, list_f, hext=hext)

