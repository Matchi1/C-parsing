%{
	/*Projet.lex*/
	#include <stdio.h>
	#include "as.tab.h"

	char text_line[100];
	int index_text = 0;
	int line = 1;
	int column = 0;

	#undef YY_INPUT
	#define YY_INPUT(buf, result, max_size){ \
		int c = getchar(); \
		if(c == '\n') \
			index_text = 0; \
		else { \
			text_line[index_text] = c; \
			index_text++; \
			text_line[index_text] = '\0'; \
		} \
		result = (c == EOF) ? YY_NULL : (buf[0] = c, 1); \
	}
%}

%option noyywrap
%option nounput
%option noinput

%x COMMENT OLCOMMENT STRING

%%
\/\* 						{column += yyleng; BEGIN COMMENT;}
\/\/ 						{column += yyleng; BEGIN OLCOMMENT;}
\" 							{column ++; BEGIN STRING;}

<COMMENT>"*/" 				{column += yyleng; BEGIN INITIAL;}
<OLCOMMENT>\n 				{column = 0; line++; BEGIN INITIAL;}
<STRING>\" 					{column++; BEGIN INITIAL;}
<STRING>\\\n 				{column += yyleng;}
<STRING>\\\" 				{column += yyleng;}
<OLCOMMENT,COMMENT>"\n" 	{line++; column = 0;}
<OLCOMMENT,COMMENT,STRING>. {column++;}

[ \t]+ 						{column += yyleng;}
== 							{column += yyleng; return EQ;}
&& 							{column += yyleng; return AND;}
\|\| 						{column += yyleng; return OR;}
\*|\/|% 					{column++; return DIVSTAR;}
\+|- 						{column++; return ADDSUB;}
"<""="?|">""="? 			{column += yyleng; return ORDER;}

"void"   					{column += yyleng; return VOID;}
"return" 					{column += yyleng; return RETURN;}
"if"     					{column += yyleng; return IF;}
"else"   					{column += yyleng; return ELSE;}
"while"  					{column += yyleng; return WHILE;}
"print"  					{column += yyleng; return PRINT;}
"readc"  					{column += yyleng; return READC;}
"reade"  					{column += yyleng; return READE;}

[0-9]+ 						{column += yyleng; return NUM;}
"int"|"double" 				{column += yyleng; return TYPE;}
[a-zA-Z_][a-zA-Z0-9_]* 		{column += yyleng; return IDENT;}

[a-zA-Z]					{column ++; return CHARACTER;}
. 							{column++; return yytext[0];}

\n 							{line++; column = 0; }
<<EOF>>						{return 0;}
%%
