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
	%3 = icmp eq i64 %2, 2
	br i1 %3, label %4, label %91

4:
	%5 = alloca [5 x i8]
	store [5 x i8] c"true\00", [5 x i8]* %5
	%6 = alloca { i8*, i64 }
	%7 = getelementptr [5 x i8], [5 x i8]* %5, i32 0, i32 0
	%8 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 0
	store i8* %7, i8** %8
	%9 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 1
	store i64 5, i64* %9
	%10 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %10
	%11 = alloca { i8*, i64 }
	%12 = getelementptr [2 x i8], [2 x i8]* %10, i32 0, i32 0
	%13 = getelementptr { i8*, i64 }, { i8*, i64 }* %11, i32 0, i32 0
	store i8* %12, i8** %13
	%14 = getelementptr { i8*, i64 }, { i8*, i64 }* %11, i32 0, i32 1
	store i64 2, i64* %14
	%15 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 1
	%16 = load i64, i64* %15
	%17 = getelementptr { i8*, i64 }, { i8*, i64 }* %11, i32 0, i32 1
	%18 = load i64, i64* %17
	%19 = add i64 %16, %18
	%20 = call i8* @malloc(i64 %19)
	%21 = getelementptr { i8*, i64 }, { i8*, i64 }* %6, i32 0, i32 0
	%22 = load i8*, i8** %21
	%23 = call i8* @strcat(i8* %20, i8* %22)
	%24 = getelementptr { i8*, i64 }, { i8*, i64 }* %11, i32 0, i32 0
	%25 = load i8*, i8** %24
	%26 = call i8* @strcat(i8* %20, i8* %25)
	%27 = alloca { i8*, i64 }
	%28 = getelementptr { i8*, i64 }, { i8*, i64 }* %27, i32 0, i32 0
	store i8* %20, i8** %28
	%29 = getelementptr { i8*, i64 }, { i8*, i64 }* %27, i32 0, i32 1
	store i64 %19, i64* %29
	%30 = getelementptr { i8*, i64 }, { i8*, i64 }* %27, i32 0, i32 0
	%31 = load i8*, i8** %30
	call void @printf(i8* %31)
	%32 = icmp eq i64 1, 2
	br i1 %32, label %34, label %63

33:
	ret i32 0

34:
	%35 = alloca [9 x i8]
	store [9 x i8] c"truetrue\00", [9 x i8]* %35
	%36 = alloca { i8*, i64 }
	%37 = getelementptr [9 x i8], [9 x i8]* %35, i32 0, i32 0
	%38 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 0
	store i8* %37, i8** %38
	%39 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 1
	store i64 9, i64* %39
	%40 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %40
	%41 = alloca { i8*, i64 }
	%42 = getelementptr [2 x i8], [2 x i8]* %40, i32 0, i32 0
	%43 = getelementptr { i8*, i64 }, { i8*, i64 }* %41, i32 0, i32 0
	store i8* %42, i8** %43
	%44 = getelementptr { i8*, i64 }, { i8*, i64 }* %41, i32 0, i32 1
	store i64 2, i64* %44
	%45 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 1
	%46 = load i64, i64* %45
	%47 = getelementptr { i8*, i64 }, { i8*, i64 }* %41, i32 0, i32 1
	%48 = load i64, i64* %47
	%49 = add i64 %46, %48
	%50 = call i8* @malloc(i64 %49)
	%51 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 0
	%52 = load i8*, i8** %51
	%53 = call i8* @strcat(i8* %50, i8* %52)
	%54 = getelementptr { i8*, i64 }, { i8*, i64 }* %41, i32 0, i32 0
	%55 = load i8*, i8** %54
	%56 = call i8* @strcat(i8* %50, i8* %55)
	%57 = alloca { i8*, i64 }
	%58 = getelementptr { i8*, i64 }, { i8*, i64 }* %57, i32 0, i32 0
	store i8* %50, i8** %58
	%59 = getelementptr { i8*, i64 }, { i8*, i64 }* %57, i32 0, i32 1
	store i64 %49, i64* %59
	%60 = getelementptr { i8*, i64 }, { i8*, i64 }* %57, i32 0, i32 0
	%61 = load i8*, i8** %60
	call void @printf(i8* %61)
	br label %62

62:
	br label %33

