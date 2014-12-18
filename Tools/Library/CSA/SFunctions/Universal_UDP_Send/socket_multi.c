/*
NORTHROP GRUMMAN PRIVATE/PROPRIETARY LEVEL I
*/

/*#define WINDOWS //Take this line out if you're using LINUX*/

#ifdef WINDOWS
/**************************** WINDOWS SOCKET CODE *************************/
// Include the WinSock library
#pragma comment(lib, "WS2_32.Lib")

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <winsock2.h>

#ifndef	INADDR_NONE
#define	INADDR_NONE	0xffffffff
#endif	/* INADDR_NONE */
#define WSVERS	MAKEWORD(2,0)


/*------------------------------------------------------------------------
 * connectsock - allocate & connect a socket using TCP or UDP
 *------------------------------------------------------------------------
 */
int connectsock(const char *host, const char *service, const char *transport )
{
	struct hostent	*phe;	/* pointer to host information entry	*/
	struct servent	*pse;	/* pointer to service information entry	*/
	struct protoent *ppe;	/* pointer to protocol information entry*/
	struct sockaddr_in sin;	/* an Internet endpoint address		*/
	int	s, type;	/* socket descriptor and socket type	*/

	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;

    /* Map service name to port number */
	if ( pse = getservbyname(service, transport) )
		sin.sin_port = pse->s_port;
	else if ( (sin.sin_port = htons((u_short)atoi(service))) == 0 )
		printf("can't get \"%s\" service entry\n", service);

    /* Map host name to IP address, allowing for dotted decimal */
	if ( phe = gethostbyname(host) )
		memcpy(&sin.sin_addr, phe->h_addr, phe->h_length);
	else if ( (sin.sin_addr.s_addr = inet_addr(host)) == INADDR_NONE)
		printf("can't get \"%s\" host entry\n", host);

    /* Map protocol name to protocol number */
	if ( (ppe = getprotobyname(transport)) == 0)
		printf("can't get \"%s\" protocol entry\n", transport);
    /* Use protocol to choose a socket type */
	if (strcmp(transport, "udp") == 0)
		type = SOCK_DGRAM;
	else
		type = SOCK_STREAM;

    /* Allocate a socket */
	s = socket(PF_INET, type, ppe->p_proto);
	if (s == INVALID_SOCKET)
		printf("can't create socket: %d\n", GetLastError());

    /* Connect the socket */
	if (connect(s, (struct sockaddr *)&sin, sizeof(sin)) ==
	    SOCKET_ERROR)
		printf("can't connect to %s.%s: %d\n", host, service,
			GetLastError());
	return s;
}
/**************************** END WINDOWS CODE ****************************/

#else
/*************************** LINUX SOCKET CODE ****************************/
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <sys/errno.h>
#include <stdio.h>

unsigned short portbase = 0;

int connectsock(const char *host, const char *service, const char *transport )
/*
 * Arguments:
 *      host      - name of host to which connection is desired
 *      service   - service associated with the desired port
 *      transport - name of transport protocol to use ("tcp" or "udp")
 */
{
        struct hostent  *phe;   /* pointer to host information entry    */
        struct servent  *pse;   /* pointer to service information entry */
        struct protoent *ppe;   /* pointer to protocol information entry*/
        struct sockaddr_in sin; /* an Internet endpoint address         */
        int     s, type;        /* socket descriptor and socket type    */


        memset(&sin, 0, sizeof(sin));
        sin.sin_family = AF_INET;

    /* Map service name to port number */
        if ( pse = getservbyname(service, transport) )
                sin.sin_port = pse->s_port;
        else if ((sin.sin_port=htons((unsigned short)atoi(service))) == 0) {
                printf( "can't get \"%s\" service entry\n", service);
                exit(EXIT_FAILURE);
        }

    /* Map host name to IP address, allowing for dotted decimal */
        if ( phe = gethostbyname(host) ) {
                memcpy(&sin.sin_addr, phe->h_addr, phe->h_length);
        }
        else if ( (sin.sin_addr.s_addr = inet_addr(host)) == INADDR_NONE ) {
                printf( "can't get \"%s\" host entry\n", host);
                exit(EXIT_FAILURE);
        }    

	/* Map transport protocol name to protocol number */
        if ( (ppe = getprotobyname(transport)) == 0) {
                printf( "can't get \"%s\" protocol entry\n", transport);
                exit(EXIT_FAILURE);
        }

    /* Use protocol to choose a socket type */
        if (strcmp(transport, "udp") == 0)
                type = SOCK_DGRAM;
        else
                type = SOCK_STREAM;
    /* Allocate a socket */
        s = socket(PF_INET, type, ppe->p_proto);
        if (s < 0) {
                printf( "can't create socket: %s\n", strerror(errno));
                exit(EXIT_FAILURE);
        }
    /* Connect the socket */
        if (connect(s, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
                printf( "can't connect to %s.%s: %s\n", host, service, strerror(errno));
                exit(EXIT_FAILURE);
        }

        return s;
}
/************************************** END LINUX CODE *************************************/
#endif


/************************************* START OF APPLICATION CODE **************************/
/*#define IP "157.127.200.71"
#define PORT "40000"

int main() {
	int socket, rtn;
	char msg[50];

#ifdef WINDOWS
	WSADATA wsadata;
	if(WSAStartup(WSVERS, &wsadata))
		printf("WSAStartup failed\n");
#endif

	printf("Start of program\n");

	socket = connectsock(IP, PORT, "udp");

	//send
	sprintf(msg, "Sparky == Stinky");
	rtn = send(socket, msg, sizeof(msg), 0);
	printf("rtn: %i\n", rtn);

	return 0;

}*/

