declare void @printf(i8* %p1)

declare i8* @strcat(i8* %p1, i8* %p2)

declare i64 @intlen(i64 %p1)

declare i64 @itoa(i8* %p1, i64 %p2)

declare i64 @floatlen(float %p1)

declare i64 @ftoa(i8* %p1, float %p2)

declare i8* @malloc(i64 %p1)

declare i64 @booltoint(i1 %p1)

define i32 @main() {
0:
	%1 = fcmp olt float 0x3FF1999980000000, 0x3FF0041880000000
	br i1 %1, label %2, label %31

2:
	%3 = call i64 @intlen(i64 8)
	%4 = call i8* @malloc(i64 %3)
	%5 = call i64 @itoa(i8* %4, i64 8)
	%6 = alloca { i8*, i64 }
	%7 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 0
	store i8* %4, i8** %7
	%8 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 1
	store i64 %3, i64* %8
	%9 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %9
	%10 = alloca { i8*, i64 }
	%11 = getelementptr [2 x i8], [2 x i8]* %9, i32 0, i32 0
	%12 = getelementptr { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 0
	store i8* %11, i8** %12
	%13 = getelementptr { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 1
	store i64 2, i64* %13
	%14 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 1
	%15 = load i64, i64* %14
	%16 = getelementptr { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 1
	%17 = load i64, i64* %16
	%18 = add i64 %15, %17
	%19 = call i8* @malloc(i64 %18)
	%20 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 0
	%21 = load i8*, i8** %20
	%22 = call i8* @strcat(i8* %19, i8* %21)
	%23 = getelementptr { i8*, i64 }, { i8*, i64 }* %10, i32 0, i32 0
	%24 = load i8*, i8** %23
	%25 = call i8* @strcat(i8* %19, i8* %24)
	%26 = alloca { i8*, i64 }
	%27 = getelementptr { i8*, i64 }, { i8*, i64 }* %26, i32 0, i32 0
	store i8* %19, i8** %27
	%28 = getelementptr { i8*, i64 }, { i8*, i64 }* %26, i32 0, i32 1
	store i64 %18, i64* %28
	%29 = getelementptr { i8*, i64 }, { i8*, i64 }* %26, i32 0, i32 0
	%30 = load i8*, i8** %29
	call void @printf(i8* %30)
	br label %31

31:
	%32 = call i64 @intlen(i64 6)
	%33 = call i8* @malloc(i64 %32)
	%34 = call i64 @itoa(i8* %33, i64 6)
	%35 = alloca { i8*, i64 }
	%36 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 0
	store i8* %33, i8** %36
	%37 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 1
	store i64 %32, i64* %37
	%38 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %38
	%39 = alloca { i8*, i64 }
	%40 = getelementptr [2 x i8], [2 x i8]* %38, i32 0, i32 0
	%41 = getelementptr { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 0
	store i8* %40, i8** %41
	%42 = getelementptr { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 1
	store i64 2, i64* %42
	%43 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 1
	%44 = load i64, i64* %43
	%45 = getelementptr { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 1
	%46 = load i64, i64* %45
	%47 = add i64 %44, %46
	%48 = call i8* @malloc(i64 %47)
	%49 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 0
	%50 = load i8*, i8** %49
	%51 = call i8* @strcat(i8* %48, i8* %50)
	%52 = getelementptr { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 0
	%53 = load i8*, i8** %52
	%54 = call i8* @strcat(i8* %48, i8* %53)
	%55 = alloca { i8*, i64 }
	%56 = getelementptr { i8*, i64 }, { i8*, i64 }* %55, i32 0, i32 0
	store i8* %48, i8** %56
	%57 = getelementptr { i8*, i64 }, { i8*, i64 }* %55, i32 0, i32 1
	store i64 %47, i64* %57
	%58 = getelementptr { i8*, i64 }, { i8*, i64 }* %55, i32 0, i32 0
	%59 = load i8*, i8** %58
	call void @printf(i8* %59)
	ret i32 0
}
