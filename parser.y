%{
	// Includes selecionados para o arquivo C
	#include <stdio.h>
	#include "common.h"
	#include "extern.h"
	#include "cgt.h"
	#include "hmap.h" 
	#include "lexer.tab.h"

	typedef struct {
		char op[5];
		int value;
	} OP;

	struct val
{
	unsigned context;
	unsigned type;
};


	
	FILE *f;
	OP c[1024];
	int opCount;

	int yyerror(char *s);
	void codeInit();
	void codeGenerationWithoutValue(char *op);
	void codeGeneration(char *op, int value);
	void printCode();
	void openFile();
	void closeFile();
%}

// Union com os possiveis tipos para as variaveis, integer, real e string
%union YYSTYPE {
		struct val_integer
		{
			unsigned context;
			unsigned type;
			int val;
		} val_integer;
		struct val_float
		{
			unsigned context;
			unsigned type;
			float val;
		} val_float;
		struct val_string
		{
			unsigned context;
			unsigned type;
			char val[ID_SIZE];
		} val_string;
		struct val_info{
			unsigned context;
			unsigned type;
		} val_info;

}

// Tokens obtidas no analisador lexico, que serao utilizados nas regras da gramatica
// Identificadores
%token<val_integer> VAL_INTEGER
%token<val_float> VAL_FLOAT
%token<val_string> VAL_STRING
// Palavras reservadas
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
// Operadores
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
// Pontuacoes
%token PUNCTUATOR_SEMICOLON
%token PUNCTUATOR_COMMA
%token PUNCTUATOR_PERIOD
%token PUNCTUATOR_LPAREN
%token PUNCTUATOR_RPAREN
%token PUNCTUATOR_DDOTS
// Token de erro
%token LEX_ERROR

// Tipos dos não terminais.
%type <val_info> tipo_var
%type <val_info> variaveis
// Simbolo inicial da linguagem
%start programa
%expect 6

%% // Regras da LALG

// <programa> ::= program ident ; corpo .
programa:
KEYWORD_PROGRAM VAL_STRING PUNCTUATOR_SEMICOLON corpo PUNCTUATOR_PERIOD { codeGenerationWithoutValue("INPP"); printCode();}
| error VAL_STRING PUNCTUATOR_SEMICOLON corpo PUNCTUATOR_PERIOD { yyerrok; printf("and 'program' was expected.\n"); }
| KEYWORD_PROGRAM VAL_STRING error corpo PUNCTUATOR_PERIOD { yyerrok; printf("and ';' was expected.\n"); }
| KEYWORD_PROGRAM VAL_STRING PUNCTUATOR_SEMICOLON corpo error { yyerrok; printf("and '.' was expected.\n"); }
;

// <corpo> ::= <dc> begin <comandos> end
corpo:
dc KEYWORD_BEGIN comandos KEYWORD_END
| dc error comandos KEYWORD_END { yyerrok; printf("and 'begin' was expected.\n"); } 
| dc KEYWORD_BEGIN comandos error { yyerrok; printf("and 'end' was expected.\n"); }
;

// <dc> ::= <dc_c> <dc_v> <dc_p>
dc:
dc_c dc_v dc_p
;

// <dc_c> ::= const ident = <numero> ; <dc_c> | λ
dc_c:
KEYWORD_CONST VAL_STRING OPERATOR_EQUAL numero PUNCTUATOR_SEMICOLON dc_c
| KEYWORD_CONST VAL_STRING error numero PUNCTUATOR_SEMICOLON dc_c { yyerrok; printf("and ':=' was expected.\n"); }
| KEYWORD_CONST VAL_STRING OPERATOR_EQUAL numero error dc_c { yyerrok; printf("and ';' was expected.\n"); }
| 
;

// <dc_v> ::= var <variaveis> : <tipo_var> ; <dc_v> | λ
dc_v:
KEYWORD_VAR variaveis PUNCTUATOR_DDOTS tipo_var PUNCTUATOR_SEMICOLON dc_v 
{
	$2.type = $4.type;	
}
| KEYWORD_VAR variaveis error tipo_var PUNCTUATOR_SEMICOLON dc_v { yyerrok; printf("and ':' was expected.\n"); }
| KEYWORD_VAR variaveis PUNCTUATOR_DDOTS tipo_var error dc_v { yyerrok; printf("and ';' was expected.\n"); }
|
;

// <tipo_var> ::= real | integer
tipo_var:
KEYWORD_REAL
{
	$$.type = TYPE_INT;
}
| KEYWORD_INTEGER
{
	$$.type = TYPE_FLOAT;
}
| error { yyerrok; printf("and 'integer' or 'real' were expected.\n"); }
;

// <variaveis> ::= ident <mais_var>
variaveis:
VAL_STRING mais_var
{
	$$.type = $1.type;
}
;

// <mais_var> ::= , <variaveis> | λ
mais_var:
PUNCTUATOR_COMMA variaveis
|
;

// <dc_p> ::= procedure ident <parametros> ; <corpo_p> <dc_p> | λ
dc_p :
KEYWORD_PROCEDURE VAL_STRING parametros PUNCTUATOR_SEMICOLON corpo_p dc_p
|
;

// <parametros> ::= ( <lista_par> ) | λ
parametros:
PUNCTUATOR_LPAREN lista_par PUNCTUATOR_RPAREN
| 
;

// <lista_par> ::= <variaveis> : <tipo_var> <mais_par>
lista_par:
variaveis PUNCTUATOR_DDOTS tipo_var mais_par
| variaveis error tipo_var mais_par { yyerrok; printf("and ':' was expected.\n"); }
;

