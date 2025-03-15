# Things to note
* The grammar portion of this project is written in Luau, although the code to launch the program is written in C. This is because Aidan and I were set on using Luau (for the fun of it), but Luau does not have very established I/O operations. For instance, it is impossible to read a file with Luau. However, Luau does accept command line arguments.
* *main.c* forwards the file contents as arguments to the actual source code, because Luau has no file system support.
* *main.c* utilizes a utility header, *dyn_string.h* (makes string building much simpler), which is completely made by us.

# How to run

**<span style="color:orange">
    First compile "main.c" into a native executable.
</span>**

How we compile on our end (Windows):
```
gcc main.c -o main-windows.exe
```

How we run the program on our end (Windows):
```
main-windows.exe astarGrammar.txt astarGrammarInput.txt
```
