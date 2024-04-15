declare void @printf(i8* %p1)

declare i8* @strcat(i8* %p1, i8* %p2)

declare i8 @strcmp(i8* %p1, i8* %p2)

declare i64 @intlen(i64 %p1)

declare i64 @itoa(i8* %p1, i64 %p2)

declare i64 @floatlen(float %p1)

declare i64 @ftoa(i8* %p1, float %p2)

declare i8* @malloc(i64 %p1)

declare i64 @booltoint(i1 %p1)

declare void @free(i8* %p1)

define i32 @main() {
0:
	%1 = alloca i64
	store i64 1, i64* %1
	%2 = load i64, i64* %1
	%3 = call i64 @intlen(i64 %2)
	%4 = call i8* @malloc(i64 %3)
	%5 = call i64 @itoa(i8* %4, i64 %2)
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
	%31 = bitcast i64* %1 to i8*
	call void @free(i8* %31)
	ret i32 0
}
