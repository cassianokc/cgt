#ifndef CGT_H
#define CGT_H

#define ID_SIZE 33
#define MAP_SIZE 1003

#include "hmap.h"

struct symbol
{
	int type;
	unsigned context;
};

unsigned long hash(const void *a);
void init_wk_table(struct hmap *map);

#endif
