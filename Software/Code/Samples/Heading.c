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

int main(int argv, char* argc[])
{

        if (argv < 4) {
          fprintf(stderr, "Usage: drive /dev/ttyO0 /dev/ttyUSB0 heading\n");
          exit(1);
        }

        int not_done = 1;
       
	float heading_cmd = atoi(argc[3]);
	float yaw = 0;
	float yaw_err = 0;
	float speed_cmd = 0;
	float speed_mag = 0;
	float turn_radius = 1;
	float Kp_yaw   = 2;

        startOI_MT (argc[1]);

	startIMU_MT (argc[2]);

        yaw = getYaw();
	//int tollerance = 2; //+-2 deg
	float yaw_count = 1.0;

	while(yaw == 0) {//wait for initialization
		usleep(1000);
		yaw = getYaw();
	}
	while(not_done) {

		yaw = getYaw();
		yaw_err = heading_cmd - yaw;

		//printf("Count    : %.0f\n", yaw_count);
		printf("Yaw      : %.2f\n", yaw);
		printf("Yaw Error: %.2f\n\n", yaw_err);

		speed_cmd = -Kp_yaw*yaw_err;
		
		speed_mag = speed_cmd;
		turn_radius  = 1;

		if(speed_cmd < 0) {
			speed_mag = -1*speed_cmd;
			turn_radius  = -1;}

		
		if (speed_mag > 100)  {
			speed_mag = 100;
		}

		if (abs(yaw_err) < 0.5 )  {
			speed_mag = 0;
			turn_radius  = 0; 
		}
	
		drive(speed_mag,turn_radius);
		
		//printf("Speed Mag: %.2f\n", speed_mag);
		//printf("Turn Rad : %.2f\n\n", turn_radius);

		yaw_count = yaw_count + 1;
		usleep(250);

	}

        stopOI_MT();
	stopIMU_MT();
}
