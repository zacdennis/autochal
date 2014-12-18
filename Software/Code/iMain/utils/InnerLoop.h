/*
 * Functions to set up the inner loop control of the vehicles
 *
 */

 #ifndef INNER_LOOP_H
 #define INNER_LOOP_H

#include <createoi.h>
#include <libIMU.h>
#include <stdlib.h>
#include <stdio.h>
#include <curses.h>
#include <math.h>

float SpeedCmd;
float WheelSpeedCmd;
float TurnRadiusCmd;

float HeadingCmd_deg;
float HeadingErr_hist[3];
float WheelSpeedCmd_hist[2];
float TurnRadiusCmd_hist[2];

float dist_PnPe;

void yawCommand(float yaw, float yaw_cmd);

void PositionCommand(float Pn_cmd, float Pe_cmd, float Pn, float Pe);

void SpeedHeadingCommand(float SpeedCmd, float HeadingCmd_deg, float Speed, float Heading_deg, float delta_t, int cycle_count);

#endif
