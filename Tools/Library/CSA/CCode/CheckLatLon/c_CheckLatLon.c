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
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/CheckLatLon/c_CheckLatLon.c $
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
    double Lat0_deg, Lon0_deg;
    
    /* Declare Outputs: */
    double *Lat_deg, *Lon_deg;
    
    /* Get the value of each input:  */
    Lat0_deg    = mxGetScalar(prhs[0]);
    Lon0_deg    = mxGetScalar(prhs[1]);
    
    /* Initialize the Output: */
    plhs[0] = mxCreateDoubleScalar(0);  // Lat_deg
    plhs[1] = mxCreateDoubleScalar(0);  // Lon_deg
    
    /* Link Output Pointers: */
    Lat_deg    = mxGetPr(plhs[0]);
    Lon_deg = mxGetPr(plhs[1]);
    
    /* Call the Function: */
    CheckLatLon(Lat0_deg, Lon0_deg, Lat_deg, Lon_deg);
}
