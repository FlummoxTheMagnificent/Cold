declare void @printf(i8* %p1)

declare i8* @strcat(i8* %p1, i8* %p2)

declare i64 @intlen(i64 %p1)

declare i64 @itoa(i8* %p1, i64 %p2)

declare i64 @floatlen(float %p1)

declare i64 @ftoa(i8* %p1, float %p2)

declare i64 @snprintf(i8* %p1, i64 %p2, i8* %p3, float %p4)

declare i8* @malloc(i64 %p1)

define i32 @main() {
0:
	%1 = alloca [6 x i8]
	store [6 x i8] c"start\00", [6 x i8]* %1
	%2 = alloca { i8*, i64 }
	%3 = getelementptr [6 x i8], [6 x i8]* %1, i32 0, i32 0
	%4 = getelementptr { i8*, i64 }, { i8*, i64 }* %2, i32 0, i32 0
	store i8* %3, i8** %4
	%5 = getelementptr { i8*, i64 }, { i8*, i64 }* %2, i32 0, i32 1
	store i64 6, i64* %5
	%6 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %6
	%7 = alloca { i8*, i64 }
	%8 = getelementptr [2 x i8], [2 x i8]* %6, i32 0, i32 0
	%9 = getelementptr { i8*, i64 }, { i8*, i64 }* %7, i32 0, i32 0
	store i8* %8, i8** %9
	%10 = getelementptr { i8*, i64 }, { i8*, i64 }* %7, i32 0, i32 1
	store i64 2, i64* %10
	%11 = getelementptr { i8*, i64 }, { i8*, i64 }* %2, i32 0, i32 1
	%12 = load i64, i64* %11
	%13 = getelementptr { i8*, i64 }, { i8*, i64 }* %7, i32 0, i32 1
	%14 = load i64, i64* %13
	%15 = add i64 %12, %14
	%16 = call i8* @malloc(i64 %15)
	%17 = getelementptr { i8*, i64 }, { i8*, i64 }* %2, i32 0, i32 0
	%18 = load i8*, i8** %17
	%19 = call i8* @strcat(i8* %16, i8* %18)
	%20 = getelementptr { i8*, i64 }, { i8*, i64 }* %7, i32 0, i32 0
	%21 = load i8*, i8** %20
	%22 = call i8* @strcat(i8* %16, i8* %21)
	%23 = alloca { i8*, i64 }
	%24 = getelementptr { i8*, i64 }, { i8*, i64 }* %23, i32 0, i32 0
	store i8* %16, i8** %24
	%25 = getelementptr { i8*, i64 }, { i8*, i64 }* %23, i32 0, i32 1
	store i64 %15, i64* %25
	%26 = getelementptr { i8*, i64 }, { i8*, i64 }* %23, i32 0, i32 0
	%27 = load i8*, i8** %26
	call void @printf(i8* %27)
	%28 = icmp eq i64 1, 1
	br i1 %28, label %29, label %84

29:
	%30 = alloca [5 x i8]
	store [5 x i8] c"true\00", [5 x i8]* %30
	%31 = alloca { i8*, i64 }
	%32 = getelementptr [5 x i8], [5 x i8]* %30, i32 0, i32 0
	%33 = getelementptr { i8*, i64 }, { i8*, i64 }* %31, i32 0, i32 0
	store i8* %32, i8** %33
	%34 = getelementptr { i8*, i64 }, { i8*, i64 }* %31, i32 0, i32 1
	store i64 5, i64* %34
	%35 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %35
	%36 = alloca { i8*, i64 }
	%37 = getelementptr [2 x i8], [2 x i8]* %35, i32 0, i32 0
	%38 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 0
	store i8* %37, i8** %38
	%39 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 1
	store i64 2, i64* %39
	%40 = getelementptr { i8*, i64 }, { i8*, i64 }* %31, i32 0, i32 1
	%41 = load i64, i64* %40
	%42 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 1
	%43 = load i64, i64* %42
	%44 = add i64 %41, %43
	%45 = call i8* @malloc(i64 %44)
	%46 = getelementptr { i8*, i64 }, { i8*, i64 }* %31, i32 0, i32 0
	%47 = load i8*, i8** %46
	%48 = call i8* @strcat(i8* %45, i8* %47)
	%49 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 0
	%50 = load i8*, i8** %49
	%51 = call i8* @strcat(i8* %45, i8* %50)
	%52 = alloca { i8*, i64 }
	%53 = getelementptr { i8*, i64 }, { i8*, i64 }* %52, i32 0, i32 0
	store i8* %45, i8** %53
	%54 = getelementptr { i8*, i64 }, { i8*, i64 }* %52, i32 0, i32 1
	store i64 %44, i64* %54
	%55 = getelementptr { i8*, i64 }, { i8*, i64 }* %52, i32 0, i32 0
	%56 = load i8*, i8** %55
	call void @printf(i8* %56)
	%57 = alloca [11 x i8]
	store [11 x i8] c"still true\00", [11 x i8]* %57
	%58 = alloca { i8*, i64 }
	%59 = getelementptr [11 x i8], [11 x i8]* %57, i32 0, i32 0
	%60 = getelementptr { i8*, i64 }, { i8*, i64 }* %58, i32 0, i32 0
	store i8* %59, i8** %60
	%61 = getelementptr { i8*, i64 }, { i8*, i64 }* %58, i32 0, i32 1
	store i64 11, i64* %61
	%62 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %62
	%63 = alloca { i8*, i64 }
	%64 = getelementptr [2 x i8], [2 x i8]* %62, i32 0, i32 0
	%65 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 0
	store i8* %64, i8** %65
	%66 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 1
	store i64 2, i64* %66
	%67 = getelementptr { i8*, i64 }, { i8*, i64 }* %58, i32 0, i32 1
	%68 = load i64, i64* %67
	%69 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 1
	%70 = load i64, i64* %69
	%71 = add i64 %68, %70
	%72 = call i8* @malloc(i64 %71)
	%73 = getelementptr { i8*, i64 }, { i8*, i64 }* %58, i32 0, i32 0
	%74 = load i8*, i8** %73
	%75 = call i8* @strcat(i8* %72, i8* %74)
	%76 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 0
	%77 = load i8*, i8** %76
	%78 = call i8* @strcat(i8* %72, i8* %77)
	%79 = alloca { i8*, i64 }
	%80 = getelementptr { i8*, i64 }, { i8*, i64 }* %79, i32 0, i32 0
	store i8* %72, i8** %80
	%81 = getelementptr { i8*, i64 }, { i8*, i64 }* %79, i32 0, i32 1
	store i64 %71, i64* %81
	%82 = getelementptr { i8*, i64 }, { i8*, i64 }* %79, i32 0, i32 0
	%83 = load i8*, i8** %82
	call void @printf(i8* %83)
	br label %84

84:
	%85 = alloca [4 x i8]
	store [4 x i8] c"end\00", [4 x i8]* %85
	%86 = alloca { i8*, i64 }
	%87 = getelementptr [4 x i8], [4 x i8]* %85, i32 0, i32 0
	%88 = getelementptr { i8*, i64 }, { i8*, i64 }* %86, i32 0, i32 0
	store i8* %87, i8** %88
	%89 = getelementptr { i8*, i64 }, { i8*, i64 }* %86, i32 0, i32 1
	store i64 4, i64* %89
	%90 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %90
	%91 = alloca { i8*, i64 }
	%92 = getelementptr [2 x i8], [2 x i8]* %90, i32 0, i32 0
	%93 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 0
	store i8* %92, i8** %93
	%94 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 1
	store i64 2, i64* %94
	%95 = getelementptr { i8*, i64 }, { i8*, i64 }* %86, i32 0, i32 1
	%96 = load i64, i64* %95
	%97 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 1
	%98 = load i64, i64* %97
	%99 = add i64 %96, %98
	%100 = call i8* @malloc(i64 %99)
	%101 = getelementptr { i8*, i64 }, { i8*, i64 }* %86, i32 0, i32 0
	%102 = load i8*, i8** %101
	%103 = call i8* @strcat(i8* %100, i8* %102)
	%104 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 0
	%105 = load i8*, i8** %104
	%106 = call i8* @strcat(i8* %100, i8* %105)
	%107 = alloca { i8*, i64 }
	%108 = getelementptr { i8*, i64 }, { i8*, i64 }* %107, i32 0, i32 0
	store i8* %100, i8** %108
	%109 = getelementptr { i8*, i64 }, { i8*, i64 }* %107, i32 0, i32 1
	store i64 %99, i64* %109
	%110 = getelementptr { i8*, i64 }, { i8*, i64 }* %107, i32 0, i32 0
	%111 = load i8*, i8** %110
	call void @printf(i8* %111)
	ret i32 0
}
