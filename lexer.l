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
opchar [*()/+=:<>,.:;]

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

{opchar}+ {
	int ret_val;
	if (hmap_search(wk_table, yytext, &ret_val) == SUCCESS)
	{
		printf("Returning:%d\n", ret_val);
		fflush(stdout);
		return ret_val;
	}
	else
		printf("Lexical error at %u: Operator %s is unrecognized.\n", current_line, yytext);
	return LEX_ERROR;
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
			strcpy(yylval.val_string, yytext);		
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
		yylval.val_integer = atoi(yytext);
		return VAL_INTEGER;
	}
	 }

{digit}+\.{digit}+ {
	yylval.val_float = atof(yytext);
	return VAL_FLOAT;
}


. {
	printf("Lexical error at %u: Char %s is invalid.\n", current_line, yytext);
	return LEX_ERROR;
}
%%
/*C Code*/
