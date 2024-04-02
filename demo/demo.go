package main

import (
	"fmt"
	"os"

	"github.com/FlummoxTheMagnificent/Cold/tree/main/cold"
)

func main() {
	contentsByteArray, _ := os.ReadFile("program.cold")
	contents := string(contentsByteArray)
	fmt.Println("Running interpreter:")
	cold.Interpret(contents)
	fmt.Println("Running LLVM compiler:")
	cold.CompileAndExecute(contents)
}
