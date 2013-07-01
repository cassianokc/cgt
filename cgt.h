#ifndef CGT_H
#define CGT_H

#define ID_SIZE 33
#define MAP_SIZE 1003

#include "hmap.h"

struct symbol
{
	unsigned type;
	unsigned position;
	bool context;
	char key[ID_SIZE];
};

#define TYPE_ALL 0
#define TYPE_INT 1
#define TYPE_FLOAT 2
#define TYPE_PROCEDURE 3

unsigned long hash(const void *a);
void init_wk_table(struct hmap *map);

#endif
