
#include "iServer.h"
#include "iClient.h"
#include "ini.h"
#include "InnerLoop.h"
#include "Utilities.h"
#include "sched.h"


#include "createoi.h"
#include "libIMU.h"

#include <signal.h>
//#include <sys/time.h>
#include <semaphore.h> 
#include <time.h>
#include <pthread.h>
#include <curses.h>
#include <math.h>

#define MAX(a,b)        (a > b? a : b)
#define MIN(a,b)        (a < b? a : b)

int shutdown_sys; //variable to signal system shutdown of each thread
int execute_sys; //variable to execute the system
sem_t sem_50Hz, sem_2Hz;
sem_t sem_create_m, sem_imu_m;


#define NSEC_PER_SEC 1000000000ULL
static inline void timespec_add_us(struct timespec *t, uint64_t d)
{
    d *= 1000;
    d += t->tv_nsec;
    while (d >= NSEC_PER_SEC) {
        d -= NSEC_PER_SEC;
	t->tv_sec += 1;
    }
    t->tv_nsec = d;
}

void broadcastStatus();

void* func_50Hz(void* arg) //signal sensors to poll data
{
   while(!shutdown_sys) {
	sem_wait(&sem_50Hz);
        //signal create
        sem_post(&sem_create_m);
	//signal IMU
	sem_post(&sem_imu_m);
   }
   stopOI_MT();
   stopIMU_MT();
   return NULL;
}

void* func_2Hz(void* arg) //broadcast position
{
   while(!shutdown_sys)
   {
	sem_wait(&sem_2Hz);
	broadcastStatus();
   }
   return NULL;
}

// Function schedules different rate tasks to execute by posting semaphores as a signal to run.
void *execute(void *arg)
{
    struct timespec next;
    long us = 10000;  //100Hz
    long cnt = 0;

    long hz_50 = 20000 / us;
    long hz_2  = 500000 / us;
    while (execute_sys) 
    {
	clock_gettime(CLOCK_REALTIME, &next);
        timespec_add_us(&next, us);

	if(cnt % hz_50 == 0)
		sem_post(&sem_50Hz);

	if(cnt % hz_2 == 0)
		sem_post(&sem_2Hz);


	cnt = cnt + 1;
	if(cnt == 1000)
		cnt = 0;

        clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME,&next, NULL);

    }
    printf("execute return\n");
    return NULL;


}



create_status client_status;

void broadcastStatus() {
   
   sendStatus(&client_status);
}

static int handler(void* user, const char* section, const char* name,
                   const char* value)
{
    create_status* pconfig = (create_status*)user;

    #define MATCH(s, n) strcmp(section, s) == 0 && strcmp(name, n) == 0
    if (MATCH("Initial Pos", "pos_x")) {
        pconfig->pos_x = atoi(value);
    } else if (MATCH("Initial Pos", "pos_y")) {
        pconfig->pos_y = atoi(value);
    } else if (MATCH("Initial Pos", "category")) {
        pconfig->category = atoi(value);
    } else if (MATCH("Initial Pos", "uid")) {
        memset(pconfig->uid,0,32);
        memcpy(pconfig->uid,strdup(value), strlen(strdup(value)));
    } else {
        return 0;  /* unknown section/name, error */
    }
    return 1;
}


