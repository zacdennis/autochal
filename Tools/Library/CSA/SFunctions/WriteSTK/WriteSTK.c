/* NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I */

/*  Filename: WriteSTK.c
 *  Function: MATLAB/SIMULINK S-Function Source Code
 *
 *  The WriteSTK s-function records a Simulink signal to a user defined
 *  tab-delimited file (e.g. .dat, .txt).  The function works on signals
 *  of any size (it is dynamically sized).  Hence you can treat this block
 *  the same as a regular Simulink 'ToWorkspace' block.
 *
 *  Notes: You can pass a muxed signal into the block provided that they
 *      are dimensioned alike.  That is, you cannot pass a single signal
 *      and a [3x3] into this block.
 *
 *  Simulink Example: TEST_WriteSTK.mdl.
 *
 */

/* S-function name */
#define S_FUNCTION_LEVEL 2
#define S_FUNCTION_NAME  WriteSTK

#define MAXNAMELENGTH (100)

/* Required Include for Simulink Structures and Definitions */
#include "simstruc.h"
#include "matrix.h"
#include <stdio.h>
#include <string.h>
#include "mex.h"

/* Definitions */
#define MAX_ARTICULATIONS 30

typedef struct {
    char ArtName[64];
    char ArtCmd[64];
} articulation_info;

/* Initialize Sizes */
static void mdlInitializeSizes(SimStruct *S)
{
    /* Set Number of Parameters */
    ssSetNumSFcnParams(S, 12);
    /*
     * 0:  Sample Time
     * 1:  Enable WriteSTK Block
     * 2:  Write Ephemeris
     * 3:  Write Attitude
     * 4:  Write Articulation
     * 5:  Fileprefix (Root Name)
     * 6:  Articulation Type (e.g. '.sama' or '.acma')
     * 7:  Number of Articulations
     * 8:  Articulation Info Filename
     * 9:  STK Epoch String
     * 10: Central Body
     * 11: Coordinate Axes
     */
    
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
    {
        return;
    }
    
    /* Set Number of States */
    ssSetNumContStates(S,0);
    ssSetNumDiscStates(S,0);
    
    /* Set number of INPUT ports */
    if (!ssSetNumInputPorts(S,3)) return;
    /*
     * 0: Trigger to Save
     * 1: STK Vector for Ephemeris and Attitude
     * 2: Articulation Vector
     */
        
    /* Set INPUT port widths */
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortWidth(S, 1, 11);
    ssSetInputPortWidth(S, 2, (int)*(mxGetPr(ssGetSFcnParam(S,7))));
        
    /* Set DIRECT FEED THROUGHS of INPUT ports */
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 1, 1);
    ssSetInputPortDirectFeedThrough(S, 2, 1);
    
    /* Set number of OUTPUT Ports */
    if (!ssSetNumOutputPorts(S, 0)) return;
    
    /* Define Sample Time */
    ssSetNumSampleTimes(S, 1);
    
    /* Define Work Vectors */
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 7);
    /* 0: enable_record
     * 1: record_ephemeris
     * 2: record_attitude
     * 3: record_articulation
     * 4: numArticulations
     * 5: nEpoints
     * 6: nApoints
     */
    
    ssSetNumPWork(S, 6);
    /* 0: a_stream
     * 1: e_stream
     * 2: art_stream
     * 3: nPointsPosE
     * 4: nPointsPosA
     * 5: artinfo structure
     */
    
    ssSetNumModes(S, 0);
    ssSetNumNonsampledZCs(S, 0);
    ssSetOptions(S, 0);
}

