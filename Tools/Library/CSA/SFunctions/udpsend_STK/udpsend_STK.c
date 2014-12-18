/*
NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
*/
/*
 * This C code will send connectionless UDP packets over the network by means
 * of the sendto() function. It will keep track of the number of bytes sent and
 * use that as an output for the Simulink CMEX S-function block. Block parameters
 * include the IP address (or host) to send to, the port number to send to, and
 * the sample time of the block. This can be set to -1 to inherit the global sim
 * sample time, but it will return an error about being a source block.
 * This is fire-and-forget communication. There is no guarentee of reception nor
 * a checksum. This code is intended for auxillary displays and/or gauges.
 * The structure passed is defined as buf_type and must not exceed the MTU for the
 * interface used.
 *
 *
 * Created By: Dan Salluce
 * October 1, 2003
 *
 * Revised By: Dan Salluce
 * April 15, 2005
 * In addition, this will create the Ephemeris (.e) and Attitdue (.a) files for use as
 * STKexternal propagator files. It receives the STK vector from the simulation
 * and simply writes the header for the files on initialization and the actual data
 * lines on mdlOutputs().
 * 
 */

/*#define WINDOWS*/

#define S_FUNCTION_NAME udpsend_STK
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include <stdio.h>

#ifdef WINDOWS
	#include <winsock2.h>

	#ifndef	INADDR_NONE
		#define	INADDR_NONE	0xffffffff
	#endif	/* INADDR_NONE */
	#define WSVERS	MAKEWORD(2,0)

/* Include the WinSock library */
#pragma comment(lib, "WS2_32.Lib")

#else /* LINUX */
	#include <sys/types.h>
	#include <sys/socket.h>
	#include <netinet/in.h>
	#include <arpa/inet.h>
	#include <netdb.h>
	#include <string.h>
	#include <stdlib.h>
	#include <sys/errno.h>
#endif

#define NPARAMETERS 8
#define ENABLE_SEND_PARAM(S) ssGetSFcnParam(S, 0)
#define SAMPLE_TIME_PARAM(S) ssGetSFcnParam(S, 1)
#define ENABLE_E_PARAM(S)    ssGetSFcnParam(S, 2)
#define ENABLE_A_PARAM(S)    ssGetSFcnParam(S, 3)
#define ENABLE_ART_PARAM(S)  ssGetSFcnParam(S, 4)
#define PREFIX_PARAM(S)		 ssGetSFcnParam(S, 5)
#define EPOCH_PARAM(S)		 ssGetSFcnParam(S, 6)
#define IP_PARAM(S)          ssGetSFcnParam(S, 7)

#define MAX_CLIENTS 4
#define THRUSTERS 12

/* NOTE: The X, Y, & Z commands can double as LLA without ever having
            to alter this code. For that reason, only the S-functions mask
            will be changed to reflect this. Otherwise, when in this mode:
    				X -> Lat
    				Y -> Lon
    				Z -> Alt */
    				
typedef struct {
	double simtime;			/* 0 */
	double Xft;				/* 1 */
	double Yft;				/* 2 */
	double Zft;				/* 3 */
	double Ufps;			/* 4 */
	double Vfps;			/* 5 */
	double Wfps;			/* 6 */
	double quaternion1;		/* 7 */
	double quaternion2;		/* 8 */
	double quaternion3;		/* 9 */
	double quaternion0;		/* 10 */
    float  thruster[THRUSTERS];	/* 11 Thrusters 1-THRUSTERS */
} buf_type;

typedef struct {
	char ip_address[64];
	char port[64];
	int sockfd;
	struct sockaddr_in their_addr;
	int active;
} client_info_type;

fpos_t nPointsPosE;
fpos_t nPointsPosA;

