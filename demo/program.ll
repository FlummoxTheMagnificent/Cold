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
	br i1 %3, label %4, label %127

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
	br i1 %15, label %16, label %38

16:
	%17 = load { i8*, i64 }*, { i8*, i64 }** %12
	%18 = alloca [5 x i8]
	store [5 x i8] c"Fizz\00", [5 x i8]* %18
	%19 = alloca { i8*, i64 }
	%20 = getelementptr [5 x i8], [5 x i8]* %18, i32 0, i32 0
	%21 = getelementptr { i8*, i64 }, { i8*, i64 }* %19, i32 0, i32 0
	store i8* %20, i8** %21
	%22 = getelementptr { i8*, i64 }, { i8*, i64 }* %19, i32 0, i32 1
	store i64 5, i64* %22
	%23 = getelementptr { i8*, i64 }, { i8*, i64 }* %17, i32 0, i32 1
	%24 = load i64, i64* %23
	%25 = getelementptr { i8*, i64 }, { i8*, i64 }* %19, i32 0, i32 1
	%26 = load i64, i64* %25
	%27 = add i64 %24, %26
	%28 = call i8* @malloc(i64 %27)
	%29 = getelementptr { i8*, i64 }, { i8*, i64 }* %17, i32 0, i32 0
	%30 = load i8*, i8** %29
	%31 = call i8* @strcat(i8* %28, i8* %30)
	%32 = getelementptr { i8*, i64 }, { i8*, i64 }* %19, i32 0, i32 0
	%33 = load i8*, i8** %32
	%34 = call i8* @strcat(i8* %28, i8* %33)
	%35 = alloca { i8*, i64 }
	%36 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 0
	store i8* %28, i8** %36
	%37 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 1
	store i64 %27, i64* %37
	store { i8*, i64 }* %35, { i8*, i64 }** %12
	br label %38

38:
	%39 = load i64, i64* %1
	%40 = srem i64 %39, 5
	%41 = icmp eq i64 %40, 0
	br i1 %41, label %42, label %64

42:
	%43 = load { i8*, i64 }*, { i8*, i64 }** %12
	%44 = alloca [5 x i8]
	store [5 x i8] c"Buzz\00", [5 x i8]* %44
	%45 = alloca { i8*, i64 }
	%46 = getelementptr [5 x i8], [5 x i8]* %44, i32 0, i32 0
	%47 = getelementptr { i8*, i64 }, { i8*, i64 }* %45, i32 0, i32 0
	store i8* %46, i8** %47
	%48 = getelementptr { i8*, i64 }, { i8*, i64 }* %45, i32 0, i32 1
	store i64 5, i64* %48
	%49 = getelementptr { i8*, i64 }, { i8*, i64 }* %43, i32 0, i32 1
	%50 = load i64, i64* %49
	%51 = getelementptr { i8*, i64 }, { i8*, i64 }* %45, i32 0, i32 1
	%52 = load i64, i64* %51
	%53 = add i64 %50, %52
	%54 = call i8* @malloc(i64 %53)
	%55 = getelementptr { i8*, i64 }, { i8*, i64 }* %43, i32 0, i32 0
	%56 = load i8*, i8** %55
	%57 = call i8* @strcat(i8* %54, i8* %56)
	%58 = getelementptr { i8*, i64 }, { i8*, i64 }* %45, i32 0, i32 0
	%59 = load i8*, i8** %58
	%60 = call i8* @strcat(i8* %54, i8* %59)
	%61 = alloca { i8*, i64 }
	%62 = getelementptr { i8*, i64 }, { i8*, i64 }* %61, i32 0, i32 0
	store i8* %54, i8** %62
	%63 = getelementptr { i8*, i64 }, { i8*, i64 }* %61, i32 0, i32 1
	store i64 %53, i64* %63
	store { i8*, i64 }* %61, { i8*, i64 }** %12
	br label %64

