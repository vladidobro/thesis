

class MLDSet:
    def __init__(self, files):
        pass

class MolzillaFile:
    def __init__(self, path, form, **kwargs)
        self.path = path
        self.form = form
        self.opts = kwargs
    def load(self):
        load_fun = {'femtik': self._load_femtik,
                    'py_legacy': self._load_py_legacy}
        self.data_raw = load_fun[self.form](self.path, **self.opts)

    def _load_femtik(self, path, **kwargs):
        pass

    def _load_py_legacy(self, path, **kwargs):
        pass