static void get_ip_addresses( SimStruct *S );
extern int connectsock(const char *host, const char *service, const char *transport );

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

    ssSetNumSFcnParams(S, NPARAMETERS);  /* Number of expected parameters */
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

    if (!ssSetNumInputPorts(S, 2)) return;
    ssSetInputPortWidth(S, 0, 11);
    ssSetInputPortWidth(S, 1, THRUSTERS);
    
	/* ssSetInputPortRequiredContiguous(S, 0, true); /*direct input signal access*/
    /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     * See matlabroot/simulink/src/sfuntmpl_directfeed.txt.
     */

    ssSetInputPortDirectFeedThrough(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 1, 1);

    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 1);

    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 2);
    ssSetNumIWork(S, 6);
    ssSetNumPWork(S, 12);
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

} /* mdlInitializeSampleTimes */


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
	int i;

	#ifdef WINDOWS
		WSADATA wsadata;
	#endif

	/* Get the Pointer Work Vector */
    void **PWork = ssGetPWork(S);
 
	/* Header Information for .e and .a files */
	char STK_version[]    = "stk.v.6.1";
	char InterpMethod[]   = "Lagrange";
	int  InterpSamples    = 5;
	char CentralBody[]    = "Earth";
	char CoordSystem[]    = "Fixed";
	char CoordAxes[]      = "J2000";
	int  BlockingFactor   = 20;
	int  InterpOrder      = 1;
		
    float * prevThruster;
		
	char * efile;
	char * afile;
	char * artfile;
	char * fileprefix;
    char * EpochStrSTK;
    char * ip_address_file;
    
	FILE * e_stream = NULL;
    FILE * a_stream = NULL;
    FILE * art_stream = NULL;

	buf_type * buf;
	client_info_type * client;
	
	prevThruster = malloc(THRUSTERS * sizeof(float));
	
	efile           = malloc( 32 * sizeof(char) );
	afile           = malloc( 32 * sizeof(char) );
	artfile         = malloc( 32 * sizeof(char) );
	fileprefix      = malloc( 32 * sizeof(char) );
	EpochStrSTK     = malloc( 64 * sizeof(char) );
    ip_address_file = malloc( 64 * sizeof(char) );

	buf		= malloc( sizeof(buf_type) );
	client	= malloc( MAX_CLIENTS * sizeof(client_info_type) );

	if( (efile == NULL) || (afile == NULL) || (artfile == NULL) || (fileprefix == NULL) ||
		(EpochStrSTK == NULL) || ip_address_file == NULL || (buf == NULL) || (client == NULL) )
		printf( "Insufficient memory available\n" );

	#ifdef WINDOWS
	if(WSAStartup(WSVERS, &wsadata)){
		printf("WSAStartup failed\n");}
	#endif
	
	/* Initialize IWork Vectors */
    ssSetIWorkValue(S, 0, (int)*mxGetPr(ENABLE_SEND_PARAM(S))); /* enabled_udp	*/
    ssSetIWorkValue(S, 1, (int)*mxGetPr(ENABLE_E_PARAM(S)));	/* enabled_e	*/
    ssSetIWorkValue(S, 2, (int)*mxGetPr(ENABLE_A_PARAM(S)));	/* enabled_a	*/
    ssSetIWorkValue(S, 3, (int)*mxGetPr(ENABLE_ART_PARAM(S)));	/* enabled_art	*/
    ssSetIWorkValue(S, 4, THRUSTERS);							/* nThrusters	*/
    ssSetIWorkValue(S, 5, 0);									/* totbytes		*/
    
    /* Initialize RWork Vectors: reset counters for number of points */
    ssSetRWorkValue(S, 0, 0); /* nEpoints */
    ssSetRWorkValue(S, 1, 0); /* nApoints */    

	mxGetString(PREFIX_PARAM(S), fileprefix, 32);
    mxGetString(EPOCH_PARAM(S), EpochStrSTK, 64);
    mxGetString(IP_PARAM(S), ip_address_file, 64);
    
	/* Setup the filename from the prefix */
	strcpy(efile,	fileprefix);
	strcpy(afile,	fileprefix);
	strcpy(artfile, fileprefix);
	    
	strcat(efile, ".e");
	strcat(afile, ".a");
	strcat(artfile, ".sama");
    
	PWork[10] = client;
    PWork[11] = ip_address_file;

    if (ssGetIWorkValue(S, 0) == 1)
	{
		get_ip_addresses(S);
        
		for( i=0; i < MAX_CLIENTS; i++ )
		{
    		if( client[i].active == 1 )
            {
				client[i].sockfd = connectsock(client[i].ip_address, client[i].port, "udp");
            }
		}
	}

	if (ssGetIWorkValue(S, 1) == 1)
	{
		/* Open the Ephemeris File for writing: */
		e_stream = fopen(efile, "w" );

		/* Write the header information */
		fprintf(e_stream, "%s\n\n", STK_version);
		fprintf(e_stream, "BEGIN Ephemeris\n\n");
        
		/* Get the position so that we can come back later and add the number of points */
		fgetpos(e_stream, &nPointsPosE);

		/* This line will be overwritten on mdlTerminate() note the 20 spaces */
		fprintf(e_stream, "NumberOfEphemerisPoints                               \n\n");
		fprintf(e_stream, "ScenarioEpoch           %s\n\n", ssGetPWorkValue(S, 4));
		fprintf(e_stream, "InterpolationMethod     %s\n\n", InterpMethod);
		fprintf(e_stream, "InterpolationSamplesM1  %d\n\n", InterpSamples);
		fprintf(e_stream, "CentralBody             %s\n\n", CentralBody);
		fprintf(e_stream, "CoordinateSystem        %s\n\n", CoordSystem);
		fprintf(e_stream, "BlockingFactor          %d\n\n", BlockingFactor);
		fprintf(e_stream, "EphemerisLLATimePosVel\n\n");
	}

	if (ssGetIWorkValue(S, 2) == 1)
	{
		/* Open the Attitude File for writing: */
		a_stream = fopen( afile, "w" );

		/* Write the header information */
		fprintf(a_stream, "%s\n\n", STK_version);
		fprintf(a_stream, "BEGIN Attitude\n\n");
        
		/* Get the position so that we can come back later and add the number of points */
		fgetpos(a_stream, &nPointsPosA);

		/* This line will be overwritten on mdlTerminate() note the 20 spaces */
		fprintf(a_stream, "NumberOfAttitudePoints                               \n\n");
		fprintf(a_stream, "BlockingFactor          %d\n\n", BlockingFactor);
		fprintf(a_stream, "InterpolationOrder      %d\n\n", InterpOrder);
		fprintf(a_stream, "CentralBody             %s\n\n", CentralBody);
		fprintf(a_stream, "ScenarioEpoch           %s\n\n", ssGetPWorkValue(S, 4));
		fprintf(a_stream, "CoordinateAxes          %s\n\n", CoordAxes);
		fprintf(a_stream, "AttitudeTimeQuaternions\n\n");
	}

	if (ssGetIWorkValue(S, 3) == 1)
	{
		/* Open the Articulation File for writing: */
		art_stream = fopen( artfile, "w" );

		/* Write the header information */
		fprintf(art_stream, "SPREADSHEET\n\n");
	}

	/* Initialize PWork to values above */
    PWork[0] = efile;
    PWork[1] = afile;
    PWork[2] = artfile;

	PWork[3] = fileprefix;
	PWork[4] = EpochStrSTK;
    
    PWork[5] = e_stream;
    PWork[6] = a_stream;
    PWork[7] = art_stream;
    
    PWork[8] = prevThruster;
    
    PWork[9] = buf;
}
#endif /*  MDL_START */


