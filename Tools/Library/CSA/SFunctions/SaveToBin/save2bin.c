/* NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I */

/*  Filename: save2bin.c
 *  Function: MATLAB/SIMULINK S-Function Source Code
 *
 *  The save2bin s-function records a Simulink signal to a user defined
 *  binary file (.bin).  The function works on signals of any size (it is
 *  dynamically sized).  This block is similar to the Simulink 'To File'
 *  block.
 *
 *  Notes: You can pass a muxed signal into the block provided that they
 *      are dimensioned alike.  That is, you cannot pass a single signal
 *      and a [3x3] into this block.
 *
 *  Simulink Example: Test_SaveToBin.mdl.
 *
 * VERIFICATION DETAILS:
 * Verified: No
 * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/237
 *
 * Copyright Northrop Grumman Corp 2012
 * Maintained by: GN&C Technology (Dept 9V21) - Aerospace Systems - Redondo Beach, CA
 * http://trac.ngst.northgrum.com/CSA/
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/SFunctions/SaveToBin/save2bin.c $
 * $Rev: 2564 $
 * $Date: 2012-10-22 16:54:02 -0500 (Mon, 22 Oct 2012) $
 * $Author: sufanmi $
 */

/* S-function name */
#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  save2bin

#define GET_SAVE_DIRECTORY(S) ssGetSFcnParam(S, 0)
#define GET_FILENAME_ROOT(S)  ssGetSFcnParam(S, 1)
#define GET_FILENAME_TYPE(S)  ssGetSFcnParam(S, 2)
#define GET_MAX_FILE_SIZE(S)  ssGetSFcnParam(S, 3)
#define GET_REF_TEXTFILE(S)   ssGetSFcnParam(S, 4)
#define GET_SAMPLE_TIME(S)    ssGetSFcnParam(S, 5)
#define GET_RECORD_TIME(S)    ssGetSFcnParam(S, 6)

#define GET_FULL_FILE_ROOT(S) ssGetPWorkValue(S, 0)
#define GET_FILENAME_EXT(S)   ssGetPWorkValue(S, 1)
#define GET_DATA_STREAM(S)    ssGetPWorkValue(S, 2)
#define GET_LOG_STREAM(S)     ssGetPWorkValue(S, 3)
#define GET_FILE_ROOT(S)      ssGetPWorkValue(S, 4)

#define SAVE_DIRECTORY_SIZE 150
#define FILENAME_ROOT_SIZE  32
#define FILENAME_TYPE_SIZE   5
#define FULL_FILENAME_SIZE  (SAVE_DIRECTORY_SIZE+FILENAME_ROOT_SIZE+FILENAME_TYPE_SIZE)

/* Required Include for Simulink Structures and Definitions */
#include "simstruc.h"

#include <stdio.h>
#include <string.h>

