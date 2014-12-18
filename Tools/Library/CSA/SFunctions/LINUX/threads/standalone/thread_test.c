/*	This code will cerate two threads and generate random numbers in each thread
	The code will keep executing and gernating the numbers in a while(1) loop until
	a break (CTL-C) is received. This code is meant to run from the command prompt and
	be the basis for creating threads within other programs/codes. */

#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>


pthread_attr_t tattr;
pthread_t tid;

void *start_routine1(void *arg);
void *start_routine2(void *arg);
void *arg;

int ret;

int main(){
/* default behavior*/
	start_routine1(NULL);
ret = pthread_create(&tid, NULL, start_routine1, NULL);
start_routine2(NULL);
/* default behavior specified*/
ret = pthread_create(&tid, &tattr, start_routine2, NULL);
return 0;
}

void *start_routine1(void *arg){
	int doubleval;
	while(1){
		doubleval = rand();
		printf("The first thread value is: %i\n", doubleval);
		}
		}
		
void *start_routine2(void *arg){
	int doubleval;
	while(1){
		doubleval = rand();
		printf("The second thread value is: %i\n", doubleval);
		}
		}


		
		