/* NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I */

/*  Filename: bus2ts.c
 *  Function: MATLAB/SIMULINK S-Function Source Code
 *
 *  The bus2ts s-function records a Simulink signal to a timeseries .mat
 *  file via a binary intermediate step.  This s-function produces two
 *  files:
 *      (1) <BusName>.bin which contains the time history data
 *      (2) <BusName>_Log.m which is a MATLAB function that is used after
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
 * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/774
 *
 * Copyright Northrop Grumman Corp 2012
 * Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
 * http://trac.ngst.northgrum.com/CSA/
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/SFunctions/BusToTS/bus2ts.c $
 * $Rev: 3009 $
 * $Date: 2013-09-04 20:09:37 -0500 (Wed, 04 Sep 2013) $
 * $Author: sufanmi $
 */

/* S-function name */
#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  bus2ts

#define GET_SAVE_DIRECTORY(S) ssGetSFcnParam(S, 0)
#define GET_BUS_NAME(S)       ssGetSFcnParam(S, 1)
#define GET_SIGNAL_INFO(S)    ssGetSFcnParam(S, 2)
#define GET_SAMPLE_TIME(S)    ssGetSFcnParam(S, 3)
#define GET_LOG_NAME(S)       ssGetSFcnParam(S, 4)

#define PW_DATA_NAME(S)      ssGetPWorkValue(S, 0)
#define PW_LOG_NAME(S)       ssGetPWorkValue(S, 1)

#define IW_TIMESTEP_CTR(S)   ssGetIWorkValue(S, 0)
#define IW_BYTE_CTR(S)       ssGetIWorkValue(S, 1)

#define SAVE_DIRECTORY_SIZE  150
#define BUS_NAME_SIZE        100
#define FILENAME_TYPE_SIZE   5
#define FULL_FILENAME_SIZE  (SAVE_DIRECTORY_SIZE+BUS_NAME_SIZE+FILENAME_TYPE_SIZE)

/* Required Include for Simulink Structures and Definitions */
#include "simstruc.h"
#include "tmwtypes.h"
#include <stdio.h>
#include <string.h>

/* Initialize Sizes */
static void mdlInitializeSizes(SimStruct *S) {
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

    ssSetInputPortWidth(S, 0, DYNAMICALLY_SIZED);
    ssSetInputPortComplexSignal(S, 0, COMPLEX_NO);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    
//     ssSetInputPortDataType(S, 0, DYNAMICALLY_TYPED);
    
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
    /* 0: P Work: Data stream Full Filename */
    /* 1: P Work: Log stream Full Filename */
    ssSetNumPWork(S, 2);
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    ssSetOptions(S, 0);
}

