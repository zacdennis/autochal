/** BumpCheck.c
 *
 *  A simple program to move the Create and back up and turn when the bumper sensor is tripped.
 *
 *  Author: Alexis Mackenzie
 *
 *
 *  Versions:
 *      1.0     6 June 2014     Initial release
 */

#include <createoi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define SONG_LENGTH 8

/** Play sound when bumper tripped */
void horn() {
	char song[SONG_LENGTH * 2];
	int i;
	for(i=0; i < SONG_LENGTH; i++) {
		song[i*2] = 31 + floor(drand48() * (127-31));
		song[i*2+1] = 8 + floor(drand48() * 10);
	}
	writeSong(0,SONG_LENGTH, song);
	playSong(0);
}

int main(int argv, char* argc[])
{
        if (argv < 2) {
          fprintf(stderr, "Usage: drive DEVICE (e.g. /dev/ttyUSB0)\n");
          exit(1);
        }

        startOI_MT (argc[1]);

	while(1) {
	   fprintf(stdout,"Driving forward...\n");
	   driveDistance (300, 0, 500, 1);
	   int bumper = getBumpsAndWheelDrops();
	   if (0 != bumper)                                                        //sensor was tripped
           {
		fprintf(stdout, "Bumper Reading %d\n", bumper);
                if (1 == bumper)
                {
                        //drive (-120, 0);
                        //waitAngle (45, 1);
			fprintf(stdout, "Backing up at 120\n");
			horn();
			//driveDistance(-120,0,-400,0);
			//fprintf(stdout,"Turning...\n");
			//turn(100,1,45,1);
			drive(-100,-40);
			waitAngle(180,0);
			//driveDistance(-100,40,180,0);
                }
                else if (2 == bumper)
                {
                        //drive (-120, 0);
                        //waitAngle (-45, 1);
			fprintf(stdout, "Backing up at 120-2\n");
			driveDistance(-120,0,-300,0);
			fprintf(stdout,"Turning...\n");
			turn(100,-1,-45,1);
                }
                else if (3 == bumper)
                {
			fprintf(stdout,"Backing up at 250\n");
                        driveDistance(-250,0,-400,0);
			fprintf(stdout,"Turning...\n");
			turn (100,1,90,0);
                }
		else if ( 4 == bumper)
		{
			horn();
			driveDistance(-100,-40,-180,1);
		}
        }
	}
	stopOI_MT();

}