/* Initialize Sample Times */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, *mxGetPr(ssGetSFcnParam(S, 0)));
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
    int_T enable_record         = (int)*(mxGetPr(ssGetSFcnParam(S,1)));
    int_T record_ephemeris      = (int)*(mxGetPr(ssGetSFcnParam(S,2)));
    int_T record_attitude       = (int)*(mxGetPr(ssGetSFcnParam(S,3)));
    int_T record_articulation   = (int)*(mxGetPr(ssGetSFcnParam(S,4)));
    int_T numArticulations      = (int)*(mxGetPr(ssGetSFcnParam(S,7)));
    
    ssSetIWorkValue(S, 0, enable_record);
    ssSetIWorkValue(S, 1, record_ephemeris);
    ssSetIWorkValue(S, 2, record_attitude);
    ssSetIWorkValue(S, 3, record_articulation);
    ssSetIWorkValue(S, 4, numArticulations);

    /* Initialize nEpoints & nApoints to 0 */
    ssSetIWorkValue(S, 5, 0);   /* nEpoints */
    ssSetIWorkValue(S, 6, 0);   /* nApoints */
    
    if (enable_record == 1)
    {
        FILE * e_stream, * a_stream, * art_stream;
        fpos_t nPointsPosE, nPointsPosA;
        char fileprefix[32];
        char efile[32], afile[32], artfile[32];
        char artsuffix[10];
        char CentralBody[32];
        char CoordAxes[32];
        
        /* Header Information for .e and .a files */
        char STK_version[]    = "stk.v.6.1";
        char InterpMethod[]   = "Lagrange";
        int  InterpSamples    = 5;
        /*
        char CentralBody[]    = "Earth";
        char CoordAxes[]      = "J2000"; 
         */
        
        char CoordSystem[]    = "Fixed";
        int  BlockingFactor   = 20;
        int  InterpOrder      = 1;
        char EpochStrSTK[64];
        int i;
         
        articulation_info *artinfo;
        FILE * fp;
        char artinfo_filename[64];
        char line1[100];
        char *result;      
        
        /* Retrieve the name of the datafile */
        mxGetString(ssGetSFcnParam(S,5), fileprefix, 32);
        mxGetString(ssGetSFcnParam(S,6), artsuffix, 10);
        mxGetString(ssGetSFcnParam(S,9), EpochStrSTK, 64);
        mxGetString(ssGetSFcnParam(S,10), CentralBody, 32);
        mxGetString(ssGetSFcnParam(S,11), CoordAxes, 32);
        
        artinfo = malloc(numArticulations * sizeof(articulation_info) );
        
        if (record_ephemeris == 1)
        {
            strcpy(efile, fileprefix);
            strcat(efile, ".e");
            e_stream = fopen( efile, "w" );
            ssSetPWorkValue(S, 0, e_stream);
            
            /* Write the header information */
            fprintf(e_stream, "%s\n", STK_version);
            fprintf(e_stream, "BEGIN Ephemeris\n");
        
            /* Get the position so that we can come back later and add the number of points */
            fgetpos(e_stream, &nPointsPosE);
            ssSetPWorkValue(S, 3, (void *)nPointsPosE);
            
            /* This line will be overwritten on mdlTerminate() note the 20 spaces */
            fprintf(e_stream, "NumberOfEphemerisPoints                               \n\n");
            fprintf(e_stream, "ScenarioEpoch           %s\n", EpochStrSTK);
            fprintf(e_stream, "InterpolationMethod     %s\n", InterpMethod);
            fprintf(e_stream, "InterpolationSamplesM1  %d\n", InterpSamples);
            fprintf(e_stream, "CentralBody             %s\n", CentralBody);
            fprintf(e_stream, "CoordinateSystem        %s\n", CoordSystem);
            fprintf(e_stream, "BlockingFactor          %d\n", BlockingFactor);
            fprintf(e_stream, "EphemerisLLATimePosVel\n\n");
        }
        
        if (record_attitude == 1)
        {
            strcpy(afile, fileprefix);
            strcat(afile, ".a");
            a_stream    = fopen( afile, "w" );            
            ssSetPWorkValue(S, 1, a_stream);
            
            /* Write the header information */
            fprintf(a_stream, "%s\n", STK_version);
            fprintf(a_stream, "BEGIN Attitude\n");
        
            /* Get the position so that we can come back later and add the number of points */
            fgetpos(a_stream, &nPointsPosA);
            ssSetPWorkValue(S, 4, (void *) nPointsPosA);
            
    		/* This line will be overwritten on mdlTerminate() note the 20 spaces */
            fprintf(a_stream, "NumberOfAttitudePoints                               \n\n");
            fprintf(a_stream, "BlockingFactor          %d\n", BlockingFactor);
            fprintf(a_stream, "InterpolationOrder      %d\n", InterpOrder);
            fprintf(a_stream, "CentralBody             %s\n", CentralBody);
            fprintf(a_stream, "ScenarioEpoch           %s\n", EpochStrSTK);
            fprintf(a_stream, "CoordinateAxes          %s\n", CoordAxes);
            fprintf(a_stream, "AttitudeTimeQuaternions\n\n");
            
        }
        
        if (record_articulation == 1)
        {               
            
            /* Create the Articulation Filename */
            strcpy(artfile, fileprefix);
            strcat(artfile, artsuffix);
            art_stream  = fopen( artfile, "w" );
            ssSetPWorkValue(S, 2, art_stream);
            
            /* Write the header information */
    		fprintf(art_stream, "SPREADSHEET\n\n");
            
            /* Read in Articulation File */
            i = 0;
            mxGetString(ssGetSFcnParam(S, 8), artinfo_filename, 64);
            fp = fopen(artinfo_filename, "r" );
            
            while((fgets(line1, 100, fp) != EOF) & (i < numArticulations)) {
                
                /* 
                printf("line1: %s\n", line1);
                */
                 
                result = strtok(line1, " \n");
                /*
                printf("result: %s\n", result);
                */
                strcpy(artinfo[i].ArtName, result);
                
                result = strtok(NULL, " \n");
                /*
                printf("result: %s\n", result);
                */
                strcpy(artinfo[i].ArtCmd, result);
                i++;
            }
            fclose(fp);
            ssSetPWorkValue(S, 5, artinfo);
        }
    }    
}
#endif /*  MDL_START */

