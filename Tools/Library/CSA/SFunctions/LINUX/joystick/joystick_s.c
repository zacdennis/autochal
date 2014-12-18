/*
NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
*/
/*
 * This C code will allow the mouse position to be outputted from an S-Function
 * block in Matlab's Simulink. The file is set to display 0 --> 1 in x direction
 * and 0 --> 1 in y direction with positive being right and down, respectively.
 *
 * Be sure to change the divisors for the screen resoultion. It is currently set to
 * work with 1024 x 768 resolutions.
 * There are no inputs to this block and a mouse is needed on the machine.
 *
 * Created By: Dan Salluce and Deena Tin
 * October 1, 2003
 *
 * rev 1 - DS November 12, 2004
 * Revised to output the correct buttons and axes for the Logitech Cordless Freedom
 * 2.4 GHz under Suse 9.1
 */

    #include <stdio.h>                              
    #include <stdlib.h>
    #include <unistd.h>
    #include <errno.h>
    #include <string.h>
    #include <sys/types.h>
    #include <sys/ioctl.h>
    #include <linux/joystick.h>
    #include <fcntl.h>

    #define JOY_DEV "/dev/input/js0"

    int joy_fd, *axis=NULL, num_of_axis=0, num_of_buttons=0, x;
    char *button=NULL, name_of_joystick[80];
    struct js_event js;


/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl_basic with the name of your S-function).
 */

#define S_FUNCTION_NAME  joystick_s
#define S_FUNCTION_LEVEL 2

#define ENABLEDJOY(S) ssGetSFcnParam(S, 0)

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"

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

int enabledJoystick = 0;

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
	/*ssSetNumInputPorts(S, 1);*/

    if (!ssSetNumInputPorts(S, 0)) return;
    /*ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortRequiredContiguous(S, 0, true); /*direct input signal access*/
    /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     * See matlabroot/simulink/src/sfuntmpl_directfeed.txt.
     */
    /*ssSetInputPortDirectFeedThrough(S, 0, 1);*/

    if (!ssSetNumOutputPorts(S, 2)) return;
    ssSetOutputPortWidth(S, 0, 4);
    ssSetOutputPortWidth(S, 1, 10);

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
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    
    enabledJoystick = (int)*mxGetPr(ENABLEDJOY(S)); /* Get the ENABLED Parameter */

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
      if (enabledJoystick == 1)
      {
    
/*close( joy_fd );*/
    if( ( joy_fd = open(JOY_DEV, O_RDONLY)) == -1 )
    {
      printf( "Couldn't open joystick\n" );
    }

      ioctl( joy_fd, JSIOCGAXES, &num_of_axis );
      ioctl( joy_fd, JSIOCGBUTTONS, &num_of_buttons );
      ioctl( joy_fd, JSIOCGNAME(80), &name_of_joystick );


      axis = (int *) calloc( num_of_axis, sizeof( int ) );
      button = (char *) calloc( num_of_buttons, sizeof( char ) );

      printf("Joystick detected: %s\n\t%d axis\n\t%d buttons\n\n"
      , name_of_joystick
      , num_of_axis
      , num_of_buttons );

      fcntl( joy_fd, F_SETFL, O_NONBLOCK );	/* use non-blocking mode */
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
    /*const real_T *u = (const real_T*) ssGetInputPortSignal(S,0);*/
    real_T       *y1 = ssGetOutputPortSignal(S,0);
    real_T       *y2 = ssGetOutputPortSignal(S,1);    

    if (enabledJoystick == 1)
    {
        read(joy_fd, &js, sizeof(struct js_event));

    /* see what to do with the event */
    switch (js.type & ~JS_EVENT_INIT)
    {
      case JS_EVENT_AXIS:
      axis   [ js.number ] = js.value;
      break;
      case JS_EVENT_BUTTON:
      button [ js.number ] = js.value;
      break;
    }
  
    y1[0] = (float)axis[0]/32767.0;
    y1[1] = (float)axis[1]/32767.0;
    y1[2] = (float)axis[2]/32767.0;
    y1[3] = (float)axis[3]/32767.0;
/*    y1[4] = (float)axis[4]/32767.0;*/
/*    y1[5] = (float)axis[5]/32767.0;*/
/*    y1[6] = (float)axis[6]/32767.0;*/
/*    y1[7] = (float)axis[7]/32767.0;*/
/*    y1[2] = (float)axis[8]/32767.0;*/
/*    y1[3] = (float)axis[9]/32767.0;*/

    y2[0] = button[0];
    y2[1] = button[1];
    y2[2] = button[2];
    y2[3] = button[3];
    y2[4] = button[4];
    y2[5] = button[5];
    y2[6] = button[6];
    y2[7] = button[7];
    y2[8] = button[8];
    y2[9] = button[9];
    /*y2[10] = button[10];
    y2[11] = button[11];
    y2[12] = button[12];
    y2[13] = button[13];
    y2[14] = button[14];
    y2[15] = button[15];
    y2[16] = button[16];
    y2[17] = button[17];*/
    }
       
}



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
  close( joy_fd );
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
