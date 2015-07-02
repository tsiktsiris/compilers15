%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include "ast.h"
#include "common.h"

// prototypes
node *new_node(int oper, int nops, ...);
node *id(int i);
node *con(int value);

void parse(node *p);
void free_node(node *p);

int eval(node *p);

int yylex(void);
void yyerror(char *s);


int sym[25];                    // symbol table

%}

%union 
{
    int iValue;                 // integer value
    char sIndex;                // symbol table index
    node *nPtr;					// node pointer
};

%token <sIndex> IDENTIFIER
%token <iValue> NUMBER
%left MINUS
%token EQUALS LET IN AND COMMA LP RP TIMES PLUS _EOF 


%type <nPtr> expr deflist definition

%%

program:
		expr	{parse($1); free_node($1); exit(0);	}
		;

expr:
	  LET deflist IN expr				{ $$ = new_node(LET, 2, $2,$4); }
	| IDENTIFIER 						{ $$ = id($1); }
	| NUMBER 							{ $$ = con($1); }
	| PLUS LP expr COMMA expr RP 		{ $$ = new_node(PLUS, 2, $3, $5); }
	| TIMES LP expr COMMA expr RP		{ $$ = new_node(TIMES, 2, $3, $5); }
    | MINUS IDENTIFIER                  { $$ = new_node(MINUS, 1, id($2)); }
    | MINUS NUMBER                      { $$ = new_node(MINUS, 1, con($2)); }
	;
deflist:
	  definition						
	| definition AND deflist			{ $$ = new_node(AND, 2, $1, $3); }
	;
definition:
	  IDENTIFIER EQUALS expr 			{ $$ = new_node(EQUALS, 2, id($1), $3); }
	;
%%

node *con(int value) 
{
    node *p;

	DEBUG("Allocating %d bytes for CONSTANT %d",sizeof(node),value);

    if ((p = malloc(sizeof(node))) == NULL) 
		yyerror("out of memory");

    p->type = typeCon;
    p->con.value = value;

    return p;
}

node *id(int i) 
{
    node *p;

	DEBUG("Allocating %d bytes for ID %d",sizeof(node),i);
    if ((p = malloc(sizeof(node))) == NULL) 
		yyerror("out of memory");

    p->type = typeId;
    p->id.i = i;

    return p;
}

node *new_node(int oper, int nops, ...) 
{
    va_list ap;
    node *p;
    int i;

	DEBUG("Allocating %d bytes for new node (operation %d)",sizeof(node),oper);

    if ((p = malloc(sizeof(node))) == NULL) 
		yyerror("out of memory");
    if ((p->opr.op = malloc(nops * sizeof(node *))) == NULL) 
		yyerror("out of memory");

    // copy information
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;

    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, node*);
    va_end(ap);

    return p;
}

void free_node(node *p) 
{
    int i;

    if (!p) return;

    if (p->type == typeOpr) 
	{
        for (i = 0; i < p->opr.nops; i++)
            free_node(p->opr.op[i]);
        free(p->opr.op);
    }
	DEBUG("Releasing node TYPE %d",p->type);
    free (p);
}

void yyerror(char *s) 
{
    fprintf(stdout, "%s\n", s);
}



