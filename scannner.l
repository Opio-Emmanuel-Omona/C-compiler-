%{
	#include<stdio.h>
	#include "parser.tab.h"

	static void comment(void);

	int keyword = 0;
	int type = 0;
	int relop = 0;
	int number = 0;
	int floating = 0;
	int arithmetic_operator = 0;
	int identifier = 0;
	int bracket = 0;
	int parenthesis = 0;
	int brace = 0;
	int symbol = 0;
	int assignment = 0;
	int logic_operator = 0;
	int string = 0;

%}

%option yylineno

%%

\/\/.*					{;}
"/*"					{comment();}
[ \t\n]					{;}
if					{keyword++; yylval.str = yytext; return IF;}
else					{keyword++; yylval.str = yytext; return ELSE;}
do					{keyword++; yylval.str = yytext; return DO;}
while					{keyword++; yylval.str = yytext; return WHILE;}
for					{keyword++; yylval.str = yytext; return FOR;}
return					{keyword++; yylval.str = yytext; return RETURN;}
break					{keyword++; yylval.str = yytext; return BREAK;}
int					{type++; yylval.str = yytext; return INT;}
void					{type++; yylval.str = yytext; return VOID;}
char					{type++; yylval.str = yytext; return CHAR;}
float					{type++; yylval.str = yytext; return FLOAT;}
double					{type++; yylval.str = yytext; return DOUBLE;}
long					{type++; yylval.str = yytext; return LONG;}
"<"					{relop++; return LT;}
">"					{relop++; return GT;}
"<"[a-zA-Z]+.[a-zA-Z]+">"		{relop++; return HEADER;}
"<="					{relop++; return LE;}
">="					{relop++; return GE;}
"*="					{assignment++; arithmetic_operator++; return TE;}
"+="					{assignment++; arithmetic_operator++; return PE;}
"++"					{arithmetic_operator++; return PP;}
"--"					{arithmetic_operator++; return MM;}
"=="					{relop; return EE;}
"!="					{relop; return NE;}
"+"					{arithmetic_operator++; return PLUS;}
"-"					{arithmetic_operator++; return MINUS;}
"/"					{arithmetic_operator++; return DIVIDE;}
"="					{assignment++; return EQUAL;}
"*"					{arithmetic_operator++; return TIMES;}
"||"|"&&"				{logic_operator++; return LOGIC_OP;}
"#"([a-zA-Z])+				{return PREPROCESSOR;}
","					{symbol++; return COMMA;}
"["					{bracket++; return OPEN_BRACKET;}
"]"					{bracket++; return CLOSE_BRACKET;}
"("					{parenthesis++; return OPEN_PARENTHESIS;}
")"					{parenthesis++; return CLOSE_PARENTHESIS;}
"{"					{brace++; return OPEN_BRACE;}
"}"					{brace++; return CLOSE_BRACE;}
"&"					{symbol++; return AMPERSAND;}
"%"					{symbol++; return PERCENT;}
"."					{symbol++; return DOT_OPERATOR;}
";"					{symbol++; return SEMI_COLON;}
[a-zA-Z_][a-zA-Z0-9_]*			{identifier++; yylval.str = yytext; return ID;}
[0-9]+					{number++; yylval.number = atoi(yytext); return NUM;}
[0-9]+.[0-9]+				{floating++; yylval.floating = atoi(yytext); return DECIMAL;}
\"[^"]+\"				{string++; return STRING;}
.					{yyerror("unrecognized token");}


%%

int yywrap()
{
	return 1;
}

static void comment(void)
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}
