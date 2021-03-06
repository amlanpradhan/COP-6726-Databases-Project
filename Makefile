CC = g++ -O0 -ggdb3 -std=gnu++0x -fopenmp -Wall -Wextra -Wshadow -Wno-write-strings -Wno-deprecated -pedantic-errors -lrt
# ccache
# -D_GLIBCXX_PARALLEL -march=native -msse2 -ffast-math -fomit-frame-pointer
# wtf is this below? tag is set to '-i', but if on linux it is '-n'? INVESTIGATE TODO
tag = -i

ifdef linux
tag = -n
endif

again: clean all

all: main

a4-1.out: Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o BigQ.o Statistics.o y.tab.o lex.yy.o test.o
	$(CC) -o a4-1.out Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o BigQ.o Statistics.o y.tab.o lex.yy.o test.o -lfl

test.o: test.cc
	$(CC) -c test.cc

Statistics.o: Statistics.cc Statistics.h
	$(CC) -c Statistics.cc

a3.out: Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o BigQ.o RelOp.o Function.o y.tab.o yyfunc.tab.o lex.yy.o lex.yyfunc.o a3test.o
	$(CC) -o a3.out Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o BigQ.o RelOp.o Function.o y.tab.o yyfunc.tab.o lex.yy.o lex.yyfunc.o a3test.o -lfl -lpthread

a3test.o: a3test.cc a3test.h
	$(CC) -c a3test.cc

a22.out: Record.o Comparison.o ComparisonEngine.o Schema.o File.o BigQ.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o y.tab.o lex.yy.o a2-2test.o
	$(CC) -o a22.out Record.o Comparison.o ComparisonEngine.o Schema.o File.o BigQ.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o y.tab.o lex.yy.o a2-2test.o -lfl -lpthread

a2-2test.o: a2-2test.cc a2-2test.h
	$(CC)  -c a2-2test.cc

a2-1test: Record.o Comparison.o ComparisonEngine.o Schema.o File.o BigQ.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o y.tab.o lex.yy.o a2-1test.o
	$(CC) -o a2-1test Record.o Comparison.o ComparisonEngine.o Schema.o File.o BigQ.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o y.tab.o lex.yy.o a2-1test.o -lfl -lpthread

a2-11test.o: a2-1test.cc a2-1test.h
	$(CC)  -c a2-1test.cc

a1test: Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o GenericDBFile.o HeapDBFile.o BigQ.o Pipe.o SortedDBFile.o y.tab.o lex.yy.o a1test.o
	$(CC) -o a1test Record.o Comparison.o ComparisonEngine.o Schema.o File.o DBFile.o GenericDBFile.o HeapDBFile.o BigQ.o Pipe.o SortedDBFile.o y.tab.o lex.yy.o a1test.o -lfl -lpthread

a1test.o: a1test.cc a1test.h
	$(CC)  -c a1test.cc

main:   y.tab.o lex.yy.o main.o Statistics.o Schema.o Record.o Comparison.o ComparisonEngine.o File.o DBFile.o GenericDBFile.o HeapDBFile.o BigQ.o Pipe.o SortedDBFile.o RelOp.o Function.o
	$(CC) -o main y.tab.o lex.yy.o Schema.o Record.o Comparison.o ComparisonEngine.o File.o DBFile.o GenericDBFile.o HeapDBFile.o SortedDBFile.o Pipe.o BigQ.o RelOp.o Function.o  Statistics.o main.o -lfl

main.o : main.cc main.h
	$(CC) -g -c main.cc

Comparison.o: Comparison.cc Comparison.h
	$(CC)  -c Comparison.cc

ComparisonEngine.o: ComparisonEngine.cc ComparisonEngine.h
	$(CC)  -c ComparisonEngine.cc

Pipe.o: Pipe.cc Pipe.h
	$(CC)  -c Pipe.cc

BigQ.o: BigQ.cc BigQ.h
	$(CC)  -c BigQ.cc

RelOp.o: RelOp.cc RelOp.h
	$(CC) -c RelOp.cc

Function.o: Function.cc Function.h
	$(CC) -c Function.cc

BPlusDBFile.o: BPlusDBFile.cc BPlusDBFile.h DBFileDefs.h
	$(CC)  -c BPlusDBFile.cc

SortedDBFile.o: SortedDBFile.cc SortedDBFile.h DBFileDefs.h
	$(CC)  -c SortedDBFile.cc

HeapDBFile.o: HeapDBFile.cc HeapDBFile.h DBFileDefs.h
	$(CC)  -c HeapDBFile.cc

GenericDBFile.o: GenericDBFile.cc GenericDBFile.h DBFileDefs.h
	$(CC)  -c GenericDBFile.cc

DBFile.o: DBFile.cc DBFile.h DBFileDefs.h
	$(CC)  -c DBFile.cc

File.o: File.cc File.h
	$(CC)  -c File.cc

Record.o: Record.cc Record.h
	$(CC)  -c Record.cc

Schema.o: Schema.cc Schema.h
	$(CC)  -c Schema.cc

TwoWayList.o : TwoWayList.cc TwoWayList.h
	$(CC)  -c TwoWayList.cc

y.tab.o: Parser.y
	yacc -d Parser.y
	sed $(tag) y.tab.c -e "s/  __attribute__ ((__unused__))$$/# ifndef __cplusplus\n  __attribute__ ((__unused__));\n# endif/"
	g++ -ggdb3 -c y.tab.c

yyfunc.tab.o: ParserFunc.y
	yacc -p "yyfunc" -b "yyfunc" -d ParserFunc.y
	#sed $(tag) yyfunc.tab.c -e "s/  __attribute__ ((__unused__))$$/# ifndef __cplusplus\n  __attribute__ ((__unused__));\n# endif/"
	g++ -ggdb3 -c yyfunc.tab.c


lex.yy.o: Lexer.l
	lex  Lexer.l
	gcc -ggdb3 -c lex.yy.c

lex.yyfunc.o: LexerFunc.l
	lex -Pyyfunc LexerFunc.l
	gcc -ggdb3 -c lex.yyfunc.c

clean:
	rm -f a1test
	rm -f a2-1test
	rm -f a2-2test
	rm -f *.o
	rm -f *.out
	rm -f y.tab.*
	rm -f yyfunc.tab.*
	rm -f lex.yy.*
	rm -f lex.yyfunc*
	rm -f main
