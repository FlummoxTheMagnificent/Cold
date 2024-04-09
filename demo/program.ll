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
	%33 = alloca [9 x i8]
	store [9 x i8] c"truetrue\00", [9 x i8]* %33
	%34 = alloca { i8*, i64 }
	%35 = getelementptr [9 x i8], [9 x i8]* %33, i32 0, i32 0
	%36 = getelementptr { i8*, i64 }, { i8*, i64 }* %34, i32 0, i32 0
	store i8* %35, i8** %36
	%37 = getelementptr { i8*, i64 }, { i8*, i64 }* %34, i32 0, i32 1
	store i64 9, i64* %37
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
	%62 = alloca [10 x i8]
	store [10 x i8] c"truefalse\00", [10 x i8]* %62
	%63 = alloca { i8*, i64 }
	%64 = getelementptr [10 x i8], [10 x i8]* %62, i32 0, i32 0
	%65 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 0
	store i8* %64, i8** %65
	%66 = getelementptr { i8*, i64 }, { i8*, i64 }* %63, i32 0, i32 1
	store i64 10, i64* %66
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
	%90 = alloca i64
	store i64 1, i64* %90
	%91 = alloca [6 x i8]
	store [6 x i8] c"false\00", [6 x i8]* %91
	%92 = alloca { i8*, i64 }
	%93 = getelementptr [6 x i8], [6 x i8]* %91, i32 0, i32 0
	%94 = getelementptr { i8*, i64 }, { i8*, i64 }* %92, i32 0, i32 0
	store i8* %93, i8** %94
	%95 = getelementptr { i8*, i64 }, { i8*, i64 }* %92, i32 0, i32 1
	store i64 6, i64* %95
	%96 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %96
	%97 = alloca { i8*, i64 }
	%98 = getelementptr [2 x i8], [2 x i8]* %96, i32 0, i32 0
	%99 = getelementptr { i8*, i64 }, { i8*, i64 }* %97, i32 0, i32 0
	store i8* %98, i8** %99
	%100 = getelementptr { i8*, i64 }, { i8*, i64 }* %97, i32 0, i32 1
	store i64 2, i64* %100
	%101 = getelementptr { i8*, i64 }, { i8*, i64 }* %92, i32 0, i32 1
	%102 = load i64, i64* %101
	%103 = getelementptr { i8*, i64 }, { i8*, i64 }* %97, i32 0, i32 1
	%104 = load i64, i64* %103
	%105 = add i64 %102, %104
	%106 = call i8* @malloc(i64 %105)
	%107 = getelementptr { i8*, i64 }, { i8*, i64 }* %92, i32 0, i32 0
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
	%118 = load i64, i64* %90
	%119 = icmp eq i64 1, %118
	br i1 %119, label %120, label %180

120:
	%121 = alloca [10 x i8]
	store [10 x i8] c"falsetrue\00", [10 x i8]* %121
	%122 = alloca { i8*, i64 }
	%123 = getelementptr [10 x i8], [10 x i8]* %121, i32 0, i32 0
	%124 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 0
	store i8* %123, i8** %124
	%125 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 1
	store i64 10, i64* %125
	%126 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %126
	%127 = alloca { i8*, i64 }
	%128 = getelementptr [2 x i8], [2 x i8]* %126, i32 0, i32 0
	%129 = getelementptr { i8*, i64 }, { i8*, i64 }* %127, i32 0, i32 0
	store i8* %128, i8** %129
	%130 = getelementptr { i8*, i64 }, { i8*, i64 }* %127, i32 0, i32 1
	store i64 2, i64* %130
	%131 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 1
	%132 = load i64, i64* %131
	%133 = getelementptr { i8*, i64 }, { i8*, i64 }* %127, i32 0, i32 1
	%134 = load i64, i64* %133
	%135 = add i64 %132, %134
	%136 = call i8* @malloc(i64 %135)
	%137 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 0
	%138 = load i8*, i8** %137
	%139 = call i8* @strcat(i8* %136, i8* %138)
	%140 = getelementptr { i8*, i64 }, { i8*, i64 }* %127, i32 0, i32 0
	%141 = load i8*, i8** %140
	%142 = call i8* @strcat(i8* %136, i8* %141)
	%143 = alloca { i8*, i64 }
	%144 = getelementptr { i8*, i64 }, { i8*, i64 }* %143, i32 0, i32 0
	store i8* %136, i8** %144
	%145 = getelementptr { i8*, i64 }, { i8*, i64 }* %143, i32 0, i32 1
	store i64 %135, i64* %145
	%146 = getelementptr { i8*, i64 }, { i8*, i64 }* %143, i32 0, i32 0
	%147 = load i8*, i8** %146
	call void @printf(i8* %147)
	br label %148