64:
	%65 = load { i8*, i64 }*, { i8*, i64 }** %12
	%66 = alloca [1 x i8]
	store [1 x i8] c"\00", [1 x i8]* %66
	%67 = alloca { i8*, i64 }
	%68 = getelementptr [1 x i8], [1 x i8]* %66, i32 0, i32 0
	%69 = getelementptr { i8*, i64 }, { i8*, i64 }* %67, i32 0, i32 0
	store i8* %68, i8** %69
	%70 = getelementptr { i8*, i64 }, { i8*, i64 }* %67, i32 0, i32 1
	store i64 1, i64* %70
	%71 = getelementptr { i8*, i64 }, { i8*, i64 }* %65, i32 0, i32 0
	%72 = load i8*, i8** %71
	%73 = getelementptr { i8*, i64 }, { i8*, i64 }* %67, i32 0, i32 0
	%74 = load i8*, i8** %73
	%75 = call i8 @strcmp(i8* %72, i8* %74)
	%76 = icmp eq i8 0, %75
	br i1 %76, label %77, label %101

77:
	%78 = load { i8*, i64 }*, { i8*, i64 }** %12
	%79 = load i64, i64* %1
	%80 = call i64 @intlen(i64 %79)
	%81 = call i8* @malloc(i64 %80)
	%82 = call i64 @itoa(i8* %81, i64 %79)
	%83 = alloca { i8*, i64 }
	%84 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 0
	store i8* %81, i8** %84
	%85 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 1
	store i64 %80, i64* %85
	%86 = getelementptr { i8*, i64 }, { i8*, i64 }* %78, i32 0, i32 1
	%87 = load i64, i64* %86
	%88 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 1
	%89 = load i64, i64* %88
	%90 = add i64 %87, %89
	%91 = call i8* @malloc(i64 %90)
	%92 = getelementptr { i8*, i64 }, { i8*, i64 }* %78, i32 0, i32 0
	%93 = load i8*, i8** %92
	%94 = call i8* @strcat(i8* %91, i8* %93)
	%95 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 0
	%96 = load i8*, i8** %95
	%97 = call i8* @strcat(i8* %91, i8* %96)
	%98 = alloca { i8*, i64 }
	%99 = getelementptr { i8*, i64 }, { i8*, i64 }* %98, i32 0, i32 0
	store i8* %91, i8** %99
	%100 = getelementptr { i8*, i64 }, { i8*, i64 }* %98, i32 0, i32 1
	store i64 %90, i64* %100
	store { i8*, i64 }* %98, { i8*, i64 }** %12
	br label %101

101:
	%102 = load { i8*, i64 }*, { i8*, i64 }** %12
	%103 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %103
	%104 = alloca { i8*, i64 }
	%105 = getelementptr [2 x i8], [2 x i8]* %103, i32 0, i32 0
	%106 = getelementptr { i8*, i64 }, { i8*, i64 }* %104, i32 0, i32 0
	store i8* %105, i8** %106
	%107 = getelementptr { i8*, i64 }, { i8*, i64 }* %104, i32 0, i32 1
	store i64 2, i64* %107
	%108 = getelementptr { i8*, i64 }, { i8*, i64 }* %102, i32 0, i32 1
	%109 = load i64, i64* %108
	%110 = getelementptr { i8*, i64 }, { i8*, i64 }* %104, i32 0, i32 1
	%111 = load i64, i64* %110
	%112 = add i64 %109, %111
	%113 = call i8* @malloc(i64 %112)
	%114 = getelementptr { i8*, i64 }, { i8*, i64 }* %102, i32 0, i32 0
	%115 = load i8*, i8** %114
	%116 = call i8* @strcat(i8* %113, i8* %115)
	%117 = getelementptr { i8*, i64 }, { i8*, i64 }* %104, i32 0, i32 0
	%118 = load i8*, i8** %117
	%119 = call i8* @strcat(i8* %113, i8* %118)
	%120 = alloca { i8*, i64 }
	%121 = getelementptr { i8*, i64 }, { i8*, i64 }* %120, i32 0, i32 0
	store i8* %113, i8** %121
	%122 = getelementptr { i8*, i64 }, { i8*, i64 }* %120, i32 0, i32 1
	store i64 %112, i64* %122
	%123 = getelementptr { i8*, i64 }, { i8*, i64 }* %120, i32 0, i32 0
	%124 = load i8*, i8** %123
	call void @printf(i8* %124)
	%125 = load i64, i64* %1
	%126 = icmp slt i64 %125, 100
	br i1 %126, label %4, label %127

127:
	ret i32 0
}
