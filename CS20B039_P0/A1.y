%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    int yylex (void);
    void yyerror (const char *);

    char* MacroIDList[2000];
    char* MacroParsList[2000][1000];
    char* MacroActions[2000];
    int MacroNumberofArgs[2000]={0};
    int MacroIndex = 0;


    int findMacroIndex(char* MacroName) 
    {
        int exists = -1;
        for(int i=0;i<MacroIndex;i++)
        {
            if(strcmp(MacroIDList[i],MacroName)==0) 
            {
                exists = i; break;
            }
        }
        if(exists==-1)
        {
            yyerror("Error Finding Macro");
            exit(0);
        }
        return exists;
    }

    char* replaceEverywhere(char* mainString, char* oldWord, char* newWord)
    {
        char* result;
        int i, ct;
        i=ct=0;
        int nlen = strlen(newWord);
        int olen = strlen(oldWord);

        result = (char*)malloc(1000+strlen(mainString));

        i=0;
        while(*mainString)
        {
            if(strstr(mainString,oldWord)==mainString)
            {
                strcpy(&result[i],newWord);
                i+=nlen;
                mainString+=olen;
            }
            else
                result[i++] = *mainString++;
        }

        result[i]='\0';
        return result;
    }

%}

%define parse.error verbose

%union {
  char* str;
}

//Terminal declarations
%token <str>  CLASS PUBLIC STATIC VOIDT MAIN STRING PRINT EXTENDS RETURN
%token <str>  INTT BOOLEANT IF ELSE WHILE LENGTH 
%token <str>  TRUET FALSET THIS NEW
%token <str>  INTLIT IDT
%token <str>  LCURL RCURL LPAR RPAR LSQUARE RSQUARE 
%token <str>  SEMICOLON EQUAL 
%token <str>  AND OR NOTEQUAL LEQ
%token <str>  PLUS MINUS MUL DIV DOTOP NOT COMMA
%token <str>  MACRODEF

//Non-terminal declarations
%type  <str>  Goal MacroDefinitionStar MainClass TypeDeclarationStar
%type  <str>  MacroDefinition TypeDeclaration
%type  <str>  Identifier Expression
%type  <str>  TypeIdentifierStar MethodDeclarationStar Type
%type  <str>  MethodDeclaration TypeIdentifierCommaList StatementStar Statement
%type  <str>  TypeIdCommaStar
%type  <str>  NextStatement ExpressionCommaList CommaExpressionStar
%type  <str>  PrimaryExpression AnotherExpression ExpFollowingDot
%type  <str>  IntegerNT ExpFollowingNew
%type  <str>  MacroDefStatement MacroDefExpression Parameters CommaIdentifierStar



%%


Goal : MacroDefinitionStar MainClass TypeDeclarationStar{

        int len = 1000+strlen($1)+strlen($2)+strlen($3);
        $$ = (char*)malloc(len*sizeof(char));
        snprintf($$,len,"%s\n%s\n%s",$1,$2,$3);
        printf("%s",$$);
    }
;
MacroDefinitionStar : MacroDefinition MacroDefinitionStar{

                            int len = 1000 + strlen($1)+strlen($2);
                            $$ = (char*)malloc(len*sizeof(char));
                            snprintf($$,len,"%s%s",$1,$2);
                        }
                      | {
                            $$ = "\0";
                      }
;
TypeDeclarationStar : TypeDeclaration TypeDeclarationStar
                        {
                            int len = strlen($1)+strlen($2)+1000;
                            $$ = (char*)malloc(len*sizeof(char));
                            snprintf($$,len,"%s%s",$1,$2);
                        }
                      |{
                            $$ = "\0";
                      }
;
MainClass : CLASS Identifier LCURL PUBLIC STATIC VOIDT MAIN LPAR STRING LSQUARE RSQUARE Identifier RPAR LCURL PRINT LPAR Expression RPAR SEMICOLON RCURL RCURL
                {
                    int len = 1000 + strlen($2) + strlen($12) + strlen($17);
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"class %s {public static void main(String[] %s){\n System.out.println(%s);\n}\n}\n",$2,$12,$17);
                }
