# Things to note
* This project is written in Luau, although the code is executed indirectly through the proxy *nob.c*.
* *nob.c* forwards the file contents as arguments to the actual source code, because Luau has no file system support.
* *nob.c* utilizes a utility header, *nob.h*, which makes this process simpler.
* **None of the source code dedicated to the grammar parser itself uses any external utilities, only the build/run script (*nob.c*) does (only *nob.h*).**

# How to run

**<span style="color:orange">
    If not on Windows, first compile "nob.c" into a native executable.
</span>**
Otherwise, 'nob-windows.exe' is already compiled for Windows.

How we compile on our end (Windows):
```
gcc nob.c -o nob-windows.exe
```

How we run the program on our end (Windows):
```
nob-windows.exe "astarGrammar.txt" "astarGrammarInput.txt"
```

<span style="color:lightblue">
    We included the Luau interpreters for Windows, MacOS, and Linux, so the execution of the Luau code should be taken care of automatically.
</span>
