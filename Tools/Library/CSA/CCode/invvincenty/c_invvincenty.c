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
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/invvincenty/c_invvincenty.c $
 * $Rev: 3057 $
 * $Date: 2013-12-16 17:24:35 -0600 (Mon, 16 Dec 2013) $
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
    double lat1_deg, lon1_deg, az1_deg, dist, CB_a, CB_f;
    
    /* Declare Outputs: */
    double *lat2_deg, *lon2_deg, *az2_deg;
    
    /* Get the value of each input:  */
    lat1_deg    = mxGetScalar(prhs[0]);
    lon1_deg    = mxGetScalar(prhs[1]);
    az1_deg     = mxGetScalar(prhs[2]);
    dist        = mxGetScalar(prhs[3]);
    CB_a        = mxGetScalar(prhs[4]);
    CB_f        = mxGetScalar(prhs[5]);
    
    /* Initialize the Output: */
    plhs[0] = mxCreateDoubleScalar(0);  // lat2
    plhs[1] = mxCreateDoubleScalar(0);  // lon2
    plhs[2] = mxCreateDoubleScalar(0);  // az2
    
    /* Link Output Pointers: */
    lat2_deg    = mxGetPr(plhs[0]);
    lon2_deg    = mxGetPr(plhs[1]);
    az2_deg     = mxGetPr(plhs[2]);
    
    /* Call the Function: */
    invvincenty(lat1_deg, lon1_deg, az1_deg, dist, CB_a, CB_f, lat2_deg, lon2_deg, az2_deg);
}
