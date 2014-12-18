/*
 * Utility functions to process state data from sensors
 *
 */

 #ifndef UTILITIES_H
 #define UTILITIES_H

#include <createoi.h>
#include <libIMU.h>
#include <stdlib.h>
#include <stdio.h>
#include <curses.h>
#include <math.h>

void updatePositionVelCreate(float *xc, float *yc, float *Vxc, float *Vyc, float yaw, float create_distance, float delta_t);

void Vned2VGammaChi(float *Speed, float *Gamma_deg, float *Chi_deg, float Vn, float Ve, float Vd);

#endif
