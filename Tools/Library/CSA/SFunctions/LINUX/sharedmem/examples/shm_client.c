/*Example two processes comunicating via shared memory: shm_server.c, shm_client.c

We develop two programs here that illustrate the passing of a simple piece of memery (a string) between the processes if running simulatenously:

shm_server.c
    -- simply creates the string and shared memory portion.
shm_client.c
    -- attaches itself to the created shared memory portion and uses the string (printf.

The code listings of the 2 programs no follow:*/

/******************* shm_client.c ***********************************/

/*
 * shm-client - client program to demonstrate shared memory.
 */

#include "struct_shared_type.h"

main()
{

    /*
     * Locate the segment.
     */
    if ((shmid = shmget(key, SHMSZ, 0666)) < 0) {
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
     * Now read what the server put in the memory.
     */
    for (s = shm; *s != NULL; s++)
        putchar(*s);
    putchar('\n');

    /*
     * Finally, change the first character of the
     * segment to '*', indicating we have read
     * the segment.
     */
    *shm = '*';

    exit(0);
}
