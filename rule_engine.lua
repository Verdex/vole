
local match_type = {}
local function match(name, pred) 
    assert(name, "must provide a name")
    assert(name ~= '', "name must not be ''")
    assert(pred, "must have predicate")
    assert(type(pred) == "function", "predicate must be funcion")

    return { type = match_type
           , name = name
           , pred = pred
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

local rule_type = {}
-- (rule|match)+  => output
local function rule(name, rules, output)
    assert(name, "must include name")
    assert(name ~= '', "name must not be the empty string")
    assert(rules, "must include rules")
    assert(#rules ~= 0, "must include rules")
    assert(output, "must include output")
    assert(type(output) == "function", "output must be a function")

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

    return {type = def_type, env = env}
end

local rule_ref_type = {}
local function rule_ref(name)
    return {type = rule_ref_type, name = name}
end

local match_ref_type = {}
local function match_ref(name)
    return {type = match_ref_type, name = name}
end

local function check_rule(rule, env, input, index, at) -- : (success:bool, index:int, output) 
    if rule.type == match_ref_type then
        local m = env.matches[rule.name]
        if m.pred(at(input,index)) then 
            return m.pred, index + 1, { text = at(input, index)
                                      , index = index 
                                      , name = rule.name
                                      }
        else
            return false, index
        end
    elseif rule.type == rule_ref_type then
        local r = env.rules[rule.name]
        local temp_index = index
        local outputs = {}
        for _, v in ipairs(r.rules) do
            local success = false
            local output = false 
            success, temp_index, output = check_rule(v, env, input, temp_index, at)
            if not success then
                return false, index
            end
            if output then
                outputs[#outputs+1] = output
            end
        end
        return true, temp_index, r.output(outputs)
    elseif rule.type == alt_type then
        local rules = rule.rules
        for _, v in ipairs(rules) do
            local success, new_index, output = check_rule(v, env, input, index, at)
            if success then
                return true, new_index, output 
            end
        end 
        return false, index
    elseif rule.type == zero_type then
        local r = rule.rule
        local outputs = {}
        local success, temp_index, output = check_rule(r, env, input, index, at)
        if output then
            outputs[#outputs+1] = output
        end
        while success do
            success, temp_index, output = check_rule(r, env, input, temp_index, at)
            if output then
                outputs[#outputs+1] = output
            end
        end
        return true, temp_index, outputs
    elseif rule.type == one_type then
        local r = rule.rule
        local outputs = {}
        local success, temp_index, output = check_rule(r, env, input, index, at)
        if not success then
            return false, index
        end
        if output then
            outputs[#outputs+1] = output
        end
        while success do
            success, temp_index, output = check_rule(r, env, input, temp_index, at)
            if output then
                outputs[#outputs+1] = output
            end
        end
        return true, temp_index, outputs
    else
        error "unknown type encountered"
    end
end

local function eval(d, input, indexer)
    assert( d, "need definition")
    assert( d.type == def_type, "need definition" )
    assert( input, "need input")
    assert( type(input) == "string", "input should be a string")
    
    local env = d.env
   
    local success, index, output = check_rule(rule_ref 'main', env, input, 1, indexer)  

    if #input ~= index - 1 then
        return false, index
    end

    return success, index, output
end


return { rule = rule
       , alt = alt
       , zero_or_more = zero_or_more 
       , one_or_more = one_or_more
       , def = def
       , match = match
       , rule_ref = rule_ref
       , match_ref = match_ref
       , eval = eval 
       }
