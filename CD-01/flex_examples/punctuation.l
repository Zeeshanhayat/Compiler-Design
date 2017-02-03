/* Print the words followed by punctuation. */
%option noyywrap
%{
#include <stdio.h>
%}
%%
[a-zA-Z]+/[,;:".?!] { printf("Found: %s\n", yytext); }
.|\n     ;
%%
int main()
{
  yylex();
  return 0;
}