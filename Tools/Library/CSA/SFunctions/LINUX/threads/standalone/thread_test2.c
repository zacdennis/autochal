/*	Sample code to measure multithreaded performance by measuring the time it
	takes to find prime numbers in two threads and then report the time elapsed.
	
	This code is based largely on code by Robert M. Love (Linux developer) and
	example code on the LLNL.gov web page for POSIX pthreads. This code has combined
	the two and set it up in a way to be manageable and quick to understand and use
	(because I am slow with this stuff myself!).
	
	Dan Salluce
	August 23, 2004
	
	Written for and developed on Suse 9.1 Pro with the 2.6 kernel. 
	Compile with: :> gcc thread_test2.c -g -o test -lpthread -lm -D_REENTRANT */

#include <stdio.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <pthread.h>
#include <sys/types.h>
#include <math.h>
#include <time.h>
#include <sched.h>

void function1(void);
void function2(void);
void function3(void);
void function4(void);

int main() {
	/* Setup the time variables to be able to measure execution time */
	struct timeval before, after, diff;
	
	/* Define the thread variables */
	pthread_t thread1, thread2, thread3, thread4;
	
	/* Setup the variables needed for the get/set affinity mask */
	unsigned long cur_mask, new_mask;
	unsigned int len = sizeof(cur_mask);
	pid_t pid = 0;
	/* Define the hexidecimal bitmask here.
	Refer the to table below (quad CPU example) or a man on sched_setaffinity()
	***********************************
	CPU#	3	2	1	0	|	HEX
	___________________________________
		0	0	0	0	|	0
		0	0	0	1	|	1
		0	0	1	0	|	2
		0	0	1	1	|	3
		0	1	0	0	|	4
		0	1	0	1	|	5
		0	1	1	0	|	6
		0	1	1	1	|	7
		1	0	0	0	|	8
		1	0	0	1	|	9
		1	0	1	0	|	A
		1	0	1	1	|	B
		1	1	0	0	|	C
		1	1	0	1	|	D
		1	1	1	0	|	E
		1	1	1	1	|	F
	***********************************/
	char * new_mask_string = "0000000f";
	
	/* Display the current process' affinity mask */
	if (sched_getaffinity(pid, len, &cur_mask) < 0) {
		printf("error: could not get pid %d's affinity.\n", pid);
		return -1;
	}
	printf(" pid %d's old affinity: %08lx\n", pid, cur_mask);
	
	/* Grab the hexidecimal mask from new_mask_tring */
	sscanf(new_mask_string, "%08lx", &new_mask);
	
	/* Set the affinity for the process */
	if (sched_setaffinity(pid, len, &new_mask)) {
		printf("error: could not set pid %d's affinity.\n", pid);
		return -1;
	}
	
	/* Get the affinity for the process now that it has been changed */
	if (sched_getaffinity(pid, len, &cur_mask) < 0) {
		printf("error: could not get pid %d's affinity.\n", pid);
		return -1;
	}
	
	/* Display the newly changed mask */
	printf(" pid %d's new affinity: %08lx\n", pid, cur_mask);
	
	/* Get the time at the beginning of exectution */
	gettimeofday(&before, 0);
	
	/* Create the threads to test */
	pthread_create(&thread1,NULL,(void *)function1,NULL);
	pthread_create(&thread2,NULL,(void *)function2,NULL);
	pthread_create(&thread3,NULL,(void *)function3,NULL);
	pthread_create(&thread4,NULL,(void *)function4,NULL);
	
	/* Join the threads now that they have been created */
	pthread_join(thread1,NULL);
	pthread_join(thread2,NULL);
	pthread_join(thread3,NULL);
	pthread_join(thread4,NULL);
		
	/* Get the time once the threads are complete and display the elapsed time */
	gettimeofday(&after, 0);
	timersub(&after, &before, &diff);
	printf("program took %d:%d seconds\n", diff.tv_sec, diff.tv_usec);
	return 0;
}

/* First function to find the greatest prime number */
void function1(void)
{
	int i=2,n,k,s,f,z1;

	do{
		int z=1,n=2;
		k=sqrt(i);
		do{
			s=fmod(i,n);
			/* printf("s is %d\t%d\t",s,i); */
			if(s==0){
				f=0;
			}
			else f=1;
				z= f&&z;
			n=n++;
		}while(n<=k);

		if(z==1){
			z1=i;
		}
		i=i++;

	}while(i<500000);
	printf("this is greatest prime1 %d\n",z1);

}

/* Second function to find the greatest prime number */
void function2(void)
{
	int i,n,k,s,f,z2;
	for(i=2;i<500000;i++)
	{
		int z=1;
		k=sqrt(i);
		for(n=2;n<=k;n++)
		{
			s=fmod(i,n);
			if(s==0){
					f=0;
			}
			else f=1;
			z= f&&z;
		}
		if(z==1){
			z2=i;
		}
	}
	printf("this is greatest prime2 %d\n",z2);
}

/* Third function ... */
void function3(void)
{
	int i,n,k,s,f,z2;
	for(i=2;i<500000;i++)
	{
		int z=1;
		k=sqrt(i);
		for(n=2;n<=k;n++)
		{
			s=fmod(i,n);
			if(s==0){
					f=0;
			}
			else f=1;
			z= f&&z;
		}
		if(z==1){
			z2=i;
		}
	}
	printf("this is greatest prime2 %d\n",z2);
}

/* Fourth function... */
void function4(void)
{
	int i,n,k,s,f,z2;
	for(i=2;i<500000;i++)
	{
		int z=1;
		k=sqrt(i);
		for(n=2;n<=k;n++)
		{
			s=fmod(i,n);
			if(s==0){
					f=0;
			}
			else f=1;
			z= f&&z;
		}
		if(z==1){
			z2=i;
		}
	}
	printf("this is greatest prime2 %d\n",z2);
}

/*End*/

