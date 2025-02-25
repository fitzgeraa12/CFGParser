--!strict

local function trim_quotes(str: string)
    if str == nil or str == "" then
        return str
    end

    -- Remove leading quotes
    while #str > 0 and (string.sub(str, 1, 1) == "'" or string.sub(str, 1, 1) == "\"") do
        str = str:sub(2, #str) -- Remove the first character
    end

    -- Remove trailing quotes
    while #str > 0 and (string.sub(str, #str, #str) == "'" or string.sub(str, #str, #str) == "\"") do
        str = str:sub(1, #str - 1) -- Remove the last character
    end

    return str
end

local args = {...}; -- Get script args
local grammar_src: string = args[1];
assert(type(grammar_src) == "string", "No grammar src provided");
local grammar_input_src: string = args[2];
assert(type(grammar_input_src) == "string", "No grammar input src provided");


