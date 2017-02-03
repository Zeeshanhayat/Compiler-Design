
/* 
Assignment 2 Parser
Zeehsan Hayat 387503, 
Muhammad Ikram Ul Haq 387605, 
Asim Siddiqui 387527
 */

%{
#include <stdio.h>
extern int yylex(); // Declared by lexer
void yyerror(const char *s); // Declared later in file
void flagCheck();
void setFlag(char *s);

int stateCamera = 0;
int stateMaterial = 0;
int stateTexture = 0;
int statePrimitive = 0;
int stateLight = 0;

int methodCamera = 0;
int methodMaterial = 0;
int methodTexture = 0;
int methodPrimitive = 0;
int methodLight = 0;

%}

/* declare tokens */
%token NUMBER
%token IF ELSE FOR
%token CLASS
%token BOOLEAN INT FLOAT FL RTSL_KEYWORD TYPE_DEFAULT TYPE_VECTOR 
%token QUALIFIER_VARI QUALIFIER_CLASS QUALIFIER STATE IDENTIFIER SWIZZLE 
%token ADD SUB MUL DIV ASSIGN EQL NE LER LEQ GTR GEQ COMMA COLON SEMICOLON LPAREN RPAREN LSPAREN RSPAREN 
%token LBRACES RBRACES ANDOP OROP INC DEC
%token EOL ABS CP OP
%token MATERIAL CAMERA LIGHT PRIMITIVE TEXTURE 
%token VOID
%token INTEGER
%token RE
%token BOOL
%token WHILE
%token COLOR
%token POW
%token DIGIT
%token NORMALIZE
%token DOT
%token REFLECT
%token SQRT
%token TRACE
%token CROSS
%right GTR LER GEQ LEQ
%left DIV MUL SUB ADD
%define parse.error verbose
%%
 
MAINPROGRAM : PROGRAM ;

SHADER_DEF : CLASS IDENTIFIER COLON MATERIAL SEMICOLON
					{ printf("SHADER_DEF material");stateMaterial=1;}					   
						| CLASS IDENTIFIER COLON CAMERA	SEMICOLON 
						{ printf("SHADER_DEF camera");stateCamera=1;} 
						| CLASS IDENTIFIER COLON PRIMITIVE SEMICOLON
						{ printf("SHADER_DEF primitive");statePrimitive=1;} 
				 		| CLASS IDENTIFIER COLON TEXTURE SEMICOLON	 
				 		{ printf("SHADER_DEF texture"); stateTexture=1;} 
						| CLASS IDENTIFIER COLON LIGHT SEMICOLON	     
						{ printf("SHADER_DEF light");stateLight=1;}
						;


PROGRAM 
	: SHADER_DEF DECLARATION FUNCTION_DEF_RULE 
	| SHADER_DEF FUNCTION_DEF_RULE DECLARATION  
	;

FUNCTION_DEF_RULE
	: FUNCTION_DEF
	| FUNCTION_DEF_RULE FUNCTION_DEF
	;

FUNCTION_DEF
	: TYPE_SPECIFIER IDENTIFIER LPAREN EXPRESSION RPAREN LBRACES BLOCK_ITEM_LIST RBRACES 
	  {printf("\nFUNCTION_DEF");}	
	| TYPE_SPECIFIER IDENTIFIER LPAREN RPAREN LBRACES BLOCK_ITEM_LIST RBRACES
	  {printf("\nFUNCTION_DEF");}	
	| TYPE_SPECIFIER IDENTIFIER LPAREN RPAREN LBRACES RBRACES
	  {printf("\nFUNCTION_DEF");}	
	;


DECLARATION
	: DECLARATION_RULE
	| DECLARATION DECLARATION_RULE
	;


DECLARATION_RULE
	:	DECLARATION_RULE SEMICOLON	
	|	QUALIFIER_CLASS TYPE_VECTOR IDENTIFIER  
		{printf("\nDECLARATION");}
	|	QUALIFIER_CLASS TYPE_SPECIFIER IDENTIFIER  
		{printf("\nDECLARATION");}
	|	TYPE_SPECIFIER EXPRESSION_STATEMENT
		{printf("\nDECLARATION");}
	|   TYPE_VECTOR IDENTIFIER RELATIONAL_ASSIGN_OPERATOR STATE 
 	  	{printf("\nDECLARATION");}	
	|	TYPE_SPECIFIER IDENTIFIER RELATIONAL_ASSIGN_OPERATOR FUNCTIONAL_EXPRESSION
		{printf("\nDECLARATION");}
	|   TYPE_VECTOR IDENTIFIER RELATIONAL_ASSIGN_OPERATOR NORMALIZE LPAREN STATE RPAREN 
 	  	{printf("\nDECLARATION");}
  	|   TYPE_SPECIFIER IDENTIFIER RELATIONAL_ASSIGN_OPERATOR TYPE_SPECIFIER LPAREN FL RPAREN 
  		{printf("\nDECLARATION");}		 		
	| TYPE_SPECIFIER IDENTIFIER RELATIONAL_ASSIGN_OPERATOR POWER_EXPRESSION 
 	  {printf("\nDECLARATION");}	
	|   TYPE_VECTOR TYPE_VECTOR_DECLARATION
		{printf("\nDECLARATION");}
 ;

