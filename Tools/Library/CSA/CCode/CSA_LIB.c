/* -------------------------- UNCLASSIFIED ---------------------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 *
 * Common Simulation Architecture C Code Library
 *
 * This library contains translated Simulink and MATLAB code in C format.
 *  Remember that C is order specific.  If function 'B' below utilizes a
 *  function 'A', function 'A' must be placed above function 'B'.
 *
 * Copyright Northrop Grumman Corp 2013
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/CSA_LIB.c $
 * $Rev: 3089 $
 * $Date: 2014-03-06 16:18:21 -0600 (Thu, 06 Mar 2014) $
 * $Author: sufanmi $
 */

/* Included C Libraries */
#include <stdlib.h>
#include <math.h>
#include "CSA_LIB.h"

/* =====================================================================
 *							BASIC MATH UTILITIES
 * ===================================================================== */
double sign( double val )
{
    /* Returns the sign (-1, 0, or +1) of the input value */
    if(val > 0.0) {
        return 1.0;
    }
    else if(val < 0.0) {
        return -1.0;
    }
    else {
        return 0.0;
    }
}

/* =====================================================================
 *							ANGLE WRAPPING UTILITIES
 * ===================================================================== */
double wrap180( double IN )
{
    /* Wraps an input angle [deg] to be between -180 and 180 [deg] */
    return ( atan2( sin(IN*D2R), cos(IN*D2R) )*R2D );
}
// ====================================================
void CheckLatLon(double Lat0_deg, double Lon0_deg, double *Lat_deg, double *Lon_deg)
{
    /*
     * CheckLatLon: Adjusts Latitude to be within +/- 90 deg and 
     * Longitude to be within +/-180 deg.
     *
     * INPUTS:
     *	Name        Size    Units		Description
     *  Lat0_deg    [1]     [deg]       Input Latitude (-inf < Lat0 < inf)
     *  Lon0_deg    [1]     [deg]       Input Latitude (-inf < Lat0 < inf)
     *
     * OUTPUTS:
     *	Name        Size    Units		Description
     *	Lat_deg     [1]  	[deg]  		Fixed Latitude (-90 <= Lat <= 90)
     **	Lon_deg     [1]  	[deg]  		Fixed Longitude(-180 <= Lon <= 180)
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/821
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */
    double Lat1_deg, Lon1_deg;
    
    /* Fix Latitude to be within 0 and 360 */
    Lat1_deg = fmod(Lat0_deg, 360.0);

    /* Compute Latitude to be within +/- 90 deg */
    *Lat_deg = asin( sin(Lat1_deg * D2R) ) * R2D;

    /* Adjust Longitude for Latitutde Correction */
    /* If Lat1 > 90 and Lat1 < 270, add 180 to Longitude */
    Lon1_deg = Lon0_deg + 90.0 * (1.0-sign(cos(Lat1_deg*D2R)));

    /* Fix Longitude to be within 0 and 360 */
    *Lon_deg = fmod(Lon1_deg, 360.0);

    if (*Lon_deg > 180.0)
    {
        *Lon_deg = *Lon_deg - 360.0;
    }
}

/* =====================================================================
 *							VECTOR UTILITIES
 * ===================================================================== */
double norm( double vec[3] )
{
    /* norm: Returns the Vector Norm of a [3] vector
     *
     * INPUTS
     *	Name    Size    Units	Description
     *	vec		[3]     [N/A]   Vector Input
     *
     * OUTPUT
     *	Name    Size    Units	Description
     *	norm	[1]     [N/A]   Norm of Vector
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/834
     */
    return sqrt( vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2] );
}

void crossv( double vecA[3], double vecB[3], double vecC[3] )
{
    /* crossv: Returns the Cross Product of Two Vectors (C = A x B)
     *
     * INPUTS
     *	Name    Size    Units	Description
     *	vecA    [3]     [N/A]   Vector A
     *	vecB    [3]     [N/A]   Vector B
     *
     * OUTPUT
     *	Name    Size    Units	Description
     *	vecC    [3]     [N/A]   Cross Product of Vectors A & B
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/835
     */
    vecC[0] = vecA[1]*vecB[2] - vecA[2]*vecB[1];
    vecC[1] = vecA[2]*vecB[0] - vecA[0]*vecB[2];
    vecC[2] = vecA[0]*vecB[1] - vecA[1]*vecB[0];
}

/* =====================================================================
 *							MATRIX UTILITIES
 * ===================================================================== */
