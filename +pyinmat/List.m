classdef List < handle
    % LIST Recreates some of Python's `list`
    %
    %   lst = List(1, 2, "dog");
    %
    % Example:
    % 
    %    lst = List(1, 2, 3);
    %    lst.append("dog")
    %    assert(lst(1) == 1 && lst(-1) == "dog");
    % 
    % Demonstration, with MATLAB indexing, and suppose `lst = [1, 2]`:
    % 
    %  - `lst.append(3)` -> `[1, 2, 3]`
    %  - `lst.append([3, 4])` -> `[1, 2, [3, 4]]`
    %  - `lst.extend([3, 4])` -> `[1, 2, 3, 4]`
    %  - `lst.pop() == 2` -> `[1]`
    %  - `lst.insert(2, "dog")` -> `[1, "dog", 2]`
    %  - `lst(2) == 2`
    %  - `lst = List(1, 2)` initializes `lst` to `[1, 2]`
    %  - `lst.pop(1)` -> `[2]` (pop at index)
    %  - `lst(-1) == 2` (negative indexing)
    %  - `lst + lst == [1, 2, 1, 2]` (concatenation via `+`)
    %  - `lst.reversed() == [2, 1]` (returns copy of reversed list)
    %  - `lst.reverse()` -> `[2, 1]` (reverses the list; makes copy)
    %  - `lst.copy() == [1, 2]` (returns copy of list)
    %  - `length`, `numel`, and `size` were overridden to operate upon `lst.data`,
    %     where stuff is stored
    %  - `end` indexing is forbidden since we can't propagate it to methods. 
    %     Incidentally it's not forbidden as input to methods, e.g. 
    %     `lst.pop(end)` won't error but won't work properly either - since I 
    %     don't know how to forbid it.

    properties
        data;
    end

    methods
        % initialization; call syntax -------------------------------------
        function self = List(varargin)
            self.data = {};
            if nargin > 0
                for k=1:nargin
                    self.append(varargin{k})
                end
            end
        end

        function varargout = subsref(self, x)
            if x(1).type == "()" && length(x) == 1 && ~isempty(x.subs)
                [varargout{1:nargout}] = self.get(x.subs{1});
            else
                [varargout{1:nargout}] = builtin('subsref', self, x);
            end
        end

        % basics -----------------------------------------------------------
        function append(self, x)
            self.data{end + 1} = x;
        end

        function extend(self, x)
            N = length(x);
            self.data{end + N} = [];
            for k=1:N
                self.data{end - N + k} = x(k);
            end
        end

        function out = get(self, idx)
            idx = self.ensure_positive_idx(idx);
            out = self.data{idx};
        end

        function out = pop(self, idx)
            if nargin == 1
                idx = numel(self.data);
            end
            idx = self.ensure_positive_idx(idx);
            out = self.data{idx};
            self.data(idx) = [];
        end

        function insert(self, idx, value)
            idx = self.ensure_positive_idx(idx);
            temp = cell(1, numel(self.data) + 1);
            for k=1:(idx - 1)
                temp{k} = self.data{k};
            end
            for k=(idx + 1):numel(temp)
                temp{k} = self.data{k - 1};
            end
            temp{idx} = value;
            self.data = temp;
        end

        function out = reversed(self, C)
            arguments
                self;
                C.data_only = false;
            end
            d = cell(1, numel(self.data));
            for k=1:numel(d)
                d{k} = self.data{end - k + 1};
            end
            if C.data_only
                out = d;
            else
                out = pyinmat.List();
                out.data = d;
            end
        end

        function reverse(self)
            self.data = self.reversed(data_only=true);
        end

        function out = copy(self, C)
            arguments
                self;
                C.data_only = false;
            end
            d = cell(1, numel(self));
            for k=1:numel(d)
                d{k} = self.data{k};
            end
            if C.data_only
                out = d;
            else
                out = pyinmat.List();
                out.data = d;
            end
        end

        % overloaded ---------------------------------------------------------
        function [] = end(~, ~, ~)
            error("List:EndNotSupported", "List does not support `end`.")
        end

        function out = length(self)
            out = length(self.data);
        end

        function out = numel(self)
            out = numel(self.data);
        end

        function varargout = size(self, varargin)
            [varargout{1:nargout}] = size(self.data, varargin{:});
        end

        function out = plus(a, b)
            out = pyinmat.List();
            for k=1:numel(a)
                out.append(a.get(k));
            end
            for k=1:numel(b)
                out.append(b.get(k));
            end
        end

        function out = eq(a, b)
            out = true;
            if numel(a) ~= numel(b)
                out = false;
            else
                for k=1:numel(a)
                    if a.data{k} ~= b.data{k}
                        out = false;
                        break
                    end
                end
            end
        end
    end

    methods (Access=private)
        function out = ensure_positive_idx(self, idx)
            if idx < 0
                out = numel(self.data) + 1 + idx;
            else
                out = idx;
            end
        end

    end
end
