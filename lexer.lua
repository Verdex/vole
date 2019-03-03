
local rule_engine = require "rule_engine"


alt = rule_engine.alt
rule = rule_engine.rule
zero_or_more = rule_engine.zero_or_more 
one_or_more = rule_engine.one_or_more
def = rule_engine.def
match = rule_engine.match
capture = rule_engine.capture 
eval = rule_engine.eval
r = rule_engine.rule_ref
m = rule_engine.match_ref

function ikky(v)
    return function(x) return v end
end

function neap(v1)
    return function(v2) return v1 == v2 end
end

local blah = def{
    match("comma", neap ','),
    match("semi", neap ';'),

    rule("cs", {m('comma'), m('semi')}, ikky("cs") ),
    rule("sc", {m('semi'), m('comma')}, ikky( "sc") ),
    rule("main", {r( 'cs' ), r ('sc')}, ikky( "main") )
}

s, i, o = eval(blah, ",;;,")

print(s)
print(i)
for _,v in ipairs(o) do
    print( v )
end