void matmult(double matA2B[3][3], double matB2C[3][3], double matA2C[3][3] )
{
    /* matmult: Matrix Multiplication of two 3x3 matrices
     *
     * INPUTS
     *	Name    Size    Units	Description
     *  matA2B  [3][3]  [ND]    Matrix # 1 (ie DCM b_C_a)
     *  matB2C  [3][3]  [ND]    Matrix # 2 (ie DCM c_C_b)
     *
     * OUTPUTS
     *	Name    Size    Units	Description
     *  matA2C  [3][3]  [ND]    Matrix #2 * #1 (ie DCM c_C_a)
     *                          matA2C = matB2C * matA2B
     *                           c_C_a =  c_C_b * b_C_a
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/836
     */
    short int i;
    for( i = 0; i < 3; i++ )  {
        matA2C[0][i] = matA2B[0][0]*matB2C[0][i] + matA2B[0][1]*matB2C[1][i] + matA2B[0][2]*matB2C[2][i];
        matA2C[1][i] = matA2B[1][0]*matB2C[0][i] + matA2B[1][1]*matB2C[1][i] + matA2B[1][2]*matB2C[2][i];
        matA2C[2][i] = matA2B[2][0]*matB2C[0][i] + matA2B[2][1]*matB2C[1][i] + matA2B[2][2]*matB2C[2][i];
    }
}

/* ===================================================================== */
void matvecmult(double matA2B[3][3], double vecA[3], double vecB[3])
{
    /* matvecmult: Matrix Multiplication of a 3x3 Matrix and a 3x1 Vector
     *
     * INPUTS
     *	Name    Size    Units	Description
     *  matA2B  [3][3]  [ND]    3x3 Matrix (i.e. a direction cosine matrix)
     *  vecA    [3]     [N/A]   3x1 Vector in coordinate frame A
     *
     * OUTPUTS
     *	Name    Size    Units	Description
     *  vecB    [3]     [N/A]   3x1 Vector in coordiante frame B
     *                          (vecB = matA2B * vecA)
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/837
     */
    vecB[0] = matA2B[0][0]*vecA[0] + matA2B[0][1]*vecA[1] + matA2B[0][2]*vecA[2];
    vecB[1] = matA2B[1][0]*vecA[0] + matA2B[1][1]*vecA[1] + matA2B[1][2]*vecA[2];
    vecB[2] = matA2B[2][0]*vecA[0] + matA2B[2][1]*vecA[1] + matA2B[2][2]*vecA[2];
}

/* ===================================================================== */
void transpose( double matIN[3][3], double matTRANS[3][3] )
{
    /* transpose: Transpose of a 3x3 matrix
     *
     * INPUTS
     *	Name        Size    Units	Description
     *  matIN       [3][3]  [ND]    3x3 Input Matrix
     *
     * OUTPUTS
     *	Name        Size    Units	Description
     *  matTRANS    [3][3]  [ND]    Transpose of matIN (matTRANS = matIN')
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/838
     */
    short int i, j;
    for(i = 0; i < 3; i++ ) {
        for(j = 0; j < 3; j++ ) {
            matTRANS[i][j] = matIN[j][i];
        }
    }
}

/* =====================================================================
 *					QUATERNION / EULER / DCM CONVERSIONS
 * ===================================================================== */
void eul2dcm(double eul_rad[3], double dcm[3][3])
{
    /* eul2dcm: Computes the Direction Cosine Matrix from Euler Angles
     *  Assumes 3-2-1 rotation (Yaw, Pitch, Roll)
     *
     * INPUTS
     *	Name        Size    Units	Description
     *	eul_rad		[3]		[rad]	Euler Angles (Roll/Pitch/Yaw)
     *
     * OUPUTS
     *	Name        Size    Units	Description
     *	dcm         [3][3]	[ND]	Direction Cosine Matrix
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/839
     */
    double phi, theta, psi;
    phi     = eul_rad[0];
    theta   = eul_rad[1];
    psi     = eul_rad[2];
    
    dcm[0][0] = cos(psi)*cos(theta);
    dcm[1][0] = cos(theta)*sin(psi);
    dcm[2][0] = -sin(theta);
    
    dcm[0][1] = cos(psi)*sin(phi)*sin(theta) - cos(phi)*sin(psi);
    dcm[1][1] = cos(phi)*cos(psi) + sin(phi)*sin(psi)*sin(theta);
    dcm[2][1] = cos(theta)*sin(phi);
    
    dcm[0][2] = sin(phi)*sin(psi) + cos(phi)*cos(psi)*sin(theta);
    dcm[1][2] = cos(phi)*sin(psi)*sin(theta) - cos(psi)*sin(phi);
    dcm[2][2] = cos(phi)*cos(theta);
}

