function varargout = from_import(varargin)
    M = containers.Map();
    M('List') = @pyinmat.List;
    M('Dict') = @pyinmat.Dict;
    M('Exceptions') = @pyinmat.Exceptions;

    M('dict') = pyinmat.funcs.dict;
    M('dict2str') = pyinmat.funcs.dict2str;
    M('showdict') = pyinmat.funcs.showdict;

    M('ifelse') = pyinmat.funcs.ifelse;
    M('ndim') = pyinmat.funcs.ndim;
    M('isin') = pyinmat.funcs.isin;

    M('ValueError') = default_exception('ValueError');
    M('TypeError') = default_exception('TypeError');
    M('KeyError') = default_exception('KeyError');
    M('NotImplementedError') = default_exception('NotImplementedError');

    varargout = cell(nargin, 1);
    for k = 1:nargin
        varargout{k} = M(varargin{k});
    end
end


function out = default_exception(name)
    E = Exception();
    M = containers.Map();
    M('ValueError') = @E.ValueError;
    M('TypeError') = @E.TypeError;
    M('KeyError') = @E.KeyError;
    M('NotImplementedError') = @E.NotImplementedError;

    out = M(name);
end
