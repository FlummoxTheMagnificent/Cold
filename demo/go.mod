module github.com/FlummoxTheMagnificent/Cold/tree/main/demo

go 1.22.1

replace github.com/FlummoxTheMagnificent/Cold/tree/main/cold => ../cold

replace github.com/FlummoxTheMagnificent/Cold/tree/main/lex => ../lex

require github.com/FlummoxTheMagnificent/Cold/tree/main/cold v0.0.0-00010101000000-000000000000

require (
	github.com/FlummoxTheMagnificent/Cold/tree/main/lex v0.0.0-00010101000000-000000000000 // indirect
	github.com/llir/llvm v0.3.6 // indirect
	github.com/mewmew/float v0.0.0-20211212214546-4fe539893335 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	golang.org/x/mod v0.16.0 // indirect
	golang.org/x/tools v0.19.0 // indirect
)
