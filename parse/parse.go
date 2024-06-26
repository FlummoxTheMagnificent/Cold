package parse

import (
	"fmt"
	"os"
	"slices"

	"github.com/FlummoxTheMagnificent/Cold/tree/main/lex"
)

func typeof(item any) string {
	return fmt.Sprintf("%T", item)
}

type Expression struct {
	First  any
	Expr   string
	Second any
}
type Function struct {
	Name     string
	Args     []any
	argcount int
}
type Keyword struct {
	Key string
}
type CodeBlock struct {
	Key  string
	Data string
	Code []any
}

func format(tokens []any) []any {
	// Heavily modified shunting yard algorithm
	// Partially from https://blog.kallisti.net.nz/2008/02/extension-to-the-shunting-yard-algorithm-to-allow-variable-numbers-of-arguments-to-Functions/
	var output []any
	var queue []any
	var werevalues []bool
	var argcount []int

	isexpr := true
	negate := false
	var prev string
	for _, i := range tokens {
		if prev != "" {
			if negate {
				fmt.Println("Error: unexpected '-'")
				os.Exit(1)
			}
			if typeof(i) == "lex.Token" && i.(lex.Token).Key == "(" {
				queue = append(queue, Function{prev, []any{}, 0})
				argcount = append(argcount, 0)
				if len(werevalues) > 0 {
					werevalues[len(werevalues)-1] = true
				}
				werevalues = append(werevalues, false)
			} else {
				if !(isexpr || (output == nil && queue == nil)) {
					fmt.Println("Error: unexpected", prev)
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
				fmt.Println("Error: unexpected", i)
				os.Exit(1)
			}
			if negate {
				if typeof(i) == "string" {
					fmt.Println("Error: cannot negate", i)
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
		} else if i.(lex.Token).Key == "," {
			for len(queue) > 0 && (typeof(queue[len(queue)-1]) == "parse.Function" || queue[len(queue)-1].(lex.Token).Key != "(" && queue[len(queue)-1].(lex.Token).Key != "{" && queue[len(queue)-1].(lex.Token).Key != "[") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			isexpr = true
			if len(werevalues) == 0 {
				fmt.Println("Error: unexpected ,")
				os.Exit(1)
			}
			if werevalues[len(werevalues)-1] {
				argcount[len(argcount)-1]++
				werevalues[len(werevalues)-1] = false
			}
		} else if i.(lex.Token).Key == "(" {
			queue = append(queue, i)
		} else if i.(lex.Token).Key == ")" {
			if len(queue) == 0 {
				fmt.Println("Error: missing (")
				os.Exit(1)
			}
			for {
				if typeof(queue[len(queue)-1]) == "lex.Token" && queue[len(queue)-1].(lex.Token).Key == "(" {
					queue = queue[:len(queue)-1]
					break
				} else if len(queue) == 1 {
					fmt.Println("Error: missing (")
					os.Exit(1)
				}
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			if len(queue) != 0 && typeof(queue[len(queue)-1]) == "parse.Function" {
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
		} else if i.(lex.Token).Key == "{" {
			queue = append(queue, Function{"arr", []any{}, 0})
			queue = append(queue, i)
			argcount = append(argcount, 0)
			if len(werevalues) > 0 {
				werevalues[len(werevalues)-1] = true
			}
			werevalues = append(werevalues, false)
		} else if i.(lex.Token).Key == "}" {
			if len(queue) == 0 {
				fmt.Println(output)
				fmt.Println("Error: missing {")
				os.Exit(1)
			}
			for {
				if typeof(queue[len(queue)-1]) == "lex.Token" && queue[len(queue)-1].(lex.Token).Key == "{" {
					queue = queue[:len(queue)-1]
					break
				} else if len(queue) == 1 {
					fmt.Println("Error: missing {")
					os.Exit(1)
				}
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			f := queue[len(queue)-1].(Function)
			queue = queue[:len(queue)-1]
			if werevalues[len(werevalues)-1] {
				f.argcount = argcount[len(argcount)-1] + 1
			} else {
				f.argcount = argcount[len(argcount)-1]
			}
			argcount = argcount[:len(argcount)-1]
			output = append(output, f)
		} else if i.(lex.Token).Key == "[" {
			queue = append(queue, Function{"idx", []any{}, 0})
			queue = append(queue, i)
			argcount = append(argcount, 0)
			if len(werevalues) > 0 {
				werevalues[len(werevalues)-1] = true
			}
			werevalues = append(werevalues, false)
			isexpr = true
		} else if i.(lex.Token).Key == "]" {
			if len(queue) == 0 {
				fmt.Println(output)
				fmt.Println("Error: missing [")
				os.Exit(1)
			}
			for {
				if typeof(queue[len(queue)-1]) == "lex.Token" && queue[len(queue)-1].(lex.Token).Key == "[" {
					queue = queue[:len(queue)-1]
					break
				} else if len(queue) == 1 {
					fmt.Println("Error: missing [")
					os.Exit(1)
				}
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			f := queue[len(queue)-1].(Function)
			queue = queue[:len(queue)-1]
			if werevalues[len(werevalues)-1] {
				f.argcount = argcount[len(argcount)-1] + 1
			} else {
				f.argcount = argcount[len(argcount)-1]
			}
			f.argcount++
			argcount = argcount[:len(argcount)-1]
			output = append(output, f)
		} else if i.(lex.Token).Key == "+" || i.(lex.Token).Key == "-" {
			if isexpr {
				if i.(lex.Token).Key == "-" && !negate {
					negate = true
					continue
				} else {
					fmt.Println("Error: unexpected", i, "(expected value)")
					os.Exit(1)
				}
			}
			for len(queue) > 0 && (queue[len(queue)-1].(lex.Token).Key == "*" || queue[len(queue)-1].(lex.Token).Key == "/" || queue[len(queue)-1].(lex.Token).Key == "+" || queue[len(queue)-1].(lex.Token).Key == "-" || i.(lex.Token).Key == "%") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else if i.(lex.Token).Key == "*" || i.(lex.Token).Key == "/" || i.(lex.Token).Key == "%" {
			if isexpr {
				fmt.Println("Error: unexpected", i, "(expected value)")
			}
			for len(queue) > 0 && (queue[len(queue)-1].(lex.Token).Key == "*" || queue[len(queue)-1].(lex.Token).Key == "/" || queue[len(queue)-1].(lex.Token).Key == "%") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else if i.(lex.Token).Key == "=" || i.(lex.Token).Key == "!=" || i.(lex.Token).Key == ">" || i.(lex.Token).Key == "<" || i.(lex.Token).Key == ">=" || i.(lex.Token).Key == "<=" {
			for len(queue) > 0 {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else {
			if !isexpr {
				fmt.Println("Error: unexpected", i, "(expected operator)")
				os.Exit(1)
			}
			prev = i.(lex.Token).Key
		}
	}
	if prev != "" {
		if !(isexpr || (output == nil && queue == nil)) {
			fmt.Println("Error: unexpected", prev)
			os.Exit(1)
		}
		negate = false
		output = append(output, Keyword{prev})
		isexpr = false
		if len(werevalues) > 0 {
			werevalues[len(werevalues)-1] = true
		}
		prev = ""
	}
	for i := len(queue) - 1; i > -1; i-- {
		if typeof(queue[i]) == "lex.Token" && queue[i].(lex.Token).Key == "(" {
			fmt.Println("Error: missing )")
			os.Exit(1)
		}
		output = append(output, queue[i])
	}
	return output
}
func parseexpr(expr []any) any {
	expr = format(expr)
	var values []any
	for _, x := range expr {
		if typeof(x) == "lex.Token" {
			key := x.(lex.Token).Key
			if key == "+" || key == "-" || key == "*" || key == "/" || key == "%" || key == "=" || key == "!=" || key == ">" || key == "<" || key == ">=" || key == "<=" {
				if len(values) < 2 {
					fmt.Println("Error: missing argument for", key)
					os.Exit(1)
				}
				values = append(values[:len(values)-2], Expression{values[len(values)-2], key, values[len(values)-1]})
			} else {
				values = append(values, key)
			}
		} else if typeof(x) == "parse.Function" {
			f := x.(Function)
			f.Args = slices.Clone(values[len(values)-f.argcount:])
			values = append(values[:len(values)-f.argcount], f)
		} else {
			values = append(values, x)
		}
	}
	if len(values) != 1 {
		if len(values) == 0 {
			fmt.Println("Error: missing expression")
		} else {
			fmt.Println("Error: failed to parse expression")
		}
		os.Exit(1)
	}
	return values[0]
}
func Parse(program [][]any, indents []int) []any {
	var lines []any
	i := 0
	for i < len(program) {
		line := program[i]
		if len(line) == 0 {
			i++
			continue
		}
		if len(line) > 2 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == "=" {
			lines = append(lines, CodeBlock{"setvar", line[0].(lex.Token).Key, []any{parseexpr(line[2:])}})
		} else if len(line) > 2 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == "+=" {
			lines = append(lines, CodeBlock{"setvar", line[0].(lex.Token).Key, []any{parseexpr(append([]any{line[0], lex.Token{Key: "+"}}, line[2:]...))}})
		} else if len(line) > 2 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == "-=" {
			lines = append(lines, CodeBlock{"setvar", line[0].(lex.Token).Key, []any{parseexpr(append([]any{line[0], lex.Token{Key: "-"}}, line[2:]...))}})
		} else if len(line) > 2 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == "*=" {
			lines = append(lines, CodeBlock{"setvar", line[0].(lex.Token).Key, []any{parseexpr(append([]any{line[0], lex.Token{Key: "*"}}, line[2:]...))}})
		} else if len(line) > 2 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == "/=" {
			lines = append(lines, CodeBlock{"setvar", line[0].(lex.Token).Key, []any{parseexpr(append([]any{line[0], lex.Token{Key: "/"}}, line[2:]...))}})
		} else if len(line) > 2 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == ":=" {
			lines = append(lines, CodeBlock{"newvar", line[0].(lex.Token).Key, []any{parseexpr(line[2:])}})
		} else if len(line) > 1 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == "(" {
			lines = append(lines, parseexpr(line))
		} else if typeof(line[0]) == "lex.Token" && line[0].(lex.Token).Key == "if" {
			if len(line) < 3 {
				if len(line) == 2 {
					if typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == ":" {
						fmt.Println("Error: expected condition in 'if' statement")
					} else {
						fmt.Println("Error: missing ':' in 'if' statement")
					}
				} else {
					fmt.Println("Error: unexpected 'if'")
				}
				os.Exit(1)
			}
			last := len(line) - 1
			if typeof(line[last]) == "lex.Token" && line[last].(lex.Token).Key == ":" {
				var toParse [][]any
				var toParseIndents []int
				start := i
				for i+1 < len(program) && indents[i+1] > indents[start] {
					toParse = append(toParse, program[i+1])
					toParseIndents = append(toParseIndents, indents[i+1]-1)
					i++
				}
				if len(program) > i+1 && len(program[i+1]) == 2 && typeof(program[i+1][0]) == "lex.Token" && program[i+1][0].(lex.Token).Key == "else" && typeof(program[i+1][1]) == "lex.Token" && program[i+1][1].(lex.Token).Key == ":" {
					var toParseElse [][]any
					var toParseIndentsElse []int
					i++
					start := i
					for i+1 < len(program) && indents[i+1] > indents[start] {
						toParseElse = append(toParseElse, program[i+1])
						toParseIndentsElse = append(toParseIndentsElse, indents[i+1]-1)
						i++
					}
					lines = append(lines, CodeBlock{"ifelse", "", []any{append([]any{parseexpr(line[1:last])}, Parse(toParse, toParseIndents)...), Parse(toParseElse, toParseIndentsElse)}})
				} else {
					lines = append(lines, CodeBlock{"if", "", append([]any{parseexpr(line[1:last])}, Parse(toParse, toParseIndents)...)})
				}
			} else {
				fmt.Println("Error: expected ':' in 'if' statement")
				os.Exit(1)
			}
		} else if typeof(line[0]) == "lex.Token" && line[0].(lex.Token).Key == "while" {
			if len(line) < 3 {
				if len(line) == 2 {
					if typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == ":" {
						fmt.Println("Error: expected condition in 'while' statement")
					} else {
						fmt.Println("Error: missing ':' in 'while' statement")
					}
				} else {
					fmt.Println("Error: unexpected 'while'")
				}
				os.Exit(1)
			}
			last := len(line) - 1
			if typeof(line[last]) == "lex.Token" && line[last].(lex.Token).Key == ":" {
				var toParse [][]any
				var toParseIndents []int
				start := i
				for i+1 < len(program) && indents[i+1] > indents[start] {
					toParse = append(toParse, program[i+1])
					toParseIndents = append(toParseIndents, indents[i+1]-1)
					i++
				}
				lines = append(lines, CodeBlock{"while", "", append([]any{parseexpr(line[1:last])}, Parse(toParse, toParseIndents)...)})
			} else {
				fmt.Println("Error: expected ':' in 'while' statement")
				os.Exit(1)
			}
		} else {
			fmt.Println("Error: unexpected", line[0], "(expected definition or function call)")
			os.Exit(1)
		}
		i++
	}
	return lines
}
