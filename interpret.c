#include <stdio.h>
#include "ast.h"
#include "y.tab.h"
#include "common.h"

FILE * yyin;

int eval(node *p) 
{
    if (!p) return -1;
	
	if(p->type==typeCon) DEBUG("NUMBER %d",p->con.value);
	if(p->type==typeId) DEBUG("IDENTIFIER %c",p->id.i + 'A');
	if(p->type==typeOpr) DEBUG("OPERATION %d",p->opr.oper);

    switch(p->type) 
    {

	    case typeCon:           return p->con.value;
	    case typeId:            return sym[p->id.i];
	    case typeOpr:
		
		switch(p->opr.oper) 
		{
			case LET:           eval(p->opr.op[0]); return eval(p->opr.op[1]); 
			case EQUALS:        return sym[p->opr.op[0]->id.i] = eval(p->opr.op[1]); 
			case PLUS:          return eval(p->opr.op[0]) + eval(p->opr.op[1]);
			case MINUS:         return -eval(p->opr.op[0]);
			case TIMES:         return eval(p->opr.op[0]) * eval(p->opr.op[1]); 
			case AND:           eval(p->opr.op[0]); return eval(p->opr.op[1]); 
		}
	}


    return 0;
}

void parse(node *p)
{
	printf(ANSI_COLOR_RESULT "RESULT IS: %d\n" ANSI_COLOR_RESET,eval(p));
}

int main(void) 
{
    yyin = fopen("test/test1.lt", "r" );
    yyparse();
    return 0;
}
