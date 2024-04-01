package main

import (
	"os"

	"github.com/FlummoxTheMagnificent/Cold/tree/main/cold"
)

func main() {
	contentsByteArray, _ := os.ReadFile("program.cold")
	contents := string(contentsByteArray)
	cold.Interpret(contents)
	cold.CompileAndExecute(contents)
}