/* Initialize Sample Times */
static void mdlInitializeSampleTimes(SimStruct *S) {
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
static void mdlStart(SimStruct *S) {
    
    /* P Work: Filename */
    void **PWork = ssGetPWork(S);
    char * save_directory;
    char * bus_name;
    char * signal_info;
    char * log_name;
    char * data_full;
    char * log_full;
    
    FILE * data_stream = NULL;
    FILE * log_stream = NULL;
    int_T numSignals = ssGetInputPortWidth(S,0);
    
    int_T BUS_INFO_SIZE = (numSignals * 100);
        
    save_directory = malloc( SAVE_DIRECTORY_SIZE * sizeof(char) );
    bus_name        = malloc( BUS_NAME_SIZE * sizeof(char) );
    signal_info     = malloc( BUS_INFO_SIZE * sizeof(char) );
    log_name       = malloc( BUS_NAME_SIZE * sizeof(char) );
    data_full      = malloc( FULL_FILENAME_SIZE * sizeof(char) );
    log_full       = malloc( FULL_FILENAME_SIZE * sizeof(char) );
    
    /* Retrieve the name of the datafile */
    mxGetString(GET_SAVE_DIRECTORY(S), save_directory, SAVE_DIRECTORY_SIZE);
    mxGetString(GET_BUS_NAME(S), bus_name, BUS_NAME_SIZE);
    mxGetString(GET_SIGNAL_INFO(S), signal_info, BUS_INFO_SIZE);
    mxGetString(GET_LOG_NAME(S), log_name, BUS_NAME_SIZE);
    
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
    
    /* Open the datafile: (need to clear it out first if already exists) */
    sprintf(data_full, "%s%s.bin", save_directory, bus_name);
    PWork[0] = data_full;
    
    data_stream = fopen( data_full, "w" );
    if(data_stream == NULL) {
        printf("BUS2TS :: Failed to open datafile '%s'.  Exiting...\n", data_full);
    }
    else {
//         printf("BUS2TS :: Opening datafile for writing: '%s'\n", data_full);
        fclose(data_stream);
    }
    
    /* Open the logfile: */
    sprintf(log_full, "%s%s.m", save_directory, log_name);
    PWork[1] = log_full;
    
    log_stream = fopen( log_full, "w" );
    if(log_stream == NULL) {
        printf("BUS2TS :: Failed to open logfile '%s'.  Exiting...\n", log_full);
    }
    else {
//         printf("BUS2TS :: Opening logfile for writing: '%s'\n", log_full);
        fprintf(log_stream, "function ts = %s(lstDesired, flgDelete)\n", log_name);
        fprintf(log_stream, "%% Time History Information:\n");
        fprintf(log_stream, "SaveDirectory = '%s';\n", save_directory);
        fprintf(log_stream, "BusName       = '%s';\n", bus_name);
        fprintf(log_stream, "binFilename   = '%s';\n", data_full);
        
        fprintf(log_stream, "%s\n", signal_info);
        
        fprintf(log_stream, "numRefSignals = %d;  %% [int]\n", numSignals);
        
        /* Assumption is that the bus has been converted to a vector of doubles */
        fprintf(log_stream, "SrcDataType   = 'double'; %% 'string'\n");
        fprintf(log_stream, "SrcDTBitSize  = %d; %% [bytes]\n", sizeof(double));
        
    }
    fclose(log_stream);
    free(save_directory);
    free(bus_name);
    free(signal_info);
    free(log_name);
}
#endif /*  MDL_START */

static void mdlOutputs(SimStruct *S, int_T tid) {
    /* Local Variables */
    void **PWork = ssGetPWork(S);
    int_T numSignals = ssGetInputPortWidth(S,0);
    int i;
    int timesteps_saved, bytes_saved;
    double stepsize, simtime;
    
    FILE * data_stream = NULL;
    
    /* Get INPUT ports */
    InputRealPtrsType u0 = ssGetInputPortRealSignalPtrs(S, 0);
    
    data_stream = fopen( PW_DATA_NAME(S), "ab" );
    if(data_stream == NULL) {
        printf("BUS2TS :: Failed to open datafile '%s'.  Exiting...\n",  PW_DATA_NAME(S));
    }
    else {
//         printf("BUS2TS :: Opening '%s'...\n",  PW_DATA_NAME(S));
        
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
        
        fwrite(&simtime, sizeof(double), 1, data_stream);
        bytes_saved = bytes_saved + sizeof(double);

        for (i=0; i<numSignals; i++) {
            fwrite(u0[i], sizeof(double), 1, data_stream);
            bytes_saved = bytes_saved + sizeof(double);
        }
    }
    
    fclose( data_stream );
    
    /*y0[0] = bytes_saved;*/
    ssSetIWorkValue(S, 1, bytes_saved);
}

static void mdlTerminate(SimStruct *S)
{
    /* Pull Constants from PWork Vector */
    void **PWork = ssGetPWork(S);
    FILE * log_stream = NULL;
    int timesteps_saved = IW_TIMESTEP_CTR(S);
    int i;
    log_stream = fopen(PW_LOG_NAME(S), "a+" );
    if(log_stream == NULL) {
        printf("BUS2TS :: Failed to open logfile '%s'.  Exiting...\n", PW_LOG_NAME(S));
    }
    else {
//         printf("BUS2TS :: Opening logfile for appending: '%s'\n", PW_LOG_NAME(S));
        /* Finish off the Log Message */
        fprintf(log_stream, "Timesteps     = %d; %% [int]\n", timesteps_saved);
        
        /* Now add in the MATLAB coded needed to conver the binary file into a timeseries */
        fprintf(log_stream, "\n");
        fprintf(log_stream, "numSignals = size(lstBO, 1);\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "if(nargin == 0)\n");
        fprintf(log_stream, "    lstDesired = {};\n");
        fprintf(log_stream, "end\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "if(isempty(lstDesired))\n");
        fprintf(log_stream, "    lstDesired = lstBO(:,1);\n");
        fprintf(log_stream, "end\n");
        fprintf(log_stream, "numDesired = size(lstDesired, 1);\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "arrExtract = [];\n");
        fprintf(log_stream, "for iDesired = 1:numDesired\n");
        fprintf(log_stream, "    curDesired = lstDesired{iDesired, 1};\n");
        fprintf(log_stream, "    iExtract = max(strcmp(curDesired, lstBO(:,1)).*[1:numSignals]');\n");
        fprintf(log_stream, "    if(iExtract > 0)\n");
        fprintf(log_stream, "        arrExtract = [arrExtract; iExtract];\n");
        fprintf(log_stream, "    end\n");
        fprintf(log_stream, "end\n");
        fprintf(log_stream, "numExtract = length(arrExtract);\n");
        fprintf(log_stream, "flgExtractMatchesRef = (numSignals == numExtract);\n");
        fprintf(log_stream, "if((nargin < 2) || isempty(flgDelete))\n");
        fprintf(log_stream, "    flgDelete = flgExtractMatchesRef;\n");
        fprintf(log_stream, "end\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "fid = fopen(binFilename, 'rb');\n");
        fprintf(log_stream, "t = fread(fid, [Timesteps 1], SrcDataType, numRefSignals*SrcDTBitSize);\n");
        fprintf(log_stream, "offset = SrcDTBitSize;\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "for iExtract = 1:numExtract\n");
        fprintf(log_stream, "    iSignal = arrExtract(iExtract);\n");
        fprintf(log_stream, "    fseek(fid, offset, 'bof');\n");
        fprintf(log_stream, "    curSignal   = lstBO{iSignal, 1};\n");
        fprintf(log_stream, "    curSignalName = [BusName '.' curSignal];\n");
        fprintf(log_stream, "    curDim      = lstBO{iSignal, 2};\n");
        fprintf(log_stream, "    curDatatype = lstBO{iSignal, 3};\n");
        fprintf(log_stream, "    if(isempty(curDatatype))\n");
        fprintf(log_stream, "        curDatatype = 'double';\n");
        fprintf(log_stream, "    end\n");
        fprintf(log_stream, "    curUnits = lstBO{iSignal, 4};\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "    switch curDatatype\n");
        fprintf(log_stream, "        case {'double'; 'single'}\n");
        fprintf(log_stream, "            curInterpMethod = 'linear';\n");
        fprintf(log_stream, "        otherwise\n");
        fprintf(log_stream, "            curInterpMethod = 'zoh';\n");
        fprintf(log_stream, "    end\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "    disp(sprintf('%%s : %%d/%%d : Building #%%d: ''%%s.mat''', mfilename, iExtract, numExtract, iSignal, curSignalName));\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "    bytes2skip = (numRefSignals - curDim + 1)*SrcDTBitSize;\n");
        fprintf(log_stream, "    y = fread(fid, [curDim Timesteps], [num2str(curDim) '*' SrcDataType '=>' curDatatype], bytes2skip)';\n");
        fprintf(log_stream, "    if(strcmp(curDatatype, 'boolean'))\n");
        fprintf(log_stream, "        y = (y > 0.5); %% Convert to logical\n");
        fprintf(log_stream, "    end\n");
        fprintf(log_stream, "    ts = timeseries(y,t);\n");
        fprintf(log_stream, "    ts.Name = curSignalName;\n");
        fprintf(log_stream, "    ts.DataInfo.Units = curUnits;\n");
        fprintf(log_stream, "    ts = setinterpmethod(ts, curInterpMethod);\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "    matFilename = sprintf('%%s%%s.mat', SaveDirectory, curSignalName);\n");
        fprintf(log_stream, "    save(matFilename, 'ts');\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "    offset = offset + curDim*SrcDTBitSize;\n");
        fprintf(log_stream, "end\n");
        fprintf(log_stream, "fclose(fid);\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "if(flgDelete)\n");
        fprintf(log_stream, "    recycle(binFilename);\n");
        fprintf(log_stream, "end\n");
        fprintf(log_stream, "\n");
        fprintf(log_stream, "if(numExtract == 1)\n");
        fprintf(log_stream, "    assignin('base', 'ts', ts);\n");
        fprintf(log_stream, "end\n");
        
        fclose( log_stream );
    }
    
    if(timesteps_saved == 0) {
        /* If no data has been recorded, go ahead and delete the log and opened binary file */
        printf("BUS2TS :: Removing '%s' since no data recorded\n", PW_DATA_NAME(S));
        remove(PW_DATA_NAME(S));
        printf("BUS2TS :: Removing '%s' since no data recorded\n", PW_LOG_NAME(S));
        remove(PW_LOG_NAME(S));
    }
    else {
    }
    
    /* Free up the memory */
    for (i = 0; i < ssGetNumPWork(S); i++) {
        PWork[i] = NULL;
    }
    
}

/* Final Required MATLAB/SIMULINK Interface Code */
#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif
