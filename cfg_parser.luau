local cfg_args = require("./cfg_args");

print();
print("----- [PARSER START] -----");

type Array<T> = {[number]: T};
type HashSet = {[string]: boolean};
type HashMap<T> = {[string]: T};

type Grammar = {
    vars: HashSet,
    terminals: HashSet,
    rules: HashMap<Array<string>>,
    start: string
};

local function concat_keys(hash_map: HashMap<any>, separator: string): (string)
    local arr: Array<string> = {};
    for k, _ in hash_map do
        table.insert(arr, k);
        print(string.format("Key: %s", k));
    end

    return table.concat(arr, separator);
end

local function print_grammar(grammar: Grammar): ()
    local vars_string = "Variables: ";
    local first = true;
    for var, _ in grammar.vars do
        if not first then
            vars_string = vars_string .. ", ";
        end

        vars_string = vars_string .. var;
        first = false;
    end

    local terminals_string = "Terminals: ";
    first = true;
    for terminal, _ in grammar.terminals do
        if not first then
            terminals_string = terminals_string .. ", ";
        end

        terminals_string = terminals_string .. terminal;
        first = false;
    end

    print("Variables: " .. concat_keys(grammar.vars, ", "));
    print();
    print("Terminals: " .. concat_keys(grammar.terminals, ", "));
    print();

    print("Rules:");
    print("------");
    for var, results in grammar.rules do
        print(string.format("%s -> ", var) .. table.concat(results, ", "));
    end

    print();
    print(string.format("Start Variable: %s", grammar.start));
end

local function str_array_to_hashset(arr: Array<string>): (HashSet)
    local hashset = {};
    for _, v in arr do
        hashset[v] = true;
    end

    return hashset;
end

local function create_grammar(src: string): (Grammar)
    local lines = string.split(src, "\n");
    local vars = str_array_to_hashset(string.split(assert(lines[1], "No variables line found in grammar source"), ", "));
    local terminals = str_array_to_hashset(string.split(assert(lines[2], "No terminals line found in grammar source"), ", "))

    local rules: HashMap<Array<string>> = {};
    for i = 3, #lines - 1 do
        local rule = lines[i];
        local split_rule = string.split(rule, " -> ");
        local var, result = split_rule[1], split_rule[2];

        local results = string.split(result, " | ");
        
        rules[var] = results;
    end

    print();

    return {
        vars = vars,
        terminals = terminals,
        rules = rules,
        start = lines[#lines]
    };
end

local function string_exists_in_grammer(str: string, grammar: Grammar): (boolean)
    if str == "" or str == "e" then
        for _, result in grammar.rules[grammar.start] do
            if result == "e" then return true; end
        end
        return false;
    end

    local len = #str;
    local cache: Array<Array<string>> = table.create(len, table.create(len));

    for i = 1, len do
        for var, _ in grammar.vars do
            local char = string.sub(str, i, i);
            local results = grammar.rules[var];
            if results and table.find(results, char) then
                cache[i][i] = char;
            end
        end
    end

    for l = 2, len do
        for i = 1, len - l + 1 do
            local j = i + l - 1;
            for k = i, j - 1 do
                for var, rule in grammar.rules do
                    
                end
            end
        end
    end

    return cache[1][len] == grammar.start;
end

local grammar_src, grammar_input_src = cfg_args.parse_args(...);
local grammar = create_grammar(grammar_src);
print_grammar(grammar);

local lines = string.split(grammar_input_src, "\n");
for _, line in lines do
    print(string_exists_in_grammer(line, grammar));
end
