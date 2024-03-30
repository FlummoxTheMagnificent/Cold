package main

import (
	"fmt"
	"os"
	"slices"
	"strconv"
)

func typeof(v interface{}) string {
	return fmt.Sprintf("%T", v)
}

type Token struct {
	key string
}
type Expression struct {
	first  any
	expr   string
	second any
}
type Function struct {
	name     string
	args     []any
	argcount int
}
type Keyword struct {
	key string
}
type CodeBlock struct {
	key  string
	data string
	code []any
}

func lex(txt string) ([][]any, []int) {
	var indents []int

	// Split by newlines and count indents
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
						data = nil
					}
					token = ""
				}
			} else if typeof(token) == "string" {
				token = token.(string) + char
			} else if char == " " {
				if token != nil {
					line = append(line, token)
				}
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
					line = append(line, token)
					line = append(line, Token{"."})
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
				token = Token{char}
			} else if char == "=" {
				if typeof(token) == "main.Token" {
					key := token.(Token).key
					if key == "+" || key == "-" || key == "*" || key == "/" || key == "=" || key == "!" {
						token = Token{key + char}
					} else {
						line = append(line, token)
						token = nil
						line = append(line, Token{"="})
					}
				} else {
					if token != nil {
						line = append(line, token)
					}
					token = Token{"="}
				}
			} else if char == "," {
				if token != nil {
					line = append(line, token)
				}
				line = append(line, Token{","})
				token = nil
				data = nil
			} else if char == "#" {
				if token != nil {
					line = append(line, token)
					token = nil
				}
				break
			} else {
				if token == nil {
					token = Token{char}
				} else {
					if typeof(token) == "main.Token" {
						key := token.(Token).key
						if key == "{" || key == "}" || key == "(" || key == ")" || key == "+" || key == "-" || key == "*" || key == "/" || key == "!" || key == ":" {
							line = append(line, Token{key})
							key = ""
						}
						token = Token{key + char}
					}
				}
			}
		}

		if token != nil {
			line = append(line, token)
		}
		if line != nil {
			lexed = append(lexed, line)
		}
		line = nil
	}

	return lexed, indents
}

