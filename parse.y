%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *);
int yylex(void);
%}

/* yylval data */
%union {
    char *sval;  /* string value */
    int ival;  /* integer value */
}

/* tokens */
%token T_VOID T_INT T_STR IF ELSE RETURN
%token <sval> IDENT STR_LIT
%token <ival> INT_LIT
%token EQEQ

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type <sval> funcname

%start program

%left EQEQ

%%

program
    : decl_list
    ;

decl_list
    : decl_list decl
    | /* empty */
    ;

decl
    : funcdef
    ;

funcdef
    : type funcname '(' params_opt ')' block
        {
            printf("parsed function: %s\n", $2);
            free($2);
        }
    ;

funcname
    : IDENT { $$ = $1; }
    ;

type
    : T_VOID
    | T_INT
    | T_STR
    ;

params_opt
    : /* empty */
    | param_list
    ;

param_list
    : param
    | param_list ',' param
    ;

param
    : type IDENT        /* int age */
    ;

block
    : '{' stmt_list '}'
    ;

stmt_list
    : stmt_list stmt
    | /* empty */
    ;

stmt
    : block
    | var_decl ';'
    | assignment ';'
    | expr ';'              /* e.g., function call as a statement */
    | if_stmt
    | return_stmt ';'
    ;

var_decl
    : type IDENT '=' expr
    ;

assignment
    : IDENT '=' expr
    ;

if_stmt
    : IF '(' expr ')' stmt %prec LOWER_THAN_ELSE
    | IF '(' expr ')' stmt ELSE stmt
    ;

return_stmt
    : RETURN expr
    | RETURN
    ;

expr
    : literal
    | IDENT
    | call
    | '(' expr ')'
    | expr EQEQ expr
    ;

call
    : IDENT '(' args_opt ')'
    ;

args_opt
    : /* empty */
    | arg_list
    ;

arg_list
    : expr
    | arg_list ',' expr
    ;

literal
    : INT_LIT
    | STR_LIT
    ;

%%

void
yyerror(const char *s)
{
    fprintf(stderr, "parse error: %s\n", s);
}

int
main(void)
{
    if (yyparse() > 0)
        return 1;

    printf("OK\n");
    return 0;
}