TYPE_VECTOR_DECLARATION 
	: IDENTIFIER RELATIONAL_ASSIGN_OPERATOR TYPE_VECTOR_DECLARATION
	| IDENTIFIER RELATIONAL_ASSIGN_OPERATOR IDENTIFIER 
	| FUNCTIONAL_EXPRESSION
	;	

EXPRESSION_STATEMENT
	: SEMICOLON
	| EXPRESSION SEMICOLON
	;

STATEMENT
	: SELECTION_STATEMENT
	| JUMP_STATEMENT
	| COMPOUND_STATEMENT
	| ASSIGNMENT_STATEMENT
	| ITERATION_STATEMENT
	;

SELECTION_STATEMENT	
	:	IF LPAREN EXPRESSION RPAREN STATEMENT ELSE STATEMENT
		{printf("\nIF - ELSE");}
		{printf("\nSTATEMENT");}
	|	IF LPAREN EXPRESSION RPAREN STATEMENT
		{printf("\nIF");}
		{printf("\nSTATEMENT");}
	;

JUMP_STATEMENT	
	:	RE SEMICOLON
	| 	RE FL SEMICOLON
		{printf("\nSTATEMENT");}
	;

COMPOUND_STATEMENT
	:	LBRACES RBRACES
	|	LBRACES BLOCK_ITEM_LIST RBRACES
		{printf("\nSTATEMENT");}	
	;	 

ASSIGNMENT_STATEMENT
	: EXPRESSION_STATEMENT 
	  {printf("\nSTATEMENT");}
	| ASSIGNMENT_STATEMENT SEMICOLON  
	| EXPRESSION LPAREN IDENTIFIER RPAREN
	  {printf("\nSTATEMENT");}
	| EXPRESSION LPAREN EXPRESSION COMMA EXPRESSION RPAREN 
	  {printf("\nSTATEMENT");}	  	  	
	| IDENTIFIER RELATIONAL_ASSIGN_OPERATOR POWER_EXPRESSION 
 	  {printf("\nSTATEMENT");}
  	| IDENTIFIER RELATIONAL_ASSIGN_OPERATOR FUNCTIONAL_EXPRESSION 
 	  {printf("\nSTATEMENT");}
  	|   IDENTIFIER RELATIONAL_ASSIGN_OPERATOR IDENTIFIER MULTIPLE_EXPRESSION
	  {printf("\nSTATEMENT");}
	|	STATE RELATIONAL_ASSIGN_OPERATOR STATE 
 		{printf("\nSTATEMENT");}
 	;

ITERATION_STATEMENT
	: WHILE LPAREN EXPRESSION RPAREN STATEMENT
	  {printf("\nSTATEMENT");}	
	| FOR LPAREN EXPRESSION_STATEMENT EXPRESSION_STATEMENT RPAREN STATEMENT
	  {printf("\nSTATEMENT");}
	| FOR LPAREN EXPRESSION_STATEMENT EXPRESSION_STATEMENT EXPRESSION RPAREN STATEMENT
	  {printf("\nSTATEMENT");}
	| FOR LPAREN DECLARATION EXPRESSION_STATEMENT RPAREN STATEMENT
	  {printf("\nSTATEMENT");}
	| FOR LPAREN DECLARATION EXPRESSION_STATEMENT EXPRESSION RPAREN STATEMENT
	  {printf("\nSTATEMENT");}
	;		 

RELATIONAL_ASSIGN_OPERATOR	
	:	ASSIGN
	|	EQL
	| 	NE
	|	LER
	|	LEQ
	|	GTR
	|	GEQ
	;

BLOCK_ITEM_LIST
	: BLOCK_ITEM
	| BLOCK_ITEM_LIST BLOCK_ITEM	
	;

BLOCK_ITEM 	
	: DECLARATION
	| STATEMENT
	;		

EXPRESSION
	:	IDENTIFIER
	|   TYPE_SPECIFIER IDENTIFIER 
	|   TYPE_VECTOR IDENTIFIER
	|	IDENTIFIER RELATIONAL_ASSIGN_OPERATOR TYPE_SPECIFIER
	|	IDENTIFIER RELATIONAL_ASSIGN_OPERATOR FL
	|	IDENTIFIER RELATIONAL_ASSIGN_OPERATOR MULTIPLE_EXPRESSION
	|   STATE RELATIONAL_ASSIGN_OPERATOR MULTIPLE_EXPRESSION
	|	STATE RELATIONAL_ASSIGN_OPERATOR TYPE_SPECIFIER MULTIPLE_EXPRESSION
	|	EXPRESSION COMMA EXPRESSION 
	|   IDENTIFIER BINARY_OPERATOR RELATIONAL_ASSIGN_OPERATOR FL 
	|   IDENTIFIER LOGICAL_UNARY_OPERATOR  
    |	FUNCTIONAL_EXPRESSION RELATIONAL_ASSIGN_OPERATOR MULTIPLE_EXPRESSION
    ; 