/* ===================================================================== */
void dcm2eul(double dcm[3][3], double eul_rad[3])
{
    /* dcm2eul: Converts Direction Cosine Matrix into Euler Angles
     *          Assumes 3-2-1 rotation (Yaw, Pitch, Roll)
     *
     * INPUTS
     *	Name    Size    Units	Description
     *	dcm		[3][3]	[ND]	Direction Cosine Matrix
     *
     * OUPUTS
     *	Name    Size    Units	Description
     *	eul_rad	[3]		[rad]	Euler Angles (Roll/Pitch/Yaw)
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/840
     */
    
    eul_rad[0] = atan2( dcm[1][2], dcm[2][2] );
    eul_rad[1] = asin( -dcm[0][2]);
    eul_rad[2] = atan2( dcm[0][1], dcm[0][0] );
}

/* =====================================================================
 *							COORDINATE TRANSFORMATIONS
 * ===================================================================== */
void TranslateOffsets(double P_i[3], double V_i[3], double Euler_i_rad[3], 
        double PQRb_rps[3], double Pt_P_b_rel[3], 
        double Pt_Euler_b_rel_rad[3], 
        double Pt_P_i[3], double Pt_V_i[3], double Pt_Euler_i_rad[3], 
        double Pt_PQRb_rps[3], double Pt_P_i_rel[3])
{
    /* TranslateOffsets: Matrix Multiplication of a 3x3 Matrix and a 3x1 Vector
     *
     * INPUTS
     *	Name                Size    Units           Description
     *  P_i                 [3]     [length]        CG Position w.r.t. inertial frame
     *  V_i                 [3]     [length/sec]    CG Velocity w.r.t. inertial frame
     *  Euler_i_rad         [3]     [rad]           CG Attitude w.r.t. inertial frame
     *  PQRb_rps            [3]     [rad/sec]       CG Body Rates
     *  Pt_P_b_rel          [3]     [length]        Attachment Pt relative 
     *                                               to CG in body frame
     *  Pt_Euler_b_rel_rad  [3]     [rad]           Attachment Pt attitude
     *                                               relative to CG
     *
     * OUTPUTS
     *	Name                Size    Units           Description
     *  Pt_P_i              [3]     [length]        Pt Position w.r.t. inertial frame
     *  Pt_V_i              [3]     [length/sec]    Pt Velocity w.r.t. inertial frame
     *  Pt_Euler_i_rad      [3]     [rad]           Pt Attitude w.r.t. inertial frame
     *  Pt_PQRb_rps         [3]     [rad/sec]       Pt Body Rates
     *  Pt_P_i_rel          [3]     [length]        Attachment Pt relative
     *                                               to CG in inertial frame
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/841
     */
    double pt_C_b[3][3], pt_C_i[3][3], b_C_i[3][3], i_C_b[3][3];
    double V_b_rel[3], V_i_rel[3];
    
    /* Compute DCMs between body and inertial */
    eul2dcm(Euler_i_rad, b_C_i);
    transpose(b_C_i, i_C_b);
    
    /* Compute Pt_P_i */
    matvecmult(i_C_b, Pt_P_b_rel, Pt_P_i_rel);
    Pt_P_i[0] = P_i[0] + Pt_P_i_rel[0];
    Pt_P_i[1] = P_i[1] + Pt_P_i_rel[1];
    Pt_P_i[2] = P_i[2] + Pt_P_i_rel[2];
    
    /* Compute Pt_V_i */
    crossv(PQRb_rps, Pt_P_b_rel, V_b_rel);
    matvecmult(i_C_b, V_b_rel, V_i_rel);
    Pt_V_i[0] = V_i[0] + V_i_rel[0];
    Pt_V_i[1] = V_i[1] + V_i_rel[1];
    Pt_V_i[2] = V_i[2] + V_i_rel[2];

    /* Compute Pt_Euler_i_rad */
    eul2dcm(Pt_Euler_b_rel_rad, pt_C_b);
    matmult(pt_C_b, b_C_i, pt_C_i);
    dcm2eul(pt_C_i, Pt_Euler_i_rad);
    
    /* Compute Pt_PQRb */
    matvecmult(pt_C_b, PQRb_rps, Pt_PQRb_rps);
}


/* =====================================================================
 *						LINEAR INTERPOLATION UTILITIES
 * ===================================================================== */
void Interp1D(double *DataX1, double *DataY1, double *xDes, double *yDes, unsigned int nPts)
{
    /*
     * Interp1D: 1-D Linear Interpolation with held endpoints
     *
     * DESCRIPTION:
     *
     * INPUTS:
     *	Name    Size            Units		Description
     *	DataX1  [nPts]          [N/A]       Breakpoints of independent variable
     *  DataY1  [nPts]          [N/A]       Dependent data
     *  xDes    [1]             [N/A]       Value at which to interpolate DataY1
     *  nPts    [1]             [int]       Number of Datapoints
     *
     * OUTPUTS:
     *	Name    Size            Units		Description
     *	yDes    [1]             [N/A]       Interpolated Data
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/820
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */
    unsigned int iPt;
    if(*xDes < DataX1[0]) {
        // Hold lower bound
        *yDes = DataY1[0];
    }
    else if (*xDes > DataX1[nPts-1]) {
        // Hold upper bound
        *yDes = DataY1[nPts-1];
    }
    else {
        // Somewhere in the middle
        for (iPt = 0; iPt<(nPts-1); iPt++) {
            if(WITHINLIMITS(*xDes, DataX1[iPt], DataX1[iPt+1])) {
                *yDes = (DataY1[iPt+1]-DataY1[iPt])/(DataX1[iPt+1]-DataX1[iPt])*(*xDes-DataX1[iPt]) + DataY1[iPt];
                break;
            }
        }
    }
}

