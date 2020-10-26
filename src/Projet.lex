%{
/*Projet.lex*/
#include "Projet.tab.h"
int line = 1;
int column = 0;
%}

%option nounput
%option noinput

%x COMMENT OLCOMMENT STRING

%%
\/\* column += 2; BEGIN COMMENT;
\/\/ column += 2; BEGIN OLCOMMENT;
\" column ++; BEGIN STRING;

<COMMENT>"*/" column += yyleng; BEGIN INITIAL;
<OLCOMMENT>\n BEGIN INITIAL;
<STRING>\" column++; BEGIN INITIAL;
<STRING>\\\n column += yyleng;
<STRING>\\\" column += yyleng;

[ \t]+ column += yyleng;
== column += 2; return EQ;
&& column += 2; return AND;
\|\| column += 2; return OR;
\*|\/|% column++; return DIVSTAR;
\+|- column++; return ADDSUB;
"<""="?|">""="? column += yyleng; return ORDER;

"void"   column += 4; return VOID;
"return" column += 6; return RETURN;
"if"     column += 2; return IF;
"else"   column += 4; return ELSE;
"while"  column += 5; return WHILE;
"print"  column += 5; return PRINT;
"readc"  column += 5; return READC;
"reade"  column += 5; return READE;

[0-9]+ column += yyleng; return NUM;
"int"|"double" column += yyleng; return TYPE;
[a-zA-Z_][a-zA-Z0-9_]* column += yyleng; return IDENT;

. column++; return yytext[0];

<OLCOMMENT,COMMENT,STRING>. column++;
\n line++; column = 0;
<OLCOMMENT,COMMENT>"\n" line++; column = 0;
%%
