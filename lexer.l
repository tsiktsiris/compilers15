%{
#include <stdlib.h>
#include "ast.h"
#include "y.tab.h"

void yyerror(char *);
%}

%%



[a-z]       { 
                yylval.sIndex = *yytext - 'a';
                return IDENTIFIER;
            }


[0-9]* {
                yylval.iValue = atoi(yytext);
                return NUMBER;
            }
"let"		return LET;
"in"		return IN;
"and"		return AND;
","		return COMMA;
"+"		return PLUS;
"-"		return MINUS;
"*"		return TIMES;
"="		return EQUALS;
"("		return LP;
")"		return RP;
<<EOF>>		return _EOF;
[\r]+		return _EOF;
[ \t]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
