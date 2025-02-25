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
./nob-windows.exe "astarGrammar.txt" "astarGrammarInput.txt"
```

<span style="color:lightblue">
    We included the Luau interpreters for Windows, MacOS, and Linux, so the execution of the Luau code should be taken care of automatically.
</span>
