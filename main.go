package main

import (
	"fmt"
	"os"
	"strconv"
)

func typeof(v interface{}) string {
	return fmt.Sprintf("%T", v)
}

type keyword struct {
	key string
}

func lexer(txt string) ([][]any, []int) {
	var indents []int

	// Split by newlines
	var split []string
	var text string
	indent := 0
	for _, i := range txt {
		if string(i) == "\n" {
			split = append(split, text)
			text = ""
		} else {
			if text == "" {
				if string(i) == "\t" {
					indent++
					continue
				} else {
					indents = append(indents, indent)
					indent = 0
				}
			}
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
			if char == "\"" {
				if typeof(token) == "string" {
					line = append(line, token)
					token = nil
				} else {
					if token != nil {
						line = append(line, token)
						token = ""
						data = nil
					}
				}
			} else if typeof(token) == "string" {
				token = token.(string) + char
			} else if char == " " {
				line = append(line, token)
				token = nil
				data = nil
			} else if char == "." {
				if typeof(token) == "int" {
					token = float64(token.(int))
				} else {
					line = append(line, [2]any{token, "."})
					token = nil
					data = nil
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
			} else if char == "{" || char == "}" || char == "(" || char == ")" || char == "+" || char == "-" || char == "*" || char == "/" || char == "!" || char == ":" {
				if token != nil {
					line = append(line, token)
					data = nil
				}
				token = keyword{char}
			} else if char == "=" {
				if typeof(token) == "main.keyword" {
					key := token.(keyword).key
					if key == "+" || key == "-" || key == "*" || key == "/" || key == "=" || key == "!" {
						token = keyword{key + char}
					} else {
						line = append(line, token)
						token = nil
						line = append(line, keyword{"="})
					}
				} else {
					line = append(line, token)
					token = keyword{"="}
				}
			} else {
				if token == nil {
					token = keyword{char}
				} else {
					if typeof(token) == "main.keyword" {
						key := token.(keyword).key
						if key == "{" || key == "}" || key == "(" || key == ")" || key == "+" || key == "-" || key == "*" || key == "/" || key == "!" || key == ":" {
							line = append(line, keyword{key})
							key = ""
						}
						token = keyword{key + char}
					}
				}
			}
		}

		if token != nil {
			line = append(line, token)
		}
		lexed = append(lexed, line)
		line = nil
	}

	return lexed, indents
}

func main() {
	file := os.Args[1]
	contentsByteArray, _ := os.ReadFile(file)
	contents := string(contentsByteArray)
	lexed, indents := lexer(contents)
	fmt.Println(lexed)
	fmt.Println(indents)
}
