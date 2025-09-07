BIN = cscript
CC ?= cc
INCLUDES = lex.yy.c y.tab.c

default:
	yacc -d parse.y
	flex lex.l
	$(CC) -o $(BIN) $(INCLUDES)

clean:
	rm $(BIN) $(INCLUDES)

test:
	./$(BIN) < test01.cs
