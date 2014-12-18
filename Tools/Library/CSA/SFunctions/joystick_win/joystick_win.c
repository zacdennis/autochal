/*
NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
*/
/****************************************************************************
*  MODULE:    joystick
*
*  AUTHOR(S): Dan Salluce
*
*  DATE:      July 15, 2002
*
*  Copyright (c) NORTHROP GRUMMAN ALL RIGHTS RESERVED
*  Dan Salluce
*
* This CMEX S-function can be used in Simulink to report input from a 
* Windows Multimedia joystick. The block will output all the axes and buttons
* after polling the joystick. NOTE the ouput ports size according to joystick
* capabilities. Note this will not operate in Linux.
*
*	note: Poll times using Microsoft's gamedriver interface can be very long for analog
*		  devices. It is strongly recommended that digital devices such as the MS Sidewinder
*		  or Logitech Extreme Digital series be used. Most newer (post 2002) joysticks
*         utilize digital USB or gameport drivers.
*
*	Modifications/Revisions:
*	________________________
*	
*   January 6, 2009 - Mike Sufana
*		Added game port option and placed enable flag in RWork vectors.  Multiple instances
*       is now an option.
*
*   May 20, 2005 - Dan Salluce (with some help from Travis Vetter)
*		Complete revise including dynamically sizing outputs to capabilities of joystick
*
*   July 30, 2002 - Dan Salluce
*		Added comments and documentation in header
*
*	July 15, 2002 - Dan Salluce
*		Initial rewrite of code
*   
****************************************************************************/

#define S_FUNCTION_NAME joystick_win
#define S_FUNCTION_LEVEL 2

#define FUNCTION_NAME "joystick_win"

#include "simstruc.h"

#include <math.h>

#include <stdlib.h>
#include <string.h>

#include <conio.h>
#include <math.h>
#include <stdio.h>

#include "windows.h"
#include "Mmsystem.h"

 //Requires the  winmm.lib  Library to compile correctly:
#pragma comment(lib, "winmm.lib")

// Joystick Variables:
BOOL		useJoystick;
JOYINFOEX	joyInfo;
JOYCAPS     joyCaps;

#define NPARAMS 4
/* #define ENABLE_JOYSTICK_PARAM(S) ssGetSFcnParam(S, 0) */
/* #define GAME_PORT_NUM(S) ssGetSFcnParam(S, 1) */

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Setup sizes of the various vectors.
 */
static void mdlInitializeSizes(SimStruct *S)
{
    int game_port_num;
	
    ssSetNumSFcnParams(S, NPARAMS);
     if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }
    
    /* Set Number of States */
    ssSetNumContStates(S, 0);
    ssSetNumDiscStates(S, 0);
    
    /* Set number of INPUT ports */
    ssSetNumInputPorts(S, 0);
    
     /* Set number of OUTPUT Ports */
    if (!ssSetNumOutputPorts(S,2)) return;
    
	joyInfo.dwSize = sizeof(JOYINFOEX);
	joyInfo.dwFlags = JOY_RETURNALL;
    	
	game_port_num = (int)*mxGetPr(ssGetSFcnParam(S,1));
    
    /* Get device capabilities: */   
	if (joyGetDevCaps(game_port_num, &joyCaps, sizeof(JOYCAPS)) != JOYERR_NOERROR)
	{
           /*
     printf ("JOYSTICK :: Using Device: %s (Game Port # %d) (%d axes and %d buttons)\n", 
                        joyCaps.szPname, game_port_num, joyCaps.wNumAxes, joyCaps.wNumButtons);   
         */
		ssSetOutputPortWidth(S, 0, (int)*mxGetPr(ssGetSFcnParam(S,2)));
		ssSetOutputPortWidth(S, 1, (int)*mxGetPr(ssGetSFcnParam(S,3)));
	}
	else
	{
		/* Axes: */
		ssSetOutputPortWidth(S, 0, joyCaps.wNumAxes);
		/* Buttons: */
		ssSetOutputPortWidth(S, 1, joyCaps.wNumButtons);
	}
    	
    ssSetNumSampleTimes(S, 1);
	ssSetNumRWork(S, 3);

    /* Take care when specifying exception free code - see sfuntmpl.doc */
    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);
} /* mdlInitializeSizes() */


/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy that we inherit our sample time from the driving block.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
    ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
	ssSetOffsetTime(S, 0, FIXED_IN_MINOR_STEP_OFFSET);
}

