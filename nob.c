#define NOB_IMPLEMENTATION
#define NOB_STRIP_PREFIX
#include "nob.h"

int main(int argc, char** argv) {
    NOB_GO_REBUILD_URSELF(argc, argv);

    shift(argv, argc);

    const char* luau_interpreter = NULL;

#ifdef _WIN32
    luau_interpreter = "./bin/luau-windows.exe";

    if (argc > 0 && strcmp(argv[0], "-analyze") == 0) {
        shift(argv, argc);

        // Run luau static analyzer
        Cmd analyze_cmd = {0};
        cmd_append(&analyze_cmd, "./bin/luau-analyze.exe", "cfg_parser.luau");
        cmd_run_sync(analyze_cmd);
    }
#elif __APPLE__
    luau_interpreter = "./bin/luau-macos";
#elif linux
    luau_interpreter = "./bin/luau-linux";
#else
    nob_log(ERROR, "Unsupported operating system");
    return 1;
#endif

    // Run code
    Cmd build_cmd = {0};
    cmd_append(&build_cmd, luau_interpreter, "cfg_parser.luau", "-a");
    for (int i = 0; i < argc; i++) {
        const char* file_path = argv[i];

        String_Builder file_contents = {0};

        if (!read_entire_file(file_path, &file_contents)) {
            nob_log(ERROR, "Failed to read file: %s", file_path);
            return 1;
        }

        // Trim trailing whitespace
        while (file_contents.count > 0 && file_contents.items[file_contents.count - 1] == ' ') {
            file_contents.count--;
        }
        file_contents.items[file_contents.count] = '\0'; // Early string termination

        cmd_append(&build_cmd, temp_sprintf("\"%s\"", file_contents.items));
        sb_free(file_contents);
    }
    cmd_run_sync(build_cmd);

    return 0;
}
