/* Portable */
#include <stdio.h>
#include <stdlib.h>

/* Posix-Specific */
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

/* External */
#include <xxhash.h>

void die(int fd1, int fd2){
  close(fd1);
  close(fd2);

  exit(-1);
}

int main(int argc, char** argv){
  if (argc != 3){
    fprintf(stderr, "Invalid argument length\n");
    exit(-1);
  }

  // char *algo = argv[1];
  char *input = argv[1];
  char *output = argv[2];

  int fi = open(input, O_RDONLY);
  if (fi < 0){
    perror("open input file");
    exit(-1);
  }
  int fo = open(output, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
  if (fo < 0){
    perror("open input file");
    close(fi);
    exit(-1);
  }

  struct stat buffer;
  int status = stat(input, &buffer);
  if (status != 0){
    perror("stat");
    die(fi, fo);
  }

  char filecontents[buffer.st_size];
  ssize_t rsize = read(fi, filecontents, buffer.st_size);

  if (rsize != buffer.st_size){
    perror("read");
    die(fi, fo);
  }

  XXH128_hash_t hash = XXH3_128bits(filecontents, buffer.st_size);

  ssize_t wsize = write(fo, &hash, 128);

  if (wsize != 128){
    perror("write");
    die(fi, fo);
  }

  die(fi, fo);
}
