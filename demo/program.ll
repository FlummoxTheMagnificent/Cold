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
	%1 = call i64 @intlen(i64 1)
	%2 = call i8* @malloc(i64 %1)
	%3 = call i64 @itoa(i8* %2, i64 1)
	%4 = alloca { i8*, i64 }
	%5 = getelementptr { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 0
	store i8* %2, i8** %5
	%6 = getelementptr { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 1
	store i64 %1, i64* %6
	%7 = getelementptr { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 0
	%8 = load i8*, i8** %7
	call void @printf(i8* %8)
	%9 = icmp eq i64 1, 1
	br i1 %9, label %10, label %49

10:
	%11 = call i64 @intlen(i64 2)
	%12 = call i8* @malloc(i64 %11)
	%13 = call i64 @itoa(i8* %12, i64 2)
	%14 = alloca { i8*, i64 }
	%15 = getelementptr { i8*, i64 }, { i8*, i64 }* %14, i32 0, i32 0
	store i8* %12, i8** %15
	%16 = getelementptr { i8*, i64 }, { i8*, i64 }* %14, i32 0, i32 1
	store i64 %11, i64* %16
	%17 = getelementptr { i8*, i64 }, { i8*, i64 }* %14, i32 0, i32 0
	%18 = load i8*, i8** %17
	call void @printf(i8* %18)
	%19 = icmp eq i64 1, 1
	br i1 %19, label %20, label %29

20:
	%21 = call i64 @intlen(i64 3)
	%22 = call i8* @malloc(i64 %21)
	%23 = call i64 @itoa(i8* %22, i64 3)
	%24 = alloca { i8*, i64 }
	%25 = getelementptr { i8*, i64 }, { i8*, i64 }* %24, i32 0, i32 0
	store i8* %22, i8** %25
	%26 = getelementptr { i8*, i64 }, { i8*, i64 }* %24, i32 0, i32 1
	store i64 %21, i64* %26
	%27 = getelementptr { i8*, i64 }, { i8*, i64 }* %24, i32 0, i32 0
	%28 = load i8*, i8** %27
	call void @printf(i8* %28)
	br label %29

29:
	%30 = icmp eq i64 5, 5
	br i1 %30, label %31, label %40

31:
	%32 = call i64 @intlen(i64 4)
	%33 = call i8* @malloc(i64 %32)
	%34 = call i64 @itoa(i8* %33, i64 4)
	%35 = alloca { i8*, i64 }
	%36 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 0
	store i8* %33, i8** %36
	%37 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 1
	store i64 %32, i64* %37
	%38 = getelementptr { i8*, i64 }, { i8*, i64 }* %35, i32 0, i32 0
	%39 = load i8*, i8** %38
	call void @printf(i8* %39)
	br label %40

40:
	%41 = call i64 @intlen(i64 5)
	%42 = call i8* @malloc(i64 %41)
	%43 = call i64 @itoa(i8* %42, i64 5)
	%44 = alloca { i8*, i64 }
	%45 = getelementptr { i8*, i64 }, { i8*, i64 }* %44, i32 0, i32 0
	store i8* %42, i8** %45
	%46 = getelementptr { i8*, i64 }, { i8*, i64 }* %44, i32 0, i32 1
	store i64 %41, i64* %46
	%47 = getelementptr { i8*, i64 }, { i8*, i64 }* %44, i32 0, i32 0
	%48 = load i8*, i8** %47
	call void @printf(i8* %48)
	br label %49

49:
	%50 = call i64 @intlen(i64 6)
	%51 = call i8* @malloc(i64 %50)
	%52 = call i64 @itoa(i8* %51, i64 6)
	%53 = alloca { i8*, i64 }
	%54 = getelementptr { i8*, i64 }, { i8*, i64 }* %53, i32 0, i32 0
	store i8* %51, i8** %54
	%55 = getelementptr { i8*, i64 }, { i8*, i64 }* %53, i32 0, i32 1
	store i64 %50, i64* %55
	%56 = getelementptr { i8*, i64 }, { i8*, i64 }* %53, i32 0, i32 0
	%57 = load i8*, i8** %56
	call void @printf(i8* %57)
	ret i32 0
}
