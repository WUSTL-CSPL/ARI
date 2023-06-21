; Test CSI function entry/exit instrumentation.
;
; RUN: opt < %s -csi -S | FileCheck %s

; CHECK: @__csi_unit_bb_base_id = internal global i64 0

define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %call = call i32 @foo()
  ret i32 %call
}

define internal i32 @foo() #0 {
entry:
  ret i32 1
}

; CHECK: define i32 @main()
; CHECK-NEXT: entry:
; CHECK: %{{[0-9]+}} = load i64, i64* @__csi_unit_bb_base_id
; CHECK-NEXT: %{{[0-9]+}} = add i64 %{{[0-9]+}}, 0
; CHECK-NEXT: %{{[0-9]+}} = load i1, i1* @__csi_disable_instrumentation
; CHECK-NEXT: %{{[0-9]+}} = icmp eq i1 %{{[0-9]+}}, false
; CHECK-NEXT: br i1 %{{[0-9]+}}, label %10, label %11

; CHECK: <label>:10:
; CHECK-NEXT: store i1 true, i1* @__csi_disable_instrumentation
; CHECK-NEXT: call void @__csi_bb_entry(i64 %{{[0-9]+}}, { i1, i63 } zeroinitializer)
; CHECK-NEXT: store i1 false, i1* @__csi_disable_instrumentation
; CHECK-NEXT: br label %11

; CHECK: <label>:34:
; CHECK-NEXT: %{{[0-9]+}} = load i1, i1* @__csi_disable_instrumentation
; CHECK-NEXT: %{{[0-9]+}} = icmp eq i1 %{{[0-9]+}}, false
; CHECK-NEXT: br i1 %{{[0-9]+}}, label %37, label %38

; CHECK: <label>:37:
; CHECK-NEXT: store i1 true, i1* @__csi_disable_instrumentation
; CHECK-NEXT: call void @__csi_bb_exit(i64 %{{[0-9]+}}, { i1, i63 } zeroinitializer)
; CHECK-NEXT: store i1 false, i1* @__csi_disable_instrumentation
; CHECK-NEXT: br label %38

; CHECK: define internal i32 @foo()
; CHECK: <label>:5
; CHECK-NEXT: %{{[0-9]+}} = load i64, i64* @__csi_unit_bb_base_id
; CHECK-NEXT: %{{[0-9]+}} = add i64 %{{[0-9]+}}, 1
; CHECK-NEXT: %{{[0-9]+}} = load i1, i1* @__csi_disable_instrumentation
; CHECK-NEXT: %{{[0-9]+}} = icmp eq i1 %{{[0-9]+}}, false
; CHECK-NEXT: br i1 %{{[0-9]+}}, label %10, label %11

; CHECK: <label>:10:
; CHECK-NEXT: store i1 true, i1* @__csi_disable_instrumentation
; CHECK-NEXT: call void @__csi_bb_entry(i64 %{{[0-9]+}}, { i1, i63 } zeroinitializer)
; CHECK-NEXT: store i1 false, i1* @__csi_disable_instrumentation
; CHECK-NEXT: br label %11

; CHECK: <label>:11:
; CHECK-NEXT: %{{[0-9]+}} = load i1, i1* @__csi_disable_instrumentation
; CHECK-NEXT: %{{[0-9]+}} = icmp eq i1 %{{[0-9]+}}, false
; CHECK-NEXT: br i1 %{{[0-9]+}}, label %14, label %15

; CHECK: <label>:14:
; CHECK-NEXT: store i1 true, i1* @__csi_disable_instrumentation
; CHECK-NEXT: call void @__csi_bb_exit(i64 %{{[0-9]+}}, { i1, i63 } zeroinitializer)
; CHECK-NEXT: store i1 false, i1* @__csi_disable_instrumentation
; CHECK-NEXT: br label %15

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Top-level:

; CHECK: declare void @__csi_bb_entry(i64, { i1, i63 })
; CHECK: declare void @__csi_bb_exit(i64, { i1, i63 })
