CC=gcc
CCFLAGS=-std=c99 -Os -Wall -Wextra -pedantic
CLFLAGS=

all: hmap.o parser.tab.o lexer.tab.o cgt.o
	$(CC) $^ $(CLFLAGS) -o cgt

lexer.tab.o: lexer.tab.c parser.tab.c common.h
	$(CC) $(CCFLAGS) $< -c

lexer.tab.c: lexer.l
	lex --outfile=lexer.tab.c --header-file=lexer.tab.h lexer.l

parser.tab.o: parser.tab.c lexer.tab.c common.h
	$(CC) $(CCFLAGS) $< -c

parser.tab.c: 
	yacc -d -b parser parser.y

hmap.o: hmap.c hmap.h common.h
	$(CC) $(CCFLAGS) $< -c

cgt.o: cgt.c common.h
	$(CC) $(CCFLAGS) $< -c

#Removes all tildes ending files, objects codes and test executable
clean:
	rm -rf *~ *.o .*.swp cgt gmon.out lexer.tab.c lexer.tab.h parser.tab.c parser.tab.h
