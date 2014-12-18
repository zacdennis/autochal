#include "iClient.h"


void startClient() {
   int i;
  unsigned char ttl = 1;
  struct sockaddr_in cliAddr;
  struct hostent *h;
  sd=0;
  rc=0;

  h = gethostbyname(CREATE_GROUP);
  if(h==NULL) {
    printf("iClient : unknown host '%s'\n",CREATE_GROUP);
    exit(1);
  }

  servAddr.sin_family = h->h_addrtype;
  memcpy((char *) &servAddr.sin_addr.s_addr, h->h_addr_list[0],h->h_length);
  servAddr.sin_port = htons(SERVER_PORT);

  /* create socket */
  sd = socket(AF_INET,SOCK_DGRAM,0);
  if (sd<0) {
    printf("iClient : cannot open socket\n");
    exit(1);
  }

  /* Get wlan0 address */
  struct ifreq ifr;
  int fd = socket(AF_INET, SOCK_DGRAM, 0);
  ifr.ifr_addr.sa_family = AF_INET;
  strncpy(ifr.ifr_name, "wlan0", IFNAMSIZ-1);
  ioctl(fd, SIOCGIFADDR, &ifr);
  
  /* bind any port number */
  cliAddr.sin_family = AF_INET;
  cliAddr.sin_addr.s_addr = inet_addr(inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr)); //wlan0 address
  cliAddr.sin_port = htons(0);
  if(bind(sd,(struct sockaddr *) &cliAddr,sizeof(cliAddr))<0) {
    perror("bind");
    exit(1);
  }

  if(setsockopt(sd,IPPROTO_IP,IP_MULTICAST_TTL, &ttl,sizeof(ttl))<0) {
    printf("iClient : cannot set ttl = %d \n",ttl);
    exit(1);
  }

  printf("iClient : sending data on multicast group '%s' (%s)\n",
	 h->h_name,inet_ntoa(*(struct in_addr *) h->h_addr_list[0]));
}

void viewClientStatus(create_status* local) {
  printf("iClient: sending status %s, POS[%d,%d]\n", local->uid, local->pos_x, local->pos_y);

  create_status packet;
  packet.pos_x = local->pos_x;
  packet.pos_y = local->pos_y;
  packet.heading = local->heading;
  packet.velocity = local->velocity;
  packet.category = local->category;
  memcpy(packet.uid, local->uid, strlen(local->uid)+1);

  printf("iClient: sending packet %s, POS[%d,%d]\n", packet.uid, packet.pos_x, packet.pos_y);
}

void sendStatus(create_status*tmp)
{
  create_status packet;
  packet.pos_x = tmp->pos_x;
  packet.pos_y = tmp->pos_y;
  packet.heading = tmp->heading;
  packet.velocity = tmp->velocity;
  packet.category = tmp->category;
  memset(packet.uid, 0, 32);
  memcpy(packet.uid, tmp->uid, strlen(tmp->uid)+1);


  char buff[54];
  memset(buff, 0, 54);
  memset(buff, MSG_TYPE_STATUS, 1); //initialize message type

  memcpy(buff+1, (create_status *) &packet, sizeof(packet));
  
  /*printf("iClient: sending packet %s, POS[%d,%d]\n", packet.uid, packet.pos_x, packet.pos_y);*/
  //rc = sendto(sd,(create_status *) &packet,sizeof(packet),0,(struct sockaddr *) &servAddr, sizeof(servAddr));
  rc = sendto(sd, buff, 54, 0, (struct sockaddr *) &servAddr, sizeof(servAddr));
  if (rc<0) {
  	printf("iClient : cannot send data\n");
  	close(sd);
  	exit(1);
  }
}

void closeClient() {
   close(sd);
}




