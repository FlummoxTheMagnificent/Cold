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
	%1 = alloca i64
	store i64 0, i64* %1
	%2 = load i64, i64* %1
	%3 = icmp slt i64 %2, 10
	br i1 %3, label %4, label %38

4:
	%5 = load i64, i64* %1
	%6 = call i64 @intlen(i64 %5)
	%7 = call i8* @malloc(i64 %6)
	%8 = call i64 @itoa(i8* %7, i64 %5)
	%9 = alloca { i8*, i64 }
	%10 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 0
	store i8* %7, i8** %10
	%11 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 1
	store i64 %6, i64* %11
	%12 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %12
	%13 = alloca { i8*, i64 }
	%14 = getelementptr [2 x i8], [2 x i8]* %12, i32 0, i32 0
	%15 = getelementptr { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 0
	store i8* %14, i8** %15
	%16 = getelementptr { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 1
	store i64 2, i64* %16
	%17 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 1
	%18 = load i64, i64* %17
	%19 = getelementptr { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 1
	%20 = load i64, i64* %19
	%21 = add i64 %18, %20
	%22 = call i8* @malloc(i64 %21)
	%23 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 0
	%24 = load i8*, i8** %23
	%25 = call i8* @strcat(i8* %22, i8* %24)
	%26 = getelementptr { i8*, i64 }, { i8*, i64 }* %13, i32 0, i32 0
	%27 = load i8*, i8** %26
	%28 = call i8* @strcat(i8* %22, i8* %27)
	%29 = alloca { i8*, i64 }
	%30 = getelementptr { i8*, i64 }, { i8*, i64 }* %29, i32 0, i32 0
	store i8* %22, i8** %30
	%31 = getelementptr { i8*, i64 }, { i8*, i64 }* %29, i32 0, i32 1
	store i64 %21, i64* %31
	%32 = getelementptr { i8*, i64 }, { i8*, i64 }* %29, i32 0, i32 0
	%33 = load i8*, i8** %32
	call void @printf(i8* %33)
	%34 = load i64, i64* %1
	%35 = add i64 %34, 1
	store i64 %35, i64* %1
	%36 = load i64, i64* %1
	%37 = icmp slt i64 %36, 10
	br i1 %37, label %4, label %38

38:
	ret i32 0
}
