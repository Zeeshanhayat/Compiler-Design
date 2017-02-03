/* A program to count words, chars and lines. */
%option noyywrap
%{
int chars = 0;
int words = 0;
int lines = 0;
%}
%%
[a-zA-Z]+ { words++; chars += strlen(yytext); }
\n { chars++; lines++; }
.  { chars++; }
%%
int main(int argc, char **argv)
{
  yylex();
  printf("lines %d\nwords %d\nchars %d\n", lines, words, chars);
  return 0;
}
