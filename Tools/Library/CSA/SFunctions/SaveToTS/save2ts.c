/* NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I */

/*  Filename: save2ts.c
 *  Function: MATLAB/SIMULINK S-Function Source Code
 *
 *  The save2ts s-function records a Simulink signal to a timeseries .mat
 *  file via a binary intermediate step.  This s-function produces two
 *  files:
 *      (1) <SignalName>.bin which contains the time history data
 *      (2) <SignalName>_Log.m which is a MATLAB function that is used after
 *              sim completion to load in the binary file, convert it to
 *              a MATLAB timeseries object, adjust the interpolation and
 *              units, and then save to data to .mat file.
 *
 *  Notes: This block is vectorizable.
 *
 *  Simulink Example: Test_SaveToTS.mdl.
 *
 * VERIFICATION DETAILS:
 * Verified: No
 * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/772
 *
 * Copyright Northrop Grumman Corp 2012
 * Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
 * http://trac.ngst.northgrum.com/CSA/
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/SFunctions/SaveToTS/save2ts.c $
 * $Rev: 2578 $
 * $Date: 2012-10-30 19:35:11 -0500 (Tue, 30 Oct 2012) $
 * $Author: sufanmi $
 */

/* S-function name */
#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  save2ts

#define GET_SAVE_DIRECTORY(S) ssGetSFcnParam(S, 0)
#define GET_SIGNAL_NAME(S)    ssGetSFcnParam(S, 1)
#define GET_SIGNAL_UNITS(S)   ssGetSFcnParam(S, 2)
#define GET_SAMPLE_TIME(S)    ssGetSFcnParam(S, 3)
#define GET_LOG_NAME(S)       ssGetSFcnParam(S, 4)

#define PW_SAVE_DIRECTORY(S) ssGetPWorkValue(S, 0)
#define PW_SIGNAL_NAME(S)    ssGetPWorkValue(S, 1)
#define PW_SIGNAL_UNITS(S)   ssGetPWorkValue(S, 2)
#define PW_DATA_STREAM(S)    ssGetPWorkValue(S, 3)
#define PW_LOG_STREAM(S)     ssGetPWorkValue(S, 4)
#define PW_LOG_NAME(S)       ssGetPWorkValue(S, 5)

#define IW_TIMESTEP_CTR(S)   ssGetIWorkValue(S, 0)
#define IW_BYTE_CTR(S)       ssGetIWorkValue(S, 1)

#define SAVE_DIRECTORY_SIZE 150
#define SIGNAL_NAME_SIZE     32
#define SIGNAL_UNITS_SIZE    32
#define FILENAME_TYPE_SIZE    5
#define FULL_FILENAME_SIZE  (SAVE_DIRECTORY_SIZE+SIGNAL_NAME_SIZE+FILENAME_TYPE_SIZE)

/* Required Include for Simulink Structures and Definitions */
#include "simstruc.h"
#include "tmwtypes.h"
#include <stdio.h>
#include <string.h>

/* Initialize Sizes */
static void mdlInitializeSizes(SimStruct *S)
{
    /* Set Number of Mask Parameters */
    /* Mask Parameters */
    /* 0: Save Directory */
    /* 1: Signal Name */
    /* 2: Signal Units */
    /* 3: Sample Time */
    /* 4: Log Name */
    ssSetNumSFcnParams(S, 5);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
    {
        return;
    }
    
    /* Set Number of States */
    ssSetNumContStates(S,0);
    ssSetNumDiscStates(S,0);
    
    /* Set number of INPUT ports */
    /* 0: Data to Record */
    if (!ssSetNumInputPorts(S,1)) return;
    
    /* Set INPUT port widths */
    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortDataType(S, 0, DYNAMICALLY_TYPED);
    
    /* Set DIRECT FEED THROUGHS of INPUT ports */
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    
    /* Set number of OUTPUT Ports */
    /* 0: Number of bytes saved to current file */
    if (!ssSetNumOutputPorts(S, 0)) return;
    
    /*ssSetOutputPortWidth(S, 0, 1);*/
    
    /* Define Sample Time */
    ssSetNumSampleTimes(S, 1);
    
    /* Define Work Vectors */
    /* 0: R Work: Baserate/Sample Time */
    /* 1: R Work: Simtime (Internally Computed) */
    ssSetNumRWork(S, 2);
    
    /* Define I Work Vectors */
    /* 0: I Work: Number of Timesteps recorded */
    /* 1: I Work: Recorded bytes */
    ssSetNumIWork(S, 2);
    
    /* Define P Work Vectors */
    /* 0: P Work: Save Directory */
    /* 1: P Work: Signal Name */
    /* 2: P Work: Signal Units */
    /* 3: P Work: Data stream */
    /* 4: P Work: Log stream */
    /* 5: P Work: Log Name */
    ssSetNumPWork(S, 6);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    ssSetOptions(S, 0);
}