// <mais_par> ::= ; <lista_par> | λ
mais_par:
PUNCTUATOR_SEMICOLON lista_par
|
;

// <corpo_p> ::= <dc_loc> begin <comandos> end ;	
corpo_p:
dc_loc KEYWORD_BEGIN comandos KEYWORD_END PUNCTUATOR_SEMICOLON
| dc_loc KEYWORD_BEGIN comandos KEYWORD_END error { yyerrok; printf("and ';' was expected.\n"); }
| dc_loc KEYWORD_BEGIN comandos error PUNCTUATOR_SEMICOLON { yyerrok; printf("and 'end' was expected.\n"); }
;

// <dc_loc> ::= <dc_v>
dc_loc:
dc_v
;

// <lista_arg> ::= ( <argumentos> ) | λ
lista_arg:
PUNCTUATOR_LPAREN argumentos PUNCTUATOR_RPAREN
| 
;

// <argumentos> ::= ident <mais_ident>
argumentos:
VAL_STRING mais_ident
;

// <mais_ident> ::= ; <argumentos> | λ
mais_ident:
PUNCTUATOR_SEMICOLON argumentos
|
;

// <pfalsa> ::= else <cmd> | λ
p_falsa: KEYWORD_ELSE cmd
|
;

// <comandos> ::= <cmd> ; <comandos> | λ
comandos:
cmd PUNCTUATOR_SEMICOLON comandos
| error PUNCTUATOR_SEMICOLON comandos { yyerrok; printf("and it is not a valid command.\n"); }
| cmd error comandos { yyerrok; printf("and ';' was expected\n"); }
|
;

// <cmd> ::= read ( <variaveis> ) |
//		write ( <variaveis> ) |
//		while ( <condicao> ) do <cmd> |
//		if <condicao> then <cmd> <pfalsa> |
//		ident := <expressão> |
//		ident <lista_arg> |
//		begin <comandos> end
cmd:
KEYWORD_READ PUNCTUATOR_LPAREN variaveis PUNCTUATOR_RPAREN { codeGeneration("LEIT", 0); codeGeneration("ARMZ", 0); }
| KEYWORD_WRITE PUNCTUATOR_LPAREN variaveis PUNCTUATOR_RPAREN
| KEYWORD_WHILE PUNCTUATOR_LPAREN condicao PUNCTUATOR_RPAREN KEYWORD_DO cmd
| KEYWORD_IF condicao KEYWORD_THEN cmd p_falsa
| VAL_STRING OPERATOR_ATRIB expressao
| VAL_STRING lista_arg
| KEYWORD_BEGIN comandos KEYWORD_END
| KEYWORD_REPEAT comandos KEYWORD_UNTIL condicao
| KEYWORD_FOR VAL_STRING OPERATOR_ATRIB expressao KEYWORD_TO expressao KEYWORD_DO cmd
;

// <condicao> ::= <expressao> <relacao> <expressao>
condicao:
expressao relacao expressao
;

// <relacao> ::= = | <> | >= | <= | > | <
relacao:
OPERATOR_EQUAL
| OPERATOR_NEQUAL
| OPERATOR_GEQUAL
| OPERATOR_LEQUAL
| OPERATOR_LESSER
| OPERATOR_GREATER
| error { yyerrok; printf("and a valid operator was expected."); }; 
;

// <expressao> ::= <termo> <outros_termos>
expressao:
termo outros_termos
;

// <op_un> ::= + | - | λ
op_un:
OPERATOR_PLUS
| OPERATOR_MINUS
|
;

// <outros_termos> ::= <op_ad> <termo> <outros_termos> | λ
outros_termos:
op_ad termo outros_termos
|
;

// <op_ad> ::= + | -
op_ad:
OPERATOR_PLUS
| OPERATOR_MINUS
;

// <termo> ::= <op_un> <fator> <mais_fatores>
termo:
op_un fator mais_fatores
;

// <mais_fatores> ::= <op_mul> <fator> <mais_fatores> | λ
mais_fatores:
op_mul fator mais_fatores
|
;

// <op_mul> ::= * | /
op_mul:
OPERATOR_MUL
| OPERATOR_DIV
;

// <fator> ::= ident | <numero> | ( <expressao> )
fator:
VAL_STRING
| numero
| PUNCTUATOR_LPAREN expressao PUNCTUATOR_RPAREN
;

// <numero> ::= numero_int | numero_real
numero:
VAL_INTEGER
| VAL_FLOAT
| error { yyerrok; printf("and a number was expected."); }
;

%%

// Funcao chamada em caso de erro - imprime a porcao inicial das mensagens de erro - o restante (qual simbolo foi encontrado),
//	eh impresso localmente nos tratamentos de erros
int yyerror(char *s)
{
	printf("Syntatic error at line %u: found '%s' ", current_line, yytext);
	return 1;
}

void codeInit() {
	opCount = 0;	
}

void codeGenerationWithoutValue(char *op) {
	strcpy(c[opCount].op, op);
	c[opCount].value = NULL;
	opCount++; 
}

void codeGeneration(char *op, int value) {
	strcpy(c[opCount].op, op);
	c[opCount].value = value;
	opCount++; 
}

void printCode() {
	int i;
	for(i = 0; i < opCount; i++) {
		printf("%s %d\n", c[i].op, c[i].value);
	}
}

void openFile() {
	f = fopen("code.txt","w");
}

void closeFile() {
	fclose(f);
}
