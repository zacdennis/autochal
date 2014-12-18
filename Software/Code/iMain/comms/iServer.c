

#include "iServer.h"

static int THREAD_MODE = 0;            ///multi-thread mode status.

void startServer() {
   pthread_mutex_init(&server_mutex, NULL); //probably do not need server mutex
   initializeServer();

   THREAD_MODE = 1;
   pthread_mutex_init(&status_cache_mutex, NULL);
   //sensor_cache = (status_cache*) malloc(sizeof(status_cache)); //initialize status cache?
   pthread_create( &server_thread, NULL, (void*)serverThreadFunc, NULL);
   printf("Started Server Thread\n");
}

void initializeServer()
{
  struct in_addr mcastAddr;
  struct hostent *h;
  sock = 0; 
  rc = 0;
  cliLen = 0;
  memset(read_buff, 0, 54);

  /* get mcast address to listen to */
  h=gethostbyname(CREATE_GROUP);
  if(h==NULL) {
    printf("iServer : unknown group '%s'\n",CREATE_GROUP);
    exit(1);
  }
  
  memcpy(&mcastAddr, h->h_addr_list[0],h->h_length);
  
  /* check given address is multicast */
  if(!IN_MULTICAST(ntohl(mcastAddr.s_addr))) {
    printf("iServer : given address '%s' is not multicast\n",
	   inet_ntoa(mcastAddr));
    exit(1);
  }

  /* create socket */
  sock = socket(AF_INET,SOCK_DGRAM,0);
  if(sock<0) {
    printf("iServer : cannot create socket\n");
    exit(1);
  }

  /* bind port */
  servAddr.sin_family=AF_INET;
  servAddr.sin_addr.s_addr=htonl(INADDR_ANY);
  servAddr.sin_port=htons(SERVER_PORT);  
  if(bind(sock,(struct sockaddr *) &servAddr, sizeof(servAddr))<0) {
    printf("iServer : cannot bind port %d \n",SERVER_PORT);
    exit(1);
  }

  /* Get wlan0 address */
  int fd = socket(AF_INET, SOCK_DGRAM, 0);
  ifr.ifr_addr.sa_family = AF_INET;
  strncpy(ifr.ifr_name, "wlan0", IFNAMSIZ-1);
  ioctl(fd, SIOCGIFADDR, &ifr);
  //printf("%s\n", inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr));

  /* join multicast group */
  mreq.imr_multiaddr.s_addr=mcastAddr.s_addr;
  mreq.imr_interface.s_addr= inet_addr(inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr)); //wlan0 address

  rc = setsockopt(sock,IPPROTO_IP,IP_ADD_MEMBERSHIP,
		  (void *) &mreq, sizeof(mreq));
  if(rc<0) {
    printf("iServer : cannot join multicast group '%s'\n",
	   inet_ntoa(mcastAddr));
    exit(1);
  }
  else {
    printf("iServer : listening to mgroup %s:%d\n",
	   inet_ntoa(mcastAddr), SERVER_PORT);
 }

 not_done = 1;
}

/** Thread responsible for handling sensor loop in multi-threaded mode.
 *
 */
void *serverThreadFunc( void *ptr )
{

   fd_set readReadySet;
   
    /* Set a 5 second time-out on the select */
    struct timeval timeOut;
    timeOut.tv_sec = 5L; //5 second time out
    timeOut.tv_usec = 0L;

    no_data = 1;

    /* infinite server loop */
    while(not_done) {
        FD_ZERO(&readReadySet);
        FD_SET(sock, &readReadySet);
        timeOut.tv_sec = 5L;
        timeOut.tv_usec = 0L;
	if(select(sock+1, &readReadySet, NULL, NULL, &timeOut) > 0) {
	   if (FD_ISSET(sock, &readReadySet))
   	   {
		no_data = 0;
     		cliLen=sizeof(cliAddr);
      		//int n = recvfrom(sock,(create_status *) &status,sizeof(status),0,(struct sockaddr *) &cliAddr, &cliLen);
		int n = recvfrom(sock, read_buff, 54, 0, (struct sockaddr *) &cliAddr, &cliLen);
      		if(n<0) {
			printf("iServer : cannot receive data\n");
			continue;
      		}
		if(inet_ntoa(cliAddr.sin_addr) == inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr))
			continue;
	pthread_mutex_lock( &status_cache_mutex);
	/*printf("iServer : received data from %s:%d on %s : %s at Pos[%d,%d,%d]\n",
	     inet_ntoa(cliAddr.sin_addr),ntohs(cliAddr.sin_port),
	     CREATE_GROUP,
	     status.uid, status.pos_x, status.pos_y, status.heading);*/
	int msg_type = 0;
	memcpy(&msg_type, read_buff, 1);
	switch(msg_type) {
	case MSG_TYPE_STATUS:
		memcpy((create_status *) &status, read_buff+1, sizeof(status));
		//add status to status cache map
        	put(&map_status, status.uid,status);
		break;
	case MSG_TYPE_TERMINATION:
		memcpy((asset_terminated *) &assetTerminated, read_buff+1, sizeof(assetTerminated));
		//check which asset was terminated
		break;
	case MSG_TYPE_DETECTION:
		memcpy((radar_detection *) &radarDetection, read_buff+1, sizeof(radarDetection));
		//check which asset was detected
		break;
        default:
		printf("iServer: unknown message type received\n");
		break;
	}
	memset(read_buff, 0, 54);
	pthread_mutex_unlock( &status_cache_mutex);
   	   } else {
		//printf("select timeout\n");
		continue; //timeout
           }
	}
    }/* end of infinite server loop */

    pthread_exit(NULL);
}

void closeServer ()
{      
   pthread_mutex_lock( &status_cache_mutex );
   not_done = 0;
   close(rc);
   rc = 0;
   shutdown(sock,SHUT_RDWR);
   sock = 0;
   pthread_mutex_unlock( &status_cache_mutex );
       
   pthread_join(server_thread, NULL);
   printf("Exiting Server...\n");
   pthread_mutex_destroy(& status_cache_mutex);
   pthread_mutex_destroy(&server_mutex);

   //TODO free any memory here
}

create_status* getStatus(char* uid)
{
   return find(&map_status, uid);
}

void put(Map *map, char* key, create_status value) {
   int index = findIndex(map, key);
   if(index<0)
	return;
   memcpy((char *) &map->list[index].key, key,strlen(key));
   memcpy((create_status*) &map->list[index].value, (create_status*) &value, sizeof(value));
}

static int compare(const void * p1, const void * p2)
{
    return strcmp(*((const char **)p1), *((const char **)p2));
}

int findIndex(Map *map, char* key) {
    struct item * item = bsearch(&key, robots, 10, sizeof(*robots),
        compare);

    return item ? item->value : -1;
}

create_status* find(Map* map, char* key) {
  int index = findIndex(map, key);
  if(index>=0)
	return &(map->list[index].value);
  return NULL;
}


