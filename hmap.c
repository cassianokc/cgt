#include "hmap.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool is_empty(void *elem, unsigned long size)
{
	register unsigned long i;
	for (i=0; i<size; i++)
	{
		if (((unsigned char *) elem)[i] != 0x00)
			return FALSE;
	}
	return TRUE;
}

bool is_deleted(void *elem, unsigned long size)
{
	register unsigned long i;
	for (i=0; i<size; i++)
	{
		if (((unsigned char *) elem)[i] != 0xff)
			return FALSE;
	}
	return TRUE;
}

struct hmap *hmap_init(unsigned long map_size, unsigned long elem_size, unsigned long key_size, unsigned long (*hash)(void *)) 
{
	struct hmap *map;
	map = malloc(sizeof(struct hmap));
	if (map == NULL)
		return NULL;
	map->map = malloc(map_size*(key_size+elem_size));
	if (map->map == NULL)
	{
		free(map);
		return NULL;
	}	
	map->map_size = map_size;
	map->key_size = key_size;
	map->elem_size = elem_size;
	map->hash = hash;
	return map;
}

void hmap_free(struct hmap *map)
{
	free(map->map);
	free(map);
}

int hmap_insert(struct hmap *map, void *key, void *elem)
{
	unsigned long i=0, index=map->hash(key);
	unsigned char *aux = map->map;
	while (!is_empty(&aux[(index+i)%map->map_size], map->key_size+map->elem_size)||!is_deleted(&aux[(index+i)%map->map_size], map->key_size+map->elem_size))
	{
		if (i==map->map_size)
			return FAILURE;
		i++;
	}
	memcpy(&aux[(index+i)%map->map_size], key, map->key_size);
	memcpy(&aux[(index+i)%map->map_size]+map->key_size, elem, map->elem_size);
	return SUCCESS;	
}

int hmap_remove(struct hmap *map, void *key, void *elem)
{
	unsigned long i=0, index=map->hash(key);
	unsigned char *aux = map->map;
	while (!is_empty(&aux[(index+i)%map->map_size], map->key_size+map->elem_size)&&i!=map->map_size)
	{
		if (memcmp(&aux[(index+i)%map->map_size], key, map->key_size == 0))
		{
			memcpy(elem, &aux[(index+i)%map->map_size]+map->key_size, map->elem_size);
			memset(&aux[(index+i)%map->map_size], 0xff, map->key_size+map->elem_size);
			return SUCCESS;
		}
		i++;
	}
	return FAILURE;
}

int hmap_search(struct hmap *map, void *key, void *elem)
{
	unsigned long i=0, index=map->hash(key);
	unsigned char *aux = map->map;
	while (!is_empty(&aux[(index+i)%map->map_size], map->key_size+map->elem_size)&&i!=map->map_size)
	{
		if (memcmp(&aux[(index+i)%map->map_size], key, map->key_size == 0))
		{
			memcpy(elem, &aux[(index+i)%map->map_size]+map->key_size, map->elem_size);
			return SUCCESS;
		}
		i++;
	}
	return FAILURE;
}

