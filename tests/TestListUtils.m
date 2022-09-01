classdef TestListUtils < handle
    properties(Constant)
        assert_and_restore = @assert_and_restore;
    end
end


function assert_and_restore(cond, lsts)
    assert(cond)

    [lst, lst0] = lsts{:};
    lst.data = lst0.data;
end
