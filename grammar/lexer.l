%{

#include "grammar.gen.h"
#define yylex checker_lex

%}

INT ("+"|"-")?(("0")|([1-9][0-9]*))
FLOAT ({INT})"."([0-9]+)
BOOL true|false
TYPENAME int | float | bool | char
ID [a-zA-Z_][a-zA-Z0-9_]*
CHAR \'.\'


/* Опция, необходимая для языков с препроцессорами и #include,
в нашем случае не нужна */
%option noyywrap

%%

read 		return READ;
print		return PRINT;
while		return WHILE;
do			return DO;
if    		return IF;
else  		return ELSE;
const 		return CONST;
"{"			return '{';
"}"			return '}';
"("     	return '(';
")"     	return ')';
"["			return '[';
"]"			return ']';
"="     	return '=';
"+"     	return '+';
"-"     	return '-';
"*"     	return '*';
"/"     	return '/';
"%"     	return '%';
"<"     	return '<';
">"     	return '>';
"!"     	return '!';
";"			return ';';
"<="		return LESSOREQUALS;
">="		return MOREOREQUALS;
"=="    	return EQUALS;
"!="    	return NOTEQUALS;
"&&"    	return AND;
"||"    	return OR;
{BOOL}  	return BOOL;
{INT}		return INT;
{FLOAT}		return FLOAT;
{CHAR}		return CHAR;
{ID}		return ID;
[ \t\n]+	/* skip */;
