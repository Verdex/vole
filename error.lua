
local sub = string.sub
local function at(text, index) 
    return sub(text, index, index )
end

local function find_next_endline(text, index)
    local i = index
    local c = at(text, i)
    while c ~= '\n' and c ~= '\r' and c ~= '' do
        i = i + 1
        c = at(text, i)
    end
    return i
end

local function find_prev_endline(text, index)
    local i = index
    local c = at(text, i)
    while c ~= '\n' and c ~= '\r' and c ~= '' do
        i = i - 1
        c = at(text, i)
    end
    return i
end


local function error_at(text, index)
    local middle_end = find_next_endline(text, index)
    local middle_start = find_prev_endline(text, index)  


    local first_end = find_next_endline(text, middle_start - 1)
    local first_start = find_prev_endline(text, middle_start - 1)

    local last_end = find_next_endline(text, middle_end + 1)
    local last_start = find_prev_endline(text, middle_end + 1)

    local middle = sub(text, middle_start + 1, middle_end)
    local first = sub(text, first_start + 1, first_end)
    local last = sub(text, last_start + 1, last_end)

    local arrow = string.rep( '-', index - middle_start - 1 ) .. '^' .. '\n'

    if at(last, #last) ~= '\n' and at(last, #last) ~= '\r' then
        arrow = '\n' .. arrow
    end

    return first .. middle .. arrow .. last
end


return { error_at = error_at } 

