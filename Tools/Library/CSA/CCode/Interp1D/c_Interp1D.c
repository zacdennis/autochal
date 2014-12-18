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
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/Interp1D/c_Interp1D.c $
 * $Rev: 3053 $
 * $Date: 2013-11-19 19:06:34 -0600 (Tue, 19 Nov 2013) $
 * $Author: sufanmi $
 *
 */

#include "mex.h"
#include "CSA_LIB.h"

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *DataX1, *DataY1, *xDes, *yDes;
  size_t nRow, nCol;
  unsigned int nPts;
  
  /*  Check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=3) 
    mexErrMsgIdAndTxt( "MATLAB:maxall:invalidNumInputs",
            "Three inputs required.");
  if(nlhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:maxall:invalidNumOutputs",
            "One output required.");
  
  /*  create a pointer to the input matrix y */
  DataX1 = mxGetPr(prhs[0]);
  DataY1 = mxGetPr(prhs[1]);
  xDes   = mxGetPr(prhs[2]);
    
  /*  get the dimensions of the matrix input y */
  nRow = mxGetM(prhs[0]);
  nCol = mxGetN(prhs[0]);
  //mexPrintf("\nSize c_Interp1D(1) = [%d %d]\n", nRow, nCol);
  nPts = (unsigned int)max(nRow, nCol);
  
  //mexPrintf("\nThere are %d Pts\n", nPts);
  //mexPrintf("\nyDes = %f\n", xDes);
  
  /*  set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleScalar(0);
   
  /*  create a C pointer to a copy of the output matrix */
  yDes = mxGetPr(plhs[0]);
  
  /*  call the C subroutine */
  Interp1D(DataX1, DataY1, xDes, yDes, nPts);
  
}
