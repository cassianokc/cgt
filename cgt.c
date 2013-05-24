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
	yyparse();
	hmap_free(wk_table);
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
	value=KEYWORD_BEGIN;
	hmap_insert(map, key, &value);	
	value=KEYWORD_BEGIN;
	hmap_insert(map, key, &value);	
	value=KEYWORD_END;
	hmap_insert(map, key, &value);	
	value=KEYWORD_CONST;
	hmap_insert(map, key, &value);	
	value=KEYWORD_IF;
	hmap_insert(map, key, &value);	
	value=KEYWORD_ELSE;
	hmap_insert(map, key, &value);	
	value=KEYWORD_PROCEDURE;
	hmap_insert(map, key, &value);	
	value=KEYWORD_THEN;
	hmap_insert(map, key, &value);	
	value=KEYWORD_VAR;
	hmap_insert(map, key, &value);	
	value=KEYWORD_WHILE;
	hmap_insert(map, key, &value);	
	value=KEYWORD_FOR;
	hmap_insert(map, key, &value);	
	value=KEYWORD_TO;
	hmap_insert(map, key, &value);	
	value=KEYWORD_DO;
	hmap_insert(map, key, &value);	
	value=KEYWORD_REPEAT;
	hmap_insert(map, key, &value);	
	value=KEYWORD_UNTIL;
	hmap_insert(map, key, &value);	
	value=KEYWORD_REAL;
	hmap_insert(map, key, &value);	
	value=KEYWORD_INTEGER;
	hmap_insert(map, key, &value);	
	value=KEYWORD_PROGRAM;
	hmap_insert(map, key, &value);	
	value=OPERATOR_PLUS;
	hmap_insert(map, key, &value);	
	value=OPERATOR_MINUS;
	hmap_insert(map, key, &value);	
	value=OPERATOR_MUL;
	hmap_insert(map, key, &value);	
	value=OPERATOR_DIV;
	hmap_insert(map, key, &value);	
	value=OPERATOR_ATRIB;
	hmap_insert(map, key, &value);	
	value=OPERATOR_EQUAL;
	hmap_insert(map, key, &value);	
	value=OPERATOR_NEQUAL;
	hmap_insert(map, key, &value);	
	value=OPERATOR_LESSER;
	hmap_insert(map, key, &value);	
	value=OPERATOR_GREATER;
	hmap_insert(map, key, &value);	
	value=OPERATOR_LEQUAL;
	hmap_insert(map, key, &value);	
	value=OPERATOR_GEQUAL;
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_SEMICOLON;
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_COMMA;
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_PERIOD;
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_LPAREN;
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_RPAREN;
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_DDOTS;
	hmap_insert(map, key, &value);	
}
