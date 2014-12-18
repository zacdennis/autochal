/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * c_crossv.c
 * 
 * This is the MATLAB mex wrapper for the norm
 * C code contained in CSA_LIB.c.
 *
 * To mex this file, use mex_crossv.m
 *
 * Copyright Northrop Grumman Corp 2014
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/crossv/c_crossv.c $
 * $Rev: 3087 $
 * $Date: 2014-03-05 19:36:30 -0600 (Wed, 05 Mar 2014) $
 * $Author: sufanmi $
 *
 */

#include "mex.h"
#include "CSA_LIB.h"

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *vecA, *vecB, *vecC;
  mwSize mrows, ncols;
  
  /*  Check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=2) 
    mexErrMsgIdAndTxt( "MATLAB:crossv:invalidNumInputs",
            "Two inputs required.");
  if(nlhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:crossv:invalidNumOutputs",
            "One output required.");
  
  /*  create a pointer to the input matrix u */
  vecA = mxGetPr(prhs[0]);
  vecB = mxGetPr(prhs[1]);
  
  /*  get the dimensions of the matrix input vecA */
  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);
    
  /*  set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  
  /*  create a C pointer to a copy of the output matrix */
  vecC = mxGetPr(plhs[0]);
  
  /*  call the C subroutine */
  crossv(vecA, vecB, vecC);
}
