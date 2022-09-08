function varargout = from_import(varargin)
    varargout = cell(nargin, 1);
    for k = 1:nargin
        name = varargin{k};
        switch name
           case 'List'
               o = @pyinmat.List;
           case 'Dict'
               o = @pyinmat.Dict;
        
           case 'dict'
               o = pyinmat.funcs.dict;
           case 'dict2str'
               o = pyinmat.funcs.dict2str;
           case 'showdict'
               o = pyinmat.funcs.showdict;
        
           case 'ifelse'
               o = pyinmat.funcs.ifelse;
           case 'ndim'
               o = pyinmat.funcs.ndim;
           case 'isin'
               o = pyinmat.funcs.isin;
           case 'set_if_None'
               o = pyinmat.funcs.set_if_None;
        
           case 'pystrip'
               o = pyinmat.funcs.pystrip;
           case 'pylstrip'
               o = pyinmat.funcs.pylstrip;
           case 'pyrstrip'
               o = pyinmat.funcs.pyrstrip;
        
           case 'np_linspace'
               o = pyinmat.funcs.np_linspace;
        
           case 'ValueError'
               o = pyinmat.exceptions.ValueError;
           case 'TypeError'
               o = pyinmat.exceptions.TypeError;
           case 'KeyError'
               o = pyinmat.exceptions.KeyError;
           case 'NotImplementedError'
               o = pyinmat.exceptions.NotImplementedError;
        end
        varargout{k} = o;
    end
end