/* Initialize Sample Times */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, *mxGetPr(GET_SAMPLE_TIME(S)));
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
    /* P Work: Filename */
    void **PWork = ssGetPWork(S);
    char * save_directory;
    char * signal_name;
    char * signal_units;
    char * log_name;
    DTypeId      dtId         = ssGetInputPortDataType(S, 0);
    FILE * data_stream = NULL;
    FILE * log_stream = NULL;
    int_T numSignals = ssGetInputPortWidth(S,0);
    
    char filename_full[FULL_FILENAME_SIZE];
    char log_full[FULL_FILENAME_SIZE];
    
    save_directory = malloc( SAVE_DIRECTORY_SIZE * sizeof(char) );
    signal_name    = malloc( SIGNAL_NAME_SIZE * sizeof(char) );
    signal_units   = malloc( SIGNAL_UNITS_SIZE * sizeof(char) );
    log_name       = malloc( SIGNAL_NAME_SIZE * sizeof(char) );
    
    /* Retrieve the name of the datafile */
    mxGetString(GET_SAVE_DIRECTORY(S), save_directory, SAVE_DIRECTORY_SIZE);
    mxGetString(GET_SIGNAL_NAME(S), signal_name, SIGNAL_NAME_SIZE);
    mxGetString(GET_SIGNAL_UNITS(S), signal_units, SIGNAL_UNITS_SIZE);
    mxGetString(GET_LOG_NAME(S), log_name, SIGNAL_NAME_SIZE);
    
    /* Initialize R Work Vectors */
    /* 0: R Work: Set Sample Time */
    ssSetRWorkValue(S, 0, (double) ssGetSampleTime(S, 0));
    
    /* 1: R Work: Set Simtime */
    /*    Setting to -DT.  This will get incremented back to 0 in mdlOutput */
    ssSetRWorkValue(S, 1, -ssGetRWorkValue(S,0));
    
    /* Initialize I Work Vectors */
    /* 0: I Work: Total Timesteps recorded */
    ssSetIWorkValue(S, 0, 0);
    
    /* 1: I Work: Set Recorded bytes */
    ssSetIWorkValue(S, 1, 0);
    
    /* Initialize P Work Vectors */
    PWork[0] = save_directory;
    PWork[1] = signal_name;
    PWork[2] = signal_units;
    
    /* Open the datafile: */
    sprintf(filename_full, "%s%s.bin", save_directory, signal_name);
    data_stream = fopen( filename_full, "wb" );
    PWork[3] = data_stream;
    
    /* Open the logfile: */
    sprintf(log_full, "%s%s.m", save_directory, log_name);
    log_stream = fopen( log_full, "w" );
    
    fprintf(log_stream, "function ts = ConvertBin2TS()\n");
    fprintf(log_stream, "%% Time History Information:\n");
    fprintf(log_stream, "SignalName    = '%s';\n", signal_name);
    fprintf(log_stream, "binFilename   = '%s';\n", filename_full);
    fprintf(log_stream, "SignalUnits   = '%s';\n", signal_units);
    fprintf(log_stream, "SignalDim     = %d;  %% [int]\n", numSignals);

    switch(dtId)
    {
        case SS_DOUBLE:
        {
//             printf("SAVE2TS :: '%s' is a 'double'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'double';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(double));
            fprintf(log_stream, "DestDataType  = 'double';\n");
            fprintf(log_stream, "InterpMethod  = 'linear';\n");
            break;
        }
        case SS_SINGLE:
        {
//             printf("SAVE2TS :: '%s' is a 'single'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'single';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(float));
            fprintf(log_stream, "DestDataType  = 'single';\n");
            fprintf(log_stream, "InterpMethod  = 'linear';\n");
            break;
        }
        case SS_INT8:
        {
//             printf("SAVE2TS :: '%s' is an 'int8'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'int8';\n");
            fprintf(log_stream, "SrcDTBitSize     = %d; %% [bytes]\n", sizeof(int8_T));
            fprintf(log_stream, "DestDataType  = 'int8';\n");
            fprintf(log_stream, "InterpMethod  = 'zoh';\n");
            break;
        }
        case SS_UINT8:
        {
//             printf("SAVE2TS :: '%s' is a 'uint8'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'uint8';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(uint8_T));
            fprintf(log_stream, "DestDataType  = 'uint8';\n");
            fprintf(log_stream, "InterpMethod  = 'zoh';\n");
            break;
        }
        case SS_INT16:
        {
//             printf("SAVE2TS :: '%s' is an 'int16'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'int16';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(int16_T));
            fprintf(log_stream, "DestDataType  = 'int16';\n");
            fprintf(log_stream, "InterpMethod  = 'zoh';\n");
            break;
        }
        case SS_UINT16:
        {
//             printf("SAVE2TS :: '%s' is a 'uint16'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'uint16';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(uint16_T));
            fprintf(log_stream, "DestDataType  = 'uint16';\n");
            fprintf(log_stream, "InterpMethod  = 'zoh';\n");
            break;
        }
        case SS_INT32:
        {
//             printf("SAVE2TS :: '%s' is an 'int32'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'int32';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(int32_T));
            fprintf(log_stream, "DestDataType  = 'int32';\n");
            fprintf(log_stream, "InterpMethod  = 'zoh';\n");
            break;
        }
        case SS_UINT32:
        {
//             printf("SAVE2TS :: '%s' is a 'uint32'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'uint32';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(uint32_T));
            fprintf(log_stream, "DestDataType  = 'uint32';\n");
            fprintf(log_stream, "InterpMethod  = 'zoh';\n");
            break;
        }
        case SS_BOOLEAN:
        {
//             printf("SAVE2TS :: '%s' is a 'boolean'\n", signal_name);
            fprintf(log_stream, "SrcDataType   = 'uint8';\n");
            fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(uint8_T));
            fprintf(log_stream, "DestDataType  = 'logical';\n");
            fprintf(log_stream, "InterpMethod  = 'zoh';\n");
            break;
        }
    }
    PWork[4] = log_stream;
    PWork[5] = log_name;
}
#endif /*  MDL_START */

