/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * c_matvecmult.c
 * 
 * This is the MATLAB mex wrapper for the matvecmult
 * C code contained in CSA_LIB.c.
 *
 * To mex this file, use mex_matvecmult.m
 *
 * Copyright Northrop Grumman Corp 2014
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/matvecmult/c_matvecmult.c $
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
  double *matA2B_ML, *vecA, *vecB;
  double matA2B[3][3];
  short int i, j, ctr;
  mwSize mrows, ncols;
  
  /*  Check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=2) 
    mexErrMsgIdAndTxt( "MATLAB:matvecmult:invalidNumInputs",
            "Two inputs required.");
  if(nlhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:matvecmult:invalidNumOutputs",
            "One output required.");
  
  /*  create a pointer to the input matrix u */
  matA2B_ML = mxGetPr(prhs[0]);
  vecA      = mxGetPr(prhs[1]);
  
  /* Create column-major C matrix from the row-major MATLAB matrix */
  ctr = 0;
  for (j = 0; j < 3; j++) {
      for(i = 0; i < 3; i++) {
          matA2B[i][j]=matA2B_ML[ctr];
          ctr++;
      }
  }
  
  /* Get the dimensions of the matrix input vecA */
  mrows = mxGetM(prhs[1]);
  ncols = mxGetN(prhs[1]);
      
  /*  Set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  
  /*  Create a C pointer to a copy of the output matrix */
  vecB = mxGetPr(plhs[0]);
  
  /*  call the C subroutine */
  matvecmult(matA2B, vecA, vecB);
}
