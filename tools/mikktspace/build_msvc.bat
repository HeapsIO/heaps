@echo off
haxe mikktspace.hxml -D no-compilation
vcvarsall.bat
cl /Ox /Femikktspace.exe -I %HASHLINK% -I out out/main.c %HASHLINK_BIN%/libhl.lib %HASHLINK_BIN%/fmt.lib