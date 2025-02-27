type Table<K, V> = {[K]: V};
export type HashMap<T> = Table<string, T>;

--[[
    An object containing all information about a grammar.
]]
export type Grammar = {
    vars: {string},
    terms: {string},
    rules: HashMap<{{string}}>,
    start: string
};

--[[
    Parses the given rules as an array of lines into a rules object

    @param rule_lines - The lines of rules to be parsed into a rules object
    @return Rules object
]]
local function parse_rules(rule_lines: {string}): (HashMap<{{string}}>)
    local len = #rule_lines;
    local rules: HashMap<{{string}}> = {};

    -- Iterate through expected rule range
    for i = 3, len - 1 do
        local line = rule_lines[i];
        local rule_term, rule_expansion = table.unpack(string.split(line, "->")); -- Separate rule term from expansion
        assert(rule_term and rule_expansion, string.format("Invalid grammar rule: %s", line));

        rules[rule_term] = {};
        local expansion_options = string.split(rule_expansion, "|"); -- Separate by unions
        for _, exp_opt in expansion_options do
            table.insert(rules[rule_term], string.split(exp_opt, "")); -- Separate invidivual terms
        end
    end

    return rules;
end

local function grammar_rule_exists(grammar: Grammar, term: string, expansion_term: string): (boolean)
    local rule = grammar.rules[term];
    if not rule then return false; end

    for _, expansion_option in rule do
        if #expansion_option ~= 1 then continue; end
        if table.find(expansion_option, expansion_term) then return true; end
    end

    return false;
end

--[[
    Applies the given map function to each element in the table and returns an array of the results.
    
    @param t - The table to be mapped
    @param func - The mapping function
    @return An array of results gathered from applying 'func' to each element in 't'
]]
local function map_and_arrayify<K, V, V2>(t: Table<K, V>, func: (k: K, v: V) -> (V2)): ({V2})
    local mapped: {V2} = {};
    for k, v in t do
        table.insert(mapped, func(k, v));
    end

    return mapped;
end

return {
    --[[
        Attempts to create a grammar by parsing the given grammar source.
        
        @param grammar_src - The grammar source as a string
        @return Grammar object
    ]]
    create_from_src = function(grammar_src: string): (Grammar)
        grammar_src = string.gsub(grammar_src, " ", ""); -- Removes spaces from grammar source
        local lines = string.split(grammar_src, "\n"); -- Split into individual lines

        return {
            vars = string.split(assert(lines[1], "No variables line found in grammar source"), ","), -- Split into individual variables
            terms = string.split(assert(lines[2], "No terminals line found in grammar source"), ","), -- Split into individual terminals
            rules = parse_rules(lines), -- Parse rules
            start = lines[#lines] -- Start terminal comes last
        };
    end,

    --[[
        Prints the grammar to the console.
        
        @param grammar_src - The grammar object to print
    ]]
    print = function(grammar: Grammar): ()
        print(string.format("Variables: %s\n", table.concat(grammar.vars, ", ")));
        print(string.format("Terminals: %s\n", table.concat(grammar.terms, ", ")));
        print(string.format("Rules:\n------\n%s\n", table.concat(
            map_and_arrayify(grammar.rules, function(rule_term: string, rule_expansion: {{string}}): (string)
                return rule_term .. " -> " .. table.concat(map_and_arrayify(rule_expansion, function(_, expansion_option: {string}): (string)
                    return table.concat(expansion_option);
                end), " | ")
            end), "\n"
        )));
        print(string.format("Start Variable: %s\n", grammar.start));
    end,

    --[[
        Determines whether a given string exists in a grammar.
        
        @param str - The string to determine
        @param grammar - The grammar to determine if 'str' exists in
    ]]
    string_exists_in = function(w: string, grammar: Grammar): (boolean)
        local n = #w;
        if (n < 1 or w == "e") and grammar_rule_exists(grammar, grammar.start, "e") then return true; end -- S -> e rule?
    
        -- Initialize table
        local tab: {{{string}}} = {};
        for i = 1, n do
            tab[i] = {};
            for j = 1, n do
                tab[i][j] = {};
            end
        end
    
        -- Iterate through characters
        for i = 1, n do
            local char = string.sub(w, i, i); -- 'w_i'
            -- For each 'A'
            for _, var in grammar.vars do
                local rule = grammar.rules[var];
                if not rule then continue; end

                for _, expansion in rule do
                    if #expansion == 1 and expansion[1] == char then -- Expands to the given char?
                        table.insert(tab[i][i], var); -- Add 'A' to tab[i][i]
                    end
                end
            end
        end
    
        for l = 2, n do
            for i = 1, n - l + 1 do
                local j = i + l - 1;
                for k = i, j - 1 do
                    -- For each 'A'
                    for _, var in grammar.vars do
                        local rule = grammar.rules[var];
                        if not rule then continue; end

                        for _, expansion in rule do
                            if #expansion == 2 then -- A -> BC rule
                                local b, c = expansion[1], expansion[2];
                                
                                -- Look for B in table(i, k) and C in table(k + 1, j)
                                if table.find(tab[i][k], b) and table.find(tab[k + 1][j], c) then
                                    table.insert(tab[i][j], var); -- Add 'A' to tab[i][j]
                                end
                            end
                        end
                    end
                end
            end
        end
    
        return table.find(tab[1][n], grammar.start) ~= nil; -- 'S' in table(1, n)?
    end
};