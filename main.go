package main

import (
	"fmt"
	"os"
)

func main() {
	file := os.Args[1]
	contentsByteArray, _ := os.ReadFile(file)
	contents := ""
	for _, i := range contentsByteArray {
		contents += string(i)
	}
	fmt.Println(contents)
}
