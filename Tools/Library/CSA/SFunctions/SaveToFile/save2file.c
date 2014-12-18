/* NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I */

/*  Filename: save2file.c
 *  Function: MATLAB/SIMULINK S-Function Source Code
 *
 *  The save2file s-function records a Simulink signal to a user defined
 *  tab-delimited file (e.g. .dat, .txt).  The function works on signals
 *  of any size (it is dynamically sized).  Hence you can treat this block
 *  the same as a regular Simulink 'ToWorkspace' block.
 *
 *  Notes: You can pass a muxed signal into the block provided that they
 *      are dimensioned alike.  That is, you cannot pass a single signal
 *      and a [3x3] into this block.
 *
 *  Simulink Example: TEST_save2file.mdl.
 *
 */

/* S-function name */
#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  save2file

/* Required Include for Simulink Structures and Definitions */
#include "simstruc.h"

#include <stdio.h>
#include <string.h>

/* Initialize Sizes */
static void mdlInitializeSizes(SimStruct *S)
{
    /* Set Number of Parameters */
    ssSetNumSFcnParams(S, 4);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
    {
        return;
    }
    
    /* Set Number of States */
    ssSetNumContStates(S,0);
    ssSetNumDiscStates(S,0);
    
    /* Set number of INPUT ports */
    if (!ssSetNumInputPorts(S,1)) return;
    
    /* Set INPUT port widths */
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    
    /* Set DIRECT FEED THROUGHS of INPUT ports */
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    
    /* Set number of OUTPUT Ports */
    if (!ssSetNumOutputPorts(S, 0)) return;
    
    /* Define Sample Time */
    ssSetNumSampleTimes(S, 1);
    
    /* Define Work Vectors */
    ssSetNumRWork(S, 2);
    ssSetNumIWork(S, 3);
    ssSetNumPWork(S, 1);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    ssSetOptions(S, 0);
}

/* Initialize Sample Times */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, *mxGetPr(ssGetSFcnParam(S, 1)));
    ssSetOffsetTime(S, 0, 0.0);
}

/**********************************************************************/
/* START OF SIMULINK S-FUNCTION CALL: mdlInitializeConditions         */
/* Initialization of States                                           */
/**********************************************************************/
#define MDL_INITIALIZE_CONDITIONS
#if defined(MDL_INITIALIZE_CONDITIONS)
static void mdlInitializeConditions(SimStruct *S)
{
}
#endif

#define MDL_START  /* Change to #undef to remove function */
#if defined(MDL_START)
  /* Function: mdlStart ===================================================
   * Abstract:
   *    This function is called once at start of model execution. If you
   *    have states that should be initialized once, this is the place
   *    to do it.
   */
static void mdlStart(SimStruct *S)
{
    int_T enable_record = (int)*(mxGetPr(ssGetSFcnParam(S,0)));
    int_T decimation = (int)*(mxGetPr(ssGetSFcnParam(S,3)));
    
    /* Enable Record */
    ssSetIWorkValue(S, 0, enable_record);
    
    /* Recording Decimation */
    ssSetIWorkValue(S, 1, decimation);
    
    /* Recording Flag Counter */
    ssSetIWorkValue(S, 2, decimation);

    ssSetRWorkValue(S, 0, *mxGetPr(ssGetSFcnParam(S, 1)));
    ssSetRWorkValue(S, 1, 0);
    
    if (enable_record == 1)
    {
        FILE * data_stream;
        void **PWork = ssGetPWork(S);
        char datafile[32];
                
        /* Retrieve the name of the datafile */
        mxGetString(ssGetSFcnParam(S,2), datafile, 32);
                
        /* Open/Clear the datafile: */
        data_stream = fopen( datafile, "w" );
        
        PWork[0] = data_stream;
        }
}
#endif /*  MDL_START */

static void mdlOutputs(SimStruct *S, int_T tid)
{
    /* Local Variables */
    int i, enable_record;
    int_T width;
    int decCount, decDesired;
    double stepsize, simtime;
    
    FILE *data_stream;
        
    /* Get INPUT ports */
    InputRealPtrsType u1 = ssGetInputPortRealSignalPtrs(S, 0);
    
    /* Get width of INPUT port */
    width = ssGetInputPortWidth(S,0);
    
    /* Retrieve Data from Work Vectors */
    data_stream = (FILE *) ssGetPWorkValue(S,0);
    enable_record = ssGetIWorkValue(S,0);
    
    decDesired = ssGetIWorkValue(S,1);
    decCount = ssGetIWorkValue(S,2);
    
    stepsize = ssGetRWorkValue(S,0);
    simtime = ssGetRWorkValue(S,1);
    
    if (enable_record == 1) {
        if(decCount == decDesired) {
            fprintf(data_stream, "%.15e\t", simtime);
            
            for (i=0; i<width; i++) {
                fprintf(data_stream, "%.15e\t", *u1[i]);
            }
            fprintf(data_stream, "\n");

            simtime = simtime + (stepsize * decDesired);
            ssSetRWorkValue(S, 1, simtime);
        }
        decCount--;
        /*
        printf("%d\n", decCount);
         */
        if(decCount == 0) {
            decCount = decDesired;
        }
        ssSetIWorkValue(S,2, decCount);       
    }
}

static void mdlTerminate(SimStruct *S)
{
    /* Pull Constants from IWork Vector */
    int enable_record = ssGetIWorkValue(S,0);
    int decDesired, width;
    double stepsize, simtime, numpts;
    
    if (enable_record == 1)
    {
        FILE *data_stream;
        char datafile[32];

        data_stream = (FILE *) ssGetPWorkValue(S,0);
        fclose( data_stream );
        
        width      = ssGetInputPortWidth(S,0);
        stepsize   = ssGetRWorkValue(S,0);
        simtime    = ssGetRWorkValue(S,1);
        decDesired = ssGetIWorkValue(S,1);
        
        simtime    = simtime - (stepsize * decDesired);
        numpts     = ((simtime / stepsize) / decDesired) + 1;        
        mxGetString(ssGetSFcnParam(S,2), datafile, 32);
        printf("SAVE2FILE :: Created '%s' :: %.0f Datapoints for %d Signals (%.3f sec @ %dx decimation)\n",
                datafile, numpts, width, simtime, decDesired);
    }
}

/* Final Required MATLAB/SIMULINK Interface Code */
#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif
