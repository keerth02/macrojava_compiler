INTEGER_LITERAL 	0|([1-9][0-9]*)
IDENTIFIER 			[a-zA-Z_][a-zA-Z0-9_]*
PRINTLN 			"System.out.println"

%%

"class"							{return CLASS;}
"public"						{return PUBLIC;}
"static"						{return STATIC;}
"void"							{return VOIDT;}
"main"							{return MAIN;}
"String"						{return STRING;}
{PRINTLN}						{return PRINT;}
"extends"						{return EXTENDS;}
"return"						{return RETURN;}
"int"							{return INTT;}
"boolean"						{return BOOLEANT;}
"if"							{return IF;}
"else"							{return ELSE;}
"while"							{return WHILE;}
"length"						{return LENGTH;}
"true"							{return TRUET;}
"false"							{return FALSET;}
"this"							{return THIS;}
"new"							{return NEW;}

{INTEGER_LITERAL}				{
									yylval.str = strdup(yytext);
									return INTLIT;
								}
{IDENTIFIER}					{
									yylval.str = strdup(yytext);
									return IDT;
								}

"{" 								{return LCURL;}
"}" 								{return RCURL;}
"(" 								{return LPAR;}
")" 								{return RPAR;}
"["									{return LSQUARE;}
"]"									{return RSQUARE;}
";" 								{return SEMICOLON;}
"&&"								{return AND;}
"||"								{return OR;}
"!="								{return NOTEQUAL;}
"<="								{return LEQ;}
"+"									{return PLUS;}
"-"									{return MINUS;}
"*"									{return MUL;}
"/"									{return DIV;}
"."									{return DOTOP;}
"!"									{return NOT;}
","									{return COMMA;}
"="									{return EQUAL;}

"#defineStmt0"			{return MACRODEF;}
"#defineStmt1"			{return MACRODEF;}
"#defineStmt2"			{return MACRODEF;}
"#defineStmt"			{return MACRODEF;}
"#defineExpr0"			{return MACRODEF;}
"#defineExpr1"			{return MACRODEF;}
"#defineExpr2"			{return MACRODEF;}
"#defineExpr"			{return MACRODEF;}

"//"[^\n]*				{}
"/*"("*"[^/]|[^*])*"*/" {}
[ \t]+			 		{}
[ \r]+			 		{}		
"\n"					{}
<<EOF>> 				{return 0;}
.						{return 1;}










