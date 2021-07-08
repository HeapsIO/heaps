# these are the default paths where hashlink is installed with `make install`
ifndef HASHLINK
HASHLINK=/usr/local/include
endif

ifndef HASHLINK_BIN
HASHLINK_BIN=/usr/local/lib
endif

all: codegen
	gcc -I ${HASHLINK} -I out out/main.c ${HASHLINK_BIN}/libhl.dylib ${HASHLINK_BIN}/fmt.hdll -o mikktspace

codegen:
	haxe mikktspace.hxml -D no-compilation