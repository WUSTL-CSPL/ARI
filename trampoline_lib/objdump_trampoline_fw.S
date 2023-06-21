
./trampoline_fw.o:     file format elf32-littlearm


Disassembly of section .trampoline_fw:

00000000 <__trampoline_fw_blx>:
   0:	e24dd00c 	sub	sp, sp, #12
   4:	e58d0000 	str	r0, [sp]
   8:	e58d1004 	str	r1, [sp, #4]
   c:	e10f0000 	mrs	r0, CPSR
  10:	e58d0008 	str	r0, [sp, #8]
  14:	e59f08dc 	ldr	r0, [pc, #2268]	; 8f8 <.curr_cpt_id>
  18:	e3a01004 	mov	r1, #4
  1c:	e0000190 	mul	r0, r0, r1
  20:	e59f1a6c 	ldr	r1, [pc, #2668]	; a94 <.cpt_stack+0x190>
  24:	e0811000 	add	r1, r1, r0
  28:	e5911000 	ldr	r1, [r1]
  2c:	e1580001 	cmp	r8, r1
  30:	3afffffe 	bcc	1c0 <__error>
  34:	e2800004 	add	r0, r0, #4
  38:	e59f1a54 	ldr	r1, [pc, #2644]	; a94 <.cpt_stack+0x190>
  3c:	e0811000 	add	r1, r1, r0
  40:	e5911000 	ldr	r1, [r1]
  44:	e1510008 	cmp	r1, r8
  48:	3afffffe 	bcc	1c0 <__error>
  4c:	e59d0008 	ldr	r0, [sp, #8]
  50:	e128f000 	msr	CPSR_f, r0
  54:	e59d0000 	ldr	r0, [sp]
  58:	e59d1004 	ldr	r1, [sp, #4]
  5c:	e28dd00c 	add	sp, sp, #12
  60:	e12fff18 	bx	r8

00000064 <__trampoline_fw_bx>:
  64:	e24dd00c 	sub	sp, sp, #12
  68:	e58d0000 	str	r0, [sp]
  6c:	e58d1004 	str	r1, [sp, #4]
  70:	e10f0000 	mrs	r0, CPSR
  74:	e58d0008 	str	r0, [sp, #8]
  78:	e59f0878 	ldr	r0, [pc, #2168]	; 8f8 <.curr_cpt_id>
  7c:	e3a01004 	mov	r1, #4
  80:	e0000190 	mul	r0, r0, r1
  84:	e59f1a08 	ldr	r1, [pc, #2568]	; a94 <.cpt_stack+0x190>
  88:	e0811000 	add	r1, r1, r0
  8c:	e5911000 	ldr	r1, [r1]
  90:	e1580001 	cmp	r8, r1
  94:	3afffffe 	bcc	1c0 <__error>
  98:	e2800004 	add	r0, r0, #4
  9c:	e59f19f0 	ldr	r1, [pc, #2544]	; a94 <.cpt_stack+0x190>
  a0:	e0811000 	add	r1, r1, r0
  a4:	e5911000 	ldr	r1, [r1]
  a8:	e1510008 	cmp	r1, r8
  ac:	3afffffe 	bcc	1c0 <__error>
  b0:	e59d0008 	ldr	r0, [sp, #8]
  b4:	e128f000 	msr	CPSR_f, r0
  b8:	e59d0000 	ldr	r0, [sp]
  bc:	e59d1004 	ldr	r1, [sp, #4]
  c0:	e28dd00c 	add	sp, sp, #12
  c4:	e12fff18 	bx	r8

000000c8 <__trampoline_bkwd_bx_t>:
  c8:	e24dd00c 	sub	sp, sp, #12
  cc:	e58d0000 	str	r0, [sp]
  d0:	e58d1004 	str	r1, [sp, #4]
  d4:	e10f0000 	mrs	r0, CPSR
  d8:	e58d0008 	str	r0, [sp, #8]
  dc:	e59f0814 	ldr	r0, [pc, #2068]	; 8f8 <.curr_cpt_id>
  e0:	e3a01004 	mov	r1, #4
  e4:	e0000190 	mul	r0, r0, r1
  e8:	e59f19a4 	ldr	r1, [pc, #2468]	; a94 <.cpt_stack+0x190>
  ec:	e0811000 	add	r1, r1, r0
  f0:	e5911000 	ldr	r1, [r1]
  f4:	e1580001 	cmp	r8, r1
  f8:	3afffffe 	bcc	1c0 <__error>
  fc:	e2800004 	add	r0, r0, #4
 100:	e59f198c 	ldr	r1, [pc, #2444]	; a94 <.cpt_stack+0x190>
 104:	e0811000 	add	r1, r1, r0
 108:	e5911000 	ldr	r1, [r1]
 10c:	e1510008 	cmp	r1, r8
 110:	3afffffe 	bcc	1c0 <__error>
 114:	e59d0008 	ldr	r0, [sp, #8]
 118:	e128f000 	msr	CPSR_f, r0
 11c:	e59d0000 	ldr	r0, [sp]
 120:	e59d1004 	ldr	r1, [sp, #4]
 124:	e28dd00c 	add	sp, sp, #12
 128:	e1a0e008 	mov	lr, r8
 12c:	e12fff18 	bx	r8

00000130 <__trampoline_bkwd_bx>:
 130:	e1a0e008 	mov	lr, r8
 134:	e12fff18 	bx	r8

00000138 <__trampoline_bkwd_pop>:
 138:	e59d8000 	ldr	r8, [sp]
 13c:	e1a0e008 	mov	lr, r8
 140:	e59d8004 	ldr	r8, [sp, #4]
 144:	e24dd00c 	sub	sp, sp, #12
 148:	e58d0000 	str	r0, [sp]
 14c:	e58d1004 	str	r1, [sp, #4]
 150:	e10f0000 	mrs	r0, CPSR
 154:	e58d0008 	str	r0, [sp, #8]
 158:	e59f0798 	ldr	r0, [pc, #1944]	; 8f8 <.curr_cpt_id>
 15c:	e3a01004 	mov	r1, #4
 160:	e0000190 	mul	r0, r0, r1
 164:	e59f1928 	ldr	r1, [pc, #2344]	; a94 <.cpt_stack+0x190>
 168:	e0811000 	add	r1, r1, r0
 16c:	e5911000 	ldr	r1, [r1]
 170:	e1580001 	cmp	r8, r1
 174:	3afffffe 	bcc	1c0 <__error>
 178:	e2800004 	add	r0, r0, #4
 17c:	e59f1910 	ldr	r1, [pc, #2320]	; a94 <.cpt_stack+0x190>
 180:	e0811000 	add	r1, r1, r0
 184:	e5911000 	ldr	r1, [r1]
 188:	e1510008 	cmp	r1, r8
 18c:	3afffffe 	bcc	1c0 <__error>
 190:	e59d0008 	ldr	r0, [sp, #8]
 194:	e128f000 	msr	CPSR_f, r0
 198:	e59d0000 	ldr	r0, [sp]
 19c:	e59d1004 	ldr	r1, [sp, #4]
 1a0:	e28dd014 	add	sp, sp, #20
 1a4:	e12fff18 	bx	r8

000001a8 <__AMI_fake_direct_transfer>:
 1a8:	e320f000 	nop	{0}

000001ac <__AMI_fake_indirect_transfer>:
 1ac:	e320f000 	nop	{0}

000001b0 <__AMI_fake_rt_transfer>:
 1b0:	e320f000 	nop	{0}

000001b4 <__AMI_fake_local_wrt>:
 1b4:	e320f000 	nop	{0}

000001b8 <__AMI_fake_shared_wrt>:
 1b8:	e320f000 	nop	{0}

000001bc <__AMI_fake_pop_pc_transfer>:
 1bc:	e320f000 	nop	{0}

000001c0 <__error>:
 1c0:	eafffffe 	b	0 <error_found>

000001c4 <__tsf_direct_jmp_link_checking>:
 1c4:	e24dd014 	sub	sp, sp, #20
 1c8:	e58d0000 	str	r0, [sp]
 1cc:	e58d1004 	str	r1, [sp, #4]
 1d0:	e58d2008 	str	r2, [sp, #8]
 1d4:	e58d300c 	str	r3, [sp, #12]
 1d8:	e10f0000 	mrs	r0, CPSR
 1dc:	e58d0010 	str	r0, [sp, #16]
 1e0:	e59f0710 	ldr	r0, [pc, #1808]	; 8f8 <.curr_cpt_id>
 1e4:	e3a01008 	mov	r1, #8
 1e8:	e0010190 	mul	r1, r0, r1
 1ec:	e59f28a4 	ldr	r2, [pc, #2212]	; a98 <.cpt_stack+0x194>
 1f0:	e0811002 	add	r1, r1, r2
 1f4:	e59f0700 	ldr	r0, [pc, #1792]	; 8fc <.total_cpt_cnt>
 1f8:	e3a02008 	mov	r2, #8
 1fc:	e0000290 	mul	r0, r0, r2
 200:	e59f2890 	ldr	r2, [pc, #2192]	; a98 <.cpt_stack+0x194>
 204:	e0820000 	add	r0, r2, r0
 208:	e5912000 	ldr	r2, [r1]
 20c:	e0822000 	add	r2, r2, r0
 210:	e5911004 	ldr	r1, [r1, #4]
 214:	e3a03000 	mov	r3, #0

00000218 <direct_link_cpt_ck_loop>:
 218:	e1530001 	cmp	r3, r1
 21c:	aa000007 	bge	240 <direct_link_cpt_ck_fail>
 220:	e3a00008 	mov	r0, #8
 224:	e0000093 	mul	r0, r3, r0
 228:	e0800002 	add	r0, r0, r2
 22c:	e5900000 	ldr	r0, [r0]
 230:	e1580000 	cmp	r8, r0
 234:	0a000003 	beq	248 <direct_link_cpt_ck_pass>
 238:	e2833001 	add	r3, r3, #1
 23c:	eafffff5 	b	218 <direct_link_cpt_ck_loop>

00000240 <direct_link_cpt_ck_fail>:
 240:	ea000000 	b	248 <direct_link_cpt_ck_pass>
 244:	eafffffe 	b	1c0 <__error>

00000248 <direct_link_cpt_ck_pass>:
 248:	e3a00008 	mov	r0, #8
 24c:	e2433001 	sub	r3, r3, #1
 250:	e0000093 	mul	r0, r3, r0
 254:	e0800002 	add	r0, r0, r2
 258:	e5900004 	ldr	r0, [r0, #4]
 25c:	e59f1838 	ldr	r1, [pc, #2104]	; a9c <.cpt_stack+0x198>
 260:	e5810000 	str	r0, [r1]
 264:	e59f0834 	ldr	r0, [pc, #2100]	; aa0 <.cpt_stack+0x19c>
 268:	e59f1690 	ldr	r1, [pc, #1680]	; 900 <.curr_cpt_stack_pointer_offset>
 26c:	e0800001 	add	r0, r0, r1
 270:	e2811008 	add	r1, r1, #8
 274:	e58f1684 	str	r1, [pc, #1668]	; 900 <.curr_cpt_stack_pointer_offset>
 278:	e59f1678 	ldr	r1, [pc, #1656]	; 8f8 <.curr_cpt_id>
 27c:	e5801000 	str	r1, [r0]
 280:	e2800004 	add	r0, r0, #4
 284:	e580e000 	str	lr, [r0]
 288:	e59d0010 	ldr	r0, [sp, #16]
 28c:	e128f000 	msr	CPSR_f, r0
 290:	e59d0000 	ldr	r0, [sp]
 294:	e59d1004 	ldr	r1, [sp, #4]
 298:	e59d2008 	ldr	r2, [sp, #8]
 29c:	e59d300c 	ldr	r3, [sp, #12]
 2a0:	e28dd014 	add	sp, sp, #20
 2a4:	e12fff18 	bx	r8

000002a8 <__tsf_direct_jmp_checking>:
 2a8:	e24dd014 	sub	sp, sp, #20
 2ac:	e58d0000 	str	r0, [sp]
 2b0:	e58d1004 	str	r1, [sp, #4]
 2b4:	e58d2008 	str	r2, [sp, #8]
 2b8:	e58d300c 	str	r3, [sp, #12]
 2bc:	e10f0000 	mrs	r0, CPSR
 2c0:	e58d0010 	str	r0, [sp, #16]
 2c4:	e59f062c 	ldr	r0, [pc, #1580]	; 8f8 <.curr_cpt_id>
 2c8:	e3a01008 	mov	r1, #8
 2cc:	e0010190 	mul	r1, r0, r1
 2d0:	e59f27c0 	ldr	r2, [pc, #1984]	; a98 <.cpt_stack+0x194>
 2d4:	e0811002 	add	r1, r1, r2
 2d8:	e59f061c 	ldr	r0, [pc, #1564]	; 8fc <.total_cpt_cnt>
 2dc:	e3a02008 	mov	r2, #8
 2e0:	e0000290 	mul	r0, r0, r2
 2e4:	e59f27ac 	ldr	r2, [pc, #1964]	; a98 <.cpt_stack+0x194>
 2e8:	e0820000 	add	r0, r2, r0
 2ec:	e5912000 	ldr	r2, [r1]
 2f0:	e0822000 	add	r2, r2, r0
 2f4:	e5911004 	ldr	r1, [r1, #4]
 2f8:	e3a03000 	mov	r3, #0

000002fc <direct_cpt_ck_loop>:
 2fc:	e1530001 	cmp	r3, r1
 300:	aa000007 	bge	324 <direct_cpt_ck_fail>
 304:	e3a00008 	mov	r0, #8
 308:	e0000093 	mul	r0, r3, r0
 30c:	e0800002 	add	r0, r0, r2
 310:	e5900000 	ldr	r0, [r0]
 314:	e1580000 	cmp	r8, r0
 318:	0a000003 	beq	32c <direct_cpt_ck_pass>
 31c:	e2833001 	add	r3, r3, #1
 320:	eafffff5 	b	2fc <direct_cpt_ck_loop>

00000324 <direct_cpt_ck_fail>:
 324:	eaffffc7 	b	248 <direct_link_cpt_ck_pass>
 328:	eafffffe 	b	1c0 <__error>

0000032c <direct_cpt_ck_pass>:
 32c:	e3a00008 	mov	r0, #8
 330:	e2433001 	sub	r3, r3, #1
 334:	e0000093 	mul	r0, r3, r0
 338:	e0800002 	add	r0, r0, r2
 33c:	e5900004 	ldr	r0, [r0, #4]
 340:	e59f1754 	ldr	r1, [pc, #1876]	; a9c <.cpt_stack+0x198>
 344:	e5810000 	str	r0, [r1]
 348:	e59d0010 	ldr	r0, [sp, #16]
 34c:	e128f000 	msr	CPSR_f, r0
 350:	e59d0000 	ldr	r0, [sp]
 354:	e59d1004 	ldr	r1, [sp, #4]
 358:	e59d2008 	ldr	r2, [sp, #8]
 35c:	e59d300c 	ldr	r3, [sp, #12]
 360:	e28dd014 	add	sp, sp, #20
 364:	e12fff18 	bx	r8

00000368 <__tsf_indirect_jmp_link_recording>:
 368:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
 36c:	ebfffffe 	bl	0 <c_indirect_tsf_recording>
 370:	e12fff38 	blx	r8
 374:	e49df004 	pop	{pc}		; (ldr pc, [sp], #4)

00000378 <__tsf_indirect_jmp_recording>:
 378:	e12fff18 	bx	r8

0000037c <__tsf_test>:
 37c:	e12fff1e 	bx	lr

00000380 <__tsf_indirect_jmp_link_checking>:
 380:	e24dd014 	sub	sp, sp, #20
 384:	e58d0000 	str	r0, [sp]
 388:	e58d1004 	str	r1, [sp, #4]
 38c:	e58d2008 	str	r2, [sp, #8]
 390:	e58d300c 	str	r3, [sp, #12]
 394:	e10f0000 	mrs	r0, CPSR
 398:	e58d0010 	str	r0, [sp, #16]
 39c:	e59f0554 	ldr	r0, [pc, #1364]	; 8f8 <.curr_cpt_id>
 3a0:	e3a01008 	mov	r1, #8
 3a4:	e0010190 	mul	r1, r0, r1
 3a8:	e59f26f4 	ldr	r2, [pc, #1780]	; aa4 <.cpt_stack+0x1a0>
 3ac:	e0811002 	add	r1, r1, r2
 3b0:	e59f0544 	ldr	r0, [pc, #1348]	; 8fc <.total_cpt_cnt>
 3b4:	e3a02008 	mov	r2, #8
 3b8:	e0000290 	mul	r0, r0, r2
 3bc:	e59f26e0 	ldr	r2, [pc, #1760]	; aa4 <.cpt_stack+0x1a0>
 3c0:	e0820000 	add	r0, r2, r0
 3c4:	e5912000 	ldr	r2, [r1]
 3c8:	e0822000 	add	r2, r2, r0
 3cc:	e5911004 	ldr	r1, [r1, #4]
 3d0:	e3a03000 	mov	r3, #0

000003d4 <indirect_link_cpt_ck_loop>:
 3d4:	e1530001 	cmp	r3, r1
 3d8:	aa000007 	bge	3fc <indirect_link_cpt_ck_fail>
 3dc:	e3a00008 	mov	r0, #8
 3e0:	e0000093 	mul	r0, r3, r0
 3e4:	e0800002 	add	r0, r0, r2
 3e8:	e5900000 	ldr	r0, [r0]
 3ec:	e1580000 	cmp	r8, r0
 3f0:	0a000009 	beq	41c <indirect_link_cpt_ck_pass>
 3f4:	e2833001 	add	r3, r3, #1
 3f8:	eafffff5 	b	3d4 <indirect_link_cpt_ck_loop>

000003fc <indirect_link_cpt_ck_fail>:
 3fc:	e59f1698 	ldr	r1, [pc, #1688]	; a9c <.cpt_stack+0x198>
 400:	e5912000 	ldr	r2, [r1]
 404:	e1a01002 	mov	r1, r2
 408:	e3a02006 	mov	r2, #6
 40c:	e92d4100 	push	{r8, lr}
 410:	ebfffffe 	bl	0 <view_switch_to_rd_and_log>
 414:	e8bd4100 	pop	{r8, lr}
 418:	ea00001d 	b	494 <indirect_link_internal_sfi>

0000041c <indirect_link_cpt_ck_pass>:
 41c:	e3a00008 	mov	r0, #8
 420:	e2433001 	sub	r3, r3, #1
 424:	e0000093 	mul	r0, r3, r0
 428:	e0800002 	add	r0, r0, r2
 42c:	e5900004 	ldr	r0, [r0, #4]
 430:	e59f1664 	ldr	r1, [pc, #1636]	; a9c <.cpt_stack+0x198>
 434:	e5912000 	ldr	r2, [r1]
 438:	e5810000 	str	r0, [r1]
 43c:	e1a01002 	mov	r1, r2
 440:	e3a02006 	mov	r2, #6
 444:	e92d4100 	push	{r8, lr}
 448:	ebfffffe 	bl	0 <view_switch_to_rd_and_log>
 44c:	e8bd4100 	pop	{r8, lr}
 450:	e59f0648 	ldr	r0, [pc, #1608]	; aa0 <.cpt_stack+0x19c>
 454:	e59f14a4 	ldr	r1, [pc, #1188]	; 900 <.curr_cpt_stack_pointer_offset>
 458:	e0800001 	add	r0, r0, r1
 45c:	e2811008 	add	r1, r1, #8
 460:	e58f1498 	str	r1, [pc, #1176]	; 900 <.curr_cpt_stack_pointer_offset>
 464:	e59f148c 	ldr	r1, [pc, #1164]	; 8f8 <.curr_cpt_id>
 468:	e5801000 	str	r1, [r0]
 46c:	e2800004 	add	r0, r0, #4
 470:	e580e000 	str	lr, [r0]
 474:	e59d0010 	ldr	r0, [sp, #16]
 478:	e128f000 	msr	CPSR_f, r0
 47c:	e59d0000 	ldr	r0, [sp]
 480:	e59d1004 	ldr	r1, [sp, #4]
 484:	e59d2008 	ldr	r2, [sp, #8]
 488:	e59d300c 	ldr	r3, [sp, #12]
 48c:	e28dd014 	add	sp, sp, #20
 490:	e12fff18 	bx	r8

00000494 <indirect_link_internal_sfi>:
 494:	e59f045c 	ldr	r0, [pc, #1116]	; 8f8 <.curr_cpt_id>
 498:	e3a01004 	mov	r1, #4
 49c:	e0000190 	mul	r0, r0, r1
 4a0:	e59f15ec 	ldr	r1, [pc, #1516]	; a94 <.cpt_stack+0x190>
 4a4:	e0811000 	add	r1, r1, r0
 4a8:	e5911000 	ldr	r1, [r1]
 4ac:	e1580001 	cmp	r8, r1
 4b0:	3afffffe 	bcc	1c0 <__error>
 4b4:	e2800004 	add	r0, r0, #4
 4b8:	e59f15d4 	ldr	r1, [pc, #1492]	; a94 <.cpt_stack+0x190>
 4bc:	e0811000 	add	r1, r1, r0
 4c0:	e5911000 	ldr	r1, [r1]
 4c4:	e1510008 	cmp	r1, r8
 4c8:	3afffffe 	bcc	1c0 <__error>
 4cc:	e59d0010 	ldr	r0, [sp, #16]
 4d0:	e128f000 	msr	CPSR_f, r0
 4d4:	e59d0000 	ldr	r0, [sp]
 4d8:	e59d1004 	ldr	r1, [sp, #4]
 4dc:	e59d2008 	ldr	r2, [sp, #8]
 4e0:	e59d300c 	ldr	r3, [sp, #12]
 4e4:	e28dd014 	add	sp, sp, #20
 4e8:	e12fff18 	bx	r8

000004ec <__tsf_indirect_jmp_checking>:
 4ec:	e24dd014 	sub	sp, sp, #20
 4f0:	e58d0000 	str	r0, [sp]
 4f4:	e58d1004 	str	r1, [sp, #4]
 4f8:	e58d2008 	str	r2, [sp, #8]
 4fc:	e58d300c 	str	r3, [sp, #12]
 500:	e10f0000 	mrs	r0, CPSR
 504:	e58d0010 	str	r0, [sp, #16]
 508:	e59f03e8 	ldr	r0, [pc, #1000]	; 8f8 <.curr_cpt_id>
 50c:	e3a01008 	mov	r1, #8
 510:	e0010190 	mul	r1, r0, r1
 514:	e59f2588 	ldr	r2, [pc, #1416]	; aa4 <.cpt_stack+0x1a0>
 518:	e0811002 	add	r1, r1, r2
 51c:	e59f03d8 	ldr	r0, [pc, #984]	; 8fc <.total_cpt_cnt>
 520:	e3a02008 	mov	r2, #8
 524:	e0000290 	mul	r0, r0, r2
 528:	e59f2574 	ldr	r2, [pc, #1396]	; aa4 <.cpt_stack+0x1a0>
 52c:	e0820000 	add	r0, r2, r0
 530:	e5912000 	ldr	r2, [r1]
 534:	e0822000 	add	r2, r2, r0
 538:	e5911004 	ldr	r1, [r1, #4]
 53c:	e3a03000 	mov	r3, #0

00000540 <indirect_cpt_ck_loop>:
 540:	e1530001 	cmp	r3, r1
 544:	aa000007 	bge	568 <indirect_cpt_ck_fail>
 548:	e3a00008 	mov	r0, #8
 54c:	e0000093 	mul	r0, r3, r0
 550:	e0800002 	add	r0, r0, r2
 554:	e5900000 	ldr	r0, [r0]
 558:	e1580000 	cmp	r8, r0
 55c:	0a000003 	beq	570 <indirect_cpt_ck_pass>
 560:	e2833001 	add	r3, r3, #1
 564:	eafffff5 	b	540 <indirect_cpt_ck_loop>

00000568 <indirect_cpt_ck_fail>:
 568:	ea000000 	b	570 <indirect_cpt_ck_pass>
 56c:	ea00000e 	b	5ac <indirect_internal_sfi>

00000570 <indirect_cpt_ck_pass>:
 570:	e3a00008 	mov	r0, #8
 574:	e2433001 	sub	r3, r3, #1
 578:	e0000093 	mul	r0, r3, r0
 57c:	e0800002 	add	r0, r0, r2
 580:	e5900004 	ldr	r0, [r0, #4]
 584:	e59f1510 	ldr	r1, [pc, #1296]	; a9c <.cpt_stack+0x198>
 588:	e5810000 	str	r0, [r1]
 58c:	e59d0010 	ldr	r0, [sp, #16]
 590:	e128f000 	msr	CPSR_f, r0
 594:	e59d0000 	ldr	r0, [sp]
 598:	e59d1004 	ldr	r1, [sp, #4]
 59c:	e59d2008 	ldr	r2, [sp, #8]
 5a0:	e59d300c 	ldr	r3, [sp, #12]
 5a4:	e28dd014 	add	sp, sp, #20
 5a8:	e12fff18 	bx	r8

000005ac <indirect_internal_sfi>:
 5ac:	e59f0344 	ldr	r0, [pc, #836]	; 8f8 <.curr_cpt_id>
 5b0:	e3a01004 	mov	r1, #4
 5b4:	e0000190 	mul	r0, r0, r1
 5b8:	e59f14d4 	ldr	r1, [pc, #1236]	; a94 <.cpt_stack+0x190>
 5bc:	e0811000 	add	r1, r1, r0
 5c0:	e5911000 	ldr	r1, [r1]
 5c4:	e1580001 	cmp	r8, r1
 5c8:	3afffffe 	bcc	1c0 <__error>
 5cc:	e2800004 	add	r0, r0, #4
 5d0:	e59f14bc 	ldr	r1, [pc, #1212]	; a94 <.cpt_stack+0x190>
 5d4:	e0811000 	add	r1, r1, r0
 5d8:	e5911000 	ldr	r1, [r1]
 5dc:	e1510008 	cmp	r1, r8
 5e0:	3afffffe 	bcc	1c0 <__error>
 5e4:	e59d0010 	ldr	r0, [sp, #16]
 5e8:	e128f000 	msr	CPSR_f, r0
 5ec:	e59d0000 	ldr	r0, [sp]
 5f0:	e59d1004 	ldr	r1, [sp, #4]
 5f4:	e59d2008 	ldr	r2, [sp, #8]
 5f8:	e59d300c 	ldr	r3, [sp, #12]
 5fc:	e28dd014 	add	sp, sp, #20
 600:	e12fff18 	bx	r8

00000604 <__tsf_bkwd_bx_lr_checking>:
 604:	e24dd00c 	sub	sp, sp, #12
 608:	e58d0000 	str	r0, [sp]
 60c:	e58d1004 	str	r1, [sp, #4]
 610:	e10f0000 	mrs	r0, CPSR
 614:	e58d0008 	str	r0, [sp, #8]
 618:	e59f0480 	ldr	r0, [pc, #1152]	; aa0 <.cpt_stack+0x19c>
 61c:	e59f12dc 	ldr	r1, [pc, #732]	; 900 <.curr_cpt_stack_pointer_offset>
 620:	e0810000 	add	r0, r1, r0
 624:	e2400004 	sub	r0, r0, #4
 628:	e5900000 	ldr	r0, [r0]
 62c:	e1580000 	cmp	r8, r0
 630:	0a000006 	beq	650 <__tsf_bkwd_bx_lr_pass>
 634:	e59d0008 	ldr	r0, [sp, #8]
 638:	e128f000 	msr	CPSR_f, r0
 63c:	e59d0000 	ldr	r0, [sp]
 640:	e59d1004 	ldr	r1, [sp, #4]
 644:	e59de00c 	ldr	lr, [sp, #12]
 648:	e28dd010 	add	sp, sp, #16
 64c:	ea00000e 	b	68c <__tsf_trampoline_bkwd_bx>

00000650 <__tsf_bkwd_bx_lr_pass>:
 650:	e2411008 	sub	r1, r1, #8
 654:	e59f044c 	ldr	r0, [pc, #1100]	; aa8 <.cpt_stack+0x1a4>
 658:	e5801000 	str	r1, [r0]
 65c:	e59f043c 	ldr	r0, [pc, #1084]	; aa0 <.cpt_stack+0x19c>
 660:	e0811000 	add	r1, r1, r0
 664:	e5910000 	ldr	r0, [r1]
 668:	e59f142c 	ldr	r1, [pc, #1068]	; a9c <.cpt_stack+0x198>
 66c:	e5810000 	str	r0, [r1]
 670:	e59d0008 	ldr	r0, [sp, #8]
 674:	e128f000 	msr	CPSR_f, r0
 678:	e59d0000 	ldr	r0, [sp]
 67c:	e59d1004 	ldr	r1, [sp, #4]
 680:	e59de00c 	ldr	lr, [sp, #12]
 684:	e28dd010 	add	sp, sp, #16
 688:	e12fff18 	bx	r8

0000068c <__tsf_trampoline_bkwd_bx>:
 68c:	e24dd00c 	sub	sp, sp, #12
 690:	e58d0000 	str	r0, [sp]
 694:	e58d1004 	str	r1, [sp, #4]
 698:	e10f0000 	mrs	r0, CPSR
 69c:	e58d0008 	str	r0, [sp, #8]
 6a0:	e59f0250 	ldr	r0, [pc, #592]	; 8f8 <.curr_cpt_id>
 6a4:	e3a01004 	mov	r1, #4
 6a8:	e0000190 	mul	r0, r0, r1
 6ac:	e59f13e0 	ldr	r1, [pc, #992]	; a94 <.cpt_stack+0x190>
 6b0:	e0811000 	add	r1, r1, r0
 6b4:	e5911000 	ldr	r1, [r1]
 6b8:	e1580001 	cmp	r8, r1
 6bc:	3afffffe 	bcc	1c0 <__error>
 6c0:	e2800004 	add	r0, r0, #4
 6c4:	e59f13c8 	ldr	r1, [pc, #968]	; a94 <.cpt_stack+0x190>
 6c8:	e0811000 	add	r1, r1, r0
 6cc:	e5911000 	ldr	r1, [r1]
 6d0:	e1510008 	cmp	r1, r8
 6d4:	3afffffe 	bcc	1c0 <__error>
 6d8:	e59d0008 	ldr	r0, [sp, #8]
 6dc:	e128f000 	msr	CPSR_f, r0
 6e0:	e59d0000 	ldr	r0, [sp]
 6e4:	e59d1004 	ldr	r1, [sp, #4]
 6e8:	e28dd00c 	add	sp, sp, #12
 6ec:	e12fff18 	bx	r8

000006f0 <__tsf_bkwd_pop_pc_checking>:
 6f0:	e59d8004 	ldr	r8, [sp, #4]
 6f4:	e24dd00c 	sub	sp, sp, #12
 6f8:	e58d0000 	str	r0, [sp]
 6fc:	e58d1004 	str	r1, [sp, #4]
 700:	e10f0000 	mrs	r0, CPSR
 704:	e58d0008 	str	r0, [sp, #8]
 708:	e59f0390 	ldr	r0, [pc, #912]	; aa0 <.cpt_stack+0x19c>
 70c:	e59f11ec 	ldr	r1, [pc, #492]	; 900 <.curr_cpt_stack_pointer_offset>
 710:	e0810000 	add	r0, r1, r0
 714:	e2400004 	sub	r0, r0, #4
 718:	e5900000 	ldr	r0, [r0]
 71c:	e1580000 	cmp	r8, r0
 720:	0a000006 	beq	740 <__tsf_bkwd_pop_pc_pass>
 724:	e59d0008 	ldr	r0, [sp, #8]
 728:	e128f000 	msr	CPSR_f, r0
 72c:	e59d0000 	ldr	r0, [sp]
 730:	e59d1004 	ldr	r1, [sp, #4]
 734:	e28dd00c 	add	sp, sp, #12
 738:	e49de004 	pop	{lr}		; (ldr lr, [sp], #4)
 73c:	ea00000f 	b	780 <__tsf_trampoline_bkwd_pop>

00000740 <__tsf_bkwd_pop_pc_pass>:
 740:	e2411008 	sub	r1, r1, #8
 744:	e59f035c 	ldr	r0, [pc, #860]	; aa8 <.cpt_stack+0x1a4>
 748:	e5801000 	str	r1, [r0]
 74c:	e59f034c 	ldr	r0, [pc, #844]	; aa0 <.cpt_stack+0x19c>
 750:	e0811000 	add	r1, r1, r0
 754:	e5910000 	ldr	r0, [r1]
 758:	e59f133c 	ldr	r1, [pc, #828]	; a9c <.cpt_stack+0x198>
 75c:	e5810000 	str	r0, [r1]
 760:	e59d0008 	ldr	r0, [sp, #8]
 764:	e128f000 	msr	CPSR_f, r0
 768:	e59d0000 	ldr	r0, [sp]
 76c:	e59d1004 	ldr	r1, [sp, #4]
 770:	e28dd00c 	add	sp, sp, #12
 774:	e49de004 	pop	{lr}		; (ldr lr, [sp], #4)
 778:	e28dd004 	add	sp, sp, #4
 77c:	e12fff18 	bx	r8

00000780 <__tsf_trampoline_bkwd_pop>:
 780:	e49d8004 	pop	{r8}		; (ldr r8, [sp], #4)
 784:	e24dd00c 	sub	sp, sp, #12
 788:	e58d0000 	str	r0, [sp]
 78c:	e58d1004 	str	r1, [sp, #4]
 790:	e10f0000 	mrs	r0, CPSR
 794:	e58d0008 	str	r0, [sp, #8]
 798:	e59f0158 	ldr	r0, [pc, #344]	; 8f8 <.curr_cpt_id>
 79c:	e3a01004 	mov	r1, #4
 7a0:	e0000190 	mul	r0, r0, r1
 7a4:	e59f12e8 	ldr	r1, [pc, #744]	; a94 <.cpt_stack+0x190>
 7a8:	e0811000 	add	r1, r1, r0
 7ac:	e5911000 	ldr	r1, [r1]
 7b0:	e1580001 	cmp	r8, r1
 7b4:	3afffffe 	bcc	1c0 <__error>
 7b8:	e2800004 	add	r0, r0, #4
 7bc:	e59f12d0 	ldr	r1, [pc, #720]	; a94 <.cpt_stack+0x190>
 7c0:	e0811000 	add	r1, r1, r0
 7c4:	e5911000 	ldr	r1, [r1]
 7c8:	e1510008 	cmp	r1, r8
 7cc:	3afffffe 	bcc	1c0 <__error>
 7d0:	e59d0008 	ldr	r0, [sp, #8]
 7d4:	e128f000 	msr	CPSR_f, r0
 7d8:	e59d0000 	ldr	r0, [sp]
 7dc:	e59d1004 	ldr	r1, [sp, #4]
 7e0:	e28dd00c 	add	sp, sp, #12
 7e4:	e12fff18 	bx	r8

000007e8 <__storing_checking>:
 7e8:	e24dd018 	sub	sp, sp, #24
 7ec:	e58d0000 	str	r0, [sp]
 7f0:	e58d1004 	str	r1, [sp, #4]
 7f4:	e58d2008 	str	r2, [sp, #8]
 7f8:	e58d300c 	str	r3, [sp, #12]
 7fc:	e58d4010 	str	r4, [sp, #16]
 800:	e10f0000 	mrs	r0, CPSR
 804:	e58d0014 	str	r0, [sp, #20]
 808:	e59f00e8 	ldr	r0, [pc, #232]	; 8f8 <.curr_cpt_id>
 80c:	e3a01008 	mov	r1, #8
 810:	e0010190 	mul	r1, r0, r1
 814:	e59f2290 	ldr	r2, [pc, #656]	; aac <.cpt_stack+0x1a8>
 818:	e0811002 	add	r1, r1, r2
 81c:	e59f00d8 	ldr	r0, [pc, #216]	; 8fc <.total_cpt_cnt>
 820:	e3a02008 	mov	r2, #8
 824:	e0000290 	mul	r0, r0, r2
 828:	e59f227c 	ldr	r2, [pc, #636]	; aac <.cpt_stack+0x1a8>
 82c:	e0820000 	add	r0, r2, r0
 830:	e5912000 	ldr	r2, [r1]
 834:	e0822000 	add	r2, r2, r0
 838:	e5911004 	ldr	r1, [r1, #4]
 83c:	e3a03000 	mov	r3, #0
 840:	e3a04000 	mov	r4, #0

00000844 <storing_ck_loop>:
 844:	e1530001 	cmp	r3, r1
 848:	aa000010 	bge	890 <storing_ck_valid>
 84c:	e3a00008 	mov	r0, #8
 850:	e0000093 	mul	r0, r3, r0
 854:	e0800002 	add	r0, r0, r2
 858:	e5900000 	ldr	r0, [r0]
 85c:	e1580000 	cmp	r8, r0
 860:	3a000008 	bcc	888 <storing_loop_next>
 864:	e3a00008 	mov	r0, #8
 868:	e0000093 	mul	r0, r3, r0
 86c:	e0800002 	add	r0, r0, r2
 870:	e2800004 	add	r0, r0, #4
 874:	e5900000 	ldr	r0, [r0]
 878:	e1580000 	cmp	r8, r0
 87c:	8a000001 	bhi	888 <storing_loop_next>
 880:	e3a04001 	mov	r4, #1
 884:	ea000006 	b	8a4 <storing_ck_pass>

00000888 <storing_loop_next>:
 888:	e2833001 	add	r3, r3, #1
 88c:	eaffffec 	b	844 <storing_ck_loop>

00000890 <storing_ck_valid>:
 890:	e3540000 	cmp	r4, #0
 894:	0a000000 	beq	89c <storing_ck_fail>
 898:	ea000001 	b	8a4 <storing_ck_pass>

0000089c <storing_ck_fail>:
 89c:	ea000000 	b	8a4 <storing_ck_pass>
 8a0:	eafffffe 	b	1c0 <__error>

000008a4 <storing_ck_pass>:
 8a4:	e59d0020 	ldr	r0, [sp, #32]
 8a8:	e59d101c 	ldr	r1, [sp, #28]
 8ac:	e30021bf 	movw	r2, #447	; 0x1bf
 8b0:	e1500002 	cmp	r0, r2
 8b4:	0a00000b 	beq	8e8 <STRBi12>
 8b8:	e30021d7 	movw	r2, #471	; 0x1d7
 8bc:	e1500002 	cmp	r0, r2
 8c0:	0a00000a 	beq	8f0 <STRi12>

000008c4 <storing_ctx_restoring>:
 8c4:	e59d0014 	ldr	r0, [sp, #20]
 8c8:	e128f000 	msr	CPSR_f, r0
 8cc:	e59d0000 	ldr	r0, [sp]
 8d0:	e59d1004 	ldr	r1, [sp, #4]
 8d4:	e59d2008 	ldr	r2, [sp, #8]
 8d8:	e59d300c 	ldr	r3, [sp, #12]
 8dc:	e59d4010 	ldr	r4, [sp, #16]
 8e0:	e28dd018 	add	sp, sp, #24
 8e4:	e12fff1e 	bx	lr

000008e8 <STRBi12>:
 8e8:	e5c81000 	strb	r1, [r8]
 8ec:	eafffff4 	b	8c4 <storing_ctx_restoring>

000008f0 <STRi12>:
 8f0:	e5881000 	str	r1, [r8]
 8f4:	eafffff2 	b	8c4 <storing_ctx_restoring>

000008f8 <.curr_cpt_id>:
 8f8:	00000000 	.word	0x00000000

000008fc <.total_cpt_cnt>:
 8fc:	00000003 	.word	0x00000003

00000900 <.curr_cpt_stack_pointer_offset>:
 900:	00000000 	.word	0x00000000

00000904 <.cpt_stack>:
	...
 a98:	00000020 	.word	0x00000020
 a9c:	000008f8 	.word	0x000008f8
 aa0:	00000904 	.word	0x00000904
 aa4:	00000058 	.word	0x00000058
 aa8:	00000900 	.word	0x00000900
 aac:	00000090 	.word	0x00000090
