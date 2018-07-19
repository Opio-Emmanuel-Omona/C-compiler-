%{
	#include<stdio.h>
	#include<string.h>

	extern FILE *yyin;
	extern int yylineno;

	extern int keyword, type, relop, number, floating, arithmetic_operator, identifier, bracket, parenthesis, brace, symbol, assignment, logic_operator, string;
	int row = 0;
	char* symbolTable[100][2];

	int search(char* s, int rows);
	void updateSymbolTable(char* one, char* two);
	void yyerror(char *s);
%}

%union {int number; char* str; float floating;}
%token	IF ELSE DO WHILE FOR RETURN BREAK
%token	INT CHAR FLOAT LONG DOUBLE VOID
%token	PE TE ME DE PP MM
%token	LOGIC_OP
%token	PLUS MINUS DIVIDE TIMES EQUAL
%token	COMMA DOT_OPERATOR SEMI_COLON AMPERSAND PERCENT
%token	OPEN_BRACE CLOSE_BRACE OPEN_BRACKET CLOSE_BRACKET OPEN_PARENTHESIS CLOSE_PARENTHESIS
%token	PREPROCESSOR HEADER
%token	ID NUM DECIMAL STRING
%nonassoc LT GT LE GE EE NE
%left	PLUS MINUS
%left	TIMES DIVIDE
%type	<str> idList id type


%start	program

%% 

action	: id PP	{;}
	| id MM {;}
	| PP id	{;}
	| MM id	{;}
	;

arithmetic_op	: PLUS		{;}
		| MINUS		{;}
		| TIMES		{;}
		| DIVIDE	{;}
		;

array	: id OPEN_BRACKET NUM CLOSE_BRACKET	{;}
	| id OPEN_BRACKET id CLOSE_BRACKET	{;}
	;

args	: type id		{;}
	| id			{;}
	| string		{;}
	| AMPERSAND id		{;}
	| expression		{;}
	|			{;}
	;

args_list	: args COMMA args_list	{;}
		| args			{;}
		;

assignment	: id EQUAL expression	{;}
		| id TE	expression	{;}
		| id DE	expression	{;}
		| id ME expression	{;}
		| id PE expression	{;}
		;

body	: functionDefinition	{;}
	;

condition	: id relop expression LOGIC_OP condition	{;}
		| id relop expression				{;}
		;

do_while_loop	: DO OPEN_BRACE stmt CLOSE_BRACE WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS SEMI_COLON	{;}

expression	: id arithmetic_op expression	{;}
		| term				{;}
		| action			{;}
		| id				{;}
		;

for_loop	: FOR OPEN_PARENTHESIS assignment SEMI_COLON condition SEMI_COLON action CLOSE_PARENTHESIS				{;}
		| FOR OPEN_PARENTHESIS assignment SEMI_COLON condition SEMI_COLON action CLOSE_PARENTHESIS OPEN_BRACE stmt CLOSE_BRACE	{;}
		;

functionBody	: OPEN_BRACE stmt CLOSE_BRACE	{;}
		| stmt				{;}
		|				{;}
		;

functionCall	: id OPEN_PARENTHESIS args_list CLOSE_PARENTHESIS	{;}
		;

functionDefinition	: type id parameters functionBody {;}
			;

id	: array	{;}
	| ID	{;}
	;

idList	: id COMMA idList	{$$=$1;}
	| id			{$$=$1;}
	| assignment		{;}
	;

if_stmt	: IF OPEN_PARENTHESIS condition CLOSE_PARENTHESIS stmt								{;}
	| IF OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE stmt CLOSE_BRACE					{;}
	| IF OPEN_PARENTHESIS condition CLOSE_PARENTHESIS stmt ELSE stmt						{;}
	| IF OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE stmt CLOSE_BRACE ELSE stmt				{;}
	| IF OPEN_PARENTHESIS condition CLOSE_PARENTHESIS stmt ELSE OPEN_BRACE stmt CLOSE_BRACE				{;}
	| IF OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE stmt CLOSE_BRACE ELSE OPEN_BRACE stmt CLOSE_BRACE	{;}
	;

parameters	: OPEN_PARENTHESIS args CLOSE_PARENTHESIS	{;}
		;

