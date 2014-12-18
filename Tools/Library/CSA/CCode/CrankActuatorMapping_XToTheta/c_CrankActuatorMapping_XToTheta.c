/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * c_CrankActuatorMapping_XToTheta.c
 * 
 * This is the MATLAB mex wrapper for the CrankActuatorMapping_XToTheta
 * C code contained in CSA_LIB.c.
 *
 * To mex this file, use mex_CrankActuatorMapping_XToTheta.m
 *
 * Copyright Northrop Grumman Corp 2011
 * Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
 * http://vodka.ccc.northgrum.com/trac/CSA/
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/CrankActuatorMapping_XToTheta/c_CrankActuatorMapping_XToTheta.c $
 * $Rev: 2247 $
 * $Date: 2011-11-01 20:01:21 -0500 (Tue, 01 Nov 2011) $
 * $Author: sufanmi $
 *
 */

#include "mex.h"
#include "CSA_LIB.h"

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    /* Declare Inputs: */
    double X, R, C, L2, ThetaBias_deg, XBias;
    
    /* Declare Outputs: */
    double *Theta_deg;
    
    /* Get the value of each input:  */
    X               = mxGetScalar(prhs[0]);
    R               = mxGetScalar(prhs[1]);
    C               = mxGetScalar(prhs[2]);
    L2              = mxGetScalar(prhs[3]);
    ThetaBias_deg   = mxGetScalar(prhs[4]);
    XBias           = mxGetScalar(prhs[5]);
    
    /* Initialize the Output: */
    plhs[0] = mxCreateDoubleScalar(0);  // Theta_deg
    
    /* Link Output Pointers: */
    Theta_deg = mxGetPr(plhs[0]);
    
    /* Call the Function: */
    CrankActuatorMapping_XToTheta(X, R, C, L2, ThetaBias_deg, XBias, Theta_deg);
}
