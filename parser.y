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
	{ unsigned context; unsigned type; };

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
	int hmap_insert(struct hmap *map, void *key, void *data);
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
%type <val_info> mais_var
%type <val_info> outras_variaveis
%type <val_info> outras_mais_var
%type <val_info> dc_p
%type <val_info> condicao
%type <val_info> expressao
%type <val_info> termo
%type <val_info> fator
%type <val_info> numero
%type <val_info> outros_termos
%type <val_info> mais_fatores
// Simbolo inicial da linguagem
%start programa
%expect 6

%% // Regras da LALG

// <programa> ::= program ident ; corpo .
programa:
KEYWORD_PROGRAM VAL_STRING PUNCTUATOR_SEMICOLON corpo PUNCTUATOR_PERIOD { }
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
KEYWORD_CONST VAL_STRING OPERATOR_EQUAL numero PUNCTUATOR_SEMICOLON dc_c { codeGeneration("ALME", 1); }
| KEYWORD_CONST VAL_STRING error numero PUNCTUATOR_SEMICOLON dc_c { yyerrok; printf("and ':=' was expected.\n"); }
| KEYWORD_CONST VAL_STRING OPERATOR_EQUAL numero error dc_c { yyerrok; printf("and ';' was expected.\n"); }
| 
;

// <dc_v> ::= var <variaveis> : <tipo_var> ; <dc_v> | λ
dc_v:
KEYWORD_VAR variaveis PUNCTUATOR_DDOTS tipo_var PUNCTUATOR_SEMICOLON dc_v { codeGeneration("ALME", 1); }
| KEYWORD_VAR variaveis error tipo_var PUNCTUATOR_SEMICOLON dc_v { yyerrok; printf("and ':' was expected.\n"); }
| KEYWORD_VAR variaveis PUNCTUATOR_DDOTS tipo_var error dc_v { yyerrok; printf("and ';' was expected.\n"); }
|
;

// <tipo_var> ::= real | integer
tipo_var:
KEYWORD_REAL
{
	struct symbol sym;
	while (!squeue_is_empty(undeclared_vars))
	{
		squeue_remove(undeclared_vars, &sym);
		sym.type = TYPE_FLOAT;
		hmap_update(sym_table, sym.key, &sym);

	}
}
| KEYWORD_INTEGER
{
	struct symbol sym;
	while (!squeue_is_empty(undeclared_vars))
	{
		squeue_remove(undeclared_vars, &sym);
		sym.type = TYPE_INT;
		hmap_update(sym_table, sym.key, &sym);

	}
}
| error { yyerrok; printf("and 'integer' or 'real' were expected.\n"); }
;

// <variaveis> ::= ident <mais_var>
variaveis:
VAL_STRING mais_var
{
	struct symbol sym;
	if (hmap_search(sym_table, $1.val, &sym) == SUCCESS)
	{
		printf("Semantic error at line %u: Identifier %s has already been declared.\n", current_line, $1.val);
		found_error=TRUE;
	}
	else 
	{
		sym.context = current_context;
		sym.position = ++mem_position;
		strcpy(sym.key, $1.val);
		squeue_insert(undeclared_vars, &sym);
		hmap_insert(sym_table, &sym.key, &sym);
	}
}
;

// <mais_var> ::= , <variaveis> | λ
mais_var:
PUNCTUATOR_COMMA variaveis { codeGeneration("ALME", 1); }
|
;

// <dc_p> ::= procedure ident <parametros> ; <corpo_p> <dc_p> | λ
dc_p :
controle_contexto KEYWORD_PROCEDURE VAL_STRING parametros PUNCTUATOR_SEMICOLON corpo_p dc_p
{
	$$.type = $3.type;
	current_context=0;
}
|
;

controle_contexto:
{
	current_context++;
}
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
dc_v {
}
;

// <lista_arg> ::= ( <argumentos> ) | λ
lista_arg:
PUNCTUATOR_LPAREN argumentos PUNCTUATOR_RPAREN
| 
;

// <argumentos> ::= ident <mais_ident>
argumentos:
VAL_STRING mais_ident {
}
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

// <cmd> ::= read ( <outras_variaveis> ) |
//		write ( <outras_variaveis> ) |
//		while ( <condicao> ) do <cmd> |
//		if <condicao> then <cmd> <pfalsa> |
//		ident := <expressão> |
//		ident <lista_arg> |
//		begin <comandos> end
cmd:
KEYWORD_READ PUNCTUATOR_LPAREN outras_variaveis PUNCTUATOR_RPAREN { }
| KEYWORD_WRITE PUNCTUATOR_LPAREN outras_variaveis PUNCTUATOR_RPAREN
| KEYWORD_WHILE PUNCTUATOR_LPAREN condicao PUNCTUATOR_RPAREN KEYWORD_DO cmd
| KEYWORD_IF condicao KEYWORD_THEN cmd p_falsa
| VAL_STRING OPERATOR_ATRIB expressao { 
	struct symbol sym;
	if (hmap_search(sym_table, $1.val, &sym) == FAILURE)
	{
		printf("Semantic error at line %u: Undeclared identifier %s.\n", current_line, $1.val); 
		found_error=TRUE;
	}
	if (sym.type != $3.type)
	{
		printf("Semantic error at line %u: Atribution between different types.\n", current_line);
		found_error=TRUE;
	}
	if (sym.context != 0 && sym.context != current_context)
	{
		printf("Semantic error at line %u: Identifier %s used out of context.\n", current_line, sym.key);
		found_error=TRUE;
	}
}
| VAL_STRING lista_arg
| KEYWORD_BEGIN comandos KEYWORD_END
| KEYWORD_REPEAT comandos KEYWORD_UNTIL condicao
| KEYWORD_FOR VAL_STRING OPERATOR_ATRIB expressao KEYWORD_TO expressao KEYWORD_DO cmd
;

