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
%token KEYWORD_READ
%token KEYWORD_WRITE
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
%start programa
%%


programa:KEYWORD_PROGRAM VAL_STRING PUNCTUATOR_SEMICOLON corpo ;
corpo: dc KEYWORD_BEGIN comandos KEYWORD_END ;
dc: dc_c dc_v dc_p ;
dc_c: KEYWORD_CONST VAL_STRING OPERATOR_EQUAL numero | ;
dc_v: KEYWORD_VAR variaveis PUNCTUATOR_DDOTS tipo_var PUNCTUATOR_SEMICOLON
	dc_v | ;
tipo_var: KEYWORD_REAL | KEYWORD_INTEGER ;
variaveis: VAL_STRING mais_var ;
mais_var: PUNCTUATOR_COMMA variaveis | 
dc_p : KEYWORD_PROCEDURE VAL_STRING parametros PUNCTUATOR_SEMICOLON corpo_p  dc_p |
dc_loc : dc_v ;
corpo_p : dc_loc KEYWORD_BEGIN comandos KEYWORD_END PUNCTUATOR_SEMICOLON ;
lista_arg : PUNCTUATOR_LPAREN argumentos PUNCTUATOR_RPAREN | 
mais_par : PUNCTUATOR_SEMICOLON lista_par |
lista_par : variaveis PUNCTUATOR_DDOTS tipo_var mais_par ;
parametros : PUNCTUATOR_LPAREN lista_par PUNCTUATOR_RPAREN | 
argumentos : VAL_STRING mais_ident ;
mais_ident : PUNCTUATOR_SEMICOLON argumentos |
p_falsa : KEYWORD_ELSE cmd |
comandos : cmd PUNCTUATOR_SEMICOLON comandos | 
cmd : KEYWORD_READ PUNCTUATOR_LPAREN variaveis PUNCTUATOR_LPAREN | 
	KEYWORD_WRITE PUNCTUATOR_LPAREN variaveis PUNCTUATOR_LPAREN | 
	KEYWORD_WHILE PUNCTUATOR_LPAREN condicao PUNCTUATOR_LPAREN KEYWORD_DO cmd | 
	KEYWORD_IF condicao KEYWORD_THEN cmd p_falsa |
	VAL_STRING PUNCTUATOR_DDOTS OPERATOR_EQUAL expressao|
	VAL_STRING lista_arg |
	KEYWORD_BEGIN comandos KEYWORD_END |
	KEYWORD_REPEAT comandos KEYWORD_UNTIL condicao |
	KEYWORD_FOR VAL_STRING PUNCTUATOR_DDOTS OPERATOR_EQUAL expressao expressao KEYWORD_DO cmd ;
	condicao : expressao relacao expressao
relacao : OPERATOR_EQUAL |
	OPERATOR_NEQUAL |
	OPERATOR_GEQUAL |
	OPERATOR_LEQUAL |
	OPERATOR_LESSER |
	OPERATOR_GREATER ;
expressao : termo outros_termos
op_un : OPERATOR_PLUS | OPERATOR_MINUS |
outros_termos : op_ad termo outros_termos |
op_ad : OPERATOR_PLUS | OPERATOR_MINUS ;
termo : op_un fator mais_fatores ;
mais_fatores : op_mul fator mais_fatores |
op_mul : OPERATOR_MUL | OPERATOR_DIV ;
fator : VAL_STRING | numero | PUNCTUATOR_LPAREN expressao PUNCTUATOR_LPAREN ;
numero : VAL_INTEGER | VAL_FLOAT ;
caracter : VAL_STRING 


	


	


%%

int yyerror(char *s)
{
	printf("ERRO\n");
	return 1;
}
