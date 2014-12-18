/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * c_TranslateOffsets.c
 * 
 * This is the MATLAB mex wrapper for the TranslateOffsets
 * C code contained in CSA_LIB.c.
 *
 * To mex this file, use mex_TranslateOffsets.m
 *
 * Copyright Northrop Grumman Corp 2014
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/TranslateOffsets/c_TranslateOffsets.c $
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
    double *P_i, *V_i, *Euler_i_rad, *PQRb_rps, *Pt_P_b_rel, *Pt_Euler_b_rel_rad;
    double *Pt_P_i, *Pt_V_i, *Pt_Euler_i_rad, *Pt_PQRb_rps, *Pt_P_i_rel;
    mwSize mrows, ncols;
    
    // Inputs
    //   1  double P_i[3]
    //   2  double V_i[3]
    //   3  double Euler_i_rad[3]
    //   4  double PQRb_rps[3]
    //   5  double Pt_P_b_rel[3]
    //   6  double Pt_Euler_b_rel_rad[3]
    
    // Outputs
    //   1  double Pt_P_i[3]
    //   2  double Pt_V_i[3],
    //   3  double Pt_Euler_i_rad[3]
    //   4  double Pt_PQRb_rps[3]
    //   5  double Pt_P_i_rel[3]

  /*  Check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=6) 
    mexErrMsgIdAndTxt( "MATLAB:TranslateOffsets:invalidNumInputs",
            "Six inputs required.");
  if(nlhs!=5) 
    mexErrMsgIdAndTxt( "MATLAB:TranslateOffsets:invalidNumOutputs",
            "Five outputs required.");
  
  /*  create a pointer to the input matrix u */
  P_i               = mxGetPr(prhs[0]);
  V_i               = mxGetPr(prhs[1]);
  Euler_i_rad       = mxGetPr(prhs[2]);
  PQRb_rps          = mxGetPr(prhs[3]);
  Pt_P_b_rel        = mxGetPr(prhs[4]);
  Pt_Euler_b_rel_rad= mxGetPr(prhs[5]);
    
  /*  set the output pointer to the output matrix */
  plhs[0] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[2] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[3] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  plhs[4] = mxCreateDoubleMatrix(mrows, ncols, mxREAL);
  
  /*  create a C pointer to a copy of the output matrix */
  Pt_P_i        = mxGetPr(plhs[0]);
  Pt_V_i        = mxGetPr(plhs[1]);
  Pt_Euler_i_rad= mxGetPr(plhs[2]);
  Pt_PQRb_rps   = mxGetPr(plhs[3]);
  Pt_P_i_rel    = mxGetPr(plhs[4]);
  
  /*  call the C subroutine */
  TranslateOffsets(P_i, V_i, Euler_i_rad, PQRb_rps, 
          Pt_P_b_rel, Pt_Euler_b_rel_rad, 
          Pt_P_i, Pt_V_i, Pt_Euler_i_rad, Pt_PQRb_rps, Pt_P_i_rel);
    
}
