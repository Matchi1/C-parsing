%{
	/* Projet.y */
	/* Syntaxe du TPC pour le projet d'analyse syntaxique de 2020-2021*/

	#include <stdio.h>
	int yyerror(char *s);
	int yylex();
	extern int line;
	extern int column;
	extern char text_line[100];
%}

%token EQ AND OR DIVSTAR ADDSUB ORDER VOID RETURN
%token IF ELSE WHILE PRINT READC READE NUM IDENT CHARACTER TYPE

%%
Prog:  DeclVars DeclFoncts
    ;
DeclVars:
       DeclVars TYPE Declarateurs ';'
    |
    ;
Declarateurs:
       Declarateurs ',' IDENT
    |  IDENT
    ;
DeclFoncts:
       DeclFoncts DeclFonct
    |  DeclFonct
    ;
DeclFonct:
       EnTeteFonct Corps
    ;
EnTeteFonct:
       TYPE IDENT '(' Parametres ')'
    |  VOID IDENT '(' Parametres ')'
    ;
Parametres:
       VOID
    |  ListTypVar
    ;
ListTypVar:
       ListTypVar ',' TYPE IDENT
    |  TYPE IDENT
    ;
Corps: '{' DeclVars SuiteInstr '}'
    ;
SuiteInstr:
       SuiteInstr Instr
    |
    ;
Instr:
       LValue '=' Exp ';'
    |  READE '(' IDENT ')' ';'
    |  READC '(' IDENT ')' ';'
    |  PRINT '(' Exp ')' ';'
    |  IF '(' Exp ')' Instr
    |  IF '(' Exp ')' Instr ELSE Instr
    |  WHILE '(' Exp ')' Instr
    |  IDENT '(' Arguments  ')' ';'
    |  RETURN Exp ';'
    |  RETURN ';'
    |  '{' SuiteInstr '}'
    |  ';'
    ;
Exp :  Exp OR TB
    |  TB
    ;
TB  :  TB AND FB
    |  FB
    ;
FB  :  FB EQ M
    |  M
    ;
M   :  M ORDER E
    |  E
    ;
E   :  E ADDSUB T
    |  T
    ;
T   :  T DIVSTAR F
    |  F
    ;
F   :  ADDSUB F
    |  '!' F
    |  '(' Exp ')'
    |  NUM
    |  CHARACTER
    |  LValue
    |  IDENT '(' Arguments  ')'
    ;
LValue:
       IDENT
    ;
Arguments:
       ListExp
    |
    ;
ListExp:
       ListExp ',' Exp
    |  Exp
    ;
%%

void display_error(){
	int index;
	for(index = 0; index < column - 1; index++){
		if(text_line[index] == '\t')
			printf("\t");
		else
			printf(" ");
	}
	printf("^\n");
}

int yyerror(char *s) {
	printf("Erreur à la ligne %d colonne %d!\n", line, column);
	printf("%s\n", text_line);
	display_error();
	return 0;
}

int main() {
  return yyparse();
}
