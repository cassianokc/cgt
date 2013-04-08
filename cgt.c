#include "cgt.h"
#include "lexer.h"
#include "hmap.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>

struct hmap *map;
char empty_block[ID_SIZE]; 

unsigned long hash(const void *a)
{
	const unsigned char *str = a;
	unsigned long hash = 5381;
	int c;
	while ((c = *str++))
		hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
	return (hash)%MAP_SIZE;
}

int main(int argc, char **argv)
{
	map = hmap_init(ID_SIZE*sizeof(char), ID_SIZE*sizeof(char), 
			MAP_SIZE, hash);
	if (map == NULL)
		return FAILURE;
	if (argc == 2)
	{
		printf("TODO: use %s file\n", argv[1]);
	}
	yylex();
	hmap_free(map);
	return SUCCESS;
}