static void mdlOutputs(SimStruct *S, int_T tid)
{
    /* Local Variables */
    int_T enable_record, record_ephemeris, record_attitude, record_articulation, numArticulations;
    FILE *e_stream, *a_stream, *art_stream;
    int nEpoints, nApoints, i;
    double record_rate;
    articulation_info *artinfo;
    
    /* Get INPUT ports */
    InputRealPtrsType uRecord        = ssGetInputPortRealSignalPtrs(S, 0);
    InputRealPtrsType uSTKVector     = ssGetInputPortRealSignalPtrs(S, 1);
    InputRealPtrsType uArticulations = ssGetInputPortRealSignalPtrs(S, 2);
    
    /* Retrieve Data from Work Vectors */
    e_stream    = (FILE *) ssGetPWorkValue(S,0);
    a_stream    = (FILE *) ssGetPWorkValue(S,1);
    art_stream  = (FILE *) ssGetPWorkValue(S,2);
    record_rate = *mxGetPr(ssGetSFcnParam(S, 0)); 
    
    enable_record       = ssGetIWorkValue(S,0);
    record_ephemeris    = ssGetIWorkValue(S,1);
    record_attitude     = ssGetIWorkValue(S,2);
    record_articulation = ssGetIWorkValue(S,3);
    numArticulations    = ssGetIWorkValue(S,4);
    
    artinfo = (articulation_info *)ssGetPWorkValue(S, 5);
    
    if(*uRecord[0] > 0.5) {
        
        if ((enable_record == 1) && (record_ephemeris == 1)) {
            /* Write First 7 to Ephemeris File */
            /* Simtime / LLA / LLADot */
            for (i=0; i<7; i++) {
                fprintf(e_stream, "%.8e\t", *uSTKVector[i]);
            }
            fprintf(e_stream, "\n");
            
            /* Increment the number of ephemeris points counter */
            nEpoints = ssGetIWorkValue(S, 5);
            nEpoints++;
            ssSetIWorkValue(S, 5, nEpoints);
        }
        
        if ((enable_record == 1) && (record_attitude == 1)) {
            /* Write Last 4 to Attitude File */
            /* Simtime / Quaternion */
            fprintf(a_stream, "%.8e\t", *uSTKVector[0]);
            for (i=7; i<11; i++) {
                fprintf(a_stream, "%.8e\t", *uSTKVector[i]);
            }
            fprintf(a_stream, "\n");
            
            /* Increment the number of attitude points counter */
            nApoints = ssGetIWorkValue(S, 6);
            nApoints++;
            ssSetIWorkValue(S, 6, nApoints);
        }
        
        if ((enable_record == 1) && (record_articulation == 1)) {
            
            for (i=0; i<numArticulations; i++) {
                /*
                printf("[%d]: Art Name: %s   Cmd %s\n", i, artinfo[i].ArtName, 
                        artinfo[i].ArtCmd);
                */
                 
                fprintf(art_stream, "ARTICULATION  %.4f\t%.4f\t 0 0 0 0 0 %s\t%s\t%.2f\t%.2f\n",
                        *uSTKVector[0],
                        record_rate,
                        artinfo[i].ArtName,
                        artinfo[i].ArtCmd,
                        *uArticulations[i],
                        *uArticulations[i]	);
            }
        }
    }
}

