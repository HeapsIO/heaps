haxe meshtools.hxml -D no-compilation
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
cl /Ox /Femeshtools.exe -I %HASHLINK_SRC%/src -I out out/main.c %HASHLINK_SRC%/x64/Release/libhl.lib %HASHLINK_SRC%/x64/Release/heaps.lib
