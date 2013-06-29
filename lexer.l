/*Definitions*/
%top{
#include <stdio.h>
#include "cgt.h"
#include "extern.h"
#include "parser.tab.h"
extern YYSTYPE yylval;
}

%option noyywrap
letter [a-zA-Z]
digit [0-9]
alphanum [a-zA-Z_0-9]

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

"+" {
	return OPERATOR_PLUS;
}

"-" {
	return OPERATOR_MINUS;
}

"*" {
	return OPERATOR_MUL;
}

"/" {
	return OPERATOR_DIV;
}

":=" {
	return OPERATOR_ATRIB;
}

"=" {
	return OPERATOR_EQUAL;
}

"<>" {
	return OPERATOR_NEQUAL;
}

"<" {
	return OPERATOR_LESSER;
} 

">" {
	return OPERATOR_GREATER;
}

"<=" {
	return OPERATOR_LEQUAL;
}

">=" {
	return OPERATOR_GEQUAL;
}

";" {
	return PUNCTUATOR_SEMICOLON;
}

"," {
	return PUNCTUATOR_COMMA;
}

"." {
	return PUNCTUATOR_PERIOD;
}

"(" {
	return PUNCTUATOR_LPAREN;
}

")" {
	return PUNCTUATOR_RPAREN;
}

":" {
	return PUNCTUATOR_DDOTS;
}

{letter}{alphanum}* {
	if (yyleng > ID_SIZE)
	{
		printf("Lexical error at %u: Identifier %s is too large.\n", current_line, yytext);
		return LEX_ERROR;
	}
	else
	{	
		int ret_val;
		if (hmap_search(wk_table, yytext, &ret_val) == SUCCESS)
		{
			return ret_val;
		}
		else
		{
			strcpy(yylval.val_string.val, yytext);		
			return VAL_STRING; 
		}
	}
		    }

{digit}+ {
	if (yyleng > 10)	
	{
		printf("Lexical error at %u: Digit %s is too large.\n", current_line, yytext);
		return LEX_ERROR;
	}
	else
	{
		yylval.val_integer.val = atoi(yytext);
		return VAL_INTEGER;
	}
	 }

{digit}+\.{digit}+ {
	yylval.val_float.val = atof(yytext);
	return VAL_FLOAT;
}

. {
	printf("Lexical error at %u: Char %s is invalid.\n", current_line, yytext);
	return LEX_ERROR;
}
%%
/*C Code*/
