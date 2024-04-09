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
	store i64 1, i64* %1
	%2 = load i64, i64* %1
	%3 = icmp eq i64 %2, 0
	%4 = icmp eq i64 1, 0
	%5 = icmp eq i1 %3, %4
	%6 = alloca i1
	store i1 %5, i1* %6
	%7 = load i1, i1* %6
	%8 = call i64 @booltoint(i1 %7)
	%9 = call i64 @intlen(i64 %8)
	%10 = call i8* @malloc(i64 %9)
	%11 = call i64 @itoa(i8* %10, i64 %8)
	%12 = alloca { i8*, i64 }
	%13 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 0
	store i8* %10, i8** %13
	%14 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 1
	store i64 %9, i64* %14
	%15 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %15
	%16 = alloca { i8*, i64 }
	%17 = getelementptr [2 x i8], [2 x i8]* %15, i32 0, i32 0
	%18 = getelementptr { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 0
	store i8* %17, i8** %18
	%19 = getelementptr { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 1
	store i64 2, i64* %19
	%20 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 1
	%21 = load i64, i64* %20
	%22 = getelementptr { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 1
	%23 = load i64, i64* %22
	%24 = add i64 %21, %23
	%25 = call i8* @malloc(i64 %24)
	%26 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 0
	%27 = load i8*, i8** %26
	%28 = call i8* @strcat(i8* %25, i8* %27)
	%29 = getelementptr { i8*, i64 }, { i8*, i64 }* %16, i32 0, i32 0
	%30 = load i8*, i8** %29
	%31 = call i8* @strcat(i8* %25, i8* %30)
	%32 = alloca { i8*, i64 }
	%33 = getelementptr { i8*, i64 }, { i8*, i64 }* %32, i32 0, i32 0
	store i8* %25, i8** %33
	%34 = getelementptr { i8*, i64 }, { i8*, i64 }* %32, i32 0, i32 1
	store i64 %24, i64* %34
	%35 = getelementptr { i8*, i64 }, { i8*, i64 }* %32, i32 0, i32 0
	%36 = load i8*, i8** %35
	call void @printf(i8* %36)
	ret i32 0
}
