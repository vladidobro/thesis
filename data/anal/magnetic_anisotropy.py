import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import scipy.optimize

import math, cmath
import collections.abc

class FreeEnergy:
    '''
    F=sum value*-0.5exp(-i*key*phim) + c.c.
    k is a dict with key=frequency, value=coef
    allowed frequencies are integers >=1
    '''
    def __init__(self, k=None, k_canon=None):
        if k is not None:
            self.k = k
        elif k_canon is not None:
            self.k_canon = k_canon
        else:
            self.k = {}

    @classmethod
    def single(cls, h, f=1):
        '''Constructor for only one term'''
        return cls(k={f: h})

    @classmethod
    def hext(cls, phih, hext=1):
        '''Constructor for ext field'''
        return cls.single(cls._polar2comp(phih, hext, f=1), f=1)
        
    def __call__(self, phim, derivative=0, m=None):
        '''
        Compute value at phim (in radian)
        Optionally m can be supplied for more efficient computation, which is a dict similar to F
        value=exp(i*key*phim)
        detivative can be number or list of derivatives to compute,
        if list, returned is list
        '''
        
        if m is None:
            m={}
        for f in self.k:
            if f not in m:
                m[f] = self._phim2m(phim, f)
        
        if isinstance(derivative, collections.abc.Iterable):
            return list(map(lambda d: self._call_simple(m, d), derivative))
        else:
            return self._call_simple(m, derivative)

    def __add__(self, other):
        return FreeEnergy(k={key: self.k.get(key, 0) + other.k.get(key, 0)
            for key in set(self.k) | set(other.k)})

    def __mul__(self, c):
        return FreeEnergy(k={key: c*self.k[key] for key in self.k})
    __rmul__=__mul__

    def rotate(self, angle):
        return FreeEnergy(k={key: self._polar2comp(angle, radius=1, f=key)*self.k[key] for key in self.k})


    @property
    def k_canon(self):
        ku, phiu = (0, 0) if 2 not in self.k else (self._comp2polar(2*self.k[2], f=2))
        kc, phic = (0, 0) if 4 not in self.k else (self._comp2polar(8*self.k[4], f=4))
        phiu, phic = np.degrees(phiu), np.degrees(phic)
        return {'ku': ku, 'phiu': phiu, 'kc': kc, 'phic': phic}

    @k_canon.setter
    def k_canon(self, kdict):
        self.k={}
        self.k[2] = self._polar2comp(0 if 'phiu' not in kdict else np.radians(kdict['phiu']),
                0 if 'ku' not in kdict else kdict['ku']/2, f=2)
        self.k[4] = self._polar2comp(0 if 'phic' not in kdict else np.radians(kdict['phic']),
                0 if 'kc' not in kdict else kdict['kc']/8, f=4)

    def _call_simple(self, m, derivative=0):
        return 2*sum(map(lambda f: self.k[f]*m[f]*(-1j*f)**derivative, self.k)).real

    def find_min(self, pivot, method='minf', **kwargs):
        '''
        Find minimum close to phim=pivot (intended to be phih)
        using a optionally given method (default is minimize F)
        '''
        methods={'minf': self._min_minf, 
                 'torq': self._min_torq,
                 'tayl': self._min_tayl,
                 'pade': self._min_pade,
                 'recu': self._min_recu}
        res = methods[method](pivot, **kwargs)
        return res.x


    def phih2phim(self, phihs, h=None, hext=1, **kwargs):
        '''
        For list of phihs returns list of phims
        Optional kwargs are passed to backend
        Optionally list of complex numbers h can be provided for speed
        These are added to k as {1: h}.
        If it is not provided, it is computed using the amplitude hext
        '''
        if h is None:
            h = map(lambda p: self._polar2comp(p, radius=hext, f=1), phihs)
       
        phim = [0]*len(phihs)
        for i, (t_p, t_h) in enumerate(zip(phihs,h)):
            phim[i]=(self+FreeEnergy.single(t_h, f=1)).find_min(t_p, **kwargs)

        return phim

    def _min_minf(self, pivot, bnd_range=0.5*math.pi):
        return scipy.optimize.minimize_scalar(lambda p: self(p), bounds=(pivot-bnd_range,pivot+bnd_range), method="bounded")

    def _min_torq(self, pivot):
        raise NotImplementedError

    def _min_tayl(self, pivot):
        raise NotImplementedError

    def _min_pade(self, pivot):
        raise NotImplementedError

    def _min_recu(self, pivot):
        raise NotImplementedError

    @staticmethod
    def _polar2comp(angle, radius=1, f=1):
        return radius*(math.cos(angle*f)+1j*math.sin(angle*f))

    @staticmethod
    def _comp2polar(k, f=1):
        '''Returns r,ang'''
        return abs(k), cmath.phase(k)/f

    @staticmethod
    def _phim2m(phim, f):
        '''phim in radian'''
        return -0.5*(math.cos(phim*f)-1j*math.sin(phim*f))

    def plot(self, ax=None, derivative=0, npoints=100):
        if ax == None:
            fig, ax = plt.subplots()
        phim = np.linspace(0, 2*math.pi, num=npoints)
        f = np.fromiter(map(lambda p: self(p, derivative),phim), np.float)
        return ax.plot(phim, f)

    def plot_phim(self, ax=None, hext=1):
        if ax == None:
            fig, ax = plt.subplots()
        phih = np.linspace(0, 2*np.pi)
        phim = self.phih2phim(phih, hext=hext)
        ax.plot(phih, phim)
