
--[[
    mod x.y.z {
        fun xyz(a,b,c) {
            match x {
                
            }
            if blah {

            }
            elseif blah {

            }
            else {

            }
        }
        ext xyz(a,b,c) {

        }
    }

--]]

local rule_engine = require "rule_engine"


alt = rule_engine.alt
rule = rule_engine.rule
zero_or_more = rule_engine.zero_or_more 
one_or_more = rule_engine.one_or_more
match = rule_engine.match
r = rule_engine.rule_ref
m = rule_engine.match_ref


local regex_match = string.match
local function match_char(c) return function(o) return o == c end end
local function start_symbol_char(c) return regex_match(c, '[a-zA-Z_]') end
local function rest_symbol_char(c) return regex_match(c, '[a-zA-Z_0-9]') end

local lang_def = rule_engine.def {
    match( 'comma', match_char( ',' ) ),
    match( 'semi', match_char( ';' ) ),
    match( 'colon', match_char( ':' ) ),
    match( 'l_square', match_char( '[' ) ), 
    match( 'r_square', match_char( ']' ) ), 
    match( 'l_paren', match_char( '(' ) ), 
    match( 'r_paren', match_char( ')' ) ), 
    match( 'l_curly', match_char( '{' ) ), 
    match( 'r_curly', match_char( '}' ) ), 
    match( 'dot', match_char( '.' ) ),
    match( 'start_symbol_char', start_symbol_char ),
    match( 'rest_symbol_char', rest_symbol_char ),


    rule( 'main', { m 'comma' }, function (x) return x[1] end ),
}


local function parse( input )
    local sub = string.sub
    local at = function ( s, i ) return sub(s, i, i) end
    local success, index, output = rule_engine.eval(lang_def, input, at)
    if not success then
        return false, "error message with index information"
    end
    return true, output
end

x, v = parse(',')

