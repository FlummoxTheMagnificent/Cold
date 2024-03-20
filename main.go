package main

import (
	"fmt"
	"os"
	"strconv"
)

func typeof(v interface{}) string {
	return fmt.Sprintf("%T", v)
}

func lexer(txt string) [][]any {
	// Split by newlines
	var split []string
	var text string
	for _, i := range txt {
		if string(i) == "\n" {
			split = append(split, text)
			text = ""
		} else {
			text += string(i)
		}
	}
	split = append(split, text)

	// Split each line into tokens
	var lexed [][]any
	var line []any
	for _, i := range split {
		var token any
		var data any
		for _, j := range i {
			char := string(j)
			if char == " " {
				line = append(line, token)
			} else if char == "." {
				if typeof(token) == "int" {
					token = float64(token.(int))
				}
			} else if num, err := strconv.Atoi(char); err == nil {
				if typeof(token) == "int" {
					token = token.(int)*10 + num
					data = 10
				} else if typeof(token) == "float64" {
					token = token.(float64) + float64(num)/float64(data.(int))
					data = data.(int) * 10
				} else {
					if token != nil {
						line = append(line, token)
					}
					token = num
				}
			}
		}
		line = append(line, token)
		lexed = append(lexed, line)
	}

	return lexed
}

func main() {
	file := os.Args[1]
	contentsByteArray, _ := os.ReadFile(file)
	contents := string(contentsByteArray)
	lexed := lexer(contents)
	fmt.Println(lexed)
	fmt.Println(typeof(lexed[0][0]))
}
