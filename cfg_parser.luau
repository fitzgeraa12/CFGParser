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
