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

type val struct {
	typ   types.Type
	ptr   value.Value
	isarr bool
	len   uint64
}

func (v val) Type() types.Type {
	return v.typ
}
func (v val) Ident() string {
	return v.ptr.Ident()
}
func (v val) String() string {
	return v.ptr.String()
}

func parseToLlvm(program []any, v *map[string]val, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) {
	for _, line := range program {
		eval(line, v, f, m, entry, main)
	}
}
func strJoin(first val, second val, entry *ir.Block, f *map[string]*ir.Func) val {
	len := first.len + second.len
	zero := constant.NewInt(types.I64, 0)
	arrayType := types.NewArray(len, types.I8)
	charArray := entry.NewAlloca(arrayType)
	entry.NewStore(constant.NewCharArray(make([]byte, len)), charArray)

	blank := val{types.I8Ptr, entry.NewGetElementPtr(arrayType, charArray, zero, zero), true, len}
	firstExtended := entry.NewCall((*f)["strcat"], blank, first.ptr)

	joined := entry.NewCall((*f)["strcat"], firstExtended, second.ptr)
	return val{types.I8Ptr, joined, true, len}
}
func eval(expr any, v *map[string]val, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) val {
	if typeof(expr) == "string" {
		zero := constant.NewInt(types.I64, 0)
		arrayType := types.NewArray(uint64(len(expr.(string))+1), types.I8)
		charArray := entry.NewAlloca(arrayType)
		entry.NewStore(constant.NewCharArrayFromString(expr.(string)+"\x00"), charArray)
		return val{types.I8Ptr, entry.NewGetElementPtr(arrayType, charArray, zero, zero), true, uint64(len(expr.(string)) + 1)}
	} else if typeof(expr) == "float64" {
		return val{types.Float, constant.NewFloat(types.Float, expr.(float64)), false, 0}
	} else if typeof(expr) == "int" {
		return val{types.I64, constant.NewInt(types.I64, int64(expr.(int))), false, 0}
	} else if typeof(expr) == "parse.Expression" {
		key := expr.(parse.Expression)
		if key.Expr == "+" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := first.typ.String()
			secondType := second.typ.String()
			if firstType == "i64" && secondType == "i64" {
				return val{types.I64, entry.NewAdd(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return val{types.Float, entry.NewFAdd(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return val{types.Float, entry.NewFAdd(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return val{types.Float, entry.NewFAdd(first, entry.NewSIToFP(second, types.Float)), false, 0}
			} else if firstType == "i8*" && secondType == "i8*" {
				return strJoin(first, second, entry, f)
			}
		} else if key.Expr == "-" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return val{types.I64, entry.NewSub(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return val{types.Float, entry.NewFSub(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return val{types.Float, entry.NewFSub(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return val{types.Float, entry.NewFSub(first, entry.NewSIToFP(second, types.Float)), false, 0}
			}
		} else if key.Expr == "*" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return val{types.I64, entry.NewMul(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return val{types.Float, entry.NewFMul(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return val{types.Float, entry.NewFMul(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return val{types.Float, entry.NewFMul(first, entry.NewSIToFP(second, types.Float)), false, 0}
			}
		} else if key.Expr == "/" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return val{types.I64, entry.NewSDiv(first, second), false, 0}
			} else if firstType == "float" && secondType == "float" {
				return val{types.Float, entry.NewFDiv(first, second), false, 0}
			} else if firstType == "i64" && secondType == "float" {
				return val{types.Float, entry.NewFDiv(entry.NewSIToFP(first, types.Float), second), false, 0}
			} else if firstType == "float" && secondType == "i64" {
				return val{types.Float, entry.NewFDiv(first, entry.NewSIToFP(second, types.Float)), false, 0}
			}
		} else if key.Expr == "=" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "Int" && secondType == "Int" {
				return val{types.I64, entry.NewICmp(enum.IPredEQ, first, second), false, 0}
			} else if firstType == "Float" && secondType == "Float" {
				return val{types.Float, entry.NewICmp(enum.IPred(enum.FPredOEQ), first, second), false, 0}
			} else if firstType == "Int" && secondType == "Float" {
				return val{types.Float, entry.NewICmp(enum.IPred(enum.FPredOEQ), first, second), false, 0}
			} else if firstType == "Float" && secondType == "Int" {
				return val{types.Float, entry.NewICmp(enum.IPred(enum.FPredOEQ), first, second), false, 0}
			}
		}
	} else if typeof(expr) == "parse.Function" {
		name := expr.(parse.Function).Name
		args := expr.(parse.Function).Args
		if name == "print" {
			if len(args) == 0 {
				return val{}
			}
			arg := eval(args[0], v, f, m, entry, main)
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "i8*" {
					fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = strJoin(arg, this, entry, f)
			}
			entry.NewCall((*f)["print"], arg)
		} else if name == "println" {
			if len(args) == 0 {
				return val{}
			}
			arg := eval(args[0], v, f, m, entry, main)
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "i8*" {
					fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = strJoin(arg, this, entry, f)
			}

			zero := constant.NewInt(types.I64, 0)
			arrayType := types.NewArray(2, types.I8)
			charArray := entry.NewAlloca(arrayType)
			entry.NewStore(constant.NewCharArrayFromString("\n\x00"), charArray)
			str := val{types.I8Ptr, entry.NewGetElementPtr(arrayType, charArray, zero, zero), true, 2}

			arg = strJoin(arg, str, entry, f)
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
			return val{function.Sig.RetType, entry.NewCall(function, list...), false, 0}
		} else {
			fmt.Println("Error: unrecognized function '" + name + "()'")
			os.Exit(1)
		}
	} else if typeof(expr) == "parse.CodeBlock" {
		if expr.(parse.CodeBlock).Key == "setvar" {
			code := expr.(parse.CodeBlock)
			prev, exists := (*v)[code.Data]
			if !exists {
				fmt.Println("Error: use of undeclared", code.Data)
				os.Exit(1)
			}
			item := eval(code.Code[0], v, f, m, entry, main)
			typ := item.Type()
			if !typ.Equal(prev.typ) {
				fmt.Println("Error: wrong value type for", code.Data, "(expected", prev.typ.String(), "but received", typ.String()+")")
				os.Exit(1)
			}
			entry.NewStore(item, prev.ptr)
		} else if expr.(parse.CodeBlock).Key == "newvar" {
			code := expr.(parse.CodeBlock)
			if _, exists := (*v)[code.Data]; exists {
				fmt.Println("Error: already declared", code.Data)
				os.Exit(1)
			}
			item := eval(code.Code[0], v, f, m, entry, main)
			typ := item.Type()
			newvar := entry.NewAlloca(typ)
			entry.NewStore(item, newvar)
			(*v)[code.Data] = val{typ, newvar, item.isarr, item.len}
		} else if expr.(parse.CodeBlock).Key == "if" {
			code := expr.(parse.CodeBlock)
			//cond := eval(code.code[0], v, f, m, entry, main)
			then := main.NewBlock("")
			parseToLlvm(code.Code[1:], v, f, m, then, main)
		}
	} else if typeof(expr) == "parse.Keyword" {
		variable, exists := (*v)[expr.(parse.Keyword).Key]
		if !exists {
			fmt.Println("Error: use of undeclared", expr.(parse.Keyword).Key)
			os.Exit(1)
		}
		return val{variable.typ, entry.NewLoad(variable.typ, variable.ptr), variable.isarr, variable.len}
	}
	return val{}
}
func builtinFuncs(f *map[string]*ir.Func, m *ir.Module) {
	(*f)["print"] = m.NewFunc("printf", types.Void, ir.NewParam("p1", types.I8Ptr))
	(*f)["strcat"] = m.NewFunc("strcat", types.I8Ptr, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I8Ptr))
}
func astToLlvm(program []any) string {
	variables := make(map[string]val)
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
	lexed, indents := lex.Lex(file)
	parsed := parse.Parse(lexed, indents)
	llvm := astToLlvm(parsed)
	// fmt.Println(llvm)

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

	compileLlvm(llvm)
}