FUNCTIONAL_EXPRESSION
	: IDENTIFIER
	| STATE COMMA STATE
	| LPAREN FUNCTIONAL_EXPRESSION RPAREN
	| DOT FUNCTIONAL_EXPRESSION
	| FUNCTIONAL_EXPRESSION COMMA FUNCTIONAL_EXPRESSION	
	| TRACE FUNCTIONAL_EXPRESSION
	| REFLECT FUNCTIONAL_EXPRESSION
	| CROSS MULTIPLE_EXPRESSION
	| NORMALIZE FUNCTIONAL_EXPRESSION
	;

TYPE_SPECIFIER 
	: VOID
	| FLOAT
	| INT
	| BOOLEAN
	| INTEGER
	| BOOL
	| COLOR
	;

BINARY_OPERATOR
	: MUL
	| ADD
	| SUB
	| DIV
	;

LOGICAL_UNARY_OPERATOR
	: ANDOP
	| OROP
	| INC
	| DEC
	;


POWER_EXPRESSION
	: POW
	| POWER_EXPRESSION MULTIPLE_EXPRESSION
	| MULTIPLE_EXPRESSION POWER_EXPRESSION MULTIPLE_EXPRESSION
	;


MULTIPLE_EXPRESSION
	: IDENTIFIER
    | FL
	| INT
	| SWIZZLE
	| SQRT MULTIPLE_EXPRESSION 
	| MULTIPLE_EXPRESSION ADD MULTIPLE_EXPRESSION	 
	| MULTIPLE_EXPRESSION SUB MULTIPLE_EXPRESSION	 
	| MULTIPLE_EXPRESSION MUL MULTIPLE_EXPRESSION 
	| MULTIPLE_EXPRESSION DIV MULTIPLE_EXPRESSION	 
	| LPAREN MULTIPLE_EXPRESSION RPAREN		 
	| MULTIPLE_EXPRESSION COMMA MULTIPLE_EXPRESSION
	| MULTIPLE_EXPRESSION COMMA STATE
	| BINARY_OPERATOR MULTIPLE_EXPRESSION
	| MULTIPLE_EXPRESSION BINARY_OPERATOR 
	;


%%
void flagCheck()
{
	if(stateCamera)
	{
		if(methodMaterial)
			yyerror("camera cannot have an interface method of material");
		if(methodTexture)
			yyerror("camera cannot access rt_TextureUVW");
		if(methodLight)
			yyerror("camera cannot have an interface method of light");
		if(methodPrimitive)
			yyerror("camera cannot have an interface method of primitive");
	}
	if(stateMaterial)
	{
		if(methodCamera)
			yyerror("material cannot have an interface method of camera");
		if(methodTexture)
			yyerror("material cannot have an interface method of texture");
		if(methodLight)
			yyerror("material cannot have an interface method of light");
		if(methodPrimitive)
			yyerror("material cannot have an interface method of primitive");
	}
	if(stateLight)
	{
		if(methodCamera)
			yyerror("light cannot have an interface method of camera");
		if(methodTexture)
			yyerror("light cannot have an interface method of texture");
		if(methodMaterial)
			yyerror("light cannot have an interface method of material");
		if(methodPrimitive)
			yyerror("light cannot have an interface method of primitive");
	}
	if(stateTexture)
	{
		if(methodCamera)
			yyerror("texture cannot have an interface method of camera");
		if(methodLight)
			yyerror("texture cannot have an interface method of light");
		if(methodMaterial)
			yyerror("texture cannot have an interface method of material");
		if(methodPrimitive)
			yyerror("texture cannot have an interface method of primitive");
	}
	if(statePrimitive)
	{
		if(methodCamera)
			yyerror("primitive cannot have an interface method of camera");
		if(methodLight)
			yyerror("primitive cannot have an interface method of light");
		if(methodMaterial)
			yyerror("primitive cannot have an interface method of material");
		if(methodTexture)
			yyerror("primitive cannot have an interface method of texture");
	}
			
}
void setFlag(char *s)
{

	if(strcmp(s, "shade")==0)
		{
		methodMaterial=1; //shade is an interface method of material
	   }
	if(strcmp(s, "generateRay")==0)
		{
		methodCamera=1; //generateRay is an interface method of material
		}
    if(strcmp(s, "lookup")==0)
		{
		methodTexture=1; 
		}
	if(strcmp(s, "rt_TextureUVW")==0)
		{
		methodTexture=1; 
		}
	if(strcmp(s, "illumination")==0)
		{
		methodLight=1; 
		}
	

}

void stateFlag(char *s)
{

	
	if(strcmp(s, "rt_TextureUVW")==0)
		{
		methodTexture=1; 
		}
	

}

int main()
{
  yyparse();
  flagCheck();

}

void yyerror(const char *s)
{
  fprintf(stderr, "Error: %s\n", s);
}


