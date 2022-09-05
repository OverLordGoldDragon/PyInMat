classdef funcs
    properties(Constant)
        dict2str = @dict2str;
        dict = @dict;
        showdict = @showdict;

        ifelse = @ifelse;
        ndim = @ndim;
        isin = @isin;

        pystrip = @pystrip;
        pylstrip = @pylstrip;
        pyrstrip = @pyrstrip;
    end
end


function out = dict(varargin)
    % DICT Python dictionary syntax
    %
    %    out = dict(a=1, mode='fast', arr=[1 2 3], yes=dict(k=2))
    %
    % Show with
    %
    %    disp(dict2str(out))

    % {key: val} syntax, where `key` is numeric
    if ~isempty(varargin) && isnumeric(varargin{1})
        assert(numel(varargin) == 2)
        out = containers.Map(varargin{1}, varargin{2}, 'UniformValues', false);
    % key=val syntax
    else
        out = containers.Map('UniformValues', false);
        current_key = '';
        for i=1:length(varargin)
            if mod(i, 2)
                current_key = varargin{i};
            else
                out(current_key) = varargin{i};
            end
        end
    end
end


function out = dict2str(d, C)
    % DICT2STR
    %
    %    `disp(out)` is like
    %        analytic=true, normalize='l1', paths_exclude=None, r_psi=.70711
    arguments
        d;
        C.delim = ', ';
        C.max_value_length = 50;
    end
    keys = d.keys;
    values = d.values;

    out = "";
    for i=1:length(keys)
        k = keys{i};
        v = values{i};
        % if dict, recurse
        if class(v) == "containers.Map" || contains(lower(class(v)), "dict")
            vs = "dict(" + dict2str(v) + ")";
        % if array, add brackets
        elseif isnumeric(v) && length(v) > 1
            vs = "[" + join(string(v)) + "]";
        % if empty, indicate with "None"
        elseif isempty(v)
            vs = "None";
        % if string, add '' to indicate string
        elseif ismember(class(v), ["string", "char"])
            vs = sprintf("'%s'", join(string(v)));
        % else, stringify
        else
            vs = join(string(v));
        end
        % if too long, trim
        if C.max_value_length && length(vs) > C.max_value_length
            vs = "<" + class(v) + ">";
        end
        out = out + sprintf("%s=%s%s", join(string(k)), join(string(vs)), C.delim);
    end

    % strip delimiter
    for i=1:length(C.delim)
        out = strip(out, 'right', C.delim(i));
    end
end
    

function showdict(d)
    disp(dict2str(d))
end


function out = ifelse(a, cond, b)
    if cond
        out = a;
    else
        out = b;
    end
end


function out = ndim(x)
    sz = size(size(x));
    out = sz(2);
end


function out = isin(value, iter, C)
    arguments
        value;
        iter;
        C.idx_notation = "None";
    end
    if strcmp(C.idx_notation, "None")
        if strcmp(class(iter), "cell")
            C.idx_notation = "{}";
        else
            C.idx_notation = "()";
        end
    end

    out = false;
    for i=1:length(iter)
        switch string(C.idx_notation)
            case "()"
                ivalue = iter(i);
            case "{}"
                ivalue = iter{i};
            otherwise
                ValueError("Invalid idx_notation")
        end
        if isequal(ivalue, value)
            out = true;
            break
        end
    end
end


% string methods -------------------------------------------------------------
function out = pystrip(s, target, C)
    % PYSTRIP MATLAB's `strip` extended to support multiple characters
    arguments
        s;
        target;
        C.side = "both";
    end
    assert(isin(C.side, {'left', 'right', 'both'}))
    assert(isin(class(s), {'string', 'char'}))
    orig_class = class(s);
    s = join(string(s));
    chars = char(s);
    
    % handle separately
    if isin(C.side, {'left', 'both'})
        chars = pystrip_(chars, target, "left");
    end
    if isin(C.side, {'right', 'both'})
        chars = pystrip_(chars, target, "right");
    end

    % cast to original type
    if strcmp(orig_class, "string")
        out = string(chars);
    else
        out = chars;
    end
end


function out = pylstrip(s, target)
    % PYLSTRIP Python's `lstrip`
    out = pystrip(s, target, side="left");
end


function out = pyrstrip(s, target)
    % PYRSTRIP Python's `rstrip`
    out = pystrip(s, target, side="right");
end


function out = pystrip_(chars, target, side)
    % count from left
    n_strip_left = 0;
    if strcmp(side, 'left')
        for k=1:numel(chars)
            c = chars(k);
            if contains(target, c)
                n_strip_left = n_strip_left + 1;
            else
                break
            end
        end
    end
    % count from right
    n_strip_right = 0;
    if strcmp(side, 'right')
        for k=1:numel(chars)
            c = chars(end - k + 1);
            if contains(target, c)
                n_strip_right = n_strip_right + 1;
            else
                break
            end
        end
    end

    if n_strip_left > 0
        chars = chars(n_strip_left + 1:end);
    elseif n_strip_right > 0
        chars = chars(1:end - n_strip_right);
    end
    out = chars;
end
