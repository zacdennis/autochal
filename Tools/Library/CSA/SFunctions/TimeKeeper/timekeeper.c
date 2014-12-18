/****************************************************************************
 *  MODULE:    timekeeper.c
 *  AUTHOR(S): Dan Salluce
 *  DATE:      September 25, 1998
 *
 *  NORTHROP GRUMMAN CORPORATION
 *
 *  REVISION HISTORY:
 *
 * Dan Salluce	April 01, 2005
 * Added Enabled mask parameter to allow turning it on/off without having to delete
 * the block. Modified output to be more meaningful. Added documentation.
 *
 * This S-function block is meant to throttle back Simulink to run in RealTime.
 * During each Simulink call to mdlOutput(), a comparison is made of the Simulink
 * time to a high fidelity Windows multimedia timer. This code is not without
 * flaws, but when compiled in with GRT, it proves to be a decent way to make
 * a simulation run near real-time on a windows or linux platform.
 *
 * LIMITATIONS:
 * 1.) There are no warnings when a frame is overrun --> CORRECTED 04.05.2005
 * 2.) The timer is only good to one milisecond, which is alright for viz sims
 *     w/o pilot or hardware in the loop.
 * 3.) There are no provisions for affinity, priority, or shielding
 * 4.) The output of the s-function is an indication of the number of miliseconds
 *     which have gone by in real-time w/o a response from the sim.
 *     This number should be zero.
 * 5.) All simulations run natively within Simulink are executed under the main
 *     matlab.exe parent thread. This means that moving windows, clicking, dragging,
 *     etc (given high priority in Matlab) will cause drastic overruns. This makes
 *     the code well suited for compilations with RTW's GRT (generic real-time target).
 *
 ****************************************************************************/
#define LINUX_TIMER

/* link to the windows multimedia library for the timer: */
#pragma comment(lib, "winmm.lib")

#define S_FUNCTION_NAME timekeeper
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"

#ifdef WINDOWS
#include "windows.h"
#include "Mmsystem.h"
#include <conio.h>
#else
#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <errno.h>
#define UINT unsigned int
#endif


#include <math.h>

#include <stdlib.h>
#include <string.h>

#include <math.h>
#include <stdio.h>

/*  Define the S-function parameters that will be used for enabling or disabling: */
#define ENABLE_PARAM(S) ssGetSFcnParam(S, 0)
#define DEBUG_PARAM(S) ssGetSFcnParam(S, 1)
#define HIGHPRIORITY_PARAM(S) ssGetSFcnParam(S, 2)

int enabled;
int debug_enabled;
int high_priority;
#ifdef WINDOWS

/* Process Handle for setting prioirties: */
HANDLE hProcess;

/* Initialize timer vaiables */
/*---------------------------------------------------------------------------------*/
#define TARGET_RESOLUTION 1 /* 1-millisecond target resolution */
TIMECAPS tc;				/* Timer structure */
UINT     wTimerRes;			/* Timer Resolution */

/* Global to record time at start */
double StartTime;

/* Timer callback prototype: */
void CALLBACK TimeProc(UINT wTimerID, UINT msg, DWORD dwUser, DWORD dw1, DWORD dw2);
/*---------------------------------------------------------------------------------*/
#else
void TimeProc(union sigval sigval );
timer_t timer;
int timer_nr;
struct timeval StartTime;

#endif

/* Timer counter implementation */
UINT timercounter;
UINT oldtimercounter;
UINT delay_time;

#ifdef WINDOWS
MMRESULT timerID;
#endif

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Setup sizes of the various vectors.
 */
static void mdlInitializeSizes(SimStruct *S) {
    /*  One parameter is defined for enabling */
    ssSetNumSFcnParams(S, 3);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }
    
    /*  ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0); */
    
    ssSetNumInputPorts(S, 1);
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortDirectFeedThrough(S, 0, 1);
    
    /* if (!ssSetNumOutputPorts(S,1)) return; */
    ssSetNumOutputPorts(S, 2);
    ssSetOutputPortWidth(S, 0, 1); /* time difference */
    ssSetOutputPortWidth(S, 1, 1); /* wall time in sec */
    
    ssSetNumSampleTimes(S, 1);
    
    /* Take care when specifying exception free code - see sfuntmpl.doc */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
}


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy that we inherit our sample time from the driving block.
 */