static void mdlTerminate(SimStruct *S)
{
    FILE *e_stream, *a_stream, *art_stream;
    fpos_t nPointsPosE, nPointsPosA;
    int_T enable_record, record_ephemeris, record_attitude, record_articulation, numArticulations;
	int nEpoints, nApoints, i;
    char fileprefix[32], artsuffix[10];
        
    enable_record       = ssGetIWorkValue(S,0);
    record_ephemeris    = ssGetIWorkValue(S,1);
    record_attitude     = ssGetIWorkValue(S,2);
    record_articulation = ssGetIWorkValue(S,3);
	numArticulations    = ssGetIWorkValue(S,4);

    mxGetString(ssGetSFcnParam(S,5), fileprefix, 32);
    mxGetString(ssGetSFcnParam(S,6), artsuffix, 10);
    
    
    if ((enable_record == 1) && (record_ephemeris == 1))
    {
        e_stream = (FILE *) ssGetPWorkValue(S,0);
            
        /* Write the termination characters */
        fprintf(e_stream, "\nEND Ephemeris\n\n");
                
        /* Go back to where the number of points is needed and write that line */
        nPointsPosE = (fpos_t) ssGetPWorkValue(S,3);
        fsetpos(e_stream, &nPointsPosE);
                
        nEpoints = ssGetIWorkValue(S,5);
        fprintf(e_stream, "NumberOfEphemerisPoints %d\n", nEpoints);
        mexPrintf("WriteSTK : '%s' Emphemeris data written to '%s.e' (%d points)\n", fileprefix, fileprefix, nEpoints);
        fclose( e_stream );
    }
         
    if ((enable_record == 1) && (record_attitude == 1))
    {
        a_stream = (FILE *) ssGetPWorkValue(S,1);
            
        /* Write the termination characters */
        fprintf(a_stream, "\nEND Attitude\n\n");
                
        /* Go back to where the number of points is needed and write that line */
        nPointsPosA = (fpos_t) ssGetPWorkValue(S,4);
        fsetpos(a_stream, &nPointsPosA);
                
        nApoints = ssGetIWorkValue(S,6);
        fprintf(a_stream, "NumberOfAttitudePoints %d\n", nApoints);
        mexPrintf("WriteSTK : '%s' Attitude data written to '%s.a' (%d points)\n", fileprefix, fileprefix, nApoints);
        fclose( a_stream );
    }
         
    if ((enable_record == 1) && (record_articulation == 1))
    {
        art_stream = (FILE *) ssGetPWorkValue(S,2);
        mexPrintf("WriteSTK : '%s' Articulation data written to '%s%s'\n", fileprefix, fileprefix, artsuffix);       
        fclose( art_stream );
    }
}

/* Final Required MATLAB/SIMULINK Interface Code */
#ifdef MATLAB_MEX_FILE
#include "simulink.c"
#else
#include "cg_sfun.h"
#endif
