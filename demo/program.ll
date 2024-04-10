declare void @printf(i8* %p1)

declare i8* @strcat(i8* %p1, i8* %p2)

declare i8 @strcmp(i8* %p1, i8* %p2)

declare i64 @intlen(i64 %p1)

declare i64 @itoa(i8* %p1, i64 %p2)

declare i64 @floatlen(float %p1)

declare i64 @ftoa(i8* %p1, float %p2)

declare i8* @malloc(i64 %p1)

declare i64 @booltoint(i1 %p1)

define i32 @main() {
0:
	%1 = alloca i64
	store i64 0, i64* %1
	%2 = load i64, i64* %1
	%3 = icmp slt i64 %2, 100
	br i1 %3, label %4, label %118

4:
	%5 = load i64, i64* %1
	%6 = add i64 %5, 1
	store i64 %6, i64* %1
	%7 = alloca [1 x i8]
	store [1 x i8] c"\00", [1 x i8]* %7
	%8 = alloca { i8*, i64 }
	%9 = getelementptr [1 x i8], [1 x i8]* %7, i32 0, i32 0
	%10 = getelementptr { i8*, i64 }, { i8*, i64 }* %8, i32 0, i32 0
	store i8* %9, i8** %10
	%11 = getelementptr { i8*, i64 }, { i8*, i64 }* %8, i32 0, i32 1
	store i64 1, i64* %11
	%12 = alloca { i8*, i64 }*
	store { i8*, i64 }* %8, { i8*, i64 }** %12
	%13 = load i64, i64* %1
	%14 = srem i64 %13, 3
	%15 = icmp eq i64 %14, 0
	br i1 %15, label %16, label %22

16:
	%17 = alloca [5 x i8]
	store [5 x i8] c"Fizz\00", [5 x i8]* %17
	%18 = alloca { i8*, i64 }
	%19 = getelementptr [5 x i8], [5 x i8]* %17, i32 0, i32 0
	%20 = getelementptr { i8*, i64 }, { i8*, i64 }* %18, i32 0, i32 0
	store i8* %19, i8** %20
	%21 = getelementptr { i8*, i64 }, { i8*, i64 }* %18, i32 0, i32 1
	store i64 5, i64* %21
	store { i8*, i64 }* %18, { i8*, i64 }** %12
	br label %22

22:
	%23 = load i64, i64* %1
	%24 = srem i64 %23, 5
	%25 = icmp eq i64 %24, 0
	br i1 %25, label %26, label %48

26:
	%27 = load { i8*, i64 }*, { i8*, i64 }** %12
	%28 = alloca [5 x i8]
	store [5 x i8] c"Buzz\00", [5 x i8]* %28
	%29 = alloca { i8*, i64 }
	%30 = getelementptr [5 x i8], [5 x i8]* %28, i32 0, i32 0
	%31 = getelementptr { i8*, i64 }, { i8*, i64 }* %29, i32 0, i32 0
	store i8* %30, i8** %31
	%32 = getelementptr { i8*, i64 }, { i8*, i64 }* %29, i32 0, i32 1
	store i64 5, i64* %32
	%33 = getelementptr { i8*, i64 }, { i8*, i64 }* %27, i32 0, i32 1
	%34 = load i64, i64* %33
	%35 = getelementptr { i8*, i64 }, { i8*, i64 }* %29, i32 0, i32 1
	%36 = load i64, i64* %35
	%37 = add i64 %34, %36
	%38 = call i8* @malloc(i64 %37)
	%39 = getelementptr { i8*, i64 }, { i8*, i64 }* %27, i32 0, i32 0
	%40 = load i8*, i8** %39
	%41 = call i8* @strcat(i8* %38, i8* %40)
	%42 = getelementptr { i8*, i64 }, { i8*, i64 }* %29, i32 0, i32 0
	%43 = load i8*, i8** %42
	%44 = call i8* @strcat(i8* %38, i8* %43)
	%45 = alloca { i8*, i64 }
	%46 = getelementptr { i8*, i64 }, { i8*, i64 }* %45, i32 0, i32 0
	store i8* %38, i8** %46
	%47 = getelementptr { i8*, i64 }, { i8*, i64 }* %45, i32 0, i32 1
	store i64 %37, i64* %47
	store { i8*, i64 }* %45, { i8*, i64 }** %12
	br label %48

48:
	%49 = load { i8*, i64 }*, { i8*, i64 }** %12
	%50 = alloca [1 x i8]
	store [1 x i8] c"\00", [1 x i8]* %50
	%51 = alloca { i8*, i64 }
	%52 = getelementptr [1 x i8], [1 x i8]* %50, i32 0, i32 0
	%53 = getelementptr { i8*, i64 }, { i8*, i64 }* %51, i32 0, i32 0
	store i8* %52, i8** %53
	%54 = getelementptr { i8*, i64 }, { i8*, i64 }* %51, i32 0, i32 1
	store i64 1, i64* %54
	%55 = getelementptr { i8*, i64 }, { i8*, i64 }* %49, i32 0, i32 0
	%56 = load i8*, i8** %55
	%57 = getelementptr { i8*, i64 }, { i8*, i64 }* %51, i32 0, i32 0
	%58 = load i8*, i8** %57
	%59 = call i8 @strcmp(i8* %56, i8* %58)
	%60 = icmp eq i8 0, %59
	br i1 %60, label %61, label %94

61:
	%62 = load i64, i64* %1
	%63 = call i64 @intlen(i64 %62)
	%64 = call i8* @malloc(i64 %63)
	%65 = call i64 @itoa(i8* %64, i64 %62)
	%66 = alloca { i8*, i64 }
	%67 = getelementptr { i8*, i64 }, { i8*, i64 }* %66, i32 0, i32 0
	store i8* %64, i8** %67
	%68 = getelementptr { i8*, i64 }, { i8*, i64 }* %66, i32 0, i32 1
	store i64 %63, i64* %68
	%69 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %69
	%70 = alloca { i8*, i64 }
	%71 = getelementptr [2 x i8], [2 x i8]* %69, i32 0, i32 0
	%72 = getelementptr { i8*, i64 }, { i8*, i64 }* %70, i32 0, i32 0
	store i8* %71, i8** %72
	%73 = getelementptr { i8*, i64 }, { i8*, i64 }* %70, i32 0, i32 1
	store i64 2, i64* %73
	%74 = getelementptr { i8*, i64 }, { i8*, i64 }* %66, i32 0, i32 1
	%75 = load i64, i64* %74
	%76 = getelementptr { i8*, i64 }, { i8*, i64 }* %70, i32 0, i32 1
	%77 = load i64, i64* %76
	%78 = add i64 %75, %77
	%79 = call i8* @malloc(i64 %78)
	%80 = getelementptr { i8*, i64 }, { i8*, i64 }* %66, i32 0, i32 0
	%81 = load i8*, i8** %80
	%82 = call i8* @strcat(i8* %79, i8* %81)
	%83 = getelementptr { i8*, i64 }, { i8*, i64 }* %70, i32 0, i32 0
	%84 = load i8*, i8** %83
	%85 = call i8* @strcat(i8* %79, i8* %84)
	%86 = alloca { i8*, i64 }
	%87 = getelementptr { i8*, i64 }, { i8*, i64 }* %86, i32 0, i32 0
	store i8* %79, i8** %87
	%88 = getelementptr { i8*, i64 }, { i8*, i64 }* %86, i32 0, i32 1
	store i64 %78, i64* %88
	%89 = getelementptr { i8*, i64 }, { i8*, i64 }* %86, i32 0, i32 0
	%90 = load i8*, i8** %89
	call void @printf(i8* %90)
	br label %91

91:
	%92 = load i64, i64* %1
	%93 = icmp slt i64 %92, 100
	br i1 %93, label %4, label %118

94:
	%95 = load { i8*, i64 }*, { i8*, i64 }** %12
	%96 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %96
	%97 = alloca { i8*, i64 }
	%98 = getelementptr [2 x i8], [2 x i8]* %96, i32 0, i32 0
	%99 = getelementptr { i8*, i64 }, { i8*, i64 }* %97, i32 0, i32 0
	store i8* %98, i8** %99
	%100 = getelementptr { i8*, i64 }, { i8*, i64 }* %97, i32 0, i32 1
	store i64 2, i64* %100
	%101 = getelementptr { i8*, i64 }, { i8*, i64 }* %95, i32 0, i32 1
	%102 = load i64, i64* %101
	%103 = getelementptr { i8*, i64 }, { i8*, i64 }* %97, i32 0, i32 1
	%104 = load i64, i64* %103
	%105 = add i64 %102, %104
	%106 = call i8* @malloc(i64 %105)
	%107 = getelementptr { i8*, i64 }, { i8*, i64 }* %95, i32 0, i32 0
	%108 = load i8*, i8** %107
	%109 = call i8* @strcat(i8* %106, i8* %108)
	%110 = getelementptr { i8*, i64 }, { i8*, i64 }* %97, i32 0, i32 0
	%111 = load i8*, i8** %110
	%112 = call i8* @strcat(i8* %106, i8* %111)
	%113 = alloca { i8*, i64 }
	%114 = getelementptr { i8*, i64 }, { i8*, i64 }* %113, i32 0, i32 0
	store i8* %106, i8** %114
	%115 = getelementptr { i8*, i64 }, { i8*, i64 }* %113, i32 0, i32 1
	store i64 %105, i64* %115
	%116 = getelementptr { i8*, i64 }, { i8*, i64 }* %113, i32 0, i32 0
	%117 = load i8*, i8** %116
	call void @printf(i8* %117)
	br label %91

118:
	ret i32 0
}
