#include "cgt.h"
#include "lexer.tab.h"
#include "parser.tab.h"
#include "hmap.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>

unsigned current_line=1;
#ifdef BLAAAH
#define KEYWORD_BEGIN 1	
#define KEYWORD_END 2
#define KEYWORD_CONST 3
#define KEYWORD_IF 4
#define KEYWORD_ELSE 5
#define KEYWORD_PROCEDURE 6
#define KEYWORD_THEN 7
#define KEYWORD_VAR 8
#define KEYWORD_WHILE 9
#define KEYWORD_FOR 10
#define KEYWORD_TO 11
#define KEYWORD_DO 12
#define KEYWORD_REPEAT 13
#define KEYWORD_UNTIL 14
#define KEYWORD_REAL 15
#define KEYWORD_INTEGER 16
#define KEYWORD_PROGRAM 17
#define OPERATOR_PLUS 18
#define OPERATOR_MINUS 19
#define OPERATOR_MUL 20
#define OPERATOR_DIV 21
#define OPERATOR_ATRIB 22
#define OPERATOR_EQUAL 23
#define OPERATOR_NEQUAL 24
#define OPERATOR_LESSER 25
#define OPERATOR_GREATER 26
#define OPERATOR_LEQUAL 27
#define OPERATOR_GEQUAL 28
#define PUNCTUATOR_SEMICOLON 29
#define PUNCTUATOR_COMMA 30
#define PUNCTUATOR_PERIOD 31
#define PUNCTUATOR_LPAREN 32
#define PUNCTUATOR_RPAREN 33
#define PUNCTUATOR_DDOTS 34
#define IDENTIFIER 35
#define CONSTANT_INTEGER 36
#define CONSTANT_FLOAT 37
#endif




int main(void)
{
	struct hmap *map;
	map = hmap_init(MAP_SIZE, ID_SIZE*sizeof(char), sizeof(struct symbol), 
		hash);
	init_symbol_table(map);
	yyparse();
	hmap_free(map);
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

void init_symbol_table(struct hmap *map)
{
/*
	char key[ID_SIZE];
	struct symbol sym;
	sym.context=0;
	sym.type=KEYWORD_BEGIN;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_BEGIN;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_END;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_CONST;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_IF;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_ELSE;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_PROCEDURE;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_THEN;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_VAR;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_WHILE;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_FOR;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_TO;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_DO;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_REPEAT;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_UNTIL;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_REAL;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_INTEGER;
	hmap_insert(map, key, &sym);	
	sym.type=KEYWORD_PROGRAM;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_PLUS;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_MINUS;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_MUL;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_DIV;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_ATRIB;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_EQUAL;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_NEQUAL;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_LESSER;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_GREATER;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_LEQUAL;
	hmap_insert(map, key, &sym);	
	sym.type=OPERATOR_GEQUAL;
	hmap_insert(map, key, &sym);	
	sym.type=PUNCTUATOR_SEMICOLON;
	hmap_insert(map, key, &sym);	
	sym.type=PUNCTUATOR_COMMA;
	hmap_insert(map, key, &sym);	
	sym.type=PUNCTUATOR_PERIOD;
	hmap_insert(map, key, &sym);	
	sym.type=PUNCTUATOR_LPAREN;
	hmap_insert(map, key, &sym);	
	sym.type=PUNCTUATOR_RPAREN;
	hmap_insert(map, key, &sym);	
	sym.type=PUNCTUATOR_DDOTS;
	hmap_insert(map, key, &sym);	
*/
}