/* Initialize Sizes */
static void mdlInitializeSizes(SimStruct *S)
{
    /* Set Number of Mask Parameters */
    /* Mask Parameters */
    /* 0: Save Directory */
    /* 1: Filename Root */
    /* 2: Filename Type */
    /* 3: Max File size */
    /* 4: Reference Signal Textfile */
    /* 5: Sample Time */
    /* 6: Record Time */
    ssSetNumSFcnParams(S, 7);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
    {
        return;
    }
    
    /* Set Number of States */
    ssSetNumContStates(S,0);
    ssSetNumDiscStates(S,0);
    
    /* Set number of INPUT ports */
    /* 0: Flag to Record */
    /* 1: Data to Record */
    if (!ssSetNumInputPorts(S,2)) return;
    
    /* Set INPUT port widths */
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortWidth(S, 1, DYNAMICALLY_SIZED);
    
    /* Set DIRECT FEED THROUGHS of INPUT ports */
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 1, 1);
    
    /* Set number of OUTPUT Ports */
    /* 0: Number of bytes saved to current file */
    if (!ssSetNumOutputPorts(S, 1)) return;
    
    ssSetOutputPortWidth(S, 0, 1);
    
    /* Define Sample Time */
    ssSetNumSampleTimes(S, 1);
    
    /* Define Work Vectors */
    /* 0: R Work: Baserate/Sample Time */
    /* 1: R Work: Internally Computed Simtime */
    /* 2: R Work: First recorded timestamp */
    ssSetNumRWork(S, 3);
    
    /* Define I Work Vectors */
    /* 0: I Work: Timesteps recorded in current file (if split) */
    /* 1: I Work: Recorded bytes */
    /* 2: I Work: File extension index */
    /* 3: I Work: Maximum Filesize */
    /* 4: I Work: Split Files */
    /* 5: I Work: Total timesteps recorded */
    /* 6: I Work: Record Time */
    ssSetNumIWork(S, 7);
    
    /* Define P Work Vectors */
    /* 0: P Work: full filename_root (full directory path + filename root) */
    /* 1: P Work: filename_ext */
    /* 2: P Work: data_stream */
    /* 3: P Work: Master Log stream */
    /* 4: P Work: filename_root (no full path) */
    ssSetNumPWork(S, 5);
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
    char * filename_root;
    char * extension;
    char * fullfile_root;
    char * reftext_full;
    
    FILE * data_stream = NULL;
    FILE * log_stream = NULL;
    FILE * reftext_stream = NULL;
    int_T width;
    char filename_full[FULL_FILENAME_SIZE];
    char log_full[FULL_FILENAME_SIZE];
    char ch;
    double max_filesize;
    double max_filesize_MB = (double)*(mxGetPr(GET_MAX_FILE_SIZE(S)));

    int bSplitFiles = (max_filesize_MB > 0);
    int bRecordTime = (int)*(mxGetPr(GET_RECORD_TIME(S)));
    
    save_directory = malloc( SAVE_DIRECTORY_SIZE * sizeof(char) );
    filename_root  = malloc( FILENAME_ROOT_SIZE * sizeof(char) );
    extension      = malloc( FILENAME_TYPE_SIZE * sizeof(char) );
    reftext_full   = malloc( FULL_FILENAME_SIZE * sizeof(char) );
	fullfile_root  = malloc( (SAVE_DIRECTORY_SIZE+FILENAME_ROOT_SIZE) * sizeof(char) );

    /* Retrieve the name of the datafile */
    mxGetString(GET_SAVE_DIRECTORY(S), save_directory, SAVE_DIRECTORY_SIZE);
    mxGetString(GET_FILENAME_ROOT(S), filename_root, FILENAME_ROOT_SIZE);
    mxGetString(GET_FILENAME_TYPE(S), extension, FILENAME_TYPE_SIZE);
    mxGetString(GET_REF_TEXTFILE(S), reftext_full, FULL_FILENAME_SIZE);
    
    sprintf(fullfile_root, "%s%s", save_directory, filename_root);

    PWork[0] = fullfile_root;
    PWork[4] = filename_root;
    PWork[1] = extension;
    
    /* Initialize R Work Vectors */
    /* 0: R Work: Set Sample Time */
    ssSetRWorkValue(S, 0, (double) ssGetSampleTime(S, 0));
        
    /* 1: R Work: Set Simtime */
    /*    Setting to -DT.  This will get incremented back to 0 in mdlOutput */
    ssSetRWorkValue(S, 1, -ssGetRWorkValue(S,0));
        
    /* 2: R Work: First timestamp recorded */
    ssSetRWorkValue(S, 2, 0);
    
    /* Initialize I Work Vectors */
    /* 0: I Work: Total Timesteps recorded */
    ssSetIWorkValue(S, 0, 0);
    
    /* 1: I Work: Set Recorded bytes */
    ssSetIWorkValue(S, 1, 0);
    
    /* 2: I Work: Set File index */
    ssSetIWorkValue(S, 2, 1);
    
    /* 3: I Work: Maximum Filesize */
    width = ssGetInputPortWidth(S,1);
    
    max_filesize = max_filesize_MB * 1024.0 * 1024.0;
    ssSetIWorkValue(S, 3, (int)max_filesize );
    
    /* 4: I Work: Split Files */
    ssSetIWorkValue(S, 4, bSplitFiles );

    /* 5: I Work: Current Timesteps Recorded */
    ssSetIWorkValue(S, 5, 0 );
    
    /* 6: I Work: Record Time */
    ssSetIWorkValue(S, 6, bRecordTime);
    
    if(bSplitFiles == 1)
    {
        sprintf(filename_full, "%s%s_%d.%s", save_directory, filename_root, 1, extension);
    }
    else
    {
        sprintf(filename_full, "%s%s.%s", save_directory, filename_root, extension);
    }
    
    /* Open a new datafile: */
    data_stream = fopen( filename_full, "wb" );   
    PWork[2] = data_stream;
    
     printf("SAVE2BIN :: Opening data recorder to save '%s' in '%s'...\n",
                filename_root, save_directory);
    
    /* Open a new logfile */
    sprintf(log_full, "%s%s_Log.txt", save_directory, filename_root);
    log_stream = fopen( log_full, "w" );
    
    fprintf(log_stream, "%%%% Info on Recorded Data:\n");
    fprintf(log_stream, "LogInfo.SaveDirectory = '%s';\n", save_directory);
    fprintf(log_stream, "LogInfo.FilenameRoot  = '%s';\n", filename_root);
    fprintf(log_stream, "LogInfo.Extension     = '%s';\n", extension);
    fprintf(log_stream, "LogInfo.MaxFilesize   = %.3f; %% [MB]\n", max_filesize_MB);
    fprintf(log_stream, "LogInfo.TotalSignals  = %d;  %% [int]\n", width+bRecordTime); 
    fprintf(log_stream, "LogInfo.SourceSignals = %d;  %% [int]\n", width);
    fprintf(log_stream, "LogInfo.TimeIsFirst   = %d;  %% [bool]\n", bRecordTime);
    fprintf(log_stream, "LogInfo.Baserate      = %6.3f; %% [sec]\n", ssGetRWorkValue(S,0));
    fprintf(log_stream, "%% NOTE: Do NOT Assume that data has been uniformly recorded\n");
    fprintf(log_stream, "%%       DataRecorder's decimation can be throttled during run\n");
    
    fprintf(log_stream, "\n%%%% Log Breakdown:\n");
    
    /* Add Additional Info to Log Message */
    if(true) {
        printf("SAVE2BIN :: Adding '%s' to '%s_Log.txt'.\n", reftext_full, filename_root);
        fprintf(log_stream, "%%%% Additional Source Data:\n");
        reftext_stream = fopen( reftext_full, "r" );
    
        if(reftext_stream == NULL) {
            fprintf(log_stream, "%% No Data Provided\n");
        }
        else {
            /* Copy Contents */
            ch = fgetc(reftext_stream);
            while( ch != EOF) {
                fputc(ch, log_stream);
                 ch = fgetc(reftext_stream);
            }
            fclose(reftext_stream);
        }        
    }
    PWork[3] = log_stream;
}
#endif /*  MDL_START */