/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector, ssGetY(S).
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
#if(1)
    int numbytes = 0;
	int i;
    int byteCounter = 0;

    buf_type * buf;

    client_info_type * client;
    
	InputRealPtrsType u1 = ssGetInputPortRealSignalPtrs(S, 0);
	InputRealPtrsType u2 = ssGetInputPortRealSignalPtrs(S, 1);

	real_T       *y = ssGetOutputPortSignal(S,0);
    
	buf = (buf_type *)ssGetPWorkValue(S, 9);
	client = (client_info_type *)ssGetPWorkValue(S, 10);
		    
    buf->simtime = *u1[0];
    buf->Xft = *u1[1];
	buf->Yft = *u1[2];
	buf->Zft = *u1[3];
	buf->Ufps = *u1[4];
	buf->Vfps = *u1[5];
	buf->Wfps = *u1[6];
	buf->quaternion1 = *u1[7];
	buf->quaternion2 = *u1[8];
	buf->quaternion3 = *u1[9];
	buf->quaternion0 = *u1[10];

	/* Get the thruster inputs */
	for ( i = 0; i < THRUSTERS; i++ )
	{
		(buf->thruster)[i] = (float)*u2[i];
	}

	if (ssGetIWorkValue(S, 0) == 1)
	{
		for( i=0; i<MAX_CLIENTS; i++ )
		{
            if( client[i].active == 1 )
			{
		  	/* if ((numbytes=sendto( client[i].sockfd, &buf, sizeof(buf_type), 0, (struct sockaddr *)&(client[i].their_addr), sizeof(struct sockaddr))) == -1) */
			if ((numbytes = send(client[i].sockfd, (const char *)buf, sizeof(buf_type), 0)) == -1)
				perror("send");
            
            byteCounter += numbytes;
            }
        }
		
		ssSetIWorkValue(S, 5, ssGetIWorkValue(S, 5) + byteCounter);
        y[0] = (double) ssGetIWorkValue(S, 5);
	}
	else
	{
        y[0] = 0.0;
	}
    
	if (ssGetIWorkValue(S, 1) == 1)
	{
		/* Write the ephemeris line - note the conversion back into meters for alt */
		fprintf(ssGetPWorkValue(S, 5), "%.8e\t%.8e\t%.8e\t%.8e\t%.8e\t%.8e\t%.8e\n", buf->simtime, buf->Xft, buf->Yft, buf->Zft * 0.3048, buf->Ufps, buf->Vfps, buf->Wfps);
		ssSetRWorkValue(S, 0, ssGetRWorkValue(S, 0) + 1);
	}

	if (ssGetIWorkValue(S, 2) == 1)
	{
		/* Write the attitude line */
		fprintf(ssGetPWorkValue(S, 6), "%.8e\t%.8e\t%.8e\t%.8e\t%.8e\n", buf->simtime, buf->quaternion1, buf->quaternion2, buf->quaternion3, buf->quaternion0);
		ssSetRWorkValue(S, 1, ssGetRWorkValue(S, 1) + 1);
	}

	if (ssGetIWorkValue(S, 3) == 1)
	{
		/* Write the articulation line */
		for (i = 0; i < ssGetIWorkValue(S, 4); i++)
		{
			/* Avoid writing a line if the value doesn't change on this call to mdlOutputs() */
			if ((buf->thruster)[i] != ((float *)ssGetPWorkValue(S, 8))[i])
				fprintf(ssGetPWorkValue(S, 7), "ARTICULATION %.4f 0 0 0 0 0 0 Thruster%d Size 0 %.4f\n", buf->simtime, i, (buf->thruster)[i]);
			
			/* Add persistance */
			((float *)ssGetPWorkValue(S, 8))[i] = (buf->thruster)[i];
		}
	}