int main(int argc, char* argv[]) {

   execute_sys = 1;
   shutdown_sys = 0;

   printf("Initializing Create IO...\n");
   startOI_MTS("/dev/ttyO0", &sem_create_m);

   printf("Initializing IMU...\n");
   startIMU_MTS("/dev/ttyUSB0", &sem_imu_m);

   printf("Starting server...\n");
   startServer();
   usleep(5000000);

   printf("Starting client...\n");
   startClient();
   usleep(5000000);


   pthread_t th_50Hz, th_2Hz, th_sched;
   //finish setting up threads here
   pthread_attr_t my_attr;
   struct sched_param param_2hz, param_50hz, param_scheduler;
   pthread_attr_init(&my_attr);
   pthread_attr_setschedpolicy(&my_attr, SCHED_FIFO);
   param_scheduler.sched_priority = 1;
   param_50hz.sched_priority = 2;
   param_2hz.sched_priority = 3;

   int retval = pthread_attr_setinheritsched(&my_attr,PTHREAD_EXPLICIT_SCHED);
   if(retval)
	printf("error with pthread_attr_setinheritsched : %d\n",retval); 

   // Starting 2Hz thread
   retval = pthread_attr_setschedparam(&my_attr, &param_2hz);
   if(retval)
	printf("error with pthread_attr_setschedparam param_2hz : %d\n",retval);
   retval = pthread_create(&th_2Hz, &my_attr, func_2Hz, 0);
   if(retval)
	printf("error with pthread_create rate_2hz : %d\n",retval);

   // Starting 50Hz thread
   retval = pthread_attr_setschedparam(&my_attr, &param_50hz);
   if(retval)
	printf("error with pthread_attr_setschedparam param_50hz : %d\n",retval);
   retval = pthread_create(&th_50Hz, &my_attr, func_50Hz, 0);
   if(retval)
	printf("error with pthread_create rate_50hz : %d\n",retval);

   //starting scheduler thread
   retval = pthread_attr_setschedparam(&my_attr, &param_scheduler);
   if(retval)
	printf("error with pthread_attr_setschedparam param_scheduler : %d\n",retval);
   retval = pthread_create(&th_sched, &my_attr, execute, 0);
   if(retval)
	printf("error with pthread_create execute : %d\n",retval);


   //initialize status from file
   printf("Initializing location...\n");
    if (ini_parse("create.ini", handler, &client_status) < 0) {
        printf("Can't load 'create.ini'\n");
        return 1;
    }

   printf("%s starting at POS[%d,%d]\n", client_status.uid, client_status.pos_x, client_status.pos_y);

   printf("Hit s to begin...\n");
   int c;
   while((c=getchar())!='s') //TODO fix THIS
	continue;

   WINDOW *win;
   int not_done = 1;
   char robo_name[40];
   int len;
   gethostname(robo_name, len);

   //setup ncurses
   initscr();
   clear();
   noecho();
   cbreak();      
   win = newwin(24, 80, 0, 0);
   keypad(win, TRUE);
   wtimeout(win,100);

   //loop variables
   int speed = 0;//store user input.
   int turn = 0;
   int velocity = 0; //values sent to the create
   int radius = 0;
   int charge;

   float Pn_mm = 0;
   float Pe_mm = 0;
   float Vn_mmps = 0;
   float Ve_mmps = 0;

   float roll = 0;
   float pitch = 0;
   float yaw = 0;
   float create_distance = 0;
   float delta_t = 0.1;
   int cycle_count  = 1;

   float Pn_cmd = 2000;
   float Pe_cmd = -2000;
   float Speed = 0;
   float FlightPath_deg = 0;
   float Heading_deg = 0;

   SpeedCmd       = 300;
   HeadingCmd_deg = -45;
   float yaw_cmd  = 45;

   WheelSpeedCmd = 0;
   TurnRadiusCmd = 0;

   dist_PnPe = 0;

   while(not_done) {
      erase();
      charge = getCharge();
      roll = getRoll();
      pitch = getPitch();
      yaw = getYaw();
      create_distance = readSensor(SENSOR_DISTANCE);
      updatePositionVelCreate(&Pn_mm, &Pe_mm, &Vn_mmps, &Ve_mmps, yaw, create_distance, delta_t);
      Vned2VGammaChi(&Speed, &FlightPath_deg, &Heading_deg, Vn_mmps, Ve_mmps, 0);

      mvwprintw(win, 0, 0, "%s Execution", robo_name);
      mvwprintw(win, 2, 0, "'q' to quit.");
      mvwprintw(win, 4, 0, "Battery Charge: %d%%", charge);

      mvwprintw(win, 5, 0, "Euler: Roll %.2f, Pitch %.2f, Yaw %.2f", roll, pitch, yaw);
      mvwprintw(win, 6, 0, "Create Position: Pn %.2f, Pe %.2f", Pn_mm, Pe_mm);
      mvwprintw(win, 7, 0, "Create Velocity: Vn %.2f, Ve %.2f", Vn_mmps, Ve_mmps);

      mvwprintw(win, 9,  0, "Speed      : Cmd %.2f, Actual %.2f", SpeedCmd, Speed);
      mvwprintw(win, 10, 0, "Heading    : Cmd 0, Actual %.2f", Heading_deg);
      mvwprintw(win, 11, 0, "Flight Path: Cmd 0, Actual %.2f", FlightPath_deg);

      mvwprintw(win, 13, 0, "Yaw: Cmd %.2f, Actual %.2f", yaw_cmd, yaw);

      mvwprintw(win, 15, 0, "Drive Cmds: WheelSpeedCmd %.2f, TurnRadiusCmd %.2f", WheelSpeedCmd, TurnRadiusCmd);
      refresh();
      //print out any additional data here
      
      //EXECUTE AUTONOMY CODE HERE

      c = wgetch(win);

      //EXAMPLE AUTONOMY CODE THAT DRIVES THE ROBOT    
      switch(c){
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
      case 'q': //REQUIRED -- DO NOT REMOVE!
	not_done = 0;
        erase();
        refresh();
	break;
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
      drive(velocity,radius);

	// Inner Loop Control Functions
	if (1) {
		PositionCommand(Pn_cmd, Pe_cmd, Pn_mm, Pe_mm);

		if (dist_PnPe < 250 )  {
			SpeedCmd = 0;
			TurnRadiusCmd  = 0;
		}
	}

	if (SpeedCmd == 0) {
      		yawCommand(yaw, yaw_cmd);
        	drive(WheelSpeedCmd,TurnRadiusCmd);
	} else {
		SpeedHeadingCommand(SpeedCmd, HeadingCmd_deg, Speed, Heading_deg, delta_t, cycle_count);
		drive(WheelSpeedCmd,TurnRadiusCmd);
	}

	cycle_count = cycle_count + 1; if (cycle_count > 3) { cycle_count = 3; }
     //END EXAMPLE AUTONOMY CODE
	
      
   }

   endwin();

   printf("Closing Client\n");
   closeClient();
   printf("Closing Server\n");
   closeServer();

   shutdown_sys = 1;
   pthread_join(th_50Hz, NULL);
   pthread_join(th_2Hz, NULL);
   execute_sys = 0;
   pthread_join(th_sched, NULL);
   printf("Shutting down\n");

}
