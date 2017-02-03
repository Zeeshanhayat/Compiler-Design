/* Minimal example: it only replace any occurence of "username".  */ 
%option noyywrap
%%
username printf("%s", getlogin());
%%
int main() {
  yylex();
  return 0;
}