/*
NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
*/
/*
 * This C code will take the inputs defined below and create a location in shared memory so that other tasks can use them to perform
 * other operation. This effectively works as an IPC and allows us to circumvent the one-thread limitation in Matlab. The other task can
 * attach to the memory and run on another processor if need be.
 *
 * Created By: Dan Salluce
 * February 16, 2004
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
  #include <fcntl.h>
  #include <sys/types.h>
  #include <sys/ipc.h>
  #include <sys/shm.h>
  #include <sys/mman.h>
/* APPLICATION INCLUDES */
  #include "struct_shared_type.h"


/* DEFINES */
  /* S-function Parameters */
  #define SAMPLE_TIME_PARAM(S) ssGetSFcnParam(S, 0) /* Parameter #0: Sample Time */
  /* You must specify the S_FUNCTION_NAME as the name of your S-function */
  #define S_FUNCTION_NAME  shared_mem
  #define S_FUNCTION_LEVEL 2
  /* Need to include simstruc.h for the definition of the SimStruct and
   * its associated macro definitions.*/
  #include "simstruc.h"

  /* Sizes */
  #define G18 global18_

/* GLOBALS */
  int     g18_id;           /* ID of existing common area */
  long    g18_size;         /* bytes of global, rounded up */
  

  /* FUNCTION PROTOTYPES */

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
    ssSetNumSFcnParams(S, 1);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    if (!ssSetNumInputPorts(S, 1)) return;
    ssSetInputPortWidth(S, 0, 3);

    /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     * See matlabroot/simulink/src/sfuntmpl_directfeed.txt
     */
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    /*ssSetInputPortRequiredContiguous(S, 0, true); /* Direct input signal access */
        
    if (!ssSetNumOutputPorts(S, 0)) return;
    /*ssSetOutputPortWidth(S, 0, 1);*/

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
    ssSetSampleTime(S, 0, *mxGetPr(SAMPLE_TIME_PARAM(S)));
    ssSetOffsetTime(S, 0, 0.0);
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
    g18_size = ((sizeof(global18_) + BLOCK_SIZE - 1) / BLOCK_SIZE)*BLOCK_SIZE;
    g18_id = shmget((key_t) G18_KEY, g18_size, IPC_CREAT | 0770);
    if (g18_id < 0)
    {
      printf("shmget(G18_KEY)");
    }
    if (munmap(&global18_, g18_size) < 0)
    {
      printf("munmap(G18_KEY)");
    }
    if ((int) shmat(g18_id, (char *) &global18_, 0) < 0)
    {
      perror("shmat(G18_KEY)");
    }
    
  }
#endif /*  MDL_START */


/* Function: mdlOutputs =======================================================


 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  InputRealPtrsType u1 = ssGetInputPortRealSignalPtrs(S, 0);
  /*real_T           *y1 = ssGetOutputPortSignal(S,0);*/

  int_T             i;
  double sampleTime = *mxGetPr(SAMPLE_TIME_PARAM(S));
  /*A = *u1[0];*/
  /*y1[0] = (double)A;*/
  
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
