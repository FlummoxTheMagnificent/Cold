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

var strtype = types.NewStruct(types.I8Ptr, types.I64)

type vari struct {
	ptr value.Value
	typ types.Type
}

func typeof(item any) string {
	return fmt.Sprintf("%T", item)
}

func parseToLlvm(program []any, v *map[string]vari, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) {
	for _, line := range program {
		eval(line, v, f, m, entry, main)
	}
}
func parseStr(str string, entry *ir.Block) value.Value {
	zero := constant.NewInt(types.I32, 0)
	arrayType := types.NewArray(uint64(len(str)+1), types.I8)
	charArray := entry.NewAlloca(arrayType)
	entry.NewStore(constant.NewCharArrayFromString(str+"\x00"), charArray)

	strptr := entry.NewAlloca(strtype)
	strgep := entry.NewGetElementPtr(arrayType, charArray, zero, zero)
	len := constant.NewInt(types.I64, int64(len(str)+1))

	newstrgep := entry.NewGetElementPtr(strtype, strptr, zero, zero)
	entry.NewStore(strgep, newstrgep)
	lengep := entry.NewGetElementPtr(strtype, strptr, zero, constant.NewInt(types.I32, 1))
	entry.NewStore(len, lengep)

	return strptr
}
func strJoin(first value.Value, second value.Value, entry *ir.Block, f *map[string]*ir.Func) value.Value {
	zero := constant.NewInt(types.I32, 0)
	one := constant.NewInt(types.I32, 1)
	firstlen := entry.NewLoad(types.I64, entry.NewGetElementPtr(strtype, first, zero, one))
	secondlen := entry.NewLoad(types.I64, entry.NewGetElementPtr(strtype, second, zero, one))

	len := entry.NewAdd(firstlen, secondlen)
	str := entry.NewCall((*f)["strmalloc"], len)
	entry.NewCall((*f)["strcat"], str, entry.NewLoad(types.I8Ptr, entry.NewGetElementPtr(strtype, first, zero, zero)))
	entry.NewCall((*f)["strcat"], str, entry.NewLoad(types.I8Ptr, entry.NewGetElementPtr(strtype, second, zero, zero)))

	strptr := entry.NewAlloca(strtype)
	newstrgep := entry.NewGetElementPtr(strtype, strptr, zero, zero)
	entry.NewStore(str, newstrgep)
	lengep := entry.NewGetElementPtr(strtype, strptr, zero, constant.NewInt(types.I32, 1))
	entry.NewStore(len, lengep)

	return strptr
}
func eval(expr any, v *map[string]vari, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func) value.Value {
	if typeof(expr) == "string" {
		return parseStr(expr.(string), entry)
	} else if typeof(expr) == "float64" {
		return constant.NewFloat(types.Float, expr.(float64))
	} else if typeof(expr) == "int" {
		return constant.NewInt(types.I64, int64(expr.(int)))
	} else if typeof(expr) == "parse.Expression" {
		key := expr.(parse.Expression)
		if key.Expr == "+" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := first.Type().String()
			secondType := second.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewAdd(first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFAdd(first, second)
			} else if firstType == "i64" && secondType == "float" {
				return entry.NewFAdd(entry.NewSIToFP(first, types.Float), second)
			} else if firstType == "float" && secondType == "i64" {
				return entry.NewFAdd(first, entry.NewSIToFP(second, types.Float))
			} else if firstType == "{ i8*, i64 }*" && secondType == "{ i8*, i64 }*" {
				return strJoin(first, second, entry, f)
			}
		} else if key.Expr == "-" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return entry.NewSub(first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFSub(first, second)
			} else if firstType == "i64" && secondType == "float" {
				return entry.NewFSub(entry.NewSIToFP(first, types.Float), second)
			} else if firstType == "float" && secondType == "i64" {
				return entry.NewFSub(first, entry.NewSIToFP(second, types.Float))
			}
		} else if key.Expr == "*" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "i64" && secondType == "i64" {
				return entry.NewMul(first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFMul(first, second)
			} else if firstType == "i64" && secondType == "float" {
				return entry.NewFMul(entry.NewSIToFP(first, types.Float), second)
			} else if firstType == "float" && secondType == "i64" {
				return entry.NewFMul(first, entry.NewSIToFP(second, types.Float))
			}
		} else if key.Expr == "/" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := first.Type().String()
			secondType := second.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewSDiv(first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFDiv(first, second)
			} else if firstType == "i64" && secondType == "float" {
				return entry.NewFDiv(entry.NewSIToFP(first, types.Float), second)
			} else if firstType == "float" && secondType == "i64" {
				return entry.NewFDiv(first, entry.NewSIToFP(second, types.Float))
			}
		} else if key.Expr == "=" {
			first := eval(key.First, v, f, m, entry, main)
			second := eval(key.Second, v, f, m, entry, main)
			firstType := typeof(first)[10:]
			secondType := typeof(second)[10:]
			if firstType == "Int" && secondType == "Int" {
				return entry.NewICmp(enum.IPredEQ, first, second)
			} else if firstType == "Float" && secondType == "Float" {
				return entry.NewFCmp(enum.FPredOEQ, first, second)
			} else if firstType == "Int" && secondType == "Float" {
				return entry.NewFCmp(enum.FPredOEQ, first, second)
			} else if firstType == "Float" && secondType == "Int" {
				return entry.NewFCmp(enum.FPredOEQ, first, second)
			}
		}
	} else if typeof(expr) == "parse.Function" {
		name := expr.(parse.Function).Name
		args := expr.(parse.Function).Args
		if name == "print" {
			if len(args) == 0 {
				return nil
			}
			arg := eval(args[0], v, f, m, entry, main)
			if arg.Type().String() != "{ i8*, i64 }*" {
				fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
				os.Exit(1)
			}
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "{ i8*, i64 }*" {
					fmt.Println("Error: invalid argument type", this.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = strJoin(arg, this, entry, f)
			}
			zero := constant.NewInt(types.I32, 0)
			gep := entry.NewGetElementPtr(strtype, arg, zero, zero)
			entry.NewCall((*f)["print"], entry.NewLoad(types.I8Ptr, gep))
		} else if name == "println" {
			if len(args) == 0 {
				return nil
			}
			arg := eval(args[0], v, f, m, entry, main)
			if arg.Type().String() != "{ i8*, i64 }*" {
				fmt.Println("Error: invalid argument type", arg.Type().String(), "for function", name+"()", "(expected", "string"+")")
				os.Exit(1)
			}
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main)
				if this.Type().String() != "{ i8*, i64 }*" {
					fmt.Println("Error: invalid argument type", this.Type().String(), "for function", name+"()", "(expected", "string"+")")
					os.Exit(1)
				}
				arg = strJoin(arg, this, entry, f)
			}
			arg = strJoin(arg, parseStr("\n", entry), entry, f)
			zero := constant.NewInt(types.I32, 0)
			gep := entry.NewGetElementPtr(strtype, arg, zero, zero)
			entry.NewCall((*f)["print"], entry.NewLoad(types.I8Ptr, gep))
		} else if name == "typeof" {
			return parseStr(eval(args[0], v, f, m, entry, main).Type().String(), entry)
		} else if name == "str" {
			if len(args) != 1 {
				fmt.Println("Error: wrong argument count for typeof()")
				os.Exit(1)
			}
			function := (*f)["sprintf"]
			zero := constant.NewInt(types.I64, 0)
			str := entry.NewGetElementPtr(types.NewArray(20, types.I8), entry.NewAlloca(types.NewArray(20, types.I8)), zero, zero)
			instr := parseStr("%d", entry)
			num := eval(args[0], v, f, m, entry, main)
			entry.NewCall(function, str, instr, num)
			return str
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
	} else if typeof(expr) == "parse.CodeBlock" {
		if expr.(parse.CodeBlock).Key == "setvar" {
			code := expr.(parse.CodeBlock)
			prev, exists := (*v)[code.Data]
			if !exists {
				fmt.Println("Error: use of undeclared", code.Data)
				os.Exit(1)
			}
			item := eval(code.Code[0], v, f, m, entry, main)
			typ := prev.ptr.Type().String()
			if item.Type().String() != typ[:len(typ)-1] {
				fmt.Println("Error: wrong value type for", code.Data, "(expected", typ[:len(typ)-1], "but received", item.Type().String()+")")
				os.Exit(1)
			}
			entry.NewStore(item, (*v)[code.Data].ptr)
		} else if expr.(parse.CodeBlock).Key == "newvar" {
			code := expr.(parse.CodeBlock)
			if _, exists := (*v)[code.Data]; exists {
				fmt.Println("Error: already declared", code.Data)
				os.Exit(1)
			}
			item := eval(code.Code[0], v, f, m, entry, main)
			ptr := entry.NewAlloca(item.Type())
			(*v)[code.Data] = vari{ptr, item.Type()}
			entry.NewStore(item, ptr)
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
		return entry.NewLoad(variable.typ, variable.ptr)
	}
	return nil
}
func builtinFuncs(f *map[string]*ir.Func, m *ir.Module) {
	(*f)["print"] = m.NewFunc("printf", types.Void, ir.NewParam("p1", types.I8Ptr))
	(*f)["strcat"] = m.NewFunc("strcat", types.I8Ptr, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I8Ptr))
	(*f)["sprintf"] = m.NewFunc("sprintf", types.I64, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I8Ptr), ir.NewParam("p3", types.I64))
	(*f)["strmalloc"] = m.NewFunc("malloc", types.I8Ptr, ir.NewParam("p1", types.I64))
}
func astToLlvm(program []any) string {
	variables := make(map[string]vari)
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
	//os.Remove("program.ll")
	cmd = exec.Command("clang", "program.o", "cold-c.o", "-oprogram", "-O3")
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
	fmt.Println(lexed)
	parsed := parse.Parse(lexed, indents)
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

	compileLlvm(llvm)
}
