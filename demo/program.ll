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
	%1 = alloca [7 x i64]
	%2 = getelementptr [7 x i64], [7 x i64]* %1, i32 0, i32 0
	store i64 1, i64* %2
	%3 = getelementptr [7 x i64], [7 x i64]* %1, i32 1, i32 0
	store i64 2, i64* %3
	%4 = getelementptr [7 x i64], [7 x i64]* %1, i32 2, i32 0
	store i64 3, i64* %4
	%5 = getelementptr [7 x i64], [7 x i64]* %1, i32 3, i32 0
	store i64 4, i64* %5
	%6 = getelementptr [7 x i64], [7 x i64]* %1, i32 4, i32 0
	store i64 5, i64* %6
	%7 = getelementptr [7 x i64], [7 x i64]* %1, i32 5, i32 0
	store i64 6, i64* %7
	%8 = getelementptr [7 x i64], [7 x i64]* %1, i32 6, i32 0
	store i64 7, i64* %8
	%9 = alloca [7 x i64]*
	store [7 x i64]* %1, [7 x i64]** %9
	%10 = load [7 x i64]*, [7 x i64]** %9
	%11 = alloca [2 x i8]
	store [2 x i8] c"{\00", [2 x i8]* %11
	%12 = alloca { i8*, i64 }
	%13 = getelementptr [2 x i8], [2 x i8]* %11, i32 0, i32 0
	%14 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 0
	store i8* %13, i8** %14
	%15 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 1
	store i64 2, i64* %15
	%16 = getelementptr [7 x i64], [7 x i64]* %10, i32 0, i32 0
	%17 = load i64, i64* %16
	%18 = call i64 @intlen(i64 %17)
	%19 = call i8* @malloc(i64 %18)
	%20 = call i64 @itoa(i8* %19, i64 %17)
	%21 = alloca { i8*, i64 }
	%22 = getelementptr { i8*, i64 }, { i8*, i64 }* %21, i32 0, i32 0
	store i8* %19, i8** %22
	%23 = getelementptr { i8*, i64 }, { i8*, i64 }* %21, i32 0, i32 1
	store i64 %18, i64* %23
	%24 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 1
	%25 = load i64, i64* %24
	%26 = getelementptr { i8*, i64 }, { i8*, i64 }* %21, i32 0, i32 1
	%27 = load i64, i64* %26
	%28 = add i64 %25, %27
	%29 = call i8* @malloc(i64 %28)
	%30 = getelementptr { i8*, i64 }, { i8*, i64 }* %12, i32 0, i32 0
	%31 = load i8*, i8** %30
	%32 = call i8* @strcat(i8* %29, i8* %31)
	%33 = getelementptr { i8*, i64 }, { i8*, i64 }* %21, i32 0, i32 0
	%34 = load i8*, i8** %33
	%35 = call i8* @strcat(i8* %29, i8* %34)
	%36 = alloca { i8*, i64 }
	%37 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 0
	store i8* %29, i8** %37
	%38 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 1
	store i64 %28, i64* %38
	%39 = alloca [3 x i8]
	store [3 x i8] c", \00", [3 x i8]* %39
	%40 = alloca { i8*, i64 }
	%41 = getelementptr [3 x i8], [3 x i8]* %39, i32 0, i32 0
	%42 = getelementptr { i8*, i64 }, { i8*, i64 }* %40, i32 0, i32 0
	store i8* %41, i8** %42
	%43 = getelementptr { i8*, i64 }, { i8*, i64 }* %40, i32 0, i32 1
	store i64 3, i64* %43
	%44 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 1
	%45 = load i64, i64* %44
	%46 = getelementptr { i8*, i64 }, { i8*, i64 }* %40, i32 0, i32 1
	%47 = load i64, i64* %46
	%48 = add i64 %45, %47
	%49 = call i8* @malloc(i64 %48)
	%50 = getelementptr { i8*, i64 }, { i8*, i64 }* %36, i32 0, i32 0
	%51 = load i8*, i8** %50
	%52 = call i8* @strcat(i8* %49, i8* %51)
	%53 = getelementptr { i8*, i64 }, { i8*, i64 }* %40, i32 0, i32 0
	%54 = load i8*, i8** %53
	%55 = call i8* @strcat(i8* %49, i8* %54)
	%56 = alloca { i8*, i64 }
	%57 = getelementptr { i8*, i64 }, { i8*, i64 }* %56, i32 0, i32 0
	store i8* %49, i8** %57
	%58 = getelementptr { i8*, i64 }, { i8*, i64 }* %56, i32 0, i32 1
	store i64 %48, i64* %58
	%59 = getelementptr [7 x i64], [7 x i64]* %10, i32 1, i32 0
	%60 = load i64, i64* %59
	%61 = call i64 @intlen(i64 %60)
	%62 = call i8* @malloc(i64 %61)
	%63 = call i64 @itoa(i8* %62, i64 %60)
	%64 = alloca { i8*, i64 }
	%65 = getelementptr { i8*, i64 }, { i8*, i64 }* %64, i32 0, i32 0
	store i8* %62, i8** %65
	%66 = getelementptr { i8*, i64 }, { i8*, i64 }* %64, i32 0, i32 1
	store i64 %61, i64* %66
	%67 = getelementptr { i8*, i64 }, { i8*, i64 }* %56, i32 0, i32 1
	%68 = load i64, i64* %67
	%69 = getelementptr { i8*, i64 }, { i8*, i64 }* %64, i32 0, i32 1
	%70 = load i64, i64* %69
	%71 = add i64 %68, %70
	%72 = call i8* @malloc(i64 %71)
	%73 = getelementptr { i8*, i64 }, { i8*, i64 }* %56, i32 0, i32 0
	%74 = load i8*, i8** %73
	%75 = call i8* @strcat(i8* %72, i8* %74)
	%76 = getelementptr { i8*, i64 }, { i8*, i64 }* %64, i32 0, i32 0
	%77 = load i8*, i8** %76
	%78 = call i8* @strcat(i8* %72, i8* %77)
	%79 = alloca { i8*, i64 }
	%80 = getelementptr { i8*, i64 }, { i8*, i64 }* %79, i32 0, i32 0
	store i8* %72, i8** %80
	%81 = getelementptr { i8*, i64 }, { i8*, i64 }* %79, i32 0, i32 1
	store i64 %71, i64* %81
	%82 = alloca [3 x i8]
	store [3 x i8] c", \00", [3 x i8]* %82
	%83 = alloca { i8*, i64 }
	%84 = getelementptr [3 x i8], [3 x i8]* %82, i32 0, i32 0
	%85 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 0
	store i8* %84, i8** %85
	%86 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 1
	store i64 3, i64* %86
	%87 = getelementptr { i8*, i64 }, { i8*, i64 }* %79, i32 0, i32 1
	%88 = load i64, i64* %87
	%89 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 1
	%90 = load i64, i64* %89
	%91 = add i64 %88, %90
	%92 = call i8* @malloc(i64 %91)
	%93 = getelementptr { i8*, i64 }, { i8*, i64 }* %79, i32 0, i32 0
	%94 = load i8*, i8** %93
	%95 = call i8* @strcat(i8* %92, i8* %94)
	%96 = getelementptr { i8*, i64 }, { i8*, i64 }* %83, i32 0, i32 0
	%97 = load i8*, i8** %96
	%98 = call i8* @strcat(i8* %92, i8* %97)
	%99 = alloca { i8*, i64 }
	%100 = getelementptr { i8*, i64 }, { i8*, i64 }* %99, i32 0, i32 0
	store i8* %92, i8** %100
	%101 = getelementptr { i8*, i64 }, { i8*, i64 }* %99, i32 0, i32 1
	store i64 %91, i64* %101
	%102 = getelementptr [7 x i64], [7 x i64]* %10, i32 2, i32 0
	%103 = load i64, i64* %102
	%104 = call i64 @intlen(i64 %103)
	%105 = call i8* @malloc(i64 %104)
	%106 = call i64 @itoa(i8* %105, i64 %103)
	%107 = alloca { i8*, i64 }
	%108 = getelementptr { i8*, i64 }, { i8*, i64 }* %107, i32 0, i32 0
	store i8* %105, i8** %108
	%109 = getelementptr { i8*, i64 }, { i8*, i64 }* %107, i32 0, i32 1
	store i64 %104, i64* %109
	%110 = getelementptr { i8*, i64 }, { i8*, i64 }* %99, i32 0, i32 1
	%111 = load i64, i64* %110
	%112 = getelementptr { i8*, i64 }, { i8*, i64 }* %107, i32 0, i32 1
	%113 = load i64, i64* %112
	%114 = add i64 %111, %113
	%115 = call i8* @malloc(i64 %114)
	%116 = getelementptr { i8*, i64 }, { i8*, i64 }* %99, i32 0, i32 0
	%117 = load i8*, i8** %116
	%118 = call i8* @strcat(i8* %115, i8* %117)
	%119 = getelementptr { i8*, i64 }, { i8*, i64 }* %107, i32 0, i32 0
	%120 = load i8*, i8** %119
	%121 = call i8* @strcat(i8* %115, i8* %120)
	%122 = alloca { i8*, i64 }
	%123 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 0
	store i8* %115, i8** %123
	%124 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 1
	store i64 %114, i64* %124
	%125 = alloca [3 x i8]
	store [3 x i8] c", \00", [3 x i8]* %125
	%126 = alloca { i8*, i64 }
	%127 = getelementptr [3 x i8], [3 x i8]* %125, i32 0, i32 0
	%128 = getelementptr { i8*, i64 }, { i8*, i64 }* %126, i32 0, i32 0
	store i8* %127, i8** %128
	%129 = getelementptr { i8*, i64 }, { i8*, i64 }* %126, i32 0, i32 1
	store i64 3, i64* %129
	%130 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 1
	%131 = load i64, i64* %130
	%132 = getelementptr { i8*, i64 }, { i8*, i64 }* %126, i32 0, i32 1
	%133 = load i64, i64* %132
	%134 = add i64 %131, %133
	%135 = call i8* @malloc(i64 %134)
	%136 = getelementptr { i8*, i64 }, { i8*, i64 }* %122, i32 0, i32 0
	%137 = load i8*, i8** %136
	%138 = call i8* @strcat(i8* %135, i8* %137)
	%139 = getelementptr { i8*, i64 }, { i8*, i64 }* %126, i32 0, i32 0
	%140 = load i8*, i8** %139
	%141 = call i8* @strcat(i8* %135, i8* %140)
	%142 = alloca { i8*, i64 }
	%143 = getelementptr { i8*, i64 }, { i8*, i64 }* %142, i32 0, i32 0
	store i8* %135, i8** %143
	%144 = getelementptr { i8*, i64 }, { i8*, i64 }* %142, i32 0, i32 1
	store i64 %134, i64* %144
	%145 = getelementptr [7 x i64], [7 x i64]* %10, i32 3, i32 0
	%146 = load i64, i64* %145
	%147 = call i64 @intlen(i64 %146)
	%148 = call i8* @malloc(i64 %147)
	%149 = call i64 @itoa(i8* %148, i64 %146)
	%150 = alloca { i8*, i64 }
	%151 = getelementptr { i8*, i64 }, { i8*, i64 }* %150, i32 0, i32 0
	store i8* %148, i8** %151
	%152 = getelementptr { i8*, i64 }, { i8*, i64 }* %150, i32 0, i32 1
	store i64 %147, i64* %152
	%153 = getelementptr { i8*, i64 }, { i8*, i64 }* %142, i32 0, i32 1
	%154 = load i64, i64* %153
	%155 = getelementptr { i8*, i64 }, { i8*, i64 }* %150, i32 0, i32 1
	%156 = load i64, i64* %155
	%157 = add i64 %154, %156
	%158 = call i8* @malloc(i64 %157)
	%159 = getelementptr { i8*, i64 }, { i8*, i64 }* %142, i32 0, i32 0
	%160 = load i8*, i8** %159
	%161 = call i8* @strcat(i8* %158, i8* %160)
	%162 = getelementptr { i8*, i64 }, { i8*, i64 }* %150, i32 0, i32 0
	%163 = load i8*, i8** %162
	%164 = call i8* @strcat(i8* %158, i8* %163)
	%165 = alloca { i8*, i64 }
	%166 = getelementptr { i8*, i64 }, { i8*, i64 }* %165, i32 0, i32 0
	store i8* %158, i8** %166
	%167 = getelementptr { i8*, i64 }, { i8*, i64 }* %165, i32 0, i32 1
	store i64 %157, i64* %167
	%168 = alloca [3 x i8]
	store [3 x i8] c", \00", [3 x i8]* %168
	%169 = alloca { i8*, i64 }
	%170 = getelementptr [3 x i8], [3 x i8]* %168, i32 0, i32 0
	%171 = getelementptr { i8*, i64 }, { i8*, i64 }* %169, i32 0, i32 0
	store i8* %170, i8** %171
	%172 = getelementptr { i8*, i64 }, { i8*, i64 }* %169, i32 0, i32 1
	store i64 3, i64* %172
	%173 = getelementptr { i8*, i64 }, { i8*, i64 }* %165, i32 0, i32 1
	%174 = load i64, i64* %173
	%175 = getelementptr { i8*, i64 }, { i8*, i64 }* %169, i32 0, i32 1
	%176 = load i64, i64* %175
	%177 = add i64 %174, %176
	%178 = call i8* @malloc(i64 %177)
	%179 = getelementptr { i8*, i64 }, { i8*, i64 }* %165, i32 0, i32 0
	%180 = load i8*, i8** %179
	%181 = call i8* @strcat(i8* %178, i8* %180)
	%182 = getelementptr { i8*, i64 }, { i8*, i64 }* %169, i32 0, i32 0
	%183 = load i8*, i8** %182
	%184 = call i8* @strcat(i8* %178, i8* %183)
	%185 = alloca { i8*, i64 }
	%186 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 0
	store i8* %178, i8** %186
	%187 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 1
	store i64 %177, i64* %187
	%188 = getelementptr [7 x i64], [7 x i64]* %10, i32 4, i32 0
	%189 = load i64, i64* %188
	%190 = call i64 @intlen(i64 %189)
	%191 = call i8* @malloc(i64 %190)
	%192 = call i64 @itoa(i8* %191, i64 %189)
	%193 = alloca { i8*, i64 }
	%194 = getelementptr { i8*, i64 }, { i8*, i64 }* %193, i32 0, i32 0
	store i8* %191, i8** %194
	%195 = getelementptr { i8*, i64 }, { i8*, i64 }* %193, i32 0, i32 1
	store i64 %190, i64* %195
	%196 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 1
	%197 = load i64, i64* %196
	%198 = getelementptr { i8*, i64 }, { i8*, i64 }* %193, i32 0, i32 1
	%199 = load i64, i64* %198
	%200 = add i64 %197, %199
	%201 = call i8* @malloc(i64 %200)
	%202 = getelementptr { i8*, i64 }, { i8*, i64 }* %185, i32 0, i32 0
	%203 = load i8*, i8** %202
	%204 = call i8* @strcat(i8* %201, i8* %203)
	%205 = getelementptr { i8*, i64 }, { i8*, i64 }* %193, i32 0, i32 0
	%206 = load i8*, i8** %205
	%207 = call i8* @strcat(i8* %201, i8* %206)
	%208 = alloca { i8*, i64 }
	%209 = getelementptr { i8*, i64 }, { i8*, i64 }* %208, i32 0, i32 0
	store i8* %201, i8** %209
	%210 = getelementptr { i8*, i64 }, { i8*, i64 }* %208, i32 0, i32 1
	store i64 %200, i64* %210
	%211 = alloca [3 x i8]
	store [3 x i8] c", \00", [3 x i8]* %211
	%212 = alloca { i8*, i64 }
	%213 = getelementptr [3 x i8], [3 x i8]* %211, i32 0, i32 0
	%214 = getelementptr { i8*, i64 }, { i8*, i64 }* %212, i32 0, i32 0
	store i8* %213, i8** %214
	%215 = getelementptr { i8*, i64 }, { i8*, i64 }* %212, i32 0, i32 1
	store i64 3, i64* %215
	%216 = getelementptr { i8*, i64 }, { i8*, i64 }* %208, i32 0, i32 1
	%217 = load i64, i64* %216
	%218 = getelementptr { i8*, i64 }, { i8*, i64 }* %212, i32 0, i32 1
	%219 = load i64, i64* %218
	%220 = add i64 %217, %219
	%221 = call i8* @malloc(i64 %220)
	%222 = getelementptr { i8*, i64 }, { i8*, i64 }* %208, i32 0, i32 0
	%223 = load i8*, i8** %222
	%224 = call i8* @strcat(i8* %221, i8* %223)
	%225 = getelementptr { i8*, i64 }, { i8*, i64 }* %212, i32 0, i32 0
	%226 = load i8*, i8** %225
	%227 = call i8* @strcat(i8* %221, i8* %226)
	%228 = alloca { i8*, i64 }
	%229 = getelementptr { i8*, i64 }, { i8*, i64 }* %228, i32 0, i32 0
	store i8* %221, i8** %229
	%230 = getelementptr { i8*, i64 }, { i8*, i64 }* %228, i32 0, i32 1
	store i64 %220, i64* %230
	%231 = getelementptr [7 x i64], [7 x i64]* %10, i32 5, i32 0
	%232 = load i64, i64* %231
	%233 = call i64 @intlen(i64 %232)
	%234 = call i8* @malloc(i64 %233)
	%235 = call i64 @itoa(i8* %234, i64 %232)
	%236 = alloca { i8*, i64 }
	%237 = getelementptr { i8*, i64 }, { i8*, i64 }* %236, i32 0, i32 0
	store i8* %234, i8** %237
	%238 = getelementptr { i8*, i64 }, { i8*, i64 }* %236, i32 0, i32 1
	store i64 %233, i64* %238
	%239 = getelementptr { i8*, i64 }, { i8*, i64 }* %228, i32 0, i32 1
	%240 = load i64, i64* %239
	%241 = getelementptr { i8*, i64 }, { i8*, i64 }* %236, i32 0, i32 1
	%242 = load i64, i64* %241
	%243 = add i64 %240, %242
	%244 = call i8* @malloc(i64 %243)
	%245 = getelementptr { i8*, i64 }, { i8*, i64 }* %228, i32 0, i32 0
	%246 = load i8*, i8** %245
	%247 = call i8* @strcat(i8* %244, i8* %246)
	%248 = getelementptr { i8*, i64 }, { i8*, i64 }* %236, i32 0, i32 0
	%249 = load i8*, i8** %248
	%250 = call i8* @strcat(i8* %244, i8* %249)
	%251 = alloca { i8*, i64 }
	%252 = getelementptr { i8*, i64 }, { i8*, i64 }* %251, i32 0, i32 0
	store i8* %244, i8** %252
	%253 = getelementptr { i8*, i64 }, { i8*, i64 }* %251, i32 0, i32 1
	store i64 %243, i64* %253
	%254 = alloca [3 x i8]
	store [3 x i8] c", \00", [3 x i8]* %254
	%255 = alloca { i8*, i64 }
	%256 = getelementptr [3 x i8], [3 x i8]* %254, i32 0, i32 0
	%257 = getelementptr { i8*, i64 }, { i8*, i64 }* %255, i32 0, i32 0
	store i8* %256, i8** %257
	%258 = getelementptr { i8*, i64 }, { i8*, i64 }* %255, i32 0, i32 1
	store i64 3, i64* %258
	%259 = getelementptr { i8*, i64 }, { i8*, i64 }* %251, i32 0, i32 1
	%260 = load i64, i64* %259
	%261 = getelementptr { i8*, i64 }, { i8*, i64 }* %255, i32 0, i32 1
	%262 = load i64, i64* %261
	%263 = add i64 %260, %262
	%264 = call i8* @malloc(i64 %263)
	%265 = getelementptr { i8*, i64 }, { i8*, i64 }* %251, i32 0, i32 0
	%266 = load i8*, i8** %265
	%267 = call i8* @strcat(i8* %264, i8* %266)
	%268 = getelementptr { i8*, i64 }, { i8*, i64 }* %255, i32 0, i32 0
	%269 = load i8*, i8** %268
	%270 = call i8* @strcat(i8* %264, i8* %269)
	%271 = alloca { i8*, i64 }
	%272 = getelementptr { i8*, i64 }, { i8*, i64 }* %271, i32 0, i32 0
	store i8* %264, i8** %272
	%273 = getelementptr { i8*, i64 }, { i8*, i64 }* %271, i32 0, i32 1
	store i64 %263, i64* %273
	%274 = getelementptr [7 x i64], [7 x i64]* %10, i32 6, i32 0
	%275 = load i64, i64* %274
	%276 = call i64 @intlen(i64 %275)
	%277 = call i8* @malloc(i64 %276)
	%278 = call i64 @itoa(i8* %277, i64 %275)
	%279 = alloca { i8*, i64 }
	%280 = getelementptr { i8*, i64 }, { i8*, i64 }* %279, i32 0, i32 0
	store i8* %277, i8** %280
	%281 = getelementptr { i8*, i64 }, { i8*, i64 }* %279, i32 0, i32 1
	store i64 %276, i64* %281
	%282 = getelementptr { i8*, i64 }, { i8*, i64 }* %271, i32 0, i32 1
	%283 = load i64, i64* %282
	%284 = getelementptr { i8*, i64 }, { i8*, i64 }* %279, i32 0, i32 1
	%285 = load i64, i64* %284
	%286 = add i64 %283, %285
	%287 = call i8* @malloc(i64 %286)
	%288 = getelementptr { i8*, i64 }, { i8*, i64 }* %271, i32 0, i32 0
	%289 = load i8*, i8** %288
	%290 = call i8* @strcat(i8* %287, i8* %289)
	%291 = getelementptr { i8*, i64 }, { i8*, i64 }* %279, i32 0, i32 0
	%292 = load i8*, i8** %291
	%293 = call i8* @strcat(i8* %287, i8* %292)
	%294 = alloca { i8*, i64 }
	%295 = getelementptr { i8*, i64 }, { i8*, i64 }* %294, i32 0, i32 0
	store i8* %287, i8** %295
	%296 = getelementptr { i8*, i64 }, { i8*, i64 }* %294, i32 0, i32 1
	store i64 %286, i64* %296
	%297 = alloca [2 x i8]
	store [2 x i8] c"}\00", [2 x i8]* %297
	%298 = alloca { i8*, i64 }
	%299 = getelementptr [2 x i8], [2 x i8]* %297, i32 0, i32 0
	%300 = getelementptr { i8*, i64 }, { i8*, i64 }* %298, i32 0, i32 0
	store i8* %299, i8** %300
	%301 = getelementptr { i8*, i64 }, { i8*, i64 }* %298, i32 0, i32 1
	store i64 2, i64* %301
	%302 = getelementptr { i8*, i64 }, { i8*, i64 }* %294, i32 0, i32 1
	%303 = load i64, i64* %302
	%304 = getelementptr { i8*, i64 }, { i8*, i64 }* %298, i32 0, i32 1
	%305 = load i64, i64* %304
	%306 = add i64 %303, %305
	%307 = call i8* @malloc(i64 %306)
	%308 = getelementptr { i8*, i64 }, { i8*, i64 }* %294, i32 0, i32 0
	%309 = load i8*, i8** %308
	%310 = call i8* @strcat(i8* %307, i8* %309)
	%311 = getelementptr { i8*, i64 }, { i8*, i64 }* %298, i32 0, i32 0
	%312 = load i8*, i8** %311
	%313 = call i8* @strcat(i8* %307, i8* %312)
	%314 = alloca { i8*, i64 }
	%315 = getelementptr { i8*, i64 }, { i8*, i64 }* %314, i32 0, i32 0
	store i8* %307, i8** %315
	%316 = getelementptr { i8*, i64 }, { i8*, i64 }* %314, i32 0, i32 1
	store i64 %306, i64* %316
	%317 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %317
	%318 = alloca { i8*, i64 }
	%319 = getelementptr [2 x i8], [2 x i8]* %317, i32 0, i32 0
	%320 = getelementptr { i8*, i64 }, { i8*, i64 }* %318, i32 0, i32 0
	store i8* %319, i8** %320
	%321 = getelementptr { i8*, i64 }, { i8*, i64 }* %318, i32 0, i32 1
	store i64 2, i64* %321
	%322 = getelementptr { i8*, i64 }, { i8*, i64 }* %314, i32 0, i32 1
	%323 = load i64, i64* %322
	%324 = getelementptr { i8*, i64 }, { i8*, i64 }* %318, i32 0, i32 1
	%325 = load i64, i64* %324
	%326 = add i64 %323, %325
	%327 = call i8* @malloc(i64 %326)
	%328 = getelementptr { i8*, i64 }, { i8*, i64 }* %314, i32 0, i32 0
	%329 = load i8*, i8** %328
	%330 = call i8* @strcat(i8* %327, i8* %329)
	%331 = getelementptr { i8*, i64 }, { i8*, i64 }* %318, i32 0, i32 0
	%332 = load i8*, i8** %331
	%333 = call i8* @strcat(i8* %327, i8* %332)
	%334 = alloca { i8*, i64 }
	%335 = getelementptr { i8*, i64 }, { i8*, i64 }* %334, i32 0, i32 0
	store i8* %327, i8** %335
	%336 = getelementptr { i8*, i64 }, { i8*, i64 }* %334, i32 0, i32 1
	store i64 %326, i64* %336
	%337 = getelementptr { i8*, i64 }, { i8*, i64 }* %334, i32 0, i32 0
	%338 = load i8*, i8** %337
	call void @printf(i8* %338)
	%339 = load [7 x i64]*, [7 x i64]** %9
	%340 = alloca [8 x i8]
	store [8 x i8] c"{7|int}\00", [8 x i8]* %340
	%341 = alloca { i8*, i64 }
	%342 = getelementptr [8 x i8], [8 x i8]* %340, i32 0, i32 0
	%343 = getelementptr { i8*, i64 }, { i8*, i64 }* %341, i32 0, i32 0
	store i8* %342, i8** %343
	%344 = getelementptr { i8*, i64 }, { i8*, i64 }* %341, i32 0, i32 1
	store i64 8, i64* %344
	%345 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %345
	%346 = alloca { i8*, i64 }
	%347 = getelementptr [2 x i8], [2 x i8]* %345, i32 0, i32 0
	%348 = getelementptr { i8*, i64 }, { i8*, i64 }* %346, i32 0, i32 0
	store i8* %347, i8** %348
	%349 = getelementptr { i8*, i64 }, { i8*, i64 }* %346, i32 0, i32 1
	store i64 2, i64* %349
	%350 = getelementptr { i8*, i64 }, { i8*, i64 }* %341, i32 0, i32 1
	%351 = load i64, i64* %350
	%352 = getelementptr { i8*, i64 }, { i8*, i64 }* %346, i32 0, i32 1
	%353 = load i64, i64* %352
	%354 = add i64 %351, %353
	%355 = call i8* @malloc(i64 %354)
	%356 = getelementptr { i8*, i64 }, { i8*, i64 }* %341, i32 0, i32 0
	%357 = load i8*, i8** %356
	%358 = call i8* @strcat(i8* %355, i8* %357)
	%359 = getelementptr { i8*, i64 }, { i8*, i64 }* %346, i32 0, i32 0
	%360 = load i8*, i8** %359
	%361 = call i8* @strcat(i8* %355, i8* %360)
	%362 = alloca { i8*, i64 }
	%363 = getelementptr { i8*, i64 }, { i8*, i64 }* %362, i32 0, i32 0
	store i8* %355, i8** %363
	%364 = getelementptr { i8*, i64 }, { i8*, i64 }* %362, i32 0, i32 1
	store i64 %354, i64* %364
	%365 = getelementptr { i8*, i64 }, { i8*, i64 }* %362, i32 0, i32 0
	%366 = load i8*, i8** %365
	call void @printf(i8* %366)
	%367 = load [7 x i64]*, [7 x i64]** %9
	%368 = getelementptr [7 x i64], [7 x i64]* %367, i64 8, i32 0
	%369 = load i64, i64* %368
	%370 = call i64 @intlen(i64 %369)
	%371 = call i8* @malloc(i64 %370)
	%372 = call i64 @itoa(i8* %371, i64 %369)
	%373 = alloca { i8*, i64 }
	%374 = getelementptr { i8*, i64 }, { i8*, i64 }* %373, i32 0, i32 0
	store i8* %371, i8** %374
	%375 = getelementptr { i8*, i64 }, { i8*, i64 }* %373, i32 0, i32 1
	store i64 %370, i64* %375
	%376 = alloca [2 x i8]
	store [2 x i8] c"\0A\00", [2 x i8]* %376
	%377 = alloca { i8*, i64 }
	%378 = getelementptr [2 x i8], [2 x i8]* %376, i32 0, i32 0
	%379 = getelementptr { i8*, i64 }, { i8*, i64 }* %377, i32 0, i32 0
	store i8* %378, i8** %379
	%380 = getelementptr { i8*, i64 }, { i8*, i64 }* %377, i32 0, i32 1
	store i64 2, i64* %380
	%381 = getelementptr { i8*, i64 }, { i8*, i64 }* %373, i32 0, i32 1
	%382 = load i64, i64* %381
	%383 = getelementptr { i8*, i64 }, { i8*, i64 }* %377, i32 0, i32 1
	%384 = load i64, i64* %383
	%385 = add i64 %382, %384
	%386 = call i8* @malloc(i64 %385)
	%387 = getelementptr { i8*, i64 }, { i8*, i64 }* %373, i32 0, i32 0
	%388 = load i8*, i8** %387
	%389 = call i8* @strcat(i8* %386, i8* %388)
	%390 = getelementptr { i8*, i64 }, { i8*, i64 }* %377, i32 0, i32 0
	%391 = load i8*, i8** %390
	%392 = call i8* @strcat(i8* %386, i8* %391)
	%393 = alloca { i8*, i64 }
	%394 = getelementptr { i8*, i64 }, { i8*, i64 }* %393, i32 0, i32 0
	store i8* %386, i8** %394
	%395 = getelementptr { i8*, i64 }, { i8*, i64 }* %393, i32 0, i32 1
	store i64 %385, i64* %395
	%396 = getelementptr { i8*, i64 }, { i8*, i64 }* %393, i32 0, i32 0
	%397 = load i8*, i8** %396
	call void @printf(i8* %397)
	ret i32 0
}