#endif
} /* mdlOutputs */



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
    char * efile;
	char * afile;
	char * artfile;
	char * fileprefix;
    char * EpochStrSTK;

	float * prevThruster;

	buf_type * buf;
	client_info_type * client;

	/* Get the Pointer Work Vector */
    void **PWork = ssGetPWork(S);

	buf = (buf_type *)ssGetPWorkValue(S, 9);
	client = (client_info_type *)ssGetPWorkValue(S, 10);

	PWork[0] = efile;
	PWork[1] = afile;
	PWork[2] = artfile;
	PWork[3] = fileprefix;
	PWork[4] = EpochStrSTK;
	PWork[8] = prevThruster;
    
    if (ssGetIWorkValue(S, 0) == 1)
	{
		#ifdef WINDOWS
			WSACleanup();
		#else
		int i;
		for( i=0; i<MAX_CLIENTS; ++i )
		{
			if( client[i].active == 1 )
				close( client[i].sockfd );
		}
		#endif
	}
    
    ssSetPWorkValue(S, 10, client);
    
	if (ssGetIWorkValue(S, 1) == 1)
	{
		/* Write the termination characters */
		fprintf(ssGetPWorkValue(S, 5), "\nEND Ephemeris\n\n");

		/* Go back to where the number of points is needed and write that line */
		fsetpos(ssGetPWorkValue(S, 5), &nPointsPosE);
		fprintf(ssGetPWorkValue(S, 5), "NumberOfEphemerisPoints %.0f", ssGetRWorkValue(S, 0));
		
		/* Close the file */
		fclose( ssGetPWorkValue(S, 5) );

		printf("COM :: Wrote Ephemeris to file \"");
		printf("%s", ssGetPWorkValue(S, 0));
		printf("\"\n");
	}

	if (ssGetIWorkValue(S, 2) == 1)
	{
		/* Write the termination characters */
		fprintf(ssGetPWorkValue(S, 6), "\nEND Attitude\n\n");

		/* Go back to where the number of points is needed and write that line */
		fsetpos(ssGetPWorkValue(S, 6), &nPointsPosA);
		fprintf(ssGetPWorkValue(S, 6), "NumberOfAttitudePoints %.0f", ssGetRWorkValue(S, 1));

		/* Close the file */
		fclose( ssGetPWorkValue(S, 6) );

		printf("COM :: Wrote Attitude to file \"");
		printf(ssGetPWorkValue(S, 1));
		printf("\"\n");
	}

	if (ssGetIWorkValue(S, 3) == 1)
	{
		printf("COM :: Wrote Articulation to file \"");
		printf(ssGetPWorkValue(S, 2));
		printf("\"\n");

		/* Close the file */
		fclose( ssGetPWorkValue(S, 7) );
	}

	/* Reset the total UDP network bytes sent */
	ssSetIWorkValue(S, 5, 0);
	/* Reset the counters for number of points */
	ssSetRWorkValue(S, 0, 0);
	ssSetRWorkValue(S, 1, 0);

	/* Free all the memory from malloc in mdlStart */
	free(efile);
	free(afile);
	free(artfile);
	free(fileprefix);
	free(EpochStrSTK);
	free(prevThruster);
}

