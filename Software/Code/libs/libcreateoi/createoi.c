/** \file createoi.c
 *  \brief Commands for controlling the Create.
 *
 *  Contains definitions for all the functions available in COIL.
 *  Many functions are direct implementations of Open Interface
 *  commands (making this a wrapper).  However, others are provided as
 *  additional functionality that is not available in the OI, provided
 *  as a convience to the user.  It is best to read the accompaning
 *  documentation for usage info.
 *
 *  \author     Jesse DeGuire, Nathan Sprague
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
 *      1.1     04 Aug 2008     Added multi-threaded mode.
 */

#include <stdlib.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include "createoi.h"
#include <sys/time.h>
#include <pthread.h>
#include <semaphore.h> 

#define MAX(a,b)        (a > b? a : b)
#define MIN(a,b)        (a < b? a : b)
#define CYCLE_TIME 20000  //delay (in mircoseconds) between readings in MT mode.

static int fd = 0;                      ///< file descriptor for serial port
static int debug = 0;                   ///< debug mode status

static int THREAD_MODE = 0;            ///multi-thread mode status.
pthread_mutex_t sensor_cache_mutex;    ///locks sensor cache struct
pthread_mutex_t create_mutex;          ///locks i/o for create

pthread_t sensor_thread;

sem_t* sem_sensor;

static int cwrite (int fd, byte* buf, int numbytes);
static int cread (int fd, byte* buf, int numbytes);
static int stopWait();
void *sensorThreadFunc( void *ptr );
void *sensorThreadFuncStandalone( void *ptr );

typedef struct {
        int distance;
        int angle;
        int velocity;
        int turning_radius;
        int bumps_and_wheel_drops;
        int cliff_left;
        int cliff_front_left;
        int cliff_front_right;
        int cliff_right;
        int wall;
        int charge;
        int capacity;
        int overcurrent;
        double time_stamp;
        int shut_down;
} sensor_cache_t;

sensor_cache_t* sensor_cache;

/* getTime() - returns current system time in seconds as a double.
 */
double getTime(){
        double reta, retb, ret;
        struct timeval timev;
        long cur_sec,cur_usec;
        gettimeofday(&timev,NULL);
        cur_sec = timev.tv_sec;
        cur_usec = timev.tv_usec;
        reta = (double)(cur_sec );
        retb = (double)(cur_usec );
        ret = reta + retb / 1000000;
        return ret;
}



/** \brief Starts the OI.
 *
 *      This command opens the serial connection and starts the Open
 *      Interface.  The Create will be started in Passive Mode. You
 *      must send this command first before any others.
 *
 *      \param serial   The location of the serial port device file
 *
 *  \return             0 if successful or -1 otherwise
 */
int startOI (char* serial)
{
        struct termios options;
        byte cmd[1];

        pthread_mutex_init(&create_mutex, NULL);
       
       
        //do only if serial port hasn't been opened yet
        if (0 == fd)
        {
                fd = open (serial, O_RDWR | O_NOCTTY | O_NDELAY);
                if (fd < 0)
                {
                        perror ("Could not open serial port");
                        return -1;
                }
                fcntl (fd, F_SETFL, 0);
                tcflush (fd, TCIOFLUSH);

                //get config from fd and put into options
                tcgetattr (fd, &options);
                //give raw data path
                cfmakeraw (&options);
                //set baud
                cfsetispeed (&options, B57600); //B57600 in original                
                cfsetospeed (&options, B57600); //B57600
                //send options back to fd
                tcsetattr (fd, TCSANOW, &options);              
        }
       
        enterPassiveMode();//sends start signal
       
        enterSafeMode ();
        setLEDState (0, 128, 255);

        return 0;
}


/** \brief Starts the OI in multi-threaded mode.
 *
 *      This command starts the interface in multithreaded mode.  In
 *      this mode, a dedicated thread reads all sensor values periodically
 *      and caches the values.  Subsequent calls to get* sensor commands
 *      will read from the cache instead of querying the create.
 *
 *      \param serial   The location of the serial port device file
 *
 *  \return             0 if successful or -1 otherwise
 */
int startOI_MTS (char* serial, sem_t* sem_input)
{
        if (startOI(serial) != 0)
                return -1;

        THREAD_MODE = 1;
	sem_sensor = sem_input;
        pthread_mutex_init(&sensor_cache_mutex, NULL);
        sensor_cache = (sensor_cache_t*) malloc(sizeof(sensor_cache_t));
        sensor_cache->shut_down = 0;
        pthread_create( &sensor_thread, NULL, sensorThreadFunc, NULL);
        usleep(100000);//give sensor thread time to get valid readings.
}

/** \brief Starts the OI in multi-threaded mode.

 *

 *      This command starts the interface in multithreaded mode.  In

 *      this mode, a dedicated thread reads all sensor values periodically

 *      and caches the values.  Subsequent calls to get* sensor commands

 *      will read from the cache instead of querying the create.

 *

 *      \param serial   The location of the serial port device file

 *

 *  \return             0 if successful or -1 otherwise

 */
int startOI_MT (char* serial)

{
        if (startOI(serial) != 0)
                return -1;

        THREAD_MODE = 1;
        pthread_mutex_init(&sensor_cache_mutex, NULL);
        sensor_cache = (sensor_cache_t*) malloc(sizeof(sensor_cache_t));
        sensor_cache->shut_down = 0;
        pthread_create( &sensor_thread, NULL, sensorThreadFuncStandalone, NULL);
        usleep(100000);//give sensor thread time to get valid readings.
}

/** Thread responsible for handling sensor loop in multi-threaded mode.
 *
 */
void *sensorThreadFunc( void *ptr )
{
        int done = 0;
        sensor_cache->distance = 0;
        sensor_cache->angle = 0;

        while (!done) {

		sem_wait(sem_sensor);

                int * sensors = getAllSensors();

                pthread_mutex_lock( &sensor_cache_mutex );
                sensor_cache->time_stamp = getTime();
                sensor_cache->distance += sensors[12];
                sensor_cache->angle += sensors[13];
                sensor_cache->velocity = sensors[32];
                sensor_cache->turning_radius = sensors[33];
                sensor_cache->bumps_and_wheel_drops = sensors[0];
                sensor_cache->cliff_left =  sensors[2];
                sensor_cache->cliff_front_left =  sensors[3];
                sensor_cache->cliff_front_right =  sensors[4];
                sensor_cache->cliff_right =  sensors[5];
                sensor_cache->wall = sensors[1];
                sensor_cache->charge = sensors[18];
                sensor_cache->capacity = sensors[19];
                sensor_cache->overcurrent = sensors[7];
                done = sensor_cache->shut_down;
                pthread_mutex_unlock( &sensor_cache_mutex );
                free(sensors);
                //usleep(CYCLE_TIME);
        }
        pthread_exit(NULL);
}

