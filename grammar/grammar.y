/** Файл содержит основанный на Bison LALR-парсер,
    способный проверить принадлежность входных данных грамматике языка.

    Основано на https://github.com/bingmann/flex-bison-cpp-example/blob/master/src/parser.yy
    */

%start program

%{
#include <stdio.h>
#include "globals.h"

/*
    Функция для вывода сообщения об ошибке должна быть определена вручную.
    При этом мы определяем checker_error вместо yyerror,
    так как ранее применили директиву %name-prefix
*/
void checker_error (char const *s) {
    ++g_errorsCount;
    fprintf (stderr, "Error: %s\n", s);
}
%}

/* Директива вызовет генерацию файла с объявлениями токенов.
   Генератор парсеров должен знать целочисленные коды токенов,
   чтобы сгенерировать таблицу разбора. */
%defines

/* Префикс будет добавлен к идентификаторам генерируемых функций */
%name-prefix "checker_"

/* Подробные сообщения об ошибках разбора по грамматике. */
%error-verbose

%token INT			  "Integer constant"
%token FLOAT		  "Float constant"
%token CHAR			  "Char constant"
%token BOOL			  "Bool constant"
%token CONST		  "const"
%token TYPENAME		  "typename"
%token ID			  "Identifier"
%token PRINT		  "print"
%token READ			  "read"
%token WHILE		  "while"
%token DO			  "do"
%token IF			  "if"
%token ELSE			  "else"
%token EQUALS		  "operator =="
%token NOTEQUALS	  "operator !="
%token MOREOREQUALS   "operator <="
%token LESSOREQUALS   "operator >="
%token AND			  "operator &&"
%token OR			  "operator ||"

/* %left, %right, %nonassoc и %precedence управляют разрешением
   приоритета операторов и правил ассоциативности

   Документация Bison: http://www.gnu.org/software/bison/manual/bison.html#Precedence-Decl
*/

%left '='
%left EQUALS NOTEQUALS
%left OR
%left AND
%left '<' '>' LESSOREQUALS MOREOREQUALS
%left '+' '-'
%left '*' '/' '%'
%left '!'

%% /* Грамматические правила */

program : statement_list

statement_list : statement | statement_list statement

statement : READ paren_expression ';'
		  | PRINT paren_expression ';'
		  | IF paren_expression statement ELSE statement ';'
          | IF paren_expression statement ';'
          | WHILE paren_expression statement ';'
          | DO statement WHILE paren_expression ';'
          | '{' statement '}'
		  |	expression ';'
		  | declaration ';'
		  | assign ';'
		  | ';'

paren_expression : '(' expression ')'

declaration : const_declaration
			| array_declaration
			| atom_declaration

const_declaration : CONST variable_declaration

array_declaration : variable_declaration '[' arithmetic_expression ']'

atom_declaration : variable_declaration
				 | variable_declaration '=' expression

variable_declaration : type_name ID

assign : array_element_assign | atom_assign

array_element_assign : array_element '=' expression

atom_assign : variable '=' expression

type_name : TYPENAME

expression : arithmetic_expression | bool_expression

arithmetic_expression : term
					  | arithmetic_expression '+' term
					  | arithmetic_expression '-' term
					  | arithmetic_expression '*' term
					  | arithmetic_expression '/' term
					  | arithmetic_expression '%' term

bool_expression : term
				| bool_expression '<' term | bool_expression LESSOREQUALS term
				| bool_expression '>' term | bool_expression MOREOREQUALS term
				| bool_expression EQUALS term | bool_expression NOTEQUALS term
				| bool_expression AND term | bool_expression OR term
				| '!' bool_expression

term : variable | type | array_element | paren_expression

array_element : variable index

index : one_dimensional_index | index one_dimensional_index

one_dimensional_index : '[' arithmetic_expression ']'

variable : ID

type : atom_type | array

array : one_dimensional_array | array one_dimensional_array

one_dimensional_array : atom_type | one_dimensional_array atom_type

atom_type : BOOL | INT | CHAR | FLOAT