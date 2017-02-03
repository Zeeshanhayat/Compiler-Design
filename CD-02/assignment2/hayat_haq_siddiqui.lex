
/*
Assignment 2 Lexer 
Zeehsan Hayat 387503,
Muhammad Ikram Ul Haq 387605, 
Asim Siddiqui 387527 */

%option noyywrap
%{
#include "hayat_haq_siddiqui.yy.h"
int num_lines = 1;
#include <math.h> // for atof()
#include <string.h>
static void countMultiCommentLines(char *);

%}
   

BOOLEAN    					true|false 
FL                   (((([0-9]+[.][0-9]*)|([0-9]*[.][0-9]+)))|([0-9]*[eE][-+]?[0-9]+))+(f|F|lf|LF)?
     
INT                     (0[xX][0-9a-fA-F]+|[0-9]+)[Uu]?

/*
C_KEYWORD					class|break|case|continue|default|do|double|else|enum|extern|for|goto|if|sizeof|static|struct|switch|typedef|union|unsigned|while
*/

CROSS                         cross	
TRACE                         trace
SQRT                          sqrt
REFLECT                       reflect
DOT                           dot
POW                           pow
COLOR                         color
WHILE                         while
BOOL                          bool
RE                            return
IF                            if
ELSE                          else  
FOR                           for  
CLASS                         class
INTEGER						  int
FLOAT                         float
VOID                          void
RTSL_KEYWORD				illuminance|ambient
NORMALIZE                   normalize
/*
BUILT_IN_KEYWORDS 		dominantAxis|dot|hit|inside|inverse|luminance|max|min|normalize|perpendicularTo|pow|rand|reflect|sqrt|trace
*/
/*TYPE_DEFAULT				int|float|bool|void*/
TYPE_VECTOR					vec2|vec3|vec4|ivec2|ivec3|ivec4|bvec2|bvec3|bvec4
/* TYPE_BUILT_IN				rt_Primitive|rt_Camera|rt_Material|rt_Texture|rt_Light */


MATERIAL                        rt_Material                 
CAMERA                          rt_Camera
PRIMITIVE                       rt_Primitive
TEXTURE                         rt_Texture  
LIGHT                           rt_Light

QUALIFIER_VARI				attribute|uniform|varying
QUALIFIER_CLASS			public|private|scratch
QUALIFIER					const

DIGIT    					[0-9]
IDENTIFIER       			[a-zA-Z]+[a-zA-Z0-9_]*

SWIZZLE						[.][a-zA-Z]+
STATE                   rt_ 

%% 
{CROSS}                 return(CROSS);
{TRACE}                 return(TRACE);
{SQRT}                  return(SQRT);
{REFLECT}               return(REFLECT);
{DOT}             		return(DOT);
{NORMALIZE}             return(NORMALIZE);
{POW}                   return(POW);
{COLOR}					return(COLOR);
{WHILE}					return(WHILE);
{BOOL}                  return(BOOL);
{RE}					return(RE);
{INTEGER}	            return(INTEGER);
{VOID}					return(VOID);	
{FLOAT}	                return(FLOAT);
{BOOLEAN}               return(BOOLEAN);
{INT}	                return(INT); 
{FL}					return(FL);
{IF}               		return(IF);
{ELSE}	                return(ELSE);  
{FOR}	                return(FOR); 
{CLASS}					return(CLASS);


{RTSL_KEYWORD}			return(RTSL_KEYWORD);

{TYPE_VECTOR}	       	return(TYPE_VECTOR);
{MATERIAL}              return(MATERIAL);
{CAMERA}                return(CAMERA);
{LIGHT}                 return(LIGHT);
{TEXTURE}               return(TEXTURE);
{PRIMITIVE}             return(PRIMITIVE);
{QUALIFIER_VARI}		return(QUALIFIER_VARI);   
{QUALIFIER_CLASS}	    return(QUALIFIER_CLASS);
{QUALIFIER}	       		return(QUALIFIER);
{STATE}{IDENTIFIER}     {stateFlag(yytext);return(STATE);}
{IDENTIFIER}	       	{setFlag(yytext);return(IDENTIFIER);}
{IDENTIFIER}{SWIZZLE}	return(SWIZZLE);


"+"                     {return ADD;}
"-"                     {return SUB;}
"*"	                  	{return MUL;} 
"/"                     {return DIV;}    
"="                     {return ASSIGN;}  
"=="					{return EQL;}
"!="					{return NE;}
"<"						{return LER;}
"<="					{return LEQ;}
">"						{return GTR;}
">="					{return GEQ;}
","						{return COMMA;}
":"						{return COLON;}
";"						{return SEMICOLON;}
"("						{return LPAREN;}
")"						{return RPAREN;}
"["						{return LSPAREN;}
"]"						{return RSPAREN;}
"{"						{return LBRACES;}
"}"						{return RBRACES;}
"&&"					{return ANDOP;}
"||"					{return OROP;}
"++"					{return INC;}
"--" 					{return DEC;}



\n								++num_lines; 

[ \t\r\v\f]+	     /* eat up whitespace, tabs, new line, carriage return,Vertical tab,form feed */ ;

 "//"[^\r\n]*         /* eat up single line comment */ ;
 
"/*"([^*]|\*+[^*/])*\*+"/"     countMultiCommentLines(yytext); /* eat up single multi line comment  ; */

.							  printf( "ERROR(%d): Unrecognized symbol \"%s\"\n",num_lines,yytext);
     
%%

static void countMultiCommentLines(char* inputString){
int i ;
	for (i=0; i< strlen(inputString);i++){
  		 if (inputString[i] == '\n'){
			 ++num_lines;
		}
	}
	
}

