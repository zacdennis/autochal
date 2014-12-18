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
#include <stdlib.h>
#include <stdio.h>
#include <curses.h>
#include <math.h>

#define MAX(a,b)        (a > b? a : b)
#define MIN(a,b)        (a < b? a : b)
#define SONG_LENGTH 8


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


int main(int argv, char* argc[])
{
        WINDOW *win;
        int key;
        int not_done = 1;


        int speed = 0;//store user input.
        int turn = 0;
       
        int velocity = 0; //values sent to the create
        int radius = 0;

        int charge;
	int x = 0;
	int y = 0;

        if (argv < 2) {
          fprintf(stderr, "Usage: drive DEVICE (e.g. /dev/ttyUSB0)\n");
          exit(1);
        }
       
       
        //setup ncurses
        initscr();
        clear();
        noecho();
        cbreak();      
        win = newwin(24, 80, 0, 0);
        keypad(win, TRUE);
	wtimeout(win,500);

     
        startOI_MT (argc[1]);

       
        while(not_done) {
               
                erase();
                charge = getCharge();
                mvwprintw(win, 0, 0, "Use arrow keys to steer.");
                mvwprintw(win, 1, 0, "'h' for horn.");
                mvwprintw(win, 2, 0, "'q' to quit.");
                mvwprintw(win, 4, 0, "Battery Charge: %d%%", charge);
		mvwprintw(win, 5, 0, "Position: %d,%d",x,y);
                mvwprintw(win, 6, 0, "%d %d", velocity, radius);
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
                case 'q':
                        not_done = 0;
                }
               


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
               
                drive(velocity, radius);
               
               
        }


        clrtoeol();
        refresh();
        endwin();
        stopOI_MT();
}
