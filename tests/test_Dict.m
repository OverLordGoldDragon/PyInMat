Dict = @pyinmat.Dict;
isin = pyinmat.gen_utils.isin;


dc = Dict(a=1, b=2);

% keys
assert(isin('a', dc.keys()))
assert(isin('b', dc.keys()))

% access
assert(dc('a') == 1)
assert(dc('b') == 2)

% insert different key kind
dc(0) = "yes";
assert(isin(0, dc.keys()))
assert(dc(0) == "yes")

% update
dc.update(Dict(a=2, c=-1))
assert(isin('c', dc.keys()))
assert(dc('a') == 2)

% advanced update, multiple key types, nested dicts
dc1 = Dict(a=2);
dc1(0) = "dog";
dc1("dog") = 0;
dc1("cat") = Dict(g=0);
dc.update(dc1)
assert(isin(0, dc.keys()))
assert(dc(0) == "dog")
assert(isin("dog", dc.keys()))
assert(dc("dog") == 0)

% copy after adding lots of stuff
dcc = dc.copy();
assert(dcc(0) == "dog")

% pop
out = dc.pop(0);
assert(out == "dog")
assert(~isin(0, dc.keys()))

out = dc.pop("dog");
assert(out == 0)
assert(~isin("dog", dc.keys()))

% pprint
dc.pprint()

% {key: val} syntax
dc = Dict(0, "dog");
assert(dc(0) == "dog")
