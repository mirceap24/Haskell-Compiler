%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex();
%}

%union {
    int i;
    char *s;
    char *sval;
}

%token TYPE_INT TYPE_BOOL
%token IF THEN ELSE
%token WHILE DO
%token BOOL_TRUE BOOL_FALSE
%token ASSIGN
%token EQUAL NOT_EQUAL LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL
%token PLUS MINUS MULTIPLY DIVIDE
%token LPAR RPAR LBRACE RBRACE
%token SEMICOLON
%token <s> ID
%token <i> INT_LITERAL
%token <sval> COMMENT


%%

program:
    declarations
    | statements
    ;

declarations:
    TYPE_INT ID { printf("Declarare variabila intreaga: %s\n", $2); free($2); } SEMICOLON
    TYPE_BOOL ID { printf("Declarare variabila booleana: %s\n", $2); free($2); } SEMICOLON
    | declarations TYPE_INT ID SEMICOLON
    | declarations TYPE_BOOL ID SEMICOLON
    ;

statements:
    statement
    | declarations
    | COMMENT { printf("Comentariu pe o singura linie: %s\n", $1); }
    | statements statement
    | statements declarations
    | statements COMMENT { printf("Comentariu pe o singura linie: %s\n", $2); }
    ;

statement:
    assignment
    | if_statement
    | while_statement
    ;

assignment:
    ID ASSIGN expression SEMICOLON
    ;

expression:
    ID
    | INT_LITERAL
    | bool_expression
    | arithmetic_expression
    | comparison_expression
    | LPAR expression RPAR
    ;

bool_expression:
    BOOL_TRUE
    | BOOL_FALSE
    ;

arithmetic_expression:
    expression PLUS expression
    | expression MINUS expression
    | expression MULTIPLY expression
    | expression DIVIDE expression
    ;

comparison_expression:
 expression EQUAL expression
    | expression NOT_EQUAL expression
    | expression LESS_THAN expression
    | expression GREATER_THAN expression
    | expression LESS_EQUAL expression
    | expression GREATER_EQUAL expression
    ;

if_statement:
    IF expression THEN { printf("Instrucțiune IF simpla\n"); } statements
    | IF expression THEN statements ELSE { printf("Instrucțiune IF-ELSE\n"); } statements
    ;

while_statement:
    WHILE expression {printf ("Expresie WHILE\n"); } DO LBRACE statements RBRACE
    | WHILE expression {printf ("Expresie WHILE fara DO"); } LBRACE statements RBRACE
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Eroare lexicala: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
   