;
TypeDeclaration : CLASS Identifier LCURL TypeIdentifierStar MethodDeclarationStar RCURL
                    {
                        int len = 1000+strlen($2)+strlen($4)+strlen($5);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"class %s {%s %s}\n",$2,$4,$5);
                    }
                  | CLASS Identifier EXTENDS Identifier LCURL TypeIdentifierStar MethodDeclarationStar RCURL
                  {
                        int len = 1000+strlen($2)+strlen($4)+strlen($6)+strlen($7);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"class %s extends %s{%s %s}\n",$2,$4,$6,$7);
                  }
;
TypeIdentifierStar : TypeIdentifierStar Type Identifier SEMICOLON 
                    {
                        int len = 1000+strlen($1)+strlen($2)+strlen($3);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"%s %s %s;\n",$1,$2,$3);
                    }
                      |{
                            $$ = "\0";
                      }
;
MethodDeclarationStar : MethodDeclaration MethodDeclarationStar
                        {
                            int len = 1000+strlen($1)+strlen($2);
                            $$ = (char*)malloc(len*sizeof(char));
                            snprintf($$,len,"%s %s",$1,$2);
                        }
                        |{
                            $$ = "\0";
                        }
;
MethodDeclaration : PUBLIC Type Identifier LPAR TypeIdentifierCommaList RPAR LCURL TypeIdentifierStar StatementStar RETURN Expression SEMICOLON RCURL
                    {
                        int len = 1000+strlen($2)+strlen($3)+strlen($5)+strlen($8)+strlen($9)+strlen($11);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"public %s %s(%s){\n %s %s return %s;\n}\n",$2,$3,$5,$8,$9,$11);
                    }
;
StatementStar : Statement StatementStar{

                    int len = 1000 + strlen($1)+ strlen($2);
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"%s %s",$1,$2);

                }
                |{
                    $$ = "\0";
                }
;
TypeIdentifierCommaList : Type Identifier TypeIdCommaStar{

                            int len = 1000 + strlen($1) + strlen($2) + strlen($3);
                            $$ = (char*)malloc(len*sizeof(char));
                            snprintf($$,len,"%s %s %s",$1,$2,$3);
                        }
                        |{
                            $$ = "\0";
                        }
;
TypeIdCommaStar : COMMA Type Identifier TypeIdCommaStar{

                        int len = 1000 + strlen($2) + strlen($3) + strlen($4);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,",%s %s %s",$2,$3,$4);
                }
                |{
                    $$ = "\0";
                }
;
Type : INTT LSQUARE RSQUARE{

            int len = 1000;
            $$ = (char*)malloc(len*sizeof(char));
            snprintf($$,len,"int[] ");
        }
      | BOOLEANT{

            int len = 1000;
            $$ = (char*)malloc(len*sizeof(char));
            snprintf($$,len,"boolean ");
      }
      | INTT{

            int len = 1000;
            $$ = (char*)malloc(len*sizeof(char));
            snprintf($$,len,"int ");
      }
      | Identifier{

            int len = 1000 + strlen($1);
            $$ = (char*)malloc(len*sizeof(char));
            snprintf($$,len,"%s",$1);
      }
