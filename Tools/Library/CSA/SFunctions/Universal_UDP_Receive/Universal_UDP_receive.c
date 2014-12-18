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
 * Created By: Dan Salluce
 * October 1, 2003
 *
 */

/*#define WINDOWS */

#define S_FUNCTION_NAME  Universal_UDP_receive
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#include <stdio.h>

/* #include "sim_io.h" */

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
#include <unistd.h>
#include <fcntl.h>
#define ERROR -1
#define SOCKET_ERROR -1
#endif

#define NPARAMETERS 4
#define ENABLE_SEND_PARAM(S) ssGetSFcnParam(S, 0)
#define WIDTH_PARAM(S) ssGetSFcnParam(S, 1)
#define SAMPLE_TIME_PARAM(S) ssGetSFcnParam(S, 2)
#define RECV_PORT_PARAM(S) ssGetSFcnParam(S, 3)

#define MAX_CLIENTS 20

typedef struct
{
    char ip_address[64];
    char port[64];
    int sockfd;
    struct sockaddr_in their_addr;
    int active;
} client_info_type;

static void get_ip_addresses( void );
extern int connectsock(const char *host, const char *service, const char *transport );

void print_error(char *string)
{
    int errorNum;
    #ifdef WINDOWS
    errorNum = WSAGetLastError();
    printf("%s, error = %d", string, errorNum);
    #else
    perror(string);
    #endif
}

/*====================*
 * INTERNAL FUNCTION  *
 *====================*/
double BOOL2DBL( bool x )
{
    if(x)
    {
        return 1.0;
    }
    else
    {
        return 0.0;
    }
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
    
    if (!ssSetNumInputPorts(S, 0)) return;
    
    // ssSetInputPortRequiredContiguous(S, 0, true); /*direct input signal access*/
    
    /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     * See matlabroot/simulink/src/sfuntmpl_directfeed.txt.
     */
    
    
    if (!ssSetNumOutputPorts(S, 1)) return;
    
    ssSetOutputPortWidth(S, 0, (int)*mxGetPr(WIDTH_PARAM(S)));       /* Count and Bytes          */
   
    ssSetNumSampleTimes(S, 1);
    ssSetNumRWork(S, 0);
    ssSetNumIWork(S, 2);
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
    int errorNum;
    char sockopt = 1;
    struct linger lingeropt;
    int sockBufSize;
    struct sockaddr_in  localUDPserverAddr;
    int sockAddrSize ; /* size of socket address structure */
    
    /* Get the ENABLED Parameters */
    ssSetIWorkValue(S, 0, (int)*mxGetPr(ENABLE_SEND_PARAM(S))); /* enabled_udp */
    
    if (ssGetIWorkValue(S, 0) == 1)
    {
        #ifdef WINDOWS
        WSADATA wsadata;
        if(WSAStartup(WSVERS, &wsadata))
        {
            printf("WSAStartup failed\n");
        }
        #endif
        
        ssSetIWorkValue(S, 1, socket(AF_INET, SOCK_DGRAM, 0)); /* sd */
       
        if (ssGetIWorkValue(S, 1) == -1)
        {
            print_error("socket error");
            exit(-1);
        }
        
        #ifdef WINDOWS
        /*allow re-use of a previously used port */
        if (setsockopt(ssGetIWorkValue(S, 1), SOL_SOCKET, SO_REUSEADDR, &sockopt, 1) == -1)
        {
            print_error("setsockopt  1 error");
            exit(-1);
        }
        
        /*Set the size of the socket receive buffer */
        sockBufSize = 0;
        if (setsockopt(ssGetIWorkValue(S, 1), SOL_SOCKET, SO_RCVBUF, (char *)&sockBufSize, sizeof(sockBufSize)) == -1)
        {
            print_error("setsockopt 2 error");
            exit(-1);
        }
        #endif
        
        #if 0
        lingeropt.l_onoff = 0;
        lingeropt.l_linger = 0;
        if (setsockopt(ssGetIWorkValue(S, 1), SOL_SOCKET, SO_DONTLINGER, &sockopt, 1) == -1)
        {
            #ifdef WINDOWS
            errorNum = WSAGetLastError();
            
            printf("setsockopt error 2, error = %d", errorNum);
            exit(-1);
            
            #else
            NEED TO ADD CODE HERE FOR LINUX?
            #endif
        }
        #endif
        
        #ifdef WINDOWS
        /*Set the socket to be non blocking */
        if (ioctlsocket(ssGetIWorkValue(S, 1), FIONBIO, (u_long FAR*) &iMode) != 0)
            #else
            if (fcntl(ssGetIWorkValue(S, 1), F_SETFL, O_NONBLOCK ) == ERROR )
                #endif
            {
                print_error("ioctl error");
                exit(-1);
            };
                
                sockAddrSize = sizeof (struct sockaddr_in);
                #if 0
                bzero ((char *) &localUDPserverAddr, sockAddrSize);
                bzero ((char *) &clientAddr, sockAddrSize);
                
                localUDPserverAddr.sin_len = (u_char) sockAddrSize;
                #endif
                printf("COM Receive Port = %d\n", (unsigned short)*mxGetPr(RECV_PORT_PARAM(S)));
                localUDPserverAddr.sin_family = AF_INET;
                localUDPserverAddr.sin_addr.s_addr=htonl(INADDR_ANY);
                localUDPserverAddr.sin_port=htons((unsigned short)*mxGetPr(RECV_PORT_PARAM(S)));
                
                if (bind(ssGetIWorkValue(S, 1), (struct sockaddr*)&localUDPserverAddr, sockAddrSize) == -1 )
                {
                    print_error("bind - input");
                    exit(-1);
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
    int i;
    int errorNum;
    int errorlen;
    struct sockaddr_in  clientAddr;
    int sockAddrSize ; /* size of socket address structure */
    
    real_T * y = ssGetOutputPortRealSignal(S,0);        
    double * receive_this;
    
    receive_this = malloc(ssGetOutputPortWidth(S, 0) * sizeof(double));
    if(receive_this == NULL)
    {
        printf("Out of memory\n");
        exit(1);
    }
    
    sockAddrSize = sizeof (struct sockaddr_in);

    if (ssGetIWorkValue(S, 0) == 1)
    {
        if(recv(ssGetIWorkValue(S, 1), (char *)receive_this, ssGetOutputPortWidth(S, 0) * sizeof(double), 0) == SOCKET_ERROR)
        {
            #ifdef WINDOWS
            errorNum = WSAGetLastError();
            
            if (errorNum != WSAEWOULDBLOCK)
            {
                printf("recv read error, error = %d\n", errorNum);
            }
            #else
            if (errno != EWOULDBLOCK)
            {
                perror("ioctl error");
                exit(-1);
            }
            #endif
            
        }
        else
        {
            for(i = 0; i < ssGetOutputPortWidth(S, 0); i++)
            {
                y[i] = *(receive_this + i);
            }
        }
    }
    
    free(receive_this);
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
    if (ssGetIWorkValue(S, 0) == 1)
    {
        #ifdef WINDOWS
        if (closesocket(ssGetIWorkValue(S, 1)) == SOCKET_ERROR)
        {
            printf("closesocket Failed, error code = %d\n", WSAGetLastError());
        }
        if (WSACleanup() == SOCKET_ERROR)
        {
            printf("WSACleanup Failed, error code = %d\n", WSAGetLastError());
        }
        
        #else
        close(ssGetIWorkValue(S, 1));
        #endif
    }
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
