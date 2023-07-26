#define _GNU_SOURCE

/* Portable */
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

/* Posix-Specific */
#include <sys/utsname.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#define SHMNAME "/exec"

extern uint8_t exec[];
extern int exec_size;

int checkmemfd(){
  struct utsname kver;
  uname(&kver);

  char *token;
  char *sep = ".";

  token = strtok(kver.release, sep);
  if (atoi(token) < 3) return 0;
  else if (atoi(token) > 3) return 1;

  token = strtok(NULL, sep);
  if (atoi(token) < 17) return 0;
  else return 1;

}

int main(int argc, char **argv, char **envp){
  int memfd = checkmemfd();
  int execfd;
  // memfd = 0;
  
  if (memfd){    
    execfd = memfd_create(SHMNAME, 0);
    if (execfd == -1){
      perror("memfd_create");
      exit(-1);
    }
  } else{
    fprintf(stderr, "memfd_create system call is not available on your version of Linux\n");
    exit(-1);
  }
  
  int written = write(execfd, exec, exec_size);
  if (written != exec_size){
    perror("write");
    exit(-1);
  }  

  char* const exec_argv[] = { NULL };

  int f = fork();

  if (f == 0){
    fexecve(execfd, exec_argv, envp);
    perror("exec (memfd)");
    exit(-1);
  }
    
  waitpid(f, NULL, 0);

  exit(-1);
}