// <outras_variaveis> ::= ident <outras_mais_var>
outras_variaveis:
VAL_STRING outras_mais_var {
	struct symbol sym;
	hmap_search(sym_table, $1.val, &sym);
	if (sym.context != 0 && sym.context != current_context)
	{
		printf("Semantic error at line %u: Identifier %s used out of context.\n", sym.key);
		found_error=TRUE;
	}
	if (sym.type != $2.type && $2.type != TYPE_ALL)
	{
		printf("Semantic error at line %u: Read/Write variables must have the same type.\n", current_line);
		found_error=TRUE;
	}
	$$.type = sym.type;
}
;

// <outras_mais_var> ::= , <outras_variaveis> | λ
outras_mais_var:
PUNCTUATOR_COMMA outras_variaveis {
	$$.type = $2.type;
}
|
{
	$$.type = TYPE_ALL;
}
;

// <condicao> ::= <expressao> <relacao> <expressao>
condicao:
expressao relacao expressao {
	if ($1.type != $3.type)
	{
		printf("Semantic error at line %u: Comparison between different types.\n", current_line);
		found_error=TRUE;
	}
}
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
termo outros_termos {
	$$.type = $1.type;
}
;

// <op_un> ::= + | - | λ
op_un:
OPERATOR_PLUS
| OPERATOR_MINUS
|
;

// <outros_termos> ::= <op_ad> <termo> <outros_termos> | λ
outros_termos:
op_ad termo outros_termos {
	if ($2.type != $3.type&&$3.type!=TYPE_ALL)
	{
		printf("Semantic error at line %u: Sum or subtraction between different types.\n", current_line);
		found_error=TRUE;
	}
	$$.type = $2.type;
}
| {
	$$.type = TYPE_ALL;
}
;

// <op_ad> ::= + | -
op_ad:
OPERATOR_PLUS
| OPERATOR_MINUS
;

// <termo> ::= <op_un> <fator> <mais_fatores>
termo:
op_un fator mais_fatores {
	$$.type = $2.type;
}
;

// <mais_fatores> ::= <op_mul> <fator> <mais_fatores> | λ
mais_fatores:
op_mul fator mais_fatores {
	if ($2.type != $3.type&&$3.type!=TYPE_ALL)
	{
		printf("Semantic error at line %u: Multiplication or division between different types.\n", current_line);
		found_error=TRUE;
	}
	$$.type = $2.type;
}
|
{
	$$.type = TYPE_ALL;
}
;

// <op_mul> ::= * | /
op_mul:
OPERATOR_MUL
| OPERATOR_DIV
;

// <fator> ::= ident | <numero> | ( <expressao> )
fator:
VAL_STRING {
	struct symbol sym;
	if (hmap_search(sym_table, $1.val, &sym) == SUCCESS)
	{
		if (sym.context != 0 && sym.context != current_context)
		{
			printf("Semantic error at line %u: Identifier %s used out of context.\n", current_line, sym.key);
			found_error=TRUE;
		}
		$$.type = sym.type;
	}
	else {
		printf("Semantic error at line %u: Undeclared identifier %s.\n", current_line, $1.val);
		found_error=TRUE;
	}
}
| numero {
	$$.type = $1.type;
}
| PUNCTUATOR_LPAREN expressao PUNCTUATOR_RPAREN {
	$$.type = $2.type;
}
;

// <numero> ::= numero_int | numero_real
numero:
VAL_INTEGER {
	$$.type = TYPE_INT;
}
| VAL_FLOAT {
	$$.type = TYPE_FLOAT;
}
| error { yyerrok; printf("and a number was expected."); }
;

%%

// Funcao chamada em caso de erro - imprime a porcao inicial das mensagens de erro - o restante (qual simbolo foi encontrado),
//	eh impresso localmente nos tratamentos de erros
int yyerror(char *s)
{
	printf("Syntatic error at line %u: found '%s' ", current_line, yytext);
	found_error=TRUE;
	return 1;
}

void codeInit() {
	opCount = 0;
	codeGenerationWithoutValue("INPP");
}

void codeGenerationWithoutValue(char *op) {
	if(found_error == FALSE) {	
		strcpy(c[opCount].op, op);
		c[opCount].value = NULL;
		opCount++;
	}
}

void codeGeneration(char *op, int value) {
	if(found_error == FALSE) {	
		strcpy(c[opCount].op, op);
		c[opCount].value = value;
		opCount++;
	}
}

void printCode() {
	int i;
	for(i = 0; i < opCount; i++) {
		printf("%s", c[i].op);
		if(c[i].value != NULL)		
			printf(" %d\n", c[i].value);
		else
			printf("\n");
	}
}

void openFile() {
	f = fopen("code.txt","w");
}

void closeFile() {
	fclose(f);
}
