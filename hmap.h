#ifndef HMAP_H
#define HMAP_H

#include "common.h"
#include <stdint.h>


/* A hash map data structure implementation, where data elements of
size elem_size are stored in a array and are acessed by passing a key
with size key_size to a hash function. The respective key and elements data are stored, in this order, in the hash map. It isn't possible to store elements containing only zeros or only ones, these are reserved markers.*/
struct hmap
{
	unsigned long map_size;
	unsigned long elem_size;
	unsigned long key_size;	
	void *map;
	unsigned long (*hash)(void *);
};

bool is_empty(void *, unsigned long);
bool is_deleted(void *, unsigned long);
struct hmap *hmap_init(unsigned long, unsigned long, unsigned long, unsigned long (*)(void *)); 
void hmap_free(struct hmap *);
int hmap_insert(struct hmap *, void *, void *);
int hmap_remove(struct hmap *, void *, void *);
int hmap_search(struct hmap *, void *, void*);


#endif