static void get_ip_addresses( SimStruct *S )
{
	client_info_type * client;
    
    FILE* Fileptr;
	
	int i;
	char readbuffer[64];
    char * ip_file;
	char line1[100];
	char line2[100];
    
	client = (client_info_type *)ssGetPWorkValue(S, 10);
    ip_file = (char *)ssGetPWorkValue(S, 11);
    
	for(i = 0; i < MAX_CLIENTS; i++){
		client[i].active = 0;}
	  
	if((Fileptr = fopen( ip_file, "r" )) == NULL)
    {
        /* An occur would have occurred */
        printf("COM :: Could not find: %s - Aborting\n", ip_file);
        ssSetErrorStatus(S, "Could not locate udpsend_STK IP configuration file");
        return;
    }
    
	i=0;

	while( (fscanf(Fileptr,"%s\n",line1)) != EOF && i < MAX_CLIENTS )
	{
		fscanf( Fileptr, "%s\n", line2 );
		strcpy( client[i].ip_address, line1 );
		sscanf( line2, "%s", readbuffer );
		strcpy( client[i].port, readbuffer );
		client[i].active = 1;
		printf( "COM :: Client %d IP Address: %s\n", i+1, client[i].ip_address );
		printf( "COM :: Client %d Port: %s\n", i+1, client[i].port );
        i++;
	}
    
	fclose( Fileptr );

	ssSetPWorkValue(S, 10, client);
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
