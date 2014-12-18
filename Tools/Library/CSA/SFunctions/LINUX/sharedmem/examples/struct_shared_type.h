/*#define G18           global18_
#define BLOCK_SIZE    16384       /* Memory block size */
/*#define KEY           0xFA18EF18  /* GLOBAL 18 */

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>

typedef struct{
    float   in0;
    float   in1;
    float   in2;
    /*float   sascfill;*/   /* fill till end of 4K block*/
}SASC_STRUCT;

/*extern struct g18 global18_;*/

/*#define SHMSZ     27*/
/*int size_of_floats = 3*sizeof(float);
#define SHMZ = size_of_floats;*/

int shmid;    
key_t key;      
/*char *shm, *s;*/
char *s;

/*
 * We need to make a segment named "5678", created by the server.
 * This is arbitrary and works as long as it is the same in the client.
 */
key = 5678;       
    

    