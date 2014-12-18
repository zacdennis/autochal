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
float speed_cmd = 0;
float speed_mag = 0;
float turn_radius = 1;
float Kp_yaw   = 2;

float delta_t = 0.1; //assuming 5Hz rate for now
double sample_rate = 0.1;

float velX = 0;
float velY = 0;
float velX_new = 0;
float velY_new = 0;
float posX_new = 0;
float posY_new = 0;

float accelX = 0;
float accelY = 0;

float create_velocity = 0;
float create_distance = 0;
float create_angle = 0;
float psi_new = 0;


double time_stamp_hist[2];
int cycle_count = 0;
float TurnRadiusCmd_hist[2];
float HeadingCmd_hist[4];
float HeadingErr_hist[3];
int closenessPos_mm = 20;
int closenessWayPt_mm = 250;

int WP_count = 0;
int WP_lap_count = 1;
int WP_max_laps = 3;
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

int headingControl(float yaw, int heading);

int positionControlMode(float *TurnRadiusCmd, float *HeadingCmd, float Pn_cmd, float Pe_cmd, float Pn, float Pe, float Speed, float Heading_deg);

int waypointControlMode(float *TurnRadiusCmd, float *HeadingCmd, float Pn_cmd, float Pe_cmd, float Pn, float Pe, float Speed, float Heading_deg, float yaw);

void updatePosition(float *x, float *y);

void updatePositionVelCreate(float *xc, float *yc, float *Vxc, float *Vyc);

void Vned2VGammaChi(float *Speed, float *Gamma_deg, float *Chi_deg, float Vn, float Ve, float Vd);

void PositionCommand(float *SpeedCmd, float *HeadingCmd_deg, float *dist_PnPe, float Pn_cmd, float Pe_cmd, float Pn, float Pe);

void SpeedHeadingCommand(float *WheelSpeedCmd, float *TurnRadiusCmd, float SpeedCmd, float HeadingCmd_deg, float dist_PnPe, float Speed, float Heading_deg, float sample_rate, int cycle_count);

