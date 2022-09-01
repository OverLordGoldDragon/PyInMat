# PyInMat

Python data structures in MATLAB. Because I still want Python!

Not official package, just public code for reference. `List` is `cellarray`, `Dict` is nested `containers.Map`.

More examples in `tests/`.

```matlab
[List, Dict] = pyinmat.from_import('List', 'Dict');
```

```matlab
lst = List(1, 2, 3);
lst.append("dog")
assert(lst(1) == 1 && lst(-1) == "dog");
```
```matlab
dc = Dict(a=1, b=2); 
dc(0) = "dog"; 
assert(dc("b") == 2)
assert(dc.pop("a") == 1)

dc2 = Dict(c=3, d=Dict(d=4))
dc.update(dc2)
assert(dc.get("cat", 3.14159) == 3.14159)
```
Display with `dc.pprint()`
```
b=2, c=3, d=dict(d=4,),
0='dog',
```
