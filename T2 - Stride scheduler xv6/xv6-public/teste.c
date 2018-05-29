//teste
#include "types.h"
#include "stat.h"
#include "user.h"

#define NPROC 3
#define VALORALTO 11234567890

void tempogasto(void);

int main (void){
  int i, num;

  printf(1, "\n\nTeste \n\n");

  for(i = 0, num = 50; i < NPROC; i++, num += 100){
    
    if(fork(num) == 0){
      tempogasto();
      printf(1, "Process0 %d acabou. Tickets: %d\n", getpid(), num);
      exit();
    }
  }
  for(i = 0; i < NPROC; i++) wait(); 

  exit();
}

void tempogasto(void){
  int j;
  for(j = 0; j < VALORALTO; j++);
}

