/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * c_maxall.c
 * 
 * This is the MATLAB mex wrapper for the maxall
 * C code contained in CSA_LIB.c.
 *
 * To mex this file, use mex_maxall.m
 *
 * Copyright Northrop Grumman Corp 2013
 * Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
 * http://trac.ngst.northgrum.com/CSA/
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/CrankActuatorMapping_ThetaToX/c_CrankActuatorMapping_ThetaToX.c $
 * $Rev: 2247 $
 * $Date: 2011-11-01 18:01:21 -0700 (Tue, 01 Nov 2011) $
 * $Author: sufanmi $
 *
 */

#include "mex.h"
#include "CSA_LIB.h"

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *u, *umax;
  size_t mrows,ncols;
  
  /*  Check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:maxall:invalidNumInputs",
            "One input required.");
  if(nlhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:maxall:invalidNumOutputs",
            "One output required.");
  
  /*  create a pointer to the input matrix y */
  u = mxGetPr(prhs[0]);
  
  /*  get the dimensions of the matrix input y */
  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);
  
  /*  set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleScalar(0);
  
  /*  create a C pointer to a copy of the output matrix */
  umax = mxGetPr(plhs[0]);
  
  /*  call the C subroutine */
  maxall(u, umax, mrows, ncols);
  
}
