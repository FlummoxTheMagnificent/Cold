module github.com/FlummoxTheMagnificent/Cold/tree/main/cold

go 1.22.1

replace github.com/FlummoxTheMagnificent/Cold/tree/main/lex => ../lex

replace github.com/FlummoxTheMagnificent/Cold/tree/main/parse => ../parse

require (
	github.com/FlummoxTheMagnificent/Cold/tree/main/lex v0.0.0-00010101000000-000000000000
	github.com/FlummoxTheMagnificent/Cold/tree/main/parse v0.0.0-00010101000000-000000000000
	github.com/llir/llvm v0.3.6
)

require (
	github.com/mewmew/float v0.0.0-20211212214546-4fe539893335 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	golang.org/x/mod v0.16.0 // indirect
	golang.org/x/tools v0.19.0 // indirect
	tinygo.org/x/go-llvm v0.0.0-20240106122909-c2c543540318 // indirect
)
