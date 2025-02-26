local cfg_args = require("./cfg_args");

print();
print("\27[36m" .. "*PARSER START*" .. "\27[0m");

local grammar_src, grammar_input_src = cfg_args.parse_args(...);
local input_lines = string.split(grammar_input_src, "\n");
for _, line in input_lines do
    print(string.format("Line: %s", line));
end
