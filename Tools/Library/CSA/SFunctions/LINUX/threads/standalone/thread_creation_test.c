
#include <stdio.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <pthread.h>
#include <sys/types.h>
#include <math.h>
#include <time.h>
#include <sched.h>


#define NTHREADS 1000000

void *do_nothing(void *null) {
int i;
i=0;
/*printf("Test\n");*/
pthread_exit(NULL);
}                      

int main() {
	/* Setup the time variables to be able to measure execution time */
	struct timeval before, after, diff;
	
	int rc, i, j, detachstate;
	pthread_t tid;
	pthread_attr_t attr;
	
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
	
	/* Get the time at the beginning of exectution */
	gettimeofday(&before, 0);
	/*printf("Time at Start %d:%d seconds\n", before.tv_sec, before.tv_usec);*/
	
	for (j=0; j<NTHREADS; j++) {
		rc = pthread_create(&tid, &attr, do_nothing, NULL);
		if (rc) {              
			printf("ERROR; return code from pthread_create() is %d\n", rc);
			exit(-1);
		}
	
		/* Wait for the thread */
		rc = pthread_join(tid, NULL);
		if (rc) {
			printf("ERROR; return code from pthread_join() is %d\n", rc);
			exit(-1);
		}
  	}

	/* Get the time once the threads are complete and display the elapsed time */
	gettimeofday(&after, 0);
	timersub(&after, &before, &diff);
	printf("program took %d:%d seconds\n", diff.tv_sec, diff.tv_usec);
	
	pthread_attr_destroy(&attr);
	pthread_exit(NULL);
	
	return 1;
}

