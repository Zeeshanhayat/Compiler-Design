/* Count and prints the number of lines. */
%option noyywrap
%{
  int num_lines = 0, num_chars = 0;    
%}  

%%
\n      ++num_lines; ++num_chars;
.       ++num_chars;
     
%%

int main()
{
  yylex();
  printf( "# of lines = %d\n# of chars = %d\n", num_lines, num_chars );
  return 0;
}