/** Thread responsible for handling sensor loop in multi-threaded mode.
 *

 */
void *sensorThreadFuncStandalone( void *ptr )
{
        int done = 0;
        sensor_cache->distance = 0;
        sensor_cache->angle = 0;

        while (!done) {

                int * sensors = getAllSensors();

                pthread_mutex_lock( &sensor_cache_mutex );
                sensor_cache->time_stamp = getTime();
                sensor_cache->distance += sensors[12];
                sensor_cache->angle += sensors[13];
                sensor_cache->velocity = sensors[32];
                sensor_cache->turning_radius = sensors[33];
                sensor_cache->bumps_and_wheel_drops = sensors[0];
                sensor_cache->cliff_left =  sensors[2];
                sensor_cache->cliff_front_left =  sensors[3];
                sensor_cache->cliff_front_right =  sensors[4];
                sensor_cache->cliff_right =  sensors[5];
                sensor_cache->wall = sensors[1];
                sensor_cache->charge = sensors[18];
                sensor_cache->capacity = sensors[19];
                sensor_cache->overcurrent = sensors[7];
                done = sensor_cache->shut_down;
                pthread_mutex_unlock( &sensor_cache_mutex );
                free(sensors);
                usleep(CYCLE_TIME);
        }
        pthread_exit(NULL);
}

/** \brief      Sets the baud rate for serial port transfer
 *
 *      This command sets the baud rate between the Create and
 *  computer.  This persists until either this command is called again
 *  or until the Create loses power.  This command will wait for 100ms
 *  after setting the baud rate to prevent data loss (this is in
 *  compliance with the OI specification).  The default baud rate is
 *  56kbps.  <b>Note: At a baud rate of 115200, there must be a 20us
 *  gap between each byte or else data loss will occur.</b>
 *
 *      \param  rate    New baud rate value
 *
 *  \return                     0 if successful or -1 otherwise
 */
int setBaud (oi_baud rate)
{
        struct termios options;
        byte cmd[2];
        int new_baud;

        //used to set baud for PC same as baud for Create
        switch (rate)
        {
                case BAUD300:           new_baud = 300;         break;
                case BAUD600:           new_baud = 600;         break;
                case BAUD1200:          new_baud = 1200;        break;
                case BAUD2400:          new_baud = 2400;        break;
                case BAUD4800:          new_baud = 4800;        break;
                case BAUD9600:          new_baud = 9600;        break;
                case BAUD14400:         new_baud = 14400;       break;
                case BAUD19200:         new_baud = 19200;       break;
                case BAUD28800:         new_baud = 28800;       break;
                case BAUD38400:         new_baud = 38400;       break;
                case BAUD57600:         new_baud = 56700;       break;
                case BAUD115200:        new_baud = 115200;      break;
                default:                        
                        fprintf (stderr, "Could not set baud: Invalid argument\n");
                        return -1;
        }

        cmd[0] = OPCODE_BAUD;   cmd[1] = rate;

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 2) < 0)
        {
                perror ("Could not set baud");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
       
        tcgetattr (fd, &options);
        cfsetispeed (&options, new_baud);
        cfsetospeed (&options, new_baud);
        tcsetattr (fd, TCSANOW, &options);

        usleep (100000);                                //sleep for 100ms
        pthread_mutex_unlock( &create_mutex );

        return 0;
}

/** \brief Put Create into Passive Mode
 *
 *      This puts the Create into Passive Mode.  This mode allows
 *      reading sensor data, running demos, and changing mode.  All
 *      other commands are ignored.
 *
 *      \return 0 if successful or -1 otherwise
 */
int enterPassiveMode()
{
        byte cmd[1];
        cmd[0] = OPCODE_START;
       
        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 1) < 0)
        {
                perror ("Could not enter Passive Mode");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );

        return 0;
}


/** \brief Put Create into Safe Mode
 *
 *      This puts the Create into Safe Mode, allowing control over the
 *      Create.  The Create will stop and revert to Passive Mode if
 *      any of the cliff or wheel drop sensors are activated or if the
 *      charger is plugged in and powered.
 *
 *      \return         0 if successful or -1 otherwise
 */
int enterSafeMode ()
{
        byte cmd[1];
        cmd[0] = OPCODE_SAFE;
       
        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 1) < 0)
        {
                perror ("Could not enter Safe Mode");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief Put Create into Full Mode
 *
 *      The puts the Create into Full Mode, allowing complete control
 *  over the Create.  The Create will turn off all safety features in
 *  this mode, giving you control over the Create's actions should any
 *  of the wheel drop or cliff sensor activate.  Be warned, however,
 *  that this also means that nothing will stop the Create from
 *  driving off a cliff.
 *
 *      \return         0 if successful or -1 otherwise
 */
int enterFullMode ()
{
        byte cmd[1];
        cmd[0] = OPCODE_FULL;
       
        pthread_mutex_lock( &create_mutex );
        if (cwrite (fd, cmd, 1) < 0)
        {
                perror ("Could not enter Full Mode");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );

        return 0;
}




/** \brief Run a built-in demo
 *
 *      This starts one of the Create's built-in demo routines.
 *  Information about the demos is available in the iRobot Create
 *  instruction manual.  This will put the Create into Passive Mode.
 *
 *      \param demo The value of the demo to run (or 255 to stop the
 *      current demo).
 *
 *      \return                 0 if successful or -1 otherwise
 */
int runDemo (oi_demo demo)
{
        byte cmd[2];
        cmd[0] = OPCODE_DEMO;   cmd[1] = demo;

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 2) < 0)
        {
                perror ("Could not run demo");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief Run the Cover demo
 *
 *      \return         0 if successful or -1 otherwise
 */
int runCoverDemo ()
{
        byte cmd[1];
        cmd[0] = OPCODE_COVER;

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 1) < 0)
        {
                perror ("Could not start Cover demo");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }

        pthread_mutex_unlock( &create_mutex );

        return 0;
}

