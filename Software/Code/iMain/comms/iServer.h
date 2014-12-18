/*
 * Functions to set up the multicast server to listen for status
 *
 */

#ifndef H_ISERVER_GD
#define H_ISERVER_GD

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h> /* close */

#include "CreateMessageSet.h"

#define SERVER_PORT 1500
#define CREATE_GROUP "225.0.0.37"


//server variables
struct sockaddr_in servAddr;
struct sockaddr_in cliAddr;
struct ip_mreq mreq;
struct ifreq ifr;
create_status status;
asset_terminated assetTerminated;
radar_detection radarDetection;
char read_buff[54];
int sock; //initialize to 0 in constructor
int rc; //same
int cliLen;
int no_data;

struct item
{
    const char * name;
    int value;
};

//Keep sorted when adding new robots so can use binary search
static struct item robots[] =
{
    { "DarcLord", 0 },
    { "DarcMaster", 1 },
    { "HammerBot", 2 },
    { "HulkX90", 3 },
    { "SpinBot", 4 },
    { "SquashBot",5 },
    { "TrundleBot", 6 },
    { "Twitch", 7 },
    { "Twonky", 8 },
    { "ZoomBot", 9 }
};

//server data
typedef struct
{
   char key[32];
   create_status value;
} KeyValuePair;

typedef struct
{
   KeyValuePair list[10]; //make sure name/index mapping is in findIndex function
} Map;

void put(Map* map, char* key, create_status value);
static int compare(const void * p1, const void * p2);
int findIndex(Map* map, char* key); //TODO fix name value pairs to make indexing fast
create_status* find(Map* map, char* key);

Map map_status;

//theading variables
pthread_t server_thread;
pthread_mutex_t status_cache_mutex;    ///locks statud cache struct
pthread_mutex_t server_mutex;          ///locks i/o for server
int not_done;

void *serverThreadFunc( void *ptr );

void startServer(); //initialize server and create a separate thread to continuously listen for data
void initializeServer();
void closeServer();

//accessors
create_status* getStatus(char* uid);

#endif