func format(tokens []any, line int) []any {
	// Heavily modified shunting yard algorithm
	// Partially from https://blog.kallisti.net.nz/2008/02/extension-to-the-shunting-yard-algorithm-to-allow-variable-numbers-of-arguments-to-functions/
	var output []any
	var queue []any
	var werevalues []bool
	var argcount []int

	isexpr := true
	negate := false
	var prev string
	for _, i := range tokens {
		if prev != "" {
			if typeof(i) == "main.Token" && i.(Token).key == "(" {
				queue = append(queue, Function{prev, []any{}, 0})
				argcount = append(argcount, 0)
				if len(werevalues) > 0 {
					werevalues[len(werevalues)-1] = true
				}
				werevalues = append(werevalues, false)
			} else {
				if !(isexpr || (output == nil && queue == nil)) {
					fmt.Println("Error: unexpected", prev, "on line", line)
					os.Exit(1)
				}
				negate = false
				output = append(output, Keyword{prev})
				isexpr = false
				if len(werevalues) > 0 {
					werevalues[len(werevalues)-1] = true
				}
			}
			prev = ""
		}
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
			if len(werevalues) > 0 {
				werevalues[len(werevalues)-1] = true
			}
		} else if i.(Token).key == "," {
			for len(queue) > 0 && (typeof(queue[len(queue)-1]) == "main.Function" || queue[len(queue)-1].(Token).key != "(") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			isexpr = true
			if len(werevalues) == 0 {
				fmt.Println("Error: unexpected , on line", line+1)
				os.Exit(1)
			}
			if werevalues[len(werevalues)-1] {
				argcount[len(argcount)-1]++
				werevalues[len(werevalues)-1] = false
			}
		} else if i.(Token).key == "(" {
			queue = append(queue, i)
		} else if i.(Token).key == ")" {
			if len(queue) == 0 {
				fmt.Println("Error: missing ( on line", line+1)
				os.Exit(1)
			}
			for {
				if typeof(queue[len(queue)-1]) != "main.Function" && queue[len(queue)-1].(Token).key == "(" {
					queue = queue[:len(queue)-1]
					break
				} else if len(queue) == 1 {
					fmt.Println("Error: missing ( on line", line+1)
					os.Exit(1)
				}
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			if typeof(queue[len(queue)-1]) == "main.Function" {
				f := queue[len(queue)-1].(Function)
				queue = queue[:len(queue)-1]
				if werevalues[len(werevalues)-1] {
					f.argcount = argcount[len(argcount)-1] + 1
				} else {
					f.argcount = argcount[len(argcount)-1]
				}
				argcount = argcount[:len(argcount)-1]
				output = append(output, f)
			}
		} else if i.(Token).key == "+" || i.(Token).key == "-" {
			if isexpr {
				if i.(Token).key == "-" && !negate {
					negate = true
					continue
				} else {
					fmt.Println("Error: unexpected", i, "(expected value) on line", line+1)
					os.Exit(1)
				}
			}
			for len(queue) > 0 && (queue[len(queue)-1].(Token).key == "*" || queue[len(queue)-1].(Token).key == "/" || queue[len(queue)-1].(Token).key == "+" || queue[len(queue)-1].(Token).key == "-") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else if i.(Token).key == "*" || i.(Token).key == "/" {
			if isexpr {
				fmt.Println("Error: unexpected", i, "(expected value) on line", line+1)
			}
			for len(queue) > 0 && (queue[len(queue)-1].(Token).key == "*" || queue[len(queue)-1].(Token).key == "/") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else {
			if !isexpr {
				fmt.Println("Error: unexpected", i, "(expected expression) on line", line)
				os.Exit(1)
			}
			prev = i.(Token).key
		}
	}

	for i := len(queue) - 1; i > -1; i-- {
		if typeof(queue[i]) == "main.Token" && queue[i].(Token).key == "(" {
			fmt.Println("Error: missing ) on line", line+1)
			os.Exit(1)
		}
		output = append(output, queue[i])
	}
	return output
}
func parseexpr(expr []any, line int) any {
	expr = format(expr, line)
	var values []any
	for _, x := range expr {
		if typeof(x) == "main.Token" {
			key := x.(Token).key
			if key == "+" || key == "-" || key == "*" || key == "/" {
				if len(values) < 2 {
					fmt.Println("Error: missing argument for", key, "on line", line+1)
					os.Exit(1)
				}
				values = append(values[:len(values)-2], Expression{values[len(values)-2], key, values[len(values)-1]})
			} else {
				values = append(values, key)
			}
		} else if typeof(x) == "main.Function" {
			f := x.(Function)
			if len(values) < f.argcount {
				fmt.Println("Error: internal error, line", line+1)
				os.Exit(1)
			}
			f.args = slices.Clone(values[len(values)-f.argcount:])
			values = append(values[:len(values)-f.argcount], f)
		} else {
			values = append(values, x)
		}
	}
	if len(values) != 1 {
		if len(values) == 0 {
			fmt.Println("Error: missing expression on line", line+1)
		} else {
			fmt.Println("Error: failed to parse expression on line", line+1)
		}
		os.Exit(1)
	}
	return values[0]
}
func parse(program [][]any, _ []int) []any {
	var lines []any
	for i, line := range program {
		if typeof(line[0]) == "main.Token" && typeof(line[1]) == "main.Token" && line[1].(Token).key == "=" {
			lines = append(lines, CodeBlock{"var", line[0].(Token).key, []any{parseexpr(line[2:], i)}})
		} else {
			lines = append(lines, parseexpr(line, i))
		}
	}
	return lines
}
func eval(expr any, line int, v *map[any]any) any {
	if typeof(expr) == "string" || typeof(expr) == "float64" || typeof(expr) == "int" {
		return expr
	} else if typeof(expr) == "main.Expression" {
		key := expr.(Expression)
		if key.expr == "+" {
			first := eval(key.first, line, v)
			second := eval(key.second, line, v)
			firstType := typeof(first)
			secondType := typeof(second)
			if firstType == "int" && secondType == "int" {
				return first.(int) + second.(int)
			} else if firstType == "string" || secondType == "string" {
				if firstType == "int" {
					first = strconv.Itoa(first.(int))
				} else if firstType == "float64" {
					first = strconv.FormatFloat(first.(float64), 'f', -1, 64)
				} else if secondType == "int" {
					second = strconv.Itoa(second.(int))
				} else if secondType == "float64" {
					second = strconv.FormatFloat(second.(float64), 'f', -1, 64)
				}
				return first.(string) + second.(string)
			} else {
				if firstType == "int" {
					first = float64(first.(int))
				} else if secondType == "int" {
					second = float64(second.(int))
				}
				return first.(float64) + second.(float64)
			}
		}
		if key.expr == "-" {
			first := eval(key.first, line, v)
			second := eval(key.second, line, v)
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
			fmt.Println("Error: mismatched types", first, "and", second, "for {-} ( types", typeof(first), "and", typeof(second), ") on line", line+1)
			os.Exit(1)
		}
		if key.expr == "*" {
			first := eval(key.first, line, v)
			second := eval(key.second, line, v)
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
			fmt.Println("Error: mismatched types", first, "and", second, "for {*} ( types", typeof(first), "and", typeof(second), ") on line", line+1)
			os.Exit(1)
		}
		if key.expr == "/" {
			first := eval(key.first, line, v)
			second := eval(key.second, line, v)
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
			fmt.Println("Error: mismatched types", first, "and", second, "for {/} ( types", typeof(first), "and", typeof(second), ") on line", line+1)
			os.Exit(1)
		}
	} else if typeof(expr) == "main.Function" {
		name := expr.(Function).name
		args := expr.(Function).args
		if name == "println" {
			str := ""
			for _, i := range args {
				i = eval(i, line, v)
				if typeof(i) == "string" {
					str += i.(string)
				} else if typeof(i) == "int" {
					str += strconv.Itoa(i.(int))
				} else if typeof(i) == "float64" {
					str += strconv.FormatFloat(i.(float64), 'f', -1, 64)
				} else {
					fmt.Println("Error: internal error")
					os.Exit(1)
				}
			}
			fmt.Println(str)
			return str
		} else if name == "print" {
			str := ""
			for _, i := range args {
				i = eval(i, line, v)
				if typeof(i) == "string" {
					str += i.(string)
				} else if typeof(i) == "int" {
					str += strconv.Itoa(i.(int))
				} else if typeof(i) == "float64" {
					str += strconv.FormatFloat(i.(float64), 'f', -1, 64)
				} else {
					fmt.Println("Error: internal error")
					os.Exit(1)
				}
			}
			fmt.Print(str)
			return str
		} else if name == "typeof" {
			if len(args) > 1 {
				fmt.Println("Error: too many arguments for 'typeof', line", line)
				os.Exit(1)
			} else if len(args) == 0 {
				fmt.Println("Error: not enough arguments for 'typeof', line", line)
				os.Exit(1)
			}
			argType := typeof(eval(args[0], line, v))
			if argType == "float64" {
				return "float"
			}
			return argType
		}
	} else if typeof(expr) == "main.Keyword" {
		return (*v)[expr.(Keyword).key]
	} else if typeof(expr) == "main.CodeBlock" {
		if expr.(CodeBlock).key == "var" {
			if len(expr.(CodeBlock).code) > 1 {
				fmt.Println("Error: internal error")
				os.Exit(1)
			}
			(*v)[expr.(CodeBlock).data] = eval(expr.(CodeBlock).code[0], line, v)
		}
	}
	return expr
}
func exec(program []any) {
	variables := make(map[any]any)
	for i, x := range program {
		eval(x, i, &variables)
	}
}

func main() {
	file := os.Args[1]
	contentsByteArray, _ := os.ReadFile(file)
	contents := string(contentsByteArray)
	lexed, indents := lex(contents)
	parsed := parse(lexed, indents)
	exec(parsed)
}
