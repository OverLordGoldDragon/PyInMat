function varargout = from_import(varargin)
    M = containers.Map();
    M('List') = @pyinmat.List;
    M('Dict') = @pyinmat.Dict;

    M('dict') = pyinmat.funcs.dict;
    M('dict2str') = pyinmat.funcs.dict2str;
    M('showdict') = pyinmat.funcs.showdict;

    M('ifelse') = pyinmat.funcs.ifelse;
    M('ndim') = pyinmat.funcs.ndim;
    M('isin') = pyinmat.funcs.isin;

    M('ValueError') = pyinmat.exceptions.ValueError;
    M('TypeError') = pyinmat.exceptions.TypeError;
    M('KeyError') = pyinmat.exceptions.KeyError;
    M('NotImplementedError') = pyinmat.exceptions.NotImplementedError;

    varargout = cell(nargin, 1);
    for k = 1:nargin
        varargout{k} = M(varargin{k});
    end
end