void maxall(double *u, double *umax, unsigned int nRow, unsigned int nCol)
{
    /*
     * maxall: Maximum value in a 2-D matrix
     *
     * DESCRIPTION:
     *   Finds the maximum value in a 2-D matrix
     *
     * INPUTS:
     *	Name    Size            Units		Description
     *	u       [nRow x nCol]   [N/A]       2-D matrix
     *  nRow    [1]             [int]       Number of rows in u
     *  nCol    [1]             [int]       Number of columns in u
     *
     * OUTPUTS:
     *	Name    Size            Units		Description
     *	umax    [1]             [N/A]       Maximum value in u
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/818
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */
  unsigned int iRow, iCol, count=0;
  for (iCol = 0; iCol < nCol; iCol++) {
    for (iRow = 0; iRow < nRow; iRow++) {
        if(count == 0) {
            *umax = *(u+count);
        }
        else {
            *umax = max(*umax, *(u+count));
        }
        count++;
    }
  }
}

void minall(double *u, double *umin, unsigned int nRow, unsigned int nCol)
{
        /*
     * minall: Minimum value in a 2-D matrix
     *
     * DESCRIPTION:
     *   Finds the minimum value in a 2-D matrix
     *
     * INPUTS:
     *	Name    Size            Units		Description
     *	u       [nRow x nCol]   [N/A]       2-D matrix
     *  nRow    [1]             [int]       Number of rows in u
     *  nCol    [1]             [int]       Number of columns in u
     *
     * OUTPUTS:
     *	Name    Size            Units		Description
     *	umin    [1]             [N/A]       Minimum value in u
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/819
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */
  unsigned int iRow, iCol, count=0;
  for (iCol = 0; iCol < nCol; iCol++) {
    for (iRow = 0; iRow < nRow; iRow++) {
        if(count == 0) {
            *umin = *(u+count);
        }
        else {
            *umin = min(*umin, *(u+count));
        }
        count++;
    }
  }
}

void CrankActuatorMapping_XToTheta(double X, double R, double C, double L2, double ThetaBias_deg, double XBias, double *Theta_deg)
 {
    /*
     * CrankActuatorMapping_XToTheta: Crank Actuator Mapping Linear X Deflection to Surface Rotation
     *
     * DESCRIPTION:
     *   This function is for use with linear actuators that are connected to
     *   rotary control surfaces (like an elevator).  This 'crank function'
     *   translates a linear actuator deflection, X, into a rotation angle,
     *   Theta, assuming basic geometric constraints of the actuator and crank
     *   lever arm.
     *
     * INPUTS:
     *	Name            Size		Units		Description
     *	X               [1]         [dist]      Linear actuator position
     *	R               [1]         [dist]      Length of crank lever arm
     *	C               [1]         [dist]      Length of the linear actuator
     *  L2              [1]         [dist]      Distance between the pivot
     *                                            points for the crank arm and
     *                                            linear actuator
     *  ThetaBias_deg   [1]         [deg]       Angle bias that Theta takes on
     *                                            when X is in neutral state.
     *  XBias           [1]         [dist]      Position bias when actuator is
     *                                            in its neutral state.  When X
     *                                            "reads" 0, XBias is 'actual
     *                                            distance between clevis and
     *                                            actuator attachment point'
     *                                            (L1) - C
     * OUTPUTS:
     *	Name            Size		Units		Description
     *	Theta_deg       [1]         [deg]       Control surface deflection angle
     *
     * NOTES:
     *	This function is vectorized, so 'X' can be a scalar or vector. Output
     *	'Theta_deg' will carry same dimensions as 'X'.  Units for 'R',
     *	'C', 'X', and 'L2' are not specified.  However, these 4 all must use
     *   the same distance unit, so standard English [ft] or Metric [m] should
     *   be used.
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/732
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */

    double L1, Alpha0_deg, Alpha_deg;
    
    Alpha0_deg = acos( (R*R + L2*L2 - C*C)/(2*R*L2) )*R2D;  // [deg]
    L1 = (X-XBias) + C;                                     // [dist]
    Alpha_deg = acos( (R*R + L2*L2 - L1*L1)/(2*R*L2) )*R2D; // [deg]
    *Theta_deg = Alpha_deg - Alpha0_deg + ThetaBias_deg;    // [deg]
}