148:
	%149 = load i64, i64* %90
	%150 = mul i64 %149, 6
	store i64 %150, i64* %90
	%151 = load i64, i64* %90
	%152 = call i64 @intlen(i64 %151)
	%153 = call i8* @malloc(i64 %152)
	%154 = call i64 @itoa(i8* %153, i64 %151)
	%155 = alloca { i8*, i64 }
	%156 = getelementptr { i8*, i64 }, { i8*, i64 }* %155, i32 0, i32 0
	store i8* %153, i8** %156
	%157 = getelementptr { i8*, i64 }, { i8*, i64 }* %155, i32 0, i32 1
	store i64 %152, i64* %157
	%158 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %158
	%159 = alloca { i8*, i64 }
	%160 = getelementptr [2 x i8], [2 x i8]* %158, i32 0, i32 0
	%161 = getelementptr { i8*, i64 }, { i8*, i64 }* %159, i32 0, i32 0
	store i8* %160, i8** %161
	%162 = getelementptr { i8*, i64 }, { i8*, i64 }* %159, i32 0, i32 1
	store i64 2, i64* %162
	%163 = getelementptr { i8*, i64 }, { i8*, i64 }* %155, i32 0, i32 1
	%164 = load i64, i64* %163
	%165 = getelementptr { i8*, i64 }, { i8*, i64 }* %159, i32 0, i32 1
	%166 = load i64, i64* %165
	%167 = add i64 %164, %166
	%168 = call i8* @malloc(i64 %167)
	%169 = getelementptr { i8*, i64 }, { i8*, i64 }* %155, i32 0, i32 0
	%170 = load i8*, i8** %169
	%171 = call i8* @strcat(i8* %168, i8* %170)
	%172 = getelementptr { i8*, i64 }, { i8*, i64 }* %159, i32 0, i32 0
	%173 = load i8*, i8** %172
	%174 = call i8* @strcat(i8* %168, i8* %173)
	%175 = alloca { i8*, i64 }
	%176 = getelementptr { i8*, i64 }, { i8*, i64 }* %175, i32 0, i32 0
	store i8* %168, i8** %176
	%177 = getelementptr { i8*, i64 }, { i8*, i64 }* %175, i32 0, i32 1
	store i64 %167, i64* %177
	%178 = getelementptr { i8*, i64 }, { i8*, i64 }* %175, i32 0, i32 0
	%179 = load i8*, i8** %178
	call void @printf(i8* %179)
	br label %31

180:
	%181 = alloca [11 x i8]
	store [11 x i8] c"falsefalse\00", [11 x i8]* %181
	%182 = alloca { i8*, i64 }
	%183 = getelementptr [11 x i8], [11 x i8]* %181, i32 0, i32 0
	%184 = getelementptr { i8*, i64 }, { i8*, i64 }* %182, i32 0, i32 0
	store i8* %183, i8** %184
	%185 = getelementptr { i8*, i64 }, { i8*, i64 }* %182, i32 0, i32 1
	store i64 11, i64* %185
	%186 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %186
	%187 = alloca { i8*, i64 }
	%188 = getelementptr [2 x i8], [2 x i8]* %186, i32 0, i32 0
	%189 = getelementptr { i8*, i64 }, { i8*, i64 }* %187, i32 0, i32 0
	store i8* %188, i8** %189
	%190 = getelementptr { i8*, i64 }, { i8*, i64 }* %187, i32 0, i32 1
	store i64 2, i64* %190
	%191 = getelementptr { i8*, i64 }, { i8*, i64 }* %182, i32 0, i32 1
	%192 = load i64, i64* %191
	%193 = getelementptr { i8*, i64 }, { i8*, i64 }* %187, i32 0, i32 1
	%194 = load i64, i64* %193
	%195 = add i64 %192, %194
	%196 = call i8* @malloc(i64 %195)
	%197 = getelementptr { i8*, i64 }, { i8*, i64 }* %182, i32 0, i32 0
	%198 = load i8*, i8** %197
	%199 = call i8* @strcat(i8* %196, i8* %198)
	%200 = getelementptr { i8*, i64 }, { i8*, i64 }* %187, i32 0, i32 0
	%201 = load i8*, i8** %200
	%202 = call i8* @strcat(i8* %196, i8* %201)
	%203 = alloca { i8*, i64 }
	%204 = getelementptr { i8*, i64 }, { i8*, i64 }* %203, i32 0, i32 0
	store i8* %196, i8** %204
	%205 = getelementptr { i8*, i64 }, { i8*, i64 }* %203, i32 0, i32 1
	store i64 %195, i64* %205
	%206 = getelementptr { i8*, i64 }, { i8*, i64 }* %203, i32 0, i32 0
	%207 = load i8*, i8** %206
	call void @printf(i8* %207)
	br label %148
}
