CC=gcc
CCFLAGS=-std=c99 -Wall -pedantic
CLFLAGS=
cgt: hmap.o cgt.o
	$(CC) $(CLFLAGS) $^ -o cgt

cgt.o: cgt.c common.h
	$(CC) $(CCFLAGS) $< -c

hmap.o: hmap.c hmap.h common.h
	$(CC) $(CCFLAGS) $< -c

	#Removes all tildes ending files, objects codes and test executable
clean:
	rm -rf *~ *.o .*.swp  test
