#include "types.h"      
#include "user.h" 
#include "param.h"
#include "stat.h"



#define N 100000000
#define PROCS 10

void repete(){
	int x=0;
	while(x < N){
		x++;
	}
}

int main(){

	int vetids[PROCS];
	int tickets;
	int x=0;

	while(x < PROCS){
		if(x % PROCS == 0){//se x é par
			tickets = (x + x) * PROCS;
		}else if(x % PROCS != 0){
			tickets = x * x;
		}

		vetids[x] = fork(tickets);

		if(vetids[x] == 0){
			repete();
			exit();
		}

		x++;

	}

	while(wait() != -1);
	exit();
    
}