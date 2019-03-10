
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
local err = require "error"

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
local function digit(c) return regex_match(c, '[0-9]') end
local concat = table.concat
local function concat_matches(ms)
    local t = {}
    for _, v in ipairs( ms ) do
        t[#t+1] = v.text
    end
    return concat( t )
end

local lex_def = rule_engine.def {
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
    match( 'digit', digit ), 

    rule( 'symbol', { m 'start_symbol_char'
                    , zero_or_more( m 'rest_symbol_char' ) 
                    }, 
                    function (x) return { name = "symbol"
                                        , index = x[1].index
                                        , value = x[1].text .. concat_matches( x[2] ) 
                                        } end ),

    rule( 'number', { one_or_more( m 'digit' ) 
                    }, 
                    function (x) return { name = "number"
                                        , index = x[1].index
                                        , value = concat_matches( x[1] ) 
                                        } end ),

    rule( 'main', { zero_or_more( alt{ m 'comma'
                                     , m 'semi'
                                     , m 'colon'
                                     , m 'l_square'
                                     , m 'r_square'
                                     , m 'l_paren'
                                     , m 'r_paren'
                                     , m 'l_curly'
                                     , m 'r_curly'
                                     , m 'dot'
                                     , r 'symbol'
                                     , r 'number'
                                     } ) 
                  }, 
                  function (x) return x[1] end ),
}

local function lex( input )
    local sub = string.sub
    local at = function ( s, i ) return sub(s, i, i) end
    local success, index, output = rule_engine.eval(lex_def, input, at)
    if not success then
        return false, err.error_at(input, index) 
    end
    return true, output
end

x, v = lex(',,;:{.}[]()889blah')

if x then 
    print "success"
    for _,vlet in ipairs( v ) do
        print( vlet.index, vlet.text, vlet.name, vlet.value )
    end
else
    print "failure"
    print( v )
end

