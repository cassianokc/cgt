#include "cgt.h"
#include "lexer.h"
#include "hmap.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>

unsigned long hash(const void *a)
{
	return *((unsigned long *)a)%MAP_SIZE;
}

int main(int argc, char **argv)
{
	struct hmap *map;
	map = hmap_init(ID_SIZE*sizeof(char), ID_SIZE*sizeof(char), MAP_SIZE, hash);
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