void CrankActuatorMapping_ThetaToX(double Theta_deg, double R, double C, double L2, double ThetaBias_deg, double XBias, double *X)
{
    /*
     * CrankActuatorMapping_ThetaToX: Crank Actuator Mapping Surface Rotation to Linear X Deflection
     *
     * DESCRIPTION:
     *   This function is for use with linear actuators that are connected to
     *   rotary control surfaces (like an elevator).  This 'crank function'
     *   translates a rotation angle, Theta, into the linear actuator deflection,
     *   X, assuming basic geometric constraints of the actuator and crank lever
     *   arm.
     *
     * SYNTAX:
     *	[X] = CrankActuatorMapping_ThetaToX(Theta_deg, R, C, L2, ThetaBias_deg, XBias)
     *
     * INPUTS:
     *	Name            Size		Units		Description
     *	Theta_deg       [1]         [deg]       Control surface deflection angle
     *	R               [1]         [dist]      Length of crank lever arm
     *	C               [1]         [dist]      Length of the linear actuator
     *  L2              [1]         [dist]      Distance between the pivot
     *                                            points for the crank arm and
     *                                            linear actuator
     *  ThetaBias_deg   [1]         [deg]       Angle bias that Theta takes on
     *                                            when X is in neutral state.
     *  XBias           [1]         [dist]      Position bias when actuator is
     *                                            in its neutral state.  When X
     *                                            "reads" 0, XBias is 'actual
     *                                            distance between clevis and
     *                                            actuator attachment point'
     *                                            (L1) - C
     * OUTPUTS:
     *	Name     	Size		Units           Description
     *	X           [1]         [dist]          Linear actuator deflection distance
     *
     * NOTES:
     *	This function is vectorized, so 'Theta_deg' can be a scalar or vector.
     *	Output 'X' will carry same dimensions as 'Theta_deg'.  Units for 'R',
     *	'C', 'L2', and 'X' are not specified.  However, these 4 all must use
     *   the same distance unit, so standard English [ft] or Metric [m] should
     *   be used.
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://vodka.ccc.northgrum.com/trac/CSA/ticket/731
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */
    
     double L1, Alpha0_deg, Alpha_deg;
    
    Alpha0_deg = acos( (R*R + L2*L2 - C*C)/(2*R*L2) ) * R2D;
    Alpha_deg = Theta_deg - ThetaBias_deg + Alpha0_deg;
    L1 = sqrt( R*R + L2*L2 - ((2*R*L2)*cos(Alpha_deg*D2R)) );
    *X = L1 - C + XBias;
}

/* FOOTER
 *
 * WARNING - This document contains technical data whose export is
 *   restricted by the Arms Export Control Act (Title 22, U.S.C. 2751 et 
 *   seq.) or the Export Administration Act of 1979, as amended, Title 50,
 *   U.S.C., App.2401et seq. Violation of these export-control laws is 
 *   subject to severe civil and/or criminal penalties.
 *
 * -------------- Northrop Grumman Proprietary Level 1 ---------------
 * ------------------ ITAR Controlled Work Product -------------------
 * -------------------------- UNCLASSIFIED ---------------------------
 */
