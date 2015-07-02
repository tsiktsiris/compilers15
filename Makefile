all:		
		$(shell flex lexer.l)
		$(shell byacc -d grammar.y)
		gcc -o run interpret.c lex.yy.c y.tab.c
		
clean:		
		rm -f run graph *.o lex.yy.c y.tab.[ch]
