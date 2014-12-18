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

.PHONY:  default all install uninstall clean docs

default: all

install: libcreateoi.a createoi.h
	cp $< $(INSTALL)
	cp createoi.h $(INCLUDE)
	ranlib $(INSTALL)/libcreateoi.a

all: createoi.o
	$(AR) rcs libcreateoi.a $<

createoi.o: createoi.c createoi.h
	$(CC) -c -o createoi.o $<

uninstall:
	rm $(INSTALL)/libcreateoi.a
	rm $(INCLUDE)/createoi.h

docs:
	@echo Not yet supported.  For now, use your favorite TeX editor to compile \
	manual.tex in the docs/ directory.

clean:
	rm libcreateoi.a
	rm createoi.o