;
Statement : LCURL StatementStar RCURL{

                int len = 1000+strlen($2);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"{%s}",$2);

            }
          | PRINT LPAR Expression RPAR SEMICOLON{

                int len = 1000 + strlen($3);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"System.out.println(%s);\n",$3);

          }
          | Identifier EQUAL Expression SEMICOLON{

                int len = 1000+strlen($1)+strlen($3);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"%s = %s;\n",$1,$3);

          }
          | Identifier LSQUARE Expression RSQUARE EQUAL Expression SEMICOLON{

                int len = 1000+strlen($1)+strlen($3)+strlen($6);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"%s[%s]=%s;\n",$1,$3,$6);

          }
          | IF LPAR Expression RPAR Statement NextStatement{

                int len = 1000+strlen($3)+strlen($5)+strlen($6);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"if(%s)%s %s",$3,$5,$6);

          }
          | WHILE LPAR Expression RPAR Statement{

                int len = 1000+strlen($3)+strlen($5);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"while(%s) %s",$3,$5);

          }
          | Identifier LPAR ExpressionCommaList RPAR SEMICOLON{         

                char* ArgValList = strdup($3);
                char* token = strtok(ArgValList,",");
                char* ArgValArray[1000];

                int i=0;
                while(token!=NULL)
                {
                    ArgValArray[i]=strdup(token);
                    token = strtok(NULL,",");
                    i++;
                }

                char* MacroName = strdup($1);
                int mnum = findMacroIndex(MacroName);
                //printf("%d",mnum);

                char* replacedAction = strdup(MacroActions[mnum]);

                for(int j=0;j<MacroNumberofArgs[mnum];j++)
                { 
                    //replace MacroParsList[mnum][j] with ArgValArray[j] everywhere it occurs in replacedAction
                    replacedAction = replaceEverywhere(replacedAction,MacroParsList[mnum][j],ArgValArray[j]);
                }

                int len = 1000 + strlen(replacedAction);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"%s\n",replacedAction);

          }
;
ExpressionCommaList : Expression CommaExpressionStar{

                        int len = 1000+strlen($1)+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"%s %s",$1,$2);

                    }
                    |{
                        $$ = "\0";
                    }
;
CommaExpressionStar : COMMA Expression CommaExpressionStar{

                        int len = 1000+strlen($2)+strlen($3);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,",%s%s",$2,$3);

                    }
                    |{
                        $$ = "\0";
                    }
;
NextStatement : ELSE Statement{

                    int len = 1000+strlen($2);
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"else %s",$2);

                }
              |{
                $$ = "\0";
              }
;
Expression : PrimaryExpression AnotherExpression{

                int len = 1000+strlen($1)+strlen($2);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"%s %s",$1,$2);

            }
            | Identifier LPAR ExpressionCommaList RPAR{       //lot of changes to be made here

                char* ArgValList = strdup($3);
                char* token = strtok(ArgValList,",");
                char* ArgValArray[1000];

                int i=0;
                while(token!=NULL)
                {
                    ArgValArray[i]=strdup(token);
                    token = strtok(NULL,",");
                    i++;
                }

                char* MacroName = strdup($1);
                int mnum = findMacroIndex(MacroName);

                char* replacedAction = strdup(MacroActions[mnum]);

                for(int j=0;j<MacroNumberofArgs[mnum];j++)
                { 
                    //replace MacroParsList[mnum][j] with ArgValArray[j] everywhere it occurs in replacedAction
                    replacedAction = replaceEverywhere(replacedAction,MacroParsList[mnum][j],ArgValArray[j]);
                }

                int len = 1000 + strlen(replacedAction);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"(%s)",replacedAction);
            }
;
AnotherExpression :   AND PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"&& %s",$2);

                    }
                    | OR PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"|| %s",$2);

                    }
                    | NOTEQUAL PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"!=%s",$2);

                    }
                    | LEQ PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"<=%s",$2);

                    }
                    | PLUS PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"+%s",$2);

                    }
                    | MINUS PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"-%s",$2);

                    }
                    | MUL PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"*%s",$2);

                    }
                    | DIV PrimaryExpression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"/%s",$2);

                    }
                    | LSQUARE PrimaryExpression RSQUARE{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"[%s]",$2);

                    }
                    | DOTOP ExpFollowingDot{

                        int len = 1000 + strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,".%s",$2);
                    }
                    |{
                        $$ = "\0";
                    }
;
ExpFollowingDot : Identifier LPAR ExpressionCommaList RPAR{

                    int len = 1000 + strlen($1) + strlen($3);
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"%s(%s)",$1,$3);

                }
                | LENGTH{

                    int len = 1000;
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"length");
                }
