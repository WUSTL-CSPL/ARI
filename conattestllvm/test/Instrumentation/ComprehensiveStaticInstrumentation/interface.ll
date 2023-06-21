; Test CSI interface declarations.
;
; RUN: opt < %s -csi -S | FileCheck %s

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

; CHECK: @__csi_unit_func_base_id = internal global i64 0
; CHECK: @__csi_unit_func_exit_base_id = internal global i64 0
; CHECK: @__csi_unit_bb_base_id = internal global i64 0
; CHECK: @__csi_unit_callsite_base_id = internal global i64 0
; CHECK: @__csi_unit_load_base_id = internal global i64 0
; CHECK: @__csi_unit_store_base_id = internal global i64 0
; CHECK: @__csi_disable_instrumentation = external thread_local externally_initialized global i1
; CHECK: @__csi_func_id_foo = weak global i64 -1
; CHECK: @__csi_func_id_main = weak global i64 -1
; CHECK: @__csi_unit_filename = private unnamed_addr constant [1 x i8] zeroinitializer
; CHECK: @0 = private unnamed_addr constant [8 x i8] c"<stdin>\00"
; CHECK: @llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @csirt.unit_ctor, i8* null }]

; CHECK: declare void @__csi_func_entry(i64, { i1, i63 })
; CHECK: declare void @__csi_func_exit(i64, i64, { i1, i63 })
; CHECK: declare void @__csi_before_load(i64, i8*, i32, { i1, i63 })
; CHECK: declare void @__csi_after_load(i64, i8*, i32, { i1, i63 })
; CHECK: declare void @__csi_before_store(i64, i8*, i32, { i1, i63 })
; CHECK: declare void @__csi_after_store(i64, i8*, i32, { i1, i63 })
; CHECK: declare void @__csi_bb_entry(i64, { i1, i63 })
; CHECK: declare void @__csi_bb_exit(i64, { i1, i63 })
; CHECK: declare void @__csi_before_call(i64, i64, { i1, i63 })
; CHECK: declare void @__csi_after_call(i64, i64, { i1, i63 })
; CHECK: define internal void @__csi_init_callsite_to_function()
; CHECK: define internal void @csirt.unit_ctor()
; CHECK-NEXT: call void @__csirt_unit_init(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @0, i32 0, i32 0), { i64, i64*, { i32, i8* }* }* getelementptr inbounds ([6 x { i64, i64*, { i32, i8* }* }], [6 x { i64, i64*, { i32, i8* }* }]* @__csi_unit_fed_tables, i32 0, i32 0), void ()* @__csi_init_callsite_to_function)
; CHECK-NEXT: ret void
; CHECK: declare void @__csirt_unit_init(i8*, { i64, i64*, { i32, i8* }* }*, void ()*)
