typedef enum { typeCon, typeId, typeOpr } nodeEnum;

typedef struct 
{
    int value;                  // value of constant
} conNode;

typedef struct 
{
    int i;                      // subscript to sym array
} idNode;

typedef struct 
{
    int oper;                   // operator
    int nops;                   // number of operands
    struct nodeTag **op;		// operands
} oprNode;

typedef struct nodeTag 
{
    nodeEnum type;              // type of node

    union 
    {
        conNode con;        	// constants
        idNode id;          	// identifiers
        oprNode opr;        	// operators 
    };
} node;

extern int sym[25];
