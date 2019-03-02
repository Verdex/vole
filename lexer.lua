
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

local blah = def{
    match("comma", ','),
    match("semi", ';'),

    rule("cs", {m(','), m(';')}, ikky("cs") ),
    rule("sc", {m(';'), m(',')}, ikky( "sc") ),
    rule("main", {r( 'cs' ), r ('sc')}, ikky( "main") )
}

eval(blah, "blah")