/**********************************************************************/
/* START OF SIMULINK S-FUNCTION CALL: mdlInitializeConditions         */
/* Initialization of States                                           */
/**********************************************************************/
#define MDL_INITIALIZE_CONDITIONS  
#if defined(MDL_INITIALIZE_CONDITIONS)
  static void mdlInitializeConditions(SimStruct *S)
  {
    /* Define R Work Vector */
	/* R Work Vectors are constants that get set once at				*/
	/* initialization and are then referenced in computations.			*/
	real_T* rWorkVec = ssGetRWork(S);
	int enabled_joystick, game_port_num;

	enabled_joystick = (int)*mxGetPr(ssGetSFcnParam(S,0));
	game_port_num	 = (int)*mxGetPr(ssGetSFcnParam(S,1));

    /* Pull Mask Parameters */

	/* Enable Flag, [int] */
	rWorkVec[0]	  = enabled_joystick;

	/* Game Port to Read, [int] */
	rWorkVec[1]	  = game_port_num;

	if (enabled_joystick == 1)
		{
   			if((joyGetPosEx(game_port_num,&joyInfo) == JOYERR_NOERROR))
			{
				/* Joystick Found */
				useJoystick = true;
				printf ("JOYSTICK :: Using Device: %s (Game Port # %d) (%d axes and %d buttons)\n", 
                        joyCaps.szPname, game_port_num, joyCaps.wNumAxes, joyCaps.wNumButtons);
			}
			else
			{
				/* No input devices found */
				printf ("JOYSTICK :: No Joystick Found on Game Port # %d!  Defaulting to %d axes and %d buttons.\n",
                        game_port_num, (int)*mxGetPr(ssGetSFcnParam(S,2)), (int)*mxGetPr(ssGetSFcnParam(S,3)));
				useJoystick = false;
			}

			/* x,y,z,r,u,v - axes order - uncomment this block to see the range of values */
			/*printf("JOYSTICK :: The X-value range is: %d - %d\n", joyCaps.wXmin, joyCaps.wXmax);
			printf("JOYSTICK :: The Y-value range is: %d - %d\n", joyCaps.wYmin, joyCaps.wYmax);
			printf("JOYSTICK :: The Z-value range is: %d - %d\n", joyCaps.wZmin, joyCaps.wZmax);
			printf("JOYSTICK :: The R-value range is: %d - %d\n", joyCaps.wRmin, joyCaps.wRmax);
			printf("JOYSTICK :: The U-value range is: %d - %d\n", joyCaps.wUmin, joyCaps.wUmax);
			printf("JOYSTICK :: The V-value range is: %d - %d\n", joyCaps.wVmin, joyCaps.wVmax);*/
		}

	/* useJoystick, [bool] */
	rWorkVec[2]	  = useJoystick;

  }
#endif

/* Function: mdlOutputs ==================================================== */
static void mdlOutputs(SimStruct *S, int_T tid)
{
	real_T* rWorkVec;
	int enabled_joystick, game_port_num;
	bool useJoystick;
    int num_default_axes = (int)*mxGetPr(ssGetSFcnParam(S,2));
    int num_default_btns = (int)*mxGetPr(ssGetSFcnParam(S,3));
    
    int i, j, k;
	BOOL jButton[32]; // 32 max buttons on winmm system
	
	DWORD buttonBits = 0x00000001;
	real_T            *Axes      = ssGetOutputPortRealSignal(S,0);
	real_T            *Buttons   = ssGetOutputPortRealSignal(S,1);

	rWorkVec		 = ssGetRWork(S);
	enabled_joystick = (int)rWorkVec[0];
	game_port_num	 = (int)rWorkVec[1];
	useJoystick      = (bool)rWorkVec[2];


    /* printf("Entering mdlOutputs\n"); */
    
	if(useJoystick == true && enabled_joystick == 1)
	{
		if(joyGetPosEx(game_port_num,&joyInfo) == JOYERR_NOERROR)
		{
			for(i = 0; i <= (int)joyCaps.wNumAxes; i++)
			{
				switch(i)
				{
				case 1:
					Axes[0] = ((double)joyInfo.dwXpos - (double)joyCaps.wXmax / 2) / ((double)joyCaps.wXmax / 2);
					break;
				case 2:
					Axes[1] = ((double)joyInfo.dwYpos - (double)joyCaps.wYmax / 2) / ((double)joyCaps.wYmax / 2);
					break;
				case 3:
					Axes[2] = ((double)joyInfo.dwZpos - (double)joyCaps.wZmax / 2) / ((double)joyCaps.wZmax / 2);
					break;
				case 4:
					Axes[3] = ((double)joyInfo.dwRpos - (double)joyCaps.wRmax / 2) / ((double)joyCaps.wRmax / 2);
					break;
				case 5:
					Axes[4] = ((double)joyInfo.dwUpos - (double)joyCaps.wUmax / 2) / ((double)joyCaps.wUmax / 2);
					break;
				case 6:
					Axes[5] = ((double)joyInfo.dwVpos - (double)joyCaps.wVmax / 2) / ((double)joyCaps.wVmax / 2);
					break;
				//default:
				//	printf("JOYSTICK :: Error assigning outputs!\n");
				}
			}
			
			//printf("JoyInfo.dwButtons member is 0x%08x\n", joyInfo.dwButtons);

			for(j = 0; j <= (int)joyCaps.wNumButtons; j++)
			{
				jButton[j] = (BOOL)((joyInfo.dwButtons & buttonBits) > 0);
				//printf("The bitcheck value is: 0x%08x\n", buttonBits);
				if (jButton[j] == TRUE)
				{
					Buttons[j] = 1.0;
					//printf("Button %d pressed\n", j);
				}
				else
					Buttons[j] = 0.0;
				
				buttonBits = buttonBits << 1;
			} // check buttons
						
		} //read joystick pos & buttons
	} // use joystick

	else // no joytick so output zero for oversized ports:
	{
		for (k = 0; k < num_default_axes; k++)
		{
			Axes[0] = (double)0.0;
		}
		for (k = 0; k < num_default_btns; k++)
		{
			Buttons[0] = (double)0.0;
		}
	}
} //mdlOutputs

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
    */
   static void mdlDerivatives(SimStruct *S)
   {
   }
#endif /* MDL_DERIVATIVES */



/* Function: mdlTerminate =====================================================
 * Abstract:
 *    No termination needed, but we are required to have this routine.
 */
static void mdlTerminate(SimStruct *S)
{
}


#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif


