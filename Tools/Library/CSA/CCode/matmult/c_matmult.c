/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * c_matmult.c
 * 
 * This is the MATLAB mex wrapper for the norm
 * C code contained in CSA_LIB.c.
 *
 * To mex this file, use mex_matmult.m
 *
 * Copyright Northrop Grumman Corp 2014
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/matmult/c_matmult.c $
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
  double *matA2B_ML, *matB2C_ML, *matA2C_ML;
  double matA2B[3][3], matB2C[3][3], matA2C[3][3];
  short int i, j, ctr;
  
  /*  Check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=2) 
    mexErrMsgIdAndTxt( "MATLAB:matmult:invalidNumInputs",
            "Two inputs required.");
  if(nlhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:matmult:invalidNumOutputs",
            "One output required.");
  
  /*  create a pointer to the input matrix u */
  matA2B_ML = mxGetPr(prhs[0]);
  matB2C_ML = mxGetPr(prhs[1]);
  
  /* Create column-major C matrices from the row-major MATLAB matrices */
  ctr = 0;
  for (j = 0; j < 3; j++) {
      for(i = 0; i < 3; i++) {
          matA2B[i][j]=matA2B_ML[ctr];
          matB2C[i][j]=matB2C_ML[ctr];
          ctr++;
      }
  }
  
  /*  set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleMatrix(3, 3, mxREAL);
  
  /*  create a C pointer to a copy of the output matrix */
  matA2C_ML = mxGetPr(plhs[0]);
  
  /*  call the C subroutine */
  matmult(matA2B, matB2C, matA2C);
    
    /* Create row-major MATLAB matrix from column-major C matrix */
  ctr = 0;
  for (j = 0; j < 3; j++) {
      for(i = 0; i < 3; i++) {
          matA2C_ML[ctr] = matA2C[i][j];
          ctr++;
      }
  }
}
