#ifndef _CFGPARSER_DYNSTRING
#define _CFGPARSER_DYNSTRING

#include "string.h"
#include "stdlib.h"
#include "stdbool.h"

typedef struct {
    char* raw;
    size_t len;
    size_t max_len;
} dyn_string;

dyn_string* dyn_string_create(const char* str_raw) {
    dyn_string* str = (dyn_string*) malloc(sizeof(dyn_string));
    if (!str) return NULL;

    // Empty string
    if (!str_raw) {
        str->len = 0;
        str->max_len = 1;
        str->raw = (char*) malloc(sizeof(char));
        if (!str->raw) {
            free(str);
            return NULL;
        }
        str->raw[0] = '\0'; // Empty string
    
    // Some string
    } else {
        size_t len = strlen(str_raw);
        str->raw = (char*) malloc(sizeof(char) * (len + 1)); // (+1 for null terminator)
        if (!str->raw) {
            free(str);
            return NULL;
        }
        memcpy(str->raw, str_raw, len + 1); // Create copy of str_raw

        str->len = len;
        str->max_len = len + 1;
    }

    return str;
}

bool dyn_string_realloc(dyn_string* str) {
    size_t new_max_len = str->max_len * 1.5; // Grow by 50%
    if (new_max_len == str->max_len) new_max_len = str->max_len * 2;

    char* new_raw = (char*) realloc(str->raw, sizeof(char) * new_max_len); // realloc on NULL is defined behavior (acts like malloc)
    if (!new_raw) {
        printf("Failed to reallocate memory for dyn_string.");
        return false;
    }

    str->max_len = new_max_len;
    str->raw = new_raw;
    return true;
}

bool dyn_string_append(dyn_string* str, const char* raw_str) {
    if (!raw_str) return true;

    size_t raw_len = strlen(raw_str);
    if (!raw_len) return true;

    size_t new_len = str->len + raw_len;

    while (new_len + 1 > str->max_len) {
        if (!dyn_string_realloc(str)) return false;
    }

    memcpy(str->raw + str->len, raw_str, raw_len); // Copy raw_str into dyn_string
    str->raw[new_len] = '\0'; // New string ending

    str->len = new_len;
    return true;
}

void dyn_string_free(dyn_string* str) {
    free(str->raw);
    free(str);
}

#endif // _CFGPARSER_DYNSTRING
