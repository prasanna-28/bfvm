
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@tape = global [30000 x i8] zeroinitializer, align 16

declare i32 @putchar(i32)
declare i32 @getchar()
declare i8* @strncpy(i8*, i8*, i64)
declare i32 @printf(i8*, ...)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)
declare %struct._IO_FILE* @__stdinp
declare %struct._IO_FILE* @__stderrp

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

define i32 @main(i32 %argc, i8** %argv) {
  %1 = icmp ne i32 %argc, 2
  br i1 %1, label %print_usage, label %run_interpreter

print_usage:
  %2 = load %struct._IO_FILE*, %struct._IO_FILE** @__stderrp, align 8
  %3 = getelementptr inbounds i8*, i8** %argv, i64 0
  %4 = load i8*, i8** %3, align 8
  %5 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %2, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @usage_str, i32 0, i32 0), i8* %4)
  ret i32 1

run_interpreter:
  %6 = getelementptr inbounds i8*, i8** %argv, i64 1
  %7 = load i8*, i8** %6, align 8
  %8 = getelementptr inbounds [30000 x i8], [30000 x i8]* @tape, i32 0, i32 0
  %9 = call i8* @strncpy(i8* %8, i8* %7, i64 29999)
  %10 = getelementptr inbounds [30000 x i8], [30000 x i8]* @tape, i64 0, i64 29999
  store i8 0, i8* %10, align 1
  call void @interpret()
  ret i32 0
}

define void @interpret() {
  %dp = alloca i32
  store i32 0, i32* %dp
  %ip = alloca i32
  store i32 0, i32* %ip
  br label %l

l:
  %cp = load i32, i32* %ip
  %ci = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %cp
  %in = load i8, i8* %ci
  switch i8 %in, label %e [
    i8 62, label %i_p
    i8 60, label %d_p
    i8 43, label %i_v
    i8 45, label %d_v
    i8 46, label %out
    i8 44, label %inp
    i8 91, label %j_f
    i8 93, label %j_b
  ]

i_p:
  %a = load i32, i32* %dp
  %b = add i32 %a, 1
  store i32 %b, i32* %dp
  br label %c

d_p:
  %d = load i32, i32* %dp
  %f = sub i32 %d, 1
  store i32 %f, i32* %dp
  br label %c

i_v:
  %g = load i32, i32* %dp
  %h = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %g
  %i = load i8, i8* %h
  %j = add i8 %i, 1
  store i8 %j, i8* %h
  br label %c

d_v:
  %k = load i32, i32* %dp
  %m = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %k
  %n = load i8, i8* %m
  %o = sub i8 %n, 1
  store i8 %o, i8* %m
  br label %c

out:
  %p = load i32, i32* %dp
  %q = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %p
  %r = load i8, i8* %q
  %s = sext i8 %r to i32
  call i32 @putchar(i32 %s)
  br label %c

inp:
  %u = call i32 @getchar()
  %v = trunc i32 %u to i8
  %w = load i32, i32* %dp
  %x = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %w
  store i8 %v, i8* %x
  br label %c

j_f:
  %y = load i32, i32* %dp
  %z = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %y
  %aa = load i8, i8* %z
  %ab = icmp eq i8 %aa, 0
  br i1 %ab, label %s_f, label %c

s_f:
  %ac = load i32, i32* %ip
  %ad = add i32 %ac, 1
  store i32 %ad, i32* %ip
  %ae = call i32 @fmb(i32 %ad, i32 1)
  store i32 %ae, i32* %ip
  br label %c

j_b:
  %af = load i32, i32* %dp
  %ag = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %af
  %ah = load i8, i8* %ag
  %ai = icmp ne i8 %ah, 0
  br i1 %ai, label %s_b, label %c

s_b:
  %aj = load i32, i32* %ip
  %ak = sub i32 %aj, 1
  %al = call i32 @fmb(i32 %ak, i32 -1)
  store i32 %al, i32* %ip
  br label %c

c:
  %am = load i32, i32* %ip
  %an = add i32 %am, 1
  store i32 %an, i32* %ip
  br label %l

e:
  ret void
}

define i32 @fmb(i32 %s, i32 %d) {
  %bc = alloca i32
  store i32 1, i32* %bc
  %cp = alloca i32
  store i32 %s, i32* %cp

  br label %sl

sl:
  %a = load i32, i32* %cp
  %b = getelementptr [30000 x i8], [30000 x i8]* @tape, i32 0, i32 %a
  %c = load i8, i8* %b

  %d = icmp eq i8 %c, 91
  %e = icmp eq i8 %c, 93

  %f = load i32, i32* %bc
  %g = select i1 %d, i32 %f, i32 0
  %h = add i32 %g, 1
  %i = select i1 %e, i32 %f, i32 0
  %j = sub i32 %i, 1
  %k = select i1 %d, i32 %h, i32 %j
  store i32 %k, i32* %bc

  %l = icmp eq i32 %k, 0
  br i1 %l, label %fd, label %cs

cs:
  %m = load i32, i32* %cp
  %n = add i32 %m, %d
  store i32 %n, i32* %cp
  br label %sl

fd:
  %o = load i32, i32* %cp
  ret i32 %o
}

@usage_str = private unnamed_addr constant [28 x i8] c"Usage: %s <brainfuck_program>\0A\00", align 1
