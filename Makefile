CC=clang
CFLAGS=-O0 -fno-pie -Wall -Wextra -Werror -Wno-error=unused-parameter
ASFLAGS=
LDFLAGS=-no-pie -fuse-ld=lld
FILE=package


$(FILE): obj/data.o obj/stub.o
	$(CC) $(LDFLAGS) $(CFLAGS) obj/data.o obj/stub.o -o $(FILE)

obj/stub.o: src/stub.c
	$(CC) -c $(CFLAGS) src/stub.c -o obj/stub.o

obj/data.o: src/data.S
	$(CC) -c $(CFLAGS) $(ASFLAGS) src/data.S -o obj/data.o

clean:
	rm -rf obj/* $(FILE)

genclean:
	rm -rf obj/*

remake: clean $(FILE)