preprocessorDirective	: PREPROCESSOR HEADER	{;}
			;

program	: preprocessorDirective body	{printf("Accepted\n");}
	;

relop	: LT	{;}
	| GT	{;}
	| LE	{;}
	| GE	{;}
	| EE	{;}
	| NE	{;}
	;

return_stmt	: RETURN		{;}
		| RETURN expression	{;}
		;

stmt	: var_declaration SEMI_COLON stmt			{;}
	| var_declaration SEMI_COLON				{;}
	| functionCall SEMI_COLON stmt				{;}
	| functionCall SEMI_COLON				{;}
	| expression SEMI_COLON stmt				{;}
	| expression SEMI_COLON					{;}
	| assignment SEMI_COLON stmt				{;}
	| assignment SEMI_COLON					{;}
	| for_loop stmt						{;}
	| for_loop						{;}
	| if_stmt						{;}
	| do_while_loop	stmt					{;}
	| do_while_loop						{;}
	| while_loop stmt					{;}
	| while_loop						{;}
	| BREAK	SEMI_COLON stmt					{;}
	| BREAK SEMI_COLON					{;}
	| return_stmt SEMI_COLON				{;}
	| return_stmt						{;}
	| SEMI_COLON						{;}
	;

string	: STRING	{;}
	;

term	: NUM		{;}
	| DECIMAL	{;}
	;

type	: INT		{;}
	| CHAR		{;}
	| VOID		{;}
	| FLOAT		{;}
	| DOUBLE	{;}
	| LONG LONG	{;}
	| LONG		{;}
	;

var_declaration	: type idList	{;}
		;

while_loop	: WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS					{;}
		| WHILE OPEN_PARENTHESIS condition CLOSE_PARENTHESIS OPEN_BRACE stmt CLOSE_BRACE	{;}
		;

%%

void yyerror(char *s) {
	fprintf(stderr, "%s on line: %d\n", s, yylineno);
}

void updateSymbolTable(char *type, char* val){
	printf("Type %s; Val %s", type, val);
	if(search(val, row) == 0){
		symbolTable[row][1] = type;
		symbolTable[row][0] = val;
		printf("%s", &symbolTable[row]);
		row++;
	}else{
		yyerror("REDECLRATION");
	}
}

int search(char *str, int rows){
	int i;
	for(i=0; i<rows; i++){
		char* temp = symbolTable[rows][0];
		printf("After\n");
		printf("%s %s",&symbolTable[rows][0], str);
		if(!strcmp(temp,str)){
			printf("Before\n");
			return 1;
		}
	}
	return 0;
}

int main(int argc, char* argv[]) {
	FILE *fp;
	if(fp = fopen(argv[1], "r")){
		yyin = fp;
	}
	yyparse();
	
	/*print table*/
	printf("\t\t+-------------------------------+\n");
	printf("\t\t|TOKEN TYPE\t|NUMBER\t\t|\n");
	printf("\t\t+---------------+---------------+\n");
	printf("\t\t|identifiers\t|%d\t\t|\n", identifier);
	printf("\t\t|numbers\t|%d\t\t|\n", number);
	printf("\t\t|floating\t|%d\t\t|\n", floating);
	printf("\t\t|type\t\t|%d\t\t|\n", type);
	printf("\t\t|keyword\t|%d\t\t|\n", keyword);
	printf("\t\t|relop\t\t|%d\t\t|\n", relop);
	printf("\t\t|arithmetic op\t|%d\t\t|\n", arithmetic_operator);
	printf("\t\t|bracket\t|%d\t\t|\n", bracket);
	printf("\t\t|parenthesis\t|%d\t\t|\n", parenthesis);
	printf("\t\t|brace\t\t|%d\t\t|\n", brace);
	printf("\t\t|assignment\t|%d\t\t|\n", assignment);
	printf("\t\t|logic op\t|%d\t\t|\n", logic_operator);
	printf("\t\t|string\t\t|%d\t\t|\n", string);
	printf("\t\t|symbol\t\t|%d\t\t|\n", symbol);
	printf("\t\t+---------------+---------------+\n");

	/*print symboltable*/
	int i;
	printf("\n\n\n");
	for(i=0; i<row; i++){
		printf("%s",symbolTable[i]);
	}

	return 0;
}