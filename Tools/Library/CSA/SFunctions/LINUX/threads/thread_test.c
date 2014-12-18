/*
NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
*/
/*
 * This C code will create new threads (3) and output the greatest prime number in each.
 * The goal is to have the threads each output to a seperate port in Simulink. The
 * downside is that the threads will need to be created and destroyed every time mdlOutputs
 * is called. This may facilitate the code having to just spawn a thread to do work outside
 * of the simulation. It could use data from the simulation to send or to do other
 * work...TBD.
 *
 * Created By: Dan Salluce
 * August 24, 2004
 *
 * Revised By: -
 * Month Day, Year
 * rev 1:
 */

/* SYSTEM INCLUDES */
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <errno.h>
	#include <string.h>
	#include <math.h>
	#include <sched.h>
	#include <time.h>
	#include <sys/types.h>
	#include <pthread.h>
	#include <sys/time.h>
	#include <sys/resource.h>
  
/* APPLICATION INCLUDES */
  
/* DEFINES */
	/* S-function Parameters */
	#define SAMPLE_TIME_PARAM(S) ssGetSFcnParam(S, 0) /* Parameter #0: Sample Time */
	/* You must specify the S_FUNCTION_NAME as the name of your S-function */
	#define S_FUNCTION_NAME  thread_test
	#define S_FUNCTION_LEVEL 2
	/* Need to include simstruc.h for the definition of the SimStruct and
	 * its associated macro definitions.*/
	#include "simstruc.h"

/* Sizes */
  
	/* GLOBALS */
	double prime1, prime2, prime3, prime4;
	
	/* Setup the time variables to be able to measure execution time */
	struct timeval before, after, diff;
	/* Define the thread variables */
	pthread_t thread1, thread2, thread3, thread4;
	/* Setup the variables needed for the get/set affinity mask */
	unsigned long cur_mask, new_mask;
	unsigned int len = sizeof(cur_mask);
	pid_t pid = 0;
	/* Define the hexidecimal bitmask here:
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
	char * new_mask_string = "0000000a";
		
	/* FUNCTION PROTOTYPES */
	void function1(void);
	void function2(void);
	void function3(void);
	void function4(void);
    
/* Error handling
 * --------------
 *
 * You should use the following technique to report errors encountered within
 * an S-function:
 *
 *       ssSetErrorStatus(S,"Error encountered due to ...");
 *       return;
 *
 * Note that the 2nd argument to ssSetErrorStatus must be persistent memory.
 * It cannot be a local variable. For example the following will cause
 * unpredictable errors:
 *
 *      mdlOutputs()
 *      {
 *         char msg[256];         {ILLEGAL: to fix use "static char msg[256];"}
 *         sprintf(msg,"Error due to %s", string);
 *         ssSetErrorStatus(S,msg);
 *         return;
 *      }
 *
 * See matlabroot/simulink/src/sfuntmpl_doc.c for more details.
 */

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
    /* See sfuntmpl_doc.c for more details on the macros below */
    ssSetNumSFcnParams(S, 0);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    if (!ssSetNumInputPorts(S, 0)) return;
    /*ssSetInputPortWidth(S, 0, 18);*/

    /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     * See matlabroot/simulink/src/sfuntmpl_directfeed.txt
     */
    /*ssSetInputPortDirectFeedThrough(S, 0, 1);*/
    /*ssSetInputPortRequiredContiguous(S, 0, true); /* Direct input signal access */
        
    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 4);

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);

    ssSetNumIWork(S, 0);
    ssSetNumPWork(S, 0);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);

    ssSetOptions(S, 0);
}

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    /*ssSetSampleTime(S, 0, *mxGetPr(SAMPLE_TIME_PARAM(S)));
    ssSetOffsetTime(S, 0, 0.0);*/
}

#define MDL_INITIALIZE_CONDITIONS   /* Change to #undef to remove function */
#if defined(MDL_INITIALIZE_CONDITIONS)
  /* Function: mdlInitializeConditions ========================================
   * Abstract:
   *    In this function, you should initialize the continuous and discrete
   *    states for your S-function block.  The initial states are placed
   *    in the state vector, ssGetContStates(S) or ssGetRealDiscStates(S).
   *    You can also perform any other initialization activities that your
   *    S-function may require. Note, this routine will be called at the
   *    start of simulation and if it is present in an enabled subsystem
   *    configured to reset states, it will be call when the enabled subsystem
   *    restarts execution to reset the states.
   */
  static void mdlInitializeConditions(SimStruct *S)
  {
  }
