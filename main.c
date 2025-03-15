#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "dyn_string.h" // This is not an 3rd-party lib
#include "direct.h"

// Quick exit program
void panic(const char* panic_msg) {
    fprintf(stderr, "%s\n", panic_msg);
    exit(1);
}

// Formatted logging
void log_msg(const char* msg) {
    printf("[CFG_PARSER MAIN] %s\n", msg);
}

// Shifts args over and returns the popped arg
char* shift_args(int* argc, char*** argv) {
    if (*argc <= 0) return NULL;
    
    char* arg = **argv;
    (*argc)--;
    (*argv)++;

    return arg;
}

// https://stackoverflow.com/questions/174531/how-to-read-the-content-of-a-file-to-a-string-in-c
// https://www.w3schools.com/c/c_files_read.php
// https://stackoverflow.com/questions/12733105/c-function-that-counts-lines-in-file
dyn_string* read_file_contents(const char* file_path) {
    // Open file
    FILE* f = fopen(file_path, "r");
    if (!f) return NULL;

    // Read file contents into string
    dyn_string* file_contents = dyn_string_create("");
    char c;
    while ((c = fgetc(f)) != EOF) {
        if (c == '\n') {
            dyn_string_append(file_contents, "\\n"); // Insert escaped newline so the command behaves as intended
        } else {
            // https://stackoverflow.com/questions/22621952/convert-char-to-string-in-c
            char char_str[2] = "\0";
            char_str[0] = c;
            dyn_string_append(file_contents, char_str);
        }
    }
    fclose(f);

    return file_contents;
}

// https://stackoverflow.com/questions/298510/how-to-get-the-current-directory-in-a-c-program
int main(int argc, char** argv) {
    shift_args(&argc, &argv);

    char working_dir[FILENAME_MAX];
    _getcwd(working_dir, FILENAME_MAX);
    log_msg(working_dir);

    if (argc > 0 && strcmp(argv[0], "-analyze") == 0) {
        shift_args(&argc, &argv);

        // Run luau static analyzer
        dyn_string* analyze_cmd = dyn_string_create(working_dir);
        if (!analyze_cmd) panic("Failed to allocate memory for analyze_cmd.");

        dyn_string_append(analyze_cmd, "\\bin\\luau-analyze.exe");
        dyn_string_append(analyze_cmd, " ");
        dyn_string_append(analyze_cmd, "cfg_parser.luau");
        if (system(analyze_cmd->raw) != 0) panic("Failed to run analyze command."); // Run analyze command

        log_msg("Ran luau analyzer.");
        dyn_string_free(analyze_cmd);
    }


    // Run code
    dyn_string* run_cmd = dyn_string_create(working_dir);
    if (!run_cmd) panic("Failed to allocate memory for run_cmd.");

    dyn_string_append(run_cmd, "\\bin\\luau-windows.exe");
    dyn_string_append(run_cmd, " ");
    dyn_string_append(run_cmd, working_dir);
    dyn_string_append(run_cmd, "\\cfg_parser.luau");
    dyn_string_append(run_cmd, " ");
    dyn_string_append(run_cmd, "-a");

    log_msg(run_cmd->raw);

    // Appends file contents as args to luau code (Luau has very limited I/O)
    for (int i = 0; i < argc; i++) {
        const char* file_path = argv[i];

        // Get file contents
        dyn_string* file_contents = read_file_contents(file_path);
        if (!file_contents) {
            dyn_string_free(run_cmd);
            panic("Failed to read file contents.");
        }

        // Append file contents as program argument
        dyn_string* wrapped_arg = dyn_string_create("\"");
        if (!wrapped_arg) panic("Failed to allocate memory for wrapped_arg.");

        dyn_string_append(wrapped_arg, file_contents->raw);
        dyn_string_append(wrapped_arg, "\"");
        dyn_string_append(run_cmd, " ");
        dyn_string_append(run_cmd, wrapped_arg->raw);

        dyn_string_free(file_contents);
        dyn_string_free(wrapped_arg);
    }

    log_msg("Running cfg parser...");
    if (system(run_cmd->raw) != 0) panic("Failed to run build command."); // Run luau code

    printf("\n");
    log_msg("Done.");
    dyn_string_free(run_cmd);    
    return 0;
}
