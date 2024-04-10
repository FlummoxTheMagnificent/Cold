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
var lastentry *ir.Block

type vari struct {
	ptr   value.Value
	typ   types.Type
	scope int
}

func typeof(item any) string {
	return fmt.Sprintf("%T", item)
}
func stroftype(typ types.Type) string {
	typstr := typ.String()
	if len(typstr) > 12 && typstr[:13] == "{ i8*, i64 }*" {
		return "string" + typstr[13:]
	}
	if len(typstr) > 2 && typstr[:3] == "i64" {
		return "int" + typstr[3:]
	}
	if len(typstr) > 1 && typstr[:2] == "i1" {
		return "bool" + typstr[2:]
	}
	return typstr
}

func evalToLlvm(program []any, v *map[string]vari, f *map[string]*ir.Func, m *ir.Module, main *ir.Func, indent int) {
	for _, line := range program {
		eval(line, v, f, m, lastentry, main, indent)
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
func str(item value.Value, entry *ir.Block, f *map[string]*ir.Func) value.Value {
	if item.Type().String() == "{ i8*, i64 }*" {
		return item
	} else if item.Type().String() == "i64" {
		zero := constant.NewInt(types.I32, 0)
		len := entry.NewCall((*f)["intlen"], item)
		str := entry.NewCall((*f)["strmalloc"], len)
		entry.NewCall((*f)["itoa"], str, item)
		strptr := entry.NewAlloca(strtype)
		newstrgep := entry.NewGetElementPtr(strtype, strptr, zero, zero)
		entry.NewStore(str, newstrgep)
		lengep := entry.NewGetElementPtr(strtype, strptr, zero, constant.NewInt(types.I32, 1))
		entry.NewStore(len, lengep)
		return strptr
	} else if item.Type().String() == "i1" {
		zero := constant.NewInt(types.I32, 0)
		new := entry.NewCall((*f)["booltoint"], item)
		len := entry.NewCall((*f)["intlen"], new)
		str := entry.NewCall((*f)["strmalloc"], len)
		entry.NewCall((*f)["itoa"], str, new)
		strptr := entry.NewAlloca(strtype)
		newstrgep := entry.NewGetElementPtr(strtype, strptr, zero, zero)
		entry.NewStore(str, newstrgep)
		lengep := entry.NewGetElementPtr(strtype, strptr, zero, constant.NewInt(types.I32, 1))
		entry.NewStore(len, lengep)
		return strptr
	} else if item.Type().String() == "float" {
		zero := constant.NewInt(types.I32, 0)
		len := entry.NewCall((*f)["floatlen"], item)
		str := entry.NewCall((*f)["strmalloc"], len)
		entry.NewCall((*f)["ftoa"], str, item)
		strptr := entry.NewAlloca(strtype)
		newstrgep := entry.NewGetElementPtr(strtype, strptr, zero, zero)
		entry.NewStore(str, newstrgep)
		lengep := entry.NewGetElementPtr(strtype, strptr, zero, constant.NewInt(types.I32, 1))
		entry.NewStore(len, lengep)
		return strptr
	}
	fmt.Println("Error: failed to convert", item, "to type string")
	os.Exit(1)
	return nil
}
func clean(v *map[string]vari, indent int) {
	for key, item := range *v {
		if item.scope > indent {
			delete(*v, key)
		}
	}
}
func eval(expr any, v *map[string]vari, f *map[string]*ir.Func, m *ir.Module, entry *ir.Block, main *ir.Func, indent int) value.Value {
	if typeof(expr) == "string" {
		return parseStr(expr.(string), entry)
	} else if typeof(expr) == "float64" {
		return constant.NewFloat(types.Float, expr.(float64))
	} else if typeof(expr) == "int" {
		return constant.NewInt(types.I64, int64(expr.(int)))
	} else if typeof(expr) == "parse.Expression" {
		key := expr.(parse.Expression)
		if key.Expr == "+" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
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
			} else if firstType == "{ i8*, i64 }*" || secondType == "{ i8*, i64 }*" {
				return strJoin(str(first, entry, f), str(second, entry, f), entry, f)
			}
		} else if key.Expr == "-" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := second.Type().String()
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
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := second.Type().String()
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
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
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
		} else if key.Expr == "%" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := second.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewSRem(first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFRem(first, second)
			} else if firstType == "i64" && secondType == "float" {
				return entry.NewFRem(entry.NewSIToFP(first, types.Float), second)
			} else if firstType == "float" && secondType == "i64" {
				return entry.NewFRem(first, entry.NewSIToFP(second, types.Float))
			}
		} else if key.Expr == "=" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := first.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewICmp(enum.IPredEQ, first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFCmp(enum.FPredOEQ, first, second)
			} else if firstType == "i1" && secondType == "i1" {
				return entry.NewICmp(enum.IPredEQ, first, second)
			} else if firstType == "{ i8*, i64 }*" && secondType == "{ i8*, i64 }*" {
				zero := constant.NewInt(types.I32, 0)
				first = entry.NewLoad(types.I8Ptr, entry.NewGetElementPtr(strtype, first, zero, zero))
				second = entry.NewLoad(types.I8Ptr, entry.NewGetElementPtr(strtype, second, zero, zero))
				return entry.NewICmp(enum.IPredEQ, constant.NewInt(types.I8, 0), entry.NewCall((*f)["strcmp"], first, second))
			}
			return constant.NewInt(types.I1, 0)
		} else if key.Expr == "!=" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := first.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewICmp(enum.IPredNE, first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFCmp(enum.FPredONE, first, second)
			} else if firstType == "i1" && secondType == "i1" {
				return entry.NewICmp(enum.IPredNE, first, second)
			}
			return constant.NewInt(types.I1, 0)
		} else if key.Expr == ">" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := first.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewICmp(enum.IPredSGT, first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFCmp(enum.FPredOGT, first, second)
			} else if firstType == "i1" && secondType == "i1" {
				return entry.NewICmp(enum.IPredSGT, first, second)
			}
			return constant.NewInt(types.I1, 0)
		} else if key.Expr == "<" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := second.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewICmp(enum.IPredSLT, first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFCmp(enum.FPredOLT, first, second)
			} else if firstType == "i1" && secondType == "i1" {
				return entry.NewICmp(enum.IPredSLT, first, second)
			}
			return constant.NewInt(types.I1, 0)
		} else if key.Expr == ">=" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := second.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewICmp(enum.IPredSGE, first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFCmp(enum.FPredOGE, first, second)
			} else if firstType == "i1" && secondType == "i1" {
				return entry.NewICmp(enum.IPredSGE, first, second)
			}
			return constant.NewInt(types.I1, 0)
		} else if key.Expr == "<=" {
			first := eval(key.First, v, f, m, entry, main, indent)
			second := eval(key.Second, v, f, m, entry, main, indent)
			firstType := first.Type().String()
			secondType := second.Type().String()
			if firstType == "i64" && secondType == "i64" {
				return entry.NewICmp(enum.IPredSLE, first, second)
			} else if firstType == "float" && secondType == "float" {
				return entry.NewFCmp(enum.FPredOLE, first, second)
			} else if firstType == "i1" && secondType == "i1" {
				return entry.NewICmp(enum.IPredSLE, first, second)
			}
			return constant.NewInt(types.I1, 0)
		}
	} else if typeof(expr) == "parse.Function" {
		name := expr.(parse.Function).Name
		args := expr.(parse.Function).Args
		if name == "print" {
			if len(args) == 0 {
				return nil
			}
			arg := str(eval(args[0], v, f, m, entry, main, indent), entry, f)
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main, indent)
				arg = strJoin(arg, str(this, entry, f), entry, f)
			}
			zero := constant.NewInt(types.I32, 0)
			gep := entry.NewGetElementPtr(strtype, arg, zero, zero)
			entry.NewCall((*f)["print"], entry.NewLoad(types.I8Ptr, gep))
		} else if name == "println" {
			if len(args) == 0 {
				return nil
			}
			arg := str(eval(args[0], v, f, m, entry, main, indent), entry, f)
			for _, i := range args[1:] {
				this := eval(i, v, f, m, entry, main, indent)
				arg = strJoin(arg, str(this, entry, f), entry, f)
			}
			arg = strJoin(arg, parseStr("\n", entry), entry, f)
			zero := constant.NewInt(types.I32, 0)
			gep := entry.NewGetElementPtr(strtype, arg, zero, zero)
			entry.NewCall((*f)["print"], entry.NewLoad(types.I8Ptr, gep))
		} else if name == "typeof" {
			return parseStr(eval(args[0], v, f, m, entry, main, indent).Type().String(), entry)
		} else if name == "str" {
			if len(args) != 1 {
				fmt.Println("Error: wrong argument count for str()")
				os.Exit(1)
			}
			num := eval(args[0], v, f, m, entry, main, indent)
			if num.Type().String() != "i64" {
				fmt.Println("Error: invalid argument type (" + num.Type().String() + ") for function str() (expected int)")
				os.Exit(1)
			}
			return str(num, entry, f)
		} else if function, exists := (*f)[name]; exists {
			list := make([]value.Value, len(args))
			for i, item := range args {
				list[i] = eval(item, v, f, m, entry, main, indent)
			}
			return entry.NewCall(function, list...)
		} else {
			fmt.Println("Error: unrecognized function '" + name + "()'")
			os.Exit(1)
		}
		return nil
	} else if typeof(expr) == "parse.CodeBlock" {
		if expr.(parse.CodeBlock).Key == "setvar" {
			code := expr.(parse.CodeBlock)
			prev, exists := (*v)[code.Data]
			if !exists {
				fmt.Println("Error: assignment of undeclared", code.Data, "(possibly out of scope)")
				os.Exit(1)
			}
			item := eval(code.Code[0], v, f, m, entry, main, indent)
			typ := prev.ptr.Type().String()
			if item.Type().String() != typ[:len(typ)-1] {
				fmt.Println("Error: wrong value type for", code.Data, "(expected", stroftype(prev.typ), "but received", stroftype(item.Type())+")")
				os.Exit(1)
			}
			entry.NewStore(item, (*v)[code.Data].ptr)
		} else if expr.(parse.CodeBlock).Key == "newvar" {
			code := expr.(parse.CodeBlock)
			if _, exists := (*v)[code.Data]; exists {
				fmt.Println("Error: already declared", code.Data)
				os.Exit(1)
			}
			item := eval(code.Code[0], v, f, m, entry, main, indent)
			ptr := entry.NewAlloca(item.Type())
			(*v)[code.Data] = vari{ptr, item.Type(), indent}
			entry.NewStore(item, ptr)
		} else if expr.(parse.CodeBlock).Key == "if" {
			code := expr.(parse.CodeBlock)
			then := main.NewBlock("")
			lastentry = then
			evalToLlvm(code.Code[1:], v, f, m, main, indent+1)
			clean(v, indent)
			new := main.NewBlock("")
			lastentry.NewBr(new)
			lastentry = new
			cond := eval(code.Code[0], v, f, m, entry, main, indent+1)
			entry.NewCondBr(cond, then, new)
		} else if expr.(parse.CodeBlock).Key == "ifelse" {
			code := expr.(parse.CodeBlock)

			then := main.NewBlock("")
			lastentry = then
			new := main.NewBlock("")
			evalToLlvm(code.Code[0].([]any)[1:], v, f, m, main, indent+1)
			clean(v, indent)
			lastentry.NewBr(new)

			els := main.NewBlock("")
			lastentry = els
			evalToLlvm(code.Code[1].([]any), v, f, m, main, indent+1)
			clean(v, indent)
			lastentry.NewBr(new)
			lastentry = new

			cond := eval(code.Code[0].([]any)[0], v, f, m, entry, main, indent)
			entry.NewCondBr(cond, then, els)
		} else if expr.(parse.CodeBlock).Key == "while" {
			code := expr.(parse.CodeBlock)
			loop := main.NewBlock("")
			lastentry = loop
			evalToLlvm(code.Code[1:], v, f, m, main, indent+1)
			clean(v, indent)
			new := main.NewBlock("")
			cond := eval(code.Code[0], v, f, m, lastentry, main, indent)
			lastentry.NewCondBr(cond, loop, new)
			lastentry = new
			cond = eval(code.Code[0], v, f, m, entry, main, indent)
			entry.NewCondBr(cond, loop, new)
		}
		return nil
	} else if typeof(expr) == "parse.Keyword" {
		variable, exists := (*v)[expr.(parse.Keyword).Key]
		if !exists {
			fmt.Println("Error: use of undeclared", expr.(parse.Keyword).Key, "(possibly out of scope)")
			os.Exit(1)
		}
		return entry.NewLoad(variable.typ, variable.ptr)
	}
	fmt.Println("Error: failed to parse", expr)
	os.Exit(1)
	return nil
}
func builtinFuncs(f *map[string]*ir.Func, m *ir.Module) {
	(*f)["print"] = m.NewFunc("printf", types.Void, ir.NewParam("p1", types.I8Ptr))
	(*f)["strcat"] = m.NewFunc("strcat", types.I8Ptr, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I8Ptr))
	(*f)["strcmp"] = m.NewFunc("strcmp", types.I8, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I8Ptr))
	(*f)["intlen"] = m.NewFunc("intlen", types.I64, ir.NewParam("p1", types.I64))
	(*f)["itoa"] = m.NewFunc("itoa", types.I64, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.I64))
	(*f)["floatlen"] = m.NewFunc("floatlen", types.I64, ir.NewParam("p1", types.Float))
	(*f)["ftoa"] = m.NewFunc("ftoa", types.I64, ir.NewParam("p1", types.I8Ptr), ir.NewParam("p2", types.Float))
	(*f)["strmalloc"] = m.NewFunc("malloc", types.I8Ptr, ir.NewParam("p1", types.I64))
	(*f)["booltoint"] = m.NewFunc("booltoint", types.I64, ir.NewParam("p1", types.I1))
}
func astToLlvm(program []any) string {
	variables := make(map[string]vari)
	funcs := make(map[string]*ir.Func)
	m := ir.NewModule()

	builtinFuncs(&funcs, m)
	main := m.NewFunc("main", types.I32)
	lastentry = main.NewBlock("")
	for _, line := range program {
		eval(line, &variables, &funcs, m, lastentry, main, 0)
	}
	lastentry.NewRet(constant.NewInt(types.I32, 0))

	return m.String()
}
func runLlvm(llvm string) {
	os.WriteFile("program.ll", []byte(llvm), 0644)
	cmd := exec.Command("llc", "-filetype=obj", "program.ll", "-o=program.o", "-O3")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
	//os.Remove("program.ll")
	cmd = exec.Command("clang", "program.o", "../cold-c/cold-c.o", "-oprogram", "-O3")
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
