/*
 * Utility functions to process state data from sensors
 *
 */

#include "Utilities.h"

void updatePositionVelCreate(float *xc, float *yc, float *Vxc, float *Vyc, float yaw, float create_distance, float delta_t) {

	//use velocity of left and right wheels to determine velocity in X and Y
	double x_vel = (create_distance/delta_t)*cos(yaw*M_PI/180);
	double y_vel = (create_distance/delta_t)*sin(yaw*M_PI/180);

	double X_new = *xc + (create_distance)*cos(yaw*M_PI/180);
	double Y_new = *yc + (create_distance)*sin(yaw*M_PI/180);

	*xc = X_new;
	*yc = Y_new;
	
	*Vxc = x_vel;
	*Vyc = y_vel;
} 

void Vned2VGammaChi(float *Speed, float *Gamma_deg, float *Chi_deg, float Vn, float Ve, float Vd) {
	// Calculate Speed magnitude, vertical flight path angle and heading from V north, east, down
	*Speed     = sqrt(Vn*Vn + Ve*Ve);
	*Chi_deg   = atan2(Ve, Vn)*180/M_PI; // Heading
	*Gamma_deg = 0; // Vertical Flight Path, Only 2-D motion for now

}