/** \brief Run the Cover and Dock demo
 *
 *      \return         0 if successful or -1 otherwise
 */
int runCoverAndDockDemo ()
{
        byte cmd[1];
        cmd[0] = OPCODE_COVER_AND_DOCK;

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 1) < 0)
        {
                perror ("Could not start Cover and Dock demo");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief Run the Spot demo
 *
 *      \return         0 if successful or -1 otherwise
 */
int runSpotDemo ()
{
        byte cmd[1];
        cmd[0] = OPCODE_SPOT;
        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 1) < 0)
        {
                perror ("Could not start Spot demo");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Drive the robot with a given velocity and turning radius
 *
 *      Drives the Create with the given velocity (mm/s) and turning
 *  radius (mm).  The velocity ranges from -500 to 500mm/s, with
 *  negative velocities making the Create drive backward.  The radius
 *  ranges from -2000 to 2000mm, with positive radii turning the
 *  Create left and negative radii turning it right.
 *
 *      A radius of -1 makes the Create turn in place clockwise and 1
 *      makes it turn in place counter-clockwise.  Also, a radius of 0
 *      will make the Create drive straight.
 *
 *      \param vel The velocity, in mm/s, of the robot
 *      \param rad The turning radius, in mm, from the center of the
 *      turning circle to the center of the Create.
 *
 *      \return         0 if successful or -1 otherwise
 */
int drive (short vel, short rad)
{
        byte cmd[5];

        //keep args within Create limits
        vel = MIN(500, vel);
        vel = MAX(-500, vel);
        rad = MIN(2000, rad);
        rad = MAX(-2000, rad);

        if (0 == rad)   //special case for drive straight (from manual)
                rad = 32768;

        cmd[0] = OPCODE_DRIVE;
        cmd[1] = (vel >> 8) & 0x00FF;
        cmd[2] = vel & 0x00FF;
        cmd[3] = (rad >> 8) & 0x00FF;
        cmd[4] = rad & 0x00FF;

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 5) < 0)
        {
                perror ("Could not start drive");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Control the Create's wheels directly
 *
 *      Allows you to control the velocity of each wheel
 *      independently, ranging from -500 to 500mm/s.  A positive
 *      velocity makes the wheel drive forward and a negative velocity
 *      makes it drive backward.
 *
 *      \param  Lwheel  The velocity of the left wheel
 *      \param  Rwheel  The velocity of the right wheel
 *
 *      \return         0 if successful or -1 otherwise
 */
int directDrive (short Lwheel, short Rwheel)
{
        byte cmd[5];

        //keep args within Create limits
        Lwheel = MIN(500, Lwheel);
        Lwheel = MAX(-500, Lwheel);
        Rwheel = MIN(500, Rwheel);
        Rwheel = MAX(-500, Rwheel);

        cmd[0] = OPCODE_DRIVE_DIRECT;
        cmd[1] = (Rwheel >> 8) & 0x00FF;
        cmd[2] = Rwheel & 0x00FF;
        cmd[3] = (Lwheel >> 8) & 0x00FF;
        cmd[4] = Lwheel & 0x00FF;
       
        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 5) < 0)
        {
                perror ("Could not start direct drive");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Drive for the specified distance
 *
 *  Moves the Create at the specified velocity and turning radius
 *  until the specified distance is reached, at which point it will
 *  stop.  Velocity ranges from -500mm/s to 500mm/s (negative values
 *  move backward) and turning radius ranges from -2000mm to 2000mm
 *  (negative values turn right; positive values turn left).
 *
 *      A radius of -1 will spin the Create in place clockwise and a
 *      radius of 1 will spin it counter-clockwise.  A radius of 0
 *      will drive straight.
 *
 *      The distance sensor on the Create will be reset to 0 after
 *      using this function.
 *
 *      \param  vel             desired velocity in mm/s
 *      \param  rad             desired turning radius in mm

 *      \param dist distance the Create should travel before stopping
 *      in mm

 *      \param interrupt 0 if the movement should be
 *      non-interruptible: ignore collisions 1 if the movement should
 *      be interruptible: terminate on collision
 *
 *      \return         Distance travelled or INT_MIN on error
 */
int driveDistance (short vel, short rad, int dist, int interrupt)
{
        int ret = 0;
       
        if (drive (vel, rad) == -1 || (ret = waitDistance (dist, interrupt)) == INT_MIN || drive (0, 0) == -1)
                return INT_MIN;
               
        return ret;
}

/** \brief      Turn for the specified angle
 *
 *  Moves the Create at the specified velocity and turning radius
 *  until the specified angle is reached, at which point it will stop.
 *  Velocity ranges from -500mm/s to 500mm/s (negative values move
 *  backward) and turning radius ranges from -2000mm to 2000mm
 *  (negative values turn right; positive values turn left).
 *
 *  A radius of -1 will spin the Create in place clockwise and a
 *  radius of 1 will spin it counter-clockwise.  A radius of 0 will
 *  drive straight.
 *
 *  The angle sensor on the Create will be reset to 0 after using this
 *  function.
 *
 *      \param  vel             desired velocity in mm/s
 *      \param  rad             desired turning radius in mm
 *      \param  angle   distance the Create should travel before stopping in mm
 *      \param interrupt 0 if the movement should be
 *                       non-interruptible: ignore collisions 1 if the
 *                       movement should be interruptible: terminate
 *                       on collision
 *
 *      \return         Angle turned or INT_MIN on error
 */
int turn (short vel, short rad, int angle, int interrupt)
{
        int ret = 0;
       
        if (drive (vel, rad) == -1 ||
            (ret = waitAngle (angle, interrupt)) == INT_MIN ||
            drive (0, 0) == -1)
                return INT_MIN;
               
        return ret;
}


/** \brief      Controls the state of the LEDs on the Create
 *
 *      Allows you the control the state of the three LEDs on the top
 *      of the Create.  The Play and Advance LEDs can be on or off and
 *      are controlled by setting bit flags.  The Power LED is set
 *      with two bytes: one for the color and the other for the
 *      light's intensity.  The color ranges from green (0) to red
 *      (255).
 *
 *      \param  lflags  LED flags for setting the Play and Advance LEDs
 *      \param  pColor  Sets color for the Power LED
 *      \param  pInten  Intensity of the Power LED
 *
 *      \return         0 if successful or -1 otherwise
 */
int setLEDState (oi_led lflags, byte pColor, byte pInten)
{
        byte cmd[4];
        cmd[0] = OPCODE_LED;
        cmd[1] = lflags;
        cmd[2] = pColor;
        cmd[3] = pInten;

        pthread_mutex_lock( &create_mutex );
        if (cwrite (fd, cmd, 4) < 0)
        {
                pthread_mutex_unlock( &create_mutex );
                perror ("Could not set LEDs");
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Sets state of digital ouputs
 *
 *      Controls the state of the 3 digital outputs in the Cargo Bay
 *      Connector.  Each output is able to provide up to 20mA of
 *      current.  The state is set using bit flags, with 1 being high
 *      (5V) and 0 being low (0V).
 *
 *      \param  oflags  Output flags for setting the state of the 3 outputs
 *
 *      \return         0 if successful or -1 otherwise
 */
int setDigitalOuts (oi_output oflags)
{
        byte cmd[2];
        cmd[0] = OPCODE_DIGITAL_OUTS;
        cmd[1] = oflags;

        pthread_mutex_lock( &create_mutex );
       
        if (cwrite (fd, cmd, 2) < 0)
        {
                perror ("Could not set digital outs");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Control low side drivers with variable power
 *
 *      Specifies the PWM (pulse width modulation) duty cycle for each
 *  of the three low side drivers in the system, with a maximum value
 *  of 128. For example, sending a value of 64 would control a driver
 *  with 50% of battery voltage since 128/64 = .5.
 *
 *      \param  pwm0    duty cycle for driver 0
 *      \param  pwm1    duty cycle for driver 1
 *      \param  pwm2    duty cycle for driver 2
 *
 *      \return         0 if successful or -1 otherwise
 */
int setPWMLowSideDrivers (byte pwm0, byte pwm1, byte pwm2)
{
        byte cmd[4];

        //max value is 128
        pwm0 = MIN(128, pwm0);
        pwm1 = MIN(128, pwm1);
        pwm2 = MIN(128, pwm2);

        cmd[0] = OPCODE_PWM_LOW_SIDE_DRIVERS;
        cmd[1] = pwm2;
        cmd[2] = pwm1;
        cmd[3] = pwm0;

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 4) < 0)
        {
                perror ("Could not set low side driver duty cycle");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/**     \brief  Control state of low side drivers
 *
 *      Controls the state of each of the low side drivers using bit
 *      flags.  This command turns the drivers on at 100% PWM duty
 *      cycle.  Low side drivers 0 and 1 can provide up to 0.5A of
 *      current while driver 2 can provide up to 1.5A.  If too much
 *      current is drawn, the current will be limited and the
 *      overcurrent flag in sensor packet 14 (overcurrent packet) is
 *      set.
 *
 *      \param  oflags   Output flags for setting the state of the 3 drivers
 *
 *      \return         0 if successful or -1 otherwise
 */
int setLowSideDrivers (oi_output oflags)
{
        byte cmd[2];
        cmd[0] = OPCODE_LOW_SIDE_DRIVERS;
        cmd[1] = oflags;

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 2) < 0)
        {
                perror ("Could not set low side driver state");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Sends IR signal
 *
 *      Sends the given IR byte out of low side driver 1, using the
 *      format expected by the Create's IR receiver.  The Create
 *      documentation suggests using a 100ohm resistor in parallel
 *      with the IR receiver and its resistor.
 *
 *      \param  irbyte  The byte value to send
 *
 *      \return         0 if successfull or -1 otherwise
 */
int sendIRbyte (byte irbyte)
{
        byte cmd[2];
        cmd[0] = OPCODE_SEND_IR;
        cmd[1] = irbyte;

        pthread_mutex_lock( &create_mutex );
        if (cwrite (fd, cmd, 2) < 0)
        {
                perror ("Could not write to IR");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Create and store a small song
 *
 *      Writes and stores a small song into the Create's internal
 *      memory.  You can store up to 16 songs, each with up to 16
 *      notes each.  Each note is associated with a sound from the
 *      robot's internal MIDI sequencer, with 31 being the lowest note
 *      and 127 being the highest.  Anything outside that range is
 *      considered to be silence.  See the iRobot OI Specification for
 *      more info.
 *
 *      The first argument is the song number (0-15).  The second
 *      argument is the number of notes in the song (1-16).  The third
 *      argument is an array of bytes.  The even entries (0, 2, 4,
 *      etc.)  are the notes to play and the odd entries (1, 3,
 *      5. etc.) are the durations of those notes, in increments of
 *      1/64th of a second (so a value of 32 would play the note for
 *      half a second).  The size of this array should be equal to
 *      twice the second argument.
 *
 *      \param  number  The song number being stored (0-15)
 *      \param  length  The number of notes in the song (1-16)
 *      \param song     An array containing notes and durations of those
 *      notes.  Size = 2 * length
 *
 *      \return         0 if successful or -1 otherwise
 */
int writeSong (byte number, byte length, byte* song)
{
        byte cmd[3 + 2*length];
        int i;

        cmd[0] = OPCODE_SONG;
        cmd[1] = number;
        cmd[2] = length;

        for (i = 0; i < 2*length; i++)
                cmd[i + 3] = song[i];

        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 3+2*length) < 0)
        {
                perror ("Could not write new song");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/**     \brief  Play a stored song
 *
 *      Retrieves a stored song from memory and plays it.  This
 *      command will not do anything if a song is already playing.
 *      Check the "song playing" sensor packet to check if the Create
 *      is ready to play a song.  This command will return 0 as long
 *      as the command was able to be sent to the Create over the
 *      serial port, regardless of whether or not the Create is ready
 *      to play the song.
 *
 *      \param number The song number to play (0-15)
 *
 *      \return         0 if successful or -1 otherwise
 */
int playSong (byte number)
{
        byte cmd[2];
        cmd[0] = OPCODE_PLAY_SONG;
        cmd[1] = number;

        pthread_mutex_lock( &create_mutex );
        if (cwrite (fd, cmd, 2) < 0)
        {
                pthread_mutex_unlock( &create_mutex );
                perror ("Could not play song");
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Get raw data from sensor
 *
 *      Requests the OI to return a packet of sensor data.  There are
 *      42 different packets, each of which returns a value of a
 *      specific sensor or group of sensors.  Different sensors have
 *      different packet sizes, so it is up to you to make sure you
 *      are requesting the correct size and that your buffer is large
 *      enough to accept the packets.
 *
 *      \param[in]      packet  Sensor packet to read
 *      \param[out]     buffer  Buffer to read raw packets into
 *      \param[in]      size    Number of bytes to read into buffer
 *
 *      \return         number of bytes read or -1 on failure
 */
int readRawSensor (oi_sensor packet, byte* buffer, int size)
{
        int numread = 0;
        byte cmd[2];
        cmd[0] = OPCODE_SENSORS;
        cmd[1] = packet;
       
        pthread_mutex_lock( &create_mutex );

        if (cwrite (fd, cmd, 2) < 0)
        {
                perror ("Could not request sensor");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
       
        numread = cread (fd, buffer, size);
        if (numread < 0)
        {
                perror ("Could not read sensor");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
       
        pthread_mutex_unlock( &create_mutex );

        return numread;
}

/** \brief  Read formatted data from single sensor
 *
 *  Returns data from the specified sensor in a user-readable format.
 *  This function will not work for sensor groups, only single
 *  sensors.  Parameter can be one of oi_sensor values.
 *
 * \param       sensor  The sensor to get data from
 *
 * \return              Value read from specified sensor or INT_MIN on error
 */
int readSensor (oi_sensor packet)
{
        int result = 0;
        byte* buffer;
       
        switch (packet)
        {
                //all one-byte unsigned sensors
                case SENSOR_BUMPS_AND_WHEEL_DROPS:
                case SENSOR_WALL:
                case SENSOR_CLIFF_LEFT:
                case SENSOR_CLIFF_FRONT_LEFT:
                case SENSOR_CLIFF_FRONT_RIGHT:
                case SENSOR_CLIFF_RIGHT:
                case SENSOR_VIRTUAL_WALL:
                case SENSOR_OVERCURRENT:
                case SENSOR_INFRARED:
                case SENSOR_BUTTONS:
                case SENSOR_CHARGING_STATE:
                case SENSOR_DIGITAL_INPUTS:
                case SENSOR_CHARGING_SOURCES_AVAILABLE:
                case SENSOR_OI_MODE:
                case SENSOR_SONG_NUMBER:
                case SENSOR_SONG_IS_PLAYING:
                case SENSOR_NUM_STREAM_PACKETS:
                        buffer = (byte*) malloc (sizeof(byte));
                        if (NULL == buffer)
                                return INT_MIN;
                        *buffer = 0;
                        if (-1 == readRawSensor (packet, buffer, 1))
                        {
                                free (buffer);
                                return INT_MIN;
                        }
                        result = *buffer;
                        break;
                       
                //one-byte signed sensor
                case SENSOR_BATTERY_TEMP:
                        buffer = (byte*) malloc (sizeof(char));
                        if (NULL == buffer)
                                return INT_MIN;
                        *buffer = 0;
                        if (-1 == readRawSensor (packet, buffer, 1))
                        {
                                free (buffer);
                                return INT_MIN;
                        }
                        result += (char) *buffer;
                        break;
                       
                //two-byte unsigned sensors
                case SENSOR_VOLTAGE:
                case SENSOR_BATTERY_CHARGE:
                case SENSOR_BATTERY_CAPACITY:
                case SENSOR_WALL_SIGNAL:
                case SENSOR_CLIFF_LEFT_SIGNAL:
                case SENSOR_CLIFF_FRONT_LEFT_SIGNAL:
                case SENSOR_CLIFF_FRONT_RIGHT_SIGNAL:
                case SENSOR_CLIFF_RIGHT_SIGNAL:
                case SENSOR_ANALOG_SIGNAL:
                        buffer = (byte*) malloc (2 * sizeof(byte));
                        if (NULL == buffer)
                                return INT_MIN;
                        buffer[0] = 0; buffer[1] = 0;
                        if (-1 == readRawSensor (packet, buffer, 2))
                        {
                                free (buffer);
                                return INT_MIN;
                        }
                        result = buffer[1] | (buffer[0] << 8);
                        break;
                       
                //two-byte signed sensors
                case SENSOR_DISTANCE:
                case SENSOR_ANGLE:
                case SENSOR_CURRENT:
                case SENSOR_REQUESTED_VELOCITY:
                case SENSOR_REQUESTED_RADIUS:
                case SENSOR_REQUESTED_RIGHT_VEL:
                case SENSOR_REQUESTED_LEFT_VEL:
                        buffer = (byte*) malloc (2 * sizeof(byte));
                        if (NULL == buffer)
                                return INT_MIN;
                        buffer[0] = 0; buffer[1] = 0;  
                        if (-1 == readRawSensor (packet, buffer, 2))
                        {
                                free (buffer);
                                return INT_MIN;
                        }
                        result += (short) (buffer[1] | (buffer[0] << 8));
                        break;
                       
                //any other input is invalid (including packet groups)
                default:
                        return INT_MIN;
        }
       
        free (buffer);
        return result;
}


/** \brief  Get current battery charge.
 *
 *  Get the percentage charge for the create's battery.
 *
 *      \return battery charge level 0-100.
 *      INT_MIN on error
 */
int getCharge ()
{
        int charge;
        int capacity;
   
        if (THREAD_MODE == 0) {
                charge = readSensor(SENSOR_BATTERY_CHARGE);
                capacity =  readSensor(SENSOR_BATTERY_CAPACITY);
        } else {
                pthread_mutex_lock(&sensor_cache_mutex);
                charge = sensor_cache->charge;
                capacity = sensor_cache->capacity;
                pthread_mutex_unlock(&sensor_cache_mutex);
        }
        if (charge == INT_MIN || capacity == INT_MIN || capacity ==0)
                return INT_MIN;
        else
                return (charge * 100) / capacity;
               
}


/** \brief  Get current distance
 *
 *      Returns the distance the Create has travelled since the last
 *  time this function was called or the last time the distance sensor
 *  was polled.
 *
 *      \return Distance Create travelled since last reading or
 *      INT_MIN on error
 */
int getDistance ()
{
        if (THREAD_MODE == 0) {
                return readSensor (SENSOR_DISTANCE);
        } else {
                int dist;
                pthread_mutex_lock(&sensor_cache_mutex);
                dist = sensor_cache->distance;
                sensor_cache->distance = 0;
                pthread_mutex_unlock(&sensor_cache_mutex);
                return dist;
        }
               
}
       
/** \brief      Get current angle
 *      
 *      Returns the angle the Create has turned since the last time
 *      this function was called or the last time the angle sensor was
 *      polled.
 *
 *      \return Angle Create turned since last reading or INT_MIN on
 *      error
 */
int getAngle ()
{
        if (THREAD_MODE == 0) {
                return readSensor (SENSOR_ANGLE);
        } else {
                int angle;
                pthread_mutex_lock(&sensor_cache_mutex);
                angle = sensor_cache->angle;
                sensor_cache->angle = 0;
                pthread_mutex_unlock(&sensor_cache_mutex);
                return angle;
        }
}

/** \brief  Get current velocity
 *
 *      Returns the Create's current velocity.  Note that read
 *      velocity may be different from actual velocity due to sensor
 *      inaccuracy and wheel slippage.
 *
 *      \return Create's currently requested velocity or INT_MIN on
 *      error
 */
int getVelocity ()
{
        if (THREAD_MODE == 0) {
                return readSensor (SENSOR_REQUESTED_VELOCITY);
        } else {
                int vel;
                pthread_mutex_lock(&sensor_cache_mutex);
                vel = sensor_cache->velocity;
                pthread_mutex_unlock(&sensor_cache_mutex);
                return vel;
        }
}

/** \brief      Get current turning radius
 *
 *      Returns the Create's current turning radius.  The read value
 *      may differ from the actual value slightly due to sensor
 *      inaccuracy and wheel slippage.
 *
 *      \return Create's currently requested turning radius or INT_MIN
 *      on error.
 */
int getTurningRadius ()
{
        if (THREAD_MODE == 0) {
                return readSensor (SENSOR_REQUESTED_RADIUS);
        } else {
                int rad;
                pthread_mutex_lock(&sensor_cache_mutex);
                rad = sensor_cache->turning_radius;
                pthread_mutex_unlock(&sensor_cache_mutex);
                return rad;
        }      
}

/** \brief      Get overcurrent reading
 *
 *
 *      \return Value of overcurrent sensor
 */
int getOvercurrent ()
{
        if (THREAD_MODE == 0) {
                return readSensor (SENSOR_OVERCURRENT);
        } else {
                int over;
                pthread_mutex_lock(&sensor_cache_mutex);
                over = sensor_cache->overcurrent;
                pthread_mutex_unlock(&sensor_cache_mutex);
                return over;
        }      
}

/**     \brief  Get bumper and wheel drop state
 *
 *      Returns the current state of the bumper and wheel drop
 *      sensors.  The state of each is sent as a single bit.  For
 *      example, a return value of 16 means that only the front
 *      caster's wheeldrop sensor is activated.  A return value of 3
 *      means that both bumper sensors are active.
 *
 *      \return Current state of bumper and wheel drops or INT_MIN on
 *      error
 */
int getBumpsAndWheelDrops ()
{
        if (THREAD_MODE == 0) {
                return readSensor (SENSOR_BUMPS_AND_WHEEL_DROPS);
        } else {
                int bumps;
                pthread_mutex_lock(&sensor_cache_mutex);
                bumps = sensor_cache->bumps_and_wheel_drops;
                pthread_mutex_unlock(&sensor_cache_mutex);
                return bumps;
        }
}

/** \brief      Get state of cliff sensors
 *      
 *      Returns the current states of the four cliff sensors under the
 *      Create's bumper.  Each sensor's state is returned as a single
 *      bit.  For example, a return value of 8 means the left cliff
 *      sensor is activated.
 *
 *      \return         Current state of cliff sensors or INT_MIN on error
 */
int getCliffs ()
{
        int cliffs[4];
        if (THREAD_MODE == 0) {
                cliffs[0] = readSensor (SENSOR_CLIFF_LEFT);
                cliffs[1] = readSensor (SENSOR_CLIFF_FRONT_LEFT);
                cliffs[2] = readSensor (SENSOR_CLIFF_FRONT_RIGHT);
                cliffs[3] = readSensor (SENSOR_CLIFF_RIGHT);
        } else {
                pthread_mutex_lock(&sensor_cache_mutex);
                cliffs[0] = sensor_cache->cliff_left;
                cliffs[1] = sensor_cache->cliff_front_left;
                cliffs[2] = sensor_cache->cliff_front_right;
                cliffs[3] = sensor_cache->cliff_right;
                pthread_mutex_unlock(&sensor_cache_mutex);
        }
       
       
        if (INT_MIN == cliffs[0]  || INT_MIN == cliffs[1] ||
            INT_MIN == cliffs[2] || INT_MIN == cliffs[3])
                return INT_MIN;
       
        return (cliffs[0]*8 + cliffs[1]*4 + cliffs[2]*2 + cliffs[3]);
}

/** \brief      Get data from all sensors
 *
 *      Returns a pointer to the data from all sensors in the Create.
 *      Sensors are in the order given in the CreateOI specification,
 *      starting with Bumps and Wheel Drops.
 *
 *      \return   Pointer to array of sensor data or a NULL pointer on error.
 */
int* getAllSensors()
{
        byte buf[52];
        int* result = (int*)malloc (36*sizeof(int));
        int i, numread;
       
        if (NULL == result)
        {
                fprintf (stderr, "Could not get all sensors:  Memory allocation failed\n");
                return NULL;
        }
       
        memset (buf, 0, 52*sizeof(byte));
        memset (result, 0, 36*sizeof(int));
       
        numread = readRawSensor (SENSOR_GROUP_ALL, buf, 52);
        if (numread < 52)
        {
                fprintf (stderr, "Could not get all sensors:  Incomplete data\n");
                free (result);
                return NULL;
        }
       
        //Bumps And Wheel Drops to Buttons
        for (i = 0; i < 12; i++)
                result[i] = buf[i];
       
        result[12] = (short) ((buf[12] << 8) | buf[13]); //Distance
        result[13] = (short) ((buf[14] << 8) | buf[15]); //Angle
        result[14] = buf[16];                           //Charging State
        result[15] = (buf[17] << 8) | buf[18];          //Voltage
        result[16] = (short) ((buf[19] << 8) | buf[20]); //Current
        result[17] = (char) buf[21];                    //Battery Temp
       
        //Battery Charge to Cliff Right Signal
        for (i = 0; i <= 6; i++)
                result[i + 18] = (buf[22 + 2*i] << 8) | buf[23 + 2*i];
               
        result[25] = buf[36];                           //Cargo Bay DI
        result[26] = (buf[37] << 8) | buf[38];          //Cargo Bay Analog
       
        //Charging Sources to Number Of Stream Packets
        for (i = 0; i <= 4; i++)
                result[i + 27] = buf[39 + i];
               
        //Request sensors
        for (i = 0; i <= 3; i++)
                result [32 + i] = (short) ((buf[44 + 2*i] << 8) | buf[45 + 2*i]);
       
        return result;
}

/** \brief      Get raw data from multiple sensors
 *
 *  Requests the OI to return multiple sensor data packets.  The
 *      packets are returned in the order you specify.  It is up to
 *      you to make sure you are reading the correct number of bytes
 *      from the Create.
 *
 *      \param[in]      packet_list     List of sensor packets to return
 *      \param[in]      num_packets     Number of packets to get
 *      \param[out]     buffer          Buffer to read data into
 *      \param[in]      size            Number of bytes to read into buffer
 *
 *      \return         number of bytes read or -1 on failure
 */
int readRawSensorList (oi_sensor* packet_list, byte num_packets,
                       byte* buffer, int size)
{
        int numread, i;
        byte cmd[size + 2];
        cmd[0] = OPCODE_QUERY_LIST;
        cmd[1] = num_packets;
       
        for (i = 0; i < num_packets; i++)
                cmd[i+2] = packet_list[i];
       
        pthread_mutex_lock( &create_mutex );
       
        if (cwrite (fd, cmd, size+2) < 0)
        {
                perror ("Could not request sensor list");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
       
        numread = cread (fd, buffer, size);
        if (numread < 0)
        {
                perror ("Could not read sensor list");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }

        pthread_mutex_unlock( &create_mutex );
       
        return numread;
}

/**     \brief  Send script to Create
 *
 *      Sends a script, consisting of opcodes and data bytes, to the
 *      Create's internal memory.  A script can be up to 100 bytes
 *      long.
 *
 *      \param  script  Script to send to Create
 *      \param  size    Size, in bytes, of the script
 *
 *      \return         0 if successful or -1 otherwise
 */
int writeScript (byte* script, byte size)
{
        int i;
        byte cmd[size+1];
        cmd[1] = OPCODE_SCRIPT;
       
        for (i = 0; i < size; i++)
                cmd[i+1] = script[i];
       
        pthread_mutex_lock( &create_mutex );
        if (cwrite (fd, cmd, size+1) < 0)
        {
                perror ("Could not write script");
                pthread_mutex_unlock( &create_mutex );
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/** \brief      Plays currently stored script
 *
 *      Loads the script that was written to the Create's internal
 *      memory and runs it.  The script remains in memory after it has
 *      run, allowing you to play it multiple times.
 *
 *      \return         0 if successful or -1 otherwise
 */
int playScript ()
{
        byte cmd[1];
        cmd[0] = OPCODE_PLAY_SCRIPT;
       
        pthread_mutex_lock( &create_mutex );
        if (cwrite (fd, cmd, 1) < 0)
        {
                pthread_mutex_unlock( &create_mutex );
                perror ("Could not play script");
                return -1;
        }
        pthread_mutex_unlock( &create_mutex );
        return 0;
}

/**     \brief  Get script from Create
 *
 *      Gets the currently stored script from the Create and returns a
 *      pointer to it.  The first data byte returned is the number of
 *      bytes in the script, followed by the script itself.
 *
 *      \return         Pointer to script or NULL on failure
 */
byte* getScript ()
{
        byte* script;
        byte cmd[1];
        cmd[0] = OPCODE_SHOW_SCRIPT;
        byte size;
       
        pthread_mutex_lock( &create_mutex );
        if (cwrite (fd, cmd, 1) < 0)
        {
                perror ("Could not request script");
                pthread_mutex_unlock( &create_mutex );
                return NULL;
        }
        if (cread (fd, &size, 1) < 0)
        {
                 perror ("Could not get script size");
                 pthread_mutex_unlock( &create_mutex );

                 return NULL;
        }
        script = (byte*) malloc ((size+1) * sizeof(byte));
        *script = size;
       
        if (cread (fd, script+1, size) < 0)
        {
                perror ("Could not get script data");
                pthread_mutex_unlock( &create_mutex );

                return NULL;
        }

        pthread_mutex_unlock( &create_mutex );
               
       
        return script;
}

/** \brief  Waits for the given amount of time
 *
 *  Waits the given amount of time, in seconds.  This timer has a
 *  resolution of 1 microsecond, or 1e-6 seconds; however, there is no
 *  guarantee of the accuracy of this function.  It will probably be a
 *  little off and it is possible for an external signal to wake up
 *  your program's thread prematurely.  The function returns the time
 *  you told it to wait as a means of informing you it has woken.
 *
 *  \param  time  Time in seconds to wait
 *
 *  \return   The time passed in as a parameter
 */
double waitTime (double time)
{
        if (time < 0)   time = -time;
       
        unsigned int secs = (int)time;
        unsigned int usecs = (int)((time - secs) * 1e6);

        sleep (secs);
        usleep (usecs);

        return time;
}

/** \brief Determines whether the create should exit from waitAngle or
 * waitDistance.
 *
 *              The purpose of this function is to determine whether the create
 *              is making satisfactory and safe progress toward whatever goal
 *              it is waiting to acheive.  Currently it checks bumper sensors,
 *              wheel drops, cliffs, and overcurrent sensors.
 *
 *      \return         not 0 if Create should stop waiting, 0 otherwise.
 */
static int stopWait()
{
  int shouldStop=0;
  static int overCurrentCount = 0;

  if (getOvercurrent() > 0)
    overCurrentCount++;
  else
    overCurrentCount = 0;
 
  if (overCurrentCount > 4){
    shouldStop++;
    overCurrentCount = 0;
  }

  shouldStop += getBumpsAndWheelDrops() + getCliffs();
 
  return shouldStop;
}

/** \brief      Waits for Create to travel given distance
 *
 *  Waits for Create to travel the given distance (in millimeters).
 *  The distance is incremented * when the Create travels forward and
 *  decremented when moving backward.  If the wheels are * passively
 *  rotated in either direction, the distance is incremented.  The
 *  distance sensor * will be reset after using this function.
 *
 *      The distance travelled is updated once per 20ms or 50 times per second.
 *
 *      \param  dist            Distance to travel in millimeters
 *      \param interrupt 0 if the waiting should be non-interruptible:
 *                              ignore collisions 1 if the waiting
 *                              should be interruptible: terminate on
 *                              collision
 *
 *      \return         Distance travelled or INT_MIN on error
 */
int waitDistance (int dist, int interrupt)
{
        int count = 0, current = 0;
       
        //reset sensor data
        if (INT_MIN == getDistance())
                return INT_MIN;

        while (1)
        {
                usleep (20000);
                current = getDistance();
               
                if (INT_MIN == current)
                        return INT_MIN;
                count += current;
                fprintf(stdout,"Count %d out of %d\n",count,dist);
               
                if ((interrupt && stopWait())
                    || (dist >= 0 && count >= dist)
                    || (dist < 0 && count <= dist))
                        break;
        }
        return count;
}

/** \brief      Waits for Create to turn given angle
 *
 *      Waits for Create to turn the given angle (in degrees).  The
 *  angle is incremented when the Create turns counterclockwise and
 *  decremented when turning clockwise.  The angle sensor will be
 *  reset after using this function.
 *
 *      The angle turned is updated once per 20ms or 50 times per second.
 *
 *      \param  angle           Angle to travel in degrees.
 *      \param interrupt 0 if the waiting should be non-interruptible:
 *                              ignore collisions 1 if the waiting
 *                              should be interruptible: terminate on
 *                              collision
 *
 *      \return         Angle turned or INT_MIN on error
 */
int waitAngle (int angle, int interrupt)
{
        int count = 0, current = 0;

        //reset sensor data
        if (INT_MIN == getAngle())
                return INT_MIN;

        while (1)
        {
                usleep (20000);
                current = getAngle();
               
                if (INT_MIN == current)
                        return INT_MIN;
                count += current;
                fprintf(stdout, "Turn count %d\n", getAngle());
               
                if ((interrupt && stopWait()) ||
                    (angle >= 0 && count >= angle) ||
                    (angle < 0 && count <= angle))
                        break;
        }
        return count;
}

/**     \brief  Stops the Create and closes connection to it
 *
 *      Stops the Create and closes the serial connection to it.  The
 *      connection can be restarted by calling the startOI command.
 *
 *      \return         0 if successful or -1 otherwise
 */
int stopOI ()
{              
        enterPassiveMode();

        if (directDrive (0, 0) < 0)
        {
                perror ("Could not stop OI\n");
                return -1;
        }

        pthread_mutex_destroy(&create_mutex);

        close (fd);
        fd = 0;
        return 0;
}


/**     \brief  Stops the Create and closes connection to it
 *
 *      Stops the Create and closes the serial connection to it.  The
 *      connection can be restarted by calling the startOI command.
 *
 *      \return         0 if successful or -1 otherwise
 */
int stopOI_MT ()
{      
        pthread_mutex_lock( &sensor_cache_mutex );
        sensor_cache->shut_down = 1;
        pthread_mutex_unlock( &sensor_cache_mutex );
       
        pthread_join(sensor_thread, NULL);

        pthread_mutex_destroy(& sensor_cache_mutex);

        if (stopOI()  !=0)
                return -1;
       
        return 0;
}


/** \brief Enables Debug Mode
 *
 *  Turns on Debug Mode, which will print serial transfers to the
 *  console window.  Serial reads and writes will be printed in
 *  byte-aligned format, in the order they will be sent to the serial
 *  port.
 */
void enableDebug ()
{
  debug = 1;
}

/** \brief Disables Debug Mode
 *
 *  Turns off Debug Mode, so that serial transfers will no longer be
 *  printed to the console window.
 */
void disableDebug ()
{
  debug = 0;
}

/** \brief      Write data to the Create
 *
 *      Writes data to the Create's serial port.  This function will
 *      continue to attempt writing to the serial port until the
 *      specified number of bytes has been written or until nothing is
 *      written 3 times in a row.  At that point, the function will
 *      return the number of bytes written so far.  Use this function
 *      to write to the Create instead of OS-specific functions.
 *
 *      \param  fd                      The file descriptor for the serial port
 *      \param  buf                     The buffer to write from
 *      \param  numbytes        The number of bytes to write
 *
 *      \return         The number of bytes written to the port or -1 on error
 */
static int cwrite (int fd, byte* buf, int numbytes)
{
        int i, numwritten = 0, n = 0, numzeroes = 0;

        //write (fd, (buf + numwritten), (numbytes - numwritten));

        while (numwritten < numbytes)
        {
                n = write (fd, (buf + numwritten), (numbytes - numwritten));
                if (n < 0)
                        return -1;
                if (0 == n)
                {
                        numzeroes++;
                        if (3 < numzeroes)
                                break;
                }
                numwritten += n;
        }
               
        if (debug)
        {
                printf ("Write: ");
                for (i = 0; i < numwritten; i++)
                        printf ("%d ", buf[i]);
                printf ("\nWrote %d of %d bytes\n", numwritten, numbytes);
        }
       
        return numwritten;
}

/** \brief Read data from the Create
 *
 *      Reads data from the Create's serial port.  This function will
 *      continue reading from the port until the specified number of
 *      bytes has been read or until it reads nothing 3 times in a row
 *      (this can happen if you tell the function to read more data
 *      than the Create has available).  If this limit is reached, the
 *      buffer will contain what was read up to that point and the
 *      function will return the number of bytes read up to that
 *      point.  Use this instead of the OS-specific read function when
 *      reading from the Create.
 *
 *      \param  fd                      The file descriptor for serial port
 *      \param  buf                     The buffer to read the data into
 *      \param  numbytes        The number of bytes to read
 *
 *      \return The number of bytes read from the serial port or -1 on
 *      error
 */
static int cread (int fd, byte* buf, int numbytes)
{
        int i, numread = 0, n = 0, numzeroes = 0;
       
        while (numread < numbytes)
        {
                n = read (fd, (buf + numread), (numbytes - numread));
                if (n < 0)
                        return -1;
                if (0 == n)
                {
                        numzeroes++;
                        if (3 < numzeroes)
                                break;
                }
                numread += n;
        }
       
        if (debug)
        {
                printf ("Read:   ");
                for (i = 0; i < numread; i++)
                        printf ("%d ", buf[i]);
                printf ("\nRead %d of %d bytes\n", numread, numbytes);
        }
           
        tcflush (fd, TCIFLUSH);                 //discard data that was not read
        return numread;
}
