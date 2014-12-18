#include <stdlib.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include "libIMU.h"
#include <sys/time.h>
#include <pthread.h>
#include <semaphore.h>

#define CYCLE_TIME 20000  //delay (in mircoseconds) between readings in MT mode.

static int fd = 0;                      ///< file descriptor for serial port
FILE* fd_out = NULL;
static int THREAD_MODE = 0;            ///multi-thread mode status.
pthread_mutex_t imu_sensor_cache_mutex;    ///locks sensor cache struct
pthread_mutex_t imu_mutex;          ///locks i/o for create

pthread_t imu_sensor_thread;
void *sensorThreadFunction( void *ptr );
void *sensorThreadFunctionStandalone( void *ptr );

sem_t * sem_imu;

static int iread (int fd, byte* buf, int numbytes);
static float Deg180(float deg);
static float RangeGyro(float gyro);
static float Range4G(float accel);

#define Gyro_Gain_X 0.0076 
#define Gyro_Gain_Y 0.0076
#define Gyro_Gain_Z 0.0076

typedef struct {
	float gyroX;
	float gyroY;
	float gyroZ;
	float accelX;
	float accelY;
	float accelZ;
	float rll; //roll
	float pch; //pitch
	float yaw; //yaw
	double time_stamp;
	int shut_down;
} sensor_cache_t;

/* getTime() - returns current system time in seconds as a double.
 */
