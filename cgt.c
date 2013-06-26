#include "cgt.h"
#include "lexer.tab.h"
#include "parser.tab.h"
#include "hmap.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>

struct hmap *wk_table;
struct hmap *sym_table;
unsigned current_line=1;


int main(void)
{
	wk_table = hmap_init(MAP_SIZE, 15*sizeof(char), sizeof(int), hash);
	init_wk_table(wk_table);
	sym_table = hmap_init(MAP_SIZE, ID_SIZE*sizeof(char), sizeof(struct var), hash);
	yyparse();
	hmap_free(wk_table);
	hmap_free(sym_table);
	return SUCCESS;
}

unsigned long hash(const void *a)
	/* 	Calculates the hash of a null terminated string by using some magic
	 * numbers.
	 */
{
	const unsigned char *str = a;
	unsigned long hash = 5381;
	int c;
	while ((c = *str++))
		hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
	return (hash)%MAP_SIZE;
}

void init_wk_table(struct hmap *map)
{
	char key[ID_SIZE];
	int value;
	value=KEYWORD_READ;
	strcpy(key, "read");
	hmap_insert(map, key, &value);
    	value=KEYWORD_WRITE;
	strcpy(key, "write");
	hmap_insert(map, key, &value);
	value=KEYWORD_BEGIN;
	strcpy(key, "begin");
	hmap_insert(map, key, &value);	
	value=KEYWORD_END;
	strcpy(key, "end");
	hmap_insert(map, key, &value);	
	value=KEYWORD_CONST;
	strcpy(key, "const");
	hmap_insert(map, key, &value);	
	value=KEYWORD_IF;
	strcpy(key, "if");
	hmap_insert(map, key, &value);	
	value=KEYWORD_ELSE;
	strcpy(key, "else");
	hmap_insert(map, key, &value);	
	value=KEYWORD_PROCEDURE;
	strcpy(key, "procedure");
	hmap_insert(map, key, &value);	
	value=KEYWORD_THEN;
	strcpy(key, "then");
	hmap_insert(map, key, &value);	
	value=KEYWORD_VAR;
	strcpy(key, "var");
	hmap_insert(map, key, &value);	
	value=KEYWORD_WHILE;
	strcpy(key, "while");
	hmap_insert(map, key, &value);	
	value=KEYWORD_FOR;
	strcpy(key, "for");
	hmap_insert(map, key, &value);	
	value=KEYWORD_TO;
	strcpy(key, "to");
	hmap_insert(map, key, &value);	
	value=KEYWORD_DO;
	strcpy(key, "do");
	hmap_insert(map, key, &value);	
	value=KEYWORD_REAL;
	strcpy(key, "real");
	hmap_insert(map, key, &value);	
	value=KEYWORD_INTEGER;
	strcpy(key, "integer");
	hmap_insert(map, key, &value);	
	value=KEYWORD_PROGRAM;
	strcpy(key, "program");
	hmap_insert(map, key, &value);	
}
