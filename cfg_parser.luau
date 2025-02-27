local cfg_args = require("./cfg_args");
local cfg_grammar = require("./cfg_grammar");

print("\n------ [PARSER START] -----");

local grammar_src, grammar_input_src = cfg_args.parse_args(...); -- Parse program args
local grammar = cfg_grammar.create_from_src(grammar_src); -- Create grammar
cfg_grammar.print(grammar);

local lines = string.split(grammar_input_src, "\n"); -- Get each input line
for _, line in pairs(lines) do
    local result = cfg_grammar.string_exists_in(line, grammar); -- Does string exist in the given grammar?
    print(string.format("%s: %s", line, result and "Accept" or "Reject")) -- Output result
end

-- local function string_exists_in_grammer(str: string, grammar: Grammar): (boolean)
--     if str == "" or str == "e" then
--         for _, result in grammar.rules[grammar.start] do
--             if result == "e" then return true; end
--         end
--         return false;
--     end

--     local len = #str;
--     local cache: Array<Array<string>> = table.create(len, table.create(len));

--     for i = 1, len do
--         for var, _ in grammar.vars do
--             local char = string.sub(str, i, i);
--             local results = grammar.rules[var];
--             if results and table.find(results, char) then
--                 cache[i][i] = char;
--             end
--         end
--     end

--     for l = 2, len do
--         for i = 1, len - l + 1 do
--             local j = i + l - 1;
--             for k = i, j - 1 do
--                 for var, rule in grammar.rules do
                    
--                 end
--             end
--         end
--     end

--     return cache[1][len] == grammar.start;
-- end
