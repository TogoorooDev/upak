#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include <termios.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>

#include <argon2.h>

#define HASHLEN 32
#define SALTLEN 16

int main(int argc, char **argv){
  if (argc != 3){
    fprintf(stderr, "Invalid number of arguments\n");
    exit(-1);
  }

  char *ifs = argv[1];
  char *ofs = argv[2];

  int fi = open(ifs, O_RDONLY);
  if (fi < 0){
    perror("open(if)");
    exit(-1);
  }

  int fo = open(ofs, O_WRONLY | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
  if (fo < 0){
    perror("open(of)");
    close(fi);
    exit(-1);
  }

  struct stat buffer;
  int sstat = stat(ifs, &buffer);
  if (sstat < 0){
    perror("stat(ifs)");
    exit(-1);
  }
  //char key[128];
//  getpasswd("Encryption Passphrase?", &&key, 127, stdin);

  char *pass = getpass("Encryption password?");

  
  
  puts(key);
  exit(-1);
}

uint8_t *genKey(char *txt){
  uint8_t salt[SALTLEN];
  memset(salt, 0x00, SALTLEN);

  uint8_t *pass = (uint8_t *)strdup(txt);
  uint32_t *plen = strlen(char*)pass);
}