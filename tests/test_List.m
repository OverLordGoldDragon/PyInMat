List = @pyinmat.List;
assert_and_restore = TestListUtils.assert_and_restore;

lst0 = List(1, 2, 3);
lst = lst0.copy();
lsts = {lst, lst0};

% copy
assert_and_restore(lst == lst0, lsts)

% append
lst.append(-1)
assert_and_restore(lst == List(1, 2, 3, -1), lsts)
lst.append([1 2 3])
assert_and_restore(lst == List(1, 2, 3, [1 2 3]), lsts)

% extend
lst.extend([-1 -2 -3])
assert_and_restore(lst == List(1, 2, 3, -1, -2, -3), lsts)
lst.extend(List(-1, -2, -3))
assert_and_restore(lst == List(1, 2, 3, -1, -2, -3), lsts)

% pop
num = lst.pop();
assert(num == 3)
assert(lst == List(1, 2))
num = lst.pop(1);
assert(num == 1)
assert_and_restore(lst == List(2), lsts)
num = lst.pop(-2);
assert(num == 2)
assert_and_restore(lst == List(1, 3), lsts)

% indexing
assert(lst(1) == 1)
assert(lst(-1) == 3)
lst(3) = -1;
assert_and_restore(lst == List(1, 2, -1), lsts)

% insert (also non-numeric)
lst.insert(1, "yes")
assert_and_restore(lst == List("yes", 1, 2, 3), lsts)

% reversed
assert(lst.reversed() == List(3, 2, 1))
assert(lst == List(1, 2, 3))  % shouldn't change original

% reverse
lst.reverse()
assert_and_restore(lst == List(3, 2, 1), lsts)

% length, numel, size
assert(length(lst) == numel(lst))
sz = size(lst);
assert(sz(2) == numel(lst))

% plus
lst = lst + lst;
assert_and_restore(lst == List(1, 2, 3, 1, 2, 3), lsts)
