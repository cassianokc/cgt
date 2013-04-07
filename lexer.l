/*Definitions*/

%{

%}
letter [a-zA-Z]
digit [0-9]
alphanum[a-zA-Z_0-9]
/* This tells flex to read only one input file*/
%option noyywrap

%%


{letter}{alphanum}* {
	printf("%s - id\n", yytext);
}
{digit}+ {
	printf("%s - integer\n", yytext);
}
{digit}+\.{digit}+ {
	printf("%s - float\n", yytext);
} 

.	{
				char __linha[60];
				sprintf(__linha, "Caracter desconhecido na linha\n");
				fputs(__linha, stdout);
	}

%%
/*C Code*/
