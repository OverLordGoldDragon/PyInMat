function varargout = from_import(varargin)
    varargout = cell(nargin, 1);
    for k = 1:nargin
        name = varargin{k};
        switch name
            % Data structures -------------------------------------------------
            case 'List'
                o = @pyinmat.List;
            case 'Dict'
                o = @pyinmat.Dict;
		    
            % Data structure helpers
            case 'dict'
                o = pyinmat.funcs.dict;
            case 'dict2str'
                o = pyinmat.funcs.dict2str;
            case 'showdict'
                o = pyinmat.funcs.showdict;
		    
            % Funcs -----------------------------------------------------------
            % Misc funcs
            case 'ifelse'
                o = pyinmat.funcs.ifelse;
            case 'ndim'
                o = pyinmat.funcs.ndim;
            case 'isin'
                o = pyinmat.funcs.isin;
            case 'set_if_None'
                o = pyinmat.funcs.set_if_None;
		    
            % String methods
            case 'pystrip'
                o = pyinmat.funcs.pystrip;
            case 'pylstrip'
                o = pyinmat.funcs.pylstrip;
            case 'pyrstrip'
                o = pyinmat.funcs.pyrstrip;
             
            % Numpy
            case 'np_linspace'
                o = pyinmat.funcs.np_linspace;
		    
            % Exceptions ------------------------------------------------------
            case 'ValueError'
                o = pyinmat.exceptions.ValueError;
            case 'TypeError'
                o = pyinmat.exceptions.TypeError;
            case 'KeyError'
                o = pyinmat.exceptions.KeyError;
            case 'NotImplementedError'
                o = pyinmat.exceptions.NotImplementedError;
		    
            % Visuals ---------------------------------------------------------
            case 'vplot'
                o = pyinmat.viz_primitives.vplot;
            case 'vscat'
                o = pyinmat.viz_primitives.vscat;
            case 'vimshow'
                o = pyinmat.viz_primitives.vimshow;
            case 'vplotscat'
               o = pyinmat.viz_primitives.vplotscat;

            % Visuals helpers
            case 'maybe_show'
               o = pyinmat.viz_primitives.maybe_show;
            case 'get_fig_ax'
               o = pyinmat.viz_primitives.get_fig_ax;
        end
        varargout{k} = o;
    end
end
