package cold

import (
	"fmt"
	"os"
	"os/exec"
	"slices"

	"github.com/FlummoxTheMagnificent/Cold/tree/main/lex"

	"github.com/llir/llvm/ir"
	"github.com/llir/llvm/ir/constant"
	"github.com/llir/llvm/ir/enum"
	"github.com/llir/llvm/ir/types"
	"github.com/llir/llvm/ir/value"
)

func typeof(item any) string {
	return fmt.Sprintf("%T", item)
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
type Variable struct {
	ptr value.Value
	typ types.Type
}

func format(tokens []any) []any {
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
			for len(queue) > 0 && (typeof(queue[len(queue)-1]) == "cold.Function" || queue[len(queue)-1].(lex.Token).Key != "(") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			isexpr = true
			if len(werevalues) == 0 {
				fmt.Println("Error: unexpected,")
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
				if typeof(queue[len(queue)-1]) != "cold.Function" && queue[len(queue)-1].(lex.Token).Key == "(" {
					queue = queue[:len(queue)-1]
					break
				} else if len(queue) == 1 {
					fmt.Println("Error: missing (")
					os.Exit(1)
				}
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			if typeof(queue[len(queue)-1]) == "cold.Function" {
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
		} else if i.(lex.Token).Key == "+" || i.(lex.Token).Key == "-" || i.(lex.Token).Key == "=" {
			if isexpr {
				if i.(lex.Token).Key == "-" && !negate {
					negate = true
					continue
				} else {
					fmt.Println("Error: unexpected", i, "(expected value) on")
					os.Exit(1)
				}
			}
			for len(queue) > 0 && (queue[len(queue)-1].(lex.Token).Key == "*" || queue[len(queue)-1].(lex.Token).Key == "/" || queue[len(queue)-1].(lex.Token).Key == "+" || queue[len(queue)-1].(lex.Token).Key == "-" || queue[len(queue)-1] == "=") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else if i.(lex.Token).Key == "*" || i.(lex.Token).Key == "/" {
			if isexpr {
				fmt.Println("Error: unexpected", i, "(expected value)")
			}
			for len(queue) > 0 && (queue[len(queue)-1].(lex.Token).Key == "*" || queue[len(queue)-1].(lex.Token).Key == "/") {
				output = append(output, queue[len(queue)-1])
				queue = queue[:len(queue)-1]
			}
			queue = append(queue, i)
			isexpr = true
		} else {
			if !isexpr {
				fmt.Println("Error: unexpected", i, "(expected expression)")
				os.Exit(1)
			}
			prev = i.(lex.Token).Key
		}
	}

	for i := len(queue) - 1; i > -1; i-- {
		if typeof(queue[i]) == "cold.Token" && queue[i].(lex.Token).Key == "(" {
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
			if key == "+" || key == "-" || key == "*" || key == "/" || key == "=" {
				if len(values) < 2 {
					fmt.Println("Error: missing argument for", key)
					os.Exit(1)
				}
				values = append(values[:len(values)-2], Expression{values[len(values)-2], key, values[len(values)-1]})
			} else {
				values = append(values, key)
			}
		} else if typeof(x) == "cold.Function" {
			f := x.(Function)
			f.args = slices.Clone(values[len(values)-f.argcount:])
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
func parse(program [][]any, indents []int) []any {
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
		} else if len(line) > 2 && typeof(line[0]) == "lex.Token" && typeof(line[1]) == "lex.Token" && line[1].(lex.Token).Key == ":=" {
			lines = append(lines, CodeBlock{"newvar", line[0].(lex.Token).Key, []any{parseexpr(line[2:])}})
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
			last := line[len(line)-1]
			if typeof(last) == "lex.Token" && last.(lex.Token).Key == ":" {
				var toParse [][]any
				start := i
				i++
				for i < len(program) && indents[i] > indents[start] {
					toParse = append(toParse, program[i])
					i++
				}
				lines = append(line, CodeBlock{"if", "", append([]any{parseexpr(line[1 : len(line)-1])}, parse(toParse, indents[start+1:i]))})
				i--
			} else {
				fmt.Println("Error: expected ':' in 'if' statement")
				os.Exit(1)
			}
		} else {
			lines = append(lines, parseexpr(line))
		}
		i++
	}
	return lines
}
func parseToLlvm(program []any, v *map[string]Variable, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) {
	for _, line := range program {
		eval(line, v, f, m, entry, main)
	}
}
func eval(expr any, v *map[string]Variable, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) value.Value {
	if typeof(expr) == "string" {
		zero := constant.NewInt(types.I64, 0)
		arrayType := types.NewArray(uint64(len(expr.(string))+1), types.I8)
		charArray := entry.NewAlloca(arrayType)
		entry.NewStore(constant.NewCharArrayFromString(expr.(string)+"\x00"), charArray)
		return entry.NewGetElementPtr(arrayType, charArray, zero, zero)
	} else if typeof(expr) == "float64" {
		return constant.NewFloat(types.Float, expr.(float64))
	} else if typeof(expr) == "int" {
		return constant.NewInt(types.I64, int64(expr.(int)))
	} else if typeof(expr) == "cold.Expression" {
		key := expr.(Expression)
		if key.expr == "+" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)
			secondType := typeof(second)
			if firstType == "*constant.Int" && secondType == "*constant.Int" {
				return entry.NewAdd(first.(*constant.Int), second.(*constant.Int))
			} else if firstType == "*constant.Float" && secondType == "*constant.Float" {
				return entry.NewFAdd(first.(*constant.Float), second.(*constant.Float))
			} else if firstType == "*constant.Int" && secondType == "*constant.Float" {
				return entry.NewFAdd(entry.NewSIToFP(first.(*constant.Int), types.Float), second.(*constant.Float))
			} else if firstType == "*constant.Float" && secondType == "*constant.Int" {
				return entry.NewFAdd(first.(*constant.Float), entry.NewSIToFP(second.(*constant.Int), types.Float))
			} else if firstType == "*ir.InstGetElementPtr" && secondType == "*ir.InstGetElementPtr" {
				return entry.NewCall((*f)["strcat"], first.(*ir.InstGetElementPtr), second.(*ir.InstGetElementPtr))
			}
		} else if key.expr == "-" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "Int" && secondType == "Int" {
				return entry.NewSub(first.(*constant.Int), second.(*constant.Int))
			} else if firstType == "Float" && secondType == "Float" {
				return entry.NewFSub(first.(*constant.Float), second.(*constant.Float))
			} else if firstType == "Int" && secondType == "Float" {
				return entry.NewFSub(entry.NewSIToFP(first.(*constant.Int), types.Float), second.(*constant.Float))
			} else if firstType == "Float" && secondType == "Int" {
				return entry.NewFSub(first.(*constant.Float), entry.NewSIToFP(second.(*constant.Int), types.Float))
			}
		} else if key.expr == "*" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "Int" && secondType == "Int" {
				return entry.NewMul(first.(*constant.Int), second.(*constant.Int))
			} else if firstType == "Float" && secondType == "Float" {
				return entry.NewFMul(first.(*constant.Float), second.(*constant.Float))
			} else if firstType == "Int" && secondType == "Float" {
				return entry.NewFMul(entry.NewSIToFP(first.(*constant.Int), types.Float), second.(*constant.Float))
			} else if firstType == "Float" && secondType == "Int" {
				return entry.NewFMul(first.(*constant.Float), entry.NewSIToFP(second.(*constant.Int), types.Float))
			}
		} else if key.expr == "/" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "Int" && secondType == "Int" {
				return entry.NewSDiv(first.(*constant.Int), second.(*constant.Int))
			} else if firstType == "Float" && secondType == "Float" {
				return entry.NewFDiv(first.(*constant.Float), second.(*constant.Float))
			} else if firstType == "Int" && secondType == "Float" {
				return entry.NewFDiv(entry.NewSIToFP(first.(*constant.Int), types.Float), second.(*constant.Float))
			} else if firstType == "Float" && secondType == "Int" {
				return entry.NewFDiv(first.(*constant.Float), entry.NewSIToFP(second.(*constant.Int), types.Float))
			}
		} else if key.expr == "=" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "Int" && secondType == "Int" {
				return entry.NewICmp(enum.IPredEQ, first.(*constant.Int), second.(*constant.Int))
			} else if firstType == "Float" && secondType == "Float" {
				return entry.NewICmp(enum.IPred(enum.FPredOEQ), first.(*constant.Float), second.(*constant.Float))
			} else if firstType == "Int" && secondType == "Float" {
				return entry.NewICmp(enum.IPred(enum.FPredOEQ), entry.NewSIToFP(first.(*constant.Int), types.Float), second.(*constant.Float))
			} else if firstType == "Float" && secondType == "Int" {
				return entry.NewICmp(enum.IPred(enum.FPredOEQ), first.(*constant.Float), entry.NewSIToFP(second.(*constant.Int), types.Float))
			}
		}
	} else if typeof(expr) == "cold.Function" {
		name := expr.(Function).name
		args := expr.(Function).args
		if name == "print" {
			var arg value.Value
			arg = constant.NewCharArray(nil)
			for _, i := range args {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "i8*" {
					fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = entry.NewCall((*f)["strcat"], arg, this)
			}
		} else if name == "println" {
			if len(args) == 0 {
				return nil
			}
			arg := eval(args[0], v, f, m, entry, main)
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "i8*" {
					fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = entry.NewCall((*f)["strcat"], arg, this)
			}
			arg = entry.NewCall((*f)["strcat"], arg, eval("\n", v, f, m, entry, main))
			entry.NewCall((*f)["printf"], arg)
		} else if name == "typeof" {
			if len(args) != 1 {
				fmt.Println("Error: wrong argument count for typeof()")
				os.Exit(1)
			}
			return eval(eval(args[0], v, f, m, entry, main).Type().String(), v, f, m, entry, main)
		} else if function, exists := (*f)[name]; exists {
			list := make([]value.Value, len(args))
			for i, item := range args {
				list[i] = eval(item, v, f, m, entry, main)
			}
			return entry.NewCall(function, list...)
		} else {
			fmt.Println("Error: unrecognized function '" + name + "()'")
			os.Exit(1)
		}
	} else if typeof(expr) == "cold.CodeBlock" {
		if expr.(CodeBlock).key == "setvar" {
			code := expr.(CodeBlock)
			if _, exists := (*v)[code.data]; !exists {
				fmt.Println("Error: use of undeclared", code.data)
				os.Exit(1)
			}
			item := eval(code.code[0], v, f, m, entry, main)
			typ := item.Type()
			newvar := entry.NewAlloca(typ)
			entry.NewStore(item, newvar)
			(*v)[code.data] = Variable{newvar, typ}
		} else if expr.(CodeBlock).key == "newvar" {
			code := expr.(CodeBlock)
			if _, exists := (*v)[code.data]; exists {
				fmt.Println("Error: already declared", code.data)
				os.Exit(1)
			}
			item := eval(code.code[0], v, f, m, entry, main)
			typ := item.Type()
			newvar := entry.NewAlloca(typ)
			entry.NewStore(item, newvar)
			(*v)[code.data] = Variable{newvar, typ}
		} else if expr.(CodeBlock).key == "if" {
			code := expr.(CodeBlock)
			//cond := eval(code.code[0], v, f, m, entry, main)
			then := main.NewBlock("")
			parseToLlvm(code.code[1:], v, f, m, then, main)
		}
	} else if typeof(expr) == "cold.Keyword" {
		variable := (*v)[expr.(Keyword).key]
		return entry.NewLoad(variable.typ, variable.ptr)
	}
	return nil
}
func astToLlvm(program []any) string {
	variables := make(map[string]Variable)
	funcs := make(map[string]*ir.Func)
	m := ir.NewModule()
	funcs["printf"] = m.NewFunc("printf", types.Void, ir.NewParam("p1", types.I8Ptr))
	funcs["strcat"] = m.NewFunc("strcat", types.I8Ptr, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I8Ptr))
	main := m.NewFunc("main", types.I32)
	entry := main.NewBlock("")
	for _, line := range program {
		eval(line, &variables, &funcs, m, entry, main)
	}
	entry.NewRet(constant.NewInt(types.I32, 0))

	return m.String()
}
func runLlvm(llvm string) {
	os.WriteFile("program.ll", []byte(llvm), 0644)
	cmd := exec.Command("llc", "-filetype=obj", "program.ll", "-o=program.o", "-O3")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	os.Remove("program.ll")
	cmd = exec.Command("clang", "program.o", "-oprogram", "-O3")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	os.Remove("program.o")
	cmd = exec.Command("./program")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	os.Remove("program")
}
func CompileAndExecute(file string) {
	lexed, indents := lex.Lex(file)
	parsed := parse(lexed, indents)
	llvm := astToLlvm(parsed)
	//fmt.Println(llvm)

	runLlvm(llvm)
}
func compileLlvm(llvm string) {
	os.WriteFile("program.ll", []byte(llvm), 0644)
	cmd := exec.Command("llc", "-filetype=obj", "program.ll", "-o=program.o", "-O3")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	os.Remove("program.ll")
	cmd = exec.Command("clang", "program.o", "-oprogram", "-O3")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	os.Remove("program.o")
}
func Compile(file string) {
	lexed, indents := lex.Lex(file)
	parsed := parse(lexed, indents)
	llvm := astToLlvm(parsed)
	//fmt.Println(llvm)

	compileLlvm(llvm)
}
