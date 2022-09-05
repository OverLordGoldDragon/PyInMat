% string methods -------------------------------------------------------------
[pystrip, pylstrip, pyrstrip] = pyinmat.from_import(...
    'pystrip', 'pylstrip', 'pyrstrip');

% test different scenarios
s = "the big dog";
assert(pystrip( s, "the") == " big dog")
assert(pylstrip(s, "the") == " big dog")
assert(pyrstrip(s, "the") == s)
assert(pystrip( s, "dog") == "the big ")
assert(pylstrip(s, "dog") == s)
assert(pyrstrip(s, "dog") == "the big ")

% ensure original type is preserved
o = pystrip(char(s), "dog");
assert(class(o) == "char")
assert(string(o) == "the big ")
