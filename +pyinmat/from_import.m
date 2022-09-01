function varargout = from_import(varargin)
    M = containers.Map();
    M('List') = @pyinmat.List;
    M('Dict') = @pyinmat.Dict;

    varargout = cell(nargin, 1);
    for k = 1:nargin
        varargout{k} = M(varargin{k});
    end
end
