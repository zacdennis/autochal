# This is a very simple Makefile for compiling COIL sample
# applications.


CC = gcc -g
INCLUDE = -I/autochal/Software/Code/libs/libcreateoi -I/autochal/Software/Code/libs/libIMU
LIBS = -lm -lncurses -L/autochal/Software/Code/libs/libcreateoi -lcreateoi -L/autochal/Software/Code/libs/libIMU -lIMU -lpthread
FLAGS = -L /lib64
CVFLAGS = $(shell pkg-config --libs opencv)  $(shell pkg-config --cflags opencv)

default: all


all: square drive tracker wander bumpCheck home #wanderCV

#wanderCV: wanderCV.c
#	$(CC) wanderCV.c -o wanderCV $(INCLUDE) $(FLAGS) $(LIBS) $(CVFLAGS)

image: cameraImage.c
	$(CC) cameraImage.c -o image $(INCLUDE) $(FLAGS) $(LIBS) $(CVFLAGS)

trackerCV: tracker.c tracker.h
	$(CC) -c -o trackerCV $< $(INCLUDE)

squareTmp: square.c
	$(CC) -c -o squareTmp $< $(INCLUDE)

square: square.c
	$(CC) square.c  $(INCLUDE) $(LIBS) -o square

drive: drive.c
	$(CC) drive.c $(INCLUDE) $(LIBS) -o drive

driveInnerLoop: driveInnerLoop.c
	$(CC) driveInnerLoop.c $(INCLUDE) $(LIBS) -o driveInnerLoop

driveStatus: driveIMU_PnPe_MultiCast.c
	$(CC) driveIMU_PnPe_MultiCast.c $(INCLUDE) $(LIBS) -o driveStatus

wander: wander.c
	$(CC) wander.c $(INCLUDE) $(LIBS) $(CVFLAGS) -o wander
       
tracker: tracker.c
	$(CC) tracker.c $(INCLUDE) $(LIBS) $(CVFLAGS) -o tracker

bumpCheck: BumpCheck.c
	$(CC) BumpCheck.c $(INCLUDE) $(LIBS) -o bumpCheck

home: Home.c
	$(CC) Home.c $(INCLUDE) $(LIBS) -o home

clean:
	rm -f *.o
	rm -f square drive wander tracker bumpCheck home wanderCV
