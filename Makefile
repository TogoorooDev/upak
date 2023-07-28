CC=clang
CFLAGS+=-Os -fno-pie -Wall -Wextra -Werror -Wno-error=unused-parameter
ASFLAGS=
LDFLAGS+=-no-pie -fuse-ld=lld -lzstd

CFLAGS_H+=-O2 -Wall -Wextra -Werror
LDFLAGS_H+=-fuse-ld=lld -lxxhash

ifndef FILE
	FILE=upakbin
endif


$(FILE): obj obj/data.o obj/stub.o 
	$(CC) $(LDFLAGS) $(CFLAGS) obj/data.o obj/stub.o -o $(FILE)
	strip $(FILE)

obj/stub.o: obj src/stub.c
	$(CC) -c $(CFLAGS) src/stub.c -o obj/stub.o

obj/data.o: obj src/data.S
	$(CC) -c $(CFLAGS) $(ASFLAGS) src/data.S -o obj/data.o

obj:
	mkdir obj
	
hasher: util/hasher.c
	$(CC) $(CFLAGS_H) $(LDFLAGS_H) $< -o hasher

clean:
	rm -rf obj/* $(FILE) hasher

genclean:
	rm -rf obj/*

remake: clean