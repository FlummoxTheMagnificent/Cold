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

func lex(txt string) ([][]any, []int) {
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
	for linenum, i := range split {
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
					if typeof(token) == "float64" {
						fmt.Println("Error: unexpected . on line", linenum+1)
						os.Exit(1)
					}
					line = append(line, [2]any{token, "."})
					token = nil
					data = nil
				}
			} else if num, err := strconv.Atoi(char); err == nil {
				if typeof(token) == "int" {
					token = token.(int)*10 + num
				} else if typeof(token) == "float64" {
					token = token.(float64) + float64(num)/float64(data.(int))
					data = data.(int) * 10
				} else {
					if token != nil {
						line = append(line, token)
					}
					token = num
					data = 10
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

type expression struct {
	first  any
	expr   string
	second any
}

func shuntingyard(tokens []any, line int) []any {
	var output []any
	var queue []any

	isexpr := true
	negate := false
	for _, i := range tokens {
		if typeof(i) == "int" || typeof(i) == "float64" || typeof(i) == "string" {
			if !(isexpr || (output == nil && queue == nil)) {
				fmt.Println("Error: unexpected", i, "on line", line)
				os.Exit(1)
			}
			if negate {
				if typeof(i) == "string" {
					fmt.Println("Error: cannot negate", i, "on line", line)
					os.Exit(1)
				} else {
					if typeof(i) == "int" {
						output = append(output, -i.(int))
					} else {
						output = append(output, -i.(float64))
					}
				}
				negate = false
			} else {
				output = append(output, i)
			}
			isexpr = false
		} else if i.(keyword).key == "," {
			for len(queue) > 0 && queue[len(queue)-1] != "(" {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
		} else if i.(keyword).key == "(" {
			queue = append(queue, i)
		} else if i.(keyword).key == ")" {
			for {
				if len(queue) == 1 && queue[0].(keyword).key != "(" {
					fmt.Println("Error: missing ( on line", line+1)
					os.Exit(1)
				} else if queue[len(queue)-1].(keyword).key == "(" {
					queue = queue[:len(queue)-1]
					break
				}
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
		} else if i.(keyword).key == "+" || i.(keyword).key == "-" {
			if isexpr {
				if i.(keyword).key == "-" && !negate {
					negate = true
					continue
				} else {
					fmt.Println("Error: unexpected", i, "(expected value) on line", line+1)
					os.Exit(1)
				}
			}
			for len(queue) > 0 && (queue[len(queue)-1].(keyword).key == "*" || queue[len(queue)-1].(keyword).key == "/" || queue[len(queue)-1].(keyword).key == "+" || queue[len(queue)-1].(keyword).key == "-") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else if i.(keyword).key == "*" || i.(keyword).key == "/" {
			if isexpr {
				fmt.Println("Error: unexpected", i, "(expected value) on line", line+1)
			}
			for len(queue) > 0 && (queue[len(queue)-1].(keyword).key == "*" || queue[len(queue)-1].(keyword).key == "/") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else {
			if !(isexpr || (output == nil && queue == nil)) {
				fmt.Println("Error: unexpected", i, "(expected expression) on line", line)
				os.Exit(1)
			}
			output = append(output, i)
			isexpr = false
		}
	}

	for i := len(queue) - 1; i > -1; i-- {
		if queue[i].(keyword).key == "(" {
			fmt.Println("Error: missing ) on line", line+1)
			os.Exit(1)
		}
		output = append(output, queue[i])
	}
	return output
}

func parse(program [][]any, _ []int) []any {
	var lines []any
	for i, line := range program {
		line = shuntingyard(line, i)
		var values []any
		for _, x := range line {
			if typeof(x) == "main.keyword" {
				key := x.(keyword).key
				if key == "+" || key == "-" || key == "*" || key == "/" {
					if len(values) < 2 {
						fmt.Println("Error: missing argument for", key, "on line", i+1)
						os.Exit(1)
					}
					values = append(values[:len(values)-2], expression{values[len(values)-2], key, values[len(values)-1]})
				} else {
					values = append(values, key)
				}
			} else {
				values = append(values, x)
			}
		}
		if len(values) == 0 {
			continue
		}
		lines = append(lines, values[0])
	}
	return lines
}

func eval(expr any, line int) any {
	if typeof(expr) == "string" || typeof(expr) == "float64" || typeof(expr) == "int" {
		return expr
	} else if typeof(expr) == "main.expression" {
		key := expr.(expression)
		if key.expr == "+" {
			first := eval(key.first, line)
			second := eval(key.second, line)
			if typeof(first) == "int" && typeof(second) == "int" {
				return first.(int) + second.(int)
			}
			if typeof(first) == "float64" && typeof(second) == "float64" {
				return first.(float64) + second.(float64)
			}
			if typeof(first) == "string" && typeof(second) == "string" {
				return first.(string) + second.(string)
			}
			if typeof(first) == "int" && typeof(second) == "float64" {
				return float64(first.(int)) + second.(float64)
			}
			if typeof(first) == "float64" && typeof(second) == "int" {
				return first.(float64) + float64(second.(int))
			}
			fmt.Println("Error: mismatched types", first, "and", second, "( types", typeof(first), "and", typeof(second), ") on line", line)
			os.Exit(1)
		}
		if key.expr == "-" {
			first := eval(key.first, line)
			second := eval(key.second, line)
			if typeof(first) == "int" && typeof(second) == "int" {
				return first.(int) - second.(int)
			}
			if typeof(first) == "float64" && typeof(second) == "float64" {
				return first.(float64) - second.(float64)
			}
			if typeof(first) == "int" && typeof(second) == "float64" {
				return float64(first.(int)) - second.(float64)
			}
			if typeof(first) == "float64" && typeof(second) == "int" {
				return first.(float64) - float64(second.(int))
			}
			fmt.Println("Error: mismatched types", first, "and", second, "for {-} ( types", typeof(first), "and", typeof(second), ") on line", line)
			os.Exit(1)
		}
		if key.expr == "*" {
			first := eval(key.first, line)
			second := eval(key.second, line)
			if typeof(first) == "int" && typeof(second) == "int" {
				return first.(int) * second.(int)
			}
			if typeof(first) == "float64" && typeof(second) == "float64" {
				return first.(float64) * second.(float64)
			}
			if typeof(first) == "int" && typeof(second) == "float64" {
				return float64(first.(int)) * second.(float64)
			}
			if typeof(first) == "float64" && typeof(second) == "int" {
				return first.(float64) * float64(second.(int))
			}
			fmt.Println("Error: mismatched types", first, "and", second, "for {*} ( types", typeof(first), "and", typeof(second), ") on line", line)
			os.Exit(1)
		}
		if key.expr == "/" {
			first := eval(key.first, line)
			second := eval(key.second, line)
			if typeof(first) == "int" && typeof(second) == "int" {
				return float64(first.(int)) / float64(second.(int))
			}
			if typeof(first) == "float64" && typeof(second) == "float64" {
				return first.(float64) / second.(float64)
			}
			if typeof(first) == "int" && typeof(second) == "float64" {
				return float64(first.(int)) / second.(float64)
			}
			if typeof(first) == "float64" && typeof(second) == "int" {
				return first.(float64) / float64(second.(int))
			}
			fmt.Println("Error: mismatched types", first, "and", second, "for {/} ( types", typeof(first), "and", typeof(second), ") on line", line)
			os.Exit(1)
		}
	}
	return typeof(expr)
}

func main() {
	file := os.Args[1]
	contentsByteArray, _ := os.ReadFile(file)
	contents := string(contentsByteArray)
	lexed, indents := lex(contents)
	parsed := parse(lexed, indents)
	fmt.Println(parsed...)
	fmt.Println(eval(parsed[0], 0))
}
