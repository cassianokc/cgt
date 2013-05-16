%code top{
#include <stdio.h>
#include "common.h"
#include "extern.h"
#include "cgt.h"
#include "hmap.h"
#include "lexer.tab.h"
}
%union
{
int val_integer;
float val_float;
char val_string[ID_SIZE];
}

%token<val_integer> VAL_INTEGER
%token<val_float> VAL_FLOAT
%token<val_string> VAL_STRING
%token KEYWORD_BEGIN 
%token KEYWORD_END
%token KEYWORD_CONST
%token KEYWORD_IF
%token KEYWORD_ELSE
%token KEYWORD_PROCEDURE
%token KEYWORD_THEN
%token KEYWORD_VAR
%token KEYWORD_WHILE
%token KEYWORD_FOR
%token KEYWORD_TO
%token KEYWORD_DO
%token KEYWORD_REPEAT
%token KEYWORD_UNTIL
%token KEYWORD_REAL
%token KEYWORD_INTEGER
%token KEYWORD_PROGRAM
%token OPERATOR_PLUS
%token OPERATOR_MINUS
%token OPERATOR_MUL
%token OPERATOR_DIV
%token OPERATOR_ATRIB
%token OPERATOR_EQUAL
%token OPERATOR_NEQUAL
%token OPERATOR_LESSER
%token OPERATOR_GREATER
%token OPERATOR_LEQUAL
%token OPERATOR_GEQUAL
%token PUNCTUATOR_SEMICOLON
%token PUNCTUATOR_COMMA
%token PUNCTUATOR_PERIOD
%token PUNCTUATOR_LPAREN
%token PUNCTUATOR_RPAREN
%token PUNCTUATOR_DDOTS
%start s
%%


s:VAL_STRING {

}


%%

int yyerror(char *s)
{
	printf("ERRO\n");
	return 1;
}
