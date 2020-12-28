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
		char c = fgetc(yyin); \
		result = (c == EOF) ? YY_NULL : (buf[0] = c, 1); \
		/* Vérifie si la ligne a déjà été enregistré */ \
		if(index_text == 0){ \
			while(c != EOF && c != '\n'){ \
				text_line[index_text] = c; \
				index_text++; \
				c = fgetc(yyin); \
			} \
			text_line[index_text] = '\0'; \
			fseek(yyin, -index_text, SEEK_CUR); \
		} \
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
<OLCOMMENT>\n 				{column = 0; line++; index_text = 0; BEGIN INITIAL;}
<STRING>\" 					{column++; BEGIN INITIAL;}
<STRING>\\\n 				{column += yyleng; }
<STRING>\\\" 				{column += yyleng;}
<OLCOMMENT,COMMENT>"\n" 	{line++; column = 0; index_text = 0;}
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
"int"|"char" 				{column += yyleng; return TYPE;}
"struct" 					{column += yyleng; return STRUCT;}
[a-zA-Z_][a-zA-Z0-9_]* 		{column += yyleng; return IDENT;}

\'.\'					{column ++; return CHARACTER;}
. 							{column++; return yytext[0];}

\n|\r 							{line++; column = 0; index_text = 0;}
<<EOF>>						{return 0;}
%%