static void mdlInitializeSampleTimes(SimStruct *S) {
    /*  ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0); */
    
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, FIXED_IN_MINOR_STEP_OFFSET);
    
    enabled = (int)*mxGetPr(ENABLE_PARAM(S)); /* Get the ENABLED Parameter */
    debug_enabled = (int)*mxGetPr(DEBUG_PARAM(S)); /* Get the DEBUG Parameter */
    high_priority = (int)*mxGetPr(HIGHPRIORITY_PARAM(S)); /* Get the DEBUG Parameter */
}

#define MDL_START   /* Change to #undef to remove function */
#if defined(MDL_START)
/* Function: mdlStart ======================================== */

static void mdlStart(SimStruct *S) {
#ifdef WINDOWS
    hProcess = GetCurrentProcess();

if(high_priority == 1) {
    if(GetPriorityClass(hProcess) != HIGH_PRIORITY_CLASS){
        SetPriorityClass(hProcess, HIGH_PRIORITY_CLASS);}
}
else {
    if(GetPriorityClass(hProcess) != NORMAL_PRIORITY_CLASS){
        SetPriorityClass(hProcess, NORMAL_PRIORITY_CLASS);}
}

/* Get the system time in ms */
StartTime = timeGetTime();

#else
struct itimerspec itimer;
struct sigevent sigev;
gettimeofday(&StartTime, 0);
#endif
delay_time = (UINT)(1000 * ssGetFixedStepSize(S));

if (enabled == 1) {
    printf("TIMEKEEPER :: The sample time is: %i ms\n", delay_time);
    
#ifdef WINDOWS
/* Determine the minimum and maximum timer resolutions and fill the TIMECAPS structure */
if (timeGetDevCaps(&tc, sizeof(TIMECAPS)) != TIMERR_NOERROR) {
    /* Error; application can't continue. */
    ssSetErrorStatus(S, "|||| Timekeeper ERROR ||||\n");
}

/* Determine and use the minimum of the specified, computer min, or computer max resolution to
 * avoid errors in timeSetEvent */
wTimerRes = min(max(tc.wPeriodMin, TARGET_RESOLUTION), tc.wPeriodMax);
timeBeginPeriod(wTimerRes);

/* Start the timer in its own thread with the determined parameters: */
timerID = timeSetEvent(
        (UINT)(1000*ssGetFixedStepSize(S)),	/* uDelay, */
        wTimerRes,							/* uResolution, */
        TimeProc,							/* LPTIMECALLBACK lpTimeProc,   */
        NULL,								/* DWORD_PTR dwUser,                */
        TIME_PERIODIC						/* UINT fuEvent                 */
        );

#else
#ifdef LINUX_TIMER
memset(&sigev, 0, sizeof (struct sigevent));
sigev.sigev_value.sival_int = timer_nr;
sigev.sigev_notify = SIGEV_THREAD;
sigev.sigev_notify_attributes = NULL;
sigev.sigev_notify_function = TimeProc;

if (timer_create(CLOCK_REALTIME, &sigev, &timer) < 0) {
    fprintf(stderr, "[%d]: %s\n", __LINE__, strerror(errno));
    exit(errno);
}

/* Set timer period */
itimer.it_interval.tv_sec = 0;
itimer.it_interval.tv_nsec = 1000000 * delay_time;
/* Set timer expiration */
itimer.it_value.tv_sec = 0;
itimer.it_value.tv_nsec = 1000000 * delay_time;
if (timer_settime(timer, 0, &itimer, NULL) < 0) {
    fprintf(stderr, "[%d]: %s\n", __LINE__, strerror(errno));
    exit(errno);
}
#endif
#endif
}

timercounter = 0;
oldtimercounter = 0;

}
#endif /* MDL_START */