static void mdlOutputs(SimStruct *S, int_T tid)
{
    /* Local Variables */
    int_T width;
    int i, bSplitFiles, bRecordTime;
    int timesteps_saved, bytes_saved, timesteps_saved_local;
    double stepsize, simtime;
    double max_bytes_to_save;
    int iFile;
    
    void **PWork = ssGetPWork(S);
    FILE * data_stream = NULL;
    FILE * log_stream = NULL;
    char filename_full[FULL_FILENAME_SIZE];
        
    /* Get INPUT ports */
    InputRealPtrsType u0 = ssGetInputPortRealSignalPtrs(S, 0);
    InputRealPtrsType u1 = ssGetInputPortRealSignalPtrs(S, 1);
    
    /* Get OUTPUT ports */
    real_T  *y0 = ssGetOutputPortSignal(S,0);
    
    /* Get width of INPUT port */
    width = ssGetInputPortWidth(S,1);
    
    /* Retrieve Data from Work Vectors */
    data_stream = (FILE *) GET_DATA_STREAM(S);
    log_stream  = (FILE *) GET_LOG_STREAM(S);
    
     /* Retrieve R Work Values */
    stepsize = ssGetRWorkValue(S,0);
    simtime = (double) ssGetRWorkValue(S,1);
    simtime = simtime + stepsize;
    ssSetRWorkValue(S, 1, simtime);
    
    /* Retrieve I Work Values */
    timesteps_saved       = ssGetIWorkValue(S,0);
    bytes_saved           = ssGetIWorkValue(S,1);
    max_bytes_to_save     = ssGetIWorkValue(S,3);
    bSplitFiles           = ssGetIWorkValue(S,4);
    timesteps_saved_local = ssGetIWorkValue(S,5);
    bRecordTime           = ssGetIWorkValue(S,6);

    if (*u0[0] > 0.5) 
    {
        /* Record the current data */
        timesteps_saved = timesteps_saved + 1;
        ssSetIWorkValue(S, 0, timesteps_saved);
        
        timesteps_saved_local = timesteps_saved_local + 1;
        ssSetIWorkValue(S, 5, timesteps_saved_local);
        
        if( bRecordTime > 0.5)
        {
            fwrite(&simtime, sizeof(double), 1, GET_DATA_STREAM(S));
            bytes_saved = bytes_saved + sizeof(double);
        }
        
        for (i=0; i<width; i++) 
        {
            fwrite(u1[i], sizeof(double), 1, GET_DATA_STREAM(S));
            bytes_saved = bytes_saved + sizeof(double);
        }
        
        y0[0] = bytes_saved;
        ssSetIWorkValue(S, 1, bytes_saved);
             
        if((bytes_saved >= max_bytes_to_save) && (bSplitFiles > 0.5))
        {
            /* Retrieve File Index */
            iFile = ssGetIWorkValue(S,2);
            
            /* Write Log Message */
            sprintf(filename_full, "%s_%d.%s", GET_FULL_FILE_ROOT(S), iFile, GET_FILENAME_EXT(S));
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Timesteps   = %10.0f;  %% [int]\n", iFile, (double)timesteps_saved_local);
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Signals     = %10.0f;  %% [int]\n", iFile, (double)(width+bRecordTime));
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).TimeIsFirst = %10.0f;  %% [bool]\n", iFile, (double)(bRecordTime));
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).ValueSize   = %10.0f;  %% [bytes]\n", iFile, (double)(sizeof(double)));
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).StartTime   = %10.3f;  %% [sec]\n", iFile, ssGetRWorkValue(S, 2));
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).EndTime     = %10.3f;  %% [sec]\n", iFile, simtime);
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filename    = '%s';\n", iFile, filename_full);
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filesize    = %10.0f;  %% [bytes]\n", iFile, (double)bytes_saved);
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filesize_KB = %10.3f;  %% [KB]\n", iFile,  ((double)bytes_saved/1024.0));
            fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filesize_MB = %10.3f;  %% [MB]\n", iFile,  ((double)bytes_saved/(1024.0*1024.0)));
            fprintf(GET_LOG_STREAM(S), "\n");

            /* Close the current file */
            fclose( GET_DATA_STREAM(S) );
            
            /* Increment the Indexing */
            iFile++;
            ssSetIWorkValue(S, 2, iFile);
            
            /* Reset the timesteps saved */
            ssSetIWorkValue(S, 5, 0);
            
            /* Reset the byte counter */
            ssSetIWorkValue(S, 1, 0);
            
            /* Update the Time count */
            ssSetRWorkValue(S, 2, simtime+stepsize);
            
            /* Open the new file */
            sprintf(filename_full, "%s_%d.%s", GET_FULL_FILE_ROOT(S), iFile, GET_FILENAME_EXT(S));
                        
            data_stream = fopen( filename_full, "wb" );
            ssSetPWorkValue(S, 2, data_stream);
        }
    }
}

