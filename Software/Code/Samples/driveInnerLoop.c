/** drive.c
 *
 *  A simple program to drive the create using the keyboard.
 *
 *  Author: Nathan Sprague
 *
 *
 *  This file is part of COIL.
 *
 *  COIL is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  COIL is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with COIL.  If not, see <http://www.gnu.org/licenses/>.
 *
 */


#include <createoi.h>
#include <libIMU.h>
#include <stdlib.h>
#include <stdio.h>
#include <curses.h>
#include <math.h>

#define MAX(a,b)        (a > b? a : b)
#define MIN(a,b)        (a < b? a : b)
#define SONG_LENGTH 8


float yaw_err = 0;
float Kp_yaw   = 2;

float delta_t = 0.1; //assuming 5Hz rate for now
double time_stamp = 0;

float accelX = 0;
float accelY = 0;
float accelZ = 0;

float create_velocity = 0;
float create_distance = 0;
float create_angle = 0;

int cycle_count = 0;
float HeadingErr_hist[3];
int closenessPos_mm = 20;
int closenessWayPt_mm = 250;

int WP_count = 0;
int WP_lap_count = 1;
int WP_max_laps = 5;
int WP_go_home = 0;
int WP_final_yaw = 0;
float WPcur_V_Pn_Pe[3];	
float WP1_V_Pn_Pe[3];
float WP2_V_Pn_Pe[3];
float WP3_V_Pn_Pe[3];
float WP4_V_Pn_Pe[3];
float WP5_V_Pn_Pe[3];

float dist_PnPe = 0;
float SpeedCmd = 0;
float WheelSpeedCmd = 0;
float WheelSpeedCmd_hist[2];
float TurnRadiusCmd = 0;
float TurnRadiusCmd_hist[2];
float HeadingCmd_deg = 0;

FILE* fd_main_out = NULL;

/* Plays some random notes on the create's speakers. */
void horn() {
  char song[SONG_LENGTH * 2];
  int i;
  for (i =0; i< SONG_LENGTH; i++) {
    song[i*2] = 31 + floor(drand48() * (127-31));
    song[i*2 +1] = 8 + floor(drand48() * 10);
  }
  writeSong(0, SONG_LENGTH, song);
  playSong (0);
}

int yawCommand(float yaw, int yaw_cmd);

int positionControlMode(float *TurnRadiusCmd, float *HeadingCmd, float Pn_cmd, float Pe_cmd, float Pn, float Pe, float Speed, float Heading_deg);

int waypointControlMode(float *TurnRadiusCmd, float *HeadingCmd, float Pn_cmd, float Pe_cmd, float Pn, float Pe, float Speed, float Heading_deg, float yaw);

void updatePositionVelCreate(float *xc, float *yc, float *Vxc, float *Vyc, float yaw, float delta_t);

void Vned2VGammaChi(float *Speed, float *Gamma_deg, float *Chi_deg, float Vn, float Ve, float Vd);

void PositionCommand(float *SpeedCmd, float *HeadingCmd_deg, float *dist_PnPe, float Pn_cmd, float Pe_cmd, float Pn, float Pe);

void SpeedHeadingCommand(float *WheelSpeedCmd, float *TurnRadiusCmd, float SpeedCmd, float HeadingCmd_deg, float Speed, float Heading_deg, float delta_t, int cycle_count);

