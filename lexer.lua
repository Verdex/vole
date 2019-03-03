
local rule_engine = require "rule_engine"


alt = rule_engine.alt
rule = rule_engine.rule
zero_or_more = rule_engine.zero_or_more 
one_or_more = rule_engine.one_or_more
def = rule_engine.def
match = rule_engine.match
eval = rule_engine.eval
r = rule_engine.rule_ref
m = rule_engine.match_ref

function ikky(v)
    return function(x) return v .. x[1] end
end

function neap(v1)
    return function(v2) return v1 == v2 end
end

local blah = def{
    match("comma", neap ','),
    match("semi", neap ';'),

    rule("cs", {m('comma'), m('semi')}, ikky("cs") ),
    rule("sc", {m('semi'), m('comma')}, ikky( "sc") ),
    rule("main", {r( 'cs' ), r ('sc')}, function (x) return x[1] .. "*" .. x[2] end )
}

local ab = def {
    match( "a", neap "a" ),
    match( "b", neap "b" ),

    rule( "a_or_b", { alt{ m 'a', m 'b' } }, ikky("a or b") ),

    rule( "main", { r 'a_or_b' }, function (x) return x[1] end ),
}
local sub = string.sub
local at = function (s, i) return sub(s, i, i) end

s, i, o = eval(blah, ",;;,", at)

print(s)
print(i)
print(o)



s, i, o = eval(ab, "a", at)

print(s)
print(i)
print(o)

s, i, o = eval(ab, "b", at)

print(s)
print(i)
print(o)
