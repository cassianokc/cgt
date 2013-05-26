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
	value=OPERATOR_PLUS;
	strcpy(key, "+");
	hmap_insert(map, key, &value);	
	value=OPERATOR_MINUS;
	strcpy(key, "-");
	hmap_insert(map, key, &value);	
	value=OPERATOR_MUL;
	strcpy(key, "*");
	hmap_insert(map, key, &value);	
	value=OPERATOR_DIV;
	strcpy(key, "/");
	hmap_insert(map, key, &value);	
	value=OPERATOR_ATRIB;
	strcpy(key, ":=");
	hmap_insert(map, key, &value);	
	value=OPERATOR_EQUAL;
	strcpy(key, "=");
	hmap_insert(map, key, &value);	
	value=OPERATOR_NEQUAL;
	strcpy(key, "<>");
	hmap_insert(map, key, &value);	
	value=OPERATOR_LESSER;
	strcpy(key, "<");
	hmap_insert(map, key, &value);	
	value=OPERATOR_GREATER;
	strcpy(key, ">");
	hmap_insert(map, key, &value);	
	value=OPERATOR_LEQUAL;
	strcpy(key, "<=");
	hmap_insert(map, key, &value);	
	value=OPERATOR_GEQUAL;
	strcpy(key, ">=");
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_SEMICOLON;
	strcpy(key, ";");
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_COMMA;
	strcpy(key, ",");
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_PERIOD;
	strcpy(key, ".");
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_LPAREN;
	strcpy(key, "(");
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_RPAREN;
	strcpy(key, ")");
	hmap_insert(map, key, &value);	
	value=PUNCTUATOR_DDOTS;
	strcpy(key, ":");
	hmap_insert(map, key, &value);	
}