;
PrimaryExpression :   IntegerNT{

                        int len = strlen($1) + 1000;
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"%s",$1);
                    }
                    | TRUET{

                        int len = 1000;
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"true ");

                    }
                    | FALSET{

                        int len = 1000;
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"false ");

                    }
                    | Identifier{

                        int len = 1000+strlen($1);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"%s",$1);
                    }
                    | THIS{

                        int len = 1000;
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"this ");

                    }
                    | NEW ExpFollowingNew{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"new %s",$2);
                    }
                    | NOT Expression{

                        int len = 1000+strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"!%s",$2);
                    }
                    | LPAR Expression RPAR{

                        int len = 1000 + strlen($2);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"(%s)",$2);
                    }
;
ExpFollowingNew : INTT LSQUARE Expression RSQUARE{

                    int len = strlen($3) + 1000;
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"int[%s]",$3);
                }
                | Identifier LPAR RPAR{

                    int len = 1000 + strlen($1);
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"%s()",$1);
                }
;
MacroDefinition : MacroDefStatement{
                    $$ = "\0";
                }
                | MacroDefExpression{
                    $$ = "\0";
                }
;
MacroDefStatement : MACRODEF Identifier LPAR Parameters RPAR LCURL StatementStar RCURL
                    {
                        MacroIDList[MacroIndex] = strdup($2);
                        MacroIDList[MacroIndex][strlen($2)]='\0';
                        MacroActions[MacroIndex] = strdup($7);
                        MacroActions[MacroIndex][strlen($7)]='\0';

                        MacroNumberofArgs[MacroIndex]=0;

                        char* ParsList = strdup($4);
                        char* token = strtok(ParsList,",");

                        int i=0;
                        while(token!=NULL)
                        {
                            MacroParsList[MacroIndex][i]=strdup(token);
                            MacroParsList[MacroIndex][i][strlen(token)]='\0';
                            token = strtok(NULL, ",");
                            i++;
                        }
                        MacroNumberofArgs[MacroIndex] = i;
                        MacroIndex++;
                    }
;
MacroDefExpression: MACRODEF Identifier LPAR Parameters RPAR LPAR Expression RPAR
                    {
                        MacroIDList[MacroIndex] = strdup($2);
                        MacroIDList[MacroIndex][strlen($2)]='\0';
                        MacroActions[MacroIndex] = strdup($7);
                        MacroActions[MacroIndex][strlen($7)]='\0';

                        MacroNumberofArgs[MacroIndex]=0;

                        char* ParsList = strdup($4);
                        char* token = strtok(ParsList,",");

                        int i=0;
                        while(token!=NULL)
                        {
                            MacroParsList[MacroIndex][i]=strdup(token);
                            MacroParsList[MacroIndex][i][strlen(token)]='\0';
                            token = strtok(NULL, ",");
                            i++;
                        }
                        MacroNumberofArgs[MacroIndex] = i;
                        MacroIndex++;
                    }
;
Parameters : Identifier CommaIdentifierStar{

                int len = 1000 + strlen($1) + strlen($2);
                $$ = (char*)malloc(len*sizeof(char));
                snprintf($$,len,"%s %s",$1,$2);
            }
          | {
                $$ = "\0";
          }
;
CommaIdentifierStar : COMMA Identifier CommaIdentifierStar{

                        int len = strlen($2) + strlen($3) + 1000;
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,", %s %s",$2,$3);
                    }

                    |{
                        $$ = "\0";
                    }
;
Identifier : IDT{
                    int len = 1000 + strlen($1);
                    $$ = (char*)malloc(len*sizeof(char));
                    snprintf($$,len,"%s",$1);
                }
;
IntegerNT : INTLIT  {
                        int len = 1000 + strlen($1);
                        $$ = (char*)malloc(len*sizeof(char));
                        snprintf($$,len,"%s",$1);
                    }
;


%%

void yyerror (const char *s) {
  printf ("Failed to parse input code\n");
}

int main () {
  yyparse ();

  /*for(int i=0;i<MacroIndex;i++) 
    {
        printf("\n%s ",MacroIDList[i]);
        for(int j=0;j<MacroNumberofArgs[i];j++)
        {
            printf("%s ",MacroParsList[i][j]);
        }
        printf("%s \n",MacroActions[i]);
    }*/

	return 0;
}

#include "lex.yy.c"
