

/** square.c
 *
 *  A simple program to move the Create in a square 1m per side.
 *
 *  Author: Jesse DeGuire
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
 *
 *  Versions:
 *      1.0     12 Jan 2008     Initial public release
 */

#include <createoi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argv, char* argc[])
{
        if (argv < 2) {
          fprintf(stderr, "Usage: drive DEVICE (e.g. /dev/ttyUSB0)\n");
          exit(1);
        }
        startOI_MT (argc[1]);
       
       int ir_reading = readSensor(SENSOR_INFRARED); 
       while(ir_reading != 254)
        {
                turn (100, 1, 4, 1);
		ir_reading = readSensor(SENSOR_INFRARED);
		fprintf(stdout,"IR reading %d\n", ir_reading);
                usleep (20000);
        }

	drive(250,0);
	int charging = 0;
	int bumper = 0;
	int cliff_FL = 0;
	int cliff_FR = 0;
	while(charging == 0 && bumper == 0 && cliff_FL == 0 && cliff_FR == 0) 
	{
		charging = readSensor(SENSOR_CHARGING_SOURCES_AVAILABLE);
                bumper = getBumpsAndWheelDrops();
		cliff_FL = readSensor(SENSOR_CLIFF_FRONT_LEFT);
		cliff_FR = readSensor(SENSOR_CLIFF_FRONT_RIGHT);
		fprintf(stdout, "Charging %d bumped %d %d %d\n", charging,bumper,cliff_FL,cliff_FR);
		usleep(10000);
	}

	drive(0,0);
	if(charging == 0) {
		usleep(20000);
		charging = readSensor(SENSOR_CHARGING_SOURCES_AVAILABLE);
	}

	//drive(-50,0);
	while(charging == 0) {
		drive(-50,0);
		usleep(20000);
		drive(0,0);
		usleep(10000);
		charging = readSensor(SENSOR_CHARGING_SOURCES_AVAILABLE);
	}
	drive(0,0);

        stopOI_MT();
}

