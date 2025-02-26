local cfg_args = require("./cfg_args");

print();
print("\27[36m" .. "[PARSER START]" .. "\27[0m");

type Grammar = {};

local function string_exists_in_grammer(str: string, grammar: Grammar): (boolean)

end

local grammar_src, grammar_input_src = cfg_args.parse_args(...);

print(grammar_src);
print();
print(grammar_input_src);
