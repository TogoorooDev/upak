#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// #include <sys/utsname.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#ifdef SECURITY_ENHANCED
#include <sys/ptrace.h>
#endif

#include <zstd.h>

#define SHMNAME "/exec"

#if defined(__LP64__)
#define ElfW(type) Elf64_ ## type
#else
#define ElfW(type) Elf32_ ## type
#endif

extern uint8_t execz[];
extern int execz_size;

void basicmain(int argc, char**argv, char **envp){

  #ifndef NO_COMPRESS

  int exec_size = ZSTD_getFrameContentSize(execz, execz_size);
  if (ZSTD_isError(exec_size)){
    if (exec_size == -2){
      printf("Possibly Uncompressed Data (Did you pack properly?)\n");
      exit(-1);
    }
    printf("ZSTD_getFrameContentSize: %s\n", ZSTD_getErrorName(exec_size));
    exit(-1);
  }

  int *exec = malloc(exec_size);

  size_t exec_stat = ZSTD_decompress(exec, exec_size, execz, execz_size);
  if (ZSTD_isError(exec_stat)){
    puts(ZSTD_getErrorName(exec_stat));
    free(exec);
    exit(-1);
  }

  #else

  uint8_t *exec = execz;
  int exec_size = execz_size;

  #endif

  int execfd = memfd_create(SHMNAME, 0);
  if (execfd == -1){
    perror("memfd_create");
    exit(-1);
  }

  int written = write(execfd, exec, exec_size);
  if (written != exec_size){
    perror("write");
    exit(-1);
  }

  fexecve(execfd, argv, envp);
  free(exec);
  close(execfd);
  perror("exec (memfd)");
  exit(-1);
}

#ifdef SECURITY_ENHANCED

void semain(int argc, char **argv, char **envp){
  #ifndef QUIET
    puts("Security Enhanced Binary Loading");
  #endif
  int p = getpid();
  int f = fork();
  if (f == 0){
    // printf("%d\n", getpid());
    ptrace(PTRACE_TRACEME, NULL, NULL, NULL);
    ptrace(PTRACE_SEIZE, p, NULL, NULL);
    basicmain(argc, argv, envp);
  }
  wait(NULL);
  ptrace(PTRACE_SEIZE, f, NULL, NULL);
  ptrace(PTRACE_CONT, f, NULL, NULL);
  wait(NULL);
  exit(-1);
}

#endif


int main(int argc, char **argv, char **envp){
  #ifdef SECURITY_ENHANCED
  semain(argc, argv, envp);
  #else
  basicmain(argc, argv, envp);
  #endif  
   
}
