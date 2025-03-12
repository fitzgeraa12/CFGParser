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

<span style="color:lightblue">
    We included the Luau interpreters for Windows, MacOS, and Linux, so the execution of the Luau code should be taken care of automatically (hopefully).
</span>

* **<span style="color:orange">
    Note: 
</span>**
<span style="color:orange">
    Because main.c utilizes one of the luau executables inside 'bin' to run the luau code, it's possible that express permissions need to be given to that executable (e.g. 'luau-linux') in order for the code to run.
</span>

* **<span style="color:orange">
    Worst case scenario: 
</span>**
<span style="color:orange">
    Running on windows is guaranteed to work since this was built and tested for it.
</span>