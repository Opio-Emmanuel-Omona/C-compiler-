# C-compiler-
Building a compiler for C language using lex and yacc

Note: You must have a version of lex (flex for windows) installed in addition to a C compiler.

1. Compile the scanner.l using the command
  lex scanner.l
  This will output the lex.yy.c file
	
2. Compile the parser.y using the command
  yacc -d parser.y
  This will output the parser.tab.c and the parser.tab.h

3. Compile the lex.yy.c and the parser.tab.c using the command
  gcc lex.yy.c parser.tab.c -o compiler.exe
  This specifies that the output should be in compiler.exe

4. Run the compiler and test the file in project.cpp
  compiler.exe Project.cpp
  It should give you the output of compilation specified in the Project.cpp
