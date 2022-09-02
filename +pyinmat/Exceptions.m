classdef exceptions
    properties(Constant)
        ValueError = @ValueError;
        TypeError = @TypeError;
        KeyError = @KeyError;
        NotImplementedError = @NotImplementedError;
    end
end


function ValueError(msg)
    if nargin == 0
        msg = '';
    end
    throw(exception_("ValueError", msg))
end

function TypeError(msg)
    if nargin == 0
        msg = '';
    end
    throw(exception_("TypeError", msg))
end

function KeyError(msg)
    if nargin == 0
        msg = '';
    end
    throw(exception_("KeyError", msg))
end

function NotImplementedError(msg)
    if nargin == 0
        msg = '';
    end
    throw(exception_("NotImplementedError", msg))
end


function out = exception_(err_name, msg, lib_name)
    if nargin == 2
        lib_name = "PyInMat";
    end
    memo = sprintf("%s:%s", lib_name, err_name);
    errmsg = sprintf("%s: %s", string(err_name), join(string(msg)));
    out = MException(memo, errmsg);
end