int main(int argv, char* argc[])
{
        WINDOW *win;
        int key;
        int not_done = 1;


        int speed = 0;//store user input.
        int turn = 0;
       
        int velocity = 0; //values sent to the create
        int radius = 0;
	int heading_cmd = -1;
	int posCmd_start = 0;
	int waypointCmd_start = 0;
	float roll = 0;
	float pitch = 0;
	float yaw = 0;
	float gyroX = 0;
	float gyroY = 0;
	float gyroZ = 0;
	//float accelX = 0;
	//float accelY = 0;
	float accelZ = 0;

	float x_pos = 0;
	float y_pos = 0;

	float Pn_cmd = 0;
	float Pe_cmd = 0;


	float x_create = 0;
	float y_create = 0;
	float Vx_create = 0;
	float Vy_create = 0;

	float Speed = 0;
	float FlightPath_deg = 0;
 	float Heading_deg = 0;
	
	float TurnRadiusCmd = 0;
	float HeadingCmd_deg = 0;

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
		//if (abs(create_angle) > 0) {
			yaw = getYaw();
		//}
		gyroX = getGyroX();
		gyroY = getGyroY();
		gyroZ = getGyroZ();
		accelX = getAccelX();
		accelY = getAccelY();
		accelZ = getAccelZ();
		updatePosition(&x_pos,&y_pos);
		updatePositionVelCreate(&x_create, &y_create, &Vx_create, &Vy_create);
		Vned2VGammaChi(&Speed, &FlightPath_deg, &Heading_deg, Vx_create, Vy_create, 0);
                mvwprintw(win, 0, 0, "Use arrow keys to steer.");
                mvwprintw(win, 1, 0, "'h' for horn.");
                mvwprintw(win, 2, 0, "'q' to quit.");
		mvwprintw(win, 3, 0, "'n' turn to 90 deg hdg.");
		mvwprintw(win, 4, 0, "'p' to engage position command (hard coded: Pn= %.2f, Pe= %.2f [mm]).", Pn_cmd, Pe_cmd);
		mvwprintw(win, 5, 0, "'w' to engage waypoint commands (hard coded waypoints).");
                mvwprintw(win, 7, 0, "Battery Charge: %d%%", charge);
                mvwprintw(win, 8, 0, "%d %d", velocity, radius);
		mvwprintw(win, 9, 0, "Position: %.2f %.2f", x_pos, y_pos);
		mvwprintw(win, 10, 0, "RLL: %.2f PCH: %.2f  YAW: %.2f", roll, pitch, yaw);
                mvwprintw(win, 11, 0, "Gyro:  %.2f %.2f %.2f", gyroX, gyroY, gyroZ);
		mvwprintw(win, 12, 0, "Accel: %.2f %.2f %.2f", accelX, accelY, accelZ);
		mvwprintw(win, 13, 0, "Vel: %.2f %.2f %.2f %.2f", velX, velY, velX_new, velY_new);
		mvwprintw(win, 15, 0, "Create Pos: %.2f %.2f %.2f", x_create, y_create, psi_new);
		mvwprintw(win, 16, 0, "Create Vel: %.2f %.2f", Vx_create, Vy_create);
		mvwprintw(win, 17, 0, "Create Velocity: %.2f %.2f %.2f", create_velocity, create_distance, create_angle);
		mvwprintw(win, 18, 0, "Speed, Heading, Flight Path: %.2f %.2f %.2f", Speed, Heading_deg, FlightPath_deg);
		mvwprintw(win, 19, 0, "TurnRad, HeadingCmd: %.2f %.2f", TurnRadiusCmd, HeadingCmd_deg);
		mvwprintw(win, 20, 0, "sample rate    : %.4f  ",  sample_rate);	
		mvwprintw(win, 21, 0, "time_stamp_hist[0] : %.4f  ",  time_stamp_hist[0]);	
		mvwprintw(win, 22, 0, "time_stamp_hist[1] : %.4f  ",  time_stamp_hist[1]);	
		mvwprintw(win, 23, 0, "WP_count : %d  ",  WP_count);	
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
			heading_cmd = 90;
			break;
		case 'p':
			cycle_count = 0;
			time_stamp_hist[0] = 0;
			time_stamp_hist[1] = 0;
			posCmd_start = 1;
			Pn_cmd = 2000;
			Pe_cmd = 0;
			break;
		case 'w':
			cycle_count = 0;
			time_stamp_hist[0] = 0;
			time_stamp_hist[1] = 0;
			waypointCmd_start = 1;
			Pn_cmd = 2500;
			Pe_cmd = -1500;
			break;
                case 'q':
                        not_done = 0;
			fclose(fd_main_out);
			break;
                }
               

		if(heading_cmd!=-1) {
			heading_cmd = headingControl(yaw, heading_cmd);
		} else if(posCmd_start!=0) {
			
			posCmd_start = positionControlMode(&TurnRadiusCmd, &HeadingCmd_deg, Pn_cmd,Pe_cmd, x_create, y_create, Speed, Heading_deg);
		} else if(waypointCmd_start!=0) {
			
			waypointCmd_start = waypointControlMode(&TurnRadiusCmd, &HeadingCmd_deg, Pn_cmd,Pe_cmd, x_create, y_create, Speed, Heading_deg, yaw);
		} else {

                	if (speed != 0){
                        	velocity = speed;
                        	if (turn != 0)
                                	radius = (abs(turn) / turn) *
                                        	MAX(1000 /pow(2,abs(turn)), 1);
                        	else
                                	radius = 0;
                	} else if (turn != 0) { /* turn in place*/
                        	velocity = abs(turn) * 50;
                        	if (turn > 0)
                                	radius = 1;
                        	if (turn < 0)
                                	radius = -1;
                	} else {
                        	velocity = 0;
                        	radius = 0;
                	}
			drive(velocity,radius);
		}
               
                //write file
		if (not_done!= 0) {
			fprintf(fd_main_out,"%.4f,%.2f,%.2f,%.2f,%.3f,%.3f,%.3f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%d,%.2f,%.2f,%.2f,%.2f,%.2f\n", time_stamp_hist[0], gyroX, gyroY, gyroZ, accelX, accelY, accelZ, roll, pitch, yaw, x_create, y_create, Vx_create, Vy_create, Heading_deg, WP_count, SpeedCmd, HeadingCmd_deg, dist_PnPe, TurnRadiusCmd, WheelSpeedCmd);
		}
               
               
        }


        clrtoeol();
        refresh();
        endwin();
        stopOI_MT();
	stopIMU_MT();
}