#define MDL_INITIALIZE_CONDITIONS   /* Change to #undef to remove function */
#if defined(MDL_INITIALIZE_CONDITIONS)
/* Function: mdlInitializeConditions ========================================
 * Abstract:
 *    Initialize the state. Note, that if this S-function is placed
 *    within an enabled subsystem which is configured to reset states,
 *    this routine will be called during the reset of the states.
 */
static void mdlInitializeConditions(SimStruct *S) {
}
#endif /* MDL_INITIALIZE_CONDITIONS */

/* Function: mdlOutputs =======================================================
 * Abstract:
 *
 */
static void mdlOutputs(SimStruct *S, int_T tid) {
    InputRealPtrsType uRT = ssGetInputPortRealSignalPtrs(S, 0);
    real_T            *y    = ssGetOutputPortRealSignal(S, 0);
#ifdef WINDOWS
double NowTime;
#else
struct timeval NowTime;
#endif

#ifdef LINUX_NOTIMER
timercounter++;
y[0] = timercounter - oldtimercounter;
oldtimercounter++;
usleep(1000 * delay_time);
return;
#endif

#ifdef WINDOWS
/* Get wall time again and subtract from previous time */
NowTime = timeGetTime();
y[1] = (NowTime - StartTime) / 1000.0;
#else
gettimeofday(&NowTime, 0);
y[1] = (NowTime.tv_sec - StartTime.tv_sec) + (NowTime.tv_usec - StartTime.tv_usec) / 1000000.0;
#endif

if((*uRT[0] > 0.5) && (enabled == 1)) {
    while(timercounter == oldtimercounter)
#ifdef WINDOWS
        Sleep(1); /* Sleep 1 ms */
#else
    usleep(1000);
#endif
    
    if(oldtimercounter < (timercounter - 1) && debug_enabled == 1) {
        /* ssSetErrorStatus(S,"Timer resolution is too low.\nTime is going by too fast\n"); */
        /* ErrorHandler("time too fast\n"); */
        printf("TIMEKEEPER :: Frame Overrun!\n");
        printf("\tFrame Time Requested: %i ms\n", oldtimercounter);
        printf("\tFrame Time Actual %i ms\n", timercounter);
        printf("\t\tFrame Overran by: %i ms\n", timercounter - oldtimercounter);
    }
    
    oldtimercounter++;
    y[0] = timercounter - oldtimercounter;
}
else {
    y[0] = 0.0;
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
static void mdlUpdate(SimStruct *S, int_T tid) {
}
#endif /* MDL_UPDATE */

#define MDL_DERIVATIVES  /* Change to #undef to remove function */
#if defined(MDL_DERIVATIVES)
/* Function: mdlDerivatives =================================================
 */
static void mdlDerivatives(SimStruct *S) {
}
#endif /* MDL_DERIVATIVES */
/*-------------------------------------------------------------------------*/

#ifdef WINDOWS
void CALLBACK TimeProc(UINT wTimerID, UINT msg, DWORD dwUser, DWORD dw1, DWORD dw2)
/* This is the callback funtion that is executed at the end of each timer period. */
{
    timercounter++;
    return;
}
#else
void TimeProc(union sigval sigval) {
#if 0
    printf("timer_nr=%02d  pid=%d  pthread_self=%ld\n",
        sigval.sival_int, getpid(), pthread_self());
#endif
timercounter++;
return;
}
#endif

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No termination needed, but we are required to have this routine.
 */
static void mdlTerminate(SimStruct *S) {
#ifdef WINDOWS
    hProcess = GetCurrentProcess();

if(GetPriorityClass(hProcess) == HIGH_PRIORITY_CLASS)
    SetPriorityClass(hProcess, NORMAL_PRIORITY_CLASS);

if (enabled == 1) {
    timeKillEvent(timerID);
}
/* printf("TIMEKEEPER :: The timer has been killed.\n"); */
#else
#ifdef LINUX_TIMER
if (enabled == 1) {
    if (timer_delete(timer) < 0) {
        fprintf(stderr, "[%d]: %s\n", __LINE__, strerror(errno));
        exit(errno);
    }
}
#endif
#endif
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
