

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

int main()
{
        startOI_MT ("/dev/ttyO0");
       
        
       //first half leg
        driveDistance(300,0,800,1);
	turn(100,1,87,1);
        while(1)
        {
		//fprintf(stdout,"Driving\n");
                driveDistance (300, 0, 1000, 1); //velocity,radius,distance,interruptable
                //fprintf(stdout,"Turning\n");
                turn (100, 1, 87, 1); //velocity, radius, angle, interruptable
		driveDistance(300,0,2000,1);
		turn(100,1,87,1);
        }

        stopOI_MT();
}

