
#ifndef H_CREATE_MS
#define H_CREATE_MS

#define MSG_TYPE_STATUS      1
#define MSG_TYPE_TERMINATION 2
#define MSG_TYPE_DETECTION   3

#define UNKNOWN          0
#define SURVEILLOBOMBER  1
#define SUVALIENCE       2
#define BOMBER           3
#define JAMMER           4
#define FIGHTER_FRIENDLY 5
#define FIGHTER_ENEMY    6

typedef struct {
        int pos_x;
        int pos_y;
        int heading;
        int velocity;
        int category;
	char uid[32]; //fixed length name
} create_status;

typedef struct {
	char uid[32];
} asset_terminated;

typedef struct {
	char uid[32];
} radar_detection;

#endif
