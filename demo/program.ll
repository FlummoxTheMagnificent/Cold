declare void @printf(i8* %p1)

declare i8* @strcat(i8* %p1, i8* %p2)

declare i64 @sprintf(i8* %p1, i8* %p2, i64 %p3)

declare i8* @malloc(i64 %p1)

declare void @stuff()

define i32 @main() {
0:
	call void @stuff()
	ret i32 0
}