void vincenty( double latitude1_deg, double longitude1_deg, double latitude2_deg, double longitude2_deg,
    double CB_a, double CB_flatten, double *dist, double *azimuth1_deg, double *azimuth2_deg)
{
    /* vincenty: 
     *  Computes distance between two geodetic latitude / longitude points.
     *  The distance is commonly referred to the 'as-the-crow-flies'
     *  distance.  Assumes an oblate spheroid central body (e.g. WGS-84).
     *
     * INPUTS:
     *  Name            Size    Units   Description
     *  latitude1_deg   [1]     [deg]   Geodetic Latitude of Origin (Point # 1)
     *  longitude1_deg  [1]     [deg]   Longitude of Origin (Point # 1)
     *  latitude2_deg   [1]     [deg]   Geodetic Latitude of Destination (Point # 2)
     *  longitude2_deg  [1]     [deg]   Longitude of Destination (Point # 2)
     *  CB_a            [1]     [dist]  Central Body Semi-major Axis
     *  CB_flatten      [1]     [ND]    Central Body Flattening Parameter
     *
     * OUTPUTS:
     *  Name            Size    Units   Description
     *  dist            [1]     [dist]  Distance to travel along Spheroid
     *                                  from Origin to Destination
     *  azimuth1_deg    [1]     [deg]   Initial Bearing from Point # 1 towards
     *                                  Point # 2, (0 degrees is due North, 
     *                                  positive rotation towards East)
     *  azimuth2_deg    [1]     [deg]   Initial Bearing from Point # 2 towards
     *                                  Point # 1, (0 degrees is due North, 
     *                                  positive rotation towards East)
     *
     *
     * NOTES:
     *   This calculation is not unit specific.  Input distances only need to be
     *   of the same unit.  Standard METRIC [m] or ENGLISH [ft] distance
     *   should be used. 
     *
     *   Source Documentation:
     *   [1] http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
     *   [2] http://www.ngs.noaa.gov/TOOLS/Inv_Fwd/Inv_Fwd.html
     *   [3] http://www.movable-type.co.uk/scripts/LatLongVincenty.html
     *
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/822
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */
    
    /* Local Variables */
    double lat1_deg, lon1_deg, lat2_deg, lon2_deg;
    double lat1_rad, lon1_rad, lat2_rad, lon2_rad;
    double L, U1, U2, sinU1, cosU1, sinU2, cosU2, lambda, lambdap;
    int maxCtr, ctr;
    double sinLambda, cosLambda, sinSigma, cosSigma;
    double sig, alpha, cos2alpha, cos2SigmaM, C, CB_b, uSq, AA, BB;
    double deltaSigma;
    double delta_lat_deg, delta_lon_deg;
        
    /* Ensure Lat & Lon are in bounds */
    CheckLatLon(latitude1_deg, longitude1_deg, &lat1_deg, &lon1_deg);
    CheckLatLon(latitude2_deg, longitude2_deg, &lat2_deg, &lon2_deg);
        
    delta_lat_deg = lat2_deg - lat1_deg;
    delta_lon_deg = lon2_deg - lon1_deg;
   
    /* Check Inputs to ensure they aren't on top of each other */
    if((delta_lat_deg == 0.0) && (delta_lon_deg == 0.0))
    {
        *dist = 0.0;
        *azimuth1_deg = 0.0;
        *azimuth2_deg = 0.0;
    }
    else
    {
    /* Convert Input to Radians */
        lat1_rad = lat1_deg * D2R;
        lat2_rad = lat2_deg * D2R;
        lon1_rad = lon1_deg * D2R;
        lon2_rad = lon2_deg * D2R;       
        
        L = lon2_rad - lon1_rad;
        U1 = atan((1-CB_flatten)*tan(lat1_rad));
        U2 = atan((1-CB_flatten)*tan(lat2_rad));
        sinU1 = sin(U1);
        cosU1 = cos(U1);
        sinU2 = sin(U2);
        cosU2 = cos(U2);
        
        /* [Eq 13] */
        lambda  = L;
        lambdap = 2.0*PI;
        
        maxCtr = 20;
        ctr = 0;
        while((fabs(lambda - lambdap) > (1e-12)) && (ctr < maxCtr))
        {
            ctr = ctr + 1;
            sinLambda = sin(lambda);
            cosLambda = cos(lambda);
            
            /* [Eq 14] */
            sinSigma = sqrt( (cosU2*sinLambda)*(cosU2*sinLambda) +
            (cosU1*sinU2 - sinU1*cosU2*cosLambda) * (cosU1*sinU2 - sinU1*cosU2*cosLambda) );
            /* [Eq 15] */
            cosSigma = sinU1*sinU2 + cosU1*cosU2*cosLambda;
            /* [Eq 16] */
            sig = atan2( sinSigma, cosSigma );
            /* [Eq 17] */
            alpha = asin( cosU1*cosU2*sinLambda / sinSigma );
            cos2alpha = cos(alpha)*cos(alpha);
            /* [Eq 18] */
            cos2SigmaM = cosSigma - 2.0*sinU1*sinU2/cos2alpha;
            
            /* [Eq 10] */
            C = (CB_flatten/16.0)*(cos2alpha)*(4.0 + CB_flatten*(4.0-3.0*cos2alpha) );
            lambdap = lambda;
            /* [Eq 11] */
            lambda = L + (1.0-C)*CB_flatten*sin(alpha)*( sig +
            C*sinSigma*( cos2SigmaM + C*cosSigma*(-1.0 + 2.0*cos2SigmaM*cos2SigmaM)));
        }
        
        if(ctr == 0)
        {
            *dist = 0;
            *azimuth1_deg = 0;
        }
        
        CB_b = CB_a*(1.0-CB_flatten);
        uSq = cos2alpha*(CB_a*CB_a - CB_b*CB_b)/(CB_b*CB_b);
        /* [Eq 3] */
        AA = 1.0 + (uSq/16384.0)*( 4096.0 + uSq*(-768.0 + uSq*(320.0-175.0*uSq)));
        /* [Eq 4] */
        BB = (uSq/1024.0)*( 256.0 + uSq*(-128.0 + uSq*(74.0-47.0*uSq)));
        /* [Eq 6] */
        deltaSigma = BB*sinSigma*( cos2SigmaM + (BB/4)*
        ( cosSigma*(-1.0 + 2.0*cos2SigmaM * cos2SigmaM)
        - (BB/6.0)*cos2SigmaM*(-3.0+ 4.0*sinSigma*sinSigma)*(-3.0+4.0*cos2SigmaM * cos2SigmaM)));
        /* [Eq 19] */
        *dist = CB_b*AA*(sig - deltaSigma);
        
        sinLambda = sin(lambda);
        cosLambda = cos(lambda);
        
        /* Bearing from Point 1 to Point 2 [deg] */
        /*  [Eq 20] */
        *azimuth1_deg = atan2( (cosU2*sinLambda), (cosU1*sinU2 - sinU1*cosU2*cosLambda) ) * R2D;
        
        /* Wrap Bearing to be between 0 and 360 deg */
        *azimuth1_deg = fmod(*azimuth1_deg, 360.0);
        
        if(*azimuth1_deg < 0.0)
        {
            *azimuth1_deg = *azimuth1_deg + 360.0;
        }
        
        /* Bearing from Point 2 to Point 1 [deg] */
        /*  [Eq 21] */
        *azimuth2_deg = atan2( (cosU1*sinLambda), (-sinU1*cosU2 + cosU1*sinU2*cosLambda) ) * R2D;
        
        /* Wrap Bearing to be between 0 and 360 deg */
        *azimuth2_deg = fmod(*azimuth2_deg, 360.0);
        
        if(*azimuth2_deg < 0.0)
        {
            *azimuth2_deg = *azimuth2_deg + 360.0;
        }
    }
}