#endif /* MDL_INITIALIZE_CONDITIONS */


#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START) 
  /* Function: mdlStart =======================================================
   * Abstract:
   *    This function is called once at start of model execution. If you
   *    have states that should be initialized once, this is the place
   *    to do it.
   */
  static void mdlStart(SimStruct *S)
  {
	/* Display the current process' affinity mask */
	if (sched_getaffinity(pid, len, &cur_mask) < 0) {
		printf("error: could not get pid %d's affinity.\n", pid);
		/*return -1;*/
	}
	printf(" pid %d's old affinity: %08lx\n", pid, cur_mask);
	
	/* Grab the hexidecimal mask from new_mask_tring */
	sscanf(new_mask_string, "%08lx", &new_mask);
	
	/* Set the affinity for the process */
	if (sched_setaffinity(pid, len, &new_mask)) {
		printf("error: could not set pid %d's affinity.\n", pid);
		/*return -1;*/
	}
	
	/* Get the affinity for the process now that it has been changed */
	if (sched_getaffinity(pid, len, &cur_mask) < 0) {
		printf("error: could not get pid %d's affinity.\n", pid);
		/*return -1;*/
	}
	
	/* Display the newly changed mask */
	printf(" pid %d's new affinity: %08lx\n", pid, cur_mask);
	
	/* Get the time at the beginning of exectution */
	gettimeofday(&before, 0);	
  }
#endif /*  MDL_START */


/* Function: mdlOutputs =======================================================

 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  /*InputRealPtrsType u1 = ssGetInputPortRealSignalPtrs(S, 0);*/
  real_T           *y1 = ssGetOutputPortSignal(S,0);

  int_T             i;
  real_T			prime1, prime2, prime3, prime4;
  
  /* Create the threads to test and join them immediately after */
	pthread_create(&thread1,NULL,(void *)function1,NULL);
	pthread_create(&thread2,NULL,(void *)function2,NULL);
	pthread_create(&thread3,NULL,(void *)function3,NULL);
	pthread_create(&thread4,NULL,(void *)function4,NULL);
		
	/* Join the threads so that they are part of the process being run */
	pthread_join(thread1,NULL);	
	pthread_join(thread2,NULL);
	pthread_join(thread3,NULL);
	pthread_join(thread4,NULL);
	
  	/*A = *u1[0];*/
	/* Output the variables */
	y1[0] = (int)prime1;
	y1[1] = (int)prime2;
	y1[2] = (int)prime3;
	y1[3] = (int)prime4;
	
	gettimeofday(&after, 0);
	timersub(&after, &before, &diff);
	printf("program took %d:%d seconds\n", diff.tv_sec, diff.tv_usec);
	/*return 0;*/
  
} /*  mdlOutputs */



#define MDL_UPDATE  /* Change to #undef to remove function */
#if defined(MDL_UPDATE)
  /* Function: mdlUpdate ======================================================
   * Abstract:
   *    This function is called once for every major integration time step.
   *    Discrete states are typically updated here, but this function is useful
   *    for performing any tasks that should only take place once per
   *    integration step.

   */
  static void mdlUpdate(SimStruct *S, int_T tid)
  {
  }
#endif /* MDL_UPDATE */



#define MDL_DERIVATIVES  /* Change to #undef to remove function */
#if defined(MDL_DERIVATIVES)
  /* Function: mdlDerivatives =================================================
   * Abstract:
   *    In this function, you compute the S-function block's derivatives.
   *    The derivatives are placed in the derivative vector, ssGetdX(S).
   */
  static void mdlDerivatives(SimStruct *S)
  {
  }
#endif /* MDL_DERIVATIVES */



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
   {
   }


/*======================================================*
 * See sfuntmpl_doc.c for the optional S-function methods *
 *======================================================*/

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif

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

	}while(i<50000);
	printf("this is greatest prime1 %d\n",z1);
	prime1 = z1;

}

/* Second function to find the greatest prime number */
void function2(void)
{
	int i,n,k,s,f,z2;
	for(i=2;i<50000;i++)
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
	prime2 = z2;
}

/* Third function ... */
void function3(void)
{
	int i,n,k,s,f,z3;
	for(i=2;i<50000;i++)
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
			z3=i;
		}
	}
	printf("this is greatest prime2 %d\n",z3);
	prime3 = z3;
}

/* Fourth function... */
void function4(void)
{
	int i,n,k,s,f,z4;
	for(i=2;i<50000;i++)
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
			z4=i;
		}
	}
	printf("this is greatest prime2 %d\n",z4);
	prime4 = z4;
}

/*End*/
