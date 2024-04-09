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
	%1 = icmp eq i64 1, 2
	br i1 %1, label %2, label %89

2:
	%3 = alloca [5 x i8]
	store [5 x i8] c"true\00", [5 x i8]* %3
	%4 = alloca { i8*, i64 }
	%5 = getelementptr [5 x i8], [5 x i8]* %3, i32 0, i32 0
	%6 = getelementptr { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 0
	store i8* %5, i8** %6
	%7 = getelementptr { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 1
	store i64 5, i64* %7
	%8 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %8
	%9 = alloca { i8*, i64 }
	%10 = getelementptr [2 x i8], [2 x i8]* %8, i32 0, i32 0
	%11 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 0
	store i8* %10, i8** %11
	%12 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 1
	store i64 2, i64* %12
	%13 = getelementptr { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 1
	%14 = load i64, i64* %13
	%15 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 1
	%16 = load i64, i64* %15
	%17 = add i64 %14, %16
	%18 = call i8* @malloc(i64 %17)
	%19 = getelementptr { i8*, i64 }, { i8*, i64 }* %4, i32 0, i32 0
	%20 = load i8*, i8** %19
	%21 = call i8* @strcat(i8* %18, i8* %20)
	%22 = getelementptr { i8*, i64 }, { i8*, i64 }* %9, i32 0, i32 0
	%23 = load i8*, i8** %22
	%24 = call i8* @strcat(i8* %18, i8* %23)
	%25 = alloca { i8*, i64 }
	%26 = getelementptr { i8*, i64 }, { i8*, i64 }* %25, i32 0, i32 0
	store i8* %18, i8** %26
	%27 = getelementptr { i8*, i64 }, { i8*, i64 }* %25, i32 0, i32 1
	store i64 %17, i64* %27
	%28 = getelementptr { i8*, i64 }, { i8*, i64 }* %25, i32 0, i32 0
	%29 = load i8*, i8** %28
	call void @printf(i8* %29)
	%30 = icmp eq i64 1, 2
	br i1 %30, label %32, label %61

31:
	ret i32 0

32:
	%33 = alloca [6 x i8]
	store [6 x i8] c"true1\00", [6 x i8]* %33
	%34 = alloca { i8*, i64 }
	%35 = getelementptr [6 x i8], [6 x i8]* %33, i32 0, i32 0
	%36 = getelementptr { i8*, i64 }, { i8*, i64 }* %34, i32 0, i32 0
	store i8* %35, i8** %36
	%37 = getelementptr { i8*, i64 }, { i8*, i64 }* %34, i32 0, i32 1
	store i64 6, i64* %37
	%38 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %38
	%39 = alloca { i8*, i64 }
	%40 = getelementptr [2 x i8], [2 x i8]* %38, i32 0, i32 0
	%41 = getelementptr { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 0
	store i8* %40, i8** %41
	%42 = getelementptr { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 1
	store i64 2, i64* %42
	%43 = getelementptr { i8*, i64 }, { i8*, i64 }* %34, i32 0, i32 1
	%44 = load i64, i64* %43
	%45 = getelementptr { i8*, i64 }, { i8*, i64 }* %39, i32 0, i32 1
	%46 = load i64, i64* %45
	%47 = add i64 %44, %46
	%48 = call i8* @malloc(i64 %47)
	%49 = getelementptr { i8*, i64 }, { i8*, i64 }* %34, i32 0, i32 0
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
	br label %60

60:
	br label %31

61:
	%62 = alloca [6 x i8]
	store [6 x i8] c"true2\00", [6 x i8]* %62
	%63 = alloca { i8*, i64 }
	%64 = getelementptr [6 x i8], [6 x i8]* %62, i32 0, i32 0
	%65 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 0
	store i8* %64, i8** %65
	%66 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 1
	store i64 6, i64* %66
	%67 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %67
	%68 = alloca { i8*, i64 }
	%69 = getelementptr [2 x i8], [2 x i8]* %67, i32 0, i32 0
	%70 = getelementptr { i8*, i64 }, { i8*, i64 }* %68, i32 0, i32 0
	store i8* %69, i8** %70
	%71 = getelementptr { i8*, i64 }, { i8*, i64 }* %68, i32 0, i32 1
	store i64 2, i64* %71
	%72 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 1
	%73 = load i64, i64* %72
	%74 = getelementptr { i8*, i64 }, { i8*, i64 }* %68, i32 0, i32 1
	%75 = load i64, i64* %74
	%76 = add i64 %73, %75
	%77 = call i8* @malloc(i64 %76)
	%78 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 0
	%79 = load i8*, i8** %78
	%80 = call i8* @strcat(i8* %77, i8* %79)
	%81 = getelementptr { i8*, i64 }, { i8*, i64 }* %68, i32 0, i32 0
	%82 = load i8*, i8** %81
	%83 = call i8* @strcat(i8* %77, i8* %82)
	%84 = alloca { i8*, i64 }
	%85 = getelementptr { i8*, i64 }, { i8*, i64 }* %84, i32 0, i32 0
	store i8* %77, i8** %85
	%86 = getelementptr { i8*, i64 }, { i8*, i64 }* %84, i32 0, i32 1
	store i64 %76, i64* %86
	%87 = getelementptr { i8*, i64 }, { i8*, i64 }* %84, i32 0, i32 0
	%88 = load i8*, i8** %87
	call void @printf(i8* %88)
	br label %60

89:
	%90 = alloca [6 x i8]
	store [6 x i8] c"false\00", [6 x i8]* %90
	%91 = alloca { i8*, i64 }
	%92 = getelementptr [6 x i8], [6 x i8]* %90, i32 0, i32 0
	%93 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 0
	store i8* %92, i8** %93
	%94 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 1
	store i64 6, i64* %94
	%95 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %95
	%96 = alloca { i8*, i64 }
	%97 = getelementptr [2 x i8], [2 x i8]* %95, i32 0, i32 0
	%98 = getelementptr { i8*, i64 }, { i8*, i64 }* %96, i32 0, i32 0
	store i8* %97, i8** %98
	%99 = getelementptr { i8*, i64 }, { i8*, i64 }* %96, i32 0, i32 1
	store i64 2, i64* %99
	%100 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 1
	%101 = load i64, i64* %100
	%102 = getelementptr { i8*, i64 }, { i8*, i64 }* %96, i32 0, i32 1
	%103 = load i64, i64* %102
	%104 = add i64 %101, %103
	%105 = call i8* @malloc(i64 %104)
	%106 = getelementptr { i8*, i64 }, { i8*, i64 }* %91, i32 0, i32 0
	%107 = load i8*, i8** %106
	%108 = call i8* @strcat(i8* %105, i8* %107)
	%109 = getelementptr { i8*, i64 }, { i8*, i64 }* %96, i32 0, i32 0
	%110 = load i8*, i8** %109
	%111 = call i8* @strcat(i8* %105, i8* %110)
	%112 = alloca { i8*, i64 }
	%113 = getelementptr { i8*, i64 }, { i8*, i64 }* %112, i32 0, i32 0
	store i8* %105, i8** %113
	%114 = getelementptr { i8*, i64 }, { i8*, i64 }* %112, i32 0, i32 1
	store i64 %104, i64* %114
	%115 = getelementptr { i8*, i64 }, { i8*, i64 }* %112, i32 0, i32 0
	%116 = load i8*, i8** %115
	call void @printf(i8* %116)
	%117 = icmp eq i64 1, 2
	br i1 %117, label %118, label %147

118:
	%119 = alloca [7 x i8]
	store [7 x i8] c"false1\00", [7 x i8]* %119
	%120 = alloca { i8*, i64 }
	%121 = getelementptr [7 x i8], [7 x i8]* %119, i32 0, i32 0
	%122 = getelementptr { i8*, i64 }, { i8*, i64 }* %120, i32 0, i32 0
	store i8* %121, i8** %122
	%123 = getelementptr { i8*, i64 }, { i8*, i64 }* %120, i32 0, i32 1
	store i64 7, i64* %123
	%124 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %124
	%125 = alloca { i8*, i64 }
	%126 = getelementptr [2 x i8], [2 x i8]* %124, i32 0, i32 0
	%127 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 0
	store i8* %126, i8** %127
	%128 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 1
	store i64 2, i64* %128
	%129 = getelementptr { i8*, i64 }, { i8*, i64 }* %120, i32 0, i32 1
	%130 = load i64, i64* %129
	%131 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 1
	%132 = load i64, i64* %131
	%133 = add i64 %130, %132
	%134 = call i8* @malloc(i64 %133)
	%135 = getelementptr { i8*, i64 }, { i8*, i64 }* %120, i32 0, i32 0
	%136 = load i8*, i8** %135
	%137 = call i8* @strcat(i8* %134, i8* %136)
	%138 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 0
	%139 = load i8*, i8** %138
	%140 = call i8* @strcat(i8* %134, i8* %139)
	%141 = alloca { i8*, i64 }
	%142 = getelementptr { i8*, i64 }, { i8*, i64 }* %141, i32 0, i32 0
	store i8* %134, i8** %142
	%143 = getelementptr { i8*, i64 }, { i8*, i64 }* %141, i32 0, i32 1
	store i64 %133, i64* %143
	%144 = getelementptr { i8*, i64 }, { i8*, i64 }* %141, i32 0, i32 0
	%145 = load i8*, i8** %144
	call void @printf(i8* %145)
	br label %146

146:
	br label %31

147:
	%148 = alloca [7 x i8]
	store [7 x i8] c"false2\00", [7 x i8]* %148
	%149 = alloca { i8*, i64 }
	%150 = getelementptr [7 x i8], [7 x i8]* %148, i32 0, i32 0
	%151 = getelementptr { i8*, i64 }, { i8*, i64 }* %149, i32 0, i32 0
	store i8* %150, i8** %151
	%152 = getelementptr { i8*, i64 }, { i8*, i64 }* %149, i32 0, i32 1
	store i64 7, i64* %152
	%153 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %153
	%154 = alloca { i8*, i64 }
	%155 = getelementptr [2 x i8], [2 x i8]* %153, i32 0, i32 0
	%156 = getelementptr { i8*, i64 }, { i8*, i64 }* %154, i32 0, i32 0
	store i8* %155, i8** %156
	%157 = getelementptr { i8*, i64 }, { i8*, i64 }* %154, i32 0, i32 1
	store i64 2, i64* %157
	%158 = getelementptr { i8*, i64 }, { i8*, i64 }* %149, i32 0, i32 1
	%159 = load i64, i64* %158
	%160 = getelementptr { i8*, i64 }, { i8*, i64 }* %154, i32 0, i32 1
	%161 = load i64, i64* %160
	%162 = add i64 %159, %161
	%163 = call i8* @malloc(i64 %162)
	%164 = getelementptr { i8*, i64 }, { i8*, i64 }* %149, i32 0, i32 0
	%165 = load i8*, i8** %164
	%166 = call i8* @strcat(i8* %163, i8* %165)
	%167 = getelementptr { i8*, i64 }, { i8*, i64 }* %154, i32 0, i32 0
	%168 = load i8*, i8** %167
	%169 = call i8* @strcat(i8* %163, i8* %168)
	%170 = alloca { i8*, i64 }
	%171 = getelementptr { i8*, i64 }, { i8*, i64 }* %170, i32 0, i32 0
	store i8* %163, i8** %171
	%172 = getelementptr { i8*, i64 }, { i8*, i64 }* %170, i32 0, i32 1
	store i64 %162, i64* %172
	%173 = getelementptr { i8*, i64 }, { i8*, i64 }* %170, i32 0, i32 0
	%174 = load i8*, i8** %173
	call void @printf(i8* %174)
	br label %146
}