void invvincenty( double latitude1_deg, double longitude1_deg, double azimuth1_deg,
    double dist, double CB_a, double CB_flatten, 
        double *latitude2_deg, double *longitude2_deg, double *azimuth2_deg )
{
    /* 
     * invvincenty:
     *   Inverse Vincenty.  Computes Destination Point given Distance and
     *   Bearing from Starting Origin Point.  This function assumes an Oblate 
     *   Spheroid as the Central Body.
     *
     *   [latitude2_deg, ...
     *      longitude2_deg, ...
     *          azimuth2_deg] = invvincenty( latitude1_deg, ...
     *              longitude1_deg, azimuth1_deg, distance, CB_a, CB_flatten )
     *
     * INPUTS:
     *	Name            Size    Units	Description
     *  latitude1_deg   [1]     [deg]   Geodetic Latitude of Origin (Point # 1)
     *  longitude1_deg  [1]     [deg]   Longitude of Origin (Point # 1)
     *  azimuth1_deg    [1]     [deg]   Initial Bearing from Point # 1 towards
     *                                  Point # 2, (0 degrees is due North, 
     *                                  positive rotation towards East)
     *  dist            [1]     [dist]  Distance to travel along Spheroid from
     *                                  Origin to Destination
     *  a               [1]     [dist]  Central Body Semi-major Axis
     *  f               [1]     [ND]    Central Body Flattening Parameter
     *
     * OUTPUTS:
     *	Name            Size    Units	Description
     *  latitude2_deg   [1]     [deg]   Geodetic Latitude of Destination (Point # 2)
     *  longitude2_deg  [1]     [deg]   Longitude of Destination (Point # 2)
     *  azimuth2_deg    [1]     [deg]   Initial Bearing from Point # 2 towards
     *                                  Point # 1, (0 degrees is due North,
     *                                  positive rotation towards East)
     *
     * NOTES:
     *   This calculation is not unit specific.  Input distances only need to be
     *   of the same unit.  Standard METRIC [m] or ENGLISH [ft] distance
     *   should be used. 
     *
     *   Source Documentation
     *    [1] http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
     *    [2] http://www.ngs.noaa.gov/TOOLS/Inv_Fwd/Inv_Fwd.html
     *
     *   UNDERSTANDING THE FUNCTION
     *   With the inverse vincenty function, users define an intial point, Pt. 1
     *   with a latitude and longitude.  They also define a range and an azimuth
     *   to some point, Pt. 2.  Understand that this azimuth is the azimuth of
     *   point 2 with respect to point 1 (eg. 20 deg).  The invvincenty function
     *   will start at Pt. 1 and 'travel' on an initial azimuth of 20 to compute
     *   the latitude and longitude of Pt. 2.  Once at Pt. 2, the function will
     *   then compute the back azimuth, azimuth2, of Pt. 1 with respect to Pt.
     *   2.  Realize that the curvature of the central body distorts this back
     *   azimuth slightly from 180 deg.
     *
     *   INTERNAL NOTES
     *   Equations below are translated from Fortrann source code from [2].
     *   Internally documented equations are those cross-checked with [1].
     *     
     * VERIFICATION DETAILS:
     * Verified: No
     * Trac Page: http://trac.ngst.northgrum.com/CSA/ticket/823
     *
     * AUTHORS:
     * INI: FullName     : Email                 : NGGN Username
     * MWS: Mike Sufana  : mike.sufana@ngc.com   : sufanmi
     */

    /* Local Variables */
    int maxCtr, ctr;
    double lat1_rad, lon1_rad, lat1_deg, lon1_deg, tanU1, sinFAZ, cosFAZ, BAZ, cosU1, sinU1, sinAlpha;
    double cos2alpha, X, C, D, Sigma, Sigma_minus_C, sinSigma, cosSigma, cos2Sigmam;
    double E, num, den, FAZ;
        
    maxCtr = 100;
    
    /* Convert Input to Radians */
    CheckLatLon(latitude1_deg, longitude1_deg, &lat1_deg, &lon1_deg);
    lat1_rad = lat1_deg * D2R;
    lon1_rad = lon1_deg * D2R;
    FAZ  = azimuth1_deg * D2R;

    /* Translated [2] Fortrann Code */
    /* Commented with Equation Lines from [1] */
    tanU1   = (1.0-CB_flatten) * tan(lat1_rad);  /* Reduced Latitude */
    sinFAZ  = sin(FAZ);             /* Sine of Forward Azimuth */
    cosFAZ  = cos(FAZ);             /* Cosine of Forward Azimuth */

    /* [Eq. 1] */
    BAZ     = 0.0;
    if (cosFAZ != 0.0)
    {
        BAZ = 2.0*atan2(tanU1,cosFAZ);
    }

    cosU1   = 1.0/sqrt(tanU1*tanU1+1.0);
    sinU1   = tanU1*cosU1;
    /* [Eq. 2] */
    sinAlpha=cosU1*sinFAZ;

    cos2alpha     = -sinAlpha*sinAlpha+1.0;
    X = sqrt((1.0/(1.0-CB_flatten)/(1.0-CB_flatten) -1.0)*cos2alpha+1.0)+1.0;
    X=(X-2.0)/X;
    C = 1.0-X;
    C=(X*X/4.0 + 1.0)/C;
    D = (0.375*X*X-1.0)*X;
    tanU1 = dist/(1.0-CB_flatten)/CB_a/C;
    Sigma = tanU1;

    Sigma_minus_C = 1.0;

    while((fabs(Sigma_minus_C) > 1e-12) && (ctr < maxCtr))
    {
        sinSigma = sin(Sigma);
        cosSigma = cos(Sigma);
        cos2Sigmam = cos(BAZ+Sigma);

        /* [Eq. 6] */
        E = cos2Sigmam*cos2Sigmam*2.0 - 1.0;
        C = Sigma;
        X = E*cosSigma;
        /* [Eq. 7] */
        Sigma = E+E-1.0;
        Sigma=(((sinSigma*sinSigma*4.0-3.0)*Sigma*cos2Sigmam*D/6.0+X)*D/4.0-cos2Sigmam)*sinSigma*D+tanU1;
    
        Sigma_minus_C = Sigma - C;
    }

    /* [Eq. 8] */
    num = sinU1*cosSigma+cosU1*sinSigma*cosFAZ;
    BAZ = sinU1*sinSigma - cosU1*cosSigma*cosFAZ;
    den = (1.0-CB_flatten)*sqrt(sinAlpha*sinAlpha+BAZ*BAZ);

    *latitude2_deg = atan2(num,den) * R2D;

    /* [Eq. 9] */
    X = atan2( (sinSigma*sinFAZ), (cosU1*cosSigma-sinU1*sinSigma*cosFAZ));

    /* [Eq. 10] */
    C = (CB_flatten/16.0)*cos2alpha*(4.0 + CB_flatten*(4.0-3.0*cos2alpha));

    /* [Eq. 11] */
    D=((E*cosSigma*C+cos2Sigmam)*sinSigma*C+Sigma)*sinAlpha;
    *longitude2_deg = (lon1_rad + X-(1.0-C)*D*CB_flatten) * R2D;

    /* Wrap Longitude to be within +/- 180 */
    *longitude2_deg = fmod(*longitude2_deg, 360.0);
    if (*longitude2_deg < 0.0)
    {
        *longitude2_deg = *longitude2_deg + 360.0;
    }
    
    if (*longitude2_deg > 180.0)
    {
        *longitude2_deg = *longitude2_deg - 360.0;
    }
    
    /* [Eq. 12] */
    *azimuth2_deg = atan2(sinAlpha,-BAZ)*R2D + 180.0;
    *azimuth2_deg = fmod(*azimuth2_deg, 360.0);
    
    if(*azimuth2_deg < 0.0)
    {
        *azimuth2_deg = *azimuth2_deg + 360.0;
    }
}