double getImuTime(){
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

sensor_cache_t* sensor_cache;


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
int startIMU (char* serial)
{
        struct termios options;
        byte cmd[1];

        pthread_mutex_init(&imu_mutex, NULL);
       
       
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
                cfsetispeed (&options, B38400); //IMU baud rate              
                cfsetospeed (&options, B38400); 
                //send options back to fd
                tcsetattr (fd, TCSANOW, &options);              
        }

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
int startIMU_MT (char* serial)
{
        if (startIMU(serial) != 0)
                return -1;

        THREAD_MODE = 1;
	fd_out = fopen("DefaultOut.txt", "w");
	if(fd_out == NULL)
	{
		fprintf(stderr, "Failed to open output file\n");
		exit(-1);
	}
        pthread_mutex_init(&imu_sensor_cache_mutex, NULL);
        sensor_cache = (sensor_cache_t*) malloc(sizeof(sensor_cache_t));
        sensor_cache->shut_down = 0;
        pthread_create( &imu_sensor_thread, NULL, sensorThreadFunctionStandalone, NULL);
        usleep(500000);//give sensor thread time to get valid readings.
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
int startIMU_MTS (char* serial, sem_t * sem_input)
{
        if (startIMU(serial) != 0)
                return -1;

        THREAD_MODE = 1;
        sem_imu = sem_input;
	fd_out = fopen("DefaultOut.txt", "w");
	if(fd_out == NULL)
	{
		fprintf(stderr, "Failed to open output file\n");
		exit(-1);
	}
        pthread_mutex_init(&imu_sensor_cache_mutex, NULL);
        sensor_cache = (sensor_cache_t*) malloc(sizeof(sensor_cache_t));
        sensor_cache->shut_down = 0;
        pthread_create( &imu_sensor_thread, NULL, sensorThreadFunction, NULL);
        usleep(500000);//give sensor thread time to get valid readings.
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
int startIMU_File (char* serial, char* file_name)
{
        if (startIMU(serial) != 0)
                return -1;

        THREAD_MODE = 1;
	fd_out = fopen(file_name, "w");
	if(fd_out == NULL)
	{
		fprintf(stderr, "Failed to open output file\n");
		exit(1);
	}
        pthread_mutex_init(&imu_sensor_cache_mutex, NULL);
        sensor_cache = (sensor_cache_t*) malloc(sizeof(sensor_cache_t));
        sensor_cache->shut_down = 0;
        pthread_create( &imu_sensor_thread, NULL, sensorThreadFunctionStandalone, NULL);
        usleep(500000);//give sensor thread time to get valid readings.
}

/** Thread responsible for handling sensor loop in multi-threaded mode.
 *
 */
void *sensorThreadFunction( void *ptr )
{
        int done = 0;

        while (!done) {
		sem_wait(sem_imu);
                float * data = readIMUData();
		pthread_mutex_lock( &imu_sensor_cache_mutex );
		if(data != NULL) {
                   sensor_cache->time_stamp = getImuTime();
                   sensor_cache->gyroX = data[0];
                   sensor_cache->gyroY = data[1];
                   sensor_cache->gyroZ = data[2];
                   sensor_cache->accelX = data[3];
                   sensor_cache->accelY = data[4];
                   sensor_cache->accelZ =  data[5];
		   sensor_cache->rll = data[6];
		   sensor_cache->pch = data[7];
		   sensor_cache->yaw = data[8];
		   //printf ("Read data:   %.2f %.2f %.2f Rll: %.2f Pch: %.2f Yaw: %.2f\n", sensor_cache->gyroX, sensor_cache->gyroY, sensor_cache->gyroZ, sensor_cache->rll, sensor_cache->pch, sensor_cache->yaw);
		   fprintf(fd_out,"%.4f,%.2f,%.2f,%.2f,%.3f,%.3f,%.3f\n", sensor_cache->time_stamp, sensor_cache->gyroX, sensor_cache->gyroY, sensor_cache->gyroZ, sensor_cache->accelX, sensor_cache->accelY, sensor_cache->accelZ);
		}
		done = sensor_cache->shut_down;
		//if(done)
		//   printf("Done: %d\n",done);
		pthread_mutex_unlock( &imu_sensor_cache_mutex );
		if(data!=NULL) free(data);
                //usleep(CYCLE_TIME);
        }
        pthread_exit(NULL);
}

/** Thread responsible for handling sensor loop in multi-threaded mode.
 *
 */
void *sensorThreadFunctionStandalone( void *ptr )
{
        int done = 0;

        while (!done) {
                float * data = readIMUData();
		pthread_mutex_lock( &imu_sensor_cache_mutex );
		if(data != NULL) {
                   sensor_cache->time_stamp = getImuTime();
                   sensor_cache->gyroX = data[0];
                   sensor_cache->gyroY = data[1];
                   sensor_cache->gyroZ = data[2];
                   sensor_cache->accelX = data[3];
                   sensor_cache->accelY = data[4];
                   sensor_cache->accelZ =  data[5];
		   sensor_cache->rll = data[6];
		   sensor_cache->pch = data[7];
		   sensor_cache->yaw = data[8];
		   fprintf(fd_out,"%.4f,%.2f,%.2f,%.2f,%.3f,%.3f,%.3f\n", sensor_cache->time_stamp, sensor_cache->gyroX, sensor_cache->gyroY, sensor_cache->gyroZ, sensor_cache->accelX, sensor_cache->accelY, sensor_cache->accelZ);
		}
		done = sensor_cache->shut_down;
		pthread_mutex_unlock( &imu_sensor_cache_mutex );
		if(data!=NULL) free(data);
                usleep(CYCLE_TIME);
        }
        pthread_exit(NULL);
}

/** \brief      Get data from all sensors
 *
 *      Returns a pointer to the data from all sensors in the Create.
 *      Sensors are in the order given in the CreateOI specification,
 *      starting with Bumps and Wheel Drops.
 *
 *      \return   Pointer to array of sensor data or a NULL pointer on error.
 */
float* readIMUData()
{
	byte buf[32];

	float* result = (float*)malloc(9*sizeof(float));
        int i, numread;
       
        if (NULL == result)
        {
                //fprintf (stderr, "Could not read IMU data:  Memory allocation failed\n");
                return NULL;
        }

	memset(buf,0,32*sizeof(byte));
	memset(result,0,9*sizeof(float));

	numread = iread(fd,buf,32);
	if(numread < 32)
	{
                //fprintf (stderr, "Could not get all IMU data\n");
                free (result);
                return NULL;
        }

	//first 4 bytes are header "DIYd"
	//then 06 02 header bytes

	if(buf[4] !=6 && buf[5]!=2) {//NEED TO DEBUG WHY SOMETIMES SOMETHING ELSE IS OUTPUT
		//fprintf(stderr, "Invalid header data\n");
		free(result);		
		return NULL; //invalid data read
	}

	//check checksums
	byte current_msg_checksum_a = 0;
	byte current_msg_checksum_b = 0;
	for(i=4; i<30; i++)
	{
		current_msg_checksum_a += buf[i];
		current_msg_checksum_b += current_msg_checksum_a;
	}
	if(current_msg_checksum_a != buf[30] ||
	   current_msg_checksum_b != buf[31])
	{
		//fprintf(stderr, "Invalid checksums!\n");
		free(result);
		return NULL;
	}

	//12 bytes of analog data before roll, pitch, yaw
	result[0] = RangeGyro(((buf[7]<<8) | buf[6])/100.0); //gyroX
	result[1] = RangeGyro(((buf[9]<<8) | buf[8])/100.0); //gyroY
	result[2] = RangeGyro(((buf[11]<<8) | buf[10])/100.0);//gyroZ
	result[3] = Range4G(((buf[15]<<24) | (buf[14]<<16) | (buf[13]<<8) | buf[12])/1000.0);//accelX
	result[4] = Range4G(((buf[19]<<24) | (buf[18]<<16) | (buf[17]<<8) | buf[16])/1000.0);//accelY
	result[5] = Range4G(((buf[23]<<24) | (buf[22]<<16) | (buf[21]<<8) | buf[20])/1000.0);//accelZ
	result[6] = Deg180(((buf[25]<<8) | buf[24])/100.0); //roll
	result[7] = Deg180(((buf[27]<<8) | buf[26])/100.0); //pitch
	result[8] = Deg180(((buf[29]<<8) | buf[28])/100.0);//yaw

	//last two bytes are check sums (byte 12 & 13)

	//printf("Debug: AccelZ: %d %d %d %d\n", buf[20],buf[21],buf[22],buf[23]);

	return result;
}

/**     \brief  Stops the Create and closes connection to it
 *
 *      Stops the Create and closes the serial connection to it.  The
 *      connection can be restarted by calling the startOI command.
 *
 *      \return         0 if successful or -1 otherwise
 */
int stopIMU_MT ()
{      
        pthread_mutex_lock( &imu_sensor_cache_mutex );
        sensor_cache->shut_down = 1;
        pthread_mutex_unlock( &imu_sensor_cache_mutex );
       
        pthread_join(imu_sensor_thread, NULL);

        pthread_mutex_destroy(& imu_sensor_cache_mutex);

        if (stopIMU()  !=0)
                return -1;
       
        return 0;
}

/**     \brief  Stops the Create and closes connection to it
 *
 *      Stops the Create and closes the serial connection to it.  The
 *      connection can be restarted by calling the startOI command.
 *
 *      \return         0 if successful or -1 otherwise
 */
int stopIMU ()
{              

        pthread_mutex_destroy(&imu_mutex);

        close (fd);
	fclose(fd_out);
        fd = 0;
	fd_out = NULL;
        return 0;
}

double getTimeStamp() {
	return sensor_cache->time_stamp;
}

float getRoll() {
	return sensor_cache->rll;
}

float getPitch() {
	return sensor_cache->pch;
}

float getYaw() {
	return sensor_cache->yaw;
}

float getGyroX() {
	return sensor_cache->gyroX;
}

float getGyroY() {
	return sensor_cache->gyroY;
}

float getGyroZ() {
	return sensor_cache->gyroZ;
}

float getAccelX() {
	return sensor_cache->accelX;
}

float getAccelY() {
	return sensor_cache->accelY;
} 
float getAccelZ() {
	return sensor_cache->accelZ;
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
static int iread (int fd, byte* buf, int numbytes)
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
       
        /*if (debug)
        {
                printf ("Read:   ");
                for (i = 0; i < numread; i++)
                        printf ("%d ", buf[i]);
                printf ("\nRead %d of %d bytes\n", numread, numbytes);
        }*/
           
        tcflush (fd, TCIFLUSH);                 //discard data that was not read
        return numread;
}

static float Deg180(float deg)
{
	float result = deg;
	if(deg>180)
		result -= 360;
	if(deg<-180)
		result += 360;
	return result;
}

static float RangeGyro(float gyro)
{
	float result = gyro;
	if(gyro>250)
		result -= 500;
	if(gyro<-250)
		result += 500;
	return result;
}

static float Range4G(float accel)
{
	float result = accel;
	if(accel>4)
		result -= 8;
	if(accel<-4)
		result += 8;
	return result;
}