63:
	%64 = alloca [10 x i8]
	store [10 x i8] c"truefalse\00", [10 x i8]* %64
	%65 = alloca { i8*, i64 }
	%66 = getelementptr [10 x i8], [10 x i8]* %64, i32 0, i32 0
	%67 = getelementptr { i8*, i64 }, { i8*, i64 }* %65, i32 0, i32 0
	store i8* %66, i8** %67
	%68 = getelementptr { i8*, i64 }, { i8*, i64 }* %65, i32 0, i32 1
	store i64 10, i64* %68
	%69 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %69
	%70 = alloca { i8*, i64 }
	%71 = getelementptr [2 x i8], [2 x i8]* %69, i32 0, i32 0
	%72 = getelementptr { i8*, i64 }, { i8*, i64 }* %70, i32 0, i32 0
	store i8* %71, i8** %72
	%73 = getelementptr { i8*, i64 }, { i8*, i64 }* %70, i32 0, i32 1
	store i64 2, i64* %73
	%74 = getelementptr { i8*, i64 }, { i8*, i64 }* %65, i32 0, i32 1
	%75 = load i64, i64* %74
	%76 = getelementptr { i8*, i64 }, { i8*, i64 }* %70, i32 0, i32 1
	%77 = load i64, i64* %76
	%78 = add i64 %75, %77
	%79 = call i8* @malloc(i64 %78)
	%80 = getelementptr { i8*, i64 }, { i8*, i64 }* %65, i32 0, i32 0
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
	br label %62

91:
	%92 = load i64, i64* %1
	%93 = alloca i64
	store i64 %92, i64* %93
	%94 = alloca [6 x i8]
	store [6 x i8] c"false\00", [6 x i8]* %94
	%95 = alloca { i8*, i64 }
	%96 = getelementptr [6 x i8], [6 x i8]* %94, i32 0, i32 0
	%97 = getelementptr { i8*, i64 }, { i8*, i64 }* %95, i32 0, i32 0
	store i8* %96, i8** %97
	%98 = getelementptr { i8*, i64 }, { i8*, i64 }* %95, i32 0, i32 1
	store i64 6, i64* %98
	%99 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %99
	%100 = alloca { i8*, i64 }
	%101 = getelementptr [2 x i8], [2 x i8]* %99, i32 0, i32 0
	%102 = getelementptr { i8*, i64 }, { i8*, i64 }* %100, i32 0, i32 0
	store i8* %101, i8** %102
	%103 = getelementptr { i8*, i64 }, { i8*, i64 }* %100, i32 0, i32 1
	store i64 2, i64* %103
	%104 = getelementptr { i8*, i64 }, { i8*, i64 }* %95, i32 0, i32 1
	%105 = load i64, i64* %104
	%106 = getelementptr { i8*, i64 }, { i8*, i64 }* %100, i32 0, i32 1
	%107 = load i64, i64* %106
	%108 = add i64 %105, %107
	%109 = call i8* @malloc(i64 %108)
	%110 = getelementptr { i8*, i64 }, { i8*, i64 }* %95, i32 0, i32 0
	%111 = load i8*, i8** %110
	%112 = call i8* @strcat(i8* %109, i8* %111)
	%113 = getelementptr { i8*, i64 }, { i8*, i64 }* %100, i32 0, i32 0
	%114 = load i8*, i8** %113
	%115 = call i8* @strcat(i8* %109, i8* %114)
	%116 = alloca { i8*, i64 }
	%117 = getelementptr { i8*, i64 }, { i8*, i64 }* %116, i32 0, i32 0
	store i8* %109, i8** %117
	%118 = getelementptr { i8*, i64 }, { i8*, i64 }* %116, i32 0, i32 1
	store i64 %108, i64* %118
	%119 = getelementptr { i8*, i64 }, { i8*, i64 }* %116, i32 0, i32 0
	%120 = load i8*, i8** %119
	call void @printf(i8* %120)
	%121 = load i64, i64* %93
	%122 = icmp eq i64 1, %121
	br i1 %122, label %123, label %183

123:
	%124 = alloca [10 x i8]
	store [10 x i8] c"falsetrue\00", [10 x i8]* %124
	%125 = alloca { i8*, i64 }
	%126 = getelementptr [10 x i8], [10 x i8]* %124, i32 0, i32 0
	%127 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 0
	store i8* %126, i8** %127
	%128 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 1
	store i64 10, i64* %128
	%129 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %129
	%130 = alloca { i8*, i64 }
	%131 = getelementptr [2 x i8], [2 x i8]* %129, i32 0, i32 0
	%132 = getelementptr { i8*, i64 }, { i8*, i64 }* %130, i32 0, i32 0
	store i8* %131, i8** %132
	%133 = getelementptr { i8*, i64 }, { i8*, i64 }* %130, i32 0, i32 1
	store i64 2, i64* %133
	%134 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 1
	%135 = load i64, i64* %134
	%136 = getelementptr { i8*, i64 }, { i8*, i64 }* %130, i32 0, i32 1
	%137 = load i64, i64* %136
	%138 = add i64 %135, %137
	%139 = call i8* @malloc(i64 %138)
	%140 = getelementptr { i8*, i64 }, { i8*, i64 }* %125, i32 0, i32 0
	%141 = load i8*, i8** %140
	%142 = call i8* @strcat(i8* %139, i8* %141)
	%143 = getelementptr { i8*, i64 }, { i8*, i64 }* %130, i32 0, i32 0
	%144 = load i8*, i8** %143
	%145 = call i8* @strcat(i8* %139, i8* %144)
	%146 = alloca { i8*, i64 }
	%147 = getelementptr { i8*, i64 }, { i8*, i64 }* %146, i32 0, i32 0
	store i8* %139, i8** %147
	%148 = getelementptr { i8*, i64 }, { i8*, i64 }* %146, i32 0, i32 1
	store i64 %138, i64* %148
	%149 = getelementptr { i8*, i64 }, { i8*, i64 }* %146, i32 0, i32 0
	%150 = load i8*, i8** %149
	call void @printf(i8* %150)
	br label %151

