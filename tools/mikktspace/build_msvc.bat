@echo off
haxe mikktspace.hxml -D no-compilation
vcvarsall.bat x64
cl /Ox /Femikktspace.exe -I %HASHLINK% -I out out/main.c %HASHLINK_BIN%/libhl.lib %HASHLINK_BIN%/fmt.lib