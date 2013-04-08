/*Definitions*/
%top{
#ifndef CGT_H
unsigned current_line=1;
#endif
#include "extern.h"
#include "hmap.h"
}

%option noyywrap


letter [a-zA-Z]
digit [0-9]
alphanum[a-zA-Z_0-9]
%%

" " { 
	/* Ignore space */
}

"\t" {
	/* Ignore tab */
}

"\n" {
	current_line++;
	/* Ignore new line */
}

"{".*"}" { 
	/* Ignore comments. */
} 

"begin" {
	printf("%s - KEYWORD_BEGIN\n", yytext);	
}

"end" {
	printf("%s - KEYWORD_END\n", yytext);
}

"const" {
	printf("%s - KEYWORD_CONST\n", yytext);
}

"if" {
	printf("%s - KEYWORD_IF\n", yytext);
}

"else" {
	printf("%s - KEYWORD_ELSE\n", yytext);
}

"procedure" {
	printf("%s - KEYWORD_PROCEDURE\n", yytext);
}

"then" {
	printf("%s - KEYWORD_THEN\n", yytext);
}

"var" {
	printf("%s - KEYWORD_VAR\n", yytext);
}

"while" {
	printf("%s - KEYWORD_WHILE\n", yytext);
}

"for" {
	printf("%s - KEYWORD_FOR\n", yytext);
}

"to" {
	printf("%s - KEYWORD_TO\n", yytext);
}

"do" {
	printf("%s - KEYWORD_DO\n", yytext);
}

"repeat" {
	printf("%s - KEYWORD_REPEAT\n", yytext);
}

"until" {
	printf("%s - KEYWORD_UNTIL\n", yytext);
}

"real" {
	printf("%s - KEYWORD_REAL\n", yytext);
}

"integer" {
	printf("%s - KEYWORD_INTEGER\n", yytext);
}

"program" {
	printf("%s - KEYWORD_PROGRAM\n", yytext);
} 

"+" {
	printf("%s - OPERATOR_PLUS\n", yytext);
}

"-" {
	printf("%s - OPERATOR_MINUS\n", yytext);
}

"*" {
	printf("%s - OPERATOR_MUL\n", yytext);
}

"/" {
	printf("%s - OPERATOR_DIV\n", yytext);
}

":=" {
	printf("%s - OPERATOR_ATRIB\n", yytext);
}

"=" {
	printf("%s - OPERATOR_EQUAL\n", yytext);
}

"<>" {
	printf("%s - OPERATOR_NEQUAL\n", yytext);
}

"<" {
	printf("%s - OPERATOR_LESSER\n", yytext);
}

">" {
	printf("%s - OPERATOR_GREATER\n", yytext);
}

"<=" {
	printf("%s - OPERATOR_LEQUAL\n", yytext);
}

">=" {
	printf("%s - OPERATOR_GEQUAL\n", yytext);
}

";" {
	printf("%s - PONCTUATOR_SEMICOLON\n", yytext);
}

"." {
	printf("%s - PONCTUATOR_PERIOD\n", yytext);
}

"(" {
	printf("%s - PONCTUATOR_LPAREN\n", yytext);
}

")" {
	printf("%s - PONCTUATOR_RPAREN\n", yytext);
}

{letter}{alphanum}* {
	printf("%s - IDENTIFIER\n", yytext);
	if (hmap_search(map, yytext, &empty_block) == FAILURE)
		hmap_insert(map, yytext, &empty_block);
}

{digit}+ {
	printf("%s - CONSTANT_INTEGER\n", yytext);
}

{digit}+\.{digit}+ {
	printf("%s - CONSTANT_FLOAT\n", yytext);
}

. {
	printf("Invalid char at line %u\n", current_line);
}
%%
/*C Code*/