static void mdlOutputs(SimStruct *S, int_T tid)
{
    /* Local Variables */
    int_T numSignals = ssGetInputPortWidth(S,0);
    int i;
    int timesteps_saved, bytes_saved;
    double stepsize, simtime;
    DTypeId      dtId         = ssGetInputPortDataType(S, 0);
    
    void **PWork = ssGetPWork(S);
    FILE * data_stream = NULL;
    
    /* Get INPUT ports */
//     InputRealPtrsType u0 = ssGetInputPortRealSignalPtrs(S, 0);
    InputPtrsType u0Ptrs = ssGetInputPortSignalPtrs(S,0);
    
    /* Get OUTPUT ports */
    /*real_T  *y0 = ssGetOutputPortSignal(S,0);*/
    
    /* Retrieve Data from Work Vectors */
    data_stream = (FILE *) PW_DATA_STREAM(S);
    
    /* Retrieve R Work Values */
    stepsize = ssGetRWorkValue(S,0);
    simtime = (double) ssGetRWorkValue(S,1);
    simtime = simtime + stepsize;
    ssSetRWorkValue(S, 1, simtime);
    
    /* Retrieve I Work Values */
    timesteps_saved = IW_TIMESTEP_CTR(S);
    bytes_saved     = IW_BYTE_CTR(S);
    
    /* Record the current data */
    timesteps_saved = timesteps_saved + 1;
    ssSetIWorkValue(S, 0, timesteps_saved);
    
    fwrite(&simtime, sizeof(double), 1, PW_DATA_STREAM(S));
    bytes_saved = bytes_saved + sizeof(double);
    
    switch(dtId)
    {
        case SS_DOUBLE:
        {
            InputRealPtrsType u0  = (InputRealPtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
                fwrite(u0[i], sizeof(double), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(double);
            }
            break;
        }
        case SS_SINGLE:
        {
            InputReal32PtrsType u0  = (InputReal32PtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
                fwrite(u0[i], sizeof(float), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(float);
            }
            break;
        }
        case SS_INT8:
        {
            for (i=0; i<numSignals; i++) {
                InputInt8PtrsType u0  = (InputInt8PtrsType)u0Ptrs;
                fwrite(u0[i], sizeof(int8_T), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(int8_T);
            }
            break;
        }
        case SS_UINT8:
        {
            InputUInt8PtrsType u0  = (InputUInt8PtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
                fwrite(u0[i], sizeof(uint8_T), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(uint8_T);
            }
            break;
        }
        case SS_INT16:
        {
            InputInt16PtrsType u0  = (InputInt16PtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
                fwrite(u0[i], sizeof(int16_T), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(int16_T);
            }
            break;
        }
        case SS_UINT16:
        {
            InputUInt16PtrsType u0  = (InputUInt16PtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
                fwrite(u0[i], sizeof(uint16_T), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(uint16_T);
            }
            break;
        }
        case SS_INT32:
        {
            InputInt32PtrsType u0  = (InputInt32PtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
                fwrite(u0[i], sizeof(int32_T), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(int32_T);
            }
            break;
        }
        case SS_UINT32:
        {
            InputUInt32PtrsType u0  = (InputUInt32PtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
                fwrite(u0[i], sizeof(uint32_T), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(uint32_T);
            }
            break;
        }
        case SS_BOOLEAN:
        {
            /* boolean */
            InputBooleanPtrsType u0  = (InputBooleanPtrsType)u0Ptrs;
            for (i=0; i<numSignals; i++) {
//                 printf("%d %d\n", sizeof(boolean_T), *u0[i]);
                fwrite(u0[i], sizeof(uint8_T), 1, PW_DATA_STREAM(S));
                bytes_saved = bytes_saved + sizeof(uint8_T);
            }
            break;
        }
    }

    /*y0[0] = bytes_saved;*/
    ssSetIWorkValue(S, 1, bytes_saved);
}

static void mdlTerminate(SimStruct *S)
{
    /* Pull Constants from PWork Vector */
    void **PWork = ssGetPWork(S);

    char * signal_name;
    int timesteps_saved;
    char filename_full[FULL_FILENAME_SIZE];
    sprintf(filename_full, "%s%s.bin", PW_SAVE_DIRECTORY(S), PW_SIGNAL_NAME(S));
    
    /* Retrieve the name of the datafile */
    signal_name = PW_SIGNAL_NAME(S);
    timesteps_saved = IW_TIMESTEP_CTR(S);
    
    /* Close the current binary file */
    fclose( PW_DATA_STREAM(S) );
    
    /* Finish off the Log Message */
    fprintf(PW_LOG_STREAM(S), "Timesteps     = %d; %% [int]\n", timesteps_saved);
    fprintf(PW_LOG_STREAM(S), "\n");
    /* Now add in the MATLAB coded needed to conver the binary file into a timeseries */
    fprintf(PW_LOG_STREAM(S), "\n");
    fprintf(PW_LOG_STREAM(S), "fid = fopen(binFilename, 'rb');\n");
    fprintf(PW_LOG_STREAM(S), "t = fread(fid, [Timesteps 1], 'double', SignalDim*SrcDTBitSize);\n");
    fprintf(PW_LOG_STREAM(S), "fseek(fid, 8, 'bof');\n");
    fprintf(PW_LOG_STREAM(S), "y = fread(fid, [Timesteps SignalDim], [num2str(SignalDim) '*' SrcDataType '=>' DestDataType], 8);\n");
    fprintf(PW_LOG_STREAM(S), "fclose(fid);\n");
    fprintf(PW_LOG_STREAM(S), "ts = timeseries(y,t);\n");
    fprintf(PW_LOG_STREAM(S), "ts.Name = SignalName;\n");
    fprintf(PW_LOG_STREAM(S), "ts.DataInfo.Units = SignalUnits;\n");
    fprintf(PW_LOG_STREAM(S), "ts = setinterpmethod(ts, InterpMethod);\n");
      
    fprintf(PW_LOG_STREAM(S), "matFilename = strrep(binFilename, '.bin', '.mat');\n");
    fprintf(PW_LOG_STREAM(S), "save(matFilename, 'ts');\n");
    fprintf(PW_LOG_STREAM(S), "recycle(binFilename);\n");
    fprintf(PW_LOG_STREAM(S), "\n");
    fprintf(PW_LOG_STREAM(S), "if(nargout == 0)\n");
    fprintf(PW_LOG_STREAM(S), "    assignin('base', 'ts', ts);\n");
    fprintf(PW_LOG_STREAM(S), "end\n");
    
    fclose( PW_LOG_STREAM(S) );
    if(timesteps_saved == 0)
    {
        /* If no data has been recorded, go ahead and delete the log and opened binary file */
        /* Remove the Log File */
        printf("SAVE2TS :: Removing '%s' since no data recorded\n", filename_full);
        remove(filename_full);
        sprintf(filename_full, "%s%s.m", PW_SAVE_DIRECTORY(S), PW_LOG_NAME(S));
        printf("SAVE2TS :: Removing '%s' since no data recorded\n", filename_full);
        remove(filename_full);
    }
    else
    {
//         printf("SAVE2TS :: Logging of '%s' data complete.  Details cataloged in '%s.m'.\n",
//                 signal_name, PW_LOG_NAME(S));
    }
    
}

/* Final Required MATLAB/SIMULINK Interface Code */
#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif
