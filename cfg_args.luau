--[[
    Cleans the given string by removing carriage returns, trailing spaces, and leading a trailing single quotes.

    @param str - The string to clean
    @return The cleaned string
]]
local function clean_string(str: string): (string)
    if str == "" then return str; end

    -- Funny edge case with newline at the end
    if string.sub(str, #str - 1, #str) == "\\n" then
        str = string.sub(str, 1, #str - 2);
    end

    str = string.gsub(str, "\n", "") -- Trim trailing white space (https://www.lua.org/manual/5.4/manual.html#6.4.1)
    str = string.gsub(str, "\\n", "\n") -- Replace escaped newlines with actual newlines

    return str;
end

return {
    --[[
        Parses the command line arguments provided to the parser.

        @param ... - The program arguments as a tuple
        @return The grammar source
        @return The grammar input source
    ]]
    parse_args = function(...): (string, string)
        local args = table.pack(...); -- Turn args tuple into an array
    
        -- Expect grammar source
        local grammar_src: string = assert(args[1], "No grammar src provided");
        grammar_src = clean_string(grammar_src);
        print(grammar_src);
    
        -- Expect grammar input source
        local grammar_input_src: string = assert(args[2], "No grammar input src provided");
        grammar_input_src = clean_string(grammar_input_src);
    
        return grammar_src, grammar_input_src;
    end
};