int main(int argv, char* argc[])
{
    WINDOW *win;
    int key;
    int not_done = 1;

    int speed = 0;//store user input.
    int turn = 0;

	int yaw_cmd = -1;
	int posCmd_start = 0;
	int waypointCmd_start = 0;
	float roll = 0;
	float pitch = 0;
	float yaw = 0;
	float gyroX = 0;
	float gyroY = 0;
	float gyroZ = 0;

	float Pn_cmd = 0;
	float Pe_cmd = 0;

	float x_create = 0;
	float y_create = 0;
	float Vx_create = 0;
	float Vy_create = 0;

	float Speed = 0;
	float FlightPath_deg = 0;
 	float Heading_deg = 0;

    int charge;

    if (argv < 3) {
      fprintf(stderr, "Usage: drive DEVICE (e.g. /dev/ttyO0 /dev/ttyUSB0)\n");
      exit(1);
    }


    //setup ncurses
    initscr();
    clear();
    noecho();
    cbreak();      
    win = newwin(24, 80, 0, 0);
    keypad(win, TRUE);
    wtimeout(win,100);

    startOI_MT (argc[1]);

	startIMU_File (argc[2], argc[3]);

	fd_main_out = fopen("MainOut_.txt", "w");
       
        while(not_done) {

                erase();
                charge = getCharge();
                create_velocity = readSensor(SENSOR_REQUESTED_VELOCITY);
                create_distance = readSensor(SENSOR_DISTANCE);
                create_angle = readSensor(SENSOR_ANGLE);
                roll = getRoll();
                pitch = getPitch();
                yaw = getYaw();
                time_stamp = getTimeStamp();

                gyroX = getGyroX();
                gyroY = getGyroY();
                gyroZ = getGyroZ();
                accelX = getAccelX();
                accelY = getAccelY();
                accelZ = getAccelZ();
                updatePositionVelCreate(&x_create, &y_create, &Vx_create, &Vy_create, yaw, delta_t);
                Vned2VGammaChi(&Speed, &FlightPath_deg, &Heading_deg, Vx_create, Vy_create, 0);
                mvwprintw(win, 0, 0, "Use arrow keys to steer.");
                mvwprintw(win, 1, 0, "'h' for horn.");
                mvwprintw(win, 2, 0, "'q' to quit.");
                mvwprintw(win, 3, 0, "'n' turn to 90 deg hdg.");
                mvwprintw(win, 4, 0, "'p' to engage position command (hard coded: Pn= %.2f, Pe= %.2f [mm]).", Pn_cmd, Pe_cmd);
                mvwprintw(win, 5, 0, "'w' to engage waypoint commands (hard coded waypoints).");
                
                mvwprintw(win, 7, 0, "Battery Charge: %d%%", charge);
                mvwprintw(win, 8, 0, "Accel: X %.2f, Y %.2f, Z %.2f", accelX, accelY, accelZ);
                mvwprintw(win, 9, 0, "Gyro : X %.2f, Y %.2f, Z %.2f", gyroX, gyroY, gyroZ);
                mvwprintw(win, 10, 0, "Euler: Roll %.2f, Pitch %.2f, Yaw %.2f", roll, pitch, yaw);
                
                mvwprintw(win, 12, 0, "Create Deltas  : Vel %.2f, Distance %.2f, Angle %.2f", create_velocity, create_distance, create_angle);
                mvwprintw(win, 13, 0, "Create Position: Pn %.2f, Pe %.2f", x_create, y_create);
                mvwprintw(win, 14, 0, "Create Velocity: Vn %.2f, Ve %.2f", Vx_create, Vy_create);
                
                mvwprintw(win, 16, 0, "Speed      : Cmd %.2f, Actual %.2f", SpeedCmd, Speed);
                mvwprintw(win, 17, 0, "Heading    : Cmd %.2f, Actual %.2f", HeadingCmd_deg,  Heading_deg);
                mvwprintw(win, 18, 0, "Flight Path: Cmd 0, Actual %.2f", FlightPath_deg);
                mvwprintw(win, 19, 0, "Yaw: Cmd %.2f, Actual %.2f", yaw_cmd, yaw);
                mvwprintw(win, 20, 0, "Drive Cmds: WheelSpeedCmd %.2f, TurnRadiusCmd %.2f", WheelSpeedCmd, TurnRadiusCmd);
                mvwprintw(win, 21, 0, "WP info : WP# %d Lap# %d",  WP_count, WP_lap_count);	
                refresh();

                key = wgetch(win);
  
                switch(key){
                case KEY_UP:
                        if (speed < 0) {
                                speed = 0;
                                turn = 0;
                        } else {
                                speed += 50;
                        }
                        break;
                case KEY_DOWN:
                        if (speed > 0) {
                                speed = 0;
                                turn = 0;
                        } else {
                                speed -= 50;
                        }
                        break;
                case KEY_LEFT:
                        turn =  MAX(turn + 1, 0);
                        break;
                case KEY_RIGHT:
                        turn =  MIN(turn - 1, 0);
                        break;
                case 'h':
                        horn();
                        break;
		case 'n':
			yaw_cmd = 90;
			break;
		case 'p':
			cycle_count = 0;
			posCmd_start = 1;
			Pn_cmd = -2000;
			Pe_cmd = 0;
			break;
		case 'w':
			cycle_count = 0;
			waypointCmd_start = 1;
			break;
        case 'q':
                        not_done = 0;
			fclose(fd_main_out);
			break;
                }
               

		if(yaw_cmd!=-1) {
			yaw_cmd = yawCommand(yaw, yaw_cmd);
            
		} else if(posCmd_start!=0) {
			posCmd_start = positionControlMode(&TurnRadiusCmd, &HeadingCmd_deg, Pn_cmd,Pe_cmd, x_create, y_create, Speed, Heading_deg);
            
		} else if(waypointCmd_start!=0) {
			waypointCmd_start = waypointControlMode(&TurnRadiusCmd, &HeadingCmd_deg, Pn_cmd,Pe_cmd, x_create, y_create, Speed, Heading_deg, yaw);
            
		} else {

                	if (speed != 0){
                        	WheelSpeedCmd = speed;
                        	if (turn != 0)
                                	TurnRadiusCmd = (abs(turn) / turn) *
                                        	MAX(1000 /pow(2,abs(turn)), 1);
                        	else
                                	TurnRadiusCmd = 0;
                	} else if (turn != 0) { /* turn in place*/
                        	WheelSpeedCmd = abs(turn) * 50;
                        	if (turn > 0)
                                	TurnRadiusCmd = 1;
                        	if (turn < 0)
                                	TurnRadiusCmd = -1;
                	} else {
                        	WheelSpeedCmd = 0;
                        	TurnRadiusCmd = 0;
                	}
			drive(WheelSpeedCmd,TurnRadiusCmd);
		}
               
                //write file
		if (not_done!= 0) {
			fprintf(fd_main_out,"%.4f,%.2f,%.2f,%.2f,%.3f,%.3f,%.3f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%d,%.2f,%.2f,%.2f,%.2f,%.2f\n", time_stamp, gyroX, gyroY, gyroZ, accelX, accelY, accelZ, roll, pitch, yaw, x_create, y_create, Vx_create, Vy_create, Heading_deg, WP_count, SpeedCmd, HeadingCmd_deg, dist_PnPe, TurnRadiusCmd, WheelSpeedCmd);
		}
               
               
        }


        clrtoeol();
        refresh();
        endwin();
        stopOI_MT();
	stopIMU_MT();
}

