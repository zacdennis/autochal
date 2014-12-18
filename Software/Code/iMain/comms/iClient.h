/*
 * Functions to set up the multicast server to send status
 *
 */

#ifndef H_ICLIENT_GD
#define H_ICLIENT_GD


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

//client variables
struct sockaddr_in servAddr;
int sd;
int rc;


void startClient();
void sendStatus(create_status *tmp);
void closeClient();

#endif
