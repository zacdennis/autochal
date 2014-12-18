# This is a very simple Makefile for compiling COIL sample
# applications.

CC = gcc -g
LIBS = -lm -L/autochal/Software/Code/libs/libIMU -lIMU -L/autochal/Software/Code/libs/libcreateoi -lcreateoi -lpthread -lncurses
INCLUDE = -I/autochal/Software/Code/iMain/comms -I/autochal/Software/Code/iMain/utils -I/autochal/Software/Code/iMain/inih -I/autochal/Software/Code/libs/libcreateoi -I/autochal/Software/Code/libs/libIMU

default: all

all: iMain

iMain: main.c comms/iServer.c comms/iClient.c inih/ini.c utils/InnerLoop.c utils/Utilities.c
	$(CC) main.c comms/iServer.c comms/iClient.c inih/ini.c utils/InnerLoop.c utils/Utilities.c -o iMain $(INCLUDE) $(LIBS)


clean:
	rm -f *.o
	rm -f iMain
