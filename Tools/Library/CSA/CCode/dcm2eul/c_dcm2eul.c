/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * c_dcm2euleul2dcm.c
 * 
 * This is the MATLAB mex wrapper for the eul2dcm
 * C code contained in CSA_LIB.c.
 *
 * To mex this file, use mex_eul2dcm.m
 *
 * Copyright Northrop Grumman Corp 2014
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/dcm2eul/c_dcm2eul.c $
 * $Rev: 3089 $
 * $Date: 2014-03-06 16:18:21 -0600 (Thu, 06 Mar 2014) $
 * $Author: sufanmi $
 *
 */

#include "mex.h"
#include "CSA_LIB.h"

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *Euler_rad, *DCM_ML;
  double DCM[3][3];
  short int i, j, ctr;
  
  /*  Check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:c_dcm2eul:invalidNumInputs",
            "One input required.");
  if(nlhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:c_dcm2eul:invalidNumOutputs",
            "One output required.");
  
  /*  create a pointer to the input matrix u */
  DCM_ML = mxGetPr(prhs[0]);

    /* Create column-major C matrices from the row-major MATLAB matrices */
  ctr = 0;
  for (j = 0; j < 3; j++) {
      for(i = 0; i < 3; i++) {
          DCM[i][j]=DCM_ML[ctr];
          ctr++;
      }
  }
  
  /*  set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleMatrix(3, 1, mxREAL);
  
  /*  create a C pointer to a copy of the output matrix */
  Euler_rad = mxGetPr(plhs[0]);
  
  /*  call the C subroutine */
  dcm2eul(DCM, Euler_rad);
}
