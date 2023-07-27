CC=clang
CFLAGS+=-O0 -fno-pie -Wall -Wextra -Werror -Wno-error=unused-parameter
ASFLAGS=
LDFLAGS+=-no-pie -fuse-ld=lld -lzstd

CFLAGS_H+=-O2 -Wall -Wextra -Werror
LDFLAGS_H+=-fuse-ld=lld -lxxhash

ifndef FILE
	FILE=upakbin
endif


$(FILE): obj/data.o obj/stub.o
	$(CC) $(LDFLAGS) $(CFLAGS) obj/data.o obj/stub.o -o $(FILE)

obj/stub.o: src/stub.c
	$(CC) -c $(CFLAGS) src/stub.c -o obj/stub.o

obj/data.o: src/data.S
	$(CC) -c $(CFLAGS) $(ASFLAGS) src/data.S -o obj/data.o

hasher: src/hasher.c
	$(CC) $(CFLAGS_H) $(LDFLAGS_H) src/hasher.c -o hasher

clean:
	rm -rf obj/* $(FILE)

genclean:
	rm -rf obj/*

remake: clean $(FILE)