int headingControl(float yaw, int heading) {
	yaw_err = heading - yaw;

	//printf("Count    : %.0f\n", yaw_count);
	printf("Yaw      : %.2f\n", yaw);
	printf("Yaw Error: %.2f\n\n", yaw_err);

	speed_cmd = -Kp_yaw*yaw_err;
		
	speed_mag = speed_cmd;
	turn_radius  = 1;

	if(speed_cmd < 0) {
		speed_mag = -1*speed_cmd;
		turn_radius  = -1;	
	}

		
	if (speed_mag > 100)  {
		speed_mag = 100;
	}

	if (abs(yaw_err) < 0.5 )  {
		speed_mag = 0;
		turn_radius  = 0;
		heading = -1; 
	}
	
	drive(speed_mag,turn_radius);
	return heading;
}

int positionControlMode(float *TurnRadiusCmd_out, float *HeadingCmd_deg_out, float Pn_cmd,float Pe_cmd, float Pn,float Pe, float Speed, float Heading_deg){

	float HeadingCmd_deg = 0;
	float TurnRadiusCmd = 0;
	
	int posCmd_start = 1; 

	sample_rate = (time_stamp_hist[0] - time_stamp_hist[1]);

	if (sample_rate <= 0) {
		sample_rate = 0.1;
	}
	sample_rate = 0.1;
	cycle_count = cycle_count + 1;

	if (cycle_count >= 3) {
		cycle_count = 3;
	}

	PositionCommand(&SpeedCmd, &HeadingCmd_deg, &dist_PnPe, Pn_cmd, Pe_cmd, Pn, Pe);
	
	SpeedCmd        = 500;
	HeadingCmd_deg  = 0;

	SpeedHeadingCommand(&WheelSpeedCmd, &TurnRadiusCmd, SpeedCmd, HeadingCmd_deg, dist_PnPe, Speed, Heading_deg, sample_rate, cycle_count);
	
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
	float HeadingCmd_deg = 0;
	float TurnRadiusCmd = 0;
	int waypointCmd_start = 1; 

	//Waypoint definition
	// Waypoint      V                     Pn                      Pe
	// /*
	WP1_V_Pn_Pe[0] = 300; WP1_V_Pn_Pe[1] = -2000; WP1_V_Pn_Pe[2] = -2000;
	WP2_V_Pn_Pe[0] = 300; WP2_V_Pn_Pe[1] =  2000; WP2_V_Pn_Pe[2] = -2000;
	WP3_V_Pn_Pe[0] = 300; WP3_V_Pn_Pe[1] =  2000; WP3_V_Pn_Pe[2] =  2000;
	WP4_V_Pn_Pe[0] = 300; WP4_V_Pn_Pe[1] = -2000; WP4_V_Pn_Pe[2] =  2000;
	// */

	 /*
	WP1_V_Pn_Pe[0] = 300; WP1_V_Pn_Pe[1] =  1000; WP1_V_Pn_Pe[2] =  1000;
	WP2_V_Pn_Pe[0] = 300; WP2_V_Pn_Pe[1] =  5000; WP2_V_Pn_Pe[2] =  1000;
	WP3_V_Pn_Pe[0] = 300; WP3_V_Pn_Pe[1] =  5000; WP3_V_Pn_Pe[2] =  5000;
	WP4_V_Pn_Pe[0] = 300; WP4_V_Pn_Pe[1] =  1000; WP4_V_Pn_Pe[2] =  5000;
	 */

	 /*
	WP1_V_Pn_Pe[0] = 300; WP1_V_Pn_Pe[1] =  3500; WP1_V_Pn_Pe[2] = -1000;
	WP2_V_Pn_Pe[0] = 300; WP2_V_Pn_Pe[1] =  2000; WP2_V_Pn_Pe[2] =  2000;
	WP3_V_Pn_Pe[0] = 300; WP3_V_Pn_Pe[1] = -1000; WP3_V_Pn_Pe[2] =     0;
	WP4_V_Pn_Pe[0] = 300; WP4_V_Pn_Pe[1] = -3500; WP4_V_Pn_Pe[2] =  3000;
	 */

	if ((WP_count == 0)&&(WP_go_home!=1))  {
		WP_count = WP_count + 1;
		WPcur_V_Pn_Pe[0] = WP1_V_Pn_Pe[0];
		WPcur_V_Pn_Pe[1] = WP1_V_Pn_Pe[1];
		WPcur_V_Pn_Pe[2] = WP1_V_Pn_Pe[2];
	}
	
	// Sample time & PID cycle count
	//sample_rate = (time_stamp_hist[0] - time_stamp_hist[1]);

	//if (sample_rate <= 0) {
	//	sample_rate = 0.1;
	//}
	sample_rate = 0.1;
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
	SpeedHeadingCommand(&WheelSpeedCmd, &TurnRadiusCmd, SpeedCmd, HeadingCmd_deg, dist_PnPe, Speed, Heading_deg, sample_rate, cycle_count);
	
	//Waypoint cycle
	if (dist_PnPe < closenessWayPt_mm)  {
		WP_count = WP_count + 1;
		//HeadingCmd_hist[0] = 0; HeadingCmd_hist[1] = 0; HeadingCmd_hist[2] = 0; HeadingCmd_hist[3] = 0;
		HeadingCmd_hist[1] = HeadingCmd_hist[0]; HeadingCmd_hist[2] = HeadingCmd_hist[0]; HeadingCmd_hist[3] = HeadingCmd_hist[0];
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
	//} else if (WP_count == 5)  {
		//WPcur_V_Pn_Pe[0] = WP5_V_Pn_Pe[0];
		//WPcur_V_Pn_Pe[1] = WP5_V_Pn_Pe[1];
		//WPcur_V_Pn_Pe[2] = WP5_V_Pn_Pe[2];
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

void updatePosition(float *x, float *y) {

	velX_new = velX + accelX*9.81*delta_t;
	posX_new = *x + velX_new*delta_t;

	//velX_new = velX + accelX;
	//posX_new = *x + velX_new*delta_t;

	velY_new = velY + accelY*9.81*delta_t;
	posY_new = *y + velY_new*delta_t;

	velX = velX_new;
	velY = velY_new;
	
	*x = posX_new;
	*y = posY_new;
	
} 

void updatePositionVelCreate(float *xc, float *yc, float *Vxc, float *Vyc) {

	//use velocity of left and right wheels to determine velocity in X and Y
	time_stamp_hist[1] = time_stamp_hist[0];
	time_stamp_hist[0] = getTimeStamp();
	sample_rate = (time_stamp_hist[0] - time_stamp_hist[1]);

	//create_angle = readSensor(SENSOR_ANGLE);
	//if (abs(create_angle) > 0) {
		psi_new = getYaw();
	//}
	double x_vel = (create_distance/delta_t)*cos(psi_new*M_PI/180);
	double y_vel = (create_distance/delta_t)*sin(psi_new*M_PI/180);

	double X_new = *xc + (create_distance)*cos(psi_new*M_PI/180);
	double Y_new = *yc + (create_distance)*sin(psi_new*M_PI/180);

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

	HeadingCmd_hist[0] = atan2(diff_Pe, diff_Pn)*180/M_PI;

	*HeadingCmd_deg = atan2(diff_Pe, diff_Pn)*180/M_PI; 
	//*HeadingCmd_deg = 0.25*(HeadingCmd_hist[0] + HeadingCmd_hist[1] + HeadingCmd_hist[2] + HeadingCmd_hist[3]); 

	HeadingCmd_hist[1] = *HeadingCmd_deg;
	HeadingCmd_hist[2] = HeadingCmd_hist[1];
	HeadingCmd_hist[3] = HeadingCmd_hist[2];

}

void SpeedHeadingCommand(float *WheelSpeedCmd, float *TurnRadiusCmd, float SpeedCmd, float HeadingCmd_deg, float dist_PnPe, float Speed, float Heading_deg, float sample_rate, int cycle_count) {

	// Calculate wheel speed and turn radius from Speed and Heading commands
	float HeadingErr   = 0;
	float CorrectedErr = 0;
	float k_heading    = 10000;
	float Ti_heading   = 10000000;
	float Ti_INUSE   = 0;
	float Td_heading   = 0.05;

	*WheelSpeedCmd = SpeedCmd;//0.1*(SpeedCmd-Speed)+*WheelSpeedCmd; //TODO: verify correct gain needed to command a true speed of the robot

	// Calc Heading Error, ensure correct/closest direction
	HeadingErr = atan2(sin((HeadingCmd_deg-Heading_deg)*M_PI/180), cos((HeadingCmd_deg-Heading_deg)*M_PI/180) ) * 180/M_PI;
	//HeadingErr = HeadingCmd_deg-Heading_deg;
	// Correct error, turn radius is in the opposite sign and inversely related to the Heading error
	CorrectedErr = -1/HeadingErr;
	if (cycle_count <=1) {
		HeadingErr_hist[0]  = 0;
		HeadingErr_hist[1]  = 0;
		HeadingErr_hist[2]  = 0;
		TurnRadiusCmd_hist[0] = 0;
		TurnRadiusCmd_hist[1] = 0;
	}
	else if (cycle_count == 2) {
		HeadingErr_hist[0]  = 0;
		TurnRadiusCmd_hist[0] = 0;
		TurnRadiusCmd_hist[1] = 0;
	}
	else if (cycle_count >= 3) {
		HeadingErr_hist[0] = CorrectedErr;
		TurnRadiusCmd_hist[0]    = TurnRadiusCmd_hist[1] 
		+ k_heading*((1 + (sample_rate/Ti_heading)*Ti_INUSE + (Td_heading/sample_rate)) * HeadingErr_hist[0] 
		- (1 + 2 * (Td_heading/sample_rate)) * HeadingErr_hist[1]
		+ (Td_heading/sample_rate) * HeadingErr_hist[2]);

	}
	
	if ((TurnRadiusCmd_hist[0] < 1) && (TurnRadiusCmd_hist[0] > 0))  {
		TurnRadiusCmd_hist[0] = 1;
	}

	if ((TurnRadiusCmd_hist[0] > -1) && (TurnRadiusCmd_hist[0] < 0))  {
		TurnRadiusCmd_hist[0] = -1;
	}

	if (*WheelSpeedCmd > 300)  {
		*WheelSpeedCmd = 300;

	}  else if (*WheelSpeedCmd < 150)  {
		*WheelSpeedCmd = 150;
	} 
	 
	*TurnRadiusCmd = TurnRadiusCmd_hist[0];
	
	HeadingErr_hist[2] = HeadingErr_hist[1];
	HeadingErr_hist[1] = HeadingErr_hist[0];

	TurnRadiusCmd_hist[1] = TurnRadiusCmd_hist[0];

}
