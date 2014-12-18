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
 * Copyright Northrop Grumman Corp 2011
 * Maintained by: GN&C Technology (Dept 9V21): Aerospace Systems - Redondo Beach, CA
 * http://vodka.ccc.northgrum.com/trac/CSA/
 *
 * Subversion Revision Information At Last Commit
 * $URL: https://svn.ngst.northgrum.com/repos/CSA/trunk/CSA/CCode/CSA_LIB.h $
 * $Rev: 3089 $
 * $Date: 2014-03-06 16:18:21 -0600 (Thu, 06 Mar 2014) $
 * $Author: sufanmi $
 *
 */

/* Constants */
#define PI  acos(-1)
#define D2R PI/180.0
#define R2D 180.0/PI

/* Conversions */
#define M2MM 1000.0
#define MM2M 0.001
#define MN2SEC 60.0
#define HR2MN 60.0

/* Macros */
#ifndef max
  #define max(x, y)  (((x) < (y)) ? (y) : (x))
#endif

#ifndef min
  #define min(x, y)  (((x) < (y)) ? (x) : (y))
#endif

#ifndef WITHINLIMITS
  #define WITHINLIMITS(x, xmin, xmax) ( (x >= xmin) & (x <= xmax) )
#endif
  
/* =====================================================================
 *							FUNCTION DECLARATIONS
 * ===================================================================== */

/* Basic Math Utilities */
extern double sign( double val );

/* Angle Wrapping */
extern double wrap180( double IN );
extern void CheckLatLon( double Lat0_deg, double Lon0_deg, double *Lat_deg, double *Lon_deg);

/* Vector Utilities */
extern double norm(double vec[3]);
extern void crossv(double vecA[3], double vecB[3], double vecC[3]);

/* Matrix Utilities */
extern void matmult(double matA2B[3][3], double matB2C[3][3], double matA2C[3][3]);
extern void matvecmult(double matA2B[3][3], double vecA[3], double vecB[3]);
extern void transpose( double matIN[3][3], double matTRANS[3][3] );

/* Quaternion / Euler / DCM Conversions */
extern void eul2dcm(double eul_rad[3], double dcm[3][3]);
extern void dcm2eul(double dcm[3][3], double eul_rad[3]);

/* Coordinate Transformations */
extern void TranslateOffsets(double P_i[3], double V_i[3], 
        double Euler_i_rad[3], double PQRb_rps[3], double Pt_P_b_rel[3], 
        double Pt_Euler_b_rel_rad[3], double Pt_P_i[3], double Pt_V_i[3], 
        double Pt_Euler_i_rad[3], double Pt_PQRb_rps[3], double Pt_P_i_rel[3]);

/* Linear Interpolation */
extern void Interp1D(double *DataX1, double *DataY1, double *xDes, double *yDes, unsigned int nPts);
  
/* minall and maxall */
extern void maxall(double *u, double *umax, unsigned int m, unsigned int n);
extern void minall(double *u, double *umin, unsigned int m, unsigned int n);
  
/* Crank Actuator Mapping: Theta <--> X */
extern void CrankActuatorMapping_XToTheta(double X, double R, double C, double L2, double ThetaBias_deg, double XBias, double *Theta_deg);
extern void CrankActuatorMapping_ThetaToX(double Theta_deg, double R, double C, double L2, double ThetaBias_deg, double XBias, double *X);

/* Navigation */
extern void vincenty( double latitude1_deg, double longitude1_deg, double latitude2_deg, double longitude2_deg,
    double CB_a, double CB_flatten, double *dist, double *azimuth1_deg, double *azimuth2_deg);
extern void invvincenty( double latitude1_deg, double longitude1_deg, double azimuth1_deg,
    double dist, double CB_a, double CB_flatten, 
        double *latitude2_deg, double *longitude2_deg, double *azimuth2_deg );

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