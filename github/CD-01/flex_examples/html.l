/* Prints all the <html> tags in a file. */
%option noyywrap
%{
#include <stdio.h>
%}
%%
"<"[^>]*> { printf("VALUE: %s\n", yytext); }
.|\n     ;
%%
int main()
{
  yylex();
  return 0;
} 
