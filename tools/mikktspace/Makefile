# these are the default paths where hashlink is installed with `make install`
ifndef HASHLINK
HASHLINK=/usr/local/include
endif

ifndef HASHLINK_BIN
HASHLINK=/usr/local/lib
endif

all: codegen
	gcc -I $HASHLINK -I out out/main.c -lhl -L${HASHLINK_BIN}/fmt.hdll -o mikktspace

codegen:
	haxe mikktspace.hxml -D no-compilation
