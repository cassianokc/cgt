CC=gcc
CCFLAGS=-std=c99 -march=native -mtune=native -Os -Wall -Wextra -pedantic
CLD=


all: hmap.o

hmap.o: hmap.c hmap.h common.h
	$(CC) $(CCFLAGS) $< -c

#Removes all tildes ending files, objects codes and test executable
clean:
	rm -rf *~ *.o .*.swp utest gmon.out 