int yawCommand(float yaw, int yaw_cmd) {
	yaw_err = yaw_cmd - yaw;

    SpeedCmd = -Kp_yaw*yaw_err;
    WheelSpeedCmd = SpeedCmd;
    TurnRadiusCmd = 1;

    if(SpeedCmd < 0) {
        WheelSpeedCmd = -1*SpeedCmd;
        TurnRadiusCmd = -1;	
    }

    if (WheelSpeedCmd > 100)  {
        WheelSpeedCmd = 100;
    }
    
	if (abs(yaw_err) < 0.5 )  {
		WheelSpeedCmd = 0;
		TurnRadiusCmd  = 0;
		yaw_cmd = -1; 
	}
	
	drive(WheelSpeedCmd,TurnRadiusCmd);
	return yaw_cmd;
}

int positionControlMode(float *TurnRadiusCmd_out, float *HeadingCmd_deg_out, float Pn_cmd,float Pe_cmd, float Pn,float Pe, float Speed, float Heading_deg){

	int posCmd_start = 1; 

	cycle_count = cycle_count + 1;

	if (cycle_count >= 3) {
		cycle_count = 3;
	}

	PositionCommand(&SpeedCmd, &HeadingCmd_deg, &dist_PnPe, Pn_cmd, Pe_cmd, Pn, Pe);
	
	//SpeedCmd        = 500;
	//HeadingCmd_deg  = 0;

	SpeedHeadingCommand(&WheelSpeedCmd, &TurnRadiusCmd, SpeedCmd, HeadingCmd_deg, Speed, Heading_deg, delta_t, cycle_count);
	
	if (dist_PnPe < closenessWayPt_mm )  {
		SpeedCmd = 0;
		TurnRadiusCmd  = 0;
		posCmd_start = 0; 
	}
	
	drive(WheelSpeedCmd,TurnRadiusCmd);
	
	*HeadingCmd_deg_out = HeadingCmd_deg;
	*TurnRadiusCmd_out = TurnRadiusCmd;

	return posCmd_start;
}

