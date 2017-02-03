/* Zeehsan Hayat, Muhammad Ikram Ul Haq, Asim Siddique */
%option noyywrap
%{
int num_lines = 1;
#include <math.h> // for atof()
#include <string.h>
static void countMultiCommentLines(char *);
%}
   

BOOLEAN    					true|false 
FLOAT                   (((([0-9]+[.][0-9]*)|([0-9]*[.][0-9]+)))|([0-9]*[eE][-+]?[0-9]+))+(f|F|lf|LF)?      
INT                     (0[xX][0-9a-fA-F]+|[0-9]+)[Uu]?


C_KEYWORD					class|break|case|continue|default|do|double|else|enum|extern|for|goto|if|sizeof|static|struct|switch|typedef|union|unsigned|while
RTSL_KEYWORD				illuminance|ambient
BUILT_IN_KEYWORDS 		dominantAxis|dot|hit|inside|inverse|luminance|max|min|normalize|perpendicularTo|pow|rand|reflect|sqrt|trace

TYPE_DEFAULT				int|float|bool|void
TYPE_VECTOR					vec2|vec3|vec4|ivec2|ivec3|ivec4|bvec2|bvec3|bvec4
TYPE_BUILT_IN				rt_Primitive|rt_Camera|rt_Material|rt_Texture|rt_Light

QUALIFIER_VARI				attribute|uniform|varying
QUALIFIER_CLASS			public|private|scratch
QUALIFIER					const

DIGIT    					[0-9]
IDENTIFIER       			[a-zA-Z]+[a-zA-Z0-9_]*

SWIZZLE						[.][a-zA-Z]+
STATE                   rt_ 

%%     


{BOOLEAN}               printf( "BOOLEAN %s\n", yytext );

{INT}	                  { printf( "INT %s \n", yytext ); }
     
{FLOAT}						{ printf( "FLOAT %s\n", yytext); }

{C_KEYWORD}  			   printf( "KEYWORD %s\n", yytext );
		       			   
{RTSL_KEYWORD}			   printf( "KEYWORD %s\n", yytext );
		
{BUILT_IN_KEYWORDS}		printf( "KEYWORD %s\n", yytext );

{TYPE_DEFAULT}	       	printf( "TYPE %s\n", yytext );
	
{TYPE_VECTOR}	       	printf( "TYPE %s\n", yytext );
	
{TYPE_BUILT_IN}	      printf( "TYPE %s\n", yytext );
	
{QUALIFIER_VARI}		   printf( "QUALIFIER %s\n", yytext );
	
{QUALIFIER_CLASS}	      printf( "QUALIFIER %s\n", yytext );
	
{QUALIFIER}	       		printf( "QUALIFIER %s\n", yytext );

{STATE}{IDENTIFIER}     printf("STATE %s \n",yytext); 

{IDENTIFIER}	       	printf( "IDENTIFIER %s\n", yytext );

{SWIZZLE}					printf("SWIZZLE %s\n", yytext+1);

"+"                     printf("PLUS \n");
"-"                     printf("MINUS \n");
"*"	                  printf("MUL \n"); 
"/"                     printf("DIV \n");    
"="                     printf("ASSIGN \n");  
"=="							printf("EQUAL \n");
"!="							printf("NOT EQUAL\n");
"<"							printf("LT \n");
"<="							printf("LE \n");
">"							printf("GT \n");
">="							printf("GE \n");
","							printf("COMMA \n");
":"							printf("COLON \n");
";"							printf("SEMICOLON \n");
"("							printf("LPARENTHESIS \n");
")"							printf("RPARENTHESIS \n");
"["							printf("LBRACKET \n");
"]"							printf("RBRACKET \n");
"{"							printf("LBRACE \n");
"}"							printf("RBRACE \n");
"&&"							printf("AND \n");
"||"							printf("OR \n");
"++"							printf("INC \n");
"--" 							printf("DEC \n");



\n								++num_lines; 

[ \t\r\v\f]+	     /* eat up whitespace, tabs, new line, carriage return,Vertical tab,form feed */ ;

 "//"[^\r\n]*           ++num_lines; /* eat up single line comment */ ;
 
"/*"([^*]|\*+[^*/])*\*+"/"     countMultiCommentLines(yytext);/* eat up single multi line comment */ ;

.							  printf( "ERROR(%d): Unrecognized symbol \"%s\"\n",num_lines,yytext);
     
%%

static void countMultiCommentLines(char* inputString){
printf("multiline");
int i = 0 ;
char inputChar = inputString[i];
while(inputChar == '\'){
if(inputChar == 'n'){
++num_lines;
i++;
}
}
}
    
int main( int argc, char **argv )
{
  // we assume that the input file is given as input as first argument
  ++argv, --argc;   
  if ( argc > 0 )
    yyin = fopen( argv[0], "r" );
  else
    yyin = stdin;
  yylex();
  return 0;
}
