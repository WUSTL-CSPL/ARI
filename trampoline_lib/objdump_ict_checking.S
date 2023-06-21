
./ict_checking.o:     file format elf32-littlearm


Disassembly of section .text:

00000000 <push>:
   0:	b490      	push	{r4, r7}
   2:	b088      	sub	sp, #32
   4:	af00      	add	r7, sp, #0
   6:	6078      	str	r0, [r7, #4]
   8:	6039      	str	r1, [r7, #0]
   a:	687a      	ldr	r2, [r7, #4]
   c:	f44f 43b4 	mov.w	r3, #23040	; 0x5a00
  10:	f2c0 2362 	movt	r3, #610	; 0x262
  14:	4413      	add	r3, r2
  16:	f3bf 8f5b 	dmb	ish
  1a:	681b      	ldr	r3, [r3, #0]
  1c:	f3bf 8f5b 	dmb	ish
  20:	613b      	str	r3, [r7, #16]
  22:	693b      	ldr	r3, [r7, #16]
  24:	1c5a      	adds	r2, r3, #1
  26:	f64c 236b 	movw	r3, #51819	; 0xca6b
  2a:	f6c6 335f 	movt	r3, #27487	; 0x6b5f
  2e:	fba2 3403 	umull	r3, r4, r2, r3
  32:	0da1      	lsrs	r1, r4, #22
  34:	f249 6380 	movw	r3, #38528	; 0x9680
  38:	f2c0 0398 	movt	r3, #152	; 0x98
  3c:	fb03 f301 	mul.w	r3, r3, r1
  40:	1ad3      	subs	r3, r2, r3
  42:	61fb      	str	r3, [r7, #28]
  44:	687a      	ldr	r2, [r7, #4]
  46:	f645 2304 	movw	r3, #23044	; 0x5a04
  4a:	f2c0 2362 	movt	r3, #610	; 0x262
  4e:	4413      	add	r3, r2
  50:	61bb      	str	r3, [r7, #24]
  52:	69bb      	ldr	r3, [r7, #24]
  54:	f3bf 8f5b 	dmb	ish
  58:	681b      	ldr	r3, [r3, #0]
  5a:	f3bf 8f5b 	dmb	ish
  5e:	60fb      	str	r3, [r7, #12]
  60:	68fa      	ldr	r2, [r7, #12]
  62:	69fb      	ldr	r3, [r7, #28]
  64:	429a      	cmp	r2, r3
  66:	d01c      	beq.n	a2 <push+0xa2>
  68:	687a      	ldr	r2, [r7, #4]
  6a:	f44f 43b4 	mov.w	r3, #23040	; 0x5a00
  6e:	f2c0 2362 	movt	r3, #610	; 0x262
  72:	4413      	add	r3, r2
  74:	681a      	ldr	r2, [r3, #0]
  76:	687b      	ldr	r3, [r7, #4]
  78:	6839      	ldr	r1, [r7, #0]
  7a:	f843 1022 	str.w	r1, [r3, r2, lsl #2]
  7e:	687a      	ldr	r2, [r7, #4]
  80:	f44f 43b4 	mov.w	r3, #23040	; 0x5a00
  84:	f2c0 2362 	movt	r3, #610	; 0x262
  88:	4413      	add	r3, r2
  8a:	617b      	str	r3, [r7, #20]
  8c:	69fb      	ldr	r3, [r7, #28]
  8e:	60bb      	str	r3, [r7, #8]
  90:	68ba      	ldr	r2, [r7, #8]
  92:	697b      	ldr	r3, [r7, #20]
  94:	f3bf 8f5b 	dmb	ish
  98:	601a      	str	r2, [r3, #0]
  9a:	f3bf 8f5b 	dmb	ish
  9e:	2301      	movs	r3, #1
  a0:	e000      	b.n	a4 <push+0xa4>
  a2:	2300      	movs	r3, #0
  a4:	4618      	mov	r0, r3
  a6:	3720      	adds	r7, #32
  a8:	46bd      	mov	sp, r7
  aa:	bc90      	pop	{r4, r7}
  ac:	4770      	bx	lr

000000ae <pop>:
  ae:	b490      	push	{r4, r7}
  b0:	b08a      	sub	sp, #40	; 0x28
  b2:	af00      	add	r7, sp, #0
  b4:	6078      	str	r0, [r7, #4]
  b6:	6039      	str	r1, [r7, #0]
  b8:	687a      	ldr	r2, [r7, #4]
  ba:	f44f 43b4 	mov.w	r3, #23040	; 0x5a00
  be:	f2c0 2362 	movt	r3, #610	; 0x262
  c2:	4413      	add	r3, r2
  c4:	627b      	str	r3, [r7, #36]	; 0x24
  c6:	6a7b      	ldr	r3, [r7, #36]	; 0x24
  c8:	f3bf 8f5b 	dmb	ish
  cc:	681b      	ldr	r3, [r3, #0]
  ce:	f3bf 8f5b 	dmb	ish
  d2:	617b      	str	r3, [r7, #20]
  d4:	697a      	ldr	r2, [r7, #20]
  d6:	6879      	ldr	r1, [r7, #4]
  d8:	f645 2304 	movw	r3, #23044	; 0x5a04
  dc:	f2c0 2362 	movt	r3, #610	; 0x262
  e0:	440b      	add	r3, r1
  e2:	623b      	str	r3, [r7, #32]
  e4:	6a3b      	ldr	r3, [r7, #32]
  e6:	f3bf 8f5b 	dmb	ish
  ea:	681b      	ldr	r3, [r3, #0]
  ec:	f3bf 8f5b 	dmb	ish
  f0:	613b      	str	r3, [r7, #16]
  f2:	693b      	ldr	r3, [r7, #16]
  f4:	429a      	cmp	r2, r3
  f6:	d101      	bne.n	fc <pop+0x4e>
  f8:	2300      	movs	r3, #0
  fa:	e037      	b.n	16c <pop+0xbe>
  fc:	687a      	ldr	r2, [r7, #4]
  fe:	f645 2304 	movw	r3, #23044	; 0x5a04
 102:	f2c0 2362 	movt	r3, #610	; 0x262
 106:	4413      	add	r3, r2
 108:	681a      	ldr	r2, [r3, #0]
 10a:	687b      	ldr	r3, [r7, #4]
 10c:	f853 2022 	ldr.w	r2, [r3, r2, lsl #2]
 110:	683b      	ldr	r3, [r7, #0]
 112:	601a      	str	r2, [r3, #0]
 114:	687a      	ldr	r2, [r7, #4]
 116:	f645 2304 	movw	r3, #23044	; 0x5a04
 11a:	f2c0 2362 	movt	r3, #610	; 0x262
 11e:	4413      	add	r3, r2
 120:	61fb      	str	r3, [r7, #28]
 122:	687a      	ldr	r2, [r7, #4]
 124:	f645 2304 	movw	r3, #23044	; 0x5a04
 128:	f2c0 2362 	movt	r3, #610	; 0x262
 12c:	4413      	add	r3, r2
 12e:	f3bf 8f5b 	dmb	ish
 132:	681b      	ldr	r3, [r3, #0]
 134:	f3bf 8f5b 	dmb	ish
 138:	61bb      	str	r3, [r7, #24]
 13a:	69bb      	ldr	r3, [r7, #24]
 13c:	1c59      	adds	r1, r3, #1
 13e:	f64c 236b 	movw	r3, #51819	; 0xca6b
 142:	f6c6 335f 	movt	r3, #27487	; 0x6b5f
 146:	fba1 3403 	umull	r3, r4, r1, r3
 14a:	0da3      	lsrs	r3, r4, #22
 14c:	f249 6280 	movw	r2, #38528	; 0x9680
 150:	f2c0 0298 	movt	r2, #152	; 0x98
 154:	fb02 f303 	mul.w	r3, r2, r3
 158:	1acb      	subs	r3, r1, r3
 15a:	60fb      	str	r3, [r7, #12]
 15c:	68fa      	ldr	r2, [r7, #12]
 15e:	69fb      	ldr	r3, [r7, #28]
 160:	f3bf 8f5b 	dmb	ish
 164:	601a      	str	r2, [r3, #0]
 166:	f3bf 8f5b 	dmb	ish
 16a:	2301      	movs	r3, #1
 16c:	4618      	mov	r0, r3
 16e:	3728      	adds	r7, #40	; 0x28
 170:	46bd      	mov	sp, r7
 172:	bc90      	pop	{r4, r7}
 174:	4770      	bx	lr

00000176 <read_r8>:
 176:	b480      	push	{r7}
 178:	b083      	sub	sp, #12
 17a:	af00      	add	r7, sp, #0
 17c:	4643      	mov	r3, r8
 17e:	607b      	str	r3, [r7, #4]
 180:	687b      	ldr	r3, [r7, #4]
 182:	4618      	mov	r0, r3
 184:	370c      	adds	r7, #12
 186:	46bd      	mov	sp, r7
 188:	f85d 7b04 	ldr.w	r7, [sp], #4
 18c:	4770      	bx	lr

0000018e <c_indirect_tsf_recording>:
 18e:	b580      	push	{r7, lr}
 190:	af00      	add	r7, sp, #0
 192:	4b03      	ldr	r3, [pc, #12]	; (1a0 <c_indirect_tsf_recording+0x12>)
 194:	447b      	add	r3, pc
 196:	4618      	mov	r0, r3
 198:	f7ff fffe 	bl	0 <puts>
 19c:	bf00      	nop
 19e:	bd80      	pop	{r7, pc}
 1a0:	00000008 	.word	0x00000008

000001a4 <ict_checking>:
 1a4:	b480      	push	{r7}
 1a6:	b083      	sub	sp, #12
 1a8:	af00      	add	r7, sp, #0
 1aa:	6078      	str	r0, [r7, #4]
 1ac:	2300      	movs	r3, #0
 1ae:	4618      	mov	r0, r3
 1b0:	370c      	adds	r7, #12
 1b2:	46bd      	mov	sp, r7
 1b4:	f85d 7b04 	ldr.w	r7, [sp], #4
 1b8:	4770      	bx	lr

000001ba <error_found>:
 1ba:	b580      	push	{r7, lr}
 1bc:	af00      	add	r7, sp, #0
 1be:	4b03      	ldr	r3, [pc, #12]	; (1cc <error_found+0x12>)
 1c0:	447b      	add	r3, pc
 1c2:	4618      	mov	r0, r3
 1c4:	f7ff fffe 	bl	0 <puts>
 1c8:	bf00      	nop
 1ca:	bd80      	pop	{r7, pc}
 1cc:	00000014 	.word	0x00000014

000001d0 <test_fwd_indirect_tsf>:
 1d0:	b480      	push	{r7}
 1d2:	af00      	add	r7, sp, #0
 1d4:	bf00      	nop
 1d6:	46bd      	mov	sp, r7
 1d8:	f85d 7b04 	ldr.w	r7, [sp], #4
 1dc:	4770      	bx	lr
 1de:	bf00      	nop
