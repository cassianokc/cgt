%{
/*Lexical Analyser by:
Cassiano Kleinert Casagrande - 7151819
Guilherme Elias Guimarães Kalatzis Sousa - 7239426
Thiago Fujisaka Tanaka - 7153014
*/
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "hmap.h
}%

letter [a-zA-Z]
digit [0-9]
alphanum [a-zA-Z_0-9]


%%
"begin"              { return KEYWORD_BEGIN;       }
"const"              { return KEYWORD_CONST;       }
"end"                { return KEYWORD_END;         }
"if"                 { return KEYWORD_IF;          }
"else"               { return KEYWORD_ELSE         }
"procedure"          { return KEYWORD_PROC;        }
"then"               { return KEYWORD_THEN;        }
"var"                { return KEYWORD_VAR;         }
"while"              { return KEYWORD_WHILE;       }
"for"                { return KEYWORD_FOR          }
"to"                 { return KEYWORD_TO           }
"do"                 { return KEYWORD_DO;          }
"repeat"             { return KEYWORD_REPEAT       }
"until"              { return KEYWORD_UNTIL        }
"real"               { return KEYWORD_REAL         }
"integer"            { return KEYWORD_INTEGER      }
"program"            { return KEYWORD_PROGRAM      }
"."                  { return KEYWORD_PERIOD;      }
"+"                  { return OPERATOR_PLUS;       }
"-"                  { return OPERATOR_MINUS;      }
"*"                  { return OPERATOR_MUL;        }
"/"                  { return OPERATOR_DIV;        }
";"                  { return OPERATOR_SEMICOLON;  }
","                  { return OPERATOR_COMMA;      }
":="                 { return OPERATOR_ATRIB;      }
"="                  { return OPERATOR_EQUAL;      }
"("                  { return OPERATOR_LPAREN;     }
")"                  { return OPERATOR_RPAREN;     }
"<>"                 { return OPERATOR_NEQUAL;     }
"<"                  { return OPERATOR_LESSER;     }
">"                  { return OPERATOR_GREATER;    }
"<="                 { return OPERATOR_LEQUAL;     }
">="                 { return OPERATOR_GEQUAL      }

{letter}{alphanum}* {}
{digit}+ {}
{digit}+\.{digit} {}




%%
