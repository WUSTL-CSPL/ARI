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
.global __AMI_fake_local_wrt
.global __AMI_fake_shared_wrt
.global __tsf_direct_jmp_checking
.global __tsf_direct_jmp_recording
.global __tsf_direct_jmp_cc_recording
.global __tsf_direct_jmp_link_checking
.global __tsf_direct_jmp_link_recording
.global __tsf_direct_jmp_link_cc_recording
.global __tsf_indirect_jmp_checking
.global __tsf_indirect_jmp_recording
.global __tsf_indirect_jmp_link_checking
.global __tsf_indirect_jmp_link_recording
.global __tsf_bkwd_bx_lr_checking
.global __tsf_bkwd_bx_lr_recording
.global __tsf_bkwd_pop_pc_checking
.global __tsf_bkwd_pop_pc_recording
.global __storing_checking
.global __tsf_test


__trampoline_fw_blx:
	sub sp, sp, #12          @saving r0, r1, spsr
	str r0, [sp, #0]
	str r1, [sp, #4]
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #4
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


__trampoline_fw_bx:
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #4
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

__trampoline_bkwd_bx_t:
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #4
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
	@pop {lr} 				@restoring lr
	mov lr, r8
	bx r8 					@jumping to target

__trampoline_bkwd_bx:
	mov lr, r8
	bx r8


__trampoline_bkwd_pop:
	@pop {r8}
	ldr r8, [sp]
	mov lr, r8
	ldr r8, [sp, #4]
	@add sp, sp, #8
	@bx r8
	@debug ending
	sub sp, sp, #12          @saving r0, r1
	str r0, [sp, #0]
	str r1, [sp, #4] 
	mrs r0, apsr 
	str r0, [sp, #8]
	ldr r0, .curr_cpt_id	@loading current compartment 
	mov r1, #4
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
	add sp, sp, #20
	bx r8 					@jumping to target

__AMI_fake_direct_transfer:
	nop

__AMI_fake_indirect_transfer:
	nop

__AMI_fake_rt_transfer:
	nop

__AMI_fake_local_wrt:
	nop

__AMI_fake_shared_wrt:
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
	ldr r0, .curr_cpt_id
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
	b direct_link_cpt_ck_pass @this is for prototype
	b __error

direct_link_cpt_ck_pass:
	mov r0, #8 			 @modifying current compartment id 
	sub r3, r3, #1
	mul r0, r3, r0
	add r0, r0, r2
	ldr r0, [r0, #4]
	ldr r1, =.curr_cpt_id
	str r0, [r1]
	
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

	ldr r0, [sp, #16]
	msr apsr, r0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	ldr r3, [sp, #12]
	add sp, sp, #20
	bx r8


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
	ldr r0, .curr_cpt_id
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
	b direct_link_cpt_ck_pass @this is for prototype
	b __error

direct_cpt_ck_pass:
	mov r0, #8 			 @modifying current compartment id 
	sub r3, r3, #1
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


@-----------------------------------------------------------------


__tsf_direct_jmp_link_recording:
	push {lr, r0, r1, r2, r3}
	mov r0, lr
	blx c_direct_tsf_recording
	pop {lr, r3, r2, r1, r0}
	bx lr

__tsf_direct_jmp_link_cc_recording:
	push {lr, r0, r1, r2, r3}
	mrs r0, cpsr
	push {r0}
	mov r0, lr
	blx c_direct_tsf_cc_recording
	pop {r0}
	msr cpsr, r0
	pop {lr, r3, r2, r1, r0}
	bx lr

__tsf_direct_jmp_recording:
	bx lr

__tsf_direct_jmp_cc_recording:
	push {lr, r0, r1, r2, r3}
	mrs r0, cpsr
	push {r0}
	mov r0, lr
	blx c_direct_tsf_bcc_recording
	pop {r0}
	msr cpsr, r0
	pop {lr, r3, r2, r1, r0}
	bx lr

__tsf_indirect_jmp_link_recording:
	push {lr, r0, r1, r2, r3}
	mov r0, lr
	blx c_indirect_tsf_recording
	pop {lr, r3, r2, r1, r0}
	bx r8          

__tsf_indirect_jmp_link_cc_recording:
	bx lr


__tsf_indirect_jmp_recording:
	bx r8

__tsf_indirect_jmp_cc_recording:
	bx lr


__tsf_bkwd_bx_lr_recording:
	push {lr, r0, r1, r2, r3}
	mov r0, lr
	blx c_tsf_bx_lr_recording
	pop {lr, r3, r2, r1, r0}
	bx r8


__tsf_bkwd_pop_pc_recording:
	push {lr, r0, r1, r2, r3}
	mov r0, lr
	blx c_tsf_pop_pc_recording
	pop {lr, r3, r2, r1, r0}
	bx r8

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

	ldr r0, .curr_cpt_id
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

indirect_link_cpt_ck_pass:
	mov r0, #8 			@modifying current compartment id
	sub r3, r3, #1
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
	mov r1, #4
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

	ldr r0, .curr_cpt_id
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
	b indirect_cpt_ck_pass	@this is for prototype
	b indirect_internal_sfi
	@b cpt_ck_pass @this is for prototype

indirect_cpt_ck_pass:
	mov r0, #8 			@modifying current compartment id
	sub r3, r3, #1
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
	mov r1, #4
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
	mov r1, #4
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
	mov r1, #4
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

@.curr_cpt_id save current running compartment id
.curr_cpt_id:
	.word 0x00000000

@total number of compartment
.total_cpt_cnt:
	.word 0x3


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


.section .AMI_SFI_Metadata , "a"
@=============TODO==============
@generate folloing 




@.cpt_tb is organized as 
@cpt1_base_addr
@cpt1_upbound_addr
@cpt2_base_addr
@cpt2_upbound_addr
@...
@cptn_base_addr
@cptn_upbound_addr

.cpt_tb:
	.word 0x00000000
	.word 0xffffffff
	.word 0x00000000
	.word 0xffffffff
	.word 0x00000000
	.word 0xffffffff
	.word 0x00000000
	.word 0xffffffff

@cpt_direct_transfer_tab is organized as
@first cpt0 entity offset, cpt0 number of entities
@first cpt1 entity offset, cpt1 number of entities
@...
@first cpt2 entity offset, cptn number of entities
@-------------------------------------------------
@cpt0 valid target function entry0, target cpt id
@cpt0 valid target function entry1, target cpt id
@...
@cpt1 valid target function entry0, target cpt id
@cpt1 valid target function entry1, target cpt id
@...
@cptn valid target function entry0, target cpt id
@cptn valid target function entry1, target cpt id


.cpt_direct_transfer_tb:
@-----------cpt_direct_transfer_tb route map---------
	.word 0x0  @first cpt0 entity offset 
	.word 0x4  @cpt0 number of entities
	.word 0x20 @first cpt1 entity offset
	.word 0x4  @cpt1 number of entities
	.word 0x40 @first cpt2 entity offset
	.word 0x4  @cpt2 number of entities  
	.word 0x00000000 @cpt0 entry0 addr
	.word 0x0 		 @cpt0 entry0 target cpt id
	.word 0x00000001 @cpt0 entry1 addr
	.word 0x0        @cpt0 entry1 target cpt id
	.word 0x00000002 @cpt0 entry2 addr
	.word 0x0	     @cpt0 entry2 target cpt id
	.word 0x00000003 @cpt0 entry3 addr
	.word 0x0        @cpt0 entry3 target cpt id


@cpt_indirect_transfer_tab is organized as
@first cpt0 entity offset, cpt0 number of entities
@first cpt1 entity offset, cpt1 number of entities
@...
@first cpt2 entity offset, cptn number of entities
@-------------------------------------------------
@cpt0 valid cross cpt target function entry0, target cpt id
@cpt0 valid cross cpt target function entry1, target cpt id
@...
@cpt1 valid cross cpt target function entry0, target cpt id
@cpt1 valid cross cpt target function entry1, target cpt id
@...
@cptn valid cross cpt target function entry0, target cpt id
@cptn valid cross cpt target function entry1, target cpt id
.cpt_indirect_transfer_tb:
	.word 0x0  @first cpt0 entity offset 
	.word 0x4  @cpt0 number of entities
	.word 0x20 @first cpt1 entity offset
	.word 0x4  @cpt1 number of entities
	.word 0x40 @first cpt2 entity offset
	.word 0x4  @cpt2 number of entities  
	.word 0x00000000 @cpt0 entry0 addr
	.word 0x0 		 @cpt0 entry0 target cpt id
	.word 0x00000001 @cpt0 entry1 addr
	.word 0x0        @cpt0 entry1 target cpt id
	.word 0x00000002 @cpt0 entry2 addr
	.word 0x0	     @cpt0 entry2 target cpt id
	.word 0x00000003 @cpt0 entry3 addr
	.word 0x0        @cpt0 entry3 target cpt id

@----------------data access right table---------------------------
@data access right table is organized as follows
@first range of cpt0 offset in this table, number of entities of cpt0
@first range of cpt1 offset in this table, number of entities of cpt1
@first range of cpt2 offset in this table, number of entities of cpt2
@first range of cpt3 offset in this table, number of entities of cpt3
@cpt0 valid data range base address, cpt0 valid data range upbound address
@cpt0 valid data range base address, cpt0 valid data range upbound address
@...
@cpt1 valid data range base address, cpt1 valid data range upbound address
@cpt1 valid data range base address, cpt1 valid data range upbound address
@...
@cpt2 valid data range base address, cpt2 valid data range upbound address
@cpt2 valid data range base address, cpt2 valid data range upbound address
@stack access is also checked here
.cpt_dt_wt_access_tb:
	.word 0x0  @cpt0 first memory range offset 
	.word 0x4  @cpt0 number of available memory ranges
	.word 0x20 @cpt1 first memroy range offset
	.word 0x4  @cpt1 number of available memory ranges
	.word 0x40 @cpt2 first memory range offset
	.word 0x4  @cpt2 number of available memory ranges  
	.word 0x00000000 @cpt0 entry0 address range base
	.word 0xffffffff @cpt0 entry0 address range up-bound
	.word 0x00000001 @cpt0 entry1 address range base
	.word 0xffffffff @cpt0 entry1 address range up-bound
	.word 0x00000002 @cpt0 entry2 address range base
	.word 0xffffffff @cpt0 entry2 address range up-bound
	.word 0x00000003 @cpt0 entry3 address range base
	.word 0xffffffff @cpt0 entry3 address range up-bound

