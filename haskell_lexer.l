%{
#include "haskell_parser.h"
#include <string.h>
void print_token(const char *token_type, const char *text, int line);
%}


%%

[ \t]                ;
[\n]                {yylineno++;}
"Int"               { print_token("IDENTIFIER", yytext, yylineno); return TYPE_INT; }
"Bool"              { print_token("IDENTIFIER", yytext, yylineno); return TYPE_BOOL; }
"if"                { print_token("KEYWORD", yytext, yylineno); return IF; }
"then"              { print_token("KEYWORD", yytext, yylineno); return THEN; }
"else"              { print_token("KEYWORD", yytext, yylineno); return ELSE; }
"while"             { print_token("KEYWORD", yytext, yylineno); return WHILE; }
"do"                { print_token("KEYWORD", yytext, yylineno); return DO; }
"True"              { print_token("LITERAL", yytext, yylineno); return BOOL_TRUE; }
"False"             { print_token("LITERAL", yytext, yylineno); return BOOL_FALSE; }
"="                 { print_token("OPERATOR", yytext, yylineno); return ASSIGN; }
"=="                { print_token("OPERATOR", yytext, yylineno); return EQUAL; }
"/="                { print_token("OPERATOR", yytext, yylineno); return NOT_EQUAL; }
"<"                 { print_token("OPERATOR", yytext, yylineno); return LESS_THAN; }
">"                 { print_token("OPERATOR", yytext, yylineno); return GREATER_THAN; }
"<="                { print_token("OPERATOR", yytext, yylineno); return LESS_EQUAL; }
">="                { print_token("OPERATOR", yytext, yylineno); return GREATER_EQUAL; }
"+"                 { print_token("OPERATOR", yytext, yylineno); return PLUS; }
"-"                 { print_token("OPERATOR", yytext, yylineno); return MINUS; }
"*"                 { print_token("OPERATOR", yytext, yylineno); return MULTIPLY; }
"/"                 { print_token("OPERATOR", yytext, yylineno); return DIVIDE; }
"("                 { print_token("PUNCTUATION", yytext, yylineno); return LPAR; }
")"                 { print_token("PUNCTUATION", yytext, yylineno); return RPAR; }
"{"                 { print_token("PUNCTUATION", yytext, yylineno); return LBRACE; }
"}"                 { print_token("PUNCTUATION", yytext, yylineno); return RBRACE; }
";"                 { print_token("PUNCTUATION", yytext, yylineno); return SEMICOLON; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.s = strdup(yytext); print_token("IDENTIFIER", yytext, yylineno); return ID; }
[0-9]+             { yylval.i = atoi(yytext); print_token("LITERAL", yytext, yylineno); return INT_LITERAL; }
"--"[^\n]*         { yylineno++; yylval.sval = strdup(yytext); print_token("SINGLE-LINE COMMENT", yytext, yylineno); return COMMENT; }


%%

void print_token(const char *token_type, const char *text, int line) {
    printf("Lexeme: %s, Token: %s, Line: %d\n", text, token_type, line - 1);
}

int yywrap() { return 1; }