151:
	%152 = load i64, i64* %93
	%153 = mul i64 %152, 6
	store i64 %153, i64* %93
	%154 = load i64, i64* %93
	%155 = call i64 @intlen(i64 %154)
	%156 = call i8* @malloc(i64 %155)
	%157 = call i64 @itoa(i8* %156, i64 %154)
	%158 = alloca { i8*, i64 }
	%159 = getelementptr { i8*, i64 }, { i8*, i64 }* %158, i32 0, i32 0
	store i8* %156, i8** %159
	%160 = getelementptr { i8*, i64 }, { i8*, i64 }* %158, i32 0, i32 1
	store i64 %155, i64* %160
	%161 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %161
	%162 = alloca { i8*, i64 }
	%163 = getelementptr [2 x i8], [2 x i8]* %161, i32 0, i32 0
	%164 = getelementptr { i8*, i64 }, { i8*, i64 }* %162, i32 0, i32 0
	store i8* %163, i8** %164
	%165 = getelementptr { i8*, i64 }, { i8*, i64 }* %162, i32 0, i32 1
	store i64 2, i64* %165
	%166 = getelementptr { i8*, i64 }, { i8*, i64 }* %158, i32 0, i32 1
	%167 = load i64, i64* %166
	%168 = getelementptr { i8*, i64 }, { i8*, i64 }* %162, i32 0, i32 1
	%169 = load i64, i64* %168
	%170 = add i64 %167, %169
	%171 = call i8* @malloc(i64 %170)
	%172 = getelementptr { i8*, i64 }, { i8*, i64 }* %158, i32 0, i32 0
	%173 = load i8*, i8** %172
	%174 = call i8* @strcat(i8* %171, i8* %173)
	%175 = getelementptr { i8*, i64 }, { i8*, i64 }* %162, i32 0, i32 0
	%176 = load i8*, i8** %175
	%177 = call i8* @strcat(i8* %171, i8* %176)
	%178 = alloca { i8*, i64 }
	%179 = getelementptr { i8*, i64 }, { i8*, i64 }* %178, i32 0, i32 0
	store i8* %171, i8** %179
	%180 = getelementptr { i8*, i64 }, { i8*, i64 }* %178, i32 0, i32 1
	store i64 %170, i64* %180
	%181 = getelementptr { i8*, i64 }, { i8*, i64 }* %178, i32 0, i32 0
	%182 = load i8*, i8** %181
	call void @printf(i8* %182)
	br label %33

183:
	%184 = alloca [11 x i8]
	store [11 x i8] c"falsefalse\00", [11 x i8]* %184
	%185 = alloca { i8*, i64 }
	%186 = getelementptr [11 x i8], [11 x i8]* %184, i32 0, i32 0
	%187 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 0
	store i8* %186, i8** %187
	%188 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 1
	store i64 11, i64* %188
	%189 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %189
	%190 = alloca { i8*, i64 }
	%191 = getelementptr [2 x i8], [2 x i8]* %189, i32 0, i32 0
	%192 = getelementptr { i8*, i64 }, { i8*, i64 }* %190, i32 0, i32 0
	store i8* %191, i8** %192
	%193 = getelementptr { i8*, i64 }, { i8*, i64 }* %190, i32 0, i32 1
	store i64 2, i64* %193
	%194 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 1
	%195 = load i64, i64* %194
	%196 = getelementptr { i8*, i64 }, { i8*, i64 }* %190, i32 0, i32 1
	%197 = load i64, i64* %196
	%198 = add i64 %195, %197
	%199 = call i8* @malloc(i64 %198)
	%200 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 0
	%201 = load i8*, i8** %200
	%202 = call i8* @strcat(i8* %199, i8* %201)
	%203 = getelementptr { i8*, i64 }, { i8*, i64 }* %190, i32 0, i32 0
	%204 = load i8*, i8** %203
	%205 = call i8* @strcat(i8* %199, i8* %204)
	%206 = alloca { i8*, i64 }
	%207 = getelementptr { i8*, i64 }, { i8*, i64 }* %206, i32 0, i32 0
	store i8* %199, i8** %207
	%208 = getelementptr { i8*, i64 }, { i8*, i64 }* %206, i32 0, i32 1
	store i64 %198, i64* %208
	%209 = getelementptr { i8*, i64 }, { i8*, i64 }* %206, i32 0, i32 0
	%210 = load i8*, i8** %209
	call void @printf(i8* %210)
	br label %151
}
