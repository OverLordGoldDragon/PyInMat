classdef Exceptions
    properties
        lib_name
    end

    methods(Access = private)
        function out = exception_(self, err_name, msg)
            memo = sprintf("%s:%s", self.lib_name, err_name);
            errmsg = sprintf("%s: %s", string(err_name), join(string(msg)));
            out = MException(memo, errmsg);
        end

    end

    methods
        function self = Exceptions(lib_name)
            if nargin == 0
                lib_name = "PyInMat";
            end
            self.lib_name = lib_name;
        end

        function ValueError(self, msg)
            if nargin == 1
                msg = '';
            end
            throw(self.exception_('ValueError', msg))
        end
        
        function TypeError(self, msg)
            if nargin == 1
                msg = '';
            end
            throw(self.exception_('TypeError', msg))
        end
        
        function KeyError(self, msg)
            if nargin == 1
                msg = '';
            end
            throw(self.exception_('KeyError', msg))
        end
        
        function NotImplementedError(self, msg)
            if nargin == 1
                msg = '';
            end
            throw(self.exception_('NotImplementedError', msg))
        end
    end
end
