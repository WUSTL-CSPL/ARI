#define ASSEMBLY

.section .trampoline_fw , "axw"

.global __trampoline_fw_blx
.global __trampoline_fw_bx
.global __trampoline_bkwd_bx
.global	__trampoline_bkwd_pop
.global __error
.global __AMI_fake_direct_transfer
.global __AMI_fake_indirect_transfer
.global __AMI_fake_rt_transfer
.global __tsf_direct_jmp_checking
.global __tsf_direct_jmp_link_checking
.global __tsf_indirect_jmp_checking
.global __tsf_indirect_jmp_link_checking
.global __tsf_bkwd_bx_lr_checking
.global __tsf_bkwd_pop_pc_checking
.global __storing_checking
.global __tsf_test


__trampoline_fw_blx:
	sub sp, sp, #12          @saving r0, r1, spsr
	str r0, [sp, #0]
	str r1, [sp, #4]
	mrs r0, apsr 
	str r0, [sp, #8]
	movw r1,#0xffff
	movt r1,#0xffff
	ldr r0, .curr_cpt_id
	cmp r1,r0
	beq __trampoline_fw_blx_update
__trampoline_fw_blx_ok:
	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __error
	ldr r0, [sp, #8]
	msr apsr, r0
	ldr r0, [sp, #0] 		@restoring r0, r1
	ldr r1, [sp, #4]
	add sp, sp, #12
	bx r8 					@jumping to target

__trampoline_fw_blx_update:
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {lr}
	
	bl __fwd_update

	pop	 {lr}
	pop  {r3}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	ldr r0, .curr_cpt_id
	b	__trampoline_fw_blx_ok

__trampoline_fw_bx:
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	
	movw r1,#0xffff
	movt r1,#0xffff
	ldr r0, .curr_cpt_id
	cmp r1,r0
	beq __trampoline_fw_bx_update
__trampoline_fw_bx_ok: 

	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __error
	ldr r0, [sp, #8]
	msr apsr, r0
	ldr r0, [sp, #0] 		@restoring r0, r1
	ldr r1, [sp, #4]
	add sp, sp, #12
	bx r8 					@jumping to target

__trampoline_fw_bx_update:
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {lr}
	
	bl __fwd_update

	pop	 {lr}
	pop  {r3}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	ldr r0, .curr_cpt_id
	b	__trampoline_fw_bx_ok

__trampoline_bkwd_bx:
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __trampoline_bkwd_bx__error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __trampoline_bkwd_bx__error
__trampoline_bkwd_bx_ok:
	ldr r0, [sp, #8]
	msr apsr, r0
	ldr r0, [sp, #0] 		@restoring r0, r1
	ldr r1, [sp, #4]
	add sp, sp, #12
	@pop {lr} 				@restoring lr
	mov lr, r8
	bx r8 					@jumping to target

__trampoline_bkwd_bx__error:
	push {r0}
	push {r1}
	push {r2}
	push {lr}
	
	bl __bkwd__error

	pop	 {lr}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	b	__trampoline_bkwd_bx_ok



__trampoline_bkwd_pop:
	@pop {r8}
	ldr r8, [sp]
	mov lr, r8
	ldr r8, [sp, #4]
	add sp, sp, #8
	@bx r8
	@debug ending
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __trampoline_bkwd_pop__error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __trampoline_bkwd_pop__error
__trampoline_bkwd_pop_ok:
	ldr r0, [sp, #8]
	msr apsr, r0
	ldr r0, [sp, #0] 		@restoring r0, r1
	ldr r1, [sp, #4]
	add sp, sp, #12 @yujie
	bx r8 					@jumping to target


__trampoline_bkwd_pop__error:
	push {r0}
	push {r1}
	push {r2}
	push {lr}
	
	bl __bkwd__error

	pop	 {lr}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	b	__trampoline_bkwd_pop_ok

__AMI_fake_direct_transfer:
	nop

__AMI_fake_indirect_transfer:
	nop

__AMI_fake_rt_transfer:
	nop

__AMI_fake_pop_pc_transfer:
	nop

__error:
	b error_found
@-----------------------------------------------------------------
@compartment transfer BL
__tsf_direct_jmp_link_checking:
	@bx r8
	@saving context
	sub sp, sp, #20
	str r0, [sp]
	str r1, [sp, #4]
	str r2, [sp, #8]
	str r3, [sp, #12]
	mrs r0, apsr 
	str r0, [sp, #16]
	@checking compartment transfering
	movw r1,#0xffff
	movt r1,#0xffff
	ldr r0, .curr_cpt_id
	cmp r1,r0
	beq __tsf_direct_jmp_link_checking_update
__tsf_direct_jmp_link_checking_ok:
	mov r1, #8
	mul r1, r0, r1		@get first entity offset of current compartment
	ldr r2, =.cpt_direct_transfer_tb
	add r1, r1, r2 		@get address of current compartment metadata r1
	
	ldr r0, .total_cpt_cnt
	mov r2, #8
	mul r0, r0, r2		
	ldr r2, =.cpt_direct_transfer_tb
	add r0, r2, r0 		@get first entity address r0

	ldr r2, [r1]		@compartment offset
	add r2, r2, r0      @current compartment first entity address

	ldr r1, [r1, #4]    @current compartment total entity account

	mov r3, #0 			@loop index
direct_link_cpt_ck_loop:
	
	cmp r3, r1
	bge direct_link_cpt_ck_fail

	mov r0, #8
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0] 		@load possible target address

	cmp r8, r0
	beq direct_link_cpt_ck_pass
	
	add r3, r3, #1
	b direct_link_cpt_ck_loop

direct_link_cpt_ck_fail:
	@modifying next compartment id
	@restoring context
@	b direct_link_cpt_ck_pass @this is for prototype
	b __error

direct_link_cpt_ck_pass: @yujie
	
	@add next cpt id on to cpt stack
	ldr r0, =.cpt_stack
	ldr r1, .curr_cpt_stack_pointer_offset
	add r0, r0, r1
	@modify cpt stack pointer offset
	add r1, #8
	str r1, .curr_cpt_stack_pointer_offset @update current stack pointer offset

	ldr r1, .curr_cpt_id
	str r1, [r0]
	@add return address on to cpt stack
	add r0, #4
	str lr, [r0]

	mov r0, #8 			 @modifying current compartment id 
	@yujie	sub r3, r3, #1
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0, #4]
	ldr r1, =.curr_cpt_id
	str r0, [r1]
	
	ldr r0, [sp, #16]
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	add sp, sp, #20
	bx r8


__tsf_direct_jmp_link_checking_update:
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {lr}
	
	bl __fwd_update

	pop	 {lr}
	pop  {r3}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	ldr r0, .curr_cpt_id
	b	__tsf_direct_jmp_link_checking_ok

__fwd_update:
	ldr r3,[sp,#0]
	mov r1,#8
	ldr r0, .total_cpt_cnt
	mul r0, r0, r1
	ldr r1, =.cpt_tb
	add r0,r0,r1
	
__fwd_update_loop:
	ldr r2,[r1]
	cmp r3,r2
	bcc __fwd_update_loop_next
	ldr r2,[r1,#4]
	cmp r2,r3
	bcc __fwd_update_loop_next	
	b __fwd_update_loop_done

__fwd_update_loop_next:
	add r1,r1,#8
	cmp r1,r0
	bcc __fwd_update_loop
	b __error
__fwd_update_loop_done:
	ldr r2, =.cpt_tb
	sub r2, r1,r2
	asrs r2, r2,#3
	ldr r0, =.curr_cpt_id
	str r2,[r0]
	bx lr
@-----------------------------------------------------------------
@compartment transfer B
__tsf_direct_jmp_checking:
	@saving context
	sub sp, sp, #20
	str r0, [sp]
	str r1, [sp, #4]
	str r2, [sp, #8]
	str r3, [sp, #12]
	mrs r0, apsr 
	str r0, [sp, #16]

	@checking compartment transfering
	movw r1,#0xffff
	movt r1,#0xffff
	ldr r0, .curr_cpt_id
	cmp r1,r0
	beq __tsf_direct_jmp_checking_update
__tsf_direct_jmp_checking_ok:
	mov r1, #8
	mul r1, r0, r1		@get first entity offset of current compartment
	ldr r2, =.cpt_direct_transfer_tb
	add r1, r1, r2 		@get address of current compartment metadata r1
	
	ldr r0, .total_cpt_cnt
	mov r2, #8
	mul r0, r0, r2		
	ldr r2, =.cpt_direct_transfer_tb
	add r0, r2, r0 		@get first entity address r0

	ldr r2, [r1]		@compartment offset
	add r2, r2, r0      @current compartment first entity address

	ldr r1, [r1, #4]    @current compartment total entity account

	mov r3, #0 			@loop index
direct_cpt_ck_loop:
	
	cmp r3, r1
	bge direct_cpt_ck_fail

	mov r0, #8
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0] 		@load possible target address

	cmp r8, r0
	beq direct_cpt_ck_pass
	
	add r3, r3, #1
	b direct_cpt_ck_loop

direct_cpt_ck_fail:
	@modifying next compartment id
	@restoring context
@	b direct_link_cpt_ck_pass @this is for prototype
	b __error

direct_cpt_ck_pass:
	mov r0, #8 			 @modifying current compartment id 
@yujie	sub r3, r3, #1
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0, #4]
	ldr r1, =.curr_cpt_id
	str r0, [r1]

	ldr r0, [sp, #16]
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	add sp, sp, #20
	bx r8


__tsf_direct_jmp_checking_update:
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {lr}
	
	bl __fwd_update

	pop	 {lr}
	pop  {r3}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	ldr r0, .curr_cpt_id
	b	__tsf_direct_jmp_checking_ok

@-----------------------------------------------------------------

__tsf_test:
	bx lr

@BXL
__tsf_indirect_jmp_link_checking:
@check according to .cpt_indirect_transfer_tb
	@saving context
	sub sp, sp, #20
	str r0, [sp]
	str r1, [sp, #4]
	str r2, [sp, #8]
	str r3, [sp, #12]
	mrs r0, apsr 
	str r0, [sp, #16]

	@checking compartment transfering

	movw r1,#0xffff
	movt r1,#0xffff
	ldr r0, .curr_cpt_id
	cmp r1,r0
	beq __tsf_indirect_jmp_link_checking_update
__tsf_indirect_jmp_link_checking_ok:
	mov r1, #8
	mul r1, r0, r1		@get first entity offset of current compartment
	ldr r2, =.cpt_indirect_transfer_tb
	add r1, r1, r2 		@get address of current compartment metadata r1
	
	ldr r0, .total_cpt_cnt
	mov r2, #8
	mul r0, r0, r2		
	ldr r2, =.cpt_indirect_transfer_tb
	add r0, r2, r0 		@get first entity address r0

	ldr r2, [r1]		@compartment offset
	add r2, r2, r0      @current compartment first entity address

	ldr r1, [r1, #4]    @current compartment total entity account

	mov r3, #0 			@loop index

indirect_link_cpt_ck_loop:	
	cmp r3, r1
	bge indirect_link_cpt_ck_fail

	mov r0, #8
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0] 		@load possible target addresses

	cmp r8, r0
	beq indirect_link_cpt_ck_pass
	
	add r3, r3, #1
	b indirect_link_cpt_ck_loop

indirect_link_cpt_ck_fail:

    ldr r1, =.curr_cpt_id  @ simulate overhead starts
    ldr r2, [r1]           @ new r2 is current compartment id
    @str r0, [r1]      	   @ r0 is next compartment id

    mov r1, r2             @ new r1 is current compartment id
    mov r2, #6             @ new 6 is cptment transfer type


    push {lr, r8}
	bl view_switch_to_rd_and_log
	pop {r8, lr}		 @ simulate overhead ends


	@modifying next compartment id
	@b indirect_link_cpt_ck_pass	@this is for prototype
	b indirect_link_internal_sfi
	@b cpt_ck_pass @this is for prototype

indirect_link_cpt_ck_pass:@yujie


	@add next cpt id on to cpt stack
	ldr r0, =.cpt_stack
	ldr r1, .curr_cpt_stack_pointer_offset
	add r0, r0, r1
	@modify cpt stack pointer offset
	@commend here
	add r1, #8
	str r1, .curr_cpt_stack_pointer_offset @update current stack pointer offset

	ldr r1, .curr_cpt_id
	str r1, [r0]
	@add return address on to cpt stack
	add r0, #4
	str lr, [r0]

	mov r0, #8 			@modifying current compartment id
@yujie	sub r3, r3, #1
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0, #4]
	ldr r1, =.curr_cpt_id
	@str r0, [r1]       @commend because of record compartment transfer


	@record compartment transfer
   
    ldr r2, [r1]         @ new r2 is current compartment id
    str r0, [r1]      	 @ r0 is next compartment id

    mov r1, r2           @ new r1 is current compartment id
    mov r2, #6           @ new 6 is cptment transfer type

    push {lr, r8}
    @bl view_switch_to_rd_and_log @ new
    bl view_switch_to_rd_and_log
    pop {r8, lr}	

    @record compartment transfer end

	ldr r0, [sp, #16]
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	add sp, sp, #20
	bx r8

indirect_link_internal_sfi:

	

	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __error
	ldr r0, [sp, #16]		@contaxt restoring
	msr apsr, r0
	ldr r0, [sp] 			
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	add sp, sp, #20
							@add sp, sp, #8
	bx r8 					@jumping to target
@check according to .cpt_tb

__tsf_indirect_jmp_link_checking_update:
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {lr}
	
	bl __fwd_update
	
	pop	 {lr}
	pop  {r3}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	ldr r0, .curr_cpt_id
	b	__tsf_indirect_jmp_link_checking_ok

@-----------------------------------------------------------
@BX
__tsf_indirect_jmp_checking:
@check according to .cpt_indirect_transfer_tb
	@saving context
	sub sp, sp, #20
	str r0, [sp]
	str r1, [sp, #4]
	str r2, [sp, #8]
	str r3, [sp, #12]
	mrs r0, apsr 
	str r0, [sp, #16]

	@checking compartment transfering

	movw r1,#0xffff
	movt r1,#0xffff
	ldr r0, .curr_cpt_id
	cmp r1,r0
	beq __tsf_indirect_jmp_checking_update
__tsf_indirect_jmp_checking_ok:
	mov r1, #8
	mul r1, r0, r1		@get first entity offset of current compartment
	ldr r2, =.cpt_indirect_transfer_tb
	add r1, r1, r2 		@get address of current compartment metadata r1
	
	ldr r0, .total_cpt_cnt
	mov r2, #8
	mul r0, r0, r2		
	ldr r2, =.cpt_indirect_transfer_tb
	add r0, r2, r0 		@get first entity address r0

	ldr r2, [r1]		@compartment offset
	add r2, r2, r0      @current compartment first entity address

	ldr r1, [r1, #4]    @current compartment total entity account

	mov r3, #0 			@loop index

indirect_cpt_ck_loop:	
	cmp r3, r1
	bge indirect_cpt_ck_fail

	mov r0, #8
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0] 		@load possible target addresses

	cmp r8, r0
	beq indirect_cpt_ck_pass
	
	add r3, r3, #1
	b indirect_cpt_ck_loop

indirect_cpt_ck_fail:
	@modifying next compartment id
@	b indirect_cpt_ck_pass	@this is for prototype
	b indirect_internal_sfi
	@b cpt_ck_pass @this is for prototype

indirect_cpt_ck_pass:
	mov r0, #8 			@modifying current compartment id
@yujie	sub r3, r3, #1
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0, #4]
	ldr r1, =.curr_cpt_id
	str r0, [r1]	

	ldr r0, [sp, #16]		@contaxt restoring
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	add sp, sp, #20
	bx r8

indirect_internal_sfi:
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __error
	ldr r0, [sp, #16]		@contaxt restoring
	msr apsr, r0		
	ldr r0, [sp] 			
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	add sp, sp, #20
							@add sp, sp, #8
	bx r8 					@jumping to target

__tsf_indirect_jmp_checking_update:
	push {r0}
	push {r1}
	push {r2}
	push {r3}
	push {lr}
	
	bl __fwd_update

	pop	 {lr}
	pop  {r3}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	ldr r0, .curr_cpt_id
	b	__tsf_indirect_jmp_checking_ok

@--------------------------------------------------------------

@backwards bx lr transfer checking
__tsf_bkwd_bx_lr_checking:
	@saving context
	sub sp, sp, #12
	str r0, [sp]
	str r1, [sp, #4]
	mrs r0, apsr 
	str r0, [sp, #8]
	@check stack
	ldr r0, =.cpt_stack
	ldr r1, .curr_cpt_stack_pointer_offset
	add r0, r1, r0 			@calculate current stack pointer address	
	sub r0, r0, #4
	ldr r0, [r0]
	cmp r8, r0 				@compare return target with return address stored on cpt stack
	beq __tsf_bkwd_bx_lr_pass
	@restoring context
	ldr r0, [sp, #8]		@contaxt restoring
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr lr, [sp, #12]		@restoring lr
	add sp, sp, #16
	@jump to bkwd indirect checking
	@this function needs two versions, one for bx lr, one for pop return 
	b __tsf_trampoline_bkwd_bx

__tsf_bkwd_bx_lr_pass:
	sub r1, r1, #8
	ldr r0, =.curr_cpt_stack_pointer_offset
	str r1, [r0] 			@update .curr_cpt_stack_pointer_offset
	ldr r0, =.cpt_stack
	add r1, r1, r0
	ldr r0, [r1]
	ldr r1, =.curr_cpt_id
	str r0, [r1]			@update current_cpt_id to cpt id stored on stack
	@restoring context
	ldr r0, [sp, #8]		
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr lr, [sp, #12]
	add sp, sp, #16
	bx r8

__tsf_trampoline_bkwd_bx:
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __tsf_trampoline_bkwd_bx__error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __tsf_trampoline_bkwd_bx__error
__tsf_trampoline_bkwd_bx_ok:	
	ldr r0, [sp, #8]
	msr apsr, r0
	ldr r0, [sp, #0] 		@restoring r0, r1
	ldr r1, [sp, #4]
	add sp, sp, #12
	bx r8 					@jumping to target

__tsf_trampoline_bkwd_bx__error:
	push {r0}
	push {r1}
	push {r2}
	push {lr}
	
	bl __bkwd__error

	pop	 {lr}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	b	__tsf_trampoline_bkwd_bx_ok
@------------------------------------------------------------------

@backwards pop return transfer checking
__tsf_bkwd_pop_pc_checking:
	ldr r8, [sp, #4]
	@pop {r8}
	@saving context
	sub sp, sp, #12
	str r0, [sp]
	str r1, [sp, #4]
	mrs r0, apsr 
	str r0, [sp, #8]
	@check stack
	ldr r0, =.cpt_stack
	ldr r1, .curr_cpt_stack_pointer_offset
	add r0, r1, r0 			@calculate current stack pointer address	
	sub r0, r0, #4
	ldr r0, [r0]
	cmp r8, r0 				@compare return target with return address stored on cpt stack
	beq __tsf_bkwd_pop_pc_pass
	@restoring context
	ldr r0, [sp, #8]		
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	add sp, sp, #12
	pop {lr} 					@restore lr
	@add sp, sp, #4
	@jump to bkwd indirect checking
	@this function needs two versions, one for bx lr, one for pop return 
	b __tsf_trampoline_bkwd_pop

__tsf_bkwd_pop_pc_pass:
	sub r1, r1, #8
	ldr r0, =.curr_cpt_stack_pointer_offset
	str r1, [r0] 			@update .curr_cpt_stack_pointer_offset
	ldr r0, =.cpt_stack
	add r1, r1, r0
	ldr r0, [r1]
	ldr r1, =.curr_cpt_id
	str r0, [r1]			@update current_cpt_id to cpt id stored on stack
	@restoring context
	ldr r0, [sp, #8]		
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	add sp, sp, #12
	pop {lr}
	add sp, sp, #4
	bx r8

__tsf_trampoline_bkwd_pop:
	pop {r8}
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #8
	mul r0, r0, r1 			@calculating offset of cpt base addr on cpt_table
	ldr r1, =.cpt_tb
	add r1, r1, r0 			@calculating addr of cpt base address
	ldr r1, [r1]
	cmp r8, r1 				@check target addr with cpt base address
	bcc __tsf_trampoline_bkwd_pop__error	
	add r0, r0, #4 			@calculating addr of cpt up bound address
	ldr r1, =.cpt_tb
	add r1, r1, r0
	ldr r1, [r1] 			
	cmp r1, r8 				@check target addr with cpt upbound address
	bcc __tsf_trampoline_bkwd_pop__error
__tsf_trampoline_bkwd_pop_ok:
	ldr r0, [sp, #8]
	msr apsr, r0
	ldr r0, [sp, #0] 		@restoring r0, r1
	ldr r1, [sp, #4]
	add sp, sp, #12
	bx r8 					@jumping to target


__tsf_trampoline_bkwd_pop__error:
	push {r0}
	push {r1}
	push {r2}
	push {lr}
	
	bl __bkwd__error

	pop	 {lr}
	pop	 {r2}
	pop	 {r1}
	pop	 {r0}
	b	__tsf_trampoline_bkwd_pop_ok

__bkwd__error:	@manipulate r0,r1,r2, address in r8
	
	ldr r0, .curr_cpt_id
	movw r1,#0xffff
	movt r1,#0xffff
	cmp r1,r0
	beq __bkwd__error_loop_ok

	mov r1,#8
	ldr r0, .total_cpt_cnt
	mul r0, r0, r1
	ldr r1, =.cpt_tb
	add r0,r0,r1
	
__bkwd__error_loop:
	ldr r2,[r1]
	cmp r8,r2
	bcc __bkwd__error_loop_next
	ldr r2,[r1,#4]
	cmp r2,r8
	bcc __bkwd__error_loop_next

	b __error

__bkwd__error_loop_next:
	add r1,r1,#8
	cmp r1,r0
	bcc __bkwd__error_loop
__bkwd__error_loop_ok:
	ldr r0, =.curr_cpt_id
	movw r1,#0xffff
	movt r1,#0xffff
	str r1,[r0]
	bx lr



@------------------------SFI Storing Checking---------------------------

//TODO handle conditional str instruction
__storing_checking:
	
@context saving
	sub sp, sp, #24
	str r0, [sp]
	str r1, [sp, #4]
	str r2, [sp, #8]
	str r3, [sp, #12]
	str r4, [sp, #16]
	mrs r0, apsr 
	str r0, [sp, #20]
	
@checkig store target address range
	ldr r0, .curr_cpt_id
	mov r1, #8
	mul r1, r0, r1		@get first address range offset of current compartment
	ldr r2, =.cpt_dt_wt_access_tb
	add r1, r1, r2 		@get address of current compartment metadata r1
	
	ldr r0, .total_cpt_cnt
	mov r2, #8
	mul r0, r0, r2		
	ldr r2, =.cpt_dt_wt_access_tb
	add r0, r2, r0 		@get first address range address r0

	ldr r2, [r1]		@compartment offset
	add r2, r2, r0      @current compartment first entity address

	ldr r1, [r1, #4]    @current compartment total entity account

	mov r3, #0 			@loop index

	mov r4, #0 			@address range valid flag

storing_ck_loop:	
	cmp r3, r1
	@bge storing_ck_fail
	bge storing_ck_valid

	mov r0, #8
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0] 		@load addrese range base address
	cmp r8, r0
	bcc storing_loop_next @less without sign

	mov r0, #8
	mul r0, r3, r0
	add r0, r0, r2
	add r0, #4
	ldr r0, [r0]
	cmp r8, r0
	bhi storing_loop_next @larger without sign
	mov r4, #1
 	b storing_ck_pass
	@beq indirect_cpt_ck_pass
	
storing_loop_next:
	add r3, r3, #1
	b storing_ck_loop

storing_ck_valid:
	cmp r4, #0
	beq storing_ck_fail
	b storing_ck_pass

storing_ck_fail:
	@modifying next compartment id
	b storing_ck_pass	@this is for prototype
	b __error

storing_ck_pass:
	ldr r0, [sp, #32] 	@instruction id
	ldr r1, [sp, #28] 	@str value
    movw r2, #447                        
	cmp r0, r2 		@STRBi12   = 447
	beq STRBi12
	movw r2, #471
	cmp r0, r2 		@STRi12    = 471,
	beq STRi12

storing_ctx_restoring:
	ldr r0, [sp, #20]		@contaxt restoring
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	ldr r4, [sp, #16]
	add sp, sp, #24
@context restoring
	bx lr

STRBi12: 
strb r1, [r8]
b storing_ctx_restoring

STRi12:
str r1, [r8]
b storing_ctx_restoring
@---------------------------------------------------------------------




@current compartment stack stack pointer
@compartment stack grows from low address to high address
.curr_cpt_stack_pointer_offset:
	.word 0x00000000


@---------------compartment shadow stack--------------------
@compartment shadow stack is organized as follows
@...
@return address (higher address)
@cpt id 		(lower address)
@...
.cpt_stack:
.skip 50*8	







.curr_cpt_id:
	.word 566
.total_cpt_cnt:
	.word 927
.section .AMI_SFI_Metadata , "awx"



.cpt_dt_wt_access_tb:
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0x1
	.word 0x0
	.word 0xffffffff
