/*  NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
 *
 *  WARNING - This document contains technical data whose export is 
 *  restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et
 *  seq.) or the Export Administration Act of 1979, as amended, Title 50, 
 *  U.S.C., App.2401et seq. Violation of these export-control laws is 
 *  subject to severe civil and/or criminal penalties.
 *
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
 */

/*#define WINDOWS*/

#define S_FUNCTION_NAME Universal_UDP_send
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include <stdio.h>

#ifdef WINDOWS
	#include <winsock2.h>
    #include <errno.h>

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

#define NPARAMETERS 3
#define ENABLE_SEND_PARAM(S) ssGetSFcnParam(S, 0)
#define SAMPLE_TIME_PARAM(S) ssGetSFcnParam(S, 1)
#define IP_PARAM(S) ssGetSFcnParam(S, 2)

#define MAX_CLIENTS 20

typedef struct
{
	char ip_address[64];
	char port[64];
	int sockfd;
	struct sockaddr_in their_addr;
	int active;
} client_info_type;

static void get_ip_addresses( SimStruct *S );
extern int connectsock(const char *host, const char *service, const char *transport );


/*====================*
 * INTERNAL FUNCTION  *
 *====================*/
bool DBL2BOOL( double x )
{
    return(x > 0.0);
}
            

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
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
    {
        /* Return if number of expected != number of actual parameters */
        return;
    }

    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);

	/* Defined for the sim_io.h typedef */
    if (!ssSetNumInputPorts(S, 2)) return;
   
    ssSetInputPortWidth(S, 0, 1);                   /* Trigger Send */
    ssSetInputPortWidth(S, 1, DYNAMICALLY_SIZED);   /* Generic UDP packet */
	
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
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 2);
    ssSetNumPWork(S, 2);
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
    unsigned long iMode = 1;
    char sockopt = 1;
    int numbytes = 0;
    
    char * ip_address_file;
	void **PWork = ssGetPWork(S);
 
    client_info_type * client;
    InputRealPtrsType u1 = ssGetInputPortRealSignalPtrs(S, 1);
    
    #ifdef WINDOWS
	WSADATA wsadata;
	if(WSAStartup(WSVERS, &wsadata))
    {
		printf("WSAStartup failed\n");
    }
    #endif
    
    ip_address_file = malloc(64 * sizeof(char));
    client = malloc(MAX_CLIENTS * sizeof(client_info_type));
	for( i=0; i < MAX_CLIENTS; i++ )
		client[i].active = 0;
        
    mxGetString(IP_PARAM(S), ip_address_file, 64);
    
    ssSetIWorkValue(S, 0, (int)*mxGetPr(ENABLE_SEND_PARAM(S))); /* enabled_udp */
    ssSetIWorkValue(S, 1, 0);									/* totbytes		*/
    
    PWork[0] = client;
    PWork[1] = ip_address_file;
    
    
	if (ssGetIWorkValue(S, 0) == 1)
	{
        numbytes = ssGetInputPortWidth(S, 1) * sizeof(double);

        get_ip_addresses(S);

        printf( "\nUniversal_UDP_Send:: Reference IP Address File: %s\n", ip_address_file);
        printf( "Universal_UDP_Send:: Sending: %d doubles (%d bytes)\n", ssGetInputPortWidth(S, 1), numbytes );
		for( i=0; i < MAX_CLIENTS; i++ )
		{
    		if( client[i].active == 1 )
            {
            	printf( "Universal_UDP_Send:: Destination #%d: IP Address: %s (Port: %s)\n", i+1, client[i].ip_address, client[i].port );
				client[i].sockfd = connectsock(client[i].ip_address, client[i].port, "udp");
            }
		}
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
	int byteCounter = 0;
	int i;
    int numbytes = 0;
        
    double * transmit_this;
    client_info_type * client;

    InputRealPtrsType u0 = ssGetInputPortRealSignalPtrs(S, 0);
    InputRealPtrsType u1 = ssGetInputPortRealSignalPtrs(S, 1);
    
    real_T       *y = ssGetOutputPortSignal(S,0);
    
    
    if(*u0[0] == 1)
    {
        
        client = (client_info_type *)ssGetPWorkValue(S, 0);
        transmit_this = malloc(ssGetInputPortWidth(S, 1) * sizeof(double));

        for(i = 0; i < ssGetInputPortWidth(S, 1); i++)
        {
            transmit_this[i] = *u1[i];
        }

        if (ssGetIWorkValue(S, 0) == 1)
        {
        	for( i=0; i<MAX_CLIENTS; i++ )
        	{
        		if( client[i].active == 1 )
        		{
                   if ((numbytes = send(client[i].sockfd, (const char *)transmit_this, ssGetInputPortWidth(S, 1) * sizeof(double), 0)) == -1)
                   {
                       perror("send");
                   }
                    
                  byteCounter += numbytes;
                }
            }
         
            //byteCounter = 0;
            ssSetIWorkValue(S, 1, ssGetIWorkValue(S, 1) + byteCounter);
            y[0] = (double) ssGetIWorkValue(S, 1);
        }
        else
        {
            y[0] = 0.0;
        }
    }
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
	client_info_type * client;
    char * ipfile;
  
    client = (client_info_type *)ssGetPWorkValue(S, 0);
    ipfile = (char *)ssGetPWorkValue(S, 1);
    
    if (ssGetIWorkValue(S, 0) == 1)
	{
		#ifdef WINDOWS
			WSACleanup();
		#else
		int i;
		for( i=0; i<MAX_CLIENTS; ++i )
		{
			if( client[i].active == 1 )
            {
				close( client[i].sockfd );
            }
		}
		#endif
	}
  
    free(client);
    free(ipfile);
}

static void get_ip_addresses( SimStruct *S )
{
	client_info_type * client;
    
    FILE* Fileptr;
	
	int i = 0;
	char readbuffer[64];
	char line1[100];
	char line2[100];
    char * ipfile;
    
    client = (client_info_type *)ssGetPWorkValue(S, 0);
    ipfile = (char *)ssGetPWorkValue(S, 1);
   
    //printf( "Universal_UDP_Send:: Loading IP File: %s\n", ipfile);
	if((Fileptr = fopen( ipfile, "r" )) == NULL)
    {
        /* The file could not be found or is invalid */
        printf("Universal_UDP_send :: Could not find: %s - Aborting\n", ipfile);
        ssSetErrorStatus(S, "Could not locate Universal_UDP_send IP configuration file (usually ip_addresses.txt)");
        return;
    }

	while( (fscanf(Fileptr,"%s\n",line1)) != EOF && i < MAX_CLIENTS )
	{
		fscanf( Fileptr, "%s\n", line2 );
		strcpy( client[i].ip_address, line1 );
		sscanf( line2, "%s", readbuffer );
		strcpy( client[i].port, readbuffer );
		client[i].active = 1;
		//printf( "Universal_UDP_Send:: Client %d IP Address: %s\n", i+1, client[i].ip_address );
		//printf( "Universal_UDP_Send:: Client %d Port: %s\n", i+1, client[i].port );
		i++;
	}
	
	fclose( Fileptr );
    
    ssSetPWorkValue(S, 0, client);
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
