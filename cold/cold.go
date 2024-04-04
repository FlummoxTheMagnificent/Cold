package cold

import (
	"fmt"
	"os"
	"os/exec"

	"github.com/FlummoxTheMagnificent/Cold/tree/main/lex"
	"github.com/FlummoxTheMagnificent/Cold/tree/main/parse"

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
	ptr Value
	typ types.Type
}
type Value struct {
	typ   types.Type
	ptr   value.Value
	isarr bool
	len   uint64
}

func (val Value) Type() types.Type {
	return val.typ
}
func (val Value) Ident() string {
	return val.ptr.Ident()
}
func (val Value) String() string {
	return val.ptr.String()
}

func parseToLlvm(program []any, v *map[string]Value, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) {
	for _, line := range program {
		eval(line, v, f, m, entry, main)
	}
}
func eval(expr any, v *map[string]Value, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) Value {
	if typeof(expr) == "string" {
		zero := constant.NewInt(types.I64, 0)
		arrayType := types.NewArray(uint64(len(expr.(string))+1), types.I8)
		charArray := entry.NewAlloca(arrayType)
		entry.NewStore(constant.NewCharArrayFromString(expr.(string)+"\x00"), charArray)
		return Value{types.I8Ptr, entry.NewGetElementPtr(arrayType, charArray, zero, zero), true, uint64(len(expr.(string)) + 1)}
	} else if typeof(expr) == "float64" {
		return Value{types.Float, constant.NewFloat(types.Float, expr.(float64)), false, 0}
	} else if typeof(expr) == "int" {
		return Value{types.I64, constant.NewInt(types.I64, int64(expr.(int))), false, 0}
	} else if typeof(expr) == "cold.Expression" {
		key := expr.(Expression)
		if key.expr == "+" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := first.Type().String()
			secondType := second.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return Value{types.I64, entry.NewAdd(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return Value{types.Float, entry.NewFAdd(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return Value{types.Float, entry.NewFAdd(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return Value{types.Float, entry.NewFAdd(first, entry.NewSIToFP(second, types.Float)), false, 0}
			} else if firstType == "i8*" && secondType == "i8*" {
				zero := constant.NewInt(types.I64, 0)
				len := first.len + second.len
				blank := eval(make([]byte, len), v, f, m, entry, main)
				first_long := entry.NewCall((*f)["strcat"], blank, first.ptr)
				firstPtr := entry.NewGetElementPtr(types.NewArray(len, types.I8), first_long, zero, zero)
				joined := entry.NewCall((*f)["strcat"], firstPtr, second.ptr)
				joinedPtr := entry.NewGetElementPtr(types.NewArray(len, types.I8), joined, zero, zero)
				return Value{types.I8Ptr, joinedPtr, true, len}
			}
		} else if key.expr == "-" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return Value{types.I64, entry.NewSub(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return Value{types.Float, entry.NewFSub(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return Value{types.Float, entry.NewFSub(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return Value{types.Float, entry.NewFSub(first, entry.NewSIToFP(second, types.Float)), false, 0}
			}
		} else if key.expr == "*" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return Value{types.I64, entry.NewMul(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return Value{types.Float, entry.NewFMul(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return Value{types.Float, entry.NewFMul(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return Value{types.Float, entry.NewFMul(first, entry.NewSIToFP(second, types.Float)), false, 0}
			}
		} else if key.expr == "/" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return Value{types.I64, entry.NewSDiv(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return Value{types.Float, entry.NewFDiv(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return Value{types.Float, entry.NewFDiv(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return Value{types.Float, entry.NewFDiv(first, entry.NewSIToFP(second, types.Float)), false, 0}
			}
		} else if key.expr == "=" {
			first := eval(key.first, v, f, m, entry, main)
			second := eval(key.second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "Int" && secondType == "Int" {
				return Value{types.I64, entry.NewICmp(enum.IPredEQ, first, second), false, 0}
			} else if firstType == "Float" && secondType == "Float" {
				return Value{types.Float, entry.NewICmp(enum.IPred(enum.FPredOEQ), first, second), false, 0}
			} else if firstType == "Int" && secondType == "Float" {
				return Value{types.Float, entry.NewICmp(enum.IPred(enum.FPredOEQ), first, second), false, 0}
			} else if firstType == "Float" && secondType == "Int" {
				return Value{types.Float, entry.NewICmp(enum.IPred(enum.FPredOEQ), first, second), false, 0}
			}
		}
	} else if typeof(expr) == "cold.Function" {
		name := expr.(Function).name
		args := expr.(Function).args
		if name == "print" {
			if len(args) == 0 {
				return Value{}
			}
			arg := eval(args[0], v, f, m, entry, main)
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "i8*" {
					fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = Value{types.NewArray(arg.len+this.len, arg.typ), entry.NewCall((*f)["strcat"], entry.NewCall((*f)["strcat"], eval(string(make([]byte, arg.len+this.len)), v, f, m, entry, main), arg), this), true, arg.len + this.len}
			}
			entry.NewCall((*f)["print"], arg)
		} else if name == "println" {
			if len(args) == 0 {
				return Value{}
			}
			arg := eval(args[0], v, f, m, entry, main)
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "i8*" {
					fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = Value{types.NewArray(arg.len+this.len, arg.typ), entry.NewCall((*f)["strcat"], entry.NewCall((*f)["strcat"], eval(string(make([]byte, arg.len+this.len)), v, f, m, entry, main), arg), this), true, arg.len + this.len}
			}
			arg = Value{types.NewArray(arg.len+2, arg.typ), entry.NewCall((*f)["strcat"], entry.NewCall((*f)["strcat"], eval(string(make([]byte, arg.len+2)), v, f, m, entry, main), arg), eval("\n\x00", v, f, m, entry, main)), true, arg.len + 2}
			entry.NewCall((*f)["print"], arg)
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
			return Value{function.Sig.RetType, entry.NewCall(function, list...), false, 0}
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
			prev := (*v)[code.data]
			if !typ.Equal(prev.typ) {
				fmt.Println("Error: wrong value type for", code.data, "(expected", prev.typ.String(), "but received", typ.String()+")")
				os.Exit(1)
			}
			entry.NewStore(item, prev.ptr)
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
			(*v)[code.data] = Value{typ, newvar, false, 0}
		} else if expr.(CodeBlock).key == "if" {
			code := expr.(CodeBlock)
			//cond := eval(code.code[0], v, f, m, entry, main)
			then := main.NewBlock("")
			parseToLlvm(code.code[1:], v, f, m, then, main)
		}
	} else if typeof(expr) == "cold.Keyword" {
		variable, exists := (*v)[expr.(Keyword).key]
		if !exists {
			fmt.Println("Error: use of undeclared", expr.(Keyword).key)
			os.Exit(1)
		}
		return Value{variable.typ, entry.NewLoad(variable.typ, variable.ptr), false, 0}
	}
	return Value{}
}
func builtinFuncs(f *map[string]*ir.Func, m *ir.Module) {
	(*f)["print"] = m.NewFunc("printf", types.Void, ir.NewParam("p1", types.I8Ptr))
	(*f)["strcat"] = m.NewFunc("strcat", types.I8Ptr, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I8Ptr))
	(*f)["strlen"] = m.NewFunc("strlen", types.I64, ir.NewParam("p1", types.I8Ptr))
}
func astToLlvm(program []any) string {
	variables := make(map[string]Value)
	funcs := make(map[string]*ir.Func)
	m := ir.NewModule()
	builtinFuncs(&funcs, m)
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
	//a := Array{nil, }
	lexed, indents := lex.Lex(file)
	parsed := parse.Parse(lexed, indents)
	fmt.Println(parsed)
	llvm := astToLlvm(parsed)
	fmt.Println(llvm)

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
	parsed := parse.Parse(lexed, indents)
	llvm := astToLlvm(parsed)
	//fmt.Println(llvm)

	compileLlvm(llvm)
}
