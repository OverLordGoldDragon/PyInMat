classdef Dict < handle
    % DICT Recreates some of Python's `dict`
    %
    %   dc = Dict(a=1, b="dog");
    %
    % Supported Python methods: get, pop, update, keys, values, copy.
    % Additional methods: pprint.
    %
    % Example: 
    % 
    %     dc = Dict(a=1, b=2); 
    %     dc(0) = "dog"; 
    %     out = dc.pop("a"); 
    %     assert(out == 1)
    %     assert(dc(0) == "dog")
    %
    %     dc2 = dc.copy();
    %     dc2("dog") = 0;
    %     dc.update(dc2);
    %
    %     out = dc.get("cat", 3.14159);
    %     assert(out == 3.14159)
    %     out = dc.pop("cat", 3.14159);
    %     assert(out == 3.14159)
    %     dc.pprint()
    %
    %     dc = Dict(0, "dog");  % {0: "dog"} in Python
    %     assert(dc(0) == "dog")
    properties
        data;
    end

    methods
        % initialization; call syntax -------------------------------------
        function self = Dict(varargin)
            init = pyinmat.funcs.dict(varargin{:});
            self.data = pyinmat.funcs.dict();
            self.data(init.KeyType) = init;
        end

        function varargout = subsref(self, x)
            if x(1).type == "()" && length(x) == 1 && ~isempty(x.subs)
                [varargout{1:nargout}] = self.getter(x.subs{1});
            else
                [varargout{1:nargout}] = builtin('subsref', self, x);
            end
        end

        function self = subsasgn(self, x, varargin)
            if isequal(self, [])
                self = pyinmat.Dict.empty;
            end

            if x(1).type == "()" && length(x) == 1 && ~isempty(x.subs)
                self.setter(x.subs{1}, varargin{:});
            else
                self = builtin('subsasgn', self, x, varargin{:});
            end
        end

        % Python methods -----------------------------------------------------
        function out = get(self, key, alt)
            % GET If `key` is found, fetch its value, else return `alt`.
            try
                out = self.getter(key);
            catch
                % if alt is provided, return it, else throw error
                if nargin == 3
                    out = alt;
                else
                    pyinmat.exceptions.KeyError(key);
                end
            end
        end

        function out = pop(self, key, alt)
            % POP Remove key and return its value, or alternative.

            % first check whether the key is present - if not, return alt.
            try
                [~] = self.get(key);
                got_key = true;
            catch
                % if alt is provided, return it, else throw error
                if nargin == 3
                    out = alt;
                    got_key = false;
                else
                    self.get(key);  % throws error
                end
            end

            if got_key
                % iterate over all stored subdicts and pop matching key
                data_ = self.data;
                type_key = self.get_key_class(key);
    
                d = data_(type_key);
                keys = d.keys;
                for j=1:numel(keys)
                    dkey = keys{j};
                    if isequal(dkey, key)
                        out = d(dkey);
                        remove(d, dkey);
                        break
                    end
                end
            end
        end

        function update(self, dsrc)
            % UPDATE Add keys and values from `dsrc` onto `self`.

            % iterate over all stored dicts and subdicts of `dsrc` and fetch keys
            % and values that come first, then set onto `self`
            data_ = self.data;
            sdata_ = dsrc.data;

            type_keys = sdata_.keys;
            for k=1:numel(type_keys)
                % fetch type key, if not in `self` then add
                type_key = type_keys{k};
                if ~pyinmat.funcs.isin(type_key, data_.keys)
                    data_(type_key) = dict();
                end
                
                % fill
                d_from = sdata_(type_key);
                d_onto = data_(type_key);
                keys = d_from.keys;
                for j=1:numel(keys)
                    key = keys{j};
                    d_onto(key) = d_from(key);
                end
            end
        end

        function out = keys(self)
            % KEYS Get all keys. If there are duplicates in value, they differ
            % in type.
            [out, ~] = self.keys_and_values();
        end

        function out = values(self)
            % VALUES Get all values.
            [~, out] = self.keys_and_values();
        end

        function out = copy(self)
            % COPY Shallow copy of self.

            % iterate over all stored dicts and subdicts and fetch keys
            % and values that come first, then set onto newly initialized `Dict`.
            out = pyinmat.Dict();
            data_ = self.data;

            type_keys = data_.keys;
            for k=1:numel(type_keys)
                type_key = type_keys{k};
                out.data(type_key) = containers.Map('KeyType', type_key, ...
                                                    'ValueType', 'any');

                d = data_(type_key);
                d_copy = out.data(type_key);

                keys = d.keys;
                for j=1:numel(keys)
                    key = keys{j};
                    d_copy(key) = d(key);
                end
            end
        end
        
        % quality of life ----------------------------------------------------
        function pprint(self)
            % PPRINT Prettily print all key-value pairs.
            data_ = self.data;

            type_keys = data_.keys;
            for k=1:numel(type_keys)
                type_key = type_keys{k};
                pyinmat.funcs.showdict(data_(type_key));
            end
        end
    end

    methods(Access = private)
        % primitives ---------------------------------------------------------
        function out = getter(self, key, C)
            arguments
                self;
                key;
                C.is_assigning = false;
            end
            data_ = self.data;

            key_class = self.get_key_class(key);

            % iterate through all stored dictionaries; if key or key type
            % isn't found, throw error
            found_key = false;
            found_key_type = (ismember(key_class, data_.keys));  % SLOW
            if found_key_type
                d = data_(key_class);
                keys = d.keys;
                if ~isempty(keys) && strcmp(class(keys{1}), key_class)
                    if pyinmat.funcs.isin(key, keys)  % SLOW
                        out = d(key);
                        found_key = true;
                    end
                end
            end
              % somehow this is slower
%             found_key_type = false;
%             try
%                 d = data_(key_class);
%                 found_key_type = true;
%                 out = d(key);
%                 found_key = true;
%             catch
%                 %
%             end

            if ~found_key
                if C.is_assigning
                    % no match but we're assigning -> create new key / key type
                    if ~found_key_type
                        data_(key_class) = ...
                            containers.Map('KeyType', key_class, ...
                                           'ValueType', 'any');
                    end
                    d = data_(key_class);
                    d(key) = [];  % will assign to in `set`
                    out = [];
                else
                    pyinmat.exceptions.KeyError(key)
                end
            end
        end

        function setter(self, key, value)
            data_ = self.data;
            [~] = self.getter(key, is_assigning=true);

            key_class = class(key);
            if strcmp(key_class, "string")
                key_class = "char";
            end
            d = data_(key_class);
            d(key) = value;
        end

        % helpers ------------------------------------------------------------
        function [keys_out, values_out] = keys_and_values(self)
            % iterate over all stored dicts and subdicts and fetch keys
            % and values that come first, append into cellarray
            keys_out = {};
            values_out = {};

            data_ = self.data;
            type_keys = data_.keys;
            for k=1:numel(type_keys)
                type_key = type_keys{k};

                d = data_(type_key);
                keys = d.keys;
                for j=1:numel(keys)
                    key = keys{j};
                    keys_out{end + 1} = key;
                    values_out{end + 1} = d(key);
                end
            end
        end

        function key_class = get_key_class(self, key)
            key_class = class(key);
            % treated identically but can't make Map with string
            if strcmp(key_class, "string")
                key_class = "char";
            end
        end
    end

end
