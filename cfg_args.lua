return {
    parse_args = function(...): (string, string)
        local args = table.pack(...);

        -- Trims any leading/trailing single quotes from the given string
        local function trim_single_quotes(str: string)
            if str == nil or str == "" then
                return str;
            end
    
            -- Remove leading single quotes
            while #str > 0 and (string.sub(str, 1, 1) == "'") do
                str = str:sub(2, #str); -- Remove the first character
            end
    
            -- Remove trailing single quotes
            while #str > 0 and (string.sub(str, #str, #str) == "'") do
                str = str:sub(1, #str - 1); -- Remove the last character
            end
    
            return str;
        end
    
        -- Retrieve script arguments
        local grammar_src: string = args[1];
        assert(grammar_src, "No grammar src provided");
        grammar_src = trim_single_quotes(grammar_src);
    
        local grammar_input_src: string = args[2];
        assert(grammar_input_src, "No grammar input src provided");
        grammar_input_src = trim_single_quotes(grammar_input_src);
    
        return grammar_src, grammar_input_src;
    end
};
