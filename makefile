CC=gcc
CCFLAGS=-std=c99 -march=native -mtune=native -Os -Wall -Wextra -pedantic
CLFLAGS=

all: hmap.o lexer.o cgt.o
	$(CC) $^ $(CLFLAGS) -o cgt

lexer.o: lexer.c common.h
	$(CC) $(CCFLAGS) $< -c

lexer.c: lexer.l
	lex --outfile=lexer.c --header-file=lexer.h lexer.l

hmap.o: hmap.c hmap.h common.h
	$(CC) $(CCFLAGS) $< -c

cgt.o: cgt.c common.h
	$(CC) $(CCFLAGS) $< -c

#Removes all tildes ending files, objects codes and test executable
clean:
	rm -rf *~ *.o .*.swp cgt gmon.out lexer.c lexer.h 