int waypointControlMode(float *TurnRadiusCmd_out, float *HeadingCmd_deg_out, float Pn_cmd,float Pe_cmd, float Pn,float Pe, float Speed, float Heading_deg, float yaw){
	//init
	int waypointCmd_start = 1; 

	//Waypoint definition
	// Waypoint      V                     Pn                      Pe
	// /*
	WP1_V_Pn_Pe[0] = 450; WP1_V_Pn_Pe[1] = -2000; WP1_V_Pn_Pe[2] = -2000;
	WP2_V_Pn_Pe[0] = 450; WP2_V_Pn_Pe[1] =  2000; WP2_V_Pn_Pe[2] = -2000;
	WP3_V_Pn_Pe[0] = 450; WP3_V_Pn_Pe[1] =  2000; WP3_V_Pn_Pe[2] =  2000;
	WP4_V_Pn_Pe[0] = 450; WP4_V_Pn_Pe[1] = -2000; WP4_V_Pn_Pe[2] =  2000;
	// */

	 /*
	WP1_V_Pn_Pe[0] = 450; WP1_V_Pn_Pe[1] =  1000; WP1_V_Pn_Pe[2] =  1000;
	WP2_V_Pn_Pe[0] = 450; WP2_V_Pn_Pe[1] =  5000; WP2_V_Pn_Pe[2] =  1000;
	WP3_V_Pn_Pe[0] = 450; WP3_V_Pn_Pe[1] =  5000; WP3_V_Pn_Pe[2] =  5000;
	WP4_V_Pn_Pe[0] = 450; WP4_V_Pn_Pe[1] =  1000; WP4_V_Pn_Pe[2] =  5000;
	 */

	 /*
	WP1_V_Pn_Pe[0] = 450; WP1_V_Pn_Pe[1] =  3500; WP1_V_Pn_Pe[2] = -1000;
	WP2_V_Pn_Pe[0] = 450; WP2_V_Pn_Pe[1] =  2000; WP2_V_Pn_Pe[2] =  2000;
	WP3_V_Pn_Pe[0] = 450; WP3_V_Pn_Pe[1] = -1000; WP3_V_Pn_Pe[2] =     0;
	WP4_V_Pn_Pe[0] = 450; WP4_V_Pn_Pe[1] = -3500; WP4_V_Pn_Pe[2] =  3000;
	 */

	if ((WP_count == 0)&&(WP_go_home!=1))  {
		WP_count = WP_count + 1;
		WPcur_V_Pn_Pe[0] = WP1_V_Pn_Pe[0];
		WPcur_V_Pn_Pe[1] = WP1_V_Pn_Pe[1];
		WPcur_V_Pn_Pe[2] = WP1_V_Pn_Pe[2];
	}
	
	// PID cycle count
	cycle_count = cycle_count + 1;

	if (cycle_count >= 3) {
		cycle_count = 3;
	}

	// Position control
	PositionCommand(&SpeedCmd, &HeadingCmd_deg, &dist_PnPe, WPcur_V_Pn_Pe[1], WPcur_V_Pn_Pe[2], Pn, Pe);
	
	if (WP_go_home!=1) {
		SpeedCmd = WPcur_V_Pn_Pe[0];
	}

	//SpeedCmd        = 300;
	//HeadingCmd_deg  = 45;

	// Speed, Heading control
	SpeedHeadingCommand(&WheelSpeedCmd, &TurnRadiusCmd, SpeedCmd, HeadingCmd_deg, Speed, Heading_deg, delta_t, cycle_count);
	
	//Waypoint cycle
	if (dist_PnPe < closenessWayPt_mm)  {
		WP_count = WP_count + 1;

		HeadingErr_hist[0] = 0; HeadingErr_hist[1] = 0; HeadingErr_hist[2] = 0;
		TurnRadiusCmd_hist[0] = 0; TurnRadiusCmd_hist[1] = 0;

		
	}

	if (WP_go_home==1) {
		WP_go_home = 1;
		WP_lap_count = 0;
		WP_count = 0;
		WPcur_V_Pn_Pe[0] = SpeedCmd;
		WPcur_V_Pn_Pe[1] = 0;
		WPcur_V_Pn_Pe[2] = 0;

		if ((dist_PnPe < closenessPos_mm)||(WP_final_yaw ==1)) {
			WP_final_yaw =1;
			// At Home Position, correct yaw angle
			yaw_err = 0 - yaw;
			SpeedCmd = -Kp_yaw*yaw_err;
			WheelSpeedCmd = SpeedCmd;
			TurnRadiusCmd = 1;

			if(SpeedCmd < 0) {
				WheelSpeedCmd = -1*SpeedCmd;
				TurnRadiusCmd = -1;	
			}

			if (WheelSpeedCmd > 100)  {
				WheelSpeedCmd = 100;
			}

			if (abs(yaw_err) < 0.5 )  {
				WheelSpeedCmd = 0;
				TurnRadiusCmd = 0;

				SpeedCmd = 0;
				TurnRadiusCmd = 0;
				WheelSpeedCmd = 0;
				waypointCmd_start = 0;	
				WP_go_home = 0;
				WP_lap_count = 0;
				WP_count = 0;
				WP_final_yaw =0;
			}		
		}

	} else if (WP_count == 1)  {
		WPcur_V_Pn_Pe[0] = WP1_V_Pn_Pe[0];
		WPcur_V_Pn_Pe[1] = WP1_V_Pn_Pe[1];
		WPcur_V_Pn_Pe[2] = WP1_V_Pn_Pe[2];
	} else if (WP_count == 2)  {
		WPcur_V_Pn_Pe[0] = WP2_V_Pn_Pe[0];
		WPcur_V_Pn_Pe[1] = WP2_V_Pn_Pe[1];
		WPcur_V_Pn_Pe[2] = WP2_V_Pn_Pe[2];
	} else if (WP_count == 3)  {
		WPcur_V_Pn_Pe[0] = WP3_V_Pn_Pe[0];
		WPcur_V_Pn_Pe[1] = WP3_V_Pn_Pe[1];
		WPcur_V_Pn_Pe[2] = WP3_V_Pn_Pe[2];
	} else if (WP_count == 4)  {
		WPcur_V_Pn_Pe[0] = WP4_V_Pn_Pe[0];
		WPcur_V_Pn_Pe[1] = WP4_V_Pn_Pe[1];
		WPcur_V_Pn_Pe[2] = WP4_V_Pn_Pe[2];

	} else {

		if (WP_lap_count < WP_max_laps) {
			// Loop Waypoints
			WP_lap_count = WP_lap_count + 1;
			WP_count = 1;
			WPcur_V_Pn_Pe[0] = WP1_V_Pn_Pe[0];
			WPcur_V_Pn_Pe[1] = WP1_V_Pn_Pe[1];
			WPcur_V_Pn_Pe[2] = WP1_V_Pn_Pe[2];

		} else {
			// Stop Waypoints
			WP_go_home = 1;
			WP_lap_count = 0;
			WP_count = 0;
			WPcur_V_Pn_Pe[0] = 0;
			WPcur_V_Pn_Pe[1] = 0;
			WPcur_V_Pn_Pe[2] = 0;
		}
	}

	drive(WheelSpeedCmd,TurnRadiusCmd);
	
	*HeadingCmd_deg_out = HeadingCmd_deg;
	*TurnRadiusCmd_out = TurnRadiusCmd;

	return waypointCmd_start;
}