static void mdlTerminate(SimStruct *S)
{
    /* Pull Constants from PWork Vector */
    void **PWork = ssGetPWork(S);

    char * filename_root;
    char * extension;
    int_T width;
    int timesteps_saved, bRecordTime, bSplitFiles;
    int timesteps_saved_local;
    int numFiles, iFile;
    double simtime, stepsize;
    char filename_full[FULL_FILENAME_SIZE];
    FILE * log_stream;
    
    /* Retrieve the name of the datafile */
    filename_root = GET_FILE_ROOT(S);
    extension     = GET_FILENAME_EXT(S);
    
    width      = ssGetInputPortWidth(S, 1);
    stepsize   = ssGetRWorkValue(S, 0);
    simtime    = ssGetRWorkValue(S, 1);

    timesteps_saved       = ssGetIWorkValue(S, 0);
    numFiles              = ssGetIWorkValue(S, 2);
    bSplitFiles           = ssGetIWorkValue(S, 4);
    timesteps_saved_local = ssGetIWorkValue(S, 5);
    bRecordTime           = ssGetIWorkValue(S, 6);

    /* Close the current binary file */
    fclose( GET_DATA_STREAM(S) );

    /* Update the total timesteps saved */
    /*ssSetIWorkValue(S, 5, timesteps_saved + ssGetIWorkValue(S, 5) );*/
    
    /* Retrieve File Index */
    iFile = ssGetIWorkValue(S, 2);
    
    /* Finish off the Log Message */
    if(bSplitFiles > 0.5)
    {
        sprintf(filename_full, "%s_%d.%s", GET_FULL_FILE_ROOT(S), iFile, GET_FILENAME_EXT(S));
    }
    else
    {
        sprintf(filename_full, "%s.%s", GET_FULL_FILE_ROOT(S), GET_FILENAME_EXT(S));
    }
    
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Timesteps   = %10.0f;  %% [int]\n", iFile, (double)timesteps_saved_local);
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Signals     = %10.0f;  %% [int]\n", iFile, (double)(width+bRecordTime));
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).TimeIsFirst = %10.0f;  %% [bool]\n", iFile, (double)(bRecordTime));
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).ValueSize   = %10.0f;  %% [bytes]\n", iFile, (double)(sizeof(double)));
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).StartTime   = %10.3f;  %% [sec]\n", iFile, ssGetRWorkValue(S, 2));
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).EndTime     = %10.3f;  %% [sec]\n", iFile, simtime);
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filename    = '%s';\n", iFile, filename_full);
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filesize    = %10.0f;  %% [bytes]\n", iFile, (double)ssGetIWorkValue(S, 1));
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filesize_KB = %10.3f;  %% [KB]\n", iFile,  ((double)ssGetIWorkValue(S, 1)/1024.0));
    fprintf(GET_LOG_STREAM(S), "LogInfo.Set(%d).Filesize_MB = %10.3f;  %% [MB]\n", iFile,  ((double)ssGetIWorkValue(S, 1)/(1024.0*1024.0)));
    fprintf(GET_LOG_STREAM(S), "\n");

    fprintf(GET_LOG_STREAM(S), "%%%% Short Summary:\n");
    fprintf(GET_LOG_STREAM(S), "LogInfo.StartTime  = %10.3f;  %% [sec]\n", 0.0);
    fprintf(GET_LOG_STREAM(S), "LogInfo.EndTime    = %10.3f;  %% [sec]\n", simtime);
    fprintf(GET_LOG_STREAM(S), "LogInfo.Timesteps  = %10.0f;  %% [int]\n", (double)timesteps_saved);
    fprintf(GET_LOG_STREAM(S), "\n");
    fclose( GET_LOG_STREAM(S) );
    
    if(timesteps_saved == 0)
    {
        /* If no data has been recorded, go ahead and delete the log and opened binary file */
        /* Remove the Log File */
        printf("SAVE2BIN :: Removing '%s' since no data recorded\n", filename_full);
        remove(filename_full);
        sprintf(filename_full, "%s_Log.txt", GET_FULL_FILE_ROOT(S));
        printf("SAVE2BIN :: Removing '%s' since no data recorded\n", filename_full);
        remove(filename_full);
    }
    else
    {
        printf("SAVE2BIN :: Logging of '%s' data complete.  Details cataloged in '%s_Log.txt'.\n",
                filename_root, GET_FULL_FILE_ROOT(S));
    }
}

/* Final Required MATLAB/SIMULINK Interface Code */
#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif
