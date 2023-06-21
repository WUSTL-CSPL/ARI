#define ASSEMBLY

.section .trampoline , "ax"

.global __cfv_icall
.global __cfv_icall_blx
.global __cfv_icall_blx_pre
.global __cfv_icall_cond_dirbranch
.global __cfv_icall_ldmia_ret
.global __cfv_ijmp
.global __cfv_ret

__cfv_icall:
	sub sp, sp, #128
	str r0, [sp, #0]
	str r1, [sp, #8]
	str r2, [sp, #16]
	str r3, [sp, #24]
	str r4, [sp, #32]
	str r5, [sp, #40]
	str r6, [sp, #48]
	str r7, [sp, #56]
	str r8, [sp, #64]
	str r9, [sp, #72]
	str r10, [sp, #80]
	str r11, [sp, #88]
	str r12, [sp, #96]
	str r13, [sp, #104]
	str r14, [sp, #112]
	mrs r4, cpsr
	str r4, [sp, #120]
	bl view_switch_to_rd_and_log
	ldr r4, [sp, #120]
	msr cpsr, r4
	ldr r0, [sp, #0]
	ldr r1, [sp, #8]
	ldr r2, [sp, #16]
	ldr r3, [sp, #24]
	ldr r4, [sp, #32]
	ldr r5, [sp, #40]
	ldr r6, [sp, #48]
	ldr r7, [sp, #56]
	ldr r8, [sp, #64]
	ldr r9, [sp, #72]
	ldr r10, [sp, #80]
	ldr r11, [sp, #88]
	ldr r12, [sp, #96]
	ldr r13, [sp, #104]
	ldr r14, [sp, #112]
	add sp, sp, #128
	mov pc,lr


__cfv_icall_blx:
	push {lr}
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	mov r0, lr
	bl cfv_icall_blx
	pop {r3}
	pop {r2}
	pop {r1}
	pop {r0}
	pop {pc}


__cfv_icall_blx_pre:
	push {lr, r0, r1, r2, r3}
	mov r0, lr
	bl cfv_icall_blx_pre
	pop {r3, r2, r1, r0, pc}


__cfv_icall_cond_dirbranch:
	push {lr, r0, r1, r2, r3}
    mov r0, lr
    bl cfv_icall_bc_blc
	pop {r3, r2, r1, r0, pc}


__cfv_icall_ldmia_ret:
	push {lr, r0, r1, r2, r3}
	mov r0, lr
	bl cfv_icall_ldmia_ret
	pop {lr, r3, r2, r1, r0}
	