void updatePositionVelCreate(float *xc, float *yc, float *Vxc, float *Vyc, float yaw, float delta_t) {

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

void PositionCommand(float *SpeedCmd, float *HeadingCmd_deg, float *dist_PnPe, float Pn_cmd, float Pe_cmd, float Pn, float Pe) {
	// Calculate Speed and Heading Command from Position commands (Pn, Pe)
	float diff_Pn = 0;
	float diff_Pe = 0;

	diff_Pn = Pn_cmd - Pn;
	diff_Pe = Pe_cmd - Pe;

	*dist_PnPe = sqrt(diff_Pn*diff_Pn + diff_Pe*diff_Pe);
	*SpeedCmd   = 0.2 * *dist_PnPe;

	*HeadingCmd_deg = atan2(diff_Pe, diff_Pn)*180/M_PI;

}

void SpeedHeadingCommand(float *WheelSpeedCmd, float *TurnRadiusCmd, float SpeedCmd, float HeadingCmd_deg, float Speed, float Heading_deg, float delta_t, int cycle_count) {

	// Calculate wheel speed and turn radius from Speed and Heading commands
	float HeadingErr   = 0;
	float CorrectedErr = 0;
	float k_heading    = 10000;
	float Ti_heading   = 10000000;
	float Ti_INUSE   = 0;
	float Td_heading   = 0.05;

	// Calc Heading Error, ensure correct/closest direction
	HeadingErr = atan2(sin((HeadingCmd_deg-Heading_deg)*M_PI/180), cos((HeadingCmd_deg-Heading_deg)*M_PI/180) ) * 180/M_PI;
	// Correct error, turn radius is in the opposite sign and inversely related to the Heading error
	CorrectedErr = -1/HeadingErr;
    
	if (cycle_count <=1) {
		HeadingErr_hist[0]  = 0;
		HeadingErr_hist[1]  = 0;
		HeadingErr_hist[2]  = 0;
        //Turn Radius Cmd
		TurnRadiusCmd_hist[0] = 0;
		TurnRadiusCmd_hist[1] = 0;
        // Wheel Speed Cmd
		WheelSpeedCmd_hist[1] = 0;
        WheelSpeedCmd_hist[0] = 0.1*(SpeedCmd-Speed)+WheelSpeedCmd_hist[1]; 	
	}
	else if (cycle_count == 2) {
		HeadingErr_hist[0]  = 0;
        //Turn Radius Cmd
		TurnRadiusCmd_hist[0] = 0;
		TurnRadiusCmd_hist[1] = 0;
        // Wheel Speed Cmd
        WheelSpeedCmd_hist[0] = 0.1*(SpeedCmd-Speed)+WheelSpeedCmd_hist[1]; 
	}
	else if (cycle_count >= 3) {
		HeadingErr_hist[0] = CorrectedErr;
        //Turn Radius Cmd
		TurnRadiusCmd_hist[0]    = TurnRadiusCmd_hist[1] 
		+ k_heading*((1 + (delta_t/Ti_heading)*Ti_INUSE + (Td_heading/delta_t)) * HeadingErr_hist[0] 
		- (1 + 2 * (Td_heading/delta_t)) * HeadingErr_hist[1]
		+ (Td_heading/delta_t) * HeadingErr_hist[2]);
        // Wheel Speed Cmd
        WheelSpeedCmd_hist[0] = 0.1*(SpeedCmd-Speed)+WheelSpeedCmd_hist[1]; 
	}
	
	if ((TurnRadiusCmd_hist[0] < 1) && (TurnRadiusCmd_hist[0] > 0))  {
		TurnRadiusCmd_hist[0] = 1;
	}

	if ((TurnRadiusCmd_hist[0] > -1) && (TurnRadiusCmd_hist[0] < 0))  {
		TurnRadiusCmd_hist[0] = -1;
	}
	 
	if (*WheelSpeedCmd < 200)  {
		*WheelSpeedCmd = 200;
	} 

    *WheelSpeedCmd = WheelSpeedCmd_hist[0];
	*TurnRadiusCmd = TurnRadiusCmd_hist[0];
	
	HeadingErr_hist[2] = HeadingErr_hist[1];
	HeadingErr_hist[1] = HeadingErr_hist[0];

	TurnRadiusCmd_hist[1] = TurnRadiusCmd_hist[0];
    WheelSpeedCmd_hist[1] = WheelSpeedCmd_hist[0];

}
