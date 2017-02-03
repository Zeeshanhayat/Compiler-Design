Flex examples for the course "Compiler Design", Technische Universitaet Berlin

Flex sources are available at:
    https://github.com/westes/flex
A HTML version of the Flex manual is available at:
    http://westes.github.io/flex/manual/

The folder contains a list of examples you can browse and test with flex:

 1. lines
 2. ws
 3. tokens
 4. html
 5. punctuation
 6. username
 7. lexlongword
 8. pascal-simple 

For each code, you can create a lexer by invoking flex by command line, e.g.:

> flex -olines.c lines.l

where lines.l is the input lex file and lines.c the generated source for the lexer.
Then, you and compile the lexer with the following command:

> gcc lines.c -o lines.out

Once you have compiled your lexer, you can test it with an input file:

> ./lines.out < input.txt

or, instead, with a input string provided by the standard input:

> ./lines.out 
(press CTRL+D to add a EOF)

