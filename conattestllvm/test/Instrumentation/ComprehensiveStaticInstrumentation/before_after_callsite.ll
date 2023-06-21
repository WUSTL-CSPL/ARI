; Test CSI before/after callsite instrumentation.
;
; RUN: opt < %s -csi -S | FileCheck %s

; CHECK: @__csi_unit_callsite_base_id = internal global i64 0
; CHECK: @__csi_disable_instrumentation = external thread_local externally_initialized global i1
; CHECK: @__csi_func_id_foo = weak global i64 -1

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

; CHECK: <label>:23
; CHECK-NEXT: %{{[0-9]+}} = load i64, i64* @__csi_unit_callsite_base_id
; CHECK-NEXT: %{{[0-9]+}} = add i64 %{{[0-9]+}}, 0
; CHECK-NEXT: %{{[0-9]+}} = load i64, i64* @__csi_func_id_foo
; CHECK-NEXT: %{{[0-9]+}} = load i1, i1* @__csi_disable_instrumentation
; CHECK-NEXT: %{{[0-9]+}} = icmp eq i1 %{{[0-9]+}}, false
; CHECK-NEXT: br i1 %{{[0-9]+}}, label %29, label %30

; CHECK: <label>:29:
; CHECK-NEXT: store i1 true, i1* @__csi_disable_instrumentation
; CHECK-NEXT: call void @__csi_before_call(i64 %{{[0-9]+}}, i64 %{{[0-9]+}}, { i1, i63 } zeroinitializer)
; CHECK-NEXT: store i1 false, i1* @__csi_disable_instrumentation
; CHECK: br label %30

; CHECK: <label>:30:
; CHECK-NEXT: %call = call i32 @foo()
; CHECK-NEXT: %{{[0-9]+}} = load i1, i1* @__csi_disable_instrumentation
; CHECK-NEXT: %{{[0-9]+}} = icmp eq i1 %{{[0-9]+}}, false
; CHECK: br i1 %{{[0-9]+}}, label %33, label %34

; CHECK: <label>:33:
; CHECK-NEXT: store i1 true, i1* @__csi_disable_instrumentation
; CHECK-NEXT: call void @__csi_after_call(i64 %{{[0-9]+}}, i64 %{{[0-9]+}}, { i1, i63 } zeroinitializer)
; CHECK-NEXT: store i1 false, i1* @__csi_disable_instrumentation
; CHECK-NEXT: br label %34

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Top-level:

; CHECK: declare void @__csi_before_call(i64, i64, { i1, i63 })
; CHECK: declare void @__csi_after_call(i64, i64, { i1, i63 })
