#ifndef H_IMU_GD
#define H_IMU_GD

#include <unistd.h>
#include <semaphore.h>


#ifdef __cplusplus
extern "C" {
#endif



/// 8-bit unsigned value.  Called "byte" to keep continuity with iRobot naming
/// (and so I don't have to write "unsigned char" all the time).
typedef unsigned char   byte;

int startIMU (char* serial);
int startIMU_MT (char* serial);
int startIMU_MTS (char* serial, sem_t *sem_input);
int startIMU_File (char* serial, char* file_name);
float* readIMUData ();
double getTimeStamp();
float getRoll();
float getPitch();
float getYaw();
float getGyroX();
float getGyroY();
float getGyroZ();
float getAccelX();
float getAccelY();
float getAccelZ();
int stopIMU ();
int stopIMU_MT ();

#ifdef __cplusplus
} /* closing brace for extern "C" */
#endif



#endif //H_IMU_GD

