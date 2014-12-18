/*Example two processes comunicating via shared memory: shm_server.c, shm_client.c

We develop two programs here that illustrate the passing of a simple piece of memery (a string) between the processes if running simulatenously:

shm_server.c
    -- simply creates the string and shared memory portion.
shm_client.c
    -- attaches itself to the created shared memory portion and uses the string (printf.

The code listings of the 2 programs no follow:*/

/******************* shm_server.c ***********************************/

#include "struct_shared_type.h"

SHMSZ = 27;

main()
{
    /*char c;*/
    SASC_STRUCT *temp, *shm;
    *temp.in0 = 1.0;
    *temp.in1 = 2.0;
    *temp.in2 = 3.0;

    /*
     * Create the segment.
     */
    if ((shmid = shmget(key, SHMSZ, IPC_CREAT | 0666)) < 0) {
        perror("shmget failed");
        /*exit(1);*/
    }

    /*
     * Now we attach the segment to our data space.
     */
    if ((shm = shmat(shmid, NULL, 0)) == (char *) -1) {
        perror("shmat failed");
        /*exit(1);*/
    }

    /*
     * Now put some things into the memory for the
     * other process to read.
     */
    s = shm;

    /*for (c = 'a'; c <= 'z'; c++)
        *s++ = c;*/
    *s = NULL;

    /*
     * Finally, we wait until the other process
     * changes the first character of our memory
     * to '*', indicating that it has read what
     * we put there.

     */
    while (*shm != '*')
        sleep(1);

    exit(0);
}

