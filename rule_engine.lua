
local match_type = {}
local function match(name, pred) 
    assert(name, "must provide a name")
    assert(name ~= '', "name must not be ''")
    assert(pred, "must have predicate")
    assert(type(pred) == "function", "predicate must be funcion")

    return { type = match_type
           , name = name
           , pred
           }
end

local alt_type = {}
local function alt(rules)
    return {type = alt_type, rules = rules}
end

local zero_type = {}
local function zero_or_more(rule)
    return {type = zero_type, rule = rule}
end

local one_type = {}
local function one_or_more(rule)
    return {type = one_type, rule = rule}
end

local capture_type = {}
local function capture(name, rule)
    return {type = capture_type, name = name, rule = rule}
end

local rule_type = {}
-- (rule|match)+  => output
local function rule(name, rules, output)
    assert(name, "must include name")
    assert(name ~= '', "name must not be the empty string")
    assert(rules, "must include rules")
    assert(#rules ~= 0, "must include rules")
    assert(output, "must include output")

    return { type = rule_type
           , name = name
           , rules = rules
           , output = output
           }
end

local function find(a, t) 
    local ret = {}
    for _, v in ipairs(a) do
        if v.type == t then
            ret[#ret+1] = v
        end
    end
    return ret
end

local function create_dict(a) 
    local ret = {}
    for _, v in ipairs(a) do
        ret[v.name] = v
    end
    return ret
end

local def_type = {}
local function def(items)
    local env = {}
    
    local matches = find(items, match_type)
    local rules = find(items, rule_type)

    env.matches = create_dict(matches)
    env.rules = create_dict(rules)

    local entry = env.rules["main"]
    assert(entry, "need entry point 'main'")

    return {type = def_type, env = env, entry = entry}
end

local rule_ref_type = {}
local function rule_ref(name)
    return {type = rule_ref_type, name = name}
end

local match_ref_type = {}
local function match_ref(name)
    return {type = match_ref_type, name = name}
end

local sub = string.sub
local at = function (s, i) return sub(s, i, i) end

local function check_rule(rule, env, input, index) -- : (success:bool, index:int, capture:(name,value))
    if rule.type == match_ref_type then
        local m = env[rule.name]
        if m.pred(at(input,index)) then 
            return m.pred, index + 1 
        else
            return false, index
        end
    elseif rule.type == rule_ref_type then
        local r = env[rule.name]
        local temp_index = index
        for _, v in ipairs(rule.rules) do
            local success, temp_index, captures = check_rule(v, env, input, temp_index)
        end
    elseif rule.type == alt_type then

    elseif rule.type == zero_type then

    elseif rule.type == one_type then

    elseif rule.type == capture_type then
    --track entry and exit index value to grab capture value

    else
        error "unknown type encountered"
    end
end

local function eval(d, input)
    assert( d, "need definition")
    assert( d.type == def_type, "need definition" )
    assert( input, "need input")
    assert( type(input) == "string", "input should be a string")
    
    local env = d.env
    local entry = d.entry

    

    
    print(d) 
end


return { rule = rule
       , alt = alt
       , zero_or_more = zero_or_more 
       , one_or_more = one_or_more
       , def = def
       , match = match
       , capture = capture 
       , rule_ref = rule_ref
       , match_ref = match_ref
       , eval = eval 
       }
