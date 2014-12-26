# This is a very simple Makefile for compiling and installing
# sqlite.
#
#

AR = ar
CC = gcc -g
INCLUDE = /usr/local/include

.PHONY:  default all clean

default: all

all: sqlite3.o
	$(AR) rcs libSqlite3.a $<

sqlite3.o: sqlite3.c
	$(CC) -c -o sqlite3.o $<

clean:
	rm libSqlite3.a
	rm sqlite3.o
