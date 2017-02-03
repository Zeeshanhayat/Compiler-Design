/* Code to classify tokens  */ 
%option noyywrap
%{
  int tokenCount=0;
%}
%%
[a-zA-Z]+ { printf("%d WORD \"%s\"\n", ++tokenCount, yytext); }
[0-9]+    { printf("%d NUMBER \"%s\"\n", ++tokenCount, yytext); }
[^a-zA-Z0-9]+   { printf("%d OTHER \"%s\"\n", ++tokenCount, yytext); }
%%
int main() {
  yylex();
  return 0;
}
