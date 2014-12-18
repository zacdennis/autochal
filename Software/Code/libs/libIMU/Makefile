# This is a very simple Makefile for compiling and installing
# COIL.
#
# This file might change as my Makefile-writing skills improve,
# but it at least should be enough to get the basic things going
# for people who are happy with the default settings.
#

AR = ar
CC = gcc -g
INSTALL = /usr/local/lib
INCLUDE = /usr/local/include
LIBS = -lpthread -lIMU

.PHONY:  default all install uninstall clean

default: all

install: libIMU.a libIMU.h
	cp $< $(INSTALL)
	cp libIMU.h $(INCLUDE)
	ranlib $(INSTALL)/libIMU.a

all: libIMU.o
	$(AR) rcs libIMU.a $<

libIMU.o: libIMU.c libIMU.h
	$(CC) -c -o libIMU.o $<

uninstall:
	rm $(INSTALL)/libIMU.a
	rm $(INCLUDE)/libIMU.h

clean:
	rm libIMU.a
	rm libIMU.o
