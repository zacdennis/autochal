#define G18           global18_
#define BLOCK_SIZE    16384       /* Memory block size */
#define G18_KEY       0xFA18EF18  /* GLOBAL 18 */

struct g18 {
    float   in0;
    float   in1;
    float   in2;
    /*float   g18fill;*/        /* fill till end of 4K block*/
};
extern struct g18 global18_;
