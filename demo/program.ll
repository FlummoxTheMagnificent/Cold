; ModuleID = 'program.ll'
source_filename = "program.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nofree nounwind
declare void @printf(i8* nocapture readonly) local_unnamed_addr #0

; Function Attrs: nofree nounwind
declare i8* @strcat(i8* returned, i8* nocapture readonly) local_unnamed_addr #0

declare i8 @strcmp(i8*, i8*) local_unnamed_addr

declare i64 @intlen(i64) local_unnamed_addr

declare i64 @itoa(i8*, i64) local_unnamed_addr

; Function Attrs: nofree nounwind
declare noalias i8* @malloc(i64) local_unnamed_addr #0

define i32 @main() local_unnamed_addr {
  br label %1

1:                                                ; preds = %45, %0
  %.0 = phi i64 [ 0, %0 ], [ %2, %45 ]
  %2 = add nuw nsw i64 %.0, 1
  %3 = alloca [1 x i8], align 1
  %4 = getelementptr inbounds [1 x i8], [1 x i8]* %3, i64 0, i64 0
  store i8 0, i8* %4, align 1
  %5 = alloca { i8*, i64 }, align 8
  %6 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %5, i64 0, i32 0
  store i8* %4, i8** %6, align 8
  %7 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %5, i64 0, i32 1
  store i64 1, i64* %7, align 8
  %8 = urem i64 %2, 3
  %9 = icmp eq i64 %8, 0
  br i1 %9, label %10, label %15

10:                                               ; preds = %1
  %11 = alloca [5 x i8], align 1
  %.repack15 = getelementptr inbounds [5 x i8], [5 x i8]* %11, i64 0, i64 0
  store i8 70, i8* %.repack15, align 1
  %.repack16 = getelementptr inbounds [5 x i8], [5 x i8]* %11, i64 0, i64 1
  store i8 105, i8* %.repack16, align 1
  %.repack17 = getelementptr inbounds [5 x i8], [5 x i8]* %11, i64 0, i64 2
  store i8 122, i8* %.repack17, align 1
  %.repack18 = getelementptr inbounds [5 x i8], [5 x i8]* %11, i64 0, i64 3
  store i8 122, i8* %.repack18, align 1
  %.repack19 = getelementptr inbounds [5 x i8], [5 x i8]* %11, i64 0, i64 4
  store i8 0, i8* %.repack19, align 1
  %12 = alloca { i8*, i64 }, align 8
  %13 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %12, i64 0, i32 0
  store i8* %.repack15, i8** %13, align 8
  %14 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %12, i64 0, i32 1
  store i64 5, i64* %14, align 8
  br label %15

15:                                               ; preds = %10, %1
  %16 = phi i8* [ %.repack15, %10 ], [ %4, %1 ]
  %17 = phi i64 [ 10, %10 ], [ 6, %1 ]
  %18 = phi { i8*, i64 }* [ %12, %10 ], [ %5, %1 ]
  %19 = urem i64 %2, 5
  %20 = icmp eq i64 %19, 0
  br i1 %20, label %21, label %29

21:                                               ; preds = %15
  %22 = alloca [5 x i8], align 1
  %.repack10 = getelementptr inbounds [5 x i8], [5 x i8]* %22, i64 0, i64 0
  store i8 66, i8* %.repack10, align 1
  %.repack11 = getelementptr inbounds [5 x i8], [5 x i8]* %22, i64 0, i64 1
  store i8 117, i8* %.repack11, align 1
  %.repack12 = getelementptr inbounds [5 x i8], [5 x i8]* %22, i64 0, i64 2
  store i8 122, i8* %.repack12, align 1
  %.repack13 = getelementptr inbounds [5 x i8], [5 x i8]* %22, i64 0, i64 3
  store i8 122, i8* %.repack13, align 1
  %.repack14 = getelementptr inbounds [5 x i8], [5 x i8]* %22, i64 0, i64 4
  store i8 0, i8* %.repack14, align 1
  %23 = call i8* @malloc(i64 %17)
  %24 = call i8* @strcat(i8* nonnull dereferenceable(1) %23, i8* nonnull dereferenceable(1) %16)
  %25 = call i8* @strcat(i8* nonnull dereferenceable(1) %23, i8* nonnull dereferenceable(1) %.repack10)
  %26 = alloca { i8*, i64 }, align 8
  %27 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %26, i64 0, i32 0
  store i8* %23, i8** %27, align 8
  %28 = getelementptr inbounds { i8*, i64 }, { i8*, i64 }* %26, i64 0, i32 1
  store i64 %17, i64* %28, align 8
  br label %29

29:                                               ; preds = %21, %15
  %30 = phi i8* [ %23, %21 ], [ %16, %15 ]
  %31 = phi { i8*, i64 }* [ %26, %21 ], [ %18, %15 ]
  %32 = alloca [1 x i8], align 1
  %33 = getelementptr inbounds [1 x i8], [1 x i8]* %32, i64 0, i64 0
  store i8 0, i8* %33, align 1
  %34 = call i8 @strcmp(i8* %30, i8* nonnull %33)
  %35 = icmp eq i8 %34, 0
  br i1 %35, label %36, label %46

36:                                               ; preds = %29
  %37 = call i64 @intlen(i64 %2)
  %38 = call i8* @malloc(i64 %37)
  %39 = call i64 @itoa(i8* %38, i64 %2)
  %40 = alloca [2 x i8], align 1
  %.repack8 = getelementptr inbounds [2 x i8], [2 x i8]* %40, i64 0, i64 0
  store i8 10, i8* %.repack8, align 1
  %.repack9 = getelementptr inbounds [2 x i8], [2 x i8]* %40, i64 0, i64 1
  store i8 0, i8* %.repack9, align 1
  %41 = add i64 %37, 2
  %42 = call i8* @malloc(i64 %41)
  %43 = call i8* @strcat(i8* nonnull dereferenceable(1) %42, i8* nonnull dereferenceable(1) %38)
  %44 = call i8* @strcat(i8* nonnull dereferenceable(1) %42, i8* nonnull dereferenceable(1) %.repack8)
  br label %45

45:                                               ; preds = %46, %36
  %.sink = phi i8* [ %52, %46 ], [ %42, %36 ]
  call void @printf(i8* nonnull dereferenceable(1) %.sink)
  %exitcond = icmp eq i64 %2, 100
  br i1 %exitcond, label %56, label %1

46:                                               ; preds = %29
  %47 = getelementptr { i8*, i64 }, { i8*, i64 }* %31, i64 0, i32 0
  %48 = alloca [2 x i8], align 1
  %.repack = getelementptr inbounds [2 x i8], [2 x i8]* %48, i64 0, i64 0
  store i8 10, i8* %.repack, align 1
  %.repack7 = getelementptr inbounds [2 x i8], [2 x i8]* %48, i64 0, i64 1
  store i8 0, i8* %.repack7, align 1
  %49 = getelementptr { i8*, i64 }, { i8*, i64 }* %31, i64 0, i32 1
  %50 = load i64, i64* %49, align 8
  %51 = add i64 %50, 2
  %52 = call i8* @malloc(i64 %51)
  %53 = load i8*, i8** %47, align 8
  %54 = call i8* @strcat(i8* nonnull dereferenceable(1) %52, i8* nonnull dereferenceable(1) %53)
  %55 = call i8* @strcat(i8* nonnull dereferenceable(1) %52, i8* nonnull dereferenceable(1) %.repack)
  br label %45

56:                                               ; preds = %45
  ret i32 0
}

attributes #0 = { nofree nounwind }
