
./syringe--baseline_after_compt.elf:     file format elf32-littlearm


Disassembly of section .interp:

000100f4 <.interp>:
   100f4:	7273752f 	rsbsvc	r7, r3, #197132288	; 0xbc00000
   100f8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
   100fc:	2e646c2f 	cdpcs	12, 6, cr6, cr4, cr15, {1}
   10100:	312e6f73 			; <UNDEFINED> instruction: 0x312e6f73
	...

Disassembly of section .hash:

00010108 <.hash>:
   10108:	00000011 	andeq	r0, r0, r1, lsl r0
   1010c:	0000001d 	andeq	r0, r0, sp, lsl r0
   10110:	00000000 	andeq	r0, r0, r0
   10114:	00000014 	andeq	r0, r0, r4, lsl r0
   10118:	00000015 	andeq	r0, r0, r5, lsl r0
   1011c:	0000000e 	andeq	r0, r0, lr
   10120:	0000000c 	andeq	r0, r0, ip
   10124:	00000008 	andeq	r0, r0, r8
   10128:	0000001c 	andeq	r0, r0, ip, lsl r0
   1012c:	0000001a 	andeq	r0, r0, sl, lsl r0
   10130:	00000000 	andeq	r0, r0, r0
   10134:	00000013 	andeq	r0, r0, r3, lsl r0
   10138:	00000016 	andeq	r0, r0, r6, lsl r0
   1013c:	00000012 	andeq	r0, r0, r2, lsl r0
   10140:	00000019 	andeq	r0, r0, r9, lsl r0
   10144:	00000018 	andeq	r0, r0, r8, lsl r0
   10148:	00000011 	andeq	r0, r0, r1, lsl r0
   1014c:	0000001b 	andeq	r0, r0, fp, lsl r0
	...
   1015c:	00000001 	andeq	r0, r0, r1
	...
   1016c:	00000003 	andeq	r0, r0, r3
   10170:	00000000 	andeq	r0, r0, r0
   10174:	00000007 	andeq	r0, r0, r7
   10178:	00000005 	andeq	r0, r0, r5
   1017c:	00000009 	andeq	r0, r0, r9
   10180:	00000000 	andeq	r0, r0, r0
   10184:	00000004 	andeq	r0, r0, r4
	...
   10194:	0000000f 	andeq	r0, r0, pc
	...
   101a0:	0000000d 	andeq	r0, r0, sp
   101a4:	00000006 	andeq	r0, r0, r6
   101a8:	0000000a 	andeq	r0, r0, sl
   101ac:	00000002 	andeq	r0, r0, r2
   101b0:	00000000 	andeq	r0, r0, r0
   101b4:	00000010 	andeq	r0, r0, r0, lsl r0
   101b8:	00000017 	andeq	r0, r0, r7, lsl r0
	...
   101c4:	0000000b 	andeq	r0, r0, fp

Disassembly of section .dynsym:

000101c8 <.dynsym>:
	...
   101d8:	00000056 	andeq	r0, r0, r6, asr r0
	...
   101e4:	00000012 	andeq	r0, r0, r2, lsl r0
   101e8:	000000c1 	andeq	r0, r0, r1, asr #1
   101ec:	00021d54 	andeq	r1, r2, r4, asr sp
   101f0:	00000000 	andeq	r0, r0, r0
   101f4:	00240010 	eoreq	r0, r4, r0, lsl r0
   101f8:	000000e8 	andeq	r0, r0, r8, ror #1
   101fc:	00021d7c 	andeq	r1, r2, ip, ror sp
   10200:	00000008 	andeq	r0, r0, r8
   10204:	00240011 	eoreq	r0, r4, r1, lsl r0
   10208:	00000078 	andeq	r0, r0, r8, ror r0
	...
   10214:	00000012 	andeq	r0, r0, r2, lsl r0
   10218:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
   1021c:	00021dd0 	ldrdeq	r1, [r2], -r0
   10220:	00000000 	andeq	r0, r0, r0
   10224:	00240010 	eoreq	r0, r4, r0, lsl r0
   10228:	000000ae 	andeq	r0, r0, lr, lsr #1
   1022c:	00021d54 	andeq	r1, r2, r4, asr sp
   10230:	00000000 	andeq	r0, r0, r0
   10234:	00230010 	eoreq	r0, r3, r0, lsl r0
   10238:	000000cf 	andeq	r0, r0, pc, asr #1
   1023c:	00021dd0 	ldrdeq	r1, [r2], -r0
   10240:	00000000 	andeq	r0, r0, r0
   10244:	00240010 	eoreq	r0, r4, r0, lsl r0
   10248:	000000ec 	andeq	r0, r0, ip, ror #1
   1024c:	00021d84 	andeq	r1, r2, r4, lsl #27
   10250:	00000004 	andeq	r0, r0, r4
   10254:	00240011 	eoreq	r0, r4, r1, lsl r0
   10258:	00000080 	andeq	r0, r0, r0, lsl #1
	...
   10264:	00000012 	andeq	r0, r0, r2, lsl r0
   10268:	00000087 	andeq	r0, r0, r7, lsl #1
	...
   10274:	00000012 	andeq	r0, r0, r2, lsl r0
   10278:	000000f7 	strdeq	r0, [r0], -r7
   1027c:	00021d5c 	andeq	r1, r2, ip, asr sp
   10280:	00000004 	andeq	r0, r0, r4
   10284:	00240011 	eoreq	r0, r4, r1, lsl r0
   10288:	0000006c 	andeq	r0, r0, ip, rrx
	...
   10294:	00000012 	andeq	r0, r0, r2, lsl r0
   10298:	00000010 	andeq	r0, r0, r0, lsl r0
	...
   102a4:	00000012 	andeq	r0, r0, r2, lsl r0
   102a8:	00000102 	andeq	r0, r0, r2, lsl #2
   102ac:	00021d88 	andeq	r1, r2, r8, lsl #27
   102b0:	00000008 	andeq	r0, r0, r8
   102b4:	00240011 	eoreq	r0, r4, r1, lsl r0
   102b8:	00000071 	andeq	r0, r0, r1, ror r0
	...
   102c4:	00000012 	andeq	r0, r0, r2, lsl r0
   102c8:	000000e3 	andeq	r0, r0, r3, ror #1
   102cc:	00021dd0 	ldrdeq	r1, [r2], -r0
   102d0:	00000000 	andeq	r0, r0, r0
   102d4:	00240010 	eoreq	r0, r4, r0, lsl r0
   102d8:	000000db 	ldrdeq	r0, [r0], -fp
   102dc:	00021dd0 	ldrdeq	r1, [r2], -r0
   102e0:	00000000 	andeq	r0, r0, r0
   102e4:	00240010 	eoreq	r0, r4, r0, lsl r0
   102e8:	000000b5 	strheq	r0, [r0], -r5
   102ec:	00021d54 	andeq	r1, r2, r4, asr sp
   102f0:	00000000 	andeq	r0, r0, r0
   102f4:	00240010 	eoreq	r0, r4, r0, lsl r0
   102f8:	00000107 	andeq	r0, r0, r7, lsl #2
   102fc:	00021d90 	muleq	r2, r0, sp
   10300:	00000004 	andeq	r0, r0, r4
   10304:	00240011 	eoreq	r0, r4, r1, lsl r0
   10308:	0000010b 	andeq	r0, r0, fp, lsl #2
   1030c:	00021d94 	muleq	r2, r4, sp
   10310:	0000003c 	andeq	r0, r0, ip, lsr r0
   10314:	00240011 	eoreq	r0, r4, r1, lsl r0
   10318:	00000099 	muleq	r0, r9, r0
	...
   10324:	00000012 	andeq	r0, r0, r2, lsl r0
   10328:	00000055 	andeq	r0, r0, r5, asr r0
	...
   10334:	00000012 	andeq	r0, r0, r2, lsl r0
   10338:	0000005d 	andeq	r0, r0, sp, asr r0
	...
   10344:	00000012 	andeq	r0, r0, r2, lsl r0
   10348:	00000094 	muleq	r0, r4, r0
	...
   10354:	00000012 	andeq	r0, r0, r2, lsl r0
   10358:	0000010e 	andeq	r0, r0, lr, lsl #2
   1035c:	00021d44 	andeq	r1, r2, r4, asr #26
   10360:	00000010 	andeq	r0, r0, r0, lsl r0
   10364:	00230011 	eoreq	r0, r3, r1, lsl r0
   10368:	00000113 	andeq	r0, r0, r3, lsl r1
   1036c:	00021d58 	andeq	r1, r2, r8, asr sp
   10370:	00000001 	andeq	r0, r0, r1
   10374:	00240011 	eoreq	r0, r4, r1, lsl r0
   10378:	00000023 	andeq	r0, r0, r3, lsr #32
	...
   10384:	00000012 	andeq	r0, r0, r2, lsl r0
   10388:	0000003a 	andeq	r0, r0, sl, lsr r0
	...
   10394:	00000012 	andeq	r0, r0, r2, lsl r0

Disassembly of section .dynstr:

00010398 <.dynstr>:
   10398:	62696c00 	rsbvs	r6, r9, #0, 24
   1039c:	63656574 	cmnvs	r5, #116, 10	; 0x1d000000
   103a0:	2e6f732e 	cdpcs	3, 6, cr7, cr15, cr14, {1}
   103a4:	00302e31 	eorseq	r2, r0, r1, lsr lr
   103a8:	43454554 	movtmi	r4, #21844	; 0x5554
   103ac:	766e495f 			; <UNDEFINED> instruction: 0x766e495f
   103b0:	43656b6f 	cmnmi	r5, #113664	; 0x1bc00
   103b4:	616d6d6f 	cmnvs	sp, pc, ror #26
   103b8:	5400646e 	strpl	r6, [r0], #-1134	; 0xfffffb92
   103bc:	5f434545 	svcpl	0x00434545
   103c0:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
   103c4:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
   103c8:	6f43657a 	svcvs	0x0043657a
   103cc:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
   103d0:	45540074 	ldrbmi	r0, [r4, #-116]	; 0xffffff8c
   103d4:	4f5f4345 	svcmi	0x005f4345
   103d8:	536e6570 	cmnpl	lr, #112, 10	; 0x1c000000
   103dc:	69737365 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^
   103e0:	6c006e6f 	stcvs	14, cr6, [r0], {111}	; 0x6f
   103e4:	2e636269 	cdpcs	2, 6, cr6, cr3, cr9, {3}
   103e8:	362e6f73 	qsub16cc	r6, lr, r3
   103ec:	72707300 	rsbsvc	r7, r0, #0, 6
   103f0:	66746e69 	ldrbtvs	r6, [r4], -r9, ror #28
   103f4:	695f5f00 	ldmdbvs	pc, {r8, r9, sl, fp, ip, lr}^	; <UNPREDICTABLE>
   103f8:	39636f73 	stmdbcc	r3!, {r0, r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
   103fc:	63735f39 	cmnvs	r3, #57, 30	; 0xe4
   10400:	00666e61 	rsbeq	r6, r6, r1, ror #28
   10404:	73747570 	cmnvc	r4, #112, 10	; 0x1c000000
   10408:	6d656d00 	stclvs	13, cr6, [r5, #-0]
   1040c:	00746573 	rsbseq	r6, r4, r3, ror r5
   10410:	63746567 	cmnvs	r4, #432013312	; 0x19c00000
   10414:	00726168 	rsbseq	r6, r2, r8, ror #2
   10418:	656c7375 	strbvs	r7, [ip, #-885]!	; 0xfffffc8b
   1041c:	67007065 	strvs	r7, [r0, -r5, rrx]
   10420:	69747465 	ldmdbvs	r4!, {r0, r2, r5, r6, sl, ip, sp, lr}^
   10424:	666f656d 	strbtvs	r6, [pc], -sp, ror #10
   10428:	00796164 	rsbseq	r6, r9, r4, ror #2
   1042c:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
   10430:	72726500 	rsbsvc	r6, r2, #0, 10
   10434:	696c0078 	stmdbvs	ip!, {r3, r4, r5, r6}^
   10438:	68747062 	ldmdavs	r4!, {r1, r5, r6, ip, sp, lr}^
   1043c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
   10440:	2e6f732e 	cdpcs	3, 6, cr7, cr15, cr14, {1}
   10444:	655f0030 	ldrbvs	r0, [pc, #-48]	; 1041c <printf@plt-0x198>
   10448:	61746164 	cmnvs	r4, r4, ror #2
   1044c:	625f5f00 	subsvs	r5, pc, #0, 30
   10450:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
   10454:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
   10458:	625f5f00 	subsvs	r5, pc, #0, 30
   1045c:	735f7373 	cmpvc	pc, #-872415231	; 0xcc000001
   10460:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
   10464:	5f005f5f 	svcpl	0x00005f5f
   10468:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
   1046c:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
   10470:	5f005f5f 	svcpl	0x00005f5f
   10474:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
   10478:	5f005f5f 	svcpl	0x00005f5f
   1047c:	00646e65 	rsbeq	r6, r4, r5, ror #28
   10480:	00787463 	rsbseq	r7, r8, r3, ror #8
   10484:	5f727265 	svcpl	0x00727265
   10488:	6769726f 	strbvs	r7, [r9, -pc, ror #4]!
   1048c:	69006e69 	stmdbvs	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
   10490:	6b6f766e 	blvs	1bede50 <__bss_end__+0x1bcc080>
   10494:	6e635f65 	cdpvs	15, 6, cr5, cr3, cr5, {3}
   10498:	65730074 	ldrbvs	r0, [r3, #-116]!	; 0xffffff8c
   1049c:	72007373 	andvc	r7, r0, #-872415231	; 0xcc000001
   104a0:	6f007365 	svcvs	0x00007365
   104a4:	75750070 	ldrbvc	r0, [r5, #-112]!	; 0xffffff90
   104a8:	72006469 	andvc	r6, r0, #1761607680	; 0x69000000
   104ac:	706f5f64 	rsbvc	r5, pc, r4, ror #30
   104b0:	5f656574 	svcpl	0x00656574
   104b4:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
   104b8:	494c4700 	stmdbmi	ip, {r8, r9, sl, lr}^
   104bc:	325f4342 	subscc	r4, pc, #134217729	; 0x8000001
   104c0:	4700372e 	strmi	r3, [r0, -lr, lsr #14]
   104c4:	4342494c 	movtmi	r4, #10572	; 0x294c
   104c8:	342e325f 	strtcc	r3, [lr], #-607	; 0xfffffda1
	...

Disassembly of section .gnu.version:

000104ce <.gnu.version>:
   104ce:	00020000 	andeq	r0, r2, r0
   104d2:	00010001 	andeq	r0, r1, r1
   104d6:	00010002 	andeq	r0, r1, r2
   104da:	00010001 	andeq	r0, r1, r1
   104de:	00020001 	andeq	r0, r2, r1
   104e2:	00010002 	andeq	r0, r1, r2
   104e6:	00000002 	andeq	r0, r0, r2
   104ea:	00020001 	andeq	r0, r2, r1
   104ee:	00010001 	andeq	r0, r1, r1
   104f2:	00010001 	andeq	r0, r1, r1
   104f6:	00020001 	andeq	r0, r2, r1
   104fa:	00030002 	andeq	r0, r3, r2
   104fe:	00010002 	andeq	r0, r1, r2
   10502:	00000001 	andeq	r0, r0, r1
	...

Disassembly of section .gnu.version_r:

00010508 <.gnu.version_r>:
   10508:	00020001 	andeq	r0, r2, r1
   1050c:	0000004b 	andeq	r0, r0, fp, asr #32
   10510:	00000010 	andeq	r0, r0, r0, lsl r0
   10514:	00000000 	andeq	r0, r0, r0
   10518:	0d696917 			; <UNDEFINED> instruction: 0x0d696917
   1051c:	00030000 	andeq	r0, r3, r0
   10520:	00000121 	andeq	r0, r0, r1, lsr #2
   10524:	00000010 	andeq	r0, r0, r0, lsl r0
   10528:	0d696914 			; <UNDEFINED> instruction: 0x0d696914
   1052c:	00020000 	andeq	r0, r2, r0
   10530:	0000012b 	andeq	r0, r0, fp, lsr #2
   10534:	00000000 	andeq	r0, r0, r0

Disassembly of section .rel.plt:

00010538 <.rel.plt>:
   10538:	00021cec 	andeq	r1, r2, ip, ror #25
   1053c:	00000116 	andeq	r0, r0, r6, lsl r1
   10540:	00021cf0 	strdeq	r1, [r2], -r0
   10544:	00000416 	andeq	r0, r0, r6, lsl r4
   10548:	00021cf4 	strdeq	r1, [r2], -r4
   1054c:	00000916 	andeq	r0, r0, r6, lsl r9
   10550:	00021cf8 	strdeq	r1, [r2], -r8
   10554:	00000a16 	andeq	r0, r0, r6, lsl sl
   10558:	00021cfc 	strdeq	r1, [r2], -ip
   1055c:	00000c16 	andeq	r0, r0, r6, lsl ip
   10560:	00021d00 	andeq	r1, r2, r0, lsl #26
   10564:	00000d16 	andeq	r0, r0, r6, lsl sp
   10568:	00021d04 	andeq	r1, r2, r4, lsl #26
   1056c:	00000f16 	andeq	r0, r0, r6, lsl pc
   10570:	00021d08 	andeq	r1, r2, r8, lsl #26
   10574:	00001516 	andeq	r1, r0, r6, lsl r5
   10578:	00021d0c 	andeq	r1, r2, ip, lsl #26
   1057c:	00001616 	andeq	r1, r0, r6, lsl r6
   10580:	00021d10 	andeq	r1, r2, r0, lsl sp
   10584:	00001716 	andeq	r1, r0, r6, lsl r7
   10588:	00021d14 	andeq	r1, r2, r4, lsl sp
   1058c:	00001816 	andeq	r1, r0, r6, lsl r8
   10590:	00021d18 	andeq	r1, r2, r8, lsl sp
   10594:	00001b16 	andeq	r1, r0, r6, lsl fp
   10598:	00021d1c 	andeq	r1, r2, ip, lsl sp
   1059c:	00001c16 	andeq	r1, r0, r6, lsl ip

Disassembly of section .plt:

000105a0 <printf@plt-0x14>:
   105a0:	e52de004 	push	{lr}		; (str lr, [sp, #-4]!)
   105a4:	e59fe004 	ldr	lr, [pc, #4]	; 105b0 <printf@plt-0x4>
   105a8:	e08fe00e 	add	lr, pc, lr
   105ac:	e5bef008 	ldr	pc, [lr, #8]!
   105b0:	00011730 	andeq	r1, r1, r0, lsr r7

000105b4 <printf@plt>:
   105b4:	e28fc600 	add	ip, pc, #0, 12
   105b8:	e28cca11 	add	ip, ip, #69632	; 0x11000
   105bc:	e5bcf730 	ldr	pc, [ip, #1840]!	; 0x730

000105c0 <getchar@plt>:
   105c0:	e28fc600 	add	ip, pc, #0, 12
   105c4:	e28cca11 	add	ip, ip, #69632	; 0x11000
   105c8:	e5bcf728 	ldr	pc, [ip, #1832]!	; 0x728

000105cc <usleep@plt>:
   105cc:	e28fc600 	add	ip, pc, #0, 12
   105d0:	e28cca11 	add	ip, ip, #69632	; 0x11000
   105d4:	e5bcf720 	ldr	pc, [ip, #1824]!	; 0x720

000105d8 <gettimeofday@plt>:
   105d8:	e28fc600 	add	ip, pc, #0, 12
   105dc:	e28cca11 	add	ip, ip, #69632	; 0x11000
   105e0:	e5bcf718 	ldr	pc, [ip, #1816]!	; 0x718

000105e4 <puts@plt>:
   105e4:	e28fc600 	add	ip, pc, #0, 12
   105e8:	e28cca11 	add	ip, ip, #69632	; 0x11000
   105ec:	e5bcf710 	ldr	pc, [ip, #1808]!	; 0x710

000105f0 <TEEC_InvokeCommand@plt>:
   105f0:	e28fc600 	add	ip, pc, #0, 12
   105f4:	e28cca11 	add	ip, ip, #69632	; 0x11000
   105f8:	e5bcf708 	ldr	pc, [ip, #1800]!	; 0x708

000105fc <memset@plt>:
   105fc:	e28fc600 	add	ip, pc, #0, 12
   10600:	e28cca11 	add	ip, ip, #69632	; 0x11000
   10604:	e5bcf700 	ldr	pc, [ip, #1792]!	; 0x700

00010608 <errx@plt>:
   10608:	e28fc600 	add	ip, pc, #0, 12
   1060c:	e28cca11 	add	ip, ip, #69632	; 0x11000
   10610:	e5bcf6f8 	ldr	pc, [ip, #1784]!	; 0x6f8

00010614 <sprintf@plt>:
   10614:	e28fc600 	add	ip, pc, #0, 12
   10618:	e28cca11 	add	ip, ip, #69632	; 0x11000
   1061c:	e5bcf6f0 	ldr	pc, [ip, #1776]!	; 0x6f0

00010620 <__isoc99_scanf@plt>:
   10620:	e28fc600 	add	ip, pc, #0, 12
   10624:	e28cca11 	add	ip, ip, #69632	; 0x11000
   10628:	e5bcf6e8 	ldr	pc, [ip, #1768]!	; 0x6e8

0001062c <atoi@plt>:
   1062c:	e28fc600 	add	ip, pc, #0, 12
   10630:	e28cca11 	add	ip, ip, #69632	; 0x11000
   10634:	e5bcf6e0 	ldr	pc, [ip, #1760]!	; 0x6e0

00010638 <TEEC_InitializeContext@plt>:
   10638:	e28fc600 	add	ip, pc, #0, 12
   1063c:	e28cca11 	add	ip, ip, #69632	; 0x11000
   10640:	e5bcf6d8 	ldr	pc, [ip, #1752]!	; 0x6d8

00010644 <TEEC_OpenSession@plt>:
   10644:	e28fc600 	add	ip, pc, #0, 12
   10648:	e28cca11 	add	ip, ip, #69632	; 0x11000
   1064c:	e5bcf6d0 	ldr	pc, [ip, #1744]!	; 0x6d0

Disassembly of section .DATA_REGION_0__data:

00010650 <global_data>:
   10650:	00000171 	andeq	r0, r0, r1, ror r1

Disassembly of section .DATA_REGION_1__share:

00010654 <.DATA_REGION_1__sdata_start>:
   10654:	00000000 	andeq	r0, r0, r0

Disassembly of section .DATA_REGION_1__data:

00010658 <.DATA_REGION_1__data_start>:
   10658:	5f64636c 	svcpl	0x0064636c
   1065c:	69676562 	stmdbvs	r7!, {r1, r5, r6, r8, sl, sp, lr}^
   10660:	636c006e 	cmnvs	ip, #110	; 0x6e
   10664:	6c635f64 	stclvs	15, cr5, [r3], #-400	; 0xfffffe70
   10668:	00726165 	rsbseq	r6, r2, r5, ror #2
   1066c:	5f64636c 	svcpl	0x0064636c
   10670:	6e697270 	mcrvs	2, 3, r7, cr9, cr0, {3}
   10674:	636c0074 	cmnvs	ip, #116	; 0x74
   10678:	65735f64 	ldrbvs	r5, [r3, #-3940]!	; 0xfffff09c
   1067c:	72754374 	rsbsvc	r4, r5, #116, 6	; 0xd0000001
   10680:	00726f73 	rsbseq	r6, r2, r3, ror pc

Disassembly of section .CODE_REGION_1_:

00010684 <lcd_begin>:
   10684:	e92d4800 	push	{fp, lr}
   10688:	e1a0b00d 	mov	fp, sp
   1068c:	e24dd010 	sub	sp, sp, #16
   10690:	e59f3038 	ldr	r3, [pc, #56]	; 106d0 <.DATA_REGION_1__data_end+0x4c>
   10694:	e58d1008 	str	r1, [sp, #8]
   10698:	e50b0004 	str	r0, [fp, #-4]
   1069c:	e58d2004 	str	r2, [sp, #4]
   106a0:	e5931000 	ldr	r1, [r3]
   106a4:	e59f0028 	ldr	r0, [pc, #40]	; 106d4 <.DATA_REGION_1__data_end+0x50>
   106a8:	e51b2004 	ldr	r2, [fp, #-4]
   106ac:	e2811001 	add	r1, r1, #1
   106b0:	e5831000 	str	r1, [r3]
   106b4:	e59d3008 	ldr	r3, [sp, #8]
   106b8:	e59f1018 	ldr	r1, [pc, #24]	; 106d8 <.DATA_REGION_1__data_end+0x54>
   106bc:	e59dc004 	ldr	ip, [sp, #4]
   106c0:	e58dc000 	str	ip, [sp]
   106c4:	ebffffba 	bl	105b4 <printf@plt>
   106c8:	e1a0d00b 	mov	sp, fp
   106cc:	e8bd8800 	pop	{fp, pc}
   106d0:	00010650 	andeq	r0, r1, r0, asr r6
   106d4:	00011a50 	andeq	r1, r1, r0, asr sl
   106d8:	00010658 	andeq	r0, r1, r8, asr r6

000106dc <lcd_clear>:
   106dc:	e92d4800 	push	{fp, lr}
   106e0:	e1a0b00d 	mov	fp, sp
   106e4:	e24dd008 	sub	sp, sp, #8
   106e8:	e59f2014 	ldr	r2, [pc, #20]	; 10704 <lcd_clear+0x28>
   106ec:	e59f1014 	ldr	r1, [pc, #20]	; 10708 <lcd_clear+0x2c>
   106f0:	e58d0004 	str	r0, [sp, #4]
   106f4:	e1a00002 	mov	r0, r2
   106f8:	ebffffad 	bl	105b4 <printf@plt>
   106fc:	e1a0d00b 	mov	sp, fp
   10700:	e8bd8800 	pop	{fp, pc}
   10704:	00011aa1 	andeq	r1, r1, r1, lsr #21
   10708:	00010662 	andeq	r0, r1, r2, ror #12

0001070c <lcd_print>:
   1070c:	e92d4800 	push	{fp, lr}
   10710:	e1a0b00d 	mov	fp, sp
   10714:	e24dd010 	sub	sp, sp, #16
   10718:	e50b0004 	str	r0, [fp, #-4]
   1071c:	e58d1008 	str	r1, [sp, #8]
   10720:	e59fc024 	ldr	ip, [pc, #36]	; 1074c <lcd_print+0x40>
   10724:	e51be004 	ldr	lr, [fp, #-4]
   10728:	e59d3008 	ldr	r3, [sp, #8]
   1072c:	e59f101c 	ldr	r1, [pc, #28]	; 10750 <lcd_print+0x44>
   10730:	e58d2004 	str	r2, [sp, #4]
   10734:	e58d2000 	str	r2, [sp]
   10738:	e1a0000c 	mov	r0, ip
   1073c:	e1a0200e 	mov	r2, lr
   10740:	ebffff9b 	bl	105b4 <printf@plt>
   10744:	e1a0d00b 	mov	sp, fp
   10748:	e8bd8800 	pop	{fp, pc}
   1074c:	00011ac1 	andeq	r1, r1, r1, asr #21
   10750:	0001066c 	andeq	r0, r1, ip, ror #12

00010754 <lcd_setCursor>:
   10754:	e92d4800 	push	{fp, lr}
   10758:	e1a0b00d 	mov	fp, sp
   1075c:	e24dd010 	sub	sp, sp, #16
   10760:	e59fe028 	ldr	lr, [pc, #40]	; 10790 <lcd_setCursor+0x3c>
   10764:	e59fc028 	ldr	ip, [pc, #40]	; 10794 <lcd_setCursor+0x40>
   10768:	e58d1008 	str	r1, [sp, #8]
   1076c:	e1a03002 	mov	r3, r2
   10770:	e59d2008 	ldr	r2, [sp, #8]
   10774:	e50b0004 	str	r0, [fp, #-4]
   10778:	e1a0000e 	mov	r0, lr
   1077c:	e1a0100c 	mov	r1, ip
   10780:	e58d3004 	str	r3, [sp, #4]
   10784:	ebffff8a 	bl	105b4 <printf@plt>
   10788:	e1a0d00b 	mov	sp, fp
   1078c:	e8bd8800 	pop	{fp, pc}
   10790:	00011b03 	andeq	r1, r1, r3, lsl #22
   10794:	00010676 	andeq	r0, r1, r6, ror r6

Disassembly of section .DATA_REGION_2__share:

00010798 <.DATA_REGION_2__sdata_start>:
   10798:	00000000 	andeq	r0, r0, r0

Disassembly of section .DATA_REGION_2__data:

0001079c <ustepsPerML>:
   1079c:	00001aaa 	andeq	r1, r0, sl, lsr #21

000107a0 <motorDirPin>:
   107a0:	00000002 	andeq	r0, r0, r2

000107a4 <motorStepPin>:
   107a4:	00000003 	andeq	r0, r0, r3

000107a8 <adc_key_val>:
   107a8:	0000001e 	andeq	r0, r0, lr, lsl r0
   107ac:	00000096 	muleq	r0, r6, r0
   107b0:	00000168 	andeq	r0, r0, r8, ror #2
   107b4:	00000217 	andeq	r0, r0, r7, lsl r2
   107b8:	000002f8 	strdeq	r0, [r0], -r8

000107bc <NUM_KEYS>:
   107bc:	00000005 	andeq	r0, r0, r5

000107c0 <key>:
   107c0:	00000005 	andeq	r0, r0, r5

000107c4 <mLBolusSteps>:
   107c4:	3a83126f 	bcc	fe0d5188 <__bss_end__+0xfe0b33b8>
   107c8:	3ba3d70a 	blcc	fe9063f8 <__bss_end__+0xfe8e4628>
   107cc:	3c23d70a 	stccc	7, cr13, [r3], #-40	; 0xffffffd8
   107d0:	3d4ccccd 	stclcc	12, cr12, [ip, #-820]	; 0xfffffccc
   107d4:	3dcccccd 	stclcc	12, cr12, [ip, #820]	; 0x334
   107d8:	3f000000 	svccc	0x00000000
   107dc:	3f800000 	svccc	0x00800000
   107e0:	40a00000 	adcmi	r0, r0, r0
   107e4:	41200000 			; <UNDEFINED> instruction: 0x41200000

000107e8 <mLBolus>:
   107e8:	3f000000 	svccc	0x00000000

000107ec <mLBigBolus>:
   107ec:	3f800000 	svccc	0x00800000

000107f0 <mLBolusStepIdx>:
   107f0:	00000003 	andeq	r0, r0, r3

000107f4 <mLBolusStep>:
   107f4:	3d4ccccd 	stclcc	12, cr12, [ip, #-820]	; 0xfffffccc

000107f8 <keyRepeatDelay>:
   107f8:	00000190 	muleq	r0, r0, r1

000107fc <keyDebounce>:
   107fc:	0000007d 	andeq	r0, r0, sp, ror r0

00010800 <prevKey>:
   10800:	00000005 	andeq	r0, r0, r5

Disassembly of section .DATA_REGION_2__bss:

00010804 <triggerPin>:
   10804:	00000000 	andeq	r0, r0, r0

00010808 <bigTriggerPin>:
   10808:	00000000 	andeq	r0, r0, r0

0001080c <mLUsed>:
   1080c:	00000000 	andeq	r0, r0, r0

00010810 <lastKeyRepeatAt>:
   10810:	00000000 	andeq	r0, r0, r0

00010814 <uiState>:
   10814:	00000000 	andeq	r0, r0, r0

00010818 <prevBigTrigger>:
   10818:	00000000 	andeq	r0, r0, r0

0001081c <prevTrigger>:
   1081c:	00000000 	andeq	r0, r0, r0

00010820 <serialStr>:
	...

00010870 <serialStrReady>:
   10870:	00000000 	andeq	r0, r0, r0

00010874 <serialStrLen>:
   10874:	00000000 	andeq	r0, r0, r0

Disassembly of section .CODE_REGION_2_:

00010878 <setup>:
   10878:	e92d4830 	push	{r4, r5, fp, lr}
   1087c:	e28db008 	add	fp, sp, #8
   10880:	e59f4088 	ldr	r4, [pc, #136]	; 10910 <.DATA_REGION_2__bss_end+0x98>
   10884:	e3a01010 	mov	r1, #16
   10888:	e3a02002 	mov	r2, #2
   1088c:	e1a00004 	mov	r0, r4
   10890:	ebffff7b 	bl	10684 <.DATA_REGION_1__data_end>
   10894:	e1a00004 	mov	r0, r4
   10898:	ebffff8f 	bl	106dc <lcd_clear>
   1089c:	e59f1070 	ldr	r1, [pc, #112]	; 10914 <.DATA_REGION_2__bss_end+0x9c>
   108a0:	e1a00004 	mov	r0, r4
   108a4:	e3a02010 	mov	r2, #16
   108a8:	ebffff97 	bl	1070c <lcd_print>
   108ac:	e59f4064 	ldr	r4, [pc, #100]	; 10918 <.DATA_REGION_2__bss_end+0xa0>
   108b0:	e3a01000 	mov	r1, #0
   108b4:	e5940000 	ldr	r0, [r4]
   108b8:	eb000297 	bl	1131c <.DATA_REGION_4__data_end>
   108bc:	e59f5058 	ldr	r5, [pc, #88]	; 1091c <.DATA_REGION_2__bss_end+0xa4>
   108c0:	e3a01000 	mov	r1, #0
   108c4:	e5950000 	ldr	r0, [r5]
   108c8:	eb000293 	bl	1131c <.DATA_REGION_4__data_end>
   108cc:	e5940000 	ldr	r0, [r4]
   108d0:	e3a01000 	mov	r1, #0
   108d4:	eb0002b0 	bl	1139c <digitalWrite>
   108d8:	e5950000 	ldr	r0, [r5]
   108dc:	e3a01000 	mov	r1, #0
   108e0:	eb0002ad 	bl	1139c <digitalWrite>
   108e4:	e59f0034 	ldr	r0, [pc, #52]	; 10920 <.DATA_REGION_2__bss_end+0xa8>
   108e8:	e3a01001 	mov	r1, #1
   108ec:	e5900000 	ldr	r0, [r0]
   108f0:	eb000289 	bl	1131c <.DATA_REGION_4__data_end>
   108f4:	e59f0028 	ldr	r0, [pc, #40]	; 10924 <.DATA_REGION_2__bss_end+0xac>
   108f8:	e3a01001 	mov	r1, #1
   108fc:	e5900000 	ldr	r0, [r0]
   10900:	eb000285 	bl	1131c <.DATA_REGION_4__data_end>
   10904:	e3a00ce1 	mov	r0, #57600	; 0xe100
   10908:	eb0002a8 	bl	113b0 <Serial_begin>
   1090c:	e8bd8830 	pop	{r4, r5, fp, pc}
   10910:	00021d74 	andeq	r1, r2, r4, ror sp
   10914:	000118f0 	strdeq	r1, [r1], -r0
   10918:	00010804 	andeq	r0, r1, r4, lsl #16
   1091c:	00010808 	andeq	r0, r1, r8, lsl #16
   10920:	000107a0 	andeq	r0, r1, r0, lsr #15
   10924:	000107a4 	andeq	r0, r1, r4, lsr #15

00010928 <loop>:
   10928:	e92d4830 	push	{r4, r5, fp, lr}
   1092c:	e28db008 	add	fp, sp, #8
   10930:	e24dd010 	sub	sp, sp, #16
   10934:	ee000a10 	vmov	s0, r0
   10938:	ed9f1b1e 	vldr	d1, [pc, #120]	; 109b8 <loop+0x90>
   1093c:	e59f1084 	ldr	r1, [pc, #132]	; 109c8 <loop+0xa0>
   10940:	e59f5078 	ldr	r5, [pc, #120]	; 109c0 <loop+0x98>
   10944:	e59f4078 	ldr	r4, [pc, #120]	; 109c4 <loop+0x9c>
   10948:	eeb80bc0 	vcvt.f64.s32	d0, s0
   1094c:	e58d000c 	str	r0, [sp, #12]
   10950:	e3a0002b 	mov	r0, #43	; 0x2b
   10954:	e5c10000 	strb	r0, [r1]
   10958:	e3a00001 	mov	r0, #1
   1095c:	e5c50000 	strb	r0, [r5]
   10960:	ee200b01 	vmul.f64	d0, d0, d1
   10964:	eeb70bc0 	vcvt.f32.f64	s0, d0
   10968:	ed840a00 	vstr	s0, [r4]
   1096c:	eb0002e6 	bl	1150c <usecs>
   10970:	e58d0008 	str	r0, [sp, #8]
   10974:	e5d50000 	ldrb	r0, [r5]
   10978:	e3100001 	tst	r0, #1
   1097c:	1b000013 	blne	109d0 <processSerial>
   10980:	eb0002e1 	bl	1150c <usecs>
   10984:	ed940a00 	vldr	s0, [r4]
   10988:	e59d5008 	ldr	r5, [sp, #8]
   1098c:	e59f1038 	ldr	r1, [pc, #56]	; 109cc <loop+0xa4>
   10990:	e58d0004 	str	r0, [sp, #4]
   10994:	eeb70ac0 	vcvt.f64.f32	d0, s0
   10998:	e0400005 	sub	r0, r0, r5
   1099c:	e58d0000 	str	r0, [sp]
   109a0:	e1a00001 	mov	r0, r1
   109a4:	ec532b10 	vmov	r2, r3, d0
   109a8:	ebffff01 	bl	105b4 <printf@plt>
   109ac:	e24bd008 	sub	sp, fp, #8
   109b0:	e8bd8830 	pop	{r4, r5, fp, pc}
   109b4:	e1a00000 	nop			; (mov r0, r0)
   109b8:	d2f1a9fc 	rscsle	sl, r1, #252, 18	; 0x3f0000
   109bc:	3f50624d 	svccc	0x0050624d
   109c0:	00010870 	andeq	r0, r1, r0, ror r8
   109c4:	000107e8 	andeq	r0, r1, r8, ror #15
   109c8:	00010820 	andeq	r0, r1, r0, lsr #16
   109cc:	00011901 	andeq	r1, r1, r1, lsl #18

000109d0 <processSerial>:
   109d0:	e92d4c10 	push	{r4, sl, fp, lr}
   109d4:	e28db008 	add	fp, sp, #8
   109d8:	e24dd008 	sub	sp, sp, #8
   109dc:	e59f00c4 	ldr	r0, [pc, #196]	; 10aa8 <processSerial+0xd8>
   109e0:	e5d01000 	ldrb	r1, [r0]
   109e4:	e351002b 	cmp	r1, #43	; 0x2b
   109e8:	1a000001 	bne	109f4 <processSerial+0x24>
   109ec:	e3a00000 	mov	r0, #0
   109f0:	ea000003 	b	10a04 <processSerial+0x34>
   109f4:	e5d00000 	ldrb	r0, [r0]
   109f8:	e350002d 	cmp	r0, #45	; 0x2d
   109fc:	1a000009 	bne	10a28 <processSerial+0x58>
   10a00:	e3a00001 	mov	r0, #1
   10a04:	eb00002d 	bl	10ac0 <bolus>
   10a08:	eb000082 	bl	10c18 <updateScreen>
   10a0c:	e59f00a8 	ldr	r0, [pc, #168]	; 10abc <processSerial+0xec>
   10a10:	e59f1094 	ldr	r1, [pc, #148]	; 10aac <processSerial+0xdc>
   10a14:	e3a02000 	mov	r2, #0
   10a18:	e5c02000 	strb	r2, [r0]
   10a1c:	e5812000 	str	r2, [r1]
   10a20:	e24bd008 	sub	sp, fp, #8
   10a24:	e8bd8c10 	pop	{r4, sl, fp, pc}
   10a28:	e59f407c 	ldr	r4, [pc, #124]	; 10aac <processSerial+0xdc>
   10a2c:	e59f0074 	ldr	r0, [pc, #116]	; 10aa8 <processSerial+0xd8>
   10a30:	e5941000 	ldr	r1, [r4]
   10a34:	eb0002c9 	bl	11560 <toUInt>
   10a38:	e3500000 	cmp	r0, #0
   10a3c:	0a00000c 	beq	10a74 <processSerial+0xa4>
   10a40:	e59f0060 	ldr	r0, [pc, #96]	; 10aa8 <processSerial+0xd8>
   10a44:	e5941000 	ldr	r1, [r4]
   10a48:	eb0002c4 	bl	11560 <toUInt>
   10a4c:	ee000a10 	vmov	s0, r0
   10a50:	ed9f1b12 	vldr	d1, [pc, #72]	; 10aa0 <processSerial+0xd0>
   10a54:	e59f105c 	ldr	r1, [pc, #92]	; 10ab8 <processSerial+0xe8>
   10a58:	eeb80ac0 	vcvt.f32.s32	s0, s0
   10a5c:	e58d0004 	str	r0, [sp, #4]
   10a60:	eeb70ac0 	vcvt.f64.f32	d0, s0
   10a64:	ee800b01 	vdiv.f64	d0, d0, d1
   10a68:	eeb70bc0 	vcvt.f32.f64	s0, d0
   10a6c:	ed810a00 	vstr	s0, [r1]
   10a70:	eaffffe4 	b	10a08 <processSerial+0x38>
   10a74:	e59f0034 	ldr	r0, [pc, #52]	; 10ab0 <processSerial+0xe0>
   10a78:	e3a01012 	mov	r1, #18
   10a7c:	eb000273 	bl	11450 <Serial_write>
   10a80:	e59f0020 	ldr	r0, [pc, #32]	; 10aa8 <processSerial+0xd8>
   10a84:	e5941000 	ldr	r1, [r4]
   10a88:	eb000270 	bl	11450 <Serial_write>
   10a8c:	e59f0020 	ldr	r0, [pc, #32]	; 10ab4 <processSerial+0xe4>
   10a90:	e3a01002 	mov	r1, #2
   10a94:	eb00026d 	bl	11450 <Serial_write>
   10a98:	eaffffdb 	b	10a0c <processSerial+0x3c>
   10a9c:	e1a00000 	nop			; (mov r0, r0)
   10aa0:	00000000 	andeq	r0, r0, r0
   10aa4:	408f4000 	addmi	r4, pc, r0
   10aa8:	00010820 	andeq	r0, r1, r0, lsr #16
   10aac:	00010874 	andeq	r0, r1, r4, ror r8
   10ab0:	00011920 	andeq	r1, r1, r0, lsr #18
   10ab4:	00011933 	andeq	r1, r1, r3, lsr r9
   10ab8:	000107e8 	andeq	r0, r1, r8, ror #15
   10abc:	00010870 	andeq	r0, r1, r0, ror r8

00010ac0 <bolus>:
   10ac0:	e92d4830 	push	{r4, r5, fp, lr}
   10ac4:	e28db008 	add	fp, sp, #8
   10ac8:	e24dd010 	sub	sp, sp, #16
   10acc:	e59f512c 	ldr	r5, [pc, #300]	; 10c00 <bolus+0x140>
   10ad0:	e58d000c 	str	r0, [sp, #12]
   10ad4:	e59f4128 	ldr	r4, [pc, #296]	; 10c04 <bolus+0x144>
   10ad8:	ed950a00 	vldr	s0, [r5]
   10adc:	eeb80ac0 	vcvt.f32.s32	s0, s0
   10ae0:	ed941a00 	vldr	s2, [r4]
   10ae4:	ee210a00 	vmul.f32	s0, s2, s0
   10ae8:	eebd0ac0 	vcvt.s32.f32	s0, s0
   10aec:	e59d000c 	ldr	r0, [sp, #12]
   10af0:	e3500000 	cmp	r0, #0
   10af4:	ed8d0a02 	vstr	s0, [sp, #8]
   10af8:	0a000013 	beq	10b4c <bolus+0x8c>
   10afc:	e59d000c 	ldr	r0, [sp, #12]
   10b00:	e3500001 	cmp	r0, #1
   10b04:	1a000023 	bne	10b98 <bolus+0xd8>
   10b08:	eb0002b0 	bl	115d0 <led_off>
   10b0c:	e59f00f4 	ldr	r0, [pc, #244]	; 10c08 <bolus+0x148>
   10b10:	e3a01001 	mov	r1, #1
   10b14:	e5900000 	ldr	r0, [r0]
   10b18:	eb00021f 	bl	1139c <digitalWrite>
   10b1c:	e59f00e8 	ldr	r0, [pc, #232]	; 10c0c <bolus+0x14c>
   10b20:	ed940a00 	vldr	s0, [r4]
   10b24:	ed901a00 	vldr	s2, [r0]
   10b28:	ee310a40 	vsub.f32	s0, s2, s0
   10b2c:	eeb50ac0 	vcmpe.f32	s0, #0.0
   10b30:	eef1fa10 	vmrs	APSR_nzcv, fpscr
   10b34:	da000015 	ble	10b90 <bolus+0xd0>
   10b38:	ed940a00 	vldr	s0, [r4]
   10b3c:	ed901a00 	vldr	s2, [r0]
   10b40:	ee310a40 	vsub.f32	s0, s2, s0
   10b44:	ed800a00 	vstr	s0, [r0]
   10b48:	ea000012 	b	10b98 <bolus+0xd8>
   10b4c:	eb000292 	bl	1159c <.DATA_REGION_5__data_end>
   10b50:	e59f00b0 	ldr	r0, [pc, #176]	; 10c08 <bolus+0x148>
   10b54:	e3a01000 	mov	r1, #0
   10b58:	e5900000 	ldr	r0, [r0]
   10b5c:	eb00020e 	bl	1139c <digitalWrite>
   10b60:	ed950a00 	vldr	s0, [r5]
   10b64:	e59f00a0 	ldr	r0, [pc, #160]	; 10c0c <bolus+0x14c>
   10b68:	eeb80ac0 	vcvt.f32.s32	s0, s0
   10b6c:	ed941a00 	vldr	s2, [r4]
   10b70:	ee210a00 	vmul.f32	s0, s2, s0
   10b74:	eebd0ac0 	vcvt.s32.f32	s0, s0
   10b78:	ed901a00 	vldr	s2, [r0]
   10b7c:	ed8d0a02 	vstr	s0, [sp, #8]
   10b80:	ed940a00 	vldr	s0, [r4]
   10b84:	ee310a00 	vadd.f32	s0, s2, s0
   10b88:	ed800a00 	vstr	s0, [r0]
   10b8c:	ea000001 	b	10b98 <bolus+0xd8>
   10b90:	e3a01000 	mov	r1, #0
   10b94:	e5801000 	str	r1, [r0]
   10b98:	e59f4070 	ldr	r4, [pc, #112]	; 10c10 <bolus+0x150>
   10b9c:	e3a007b2 	mov	r0, #46661632	; 0x2c80000
   10ba0:	e3800101 	orr	r0, r0, #1073741824	; 0x40000000
   10ba4:	e58d0004 	str	r0, [sp, #4]
   10ba8:	e3a00000 	mov	r0, #0
   10bac:	e58d0000 	str	r0, [sp]
   10bb0:	ea00000c 	b	10be8 <bolus+0x128>
   10bb4:	e5940000 	ldr	r0, [r4]
   10bb8:	e3a01000 	mov	r1, #0
   10bbc:	eb0001f6 	bl	1139c <digitalWrite>
   10bc0:	ed9d0a01 	vldr	s0, [sp, #4]
   10bc4:	eb00025c 	bl	1153c <delayMicroseconds>
   10bc8:	e5940000 	ldr	r0, [r4]
   10bcc:	e3a01001 	mov	r1, #1
   10bd0:	eb0001f1 	bl	1139c <digitalWrite>
   10bd4:	ed9d0a01 	vldr	s0, [sp, #4]
   10bd8:	eb000257 	bl	1153c <delayMicroseconds>
   10bdc:	e59d0000 	ldr	r0, [sp]
   10be0:	e2800001 	add	r0, r0, #1
   10be4:	e58d0000 	str	r0, [sp]
   10be8:	e59d0008 	ldr	r0, [sp, #8]
   10bec:	e59d1000 	ldr	r1, [sp]
   10bf0:	e1510000 	cmp	r1, r0
   10bf4:	baffffee 	blt	10bb4 <bolus+0xf4>
   10bf8:	e24bd008 	sub	sp, fp, #8
   10bfc:	e8bd8830 	pop	{r4, r5, fp, pc}
   10c00:	0001079c 	muleq	r1, ip, r7
   10c04:	000107e8 	andeq	r0, r1, r8, ror #15
   10c08:	000107a0 	andeq	r0, r1, r0, lsr #15
   10c0c:	0001080c 	andeq	r0, r1, ip, lsl #16
   10c10:	000107a4 	andeq	r0, r1, r4, lsr #15
   10c14:	e1a00000 	nop			; (mov r0, r0)

00010c18 <updateScreen>:
   10c18:	e92d4c10 	push	{r4, sl, fp, lr}
   10c1c:	e28db008 	add	fp, sp, #8
   10c20:	ed2d8b04 	vpush	{d8-d9}
   10c24:	e24dd0a8 	sub	sp, sp, #168	; 0xa8
   10c28:	e59f0158 	ldr	r0, [pc, #344]	; 10d88 <updateScreen+0x170>
   10c2c:	e3a01000 	mov	r1, #0
   10c30:	e58d1004 	str	r1, [sp, #4]
   10c34:	e58d1000 	str	r1, [sp]
   10c38:	e5901000 	ldr	r1, [r0]
   10c3c:	e3510000 	cmp	r1, #0
   10c40:	0a000013 	beq	10c94 <updateScreen+0x7c>
   10c44:	e5900000 	ldr	r0, [r0]
   10c48:	e3500001 	cmp	r0, #1
   10c4c:	1a000032 	bne	10d1c <updateScreen+0x104>
   10c50:	e59f1134 	ldr	r1, [pc, #308]	; 10d8c <updateScreen+0x174>
   10c54:	e28d0058 	add	r0, sp, #88	; 0x58
   10c58:	ebfffe6d 	bl	10614 <sprintf@plt>
   10c5c:	e59f112c 	ldr	r1, [pc, #300]	; 10d90 <updateScreen+0x178>
   10c60:	e58d0004 	str	r0, [sp, #4]
   10c64:	ed9f1b43 	vldr	d1, [pc, #268]	; 10d78 <updateScreen+0x160>
   10c68:	ed910a00 	vldr	s0, [r1]
   10c6c:	ed9f3b43 	vldr	d3, [pc, #268]	; 10d80 <updateScreen+0x168>
   10c70:	e59f111c 	ldr	r1, [pc, #284]	; 10d94 <updateScreen+0x17c>
   10c74:	eeb72ac0 	vcvt.f64.f32	d2, s0
   10c78:	eebd0ac0 	vcvt.s32.f32	s0, s0
   10c7c:	ee222b01 	vmul.f64	d2, d2, d1
   10c80:	ee102a10 	vmov	r2, s0
   10c84:	eeb80bc0 	vcvt.f64.s32	d0, s0
   10c88:	ee200b01 	vmul.f64	d0, d0, d1
   10c8c:	ee321b03 	vadd.f64	d1, d2, d3
   10c90:	ea00001b 	b	10d04 <updateScreen+0xec>
   10c94:	e59f00fc 	ldr	r0, [pc, #252]	; 10d98 <updateScreen+0x180>
   10c98:	ed9f8b36 	vldr	d8, [pc, #216]	; 10d78 <updateScreen+0x160>
   10c9c:	ed9f9b37 	vldr	d9, [pc, #220]	; 10d80 <updateScreen+0x168>
   10ca0:	ed900a00 	vldr	s0, [r0]
   10ca4:	e59f10f0 	ldr	r1, [pc, #240]	; 10d9c <updateScreen+0x184>
   10ca8:	e28d0058 	add	r0, sp, #88	; 0x58
   10cac:	eeb71ac0 	vcvt.f64.f32	d1, s0
   10cb0:	eebd0ac0 	vcvt.s32.f32	s0, s0
   10cb4:	ee211b08 	vmul.f64	d1, d1, d8
   10cb8:	ee102a10 	vmov	r2, s0
   10cbc:	eeb80bc0 	vcvt.f64.s32	d0, s0
   10cc0:	ee311b09 	vadd.f64	d1, d1, d9
   10cc4:	ee200b08 	vmul.f64	d0, d0, d8
   10cc8:	ee310b40 	vsub.f64	d0, d1, d0
   10ccc:	eebd0bc0 	vcvt.s32.f64	s0, d0
   10cd0:	ee103a10 	vmov	r3, s0
   10cd4:	ebfffe4e 	bl	10614 <sprintf@plt>
   10cd8:	e59f10c0 	ldr	r1, [pc, #192]	; 10da0 <updateScreen+0x188>
   10cdc:	e58d0004 	str	r0, [sp, #4]
   10ce0:	ed910a00 	vldr	s0, [r1]
   10ce4:	e59f10b8 	ldr	r1, [pc, #184]	; 10da4 <updateScreen+0x18c>
   10ce8:	eeb71ac0 	vcvt.f64.f32	d1, s0
   10cec:	eebd0ac0 	vcvt.s32.f32	s0, s0
   10cf0:	ee211b08 	vmul.f64	d1, d1, d8
   10cf4:	ee102a10 	vmov	r2, s0
   10cf8:	eeb80bc0 	vcvt.f64.s32	d0, s0
   10cfc:	ee311b09 	vadd.f64	d1, d1, d9
   10d00:	ee200b08 	vmul.f64	d0, d0, d8
   10d04:	ee310b40 	vsub.f64	d0, d1, d0
   10d08:	eebd0bc0 	vcvt.s32.f64	s0, d0
   10d0c:	ee103a10 	vmov	r3, s0
   10d10:	e28d0008 	add	r0, sp, #8
   10d14:	ebfffe3e 	bl	10614 <sprintf@plt>
   10d18:	e58d0000 	str	r0, [sp]
   10d1c:	e59f4084 	ldr	r4, [pc, #132]	; 10da8 <updateScreen+0x190>
   10d20:	e1a00004 	mov	r0, r4
   10d24:	ebfffe6c 	bl	106dc <lcd_clear>
   10d28:	e1a00004 	mov	r0, r4
   10d2c:	e3a01000 	mov	r1, #0
   10d30:	e3a02000 	mov	r2, #0
   10d34:	ebfffe86 	bl	10754 <lcd_setCursor>
   10d38:	e59d2004 	ldr	r2, [sp, #4]
   10d3c:	e28d1058 	add	r1, sp, #88	; 0x58
   10d40:	e1a00004 	mov	r0, r4
   10d44:	ebfffe70 	bl	1070c <lcd_print>
   10d48:	e1a00004 	mov	r0, r4
   10d4c:	e3a01000 	mov	r1, #0
   10d50:	e3a02001 	mov	r2, #1
   10d54:	ebfffe7e 	bl	10754 <lcd_setCursor>
   10d58:	e59d2000 	ldr	r2, [sp]
   10d5c:	e28d1008 	add	r1, sp, #8
   10d60:	e1a00004 	mov	r0, r4
   10d64:	ebfffe68 	bl	1070c <lcd_print>
   10d68:	e24bd018 	sub	sp, fp, #24
   10d6c:	ecbd8b04 	vpop	{d8-d9}
   10d70:	e8bd8c10 	pop	{r4, sl, fp, pc}
   10d74:	e1a00000 	nop			; (mov r0, r0)
   10d78:	00000000 	andeq	r0, r0, r0
   10d7c:	408f4000 	addmi	r4, pc, r0
   10d80:	00000000 	andeq	r0, r0, r0
   10d84:	3fe00000 	svccc	0x00e00000
   10d88:	00010814 	andeq	r0, r1, r4, lsl r8
   10d8c:	00011953 	andeq	r1, r1, r3, asr r9
   10d90:	000107f4 	strdeq	r0, [r1], -r4
   10d94:	00011963 	andeq	r1, r1, r3, ror #18
   10d98:	0001080c 	andeq	r0, r1, ip, lsl #16
   10d9c:	00011936 	andeq	r1, r1, r6, lsr r9
   10da0:	000107e8 	andeq	r0, r1, r8, ror #15
   10da4:	00011944 	andeq	r1, r1, r4, asr #18
   10da8:	00021d74 	andeq	r1, r2, r4, ror sp

00010dac <checkTriggers>:
   10dac:	e92d4c10 	push	{r4, sl, fp, lr}
   10db0:	e28db008 	add	fp, sp, #8
   10db4:	e24dd010 	sub	sp, sp, #16
   10db8:	e59f00a0 	ldr	r0, [pc, #160]	; 10e60 <checkTriggers+0xb4>
   10dbc:	e5900000 	ldr	r0, [r0]
   10dc0:	eb000164 	bl	11358 <digitalRead>
   10dc4:	e58d000c 	str	r0, [sp, #12]
   10dc8:	e3500000 	cmp	r0, #0
   10dcc:	1a000006 	bne	10dec <checkTriggers+0x40>
   10dd0:	e59f008c 	ldr	r0, [pc, #140]	; 10e64 <checkTriggers+0xb8>
   10dd4:	e5900000 	ldr	r0, [r0]
   10dd8:	e3500001 	cmp	r0, #1
   10ddc:	1a000002 	bne	10dec <checkTriggers+0x40>
   10de0:	e3a00000 	mov	r0, #0
   10de4:	ebffff35 	bl	10ac0 <bolus>
   10de8:	ebffff8a 	bl	10c18 <updateScreen>
   10dec:	e59f0074 	ldr	r0, [pc, #116]	; 10e68 <checkTriggers+0xbc>
   10df0:	e59f106c 	ldr	r1, [pc, #108]	; 10e64 <checkTriggers+0xb8>
   10df4:	e59d200c 	ldr	r2, [sp, #12]
   10df8:	e5900000 	ldr	r0, [r0]
   10dfc:	e5812000 	str	r2, [r1]
   10e00:	eb000154 	bl	11358 <digitalRead>
   10e04:	e58d0008 	str	r0, [sp, #8]
   10e08:	e3500000 	cmp	r0, #0
   10e0c:	1a00000e 	bne	10e4c <checkTriggers+0xa0>
   10e10:	e59f0054 	ldr	r0, [pc, #84]	; 10e6c <checkTriggers+0xc0>
   10e14:	e5900000 	ldr	r0, [r0]
   10e18:	e3500001 	cmp	r0, #1
   10e1c:	1a00000a 	bne	10e4c <checkTriggers+0xa0>
   10e20:	e59f004c 	ldr	r0, [pc, #76]	; 10e74 <checkTriggers+0xc8>
   10e24:	e59f4044 	ldr	r4, [pc, #68]	; 10e70 <checkTriggers+0xc4>
   10e28:	e5900000 	ldr	r0, [r0]
   10e2c:	e5941000 	ldr	r1, [r4]
   10e30:	e5840000 	str	r0, [r4]
   10e34:	e3a00000 	mov	r0, #0
   10e38:	e58d1004 	str	r1, [sp, #4]
   10e3c:	ebffff1f 	bl	10ac0 <bolus>
   10e40:	e59d0004 	ldr	r0, [sp, #4]
   10e44:	e5840000 	str	r0, [r4]
   10e48:	ebffff72 	bl	10c18 <updateScreen>
   10e4c:	e59f0018 	ldr	r0, [pc, #24]	; 10e6c <checkTriggers+0xc0>
   10e50:	e59d1008 	ldr	r1, [sp, #8]
   10e54:	e5801000 	str	r1, [r0]
   10e58:	e24bd008 	sub	sp, fp, #8
   10e5c:	e8bd8c10 	pop	{r4, sl, fp, pc}
   10e60:	00010804 	andeq	r0, r1, r4, lsl #16
   10e64:	0001081c 	andeq	r0, r1, ip, lsl r8
   10e68:	00010808 	andeq	r0, r1, r8, lsl #16
   10e6c:	00010818 	andeq	r0, r1, r8, lsl r8
   10e70:	000107e8 	andeq	r0, r1, r8, ror #15
   10e74:	000107ec 	andeq	r0, r1, ip, ror #15

00010e78 <readSerial>:
   10e78:	e92d48f0 	push	{r4, r5, r6, r7, fp, lr}
   10e7c:	e28db010 	add	fp, sp, #16
   10e80:	e24dd008 	sub	sp, sp, #8
   10e84:	e59f405c 	ldr	r4, [pc, #92]	; 10ee8 <readSerial+0x70>
   10e88:	e59f6050 	ldr	r6, [pc, #80]	; 10ee0 <readSerial+0x68>
   10e8c:	e59f7050 	ldr	r7, [pc, #80]	; 10ee4 <readSerial+0x6c>
   10e90:	e3a05001 	mov	r5, #1
   10e94:	ea000005 	b	10eb0 <readSerial+0x38>
   10e98:	e5961000 	ldr	r1, [r6]
   10e9c:	e5dd0007 	ldrb	r0, [sp, #7]
   10ea0:	e7c70001 	strb	r0, [r7, r1]
   10ea4:	e5960000 	ldr	r0, [r6]
   10ea8:	e2800001 	add	r0, r0, #1
   10eac:	e5860000 	str	r0, [r6]
   10eb0:	eb00014a 	bl	113e0 <Serial_available>
   10eb4:	e3500000 	cmp	r0, #0
   10eb8:	0a000006 	beq	10ed8 <readSerial+0x60>
   10ebc:	eb00015b 	bl	11430 <Serial_read>
   10ec0:	e5cd0007 	strb	r0, [sp, #7]
   10ec4:	e5dd0007 	ldrb	r0, [sp, #7]
   10ec8:	e350001f 	cmp	r0, #31
   10ecc:	cafffff1 	bgt	10e98 <readSerial+0x20>
   10ed0:	e5c45000 	strb	r5, [r4]
   10ed4:	eafffff5 	b	10eb0 <readSerial+0x38>
   10ed8:	e24bd010 	sub	sp, fp, #16
   10edc:	e8bd88f0 	pop	{r4, r5, r6, r7, fp, pc}
   10ee0:	00010874 	andeq	r0, r1, r4, ror r8
   10ee4:	00010820 	andeq	r0, r1, r0, lsr #16
   10ee8:	00010870 	andeq	r0, r1, r0, ror r8

00010eec <readKey>:
   10eec:	e92d4c70 	push	{r4, r5, r6, sl, fp, lr}
   10ef0:	e28db010 	add	fp, sp, #16
   10ef4:	e24dd010 	sub	sp, sp, #16
   10ef8:	e3a00000 	mov	r0, #0
   10efc:	e3a06000 	mov	r6, #0
   10f00:	eb000162 	bl	11490 <analogRead>
   10f04:	e59f10b4 	ldr	r1, [pc, #180]	; 10fc0 <readKey+0xd4>
   10f08:	e5810000 	str	r0, [r1]
   10f0c:	eb000031 	bl	10fd8 <get_key>
   10f10:	e59f40ac 	ldr	r4, [pc, #172]	; 10fc4 <readKey+0xd8>
   10f14:	e5840000 	str	r0, [r4]
   10f18:	eb00016b 	bl	114cc <millis>
   10f1c:	e59f50a4 	ldr	r5, [pc, #164]	; 10fc8 <readKey+0xdc>
   10f20:	e59f10a4 	ldr	r1, [pc, #164]	; 10fcc <readKey+0xe0>
   10f24:	e58d000c 	str	r0, [sp, #12]
   10f28:	e5cd6007 	strb	r6, [sp, #7]
   10f2c:	e5952000 	ldr	r2, [r5]
   10f30:	e0400002 	sub	r0, r0, r2
   10f34:	e58d0008 	str	r0, [sp, #8]
   10f38:	e5940000 	ldr	r0, [r4]
   10f3c:	e5912000 	ldr	r2, [r1]
   10f40:	e1520000 	cmp	r2, r0
   10f44:	1a000005 	bne	10f60 <readKey+0x74>
   10f48:	e59f0080 	ldr	r0, [pc, #128]	; 10fd0 <readKey+0xe4>
   10f4c:	e59d2008 	ldr	r2, [sp, #8]
   10f50:	e5900000 	ldr	r0, [r0]
   10f54:	e1520000 	cmp	r2, r0
   10f58:	c3a00001 	movgt	r0, #1
   10f5c:	c5cd0007 	strbgt	r0, [sp, #7]
   10f60:	e5910000 	ldr	r0, [r1]
   10f64:	e3500005 	cmp	r0, #5
   10f68:	1a000005 	bne	10f84 <readKey+0x98>
   10f6c:	e59f0060 	ldr	r0, [pc, #96]	; 10fd4 <readKey+0xe8>
   10f70:	e59d2008 	ldr	r2, [sp, #8]
   10f74:	e5900000 	ldr	r0, [r0]
   10f78:	e1520000 	cmp	r2, r0
   10f7c:	c3a00001 	movgt	r0, #1
   10f80:	c5cd0007 	strbgt	r0, [sp, #7]
   10f84:	e5940000 	ldr	r0, [r4]
   10f88:	e3500005 	cmp	r0, #5
   10f8c:	03a00000 	moveq	r0, #0
   10f90:	05cd0007 	strbeq	r0, [sp, #7]
   10f94:	e5940000 	ldr	r0, [r4]
   10f98:	e5810000 	str	r0, [r1]
   10f9c:	e5dd0007 	ldrb	r0, [sp, #7]
   10fa0:	e3100001 	tst	r0, #1
   10fa4:	0a000003 	beq	10fb8 <readKey+0xcc>
   10fa8:	e5940000 	ldr	r0, [r4]
   10fac:	eb000029 	bl	11058 <doKeyAction>
   10fb0:	e59d000c 	ldr	r0, [sp, #12]
   10fb4:	e5850000 	str	r0, [r5]
   10fb8:	e24bd010 	sub	sp, fp, #16
   10fbc:	e8bd8c70 	pop	{r4, r5, r6, sl, fp, pc}
   10fc0:	00021d70 	andeq	r1, r2, r0, ror sp
   10fc4:	000107c0 	andeq	r0, r1, r0, asr #15
   10fc8:	00010810 	andeq	r0, r1, r0, lsl r8
   10fcc:	00010800 	andeq	r0, r1, r0, lsl #16
   10fd0:	000107f8 	strdeq	r0, [r1], -r8
   10fd4:	000107fc 	strdeq	r0, [r1], -ip

00010fd8 <get_key>:
   10fd8:	e24dd00c 	sub	sp, sp, #12
   10fdc:	e58d0004 	str	r0, [sp, #4]
   10fe0:	e3a00000 	mov	r0, #0
   10fe4:	e58d0000 	str	r0, [sp]
   10fe8:	e59f0060 	ldr	r0, [pc, #96]	; 11050 <get_key+0x78>
   10fec:	e59f1060 	ldr	r1, [pc, #96]	; 11054 <get_key+0x7c>
   10ff0:	ea000002 	b	11000 <get_key+0x28>
   10ff4:	e59d2000 	ldr	r2, [sp]
   10ff8:	e2822001 	add	r2, r2, #1
   10ffc:	e58d2000 	str	r2, [sp]
   11000:	e59d2000 	ldr	r2, [sp]
   11004:	e5903000 	ldr	r3, [r0]
   11008:	e1520003 	cmp	r2, r3
   1100c:	aa000005 	bge	11028 <get_key+0x50>
   11010:	e59d2000 	ldr	r2, [sp]
   11014:	e59d3004 	ldr	r3, [sp, #4]
   11018:	e7912102 	ldr	r2, [r1, r2, lsl #2]
   1101c:	e1530002 	cmp	r3, r2
   11020:	2afffff3 	bcs	10ff4 <get_key+0x1c>
   11024:	ea000004 	b	1103c <get_key+0x64>
   11028:	e59d1000 	ldr	r1, [sp]
   1102c:	e5900000 	ldr	r0, [r0]
   11030:	e1510000 	cmp	r1, r0
   11034:	a3a00005 	movge	r0, #5
   11038:	a58d0000 	strge	r0, [sp]
   1103c:	e59d0000 	ldr	r0, [sp]
   11040:	e58d0008 	str	r0, [sp, #8]
   11044:	e59d0008 	ldr	r0, [sp, #8]
   11048:	e28dd00c 	add	sp, sp, #12
   1104c:	e12fff1e 	bx	lr
   11050:	000107bc 			; <UNDEFINED> instruction: 0x000107bc
   11054:	000107a8 	andeq	r0, r1, r8, lsr #15

00011058 <doKeyAction>:
   11058:	e92d4800 	push	{fp, lr}
   1105c:	e1a0b00d 	mov	fp, sp
   11060:	e24dd008 	sub	sp, sp, #8
   11064:	e58d0004 	str	r0, [sp, #4]
   11068:	e3500005 	cmp	r0, #5
   1106c:	0a000051 	beq	111b8 <doKeyAction+0x160>
   11070:	e59d0004 	ldr	r0, [sp, #4]
   11074:	e3500004 	cmp	r0, #4
   11078:	1a000005 	bne	11094 <doKeyAction+0x3c>
   1107c:	e59f013c 	ldr	r0, [pc, #316]	; 111c0 <doKeyAction+0x168>
   11080:	e5901000 	ldr	r1, [r0]
   11084:	e3510000 	cmp	r1, #0
   11088:	13a01000 	movne	r1, #0
   1108c:	03a01001 	moveq	r1, #1
   11090:	e5801000 	str	r1, [r0]
   11094:	e59f0124 	ldr	r0, [pc, #292]	; 111c0 <doKeyAction+0x168>
   11098:	e5901000 	ldr	r1, [r0]
   1109c:	e3510000 	cmp	r1, #0
   110a0:	0a00001f 	beq	11124 <doKeyAction+0xcc>
   110a4:	e5900000 	ldr	r0, [r0]
   110a8:	e3500001 	cmp	r0, #1
   110ac:	1a000040 	bne	111b4 <doKeyAction+0x15c>
   110b0:	e59d0004 	ldr	r0, [sp, #4]
   110b4:	e3500001 	cmp	r0, #1
   110b8:	1a00000a 	bne	110e8 <doKeyAction+0x90>
   110bc:	e59f0100 	ldr	r0, [pc, #256]	; 111c4 <doKeyAction+0x16c>
   110c0:	e5901000 	ldr	r1, [r0]
   110c4:	e3510007 	cmp	r1, #7
   110c8:	ca000006 	bgt	110e8 <doKeyAction+0x90>
   110cc:	e5901000 	ldr	r1, [r0]
   110d0:	e59f30f4 	ldr	r3, [pc, #244]	; 111cc <doKeyAction+0x174>
   110d4:	e59f20ec 	ldr	r2, [pc, #236]	; 111c8 <doKeyAction+0x170>
   110d8:	e2811001 	add	r1, r1, #1
   110dc:	e5801000 	str	r1, [r0]
   110e0:	e7930101 	ldr	r0, [r3, r1, lsl #2]
   110e4:	e5820000 	str	r0, [r2]
   110e8:	e59d0004 	ldr	r0, [sp, #4]
   110ec:	e3500002 	cmp	r0, #2
   110f0:	1a00002f 	bne	111b4 <doKeyAction+0x15c>
   110f4:	e59f00c8 	ldr	r0, [pc, #200]	; 111c4 <doKeyAction+0x16c>
   110f8:	e5901000 	ldr	r1, [r0]
   110fc:	e3510001 	cmp	r1, #1
   11100:	ba00002b 	blt	111b4 <doKeyAction+0x15c>
   11104:	e5901000 	ldr	r1, [r0]
   11108:	e59f30bc 	ldr	r3, [pc, #188]	; 111cc <doKeyAction+0x174>
   1110c:	e59f20b4 	ldr	r2, [pc, #180]	; 111c8 <doKeyAction+0x170>
   11110:	e2411001 	sub	r1, r1, #1
   11114:	e5801000 	str	r1, [r0]
   11118:	e7930101 	ldr	r0, [r3, r1, lsl #2]
   1111c:	e5820000 	str	r0, [r2]
   11120:	ea000023 	b	111b4 <doKeyAction+0x15c>
   11124:	e59d0004 	ldr	r0, [sp, #4]
   11128:	e3500003 	cmp	r0, #3
   1112c:	03a00001 	moveq	r0, #1
   11130:	0bfffe62 	bleq	10ac0 <bolus>
   11134:	e59d0004 	ldr	r0, [sp, #4]
   11138:	e3500000 	cmp	r0, #0
   1113c:	1a000001 	bne	11148 <doKeyAction+0xf0>
   11140:	e3a00000 	mov	r0, #0
   11144:	ebfffe5d 	bl	10ac0 <bolus>
   11148:	e59d0004 	ldr	r0, [sp, #4]
   1114c:	e3500001 	cmp	r0, #1
   11150:	1a000005 	bne	1116c <doKeyAction+0x114>
   11154:	e59f006c 	ldr	r0, [pc, #108]	; 111c8 <doKeyAction+0x170>
   11158:	e59f1070 	ldr	r1, [pc, #112]	; 111d0 <doKeyAction+0x178>
   1115c:	ed900a00 	vldr	s0, [r0]
   11160:	ed911a00 	vldr	s2, [r1]
   11164:	ee310a00 	vadd.f32	s0, s2, s0
   11168:	ed810a00 	vstr	s0, [r1]
   1116c:	e59d0004 	ldr	r0, [sp, #4]
   11170:	e3500002 	cmp	r0, #2
   11174:	1a00000e 	bne	111b4 <doKeyAction+0x15c>
   11178:	e59f1048 	ldr	r1, [pc, #72]	; 111c8 <doKeyAction+0x170>
   1117c:	e59f004c 	ldr	r0, [pc, #76]	; 111d0 <doKeyAction+0x178>
   11180:	ed910a00 	vldr	s0, [r1]
   11184:	ed901a00 	vldr	s2, [r0]
   11188:	ee310a40 	vsub.f32	s0, s2, s0
   1118c:	eeb50ac0 	vcmpe.f32	s0, #0.0
   11190:	eef1fa10 	vmrs	APSR_nzcv, fpscr
   11194:	da000004 	ble	111ac <doKeyAction+0x154>
   11198:	ed910a00 	vldr	s0, [r1]
   1119c:	ed901a00 	vldr	s2, [r0]
   111a0:	ee310a40 	vsub.f32	s0, s2, s0
   111a4:	ed800a00 	vstr	s0, [r0]
   111a8:	ea000001 	b	111b4 <doKeyAction+0x15c>
   111ac:	e3a01000 	mov	r1, #0
   111b0:	e5801000 	str	r1, [r0]
   111b4:	ebfffe97 	bl	10c18 <updateScreen>
   111b8:	e1a0d00b 	mov	sp, fp
   111bc:	e8bd8800 	pop	{fp, pc}
   111c0:	00010814 	andeq	r0, r1, r4, lsl r8
   111c4:	000107f0 	strdeq	r0, [r1], -r0	; <UNPREDICTABLE>
   111c8:	000107f4 	strdeq	r0, [r1], -r4
   111cc:	000107c4 	andeq	r0, r1, r4, asr #15
   111d0:	000107e8 	andeq	r0, r1, r8, ror #15

000111d4 <forward_target>:
   111d4:	e92d4800 	push	{fp, lr}
   111d8:	e1a0b00d 	mov	fp, sp
   111dc:	e24dd008 	sub	sp, sp, #8
   111e0:	e59f1010 	ldr	r1, [pc, #16]	; 111f8 <forward_target+0x24>
   111e4:	e58d0004 	str	r0, [sp, #4]
   111e8:	e1a00001 	mov	r0, r1
   111ec:	ebfffcf0 	bl	105b4 <printf@plt>
   111f0:	e1a0d00b 	mov	sp, fp
   111f4:	e8bd8800 	pop	{fp, pc}
   111f8:	00011969 	andeq	r1, r1, r9, ror #18

000111fc <main>:
   111fc:	e92d4800 	push	{fp, lr}
   11200:	e1a0b00d 	mov	fp, sp
   11204:	e24dd018 	sub	sp, sp, #24
   11208:	e59f2080 	ldr	r2, [pc, #128]	; 11290 <main+0x94>
   1120c:	e3a03000 	mov	r3, #0
   11210:	e90b0009 	stmdb	fp, {r0, r3}
   11214:	e1a00002 	mov	r0, r2
   11218:	e58d100c 	str	r1, [sp, #12]
   1121c:	ebfffce4 	bl	105b4 <printf@plt>
   11220:	e59f006c 	ldr	r0, [pc, #108]	; 11294 <main+0x98>
   11224:	ebfffce2 	bl	105b4 <printf@plt>
   11228:	ebfffd92 	bl	10878 <setup>
   1122c:	e59f1064 	ldr	r1, [pc, #100]	; 11298 <main+0x9c>
   11230:	e3a00002 	mov	r0, #2
   11234:	e58d1008 	str	r1, [sp, #8]
   11238:	e12fff31 	blx	r1
   1123c:	e59f3058 	ldr	r3, [pc, #88]	; 1129c <main+0xa0>
   11240:	e59f0058 	ldr	r0, [pc, #88]	; 112a0 <main+0xa4>
   11244:	e3a01010 	mov	r1, #16
   11248:	e3a02002 	mov	r2, #2
   1124c:	e58d3004 	str	r3, [sp, #4]
   11250:	e12fff33 	blx	r3
   11254:	e3a00001 	mov	r0, #1
   11258:	e58d0000 	str	r0, [sp]
   1125c:	ea000003 	b	11270 <main+0x74>
   11260:	e59d0000 	ldr	r0, [sp]
   11264:	e280000a 	add	r0, r0, #10
   11268:	e58d0000 	str	r0, [sp]
   1126c:	ebfffdad 	bl	10928 <loop>
   11270:	e59d0000 	ldr	r0, [sp]
   11274:	e350003d 	cmp	r0, #61	; 0x3d
   11278:	dafffff8 	ble	11260 <main+0x64>
   1127c:	e59f0020 	ldr	r0, [pc, #32]	; 112a4 <main+0xa8>
   11280:	ebfffccb 	bl	105b4 <printf@plt>
   11284:	e3a00000 	mov	r0, #0
   11288:	e1a0d00b 	mov	sp, fp
   1128c:	e8bd8800 	pop	{fp, pc}
   11290:	00011984 	andeq	r1, r1, r4, lsl #19
   11294:	0001199b 	muleq	r1, fp, r9
   11298:	000111d4 	ldrdeq	r1, [r1], -r4
   1129c:	00010684 	andeq	r0, r1, r4, lsl #13
   112a0:	00021d74 	andeq	r1, r2, r4, ror sp
   112a4:	000119ab 	andeq	r1, r1, fp, lsr #19

Disassembly of section .DATA_REGION_3__share:

000112a8 <.DATA_REGION_3__sdata_start>:
   112a8:	00000000 	andeq	r0, r0, r0

Disassembly of section .CODE_REGION_3_:

000112ac <ict_checking>:
   112ac:	e24dd004 	sub	sp, sp, #4
   112b0:	e58d0000 	str	r0, [sp]
   112b4:	e3a00000 	mov	r0, #0
   112b8:	e28dd004 	add	sp, sp, #4
   112bc:	e12fff1e 	bx	lr

000112c0 <error_found>:
   112c0:	e92d4800 	push	{fp, lr}
   112c4:	e1a0b00d 	mov	fp, sp
   112c8:	e59f0004 	ldr	r0, [pc, #4]	; 112d4 <error_found+0x14>
   112cc:	ebfffcb8 	bl	105b4 <printf@plt>
   112d0:	e8bd8800 	pop	{fp, pc}
   112d4:	00011b3b 	andeq	r1, r1, fp, lsr fp

Disassembly of section .DATA_REGION_4__share:

000112d8 <.DATA_REGION_4__sdata_start>:
   112d8:	00000000 	andeq	r0, r0, r0

Disassembly of section .DATA_REGION_4__data:

000112dc <.DATA_REGION_4__data_start>:
   112dc:	4d6e6970 			; <UNDEFINED> instruction: 0x4d6e6970
   112e0:	0065646f 	rsbeq	r6, r5, pc, ror #8
   112e4:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
   112e8:	526c6174 	rsbpl	r6, ip, #116, 2
   112ec:	00646165 	rsbeq	r6, r4, r5, ror #2
   112f0:	69726553 	ldmdbvs	r2!, {r0, r1, r4, r6, r8, sl, sp, lr}^
   112f4:	625f6c61 	subsvs	r6, pc, #24832	; 0x6100
   112f8:	6e696765 	cdpvs	7, 6, cr6, cr9, cr5, {3}
   112fc:	72655300 	rsbvc	r5, r5, #0, 6
   11300:	5f6c6169 	svcpl	0x006c6169
   11304:	69617661 	stmdbvs	r1!, {r0, r5, r6, r9, sl, ip, sp, lr}^
   11308:	6c62616c 	stfvse	f6, [r2], #-432	; 0xfffffe50
   1130c:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
   11310:	6c616972 			; <UNDEFINED> instruction: 0x6c616972
   11314:	6972775f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, sp, lr}^
   11318:	00006574 	andeq	r6, r0, r4, ror r5

Disassembly of section .CODE_REGION_4_:

0001131c <pinMode>:
   1131c:	e92d4800 	push	{fp, lr}
   11320:	e1a0b00d 	mov	fp, sp
   11324:	e24dd008 	sub	sp, sp, #8
   11328:	e58d0004 	str	r0, [sp, #4]
   1132c:	e59fc01c 	ldr	ip, [pc, #28]	; 11350 <.DATA_REGION_4__data_end+0x34>
   11330:	e1a03001 	mov	r3, r1
   11334:	e59f1018 	ldr	r1, [pc, #24]	; 11354 <.DATA_REGION_4__data_end+0x38>
   11338:	e59d2004 	ldr	r2, [sp, #4]
   1133c:	e1a0000c 	mov	r0, ip
   11340:	e58d3000 	str	r3, [sp]
   11344:	ebfffc9a 	bl	105b4 <printf@plt>
   11348:	e1a0d00b 	mov	sp, fp
   1134c:	e8bd8800 	pop	{fp, pc}
   11350:	000119c0 	andeq	r1, r1, r0, asr #19
   11354:	000112dc 	ldrdeq	r1, [r1], -ip

00011358 <digitalRead>:
   11358:	e92d4800 	push	{fp, lr}
   1135c:	e1a0b00d 	mov	fp, sp
   11360:	e24dd008 	sub	sp, sp, #8
   11364:	e1a02000 	mov	r2, r0
   11368:	e59f0020 	ldr	r0, [pc, #32]	; 11390 <digitalRead+0x38>
   1136c:	e59f1020 	ldr	r1, [pc, #32]	; 11394 <digitalRead+0x3c>
   11370:	e58d2004 	str	r2, [sp, #4]
   11374:	ebfffc8e 	bl	105b4 <printf@plt>
   11378:	e59f0018 	ldr	r0, [pc, #24]	; 11398 <digitalRead+0x40>
   1137c:	e1a0100d 	mov	r1, sp
   11380:	ebfffca6 	bl	10620 <__isoc99_scanf@plt>
   11384:	e59d0000 	ldr	r0, [sp]
   11388:	e1a0d00b 	mov	sp, fp
   1138c:	e8bd8800 	pop	{fp, pc}
   11390:	000119e2 	andeq	r1, r1, r2, ror #19
   11394:	000112e4 	andeq	r1, r1, r4, ror #5
   11398:	00011966 	andeq	r1, r1, r6, ror #18

0001139c <digitalWrite>:
   1139c:	e24dd008 	sub	sp, sp, #8
   113a0:	e58d0004 	str	r0, [sp, #4]
   113a4:	e58d1000 	str	r1, [sp]
   113a8:	e28dd008 	add	sp, sp, #8
   113ac:	e12fff1e 	bx	lr

000113b0 <Serial_begin>:
   113b0:	e92d4800 	push	{fp, lr}
   113b4:	e1a0b00d 	mov	fp, sp
   113b8:	e24dd008 	sub	sp, sp, #8
   113bc:	e1a02000 	mov	r2, r0
   113c0:	e59f0010 	ldr	r0, [pc, #16]	; 113d8 <Serial_begin+0x28>
   113c4:	e59f1010 	ldr	r1, [pc, #16]	; 113dc <Serial_begin+0x2c>
   113c8:	e58d2004 	str	r2, [sp, #4]
   113cc:	ebfffc78 	bl	105b4 <printf@plt>
   113d0:	e1a0d00b 	mov	sp, fp
   113d4:	e8bd8800 	pop	{fp, pc}
   113d8:	000119f5 	strdeq	r1, [r1], -r5
   113dc:	000112f0 	strdeq	r1, [r1], -r0

000113e0 <Serial_available>:
   113e0:	e92d4800 	push	{fp, lr}
   113e4:	e1a0b00d 	mov	fp, sp
   113e8:	e24dd008 	sub	sp, sp, #8
   113ec:	ebfffc73 	bl	105c0 <getchar@plt>
   113f0:	e5cd0003 	strb	r0, [sp, #3]
   113f4:	e59f302c 	ldr	r3, [pc, #44]	; 11428 <Serial_available+0x48>
   113f8:	e59f102c 	ldr	r1, [pc, #44]	; 1142c <Serial_available+0x4c>
   113fc:	e5dd2003 	ldrb	r2, [sp, #3]
   11400:	e1a00003 	mov	r0, r3
   11404:	ebfffc6a 	bl	105b4 <printf@plt>
   11408:	e5dd0003 	ldrb	r0, [sp, #3]
   1140c:	e3500079 	cmp	r0, #121	; 0x79
   11410:	13a00000 	movne	r0, #0
   11414:	03a00001 	moveq	r0, #1
   11418:	e58d0004 	str	r0, [sp, #4]
   1141c:	e59d0004 	ldr	r0, [sp, #4]
   11420:	e1a0d00b 	mov	sp, fp
   11424:	e8bd8800 	pop	{fp, pc}
   11428:	00011a09 	andeq	r1, r1, r9, lsl #20
   1142c:	000112fd 	strdeq	r1, [r1], -sp

00011430 <Serial_read>:
   11430:	e92d4800 	push	{fp, lr}
   11434:	e1a0b00d 	mov	fp, sp
   11438:	e24dd008 	sub	sp, sp, #8
   1143c:	ebfffc5f 	bl	105c0 <getchar@plt>
   11440:	e54b0001 	strb	r0, [fp, #-1]
   11444:	e55b0001 	ldrb	r0, [fp, #-1]
   11448:	e1a0d00b 	mov	sp, fp
   1144c:	e8bd8800 	pop	{fp, pc}

00011450 <Serial_write>:
   11450:	e92d4800 	push	{fp, lr}
   11454:	e1a0b00d 	mov	fp, sp
   11458:	e24dd008 	sub	sp, sp, #8
   1145c:	e58d0004 	str	r0, [sp, #4]
   11460:	e59fc020 	ldr	ip, [pc, #32]	; 11488 <Serial_write+0x38>
   11464:	e1a03001 	mov	r3, r1
   11468:	e59f101c 	ldr	r1, [pc, #28]	; 1148c <Serial_write+0x3c>
   1146c:	e59d2004 	ldr	r2, [sp, #4]
   11470:	e1a0000c 	mov	r0, ip
   11474:	e58d3000 	str	r3, [sp]
   11478:	ebfffc4d 	bl	105b4 <printf@plt>
   1147c:	e3a00000 	mov	r0, #0
   11480:	e1a0d00b 	mov	sp, fp
   11484:	e8bd8800 	pop	{fp, pc}
   11488:	00011a14 	andeq	r1, r1, r4, lsl sl
   1148c:	0001130e 	andeq	r1, r1, lr, lsl #6

00011490 <analogRead>:
   11490:	e92d4800 	push	{fp, lr}
   11494:	e1a0b00d 	mov	fp, sp
   11498:	e24dd008 	sub	sp, sp, #8
   1149c:	e1a01000 	mov	r1, r0
   114a0:	e59f001c 	ldr	r0, [pc, #28]	; 114c4 <analogRead+0x34>
   114a4:	e58d1004 	str	r1, [sp, #4]
   114a8:	ebfffc41 	bl	105b4 <printf@plt>
   114ac:	e59f0014 	ldr	r0, [pc, #20]	; 114c8 <analogRead+0x38>
   114b0:	e1a0100d 	mov	r1, sp
   114b4:	ebfffc59 	bl	10620 <__isoc99_scanf@plt>
   114b8:	e59d0000 	ldr	r0, [sp]
   114bc:	e1a0d00b 	mov	sp, fp
   114c0:	e8bd8800 	pop	{fp, pc}
   114c4:	00011a3a 	andeq	r1, r1, sl, lsr sl
   114c8:	00011966 	andeq	r1, r1, r6, ror #18

000114cc <millis>:
   114cc:	e92d4800 	push	{fp, lr}
   114d0:	e1a0b00d 	mov	fp, sp
   114d4:	e24dd008 	sub	sp, sp, #8
   114d8:	e1a0000d 	mov	r0, sp
   114dc:	e3a01000 	mov	r1, #0
   114e0:	ebfffc3c 	bl	105d8 <gettimeofday@plt>
   114e4:	e59f001c 	ldr	r0, [pc, #28]	; 11508 <millis+0x3c>
   114e8:	e89d0006 	ldm	sp, {r1, r2}
   114ec:	e750f012 	smmul	r0, r2, r0
   114f0:	e1a02340 	asr	r2, r0, #6
   114f4:	e0820fa0 	add	r0, r2, r0, lsr #31
   114f8:	e3a02ffa 	mov	r2, #1000	; 0x3e8
   114fc:	e0200291 	mla	r0, r1, r2, r0
   11500:	e1a0d00b 	mov	sp, fp
   11504:	e8bd8800 	pop	{fp, pc}
   11508:	10624dd3 	ldrdne	r4, [r2], #-211	; 0xffffff2d	; <UNPREDICTABLE>

0001150c <usecs>:
   1150c:	e92d4800 	push	{fp, lr}
   11510:	e1a0b00d 	mov	fp, sp
   11514:	e24dd008 	sub	sp, sp, #8
   11518:	e1a0000d 	mov	r0, sp
   1151c:	e3a01000 	mov	r1, #0
   11520:	ebfffc2c 	bl	105d8 <gettimeofday@plt>
   11524:	e3a02d09 	mov	r2, #576	; 0x240
   11528:	e89d0003 	ldm	sp, {r0, r1}
   1152c:	e382293d 	orr	r2, r2, #999424	; 0xf4000
   11530:	e0201290 	mla	r0, r0, r2, r1
   11534:	e1a0d00b 	mov	sp, fp
   11538:	e8bd8800 	pop	{fp, pc}

0001153c <delayMicroseconds>:
   1153c:	e92d4800 	push	{fp, lr}
   11540:	e1a0b00d 	mov	fp, sp
   11544:	e24dd008 	sub	sp, sp, #8
   11548:	ed8d0a01 	vstr	s0, [sp, #4]
   1154c:	eebd0ac0 	vcvt.s32.f32	s0, s0
   11550:	ee100a10 	vmov	r0, s0
   11554:	ebfffc1c 	bl	105cc <usleep@plt>
   11558:	e1a0d00b 	mov	sp, fp
   1155c:	e8bd8800 	pop	{fp, pc}

00011560 <toUInt>:
   11560:	e92d4800 	push	{fp, lr}
   11564:	e1a0b00d 	mov	fp, sp
   11568:	e24dd010 	sub	sp, sp, #16
   1156c:	e50b0004 	str	r0, [fp, #-4]
   11570:	e51b0004 	ldr	r0, [fp, #-4]
   11574:	e58d1008 	str	r1, [sp, #8]
   11578:	ebfffc2b 	bl	1062c <atoi@plt>
   1157c:	e58d0004 	str	r0, [sp, #4]
   11580:	e1a0d00b 	mov	sp, fp
   11584:	e8bd8800 	pop	{fp, pc}

Disassembly of section .DATA_REGION_5__share:

00011588 <.DATA_REGION_5__sdata_start>:
   11588:	00000000 	andeq	r0, r0, r0

Disassembly of section .DATA_REGION_5__data:

0001158c <.DATA_REGION_5__data_start>:
   1158c:	5f64656c 	svcpl	0x0064656c
   11590:	6c006e6f 	stcvs	14, cr6, [r0], {111}	; 0x6f
   11594:	6f5f6465 	svcvs	0x005f6465
   11598:	00006666 	andeq	r6, r0, r6, ror #12

Disassembly of section .CODE_REGION_5_:

0001159c <led_on>:
   1159c:	e92d4800 	push	{fp, lr}
   115a0:	e1a0b00d 	mov	fp, sp
   115a4:	e59f2018 	ldr	r2, [pc, #24]	; 115c4 <.DATA_REGION_5__data_end+0x28>
   115a8:	e59f0018 	ldr	r0, [pc, #24]	; 115c8 <.DATA_REGION_5__data_end+0x2c>
   115ac:	e59f1018 	ldr	r1, [pc, #24]	; 115cc <.DATA_REGION_5__data_end+0x30>
   115b0:	e5923000 	ldr	r3, [r2]
   115b4:	e2833001 	add	r3, r3, #1
   115b8:	e5823000 	str	r3, [r2]
   115bc:	ebfffbfc 	bl	105b4 <printf@plt>
   115c0:	e8bd8800 	pop	{fp, pc}
   115c4:	00010650 	andeq	r0, r1, r0, asr r6
   115c8:	00011a4c 	andeq	r1, r1, ip, asr #20
   115cc:	0001158c 	andeq	r1, r1, ip, lsl #11

000115d0 <led_off>:
   115d0:	e92d4800 	push	{fp, lr}
   115d4:	e1a0b00d 	mov	fp, sp
   115d8:	e59f0008 	ldr	r0, [pc, #8]	; 115e8 <led_off+0x18>
   115dc:	e59f1008 	ldr	r1, [pc, #8]	; 115ec <led_off+0x1c>
   115e0:	ebfffbf3 	bl	105b4 <printf@plt>
   115e4:	e8bd8800 	pop	{fp, pc}
   115e8:	00011a4c 	andeq	r1, r1, ip, asr #20
   115ec:	00011593 	muleq	r1, r3, r5

Disassembly of section .DATA_REGION_6__share:

000115f0 <.DATA_REGION_6__sdata_start>:
   115f0:	00000000 	andeq	r0, r0, r0

Disassembly of section .text:

000115f4 <view_switch_to_rd_and_log>:
   115f4:	b590      	push	{r4, r7, lr}
   115f6:	b089      	sub	sp, #36	; 0x24
   115f8:	af04      	add	r7, sp, #16
   115fa:	60f8      	str	r0, [r7, #12]
   115fc:	60b9      	str	r1, [r7, #8]
   115fe:	607a      	str	r2, [r7, #4]
   11600:	4c54      	ldr	r4, [pc, #336]	; (11754 <.DATA_REGION_6__sdata_end+0x160>)
   11602:	447c      	add	r4, pc
   11604:	4b54      	ldr	r3, [pc, #336]	; (11758 <.DATA_REGION_6__sdata_end+0x164>)
   11606:	58e3      	ldr	r3, [r4, r3]
   11608:	681b      	ldr	r3, [r3, #0]
   1160a:	3301      	adds	r3, #1
   1160c:	4a52      	ldr	r2, [pc, #328]	; (11758 <.DATA_REGION_6__sdata_end+0x164>)
   1160e:	58a2      	ldr	r2, [r4, r2]
   11610:	6013      	str	r3, [r2, #0]
   11612:	4b51      	ldr	r3, [pc, #324]	; (11758 <.DATA_REGION_6__sdata_end+0x164>)
   11614:	58e3      	ldr	r3, [r4, r3]
   11616:	6819      	ldr	r1, [r3, #0]
   11618:	f246 6367 	movw	r3, #26215	; 0x6667
   1161c:	f2c6 6366 	movt	r3, #26214	; 0x6666
   11620:	fb81 2303 	smull	r2, r3, r1, r3
   11624:	109a      	asrs	r2, r3, #2
   11626:	17cb      	asrs	r3, r1, #31
   11628:	1ad2      	subs	r2, r2, r3
   1162a:	4613      	mov	r3, r2
   1162c:	009b      	lsls	r3, r3, #2
   1162e:	4413      	add	r3, r2
   11630:	005b      	lsls	r3, r3, #1
   11632:	1aca      	subs	r2, r1, r3
   11634:	2a00      	cmp	r2, #0
   11636:	f040 8089 	bne.w	1174c <view_switch_to_rd_and_log+0x158>
   1163a:	4b48      	ldr	r3, [pc, #288]	; (1175c <.DATA_REGION_6__sdata_end+0x168>)
   1163c:	58e3      	ldr	r3, [r4, r3]
   1163e:	781b      	ldrb	r3, [r3, #0]
   11640:	f083 0301 	eor.w	r3, r3, #1
   11644:	b2db      	uxtb	r3, r3
   11646:	2b00      	cmp	r3, #0
   11648:	d045      	beq.n	116d6 <view_switch_to_rd_and_log+0xe2>
   1164a:	4b44      	ldr	r3, [pc, #272]	; (1175c <.DATA_REGION_6__sdata_end+0x168>)
   1164c:	58e3      	ldr	r3, [r4, r3]
   1164e:	2201      	movs	r2, #1
   11650:	701a      	strb	r2, [r3, #0]
   11652:	4b43      	ldr	r3, [pc, #268]	; (11760 <.DATA_REGION_6__sdata_end+0x16c>)
   11654:	447b      	add	r3, pc
   11656:	4618      	mov	r0, r3
   11658:	f7fe efc4 	blx	105e4 <puts@plt>
   1165c:	4b41      	ldr	r3, [pc, #260]	; (11764 <.DATA_REGION_6__sdata_end+0x170>)
   1165e:	58e3      	ldr	r3, [r4, r3]
   11660:	4619      	mov	r1, r3
   11662:	2000      	movs	r0, #0
   11664:	f7fe efe8 	blx	10638 <TEEC_InitializeContext@plt>
   11668:	4602      	mov	r2, r0
   1166a:	4b3f      	ldr	r3, [pc, #252]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   1166c:	58e3      	ldr	r3, [r4, r3]
   1166e:	601a      	str	r2, [r3, #0]
   11670:	4b3d      	ldr	r3, [pc, #244]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   11672:	58e3      	ldr	r3, [r4, r3]
   11674:	681b      	ldr	r3, [r3, #0]
   11676:	2b00      	cmp	r3, #0
   11678:	d009      	beq.n	1168e <view_switch_to_rd_and_log+0x9a>
   1167a:	4b3b      	ldr	r3, [pc, #236]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   1167c:	58e3      	ldr	r3, [r4, r3]
   1167e:	681b      	ldr	r3, [r3, #0]
   11680:	461a      	mov	r2, r3
   11682:	4b3a      	ldr	r3, [pc, #232]	; (1176c <.DATA_REGION_6__sdata_end+0x178>)
   11684:	447b      	add	r3, pc
   11686:	4619      	mov	r1, r3
   11688:	2001      	movs	r0, #1
   1168a:	f7fe efbe 	blx	10608 <errx@plt>
   1168e:	4b38      	ldr	r3, [pc, #224]	; (11770 <.DATA_REGION_6__sdata_end+0x17c>)
   11690:	58e3      	ldr	r3, [r4, r3]
   11692:	9302      	str	r3, [sp, #8]
   11694:	2300      	movs	r3, #0
   11696:	9301      	str	r3, [sp, #4]
   11698:	2300      	movs	r3, #0
   1169a:	9300      	str	r3, [sp, #0]
   1169c:	2300      	movs	r3, #0
   1169e:	4a35      	ldr	r2, [pc, #212]	; (11774 <.DATA_REGION_6__sdata_end+0x180>)
   116a0:	58a2      	ldr	r2, [r4, r2]
   116a2:	4935      	ldr	r1, [pc, #212]	; (11778 <.DATA_REGION_6__sdata_end+0x184>)
   116a4:	5861      	ldr	r1, [r4, r1]
   116a6:	482f      	ldr	r0, [pc, #188]	; (11764 <.DATA_REGION_6__sdata_end+0x170>)
   116a8:	5820      	ldr	r0, [r4, r0]
   116aa:	f7fe efcc 	blx	10644 <TEEC_OpenSession@plt>
   116ae:	4602      	mov	r2, r0
   116b0:	4b2d      	ldr	r3, [pc, #180]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   116b2:	58e3      	ldr	r3, [r4, r3]
   116b4:	601a      	str	r2, [r3, #0]
   116b6:	4b2c      	ldr	r3, [pc, #176]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   116b8:	58e3      	ldr	r3, [r4, r3]
   116ba:	681b      	ldr	r3, [r3, #0]
   116bc:	2b00      	cmp	r3, #0
   116be:	d00a      	beq.n	116d6 <view_switch_to_rd_and_log+0xe2>
   116c0:	4b29      	ldr	r3, [pc, #164]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   116c2:	58e3      	ldr	r3, [r4, r3]
   116c4:	681a      	ldr	r2, [r3, #0]
   116c6:	4b2a      	ldr	r3, [pc, #168]	; (11770 <.DATA_REGION_6__sdata_end+0x17c>)
   116c8:	58e3      	ldr	r3, [r4, r3]
   116ca:	681b      	ldr	r3, [r3, #0]
   116cc:	492b      	ldr	r1, [pc, #172]	; (1177c <.DATA_REGION_6__sdata_end+0x188>)
   116ce:	4479      	add	r1, pc
   116d0:	2001      	movs	r0, #1
   116d2:	f7fe ef9a 	blx	10608 <errx@plt>
   116d6:	223c      	movs	r2, #60	; 0x3c
   116d8:	2100      	movs	r1, #0
   116da:	4b29      	ldr	r3, [pc, #164]	; (11780 <.DATA_REGION_6__sdata_end+0x18c>)
   116dc:	58e3      	ldr	r3, [r4, r3]
   116de:	4618      	mov	r0, r3
   116e0:	f7fe ef8c 	blx	105fc <memset@plt>
   116e4:	4b26      	ldr	r3, [pc, #152]	; (11780 <.DATA_REGION_6__sdata_end+0x18c>)
   116e6:	58e3      	ldr	r3, [r4, r3]
   116e8:	461a      	mov	r2, r3
   116ea:	2333      	movs	r3, #51	; 0x33
   116ec:	6053      	str	r3, [r2, #4]
   116ee:	68fb      	ldr	r3, [r7, #12]
   116f0:	4a23      	ldr	r2, [pc, #140]	; (11780 <.DATA_REGION_6__sdata_end+0x18c>)
   116f2:	58a2      	ldr	r2, [r4, r2]
   116f4:	6093      	str	r3, [r2, #8]
   116f6:	68bb      	ldr	r3, [r7, #8]
   116f8:	4a21      	ldr	r2, [pc, #132]	; (11780 <.DATA_REGION_6__sdata_end+0x18c>)
   116fa:	58a2      	ldr	r2, [r4, r2]
   116fc:	60d3      	str	r3, [r2, #12]
   116fe:	687b      	ldr	r3, [r7, #4]
   11700:	4a1f      	ldr	r2, [pc, #124]	; (11780 <.DATA_REGION_6__sdata_end+0x18c>)
   11702:	58a2      	ldr	r2, [r4, r2]
   11704:	6153      	str	r3, [r2, #20]
   11706:	4b1e      	ldr	r3, [pc, #120]	; (11780 <.DATA_REGION_6__sdata_end+0x18c>)
   11708:	58e3      	ldr	r3, [r4, r3]
   1170a:	461a      	mov	r2, r3
   1170c:	f44f 73de 	mov.w	r3, #444	; 0x1bc
   11710:	6193      	str	r3, [r2, #24]
   11712:	4b17      	ldr	r3, [pc, #92]	; (11770 <.DATA_REGION_6__sdata_end+0x17c>)
   11714:	58e3      	ldr	r3, [r4, r3]
   11716:	4a1a      	ldr	r2, [pc, #104]	; (11780 <.DATA_REGION_6__sdata_end+0x18c>)
   11718:	58a2      	ldr	r2, [r4, r2]
   1171a:	2100      	movs	r1, #0
   1171c:	4816      	ldr	r0, [pc, #88]	; (11778 <.DATA_REGION_6__sdata_end+0x184>)
   1171e:	5820      	ldr	r0, [r4, r0]
   11720:	f7fe ef66 	blx	105f0 <TEEC_InvokeCommand@plt>
   11724:	4602      	mov	r2, r0
   11726:	4b10      	ldr	r3, [pc, #64]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   11728:	58e3      	ldr	r3, [r4, r3]
   1172a:	601a      	str	r2, [r3, #0]
   1172c:	4b0e      	ldr	r3, [pc, #56]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   1172e:	58e3      	ldr	r3, [r4, r3]
   11730:	681b      	ldr	r3, [r3, #0]
   11732:	2b00      	cmp	r3, #0
   11734:	d00b      	beq.n	1174e <view_switch_to_rd_and_log+0x15a>
   11736:	4b0c      	ldr	r3, [pc, #48]	; (11768 <.DATA_REGION_6__sdata_end+0x174>)
   11738:	58e3      	ldr	r3, [r4, r3]
   1173a:	681a      	ldr	r2, [r3, #0]
   1173c:	4b0c      	ldr	r3, [pc, #48]	; (11770 <.DATA_REGION_6__sdata_end+0x17c>)
   1173e:	58e3      	ldr	r3, [r4, r3]
   11740:	681b      	ldr	r3, [r3, #0]
   11742:	4910      	ldr	r1, [pc, #64]	; (11784 <.DATA_REGION_6__sdata_end+0x190>)
   11744:	4479      	add	r1, pc
   11746:	2001      	movs	r0, #1
   11748:	f7fe ef5e 	blx	10608 <errx@plt>
   1174c:	bf00      	nop
   1174e:	3714      	adds	r7, #20
   11750:	46bd      	mov	sp, r7
   11752:	bd90      	pop	{r4, r7, pc}
   11754:	000106da 	ldrdeq	r0, [r1], -sl
   11758:	00000048 	andeq	r0, r0, r8, asr #32
   1175c:	0000005c 	andeq	r0, r0, ip, asr r0
   11760:	0000050c 	andeq	r0, r0, ip, lsl #10
   11764:	00000040 	andeq	r0, r0, r0, asr #32
   11768:	00000050 	andeq	r0, r0, r0, asr r0
   1176c:	00000504 	andeq	r0, r0, r4, lsl #10
   11770:	00000044 	andeq	r0, r0, r4, asr #32
   11774:	00000058 	andeq	r0, r0, r8, asr r0
   11778:	0000004c 	andeq	r0, r0, ip, asr #32
   1177c:	000004ea 	andeq	r0, r0, sl, ror #9
   11780:	00000054 	andeq	r0, r0, r4, asr r0
   11784:	000004a8 	andeq	r0, r0, r8, lsr #9

00011788 <view_switch_to_text_and_log>:
   11788:	b598      	push	{r3, r4, r7, lr}
   1178a:	af00      	add	r7, sp, #0
   1178c:	4c19      	ldr	r4, [pc, #100]	; (117f4 <view_switch_to_text_and_log+0x6c>)
   1178e:	447c      	add	r4, pc
   11790:	223c      	movs	r2, #60	; 0x3c
   11792:	2100      	movs	r1, #0
   11794:	4b18      	ldr	r3, [pc, #96]	; (117f8 <view_switch_to_text_and_log+0x70>)
   11796:	58e3      	ldr	r3, [r4, r3]
   11798:	4618      	mov	r0, r3
   1179a:	f7fe ef30 	blx	105fc <memset@plt>
   1179e:	4b16      	ldr	r3, [pc, #88]	; (117f8 <view_switch_to_text_and_log+0x70>)
   117a0:	58e3      	ldr	r3, [r4, r3]
   117a2:	461a      	mov	r2, r3
   117a4:	2303      	movs	r3, #3
   117a6:	6053      	str	r3, [r2, #4]
   117a8:	4b13      	ldr	r3, [pc, #76]	; (117f8 <view_switch_to_text_and_log+0x70>)
   117aa:	58e3      	ldr	r3, [r4, r3]
   117ac:	461a      	mov	r2, r3
   117ae:	f64f 73fa 	movw	r3, #65530	; 0xfffa
   117b2:	6093      	str	r3, [r2, #8]
   117b4:	4b11      	ldr	r3, [pc, #68]	; (117fc <view_switch_to_text_and_log+0x74>)
   117b6:	58e3      	ldr	r3, [r4, r3]
   117b8:	4a0f      	ldr	r2, [pc, #60]	; (117f8 <view_switch_to_text_and_log+0x70>)
   117ba:	58a2      	ldr	r2, [r4, r2]
   117bc:	2100      	movs	r1, #0
   117be:	4810      	ldr	r0, [pc, #64]	; (11800 <view_switch_to_text_and_log+0x78>)
   117c0:	5820      	ldr	r0, [r4, r0]
   117c2:	f7fe ef16 	blx	105f0 <TEEC_InvokeCommand@plt>
   117c6:	4602      	mov	r2, r0
   117c8:	4b0e      	ldr	r3, [pc, #56]	; (11804 <view_switch_to_text_and_log+0x7c>)
   117ca:	58e3      	ldr	r3, [r4, r3]
   117cc:	601a      	str	r2, [r3, #0]
   117ce:	4b0d      	ldr	r3, [pc, #52]	; (11804 <view_switch_to_text_and_log+0x7c>)
   117d0:	58e3      	ldr	r3, [r4, r3]
   117d2:	681b      	ldr	r3, [r3, #0]
   117d4:	2b00      	cmp	r3, #0
   117d6:	d00a      	beq.n	117ee <view_switch_to_text_and_log+0x66>
   117d8:	4b0a      	ldr	r3, [pc, #40]	; (11804 <view_switch_to_text_and_log+0x7c>)
   117da:	58e3      	ldr	r3, [r4, r3]
   117dc:	681a      	ldr	r2, [r3, #0]
   117de:	4b07      	ldr	r3, [pc, #28]	; (117fc <view_switch_to_text_and_log+0x74>)
   117e0:	58e3      	ldr	r3, [r4, r3]
   117e2:	681b      	ldr	r3, [r3, #0]
   117e4:	4908      	ldr	r1, [pc, #32]	; (11808 <view_switch_to_text_and_log+0x80>)
   117e6:	4479      	add	r1, pc
   117e8:	2001      	movs	r0, #1
   117ea:	f7fe ef0e 	blx	10608 <errx@plt>
   117ee:	bf00      	nop
   117f0:	bd98      	pop	{r3, r4, r7, pc}
   117f2:	bf00      	nop
   117f4:	0001054e 	andeq	r0, r1, lr, asr #10
   117f8:	00000054 	andeq	r0, r0, r4, asr r0
   117fc:	00000044 	andeq	r0, r0, r4, asr #32
   11800:	0000004c 	andeq	r0, r0, ip, asr #32
   11804:	00000050 	andeq	r0, r0, r0, asr r0
   11808:	00000406 	andeq	r0, r0, r6, lsl #8

0001180c <__test>:
   1180c:	b480      	push	{r7}
   1180e:	b085      	sub	sp, #20
   11810:	af00      	add	r7, sp, #0
   11812:	e9c7 0102 	strd	r0, r1, [r7, #8]
   11816:	e9c7 2300 	strd	r2, r3, [r7]
   1181a:	bf00      	nop
   1181c:	3714      	adds	r7, #20
   1181e:	46bd      	mov	sp, r7
   11820:	f85d 7b04 	ldr.w	r7, [sp], #4
   11824:	4770      	bx	lr

00011826 <__conditional_branch_recording>:
   11826:	b480      	push	{r7}
   11828:	b083      	sub	sp, #12
   1182a:	af00      	add	r7, sp, #0
   1182c:	4603      	mov	r3, r0
   1182e:	71fb      	strb	r3, [r7, #7]
   11830:	bf00      	nop
   11832:	370c      	adds	r7, #12
   11834:	46bd      	mov	sp, r7
   11836:	f85d 7b04 	ldr.w	r7, [sp], #4
   1183a:	4770      	bx	lr

0001183c <__tsf_recording>:
   1183c:	b480      	push	{r7}
   1183e:	b083      	sub	sp, #12
   11840:	af00      	add	r7, sp, #0
   11842:	6078      	str	r0, [r7, #4]
   11844:	6039      	str	r1, [r7, #0]
   11846:	bf00      	nop
   11848:	370c      	adds	r7, #12
   1184a:	46bd      	mov	sp, r7
   1184c:	f85d 7b04 	ldr.w	r7, [sp], #4
   11850:	4770      	bx	lr
   11852:	bf00      	nop

Disassembly of section .trampoline:

00011854 <__cfv_icall>:
   11854:	e24dd080 	sub	sp, sp, #128	; 0x80
   11858:	e58d0000 	str	r0, [sp]
   1185c:	e58d1008 	str	r1, [sp, #8]
   11860:	e58d2010 	str	r2, [sp, #16]
   11864:	e58d3018 	str	r3, [sp, #24]
   11868:	e58d4020 	str	r4, [sp, #32]
   1186c:	e58d5028 	str	r5, [sp, #40]	; 0x28
   11870:	e58d6030 	str	r6, [sp, #48]	; 0x30
   11874:	e58d7038 	str	r7, [sp, #56]	; 0x38
   11878:	e58d8040 	str	r8, [sp, #64]	; 0x40
   1187c:	e58d9048 	str	r9, [sp, #72]	; 0x48
   11880:	e58da050 	str	sl, [sp, #80]	; 0x50
   11884:	e58db058 	str	fp, [sp, #88]	; 0x58
   11888:	e58dc060 	str	ip, [sp, #96]	; 0x60
   1188c:	e58dd068 	str	sp, [sp, #104]	; 0x68
   11890:	e58de070 	str	lr, [sp, #112]	; 0x70
   11894:	e10f4000 	mrs	r4, CPSR
   11898:	e58d4078 	str	r4, [sp, #120]	; 0x78
   1189c:	faffff54 	blx	115f4 <.DATA_REGION_6__sdata_end>
   118a0:	e59d4078 	ldr	r4, [sp, #120]	; 0x78
   118a4:	e129f004 	msr	CPSR_fc, r4
   118a8:	e59d0000 	ldr	r0, [sp]
   118ac:	e59d1008 	ldr	r1, [sp, #8]
   118b0:	e59d2010 	ldr	r2, [sp, #16]
   118b4:	e59d3018 	ldr	r3, [sp, #24]
   118b8:	e59d4020 	ldr	r4, [sp, #32]
   118bc:	e59d5028 	ldr	r5, [sp, #40]	; 0x28
   118c0:	e59d6030 	ldr	r6, [sp, #48]	; 0x30
   118c4:	e59d7038 	ldr	r7, [sp, #56]	; 0x38
   118c8:	e59d8040 	ldr	r8, [sp, #64]	; 0x40
   118cc:	e59d9048 	ldr	r9, [sp, #72]	; 0x48
   118d0:	e59da050 	ldr	sl, [sp, #80]	; 0x50
   118d4:	e59db058 	ldr	fp, [sp, #88]	; 0x58
   118d8:	e59dc060 	ldr	ip, [sp, #96]	; 0x60
   118dc:	e59dd068 	ldr	sp, [sp, #104]	; 0x68
   118e0:	e59de070 	ldr	lr, [sp, #112]	; 0x70
   118e4:	e28dd080 	add	sp, sp, #128	; 0x80
   118e8:	e1a0f00e 	mov	pc, lr

Disassembly of section .rodata:

000118ec <mLBolusStepsLength>:
   118ec:	00000009 	andeq	r0, r0, r9
   118f0:	69727953 	ldmdbvs	r2!, {r0, r1, r4, r6, r8, fp, ip, sp, lr}^
   118f4:	5065676e 	rsbpl	r6, r5, lr, ror #14
   118f8:	20706d75 	rsbscs	r6, r0, r5, ror sp
   118fc:	302e3276 	eorcc	r3, lr, r6, ror r2
   11900:	424c6d00 	submi	r6, ip, #0, 26
   11904:	73756c6f 	cmnvc	r5, #28416	; 0x6f00
   11908:	25203d20 	strcs	r3, [r0, #-3360]!	; 0xfffff2e0
   1190c:	74202c66 	strtvc	r2, [r0], #-3174	; 0xfffff39a
   11910:	20656d69 	rsbcs	r6, r5, r9, ror #26
   11914:	63657375 	cmnvs	r5, #-738197503	; 0xd4000001
   11918:	25203a73 	strcs	r3, [r0, #-2675]!	; 0xfffff58d
   1191c:	000a756c 	andeq	r7, sl, ip, ror #10
   11920:	61766e49 	cmnvs	r6, r9, asr #28
   11924:	2064696c 	rsbcs	r6, r4, ip, ror #18
   11928:	6d6d6f63 	stclvs	15, cr6, [sp, #-396]!	; 0xfffffe74
   1192c:	3a646e61 	bcc	192d2b8 <__bss_end__+0x190b4e8>
   11930:	5d005b20 	vstrpl	d5, [r0, #-128]	; 0xffffff80
   11934:	7355000a 	cmpvc	r5, #10
   11938:	25206465 	strcs	r6, [r0, #-1125]!	; 0xfffffb9b
   1193c:	64252e64 	strtvs	r2, [r5], #-3684	; 0xfffff19c
   11940:	004c6d20 	subeq	r6, ip, r0, lsr #26
   11944:	756c6f42 	strbvc	r6, [ip, #-3906]!	; 0xfffff0be
   11948:	64252073 	strtvs	r2, [r5], #-115	; 0xffffff8d
   1194c:	2064252e 	rsbcs	r2, r4, lr, lsr #10
   11950:	4d004c6d 	stcmi	12, cr4, [r0, #-436]	; 0xfffffe4c
   11954:	3e756e65 	cdpcc	14, 7, cr6, cr5, cr5, {3}
   11958:	6c6f4220 	sfmvs	f4, 2, [pc], #-128	; 118e0 <__cfv_icall+0x8c>
   1195c:	74537375 	ldrbvc	r7, [r3], #-885	; 0xfffffc8b
   11960:	25007065 	strcs	r7, [r0, #-101]	; 0xffffff9b
   11964:	64252e64 	strtvs	r2, [r5], #-3684	; 0xfffff19c
   11968:	726f6600 	rsbvc	r6, pc, #0, 12
   1196c:	64726177 	ldrbtvs	r6, [r2], #-375	; 0xfffffe89
   11970:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
   11974:	20746567 	rsbscs	r6, r4, r7, ror #10
   11978:	63657865 	cmnvs	r5, #6619136	; 0x650000
   1197c:	6e697475 	mcrvs	4, 3, r7, cr9, cr5, {3}
   11980:	000a2067 	andeq	r2, sl, r7, rrx
   11984:	72617453 	rsbvc	r7, r1, #1392508928	; 0x53000000
   11988:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
   1198c:	72797320 	rsbsvc	r7, r9, #32, 6	; 0x80000000
   11990:	65676e69 	strbvs	r6, [r7, #-3689]!	; 0xfffff197
   11994:	6d757020 	ldclvs	0, cr7, [r5, #-128]!	; 0xffffff80
   11998:	68000a70 	stmdavs	r0, {r4, r5, r6, r9, fp}
   1199c:	68686868 	stmdavs	r8!, {r3, r5, r6, fp, sp, lr}^
   119a0:	68686868 	stmdavs	r8!, {r3, r5, r6, fp, sp, lr}^
   119a4:	68686868 	stmdavs	r8!, {r3, r5, r6, fp, sp, lr}^
   119a8:	45000a68 	strmi	r0, [r0, #-2664]	; 0xfffff598
   119ac:	6e69646e 	cdpvs	4, 6, cr6, cr9, cr14, {3}
   119b0:	79732067 	ldmdbvc	r3!, {r0, r1, r2, r5, r6, sp}^
   119b4:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
   119b8:	75702065 	ldrbvc	r2, [r0, #-101]!	; 0xffffff9b
   119bc:	000a706d 	andeq	r7, sl, sp, rrx
   119c0:	28207325 	stmdacs	r0!, {r0, r2, r5, r8, r9, ip, sp, lr}
   119c4:	20746e69 	rsbscs	r6, r4, r9, ror #28
   119c8:	206e6970 	rsbcs	r6, lr, r0, ror r9
   119cc:	6425203d 	strtvs	r2, [r5], #-61	; 0xffffffc3
   119d0:	6e69202c 	cdpvs	0, 6, cr2, cr9, cr12, {1}
   119d4:	6f6d2074 	svcvs	0x006d2074
   119d8:	3d206564 	cfstr32cc	mvfx6, [r0, #-400]!	; 0xfffffe70
   119dc:	29642520 	stmdbcs	r4!, {r5, r8, sl, sp}^
   119e0:	7325000a 			; <UNDEFINED> instruction: 0x7325000a
   119e4:	6e692820 	cdpvs	8, 6, cr2, cr9, cr0, {1}
   119e8:	69702074 	ldmdbvs	r0!, {r2, r4, r5, r6, sp}^
   119ec:	203d206e 	eorscs	r2, sp, lr, rrx
   119f0:	0a296425 	beq	a6aa8c <__bss_end__+0xa48cbc>
   119f4:	20732500 	rsbscs	r2, r3, r0, lsl #10
   119f8:	746e6928 	strbtvc	r6, [lr], #-2344	; 0xfffff6d8
   119fc:	75616220 	strbvc	r6, [r1, #-544]!	; 0xfffffde0
   11a00:	203d2064 	eorscs	r2, sp, r4, rrx
   11a04:	0a296425 	beq	a6aaa0 <__bss_end__+0xa48cd0>
   11a08:	28732500 	ldmdacs	r3!, {r8, sl, sp}^
   11a0c:	3a632029 	bcc	18d9ab8 <__bss_end__+0x18b7ce8>
   11a10:	000a6325 	andeq	r6, sl, r5, lsr #6
   11a14:	28207325 	stmdacs	r0!, {r0, r2, r5, r8, r9, ip, sp, lr}
   11a18:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
   11a1c:	756f2a20 	strbvc	r2, [pc, #-2592]!	; 11004 <get_key+0x2c>
   11a20:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
   11a24:	25203d20 	strcs	r3, [r0, #-3360]!	; 0xfffff2e0
   11a28:	69202c73 	stmdbvs	r0!, {r0, r1, r4, r5, r6, sl, fp, sp}
   11a2c:	6c20746e 	cfstrsvs	mvf7, [r0], #-440	; 0xfffffe48
   11a30:	3d206e65 	stccc	14, cr6, [r0, #-404]!	; 0xfffffe6c
   11a34:	29642520 	stmdbcs	r4!, {r5, r8, sl, sp}^
   11a38:	6572000a 	ldrbvs	r0, [r2, #-10]!
   11a3c:	66206461 	strtvs	r6, [r0], -r1, ror #8
   11a40:	206d6f72 	rsbcs	r6, sp, r2, ror pc
   11a44:	206e6970 	rsbcs	r6, lr, r0, ror r9
   11a48:	000a6425 	andeq	r6, sl, r5, lsr #8
   11a4c:	000a7325 	andeq	r7, sl, r5, lsr #6
   11a50:	28207325 	stmdacs	r0!, {r0, r2, r5, r8, r9, ip, sp, lr}
   11a54:	7571694c 	ldrbvc	r6, [r1, #-2380]!	; 0xfffff6b4
   11a58:	72436469 	subvc	r6, r3, #1761607680	; 0x69000000
   11a5c:	61747379 	cmnvs	r4, r9, ror r3
   11a60:	202a206c 	eorcs	r2, sl, ip, rrx
   11a64:	2064636c 	rsbcs	r6, r4, ip, ror #6
   11a68:	7830203d 	ldmdavc	r0!, {r0, r2, r3, r4, r5, sp}
   11a6c:	202c7825 	eorcs	r7, ip, r5, lsr #16
   11a70:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
   11a74:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
   11a78:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
   11a7c:	6c6f6320 	stclvs	3, cr6, [pc], #-128	; 11a04 <mLBolusStepsLength+0x118>
   11a80:	203d2073 	eorscs	r2, sp, r3, ror r0
   11a84:	202c7525 	eorcs	r7, ip, r5, lsr #10
   11a88:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
   11a8c:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
   11a90:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
   11a94:	776f7220 	strbvc	r7, [pc, -r0, lsr #4]!
   11a98:	203d2073 	eorscs	r2, sp, r3, ror r0
   11a9c:	0a297525 	beq	a6ef38 <__bss_end__+0xa4d168>
   11aa0:	20732500 	rsbscs	r2, r3, r0, lsl #10
   11aa4:	71694c28 	cmnvc	r9, r8, lsr #24
   11aa8:	43646975 	cmnmi	r4, #1916928	; 0x1d4000
   11aac:	74737972 	ldrbtvc	r7, [r3], #-2418	; 0xfffff68e
   11ab0:	2a206c61 	bcs	82cc3c <__bss_end__+0x80ae6c>
   11ab4:	64636c20 	strbtvs	r6, [r3], #-3104	; 0xfffff3e0
   11ab8:	30203d20 	eorcc	r3, r0, r0, lsr #26
   11abc:	0a782578 	beq	1e1b0a4 <__bss_end__+0x1df92d4>
   11ac0:	20732500 	rsbscs	r2, r3, r0, lsl #10
   11ac4:	71694c28 	cmnvc	r9, r8, lsr #24
   11ac8:	43646975 	cmnmi	r4, #1916928	; 0x1d4000
   11acc:	74737972 	ldrbtvc	r7, [r3], #-2418	; 0xfffff68e
   11ad0:	2a206c61 	bcs	82cc5c <__bss_end__+0x80ae8c>
   11ad4:	64636c20 	strbtvs	r6, [r3], #-3104	; 0xfffff3e0
   11ad8:	30203d20 	eorcc	r3, r0, r0, lsr #26
   11adc:	2c782578 	cfldr64cs	mvdx2, [r8], #-480	; 0xfffffe20
   11ae0:	61686320 	cmnvs	r8, r0, lsr #6
   11ae4:	6f202a72 	svcvs	0x00202a72
   11ae8:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
   11aec:	203d2074 	eorscs	r2, sp, r4, ror r0
   11af0:	202c7325 	eorcs	r7, ip, r5, lsr #6
   11af4:	20746e69 	rsbscs	r6, r4, r9, ror #28
   11af8:	206e656c 	rsbcs	r6, lr, ip, ror #10
   11afc:	6425203d 	strtvs	r2, [r5], #-61	; 0xffffffc3
   11b00:	25000a29 	strcs	r0, [r0, #-2601]	; 0xfffff5d7
   11b04:	4c282073 	stcmi	0, cr2, [r8], #-460	; 0xfffffe34
   11b08:	69757169 	ldmdbvs	r5!, {r0, r3, r5, r6, r8, ip, sp, lr}^
   11b0c:	79724364 	ldmdbvc	r2!, {r2, r5, r6, r8, r9, lr}^
   11b10:	6c617473 	cfstrdvs	mvd7, [r1], #-460	; 0xfffffe34
   11b14:	6c202a20 			; <UNDEFINED> instruction: 0x6c202a20
   11b18:	3d206463 	cfstrscc	mvf6, [r0, #-396]!	; 0xfffffe74
   11b1c:	25783020 	ldrbcs	r3, [r8, #-32]!	; 0xffffffe0
   11b20:	69202c78 	stmdbvs	r0!, {r3, r4, r5, r6, sl, fp, sp}
   11b24:	7820746e 	stmdavc	r0!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
   11b28:	25203d20 	strcs	r3, [r0, #-3360]!	; 0xfffff2e0
   11b2c:	69202c64 	stmdbvs	r0!, {r2, r5, r6, sl, fp, sp}
   11b30:	7920746e 	stmdbvc	r0!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
   11b34:	25203d20 	strcs	r3, [r0, #-3360]!	; 0xfffff2e0
   11b38:	21000a64 	tstcs	r0, r4, ror #20
   11b3c:	21212121 			; <UNDEFINED> instruction: 0x21212121
   11b40:	21212121 			; <UNDEFINED> instruction: 0x21212121
   11b44:	21212121 			; <UNDEFINED> instruction: 0x21212121
   11b48:	50212121 	eorpl	r2, r1, r1, lsr #2
   11b4c:	43494e41 	movtmi	r4, #40513	; 0x9e41
   11b50:	21212121 			; <UNDEFINED> instruction: 0x21212121
   11b54:	21212121 			; <UNDEFINED> instruction: 0x21212121
   11b58:	21212121 			; <UNDEFINED> instruction: 0x21212121
   11b5c:	21212121 			; <UNDEFINED> instruction: 0x21212121
   11b60:	0000000a 	andeq	r0, r0, sl
   11b64:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
   11b68:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
   11b6c:	6120657a 			; <UNDEFINED> instruction: 0x6120657a
   11b70:	6e6f6320 	cdpvs	3, 6, cr6, cr15, cr0, {1}
   11b74:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
   11b78:	6f726620 	svcvs	0x00726620
   11b7c:	7375206d 	cmnvc	r5, #109	; 0x6d
   11b80:	73207265 			; <UNDEFINED> instruction: 0x73207265
   11b84:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
   11b88:	00000021 	andeq	r0, r0, r1, lsr #32
   11b8c:	43454554 	movtmi	r4, #21844	; 0x5554
   11b90:	696e495f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, lr}^
   11b94:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
   11b98:	43657a69 	cmnmi	r5, #430080	; 0x69000
   11b9c:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
   11ba0:	66207478 			; <UNDEFINED> instruction: 0x66207478
   11ba4:	656c6961 	strbvs	r6, [ip, #-2401]!	; 0xfffff69f
   11ba8:	69772064 	ldmdbvs	r7!, {r2, r5, r6, sp}^
   11bac:	63206874 			; <UNDEFINED> instruction: 0x63206874
   11bb0:	2065646f 	rsbcs	r6, r5, pc, ror #8
   11bb4:	78257830 	stmdavc	r5!, {r4, r5, fp, ip, sp, lr}
   11bb8:	00000000 	andeq	r0, r0, r0
   11bbc:	43454554 	movtmi	r4, #21844	; 0x5554
   11bc0:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
   11bc4:	7365736e 	cmnvc	r5, #-1207959551	; 0xb8000001
   11bc8:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
   11bcc:	69616620 	stmdbvs	r1!, {r5, r9, sl, sp, lr}^
   11bd0:	2064656c 	rsbcs	r6, r4, ip, ror #10
   11bd4:	68746977 	ldmdavs	r4!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}^
   11bd8:	646f6320 	strbtvs	r6, [pc], #-800	; 11be0 <mLBolusStepsLength+0x2f4>
   11bdc:	78302065 	ldmdavc	r0!, {r0, r2, r5, r6, sp}
   11be0:	6f207825 	svcvs	0x00207825
   11be4:	69676972 	stmdbvs	r7!, {r1, r4, r5, r6, r8, fp, sp, lr}^
   11be8:	7830206e 	ldmdavc	r0!, {r1, r2, r3, r5, r6, sp}
   11bec:	00007825 	andeq	r7, r0, r5, lsr #16
   11bf0:	43454554 	movtmi	r4, #21844	; 0x5554
   11bf4:	766e495f 			; <UNDEFINED> instruction: 0x766e495f
   11bf8:	43656b6f 	cmnmi	r5, #113664	; 0x1bc00
   11bfc:	616d6d6f 	cmnvs	sp, pc, ror #26
   11c00:	6620646e 	strtvs	r6, [r0], -lr, ror #8
   11c04:	656c6961 	strbvs	r6, [ip, #-2401]!	; 0xfffff69f
   11c08:	69772064 	ldmdbvs	r7!, {r2, r5, r6, sp}^
   11c0c:	63206874 			; <UNDEFINED> instruction: 0x63206874
   11c10:	2065646f 	rsbcs	r6, r5, pc, ror #8
   11c14:	78257830 	stmdavc	r5!, {r4, r5, fp, ip, sp, lr}
   11c18:	69726f20 	ldmdbvs	r2!, {r5, r8, r9, sl, fp, sp, lr}^
   11c1c:	206e6967 	rsbcs	r6, lr, r7, ror #18
   11c20:	78257830 	stmdavc	r5!, {r4, r5, fp, ip, sp, lr}
	...

Disassembly of section .ARM.exidx:

00011c28 <.ARM.exidx>:
   11c28:	7fffea5c 	svcvc	0x00ffea5c
   11c2c:	00000001 	andeq	r0, r0, r1

Disassembly of section .dynamic:

00021c30 <_DYNAMIC>:
   21c30:	00000001 	andeq	r0, r0, r1
   21c34:	00000001 	andeq	r0, r0, r1
   21c38:	00000001 	andeq	r0, r0, r1
   21c3c:	0000004b 	andeq	r0, r0, fp, asr #32
   21c40:	00000001 	andeq	r0, r0, r1
   21c44:	0000009e 	muleq	r0, lr, r0
   21c48:	00000004 	andeq	r0, r0, r4
   21c4c:	00010108 	andeq	r0, r1, r8, lsl #2
   21c50:	00000005 	andeq	r0, r0, r5
   21c54:	00010398 	muleq	r1, r8, r3
   21c58:	00000006 	andeq	r0, r0, r6
   21c5c:	000101c8 	andeq	r0, r1, r8, asr #3
   21c60:	0000000a 	andeq	r0, r0, sl
   21c64:	00000135 	andeq	r0, r0, r5, lsr r1
   21c68:	0000000b 	andeq	r0, r0, fp
   21c6c:	00000010 	andeq	r0, r0, r0, lsl r0
   21c70:	00000015 	andeq	r0, r0, r5, lsl r0
   21c74:	00000000 	andeq	r0, r0, r0
   21c78:	00000003 	andeq	r0, r0, r3
   21c7c:	00021ce0 	andeq	r1, r2, r0, ror #25
   21c80:	00000002 	andeq	r0, r0, r2
   21c84:	00000068 	andeq	r0, r0, r8, rrx
   21c88:	00000014 	andeq	r0, r0, r4, lsl r0
   21c8c:	00000011 	andeq	r0, r0, r1, lsl r0
   21c90:	00000017 	andeq	r0, r0, r7, lsl r0
   21c94:	00010538 	andeq	r0, r1, r8, lsr r5
   21c98:	6ffffffe 	svcvs	0x00fffffe
   21c9c:	00010508 	andeq	r0, r1, r8, lsl #10
   21ca0:	6fffffff 	svcvs	0x00ffffff
   21ca4:	00000001 	andeq	r0, r0, r1
   21ca8:	6ffffff0 	svcvs	0x00fffff0
   21cac:	000104ce 	andeq	r0, r1, lr, asr #9
	...

Disassembly of section .got:

00021ce0 <_GLOBAL_OFFSET_TABLE_>:
   21ce0:	00021c30 	andeq	r1, r2, r0, lsr ip
	...
   21cec:	000105a0 	andeq	r0, r1, r0, lsr #11
   21cf0:	000105a0 	andeq	r0, r1, r0, lsr #11
   21cf4:	000105a0 	andeq	r0, r1, r0, lsr #11
   21cf8:	000105a0 	andeq	r0, r1, r0, lsr #11
   21cfc:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d00:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d04:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d08:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d0c:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d10:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d14:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d18:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d1c:	000105a0 	andeq	r0, r1, r0, lsr #11
   21d20:	00021d7c 	andeq	r1, r2, ip, ror sp
   21d24:	00021d84 	andeq	r1, r2, r4, lsl #27
   21d28:	00021d5c 	andeq	r1, r2, ip, asr sp
   21d2c:	00021d88 	andeq	r1, r2, r8, lsl #27
   21d30:	00021d90 	muleq	r2, r0, sp
   21d34:	00021d94 	muleq	r2, r4, sp
   21d38:	00021d44 	andeq	r1, r2, r4, asr #26
   21d3c:	00021d58 	andeq	r1, r2, r8, asr sp

Disassembly of section .data:

00021d40 <ustepsPerMM>:
   21d40:	00000a00 	andeq	r0, r0, r0, lsl #20

00021d44 <uuid>:
   21d44:	d96a5b40 	stmdble	sl!, {r6, r8, r9, fp, ip, lr}^
   21d48:	21e3c3e5 	mvncs	ip, r5, ror #7
   21d4c:	02109487 	andseq	r9, r0, #-2030043136	; 0x87000000
   21d50:	1bc6d5a5 	blne	ff1d73ec <__bss_end__+0xff1b561c>

Disassembly of section .bss:

00021d54 <__bss_start>:
   21d54:	00000000 	andeq	r0, r0, r0

00021d58 <rd_optee_init>:
   21d58:	00000000 	andeq	r0, r0, r0

00021d5c <invoke_cnt>:
   21d5c:	00000000 	andeq	r0, r0, r0

00021d60 <charBuf>:
	...

00021d70 <adc_key_in>:
   21d70:	00000000 	andeq	r0, r0, r0

00021d74 <lcd>:
   21d74:	00000000 	andeq	r0, r0, r0

00021d78 <current_cpt_id>:
   21d78:	00000000 	andeq	r0, r0, r0

00021d7c <ctx>:
	...

00021d84 <err_origin>:
   21d84:	00000000 	andeq	r0, r0, r0

00021d88 <sess>:
	...

00021d90 <res>:
   21d90:	00000000 	andeq	r0, r0, r0

00021d94 <op>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	6e616c63 	cdpvs	12, 6, cr6, cr1, cr3, {3}
   4:	65762067 	ldrbvs	r2, [r6, #-103]!	; 0xffffff99
   8:	6f697372 	svcvs	0x00697372
   c:	2e33206e 	cdpcs	0, 3, cr2, cr3, cr14, {3}
  10:	20302e39 	eorscs	r2, r0, r9, lsr lr
  14:	43434700 	movtmi	r4, #14080	; 0x3700
  18:	4c28203a 	stcmi	0, cr2, [r8], #-232	; 0xffffff18
  1c:	72616e69 	rsbvc	r6, r1, #1680	; 0x690
  20:	4347206f 	movtmi	r2, #28783	; 0x706f
  24:	2e362043 	cdpcs	0, 3, cr2, cr6, cr3, {2}
  28:	30322d32 	eorscc	r2, r2, r2, lsr sp
  2c:	312e3631 			; <UNDEFINED> instruction: 0x312e3631
  30:	36202931 			; <UNDEFINED> instruction: 0x36202931
  34:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
  38:	31303220 	teqcc	r0, r0, lsr #4
  3c:	31303136 	teqcc	r0, r6, lsr r1
  40:	Address 0x0000000000000040 is out of bounds.


Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00003841 	andeq	r3, r0, r1, asr #16
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	0000002e 	andeq	r0, r0, lr, lsr #32
  10:	412d3705 			; <UNDEFINED> instruction: 0x412d3705
  14:	070a0600 	streq	r0, [sl, -r0, lsl #12]
  18:	09010841 	stmdbeq	r1, {r0, r6, fp}
  1c:	0c030a02 			; <UNDEFINED> instruction: 0x0c030a02
  20:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
  24:	15011404 	strne	r1, [r1, #-1028]	; 0xfffffbfc
  28:	18031701 	stmdane	r3, {r0, r8, r9, sl, ip}
  2c:	1c021a01 			; <UNDEFINED> instruction: 0x1c021a01
  30:	22011e01 	andcs	r1, r1, #1, 28
  34:	44012601 	strmi	r2, [r1], #-1537	; 0xfffff9ff
  38:	Address 0x0000000000000038 is out of bounds.


Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	0a360002 	beq	d80014 <__bss_end__+0xd5e244>
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00011854 	andeq	r1, r1, r4, asr r8
  14:	00000098 	muleq	r0, r8, r0
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	0a5c0002 	beq	1700034 <__bss_end__+0x16de264>
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	000115f4 	strdeq	r1, [r1], -r4
  34:	0000025e 	andeq	r0, r0, lr, asr r2
	...

Disassembly of section .debug_pubnames:

00000000 <.debug_pubnames>:
   0:	00000291 	muleq	r0, r1, r2
   4:	00000002 	andeq	r0, r0, r2
   8:	05f90000 	ldrbeq	r0, [r9, #0]!
   c:	015e0000 	cmpeq	lr, r0
  10:	4c6d0000 	stclmi	0, cr0, [sp], #-0
  14:	756c6f42 	strbvc	r6, [ip, #-3906]!	; 0xfffff0be
  18:	65745373 	ldrbvs	r5, [r4, #-883]!	; 0xfffffc8d
  1c:	78644970 	stmdavc	r4!, {r4, r5, r6, r8, fp, lr}^
  20:	0003f000 	andeq	pc, r3, r0
  24:	64707500 	ldrbtvs	r7, [r0], #-1280	; 0xfffffb00
  28:	53657461 	cmnpl	r5, #1627389952	; 0x61000000
  2c:	65657263 	strbvs	r7, [r5, #-611]!	; 0xfffffd9d
  30:	0056006e 	subseq	r0, r6, lr, rrx
  34:	73750000 	cmnvc	r5, #0
  38:	73706574 	cmnvc	r0, #116, 10	; 0x1d000000
  3c:	4d726550 	cfldr64mi	mvdx6, [r2, #-320]!	; 0xfffffec0
  40:	003e004c 	eorseq	r0, lr, ip, asr #32
  44:	73750000 	cmnvc	r5, #0
  48:	73706574 	cmnvc	r0, #116, 10	; 0x1d000000
  4c:	4d726550 	cfldr64mi	mvdx6, [r2, #-320]!	; 0xfffffec0
  50:	01c4004d 	biceq	r0, r4, sp, asr #32
  54:	72700000 	rsbsvc	r0, r0, #0
  58:	654b7665 	strbvs	r7, [fp, #-1637]	; 0xfffff99b
  5c:	04ac0079 	strteq	r0, [ip], #121	; 0x79
  60:	65720000 	ldrbvs	r0, [r2, #-0]!
  64:	654b6461 	strbvs	r6, [fp, #-1121]	; 0xfffffb9f
  68:	04ec0079 	strbteq	r0, [ip], #121	; 0x79
  6c:	65670000 	strbvs	r0, [r7, #-0]!
  70:	656b5f74 	strbvs	r5, [fp, #-3956]!	; 0xfffff08c
  74:	01070079 	tsteq	r7, r9, ror r0
  78:	4c6d0000 	stclmi	0, cr0, [sp], #-0
  7c:	756c6f42 	strbvc	r6, [ip, #-3906]!	; 0xfffff0be
  80:	65745373 	ldrbvs	r5, [r4, #-883]!	; 0xfffffc8d
  84:	b3007370 	movwlt	r7, #880	; 0x370
  88:	6b000001 	blvs	94 <printf@plt-0x10520>
  8c:	65447965 	strbvs	r7, [r4, #-2405]	; 0xfffff69b
  90:	6e756f62 	cdpvs	15, 7, cr6, cr5, cr2, {3}
  94:	3c006563 	cfstr32cc	mvfx6, [r0], {99}	; 0x63
  98:	6d000001 	stcvs	0, cr0, [r0, #-4]
  9c:	6769424c 	strbvs	r4, [r9, -ip, asr #4]!
  a0:	756c6f42 	strbvc	r6, [ip, #-3906]!	; 0xfffff0be
  a4:	01f70073 	mvnseq	r0, r3, ror r0
  a8:	72700000 	rsbsvc	r0, r0, #0
  ac:	72547665 	subsvc	r7, r4, #105906176	; 0x6500000
  b0:	65676769 	strbvs	r6, [r7, #-1897]!	; 0xfffff897
  b4:	02830072 	addeq	r0, r3, #114	; 0x72
  b8:	636c0000 	cmnvs	ip, #0
  bc:	01800064 	orreq	r0, r0, r4, rrx
  c0:	74730000 	ldrbtvc	r0, [r3], #-0
  c4:	65707065 	ldrbvs	r7, [r0, #-101]!	; 0xffffff9b
  c8:	736f5072 	cmnvc	pc, #114	; 0x72
  cc:	00006700 	andeq	r6, r0, r0, lsl #14
  d0:	746f6d00 	strbtvc	r6, [pc], #-3328	; d8 <printf@plt-0x104dc>
  d4:	6944726f 	stmdbvs	r4, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}^
  d8:	6e695072 	mcrvs	0, 3, r5, cr9, cr2, {3}
  dc:	00024400 	andeq	r4, r2, r0, lsl #8
  e0:	72657300 	rsbvc	r7, r5, #0, 6
  e4:	536c6169 	cmnpl	ip, #1073741850	; 0x4000001a
  e8:	654c7274 	strbvs	r7, [ip, #-628]	; 0xfffffd8c
  ec:	01a2006e 			; <UNDEFINED> instruction: 0x01a2006e
  f0:	656b0000 	strbvs	r0, [fp, #-0]!
  f4:	70655279 	rsbvc	r5, r5, r9, ror r2
  f8:	44746165 	ldrbtmi	r6, [r4], #-357	; 0xfffffe9b
  fc:	79616c65 	stmdbvc	r1!, {r0, r2, r5, r6, sl, fp, sp, lr}^
 100:	00016f00 	andeq	r6, r1, r0, lsl #30
 104:	424c6d00 	submi	r6, ip, #0, 26
 108:	73756c6f 	cmnvc	r5, #28416	; 0x6f00
 10c:	70657453 	rsbvc	r7, r5, r3, asr r4
 110:	00026600 	andeq	r6, r2, r0, lsl #12
 114:	61686300 	cmnvs	r8, r0, lsl #6
 118:	66754272 			; <UNDEFINED> instruction: 0x66754272
 11c:	00048600 	andeq	r8, r4, r0, lsl #12
 120:	61657200 	cmnvs	r5, r0, lsl #4
 124:	72655364 	rsbvc	r5, r5, #100, 6	; 0x90000001
 128:	006c6169 	rsbeq	r6, ip, r9, ror #2
 12c:	00000339 	andeq	r0, r0, r9, lsr r3
 130:	706f6f6c 	rsbvc	r6, pc, ip, ror #30
 134:	00054300 	andeq	r4, r5, r0, lsl #6
 138:	726f6600 	rsbvc	r6, pc, #0, 12
 13c:	64726177 	ldrbtvs	r6, [r2], #-375	; 0xfffffe89
 140:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
 144:	00746567 	rsbseq	r6, r4, r7, ror #10
 148:	00000375 	andeq	r0, r0, r5, ror r3
 14c:	636f7270 	cmnvs	pc, #112, 4
 150:	53737365 	cmnpl	r3, #-1811939327	; 0x94000001
 154:	61697265 	cmnvs	r9, r5, ror #4
 158:	0521006c 	streq	r0, [r1, #-108]!	; 0xffffff94
 15c:	6f640000 	svcvs	0x00640000
 160:	4179654b 	cmnmi	r9, fp, asr #10
 164:	6f697463 	svcvs	0x00697463
 168:	01e6006e 	mvneq	r0, lr, rrx
 16c:	72700000 	rsbsvc	r0, r0, #0
 170:	69427665 	stmdbvs	r2, {r0, r2, r5, r6, r9, sl, ip, sp, lr}^
 174:	69725467 	ldmdbvs	r2!, {r0, r1, r2, r5, r6, sl, ip, lr}^
 178:	72656767 	rsbvc	r6, r5, #27000832	; 0x19c0000
 17c:	00039f00 	andeq	r9, r3, r0, lsl #30
 180:	6c6f6200 	sfmvs	f6, 2, [pc], #-0	; 188 <printf@plt-0x1042c>
 184:	55007375 	strpl	r7, [r0, #-885]	; 0xfffffc8b
 188:	61000002 	tstvs	r0, r2
 18c:	6b5f6364 	blvs	17d8f24 <__bss_end__+0x17b7154>
 190:	695f7965 	ldmdbvs	pc, {r0, r2, r5, r6, r8, fp, ip, sp, lr}^	; <UNPREDICTABLE>
 194:	0440006e 	strbeq	r0, [r0], #-110	; 0xffffff92
 198:	68630000 	stmdavs	r3!, {}^	; <UNPREDICTABLE>
 19c:	546b6365 	strbtpl	r6, [fp], #-869	; 0xfffffc9b
 1a0:	67676972 			; <UNDEFINED> instruction: 0x67676972
 1a4:	00737265 	rsbseq	r7, r3, r5, ror #4
 1a8:	000000e0 	andeq	r0, r0, r0, ror #1
 1ac:	0079656b 	rsbseq	r6, r9, fp, ror #10
 1b0:	00000026 	andeq	r0, r0, r6, lsr #32
 1b4:	626f6c67 	rsbvs	r6, pc, #26368	; 0x6700
 1b8:	645f6c61 	ldrbvs	r6, [pc], #-3169	; 1c0 <printf@plt-0x103f4>
 1bc:	00617461 	rsbeq	r7, r1, r1, ror #8
 1c0:	000000cf 	andeq	r0, r0, pc, asr #1
 1c4:	5f4d554e 	svcpl	0x004d554e
 1c8:	5359454b 	cmppl	r9, #314572800	; 0x12c00000
 1cc:	00009a00 	andeq	r9, r0, r0, lsl #20
 1d0:	67696200 	strbvs	r6, [r9, -r0, lsl #4]!
 1d4:	67697254 			; <UNDEFINED> instruction: 0x67697254
 1d8:	50726567 	rsbspl	r6, r2, r7, ror #10
 1dc:	2c006e69 	stccs	14, cr6, [r0], {105}	; 0x69
 1e0:	73000002 	movwvc	r0, #2
 1e4:	61697265 	cmnvs	r9, r5, ror #4
 1e8:	7274536c 	rsbsvc	r5, r4, #108, 6	; 0xb0000001
 1ec:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
 1f0:	00f10079 	rscseq	r0, r1, r9, ror r0
 1f4:	4c6d0000 	stclmi	0, cr0, [sp], #-0
 1f8:	756c6f42 	strbvc	r6, [ip, #-3906]!	; 0xfffff0be
 1fc:	65745373 	ldrbvs	r5, [r4, #-883]!	; 0xfffffc8d
 200:	654c7370 	strbvs	r7, [ip, #-880]	; 0xfffffc90
 204:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
 208:	00014d00 	andeq	r4, r1, r0, lsl #26
 20c:	554c6d00 	strbpl	r6, [ip, #-3328]	; 0xfffff300
 210:	00646573 	rsbeq	r6, r4, r3, ror r5
 214:	00000328 	andeq	r0, r0, r8, lsr #6
 218:	75746573 	ldrbvc	r6, [r4, #-1395]!	; 0xfffffa8d
 21c:	00ab0070 	adceq	r0, fp, r0, ror r0
 220:	64610000 	strbtvs	r0, [r1], #-0
 224:	656b5f63 	strbvs	r5, [fp, #-3939]!	; 0xfffff09d
 228:	61765f79 	cmnvs	r6, r9, ror pc
 22c:	0191006c 	orrseq	r0, r1, ip, rrx
 230:	616c0000 	cmnvs	ip, r0
 234:	654b7473 	strbvs	r7, [fp, #-1139]	; 0xfffffb8d
 238:	70655279 	rsbvc	r5, r5, r9, ror r2
 23c:	41746165 	cmnmi	r4, r5, ror #2
 240:	00780074 	rsbseq	r0, r8, r4, ror r0
 244:	6f6d0000 	svcvs	0x006d0000
 248:	53726f74 	cmnpl	r2, #116, 30	; 0x1d0
 24c:	50706574 	rsbspl	r6, r0, r4, ror r5
 250:	08006e69 	stmdaeq	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
 254:	73000002 	movwvc	r0, #2
 258:	61697265 	cmnvs	r9, r5, ror #4
 25c:	7274536c 	rsbsvc	r5, r4, #108, 6	; 0xb0000001
 260:	00056500 	andeq	r6, r5, r0, lsl #10
 264:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 268:	0089006e 	addeq	r0, r9, lr, rrx
 26c:	72740000 	rsbsvc	r0, r4, #0
 270:	65676769 	strbvs	r6, [r7, #-1897]!	; 0xfffff897
 274:	6e695072 	mcrvs	0, 3, r5, cr9, cr2, {3}
 278:	00012b00 	andeq	r2, r1, r0, lsl #22
 27c:	424c6d00 	submi	r6, ip, #0, 26
 280:	73756c6f 	cmnvc	r5, #28416	; 0x6f00
 284:	0001d500 	andeq	sp, r1, r0, lsl #10
 288:	53697500 	cmnpl	r9, #0, 10
 28c:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
 290:	00000000 	andeq	r0, r0, r0
 294:	0000c700 	andeq	ip, r0, r0, lsl #14
 298:	f9000200 			; <UNDEFINED> instruction: 0xf9000200
 29c:	67000005 	strvs	r0, [r0, -r5]
 2a0:	d4000002 	strle	r0, [r0], #-2
 2a4:	53000000 	movwpl	r0, #0
 2a8:	61697265 	cmnvs	r9, r5, ror #4
 2ac:	76615f6c 	strbtvc	r5, [r1], -ip, ror #30
 2b0:	616c6961 	cmnvs	ip, r1, ror #18
 2b4:	00656c62 	rsbeq	r6, r5, r2, ror #24
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	63657375 	cmnvs	r5, #-738197503	; 0xd4000001
 2c0:	00b40073 	adcseq	r0, r4, r3, ror r0
 2c4:	65530000 	ldrbvs	r0, [r3, #-0]
 2c8:	6c616972 			; <UNDEFINED> instruction: 0x6c616972
 2cc:	6765625f 			; <UNDEFINED> instruction: 0x6765625f
 2d0:	e8006e69 	stmda	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
 2d4:	74000001 	strvc	r0, [r0], #-1
 2d8:	6e49556f 	cdpvs	5, 4, cr5, cr9, cr15, {3}
 2dc:	01c80074 	biceq	r0, r8, r4, ror r0
 2e0:	65640000 	strbvs	r0, [r4, #-0]!
 2e4:	4d79616c 	ldfmie	f6, [r9, #-432]!	; 0xfffffe50
 2e8:	6f726369 	svcvs	0x00726369
 2ec:	6f636573 	svcvs	0x00636573
 2f0:	0073646e 	rsbseq	r6, r3, lr, ror #8
 2f4:	00000086 	andeq	r0, r0, r6, lsl #1
 2f8:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
 2fc:	576c6174 			; <UNDEFINED> instruction: 0x576c6174
 300:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
 304:	00005400 	andeq	r5, r0, r0, lsl #8
 308:	67696400 	strbvs	r6, [r9, -r0, lsl #8]!
 30c:	6c617469 	cfstrdvs	mvd7, [r1], #-420	; 0xfffffe5c
 310:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
 314:	0000f800 	andeq	pc, r0, r0, lsl #16
 318:	72655300 	rsbvc	r5, r5, #0, 6
 31c:	5f6c6169 	svcpl	0x006c6169
 320:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
 324:	00002600 	andeq	r2, r0, r0, lsl #12
 328:	6e697000 	cdpvs	0, 6, cr7, cr9, cr0, {0}
 32c:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
 330:	00011c00 	andeq	r1, r1, r0, lsl #24
 334:	72655300 	rsbvc	r5, r5, #0, 6
 338:	5f6c6169 	svcpl	0x006c6169
 33c:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 340:	014e0065 	cmpeq	lr, r5, rrx
 344:	6e610000 	cdpvs	0, 6, cr0, cr1, cr0, {0}
 348:	676f6c61 	strbvs	r6, [pc, -r1, ror #24]!
 34c:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
 350:	00018000 	andeq	r8, r1, r0
 354:	6c696d00 	stclvs	13, cr6, [r9], #-0
 358:	0073696c 	rsbseq	r6, r3, ip, ror #18
 35c:	00000000 	andeq	r0, r0, r0
 360:	00000025 	andeq	r0, r0, r5, lsr #32
 364:	08600002 	stmdaeq	r0!, {r1}^
 368:	00490000 	subeq	r0, r9, r0
 36c:	00260000 	eoreq	r0, r6, r0
 370:	656c0000 	strbvs	r0, [ip, #-0]!
 374:	6e6f5f64 	cdpvs	15, 6, cr5, cr15, cr4, {3}
 378:	00003700 	andeq	r3, r0, r0, lsl #14
 37c:	64656c00 	strbtvs	r6, [r5], #-3072	; 0xfffff400
 380:	66666f5f 	uqsaxvs	r6, r6, pc	; <UNPREDICTABLE>
 384:	00000000 	andeq	r0, r0, r0
 388:	00004a00 	andeq	r4, r0, r0, lsl #20
 38c:	a9000200 	stmdbge	r0, {r9}
 390:	20000008 	andcs	r0, r0, r8
 394:	26000001 	strcs	r0, [r0], -r1
 398:	6c000000 	stcvs	0, cr0, [r0], {-0}
 39c:	625f6463 	subsvs	r6, pc, #1660944384	; 0x63000000
 3a0:	6e696765 	cdpvs	7, 6, cr6, cr9, cr5, {3}
 3a4:	00006200 	andeq	r6, r0, r0, lsl #4
 3a8:	64636c00 	strbtvs	r6, [r3], #-3072	; 0xfffff400
 3ac:	656c635f 	strbvs	r6, [ip, #-863]!	; 0xfffffca1
 3b0:	be007261 	cdplt	2, 0, cr7, cr0, cr1, {3}
 3b4:	6c000000 	stcvs	0, cr0, [r0], {-0}
 3b8:	735f6463 	cmpvc	pc, #1660944384	; 0x63000000
 3bc:	75437465 	strbvc	r7, [r3, #-1125]	; 0xfffffb9b
 3c0:	726f7372 	rsbvc	r7, pc, #-939524095	; 0xc8000001
 3c4:	00008200 	andeq	r8, r0, r0, lsl #4
 3c8:	64636c00 	strbtvs	r6, [r3], #-3072	; 0xfffff400
 3cc:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
 3d0:	0000746e 	andeq	r7, r0, lr, ror #8
 3d4:	42000000 	andmi	r0, r0, #0
 3d8:	02000000 	andeq	r0, r0, #0
 3dc:	0009c900 	andeq	ip, r9, r0, lsl #18
 3e0:	00006d00 	andeq	r6, r0, r0, lsl #26
 3e4:	00002600 	andeq	r2, r0, r0, lsl #12
 3e8:	72756300 	rsbsvc	r6, r5, #0, 6
 3ec:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
 3f0:	7470635f 	ldrbtvc	r6, [r0], #-863	; 0xfffffca1
 3f4:	0064695f 	rsbeq	r6, r4, pc, asr r9
 3f8:	0000005b 	andeq	r0, r0, fp, asr r0
 3fc:	6f727265 	svcvs	0x00727265
 400:	6f665f72 	svcvs	0x00665f72
 404:	00646e75 	rsbeq	r6, r4, r5, ror lr
 408:	00000037 	andeq	r0, r0, r7, lsr r0
 40c:	5f746369 	svcpl	0x00746369
 410:	63656863 	cmnvs	r5, #6488064	; 0x630000
 414:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
 418:	00000000 	andeq	r0, r0, r0
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	000005f5 	strdeq	r0, [r0], -r5
       4:	00000005 	andeq	r0, r0, r5
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	0015000c 	andseq	r0, r5, ip
      14:	00000000 	andeq	r0, r0, r0
      18:	00230000 	eoreq	r0, r3, r0
      1c:	08780000 	ldmdaeq	r8!, {}^	; <UNPREDICTABLE>
      20:	0a300001 	beq	c0002c <__bss_end__+0xbde25c>
      24:	5d020000 	stcpl	0, cr0, [r2, #-0]
      28:	37000000 	strcc	r0, [r0, -r0]
      2c:	01000000 	mrseq	r0, (UNDEF: 0)
      30:	50030528 	andpl	r0, r3, r8, lsr #10
      34:	03000106 	movweq	r0, #262	; 0x106
      38:	00000605 	andeq	r0, r0, r5, lsl #12
      3c:	69020405 	stmdbvs	r2, {r0, r2, sl}
      40:	4f000000 	svcmi	0x00000000
      44:	01000000 	mrseq	r0, (UNDEF: 0)
      48:	4003052b 	andmi	r0, r3, fp, lsr #10
      4c:	0300021d 	movweq	r0, #541	; 0x21d
      50:	0000063a 	andeq	r0, r0, sl, lsr r6
      54:	75020405 	strvc	r0, [r2, #-1029]	; 0xfffffbfb
      58:	4f000000 	svcmi	0x00000000
      5c:	01000000 	mrseq	r0, (UNDEF: 0)
      60:	9c03052c 	cfstr32ls	mvfx0, [r3], {44}	; 0x2c
      64:	02000107 	andeq	r0, r0, #-1073741823	; 0xc0000001
      68:	00000081 	andeq	r0, r0, r1, lsl #1
      6c:	00000037 	andeq	r0, r0, r7, lsr r0
      70:	03053101 	movweq	r3, #20737	; 0x5101
      74:	000107a0 	andeq	r0, r1, r0, lsr #15
      78:	00008d02 	andeq	r8, r0, r2, lsl #26
      7c:	00003700 	andeq	r3, r0, r0, lsl #14
      80:	05320100 	ldreq	r0, [r2, #-256]!	; 0xffffff00
      84:	0107a403 	tsteq	r7, r3, lsl #8
      88:	009a0200 	addseq	r0, sl, r0, lsl #4
      8c:	00370000 	eorseq	r0, r7, r0
      90:	34010000 	strcc	r0, [r1], #-0
      94:	08040305 	stmdaeq	r4, {r0, r2, r8, r9}
      98:	a5020001 	strge	r0, [r2, #-1]
      9c:	37000000 	strcc	r0, [r0, -r0]
      a0:	01000000 	mrseq	r0, (UNDEF: 0)
      a4:	08030535 	stmdaeq	r3, {r0, r2, r4, r5, r8, sl}
      a8:	02000108 	andeq	r0, r0, #8, 2
      ac:	000000b3 	strheq	r0, [r0], -r3
      b0:	000000bc 	strheq	r0, [r0], -ip
      b4:	03053801 	movweq	r3, #22529	; 0x5801
      b8:	000107a8 	andeq	r0, r1, r8, lsr #15
      bc:	00003704 	andeq	r3, r0, r4, lsl #14
      c0:	00c80500 	sbceq	r0, r8, r0, lsl #10
      c4:	00050000 	andeq	r0, r5, r0
      c8:	0000bf06 	andeq	fp, r0, r6, lsl #30
      cc:	02070800 	andeq	r0, r7, #0, 16
      d0:	000000c8 	andeq	r0, r0, r8, asr #1
      d4:	00000037 	andeq	r0, r0, r7, lsr r0
      d8:	03053b01 	movweq	r3, #23297	; 0x5b01
      dc:	000107bc 			; <UNDEFINED> instruction: 0x000107bc
      e0:	00030e02 	andeq	r0, r3, r2, lsl #28
      e4:	00003700 	andeq	r3, r0, r0, lsl #14
      e8:	053d0100 	ldreq	r0, [sp, #-256]!	; 0xffffff00
      ec:	0107c003 	tsteq	r7, r3
      f0:	00d10200 	sbcseq	r0, r1, r0, lsl #4
      f4:	01020000 	mrseq	r0, (UNDEF: 2)
      f8:	46010000 	strmi	r0, [r1], -r0
      fc:	18ec0305 	stmiane	ip!, {r0, r2, r8, r9}^
     100:	37070001 	strcc	r0, [r7, -r1]
     104:	02000000 	andeq	r0, r0, #0
     108:	000000e4 	andeq	r0, r0, r4, ror #1
     10c:	00000118 	andeq	r0, r0, r8, lsl r1
     110:	03054701 	movweq	r4, #22273	; 0x5701
     114:	000107c4 	andeq	r0, r1, r4, asr #15
     118:	00012404 	andeq	r2, r1, r4, lsl #8
     11c:	00c80500 	sbceq	r0, r8, r0, lsl #10
     120:	00090000 	andeq	r0, r9, r0
     124:	0000f103 	andeq	pc, r0, r3, lsl #2
     128:	02040400 	andeq	r0, r4, #0, 8
     12c:	000000f7 	strdeq	r0, [r0], -r7
     130:	00000124 	andeq	r0, r0, r4, lsr #2
     134:	03054a01 	movweq	r4, #23041	; 0x5a01
     138:	000107e8 	andeq	r0, r1, r8, ror #15
     13c:	0000ff02 	andeq	pc, r0, r2, lsl #30
     140:	00012400 	andeq	r2, r1, r0, lsl #8
     144:	054b0100 	strbeq	r0, [fp, #-256]	; 0xffffff00
     148:	0107ec03 	tsteq	r7, r3, lsl #24
     14c:	010a0200 	mrseq	r0, R10_fiq
     150:	01240000 			; <UNDEFINED> instruction: 0x01240000
     154:	4c010000 	stcmi	0, cr0, [r1], {-0}
     158:	080c0305 	stmdaeq	ip, {r0, r2, r8, r9}
     15c:	11020001 	tstne	r2, r1
     160:	37000001 	strcc	r0, [r0, -r1]
     164:	01000000 	mrseq	r0, (UNDEF: 0)
     168:	f003054d 			; <UNDEFINED> instruction: 0xf003054d
     16c:	02000107 	andeq	r0, r0, #-1073741823	; 0xc0000001
     170:	00000120 	andeq	r0, r0, r0, lsr #2
     174:	00000124 	andeq	r0, r0, r4, lsr #2
     178:	03054f01 	movweq	r4, #24321	; 0x5f01
     17c:	000107f4 	strdeq	r0, [r1], -r4
     180:	00012c02 	andeq	r2, r1, r2, lsl #24
     184:	00004f00 	andeq	r4, r0, r0, lsl #30
     188:	05510100 	ldrbeq	r0, [r1, #-256]	; 0xffffff00
     18c:	021d5403 	andseq	r5, sp, #50331648	; 0x3000000
     190:	01370200 	teqeq	r7, r0, lsl #4
     194:	004f0000 	subeq	r0, pc, r0
     198:	55010000 	strpl	r0, [r1, #-0]
     19c:	08100305 	ldmdaeq	r0, {r0, r2, r8, r9}
     1a0:	47020001 	strmi	r0, [r2, -r1]
     1a4:	4f000001 	svcmi	0x00000001
     1a8:	01000000 	mrseq	r0, (UNDEF: 0)
     1ac:	f8030556 			; <UNDEFINED> instruction: 0xf8030556
     1b0:	02000107 	andeq	r0, r0, #-1073741823	; 0xc0000001
     1b4:	00000156 	andeq	r0, r0, r6, asr r1
     1b8:	0000004f 	andeq	r0, r0, pc, asr #32
     1bc:	03055701 	movweq	r5, #22273	; 0x5701
     1c0:	000107fc 	strdeq	r0, [r1], -ip
     1c4:	00016202 	andeq	r6, r1, r2, lsl #4
     1c8:	00003700 	andeq	r3, r0, r0, lsl #14
     1cc:	05580100 	ldrbeq	r0, [r8, #-256]	; 0xffffff00
     1d0:	01080003 	tsteq	r8, r3
     1d4:	016a0200 	cmneq	sl, r0, lsl #4
     1d8:	00370000 	eorseq	r0, r7, r0
     1dc:	5b010000 	blpl	401e4 <__bss_end__+0x1e414>
     1e0:	08140305 	ldmdaeq	r4, {r0, r2, r8, r9}
     1e4:	72020001 	andvc	r0, r2, #1
     1e8:	37000001 	strcc	r0, [r0, -r1]
     1ec:	01000000 	mrseq	r0, (UNDEF: 0)
     1f0:	1803055e 	stmdane	r3, {r1, r2, r3, r4, r6, r8, sl}
     1f4:	02000108 	andeq	r0, r0, #8, 2
     1f8:	00000181 	andeq	r0, r0, r1, lsl #3
     1fc:	00000037 	andeq	r0, r0, r7, lsr r0
     200:	03055f01 	movweq	r5, #24321	; 0x5f01
     204:	0001081c 	andeq	r0, r1, ip, lsl r8
     208:	00018d02 	andeq	r8, r1, r2, lsl #26
     20c:	00021900 	andeq	r1, r2, r0, lsl #18
     210:	05620100 	strbeq	r0, [r2, #-256]!	; 0xffffff00
     214:	01082003 	tsteq	r8, r3
     218:	02250400 	eoreq	r0, r5, #0, 8
     21c:	c8050000 	stmdagt	r5, {}	; <UNPREDICTABLE>
     220:	50000000 	andpl	r0, r0, r0
     224:	095c0300 	ldmdbeq	ip, {r8, r9}^
     228:	01080000 	mrseq	r0, (UNDEF: 8)
     22c:	00019702 	andeq	r9, r1, r2, lsl #14
     230:	00023d00 	andeq	r3, r2, r0, lsl #26
     234:	05630100 	strbeq	r0, [r3, #-256]!	; 0xffffff00
     238:	01087003 	tsteq	r8, r3
     23c:	01a60300 			; <UNDEFINED> instruction: 0x01a60300
     240:	01020000 	mrseq	r0, (UNDEF: 2)
     244:	0001ac02 	andeq	sl, r1, r2, lsl #24
     248:	00003700 	andeq	r3, r0, r0, lsl #14
     24c:	05640100 	strbeq	r0, [r4, #-256]!	; 0xffffff00
     250:	01087403 	tsteq	r8, r3, lsl #8
     254:	01b90200 			; <UNDEFINED> instruction: 0x01b90200
     258:	00370000 	eorseq	r0, r7, r0
     25c:	3c010000 	stccc	0, cr0, [r1], {-0}
     260:	1d700305 	ldclne	3, cr0, [r0, #-20]!	; 0xffffffec
     264:	c4020002 	strgt	r0, [r2], #-2
     268:	77000001 	strvc	r0, [r0, -r1]
     26c:	01000002 	tsteq	r0, r2
     270:	60030552 	andvs	r0, r3, r2, asr r5
     274:	0400021d 	streq	r0, [r0], #-541	; 0xfffffde3
     278:	00000225 	andeq	r0, r0, r5, lsr #4
     27c:	0000c805 	andeq	ip, r0, r5, lsl #16
     280:	02001000 	andeq	r1, r0, #0
     284:	000001cc 	andeq	r0, r0, ip, asr #3
     288:	00000294 	muleq	r0, r4, r2
     28c:	03056701 	movweq	r6, #22273	; 0x5701
     290:	00021d74 	andeq	r1, r2, r4, ror sp
     294:	00029f08 	andeq	r9, r2, r8, lsl #30
     298:	0001e400 	andeq	lr, r1, r0, lsl #8
     29c:	090a0200 	stmdbeq	sl, {r9}
     2a0:	000001d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     2a4:	0a080204 	beq	200abc <__bss_end__+0x1decec>
     2a8:	00000b00 	andeq	r0, r0, r0, lsl #22
     2ac:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
     2b0:	00000902 	andeq	r0, r0, r2, lsl #18
     2b4:	0005fc03 	andeq	pc, r5, r3, lsl #24
     2b8:	0b040700 	bleq	101ec0 <__bss_end__+0xe00f0>
     2bc:	0c430104 	stfeqe	f0, [r3], {4}
     2c0:	000001f2 	strdeq	r0, [r0], -r2
     2c4:	01f80c00 	mvnseq	r0, r0, lsl #24
     2c8:	00010000 	andeq	r0, r1, r0
     2cc:	4401040b 	strmi	r0, [r1], #-1035	; 0xfffffbf5
     2d0:	0001ff0c 	andeq	pc, r1, ip, lsl #30
     2d4:	040c0000 	streq	r0, [ip], #-0
     2d8:	01000002 	tsteq	r0, r2
     2dc:	01040b00 	tsteq	r4, r0, lsl #22
     2e0:	02080c40 	andeq	r0, r8, #64, 24	; 0x4000
     2e4:	0c000000 	stceq	0, cr0, [r0], {-0}
     2e8:	0000020d 	andeq	r0, r0, sp, lsl #4
     2ec:	040b0001 	streq	r0, [fp], #-1
     2f0:	120c3a01 	andne	r3, ip, #4096	; 0x1000
     2f4:	00000002 	andeq	r0, r0, r2
     2f8:	00021c0c 	andeq	r1, r2, ip, lsl #24
     2fc:	230c0100 	movwcs	r0, #49408	; 0xc100
     300:	02000002 	andeq	r0, r0, #2
     304:	00022c0c 	andeq	r2, r2, ip, lsl #24
     308:	350c0300 	strcc	r0, [ip, #-768]	; 0xfffffd00
     30c:	04000002 	streq	r0, [r0], #-2
     310:	0002400c 	andeq	r4, r2, ip
     314:	0b000500 	bleq	171c <printf@plt-0xee98>
     318:	0c410104 	stfeqe	f0, [r1], {4}
     31c:	00000249 	andeq	r0, r0, r9, asr #4
     320:	024e0c00 	subeq	r0, lr, #0, 24
     324:	00010000 	andeq	r0, r1, r0
     328:	0108780d 	tsteq	r8, sp, lsl #16
     32c:	0000b000 	andeq	fp, r0, r0
     330:	c35b0100 	cmpgt	fp, #0, 2
     334:	01000002 	tsteq	r0, r2
     338:	09280e69 	stmdbeq	r8!, {r0, r3, r5, r6, r9, sl, fp}
     33c:	00a80001 	adceq	r0, r8, r1
     340:	5b010000 	blpl	40348 <__bss_end__+0x1e578>
     344:	000002c9 	andeq	r0, r0, r9, asr #5
     348:	020f8a01 	andeq	r8, pc, #4096	; 0x1000
     34c:	040f0c7d 	streq	r0, [pc], #-3197	; 354 <printf@plt-0x10260>
     350:	8a010000 	bhi	40358 <__bss_end__+0x1e588>
     354:	00000037 	andeq	r0, r0, r7, lsr r0
     358:	087d0210 	ldmdaeq	sp!, {r4, r9}^
     35c:	00000415 	andeq	r0, r0, r5, lsl r4
     360:	08219b01 	stmdaeq	r1!, {r0, r8, r9, fp, ip, pc}
     364:	02100000 	andseq	r0, r0, #0
     368:	0680047d 	sxtab16eq	r0, r0, sp, ror #8
     36c:	9b010000 	blls	40374 <__bss_end__+0x1e5a4>
     370:	00000821 	andeq	r0, r0, r1, lsr #16
     374:	09d01100 	ldmibeq	r0, {r8, ip}^
     378:	00f00001 	rscseq	r0, r0, r1
     37c:	5b010000 	blpl	40384 <__bss_end__+0x1e5b4>
     380:	000002ce 	andeq	r0, r0, lr, asr #5
     384:	4012d101 	andsmi	sp, r2, r1, lsl #2
     388:	3400010a 	strcc	r0, [r0], #-266	; 0xfffffef6
     38c:	13000000 	movwne	r0, #0
     390:	1b047d02 	blne	11f7a0 <__bss_end__+0xfd9d0>
     394:	01000004 	tsteq	r0, r4
     398:	000037dc 	ldrdeq	r3, [r0], -ip
     39c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     3a0:	00010ac0 	andeq	r0, r1, r0, asr #21
     3a4:	00000154 	andeq	r0, r0, r4, asr r1
     3a8:	041d5b01 	ldreq	r5, [sp], #-2817	; 0xfffff4ff
     3ac:	e9010000 	stmdb	r1, {}	; <UNPREDICTABLE>
     3b0:	0c7d020f 	lfmeq	f0, 2, [sp], #-60	; 0xffffffc4
     3b4:	00000423 	andeq	r0, r0, r3, lsr #8
     3b8:	0037e901 	eorseq	lr, r7, r1, lsl #18
     3bc:	02130000 	andseq	r0, r3, #0
     3c0:	042d087d 	strteq	r0, [sp], #-2173	; 0xfffff783
     3c4:	ed010000 	stc	0, cr0, [r1, #-0]
     3c8:	0000004f 	andeq	r0, r0, pc, asr #32
     3cc:	047d0213 	ldrbteq	r0, [sp], #-531	; 0xfffffded
     3d0:	00000433 	andeq	r0, r0, r3, lsr r4
     3d4:	0124ff01 	msreq	LR_abt, r1
     3d8:	00140000 	andseq	r0, r4, r0
     3dc:	15000000 	strne	r0, [r0, #-0]
     3e0:	3b007d02 	blcc	1f7f0 <mLBolusStepsLength+0xdf04>
     3e4:	01000004 	tsteq	r0, r4
     3e8:	004f0101 	subeq	r0, pc, r1, lsl #2
     3ec:	00000000 	andeq	r0, r0, r0
     3f0:	010c1816 	tsteq	ip, r6, lsl r8
     3f4:	00019400 	andeq	r9, r1, r0, lsl #8
     3f8:	dc5b0100 	ldflee	f0, [fp], {-0}
     3fc:	01000002 	tsteq	r0, r2
     400:	03150163 	tsteq	r5, #-1073741800	; 0xc0000018
     404:	3d00d87d 	stccc	8, cr13, [r0, #-500]	; 0xfffffe0c
     408:	01000004 	tsteq	r0, r4
     40c:	02190165 	andseq	r0, r9, #1073741849	; 0x40000019
     410:	02150000 	andseq	r0, r5, #0
     414:	07ca087d 			; <UNDEFINED> instruction: 0x07ca087d
     418:	66010000 	strvs	r0, [r1], -r0
     41c:	00021901 	andeq	r1, r2, r1, lsl #18
     420:	7d021500 	cfstr32vc	mvfx1, [r2, #-0]
     424:	00044004 	andeq	r4, r4, r4
     428:	01670100 	cmneq	r7, r0, lsl #2
     42c:	00000037 	andeq	r0, r0, r7, lsr r0
     430:	007d0215 	rsbseq	r0, sp, r5, lsl r2
     434:	00000446 	andeq	r0, r0, r6, asr #8
     438:	37016801 	strcc	r6, [r1, -r1, lsl #16]
     43c:	00000000 	andeq	r0, r0, r0
     440:	010dac11 	tsteq	sp, r1, lsl ip
     444:	0000cc00 	andeq	ip, r0, r0, lsl #24
     448:	e95b0100 	ldmdb	fp, {r8}^
     44c:	01000002 	tsteq	r0, r2
     450:	7d0213ab 	stcvc	3, cr1, [r2, #-684]	; 0xfffffd54
     454:	00044c0c 	andeq	r4, r4, ip, lsl #24
     458:	37ad0100 	strcc	r0, [sp, r0, lsl #2]!
     45c:	13000000 	movwne	r0, #0
     460:	5d087d02 	stcpl	13, cr7, [r8, #-8]
     464:	01000004 	tsteq	r0, r4
     468:	000037b5 			; <UNDEFINED> instruction: 0x000037b5
     46c:	0e201200 	cdpeq	2, 2, cr1, cr0, cr0, {0}
     470:	002c0001 	eoreq	r0, ip, r1
     474:	02130000 	andseq	r0, r3, #0
     478:	046d047d 	strbteq	r0, [sp], #-1149	; 0xfffffb83
     47c:	b8010000 	stmdalt	r1, {}	; <UNPREDICTABLE>
     480:	00000124 	andeq	r0, r0, r4, lsr #2
     484:	78110000 	ldmdavc	r1, {}	; <UNPREDICTABLE>
     488:	7400010e 	strvc	r0, [r0], #-270	; 0xfffffef2
     48c:	01000000 	mrseq	r0, (UNDEF: 0)
     490:	0002f75b 	andeq	pc, r2, fp, asr r7	; <UNPREDICTABLE>
     494:	14c20100 	strbne	r0, [r2], #256	; 0x100
     498:	00000018 	andeq	r0, r0, r8, lsl r0
     49c:	077d0213 			; <UNDEFINED> instruction: 0x077d0213
     4a0:	00000479 	andeq	r0, r0, r9, ror r4
     4a4:	0225c601 	eoreq	ip, r5, #1048576	; 0x100000
     4a8:	00000000 	andeq	r0, r0, r0
     4ac:	010eec16 	tsteq	lr, r6, lsl ip
     4b0:	0000ec00 	andeq	lr, r0, r0, lsl #24
     4b4:	025b0100 	subseq	r0, fp, #0, 2
     4b8:	01000003 	tsteq	r0, r3
     4bc:	0215010b 	andseq	r0, r5, #-1073741822	; 0xc0000002
     4c0:	04800c7d 	streq	r0, [r0], #3197	; 0xc7d
     4c4:	14010000 	strne	r0, [r1], #-0
     4c8:	00004f01 	andeq	r4, r0, r1, lsl #30
     4cc:	7d021500 	cfstr32vc	mvfx1, [r2, #-0]
     4d0:	00048c08 	andeq	r8, r4, r8, lsl #24
     4d4:	01150100 	tsteq	r5, r0, lsl #2
     4d8:	0000004f 	andeq	r0, r0, pc, asr #32
     4dc:	077d0215 			; <UNDEFINED> instruction: 0x077d0215
     4e0:	0000049f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
     4e4:	3d011701 	stccc	7, cr1, [r1, #-4]
     4e8:	00000002 	andeq	r0, r0, r2
     4ec:	010fd817 	tsteq	pc, r7, lsl r8	; <UNPREDICTABLE>
     4f0:	00008000 	andeq	r8, r0, r0
     4f4:	0a5d0100 	beq	17408fc <__bss_end__+0x171eb2c>
     4f8:	01000003 	tsteq	r0, r3
     4fc:	0037017f 	eorseq	r0, r7, pc, ror r1
     500:	02180000 	andseq	r0, r8, #0
     504:	04ae0491 	strteq	r0, [lr], #1169	; 0x491
     508:	7f010000 	svcvc	0x00010000
     50c:	0002b401 	andeq	fp, r2, r1, lsl #8
     510:	91021500 	tstls	r2, r0, lsl #10
     514:	0007c300 	andeq	ip, r7, r0, lsl #6
     518:	01800100 	orreq	r0, r0, r0, lsl #2
     51c:	00000037 	andeq	r0, r0, r7, lsr r0
     520:	10581900 	subsne	r1, r8, r0, lsl #18
     524:	017c0001 	cmneq	ip, r1
     528:	5b010000 	blpl	40530 <__bss_end__+0x1e760>
     52c:	00000312 	andeq	r0, r0, r2, lsl r3
     530:	18012a01 	stmdane	r1, {r0, r9, fp, sp}
     534:	0e047d02 	cdpeq	13, 0, cr7, cr4, cr2, {0}
     538:	01000003 	tsteq	r0, r3
     53c:	02b4012a 	adcseq	r0, r4, #-2147483638	; 0x8000000a
     540:	19000000 	stmdbne	r0, {}	; <UNPREDICTABLE>
     544:	000111d4 	ldrdeq	r1, [r1], -r4
     548:	00000028 	andeq	r0, r0, r8, lsr #32
     54c:	031e5b01 	tsteq	lr, #1024	; 0x400
     550:	9e010000 	cdpls	0, 0, cr0, cr1, cr0, {0}
     554:	7d021801 	stcvc	8, cr1, [r2, #-4]
     558:	00043b04 	andeq	r3, r4, r4, lsl #22
     55c:	019e0100 	orrseq	r0, lr, r0, lsl #2
     560:	00000037 	andeq	r0, r0, r7, lsr r0
     564:	11fc1700 	mvnsne	r1, r0, lsl #14
     568:	00ac0001 	adceq	r0, ip, r1
     56c:	5b010000 	blpl	40574 <__bss_end__+0x1e7a4>
     570:	0000032d 	andeq	r0, r0, sp, lsr #6
     574:	3701a501 	strcc	sl, [r1, -r1, lsl #10]
     578:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     57c:	b4789102 	ldrbtlt	r9, [r8], #-258	; 0xfffffefe
     580:	01000004 	tsteq	r0, r4
     584:	003701a5 	eorseq	r0, r7, r5, lsr #3
     588:	02180000 	andseq	r0, r8, #0
     58c:	04b90c7d 	ldrteq	r0, [r9], #3197	; 0xc7d
     590:	a5010000 	strge	r0, [r1, #-0]
     594:	0005c701 	andeq	ip, r5, r1, lsl #14
     598:	7d021500 	cfstr32vc	mvfx1, [r2, #-0]
     59c:	0004be08 	andeq	fp, r4, r8, lsl #28
     5a0:	01a90100 			; <UNDEFINED> instruction: 0x01a90100
     5a4:	000005d1 	ldrdeq	r0, [r0], -r1
     5a8:	047d0215 	ldrbteq	r0, [sp], #-533	; 0xfffffdeb
     5ac:	000004c5 	andeq	r0, r0, r5, asr #9
     5b0:	dd01ad01 	stcle	13, cr10, [r1, #-4]
     5b4:	15000005 	strne	r0, [r0, #-5]
     5b8:	0f007d02 	svceq	0x00007d02
     5bc:	01000004 	tsteq	r0, r4
     5c0:	003701b1 	ldrhteq	r0, [r7], -r1
     5c4:	1a000000 	bne	5cc <printf@plt-0xffe8>
     5c8:	000005cc 	andeq	r0, r0, ip, asr #11
     5cc:	0002251a 	andeq	r2, r2, sl, lsl r5
     5d0:	05d61a00 	ldrbeq	r1, [r6, #2560]	; 0xa00
     5d4:	1c1b0000 	ldcne	0, cr0, [fp], {-0}
     5d8:	00000037 	andeq	r0, r0, r7, lsr r0
     5dc:	05e21a00 	strbeq	r1, [r2, #2560]!	; 0xa00
     5e0:	1c1b0000 	ldcne	0, cr0, [fp], {-0}
     5e4:	000005f3 	strdeq	r0, [r0], -r3
     5e8:	0002b41c 	andeq	fp, r2, ip, lsl r4
     5ec:	02b41c00 	adcseq	r1, r4, #0, 24
     5f0:	1a000000 	bne	5f8 <printf@plt-0xffbc>
     5f4:	00000294 	muleq	r0, r4, r2
     5f8:	00026300 	andeq	r6, r2, r0, lsl #6
     5fc:	00000500 	andeq	r0, r0, r0, lsl #10
     600:	04000000 	streq	r0, [r0], #-0
     604:	00000001 	andeq	r0, r0, r1
     608:	59000c00 	stmdbpl	r0, {sl, fp}
     60c:	d3000002 	movwle	r0, #2
     610:	23000005 	movwcs	r0, #5
     614:	1c000000 	stcne	0, cr0, [r0], {-0}
     618:	6c000113 	stfvss	f0, [r0], {19}
     61c:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     620:	0001131c 	andeq	r1, r1, ip, lsl r3
     624:	0000003c 	andeq	r0, r0, ip, lsr r0
     628:	03325b01 	teqeq	r2, #1024	; 0x400
     62c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
     630:	047d021d 	ldrbteq	r0, [sp], #-541	; 0xfffffde3
     634:	000004d3 	ldrdeq	r0, [r0], -r3
     638:	00370801 	eorseq	r0, r7, r1, lsl #16
     63c:	021d0000 	andseq	r0, sp, #0
     640:	07ce007d 			; <UNDEFINED> instruction: 0x07ce007d
     644:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
     648:	00000037 	andeq	r0, r0, r7, lsr r0
     64c:	13581e00 	cmpne	r8, #0, 28
     650:	00440001 	subeq	r0, r4, r1
     654:	5b010000 	blpl	4065c <__bss_end__+0x1e88c>
     658:	0000033a 	andeq	r0, r0, sl, lsr r3
     65c:	00370d01 	eorseq	r0, r7, r1, lsl #26
     660:	021d0000 	andseq	r0, sp, #0
     664:	04d3047d 	ldrbeq	r0, [r3], #1149	; 0x47d
     668:	0d010000 	stceq	0, cr0, [r1, #-0]
     66c:	00000037 	andeq	r0, r0, r7, lsr r0
     670:	007d0210 	rsbseq	r0, sp, r0, lsl r2
     674:	000000bb 	strheq	r0, [r0], -fp
     678:	00370e01 	eorseq	r0, r7, r1, lsl #28
     67c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     680:	0001139c 	muleq	r1, ip, r3
     684:	00000014 	andeq	r0, r0, r4, lsl r0
     688:	03465d01 	movteq	r5, #27905	; 0x6d01
     68c:	14010000 	strne	r0, [r1], #-0
     690:	0491021d 	ldreq	r0, [r1], #541	; 0x21d
     694:	000004d3 	ldrdeq	r0, [r0], -r3
     698:	00371401 	eorseq	r1, r7, r1, lsl #8
     69c:	021d0000 	andseq	r0, sp, #0
     6a0:	04d70091 	ldrbeq	r0, [r7], #145	; 0x91
     6a4:	14010000 	strne	r0, [r1], #-0
     6a8:	00000037 	andeq	r0, r0, r7, lsr r0
     6ac:	13b00e00 	movsne	r0, #0, 28
     6b0:	00300001 	eorseq	r0, r0, r1
     6b4:	5b010000 	blpl	406bc <__bss_end__+0x1e8ec>
     6b8:	00000353 	andeq	r0, r0, r3, asr r3
     6bc:	021d1901 	andseq	r1, sp, #16384	; 0x4000
     6c0:	04dd047d 	ldrbeq	r0, [sp], #1149	; 0x47d
     6c4:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     6c8:	00000037 	andeq	r0, r0, r7, lsr r0
     6cc:	13e01f00 	mvnne	r1, #0, 30
     6d0:	00500001 	subseq	r0, r0, r1
     6d4:	5b010000 	blpl	406dc <__bss_end__+0x1e90c>
     6d8:	00000360 	andeq	r0, r0, r0, ror #6
     6dc:	00371e01 	eorseq	r1, r7, r1, lsl #28
     6e0:	02100000 	andseq	r0, r0, #0
     6e4:	0264037d 	rsbeq	r0, r4, #-201326591	; 0xf4000001
     6e8:	1f010000 	svcne	0x00010000
     6ec:	00000225 	andeq	r0, r0, r5, lsr #4
     6f0:	14301f00 	ldrtne	r1, [r0], #-3840	; 0xfffff100
     6f4:	00200001 	eoreq	r0, r0, r1
     6f8:	5b010000 	blpl	40700 <__bss_end__+0x1e930>
     6fc:	00000371 	andeq	r0, r0, r1, ror r3
     700:	00372b01 	eorseq	r2, r7, r1, lsl #22
     704:	02100000 	andseq	r0, r0, #0
     708:	02647f91 	rsbeq	r7, r4, #580	; 0x244
     70c:	2c010000 	stccs	0, cr0, [r1], {-0}
     710:	00000225 	andeq	r0, r0, r5, lsr #4
     714:	14501e00 	ldrbne	r1, [r0], #-3584	; 0xfffff200
     718:	00400001 	subeq	r0, r0, r1
     71c:	5b010000 	blpl	40724 <__bss_end__+0x1e954>
     720:	0000037d 	andeq	r0, r0, sp, ror r3
     724:	00373301 	eorseq	r3, r7, r1, lsl #6
     728:	021d0000 	andseq	r0, sp, #0
     72c:	04e2047d 	strbteq	r0, [r2], #1149	; 0x47d
     730:	33010000 	movwcc	r0, #4096	; 0x1000
     734:	000005cc 	andeq	r0, r0, ip, asr #11
     738:	007d021d 	rsbseq	r0, sp, sp, lsl r2
     73c:	000004e9 	andeq	r0, r0, r9, ror #9
     740:	00373301 	eorseq	r3, r7, r1, lsl #6
     744:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     748:	00011490 	muleq	r1, r0, r4
     74c:	0000003c 	andeq	r0, r0, ip, lsr r0
     750:	038a5b01 	orreq	r5, sl, #1024	; 0x400
     754:	38010000 	stmdacc	r1, {}	; <UNPREDICTABLE>
     758:	00000037 	andeq	r0, r0, r7, lsr r0
     75c:	047d021d 	ldrbteq	r0, [sp], #-541	; 0xfffffde3
     760:	000004d3 	ldrdeq	r0, [r0], -r3
     764:	00373801 	eorseq	r3, r7, r1, lsl #16
     768:	02100000 	andseq	r0, r0, #0
     76c:	00bb007d 	adcseq	r0, fp, sp, ror r0
     770:	39010000 	stmdbcc	r1, {}	; <UNPREDICTABLE>
     774:	00000037 	andeq	r0, r0, r7, lsr r0
     778:	14cc2000 	strbne	r2, [ip], #0
     77c:	00400001 	subeq	r0, r0, r1
     780:	5b010000 	blpl	40788 <__bss_end__+0x1e9b8>
     784:	00000395 	muleq	r0, r5, r3
     788:	02283f01 	eoreq	r3, r8, #1, 30
     78c:	02130000 	andseq	r0, r3, #0
     790:	0415007d 	ldreq	r0, [r5], #-125	; 0xffffff83
     794:	40010000 	andmi	r0, r1, r0
     798:	0000022f 	andeq	r0, r0, pc, lsr #4
     79c:	150c2000 	strne	r2, [ip, #-0]
     7a0:	00300001 	eorseq	r0, r0, r1
     7a4:	5b010000 	blpl	407ac <__bss_end__+0x1e9dc>
     7a8:	0000039c 	muleq	r0, ip, r3
     7ac:	02284801 	eoreq	r4, r8, #65536	; 0x10000
     7b0:	02130000 	andseq	r0, r3, #0
     7b4:	0415007d 	ldreq	r0, [r5], #-125	; 0xffffff83
     7b8:	49010000 	stmdbmi	r1, {}	; <UNPREDICTABLE>
     7bc:	0000022f 	andeq	r0, r0, pc, lsr #4
     7c0:	153c0e00 	ldrne	r0, [ip, #-3584]!	; 0xfffff200
     7c4:	00240001 	eoreq	r0, r4, r1
     7c8:	5b010000 	blpl	407d0 <__bss_end__+0x1ea00>
     7cc:	000003a2 	andeq	r0, r0, r2, lsr #7
     7d0:	021d5101 	andseq	r5, sp, #1073741824	; 0x40000000
     7d4:	039c047d 	orrseq	r0, ip, #2097152000	; 0x7d000000
     7d8:	51010000 	mrspl	r0, (UNDEF: 1)
     7dc:	00000124 	andeq	r0, r0, r4, lsr #2
     7e0:	15601e00 	strbne	r1, [r0, #-3584]!	; 0xfffff200
     7e4:	00280001 	eoreq	r0, r8, r1
     7e8:	5b010000 	blpl	407f0 <__bss_end__+0x1ea20>
     7ec:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
     7f0:	00375501 	eorseq	r5, r7, r1, lsl #10
     7f4:	021d0000 	andseq	r0, sp, #0
     7f8:	04ae7c91 	strteq	r7, [lr], #3217	; 0xc91
     7fc:	55010000 	strpl	r0, [r1, #-0]
     800:	000005cc 	andeq	r0, r0, ip, asr #11
     804:	087d021d 	ldmdaeq	sp!, {r0, r2, r3, r4, r9}^
     808:	000004e9 	andeq	r0, r0, r9, ror #9
     80c:	00375501 	eorseq	r5, r7, r1, lsl #10
     810:	02100000 	andseq	r0, r0, #0
     814:	00bb047d 	adcseq	r0, fp, sp, ror r4
     818:	56010000 	strpl	r0, [r1], -r0
     81c:	00000037 	andeq	r0, r0, r7, lsr r0
     820:	05f70300 	ldrbeq	r0, [r7, #768]!	; 0x300
     824:	04070000 	streq	r0, [r7], #-0
     828:	00051309 	andeq	r1, r5, r9, lsl #6
     82c:	1e030800 	cdpne	8, 0, cr0, cr3, cr0, {0}
     830:	0004ed0a 	andeq	lr, r4, sl, lsl #26
     834:	00025000 	andeq	r5, r2, r0
     838:	00200300 	eoreq	r0, r0, r0, lsl #6
     83c:	0004fd0a 	andeq	pc, r4, sl, lsl #26
     840:	00025b00 	andeq	r5, r2, r0, lsl #22
     844:	04210300 	strteq	r0, [r1], #-768	; 0xfffffd00
     848:	004f2100 	subeq	r2, pc, r0, lsl #2
     84c:	04f40000 	ldrbteq	r0, [r4], #0
     850:	8b020000 	blhi	80858 <__bss_end__+0x5ea88>
     854:	00004f21 	andeq	r4, r0, r1, lsr #30
     858:	00050500 	andeq	r0, r5, r0, lsl #10
     85c:	008d0200 	addeq	r0, sp, r0, lsl #4
     860:	00000045 	andeq	r0, r0, r5, asr #32
     864:	00000005 	andeq	r0, r0, r5
     868:	01040000 	mrseq	r0, (UNDEF: 4)
     86c:	00000000 	andeq	r0, r0, r0
     870:	0260000c 	rsbeq	r0, r0, #12
     874:	07280000 	streq	r0, [r8, -r0]!
     878:	00230000 	eoreq	r0, r3, r0
     87c:	159c0000 	ldrne	r0, [ip]
     880:	00540001 	subseq	r0, r4, r1
     884:	9c220000 	stcls	0, cr0, [r2], #-0
     888:	34000115 	strcc	r0, [r0], #-277	; 0xfffffeeb
     88c:	01000000 	mrseq	r0, (UNDEF: 0)
     890:	0003bb5b 	andeq	fp, r3, fp, asr fp
     894:	22070100 	andcs	r0, r7, #0, 2
     898:	000115d0 	ldrdeq	r1, [r1], -r0
     89c:	00000020 	andeq	r0, r0, r0, lsr #32
     8a0:	03c25b01 	biceq	r5, r2, #1024	; 0x400
     8a4:	0d010000 	stceq	0, cr0, [r1, #-0]
     8a8:	00011c00 	andeq	r1, r1, r0, lsl #24
     8ac:	00000500 	andeq	r0, r0, r0, lsl #10
     8b0:	04000000 	streq	r0, [r0], #-0
     8b4:	00000001 	andeq	r0, r0, r1
     8b8:	66000c00 	strvs	r0, [r0], -r0, lsl #24
     8bc:	71000002 	tstvc	r0, r2
     8c0:	23000007 	movwcs	r0, #7
     8c4:	84000000 	strhi	r0, [r0], #-0
     8c8:	14000106 	strne	r0, [r0], #-262	; 0xfffffefa
     8cc:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     8d0:	00010684 	andeq	r0, r1, r4, lsl #13
     8d4:	00000058 	andeq	r0, r0, r8, asr r0
     8d8:	03ca5b01 	biceq	r5, sl, #1024	; 0x400
     8dc:	06010000 	streq	r0, [r1], -r0
     8e0:	7c91020f 	lfmvc	f0, 4, [r1], {15}
     8e4:	000001cc 	andeq	r0, r0, ip, asr #3
     8e8:	00fa0601 	rscseq	r0, sl, r1, lsl #12
     8ec:	021d0000 	andseq	r0, sp, #0
     8f0:	051b087d 	ldreq	r0, [fp, #-2173]	; 0xfffff783
     8f4:	06010000 	streq	r0, [r1], -r0
     8f8:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
     8fc:	047d021d 	ldrbteq	r0, [sp], #-541	; 0xfffffde3
     900:	00000520 	andeq	r0, r0, r0, lsr #10
     904:	02b40601 	adcseq	r0, r4, #1048576	; 0x100000
     908:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     90c:	000106dc 	ldrdeq	r0, [r1], -ip
     910:	00000030 	andeq	r0, r0, r0, lsr r0
     914:	03d45b01 	bicseq	r5, r4, #1024	; 0x400
     918:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
     91c:	047d020f 	ldrbteq	r0, [sp], #-527	; 0xfffffdf1
     920:	000001cc 	andeq	r0, r0, ip, asr #3
     924:	00fa0e01 	rscseq	r0, sl, r1, lsl #28
     928:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     92c:	0001070c 	andeq	r0, r1, ip, lsl #14
     930:	00000048 	andeq	r0, r0, r8, asr #32
     934:	03de5b01 	bicseq	r5, lr, #1024	; 0x400
     938:	13010000 	movwne	r0, #4096	; 0x1000
     93c:	7c91020f 	lfmvc	f0, 4, [r1], {15}
     940:	000001cc 	andeq	r0, r0, ip, asr #3
     944:	00fa1301 	rscseq	r1, sl, r1, lsl #6
     948:	021d0000 	andseq	r0, sp, #0
     94c:	04e2087d 	strbteq	r0, [r2], #2173	; 0x87d
     950:	13010000 	movwne	r0, #4096	; 0x1000
     954:	000005cc 	andeq	r0, r0, ip, asr #11
     958:	047d021d 	ldrbteq	r0, [sp], #-541	; 0xfffffde3
     95c:	000004e9 	andeq	r0, r0, r9, ror #9
     960:	00371301 	eorseq	r1, r7, r1, lsl #6
     964:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     968:	00010754 	andeq	r0, r1, r4, asr r7
     96c:	00000044 	andeq	r0, r0, r4, asr #32
     970:	03e85b01 	mvneq	r5, #1024	; 0x400
     974:	18010000 	stmdane	r1, {}	; <UNPREDICTABLE>
     978:	7c91020f 	lfmvc	f0, 4, [r1], {15}
     97c:	000001cc 	andeq	r0, r0, ip, asr #3
     980:	00fa1801 	rscseq	r1, sl, r1, lsl #16
     984:	021d0000 	andseq	r0, sp, #0
     988:	011e087d 	tsteq	lr, sp, ror r8
     98c:	18010000 	stmdane	r1, {}	; <UNPREDICTABLE>
     990:	00000037 	andeq	r0, r0, r7, lsr r0
     994:	047d021d 	ldrbteq	r0, [sp], #-541	; 0xfffffde3
     998:	00000439 	andeq	r0, r0, r9, lsr r4
     99c:	00371801 	eorseq	r1, r7, r1, lsl #16
     9a0:	1a000000 	bne	9a8 <printf@plt-0xfc0c>
     9a4:	000000ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     9a8:	00010a08 	andeq	r0, r1, r8, lsl #20
     9ac:	0001e400 	andeq	lr, r1, r0, lsl #8
     9b0:	090a0200 	stmdbeq	sl, {r9}
     9b4:	000001d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     9b8:	23080204 	movwcs	r0, #33284	; 0x8204
     9bc:	00000b00 	andeq	r0, r0, r0, lsl #22
     9c0:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
     9c4:	00000902 	andeq	r0, r0, r2, lsl #18
     9c8:	00006900 	andeq	r6, r0, r0, lsl #18
     9cc:	00000500 	andeq	r0, r0, r0, lsl #10
     9d0:	04000000 	streq	r0, [r0], #-0
     9d4:	00000001 	andeq	r0, r0, r1
     9d8:	76000c00 	strvc	r0, [r0], -r0, lsl #24
     9dc:	15000002 	strne	r0, [r0, #-2]
     9e0:	23000008 	movwcs	r0, #8
     9e4:	ac000000 	stcge	0, cr0, [r0], {-0}
     9e8:	2c000112 	stfcss	f0, [r0], {18}
     9ec:	24000000 	strcs	r0, [r0], #-0
     9f0:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
     9f4:	00000037 	andeq	r0, r0, r7, lsr r0
     9f8:	03050501 	movweq	r0, #21761	; 0x5501
     9fc:	00021d78 	andeq	r1, r2, r8, ror sp
     a00:	0112ac1e 	tsteq	r2, lr, lsl ip
     a04:	00001400 	andeq	r1, r0, r0, lsl #8
     a08:	f65d0100 			; <UNDEFINED> instruction: 0xf65d0100
     a0c:	01000003 	tsteq	r0, r3
     a10:	00003707 	andeq	r3, r0, r7, lsl #14
     a14:	91021d00 	tstls	r2, r0, lsl #26
     a18:	00032600 	andeq	r2, r3, r0, lsl #12
     a1c:	37070100 	strcc	r0, [r7, -r0, lsl #2]
     a20:	00000000 	andeq	r0, r0, r0
     a24:	0112c00d 	tsteq	r2, sp
     a28:	00001800 	andeq	r1, r0, r0, lsl #16
     a2c:	035b0100 	cmpeq	fp, #0, 2
     a30:	01000004 	tsteq	r0, r4
     a34:	0022000e 	eoreq	r0, r2, lr
     a38:	00020000 	andeq	r0, r2, r0
     a3c:	0000020b 	andeq	r0, r0, fp, lsl #4
     a40:	088e0104 	stmeq	lr, {r2, r8}
     a44:	18540000 	ldmdane	r4, {}^	; <UNPREDICTABLE>
     a48:	18ec0001 	stmiane	ip!, {r0}^
     a4c:	05250001 	streq	r0, [r5, #-1]!
     a50:	05320000 	ldreq	r0, [r2, #-0]!
     a54:	05670000 	strbeq	r0, [r7, #-0]!
     a58:	80010000 	andhi	r0, r1, r0
     a5c:	000008e6 	andeq	r0, r0, r6, ror #17
     a60:	021f0004 	andseq	r0, pc, #4
     a64:	01040000 	mrseq	r0, (UNDEF: 4)
     a68:	0000084e 	andeq	r0, r0, lr, asr #16
     a6c:	0009ef1d 	andeq	lr, r9, sp, lsl pc
     a70:	00002300 	andeq	r2, r0, r0, lsl #6
     a74:	0115f400 	tsteq	r5, r0, lsl #8	; <UNPREDICTABLE>
     a78:	00025e00 	andeq	r5, r2, r0, lsl #28
     a7c:	0008ef00 	andeq	lr, r8, r0, lsl #30
     a80:	08010200 	stmdaeq	r1, {r9}
     a84:	00000953 	andeq	r0, r0, r3, asr r9
     a88:	93070202 	movwls	r0, #29186	; 0x7202
     a8c:	02000007 	andeq	r0, r0, #7
     a90:	05fc0704 	ldrbeq	r0, [ip, #1796]!	; 0x704
     a94:	04020000 	streq	r0, [r2], #-0
     a98:	0005f707 	andeq	pc, r5, r7, lsl #14
     a9c:	06010200 	streq	r0, [r1], -r0, lsl #4
     aa0:	00000955 	andeq	r0, r0, r5, asr r9
     aa4:	a3050202 	movwge	r0, #20994	; 0x5202
     aa8:	03000006 	movweq	r0, #6
     aac:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     ab0:	08020074 	stmdaeq	r2, {r2, r4, r5, r6}
     ab4:	00063505 	andeq	r3, r6, r5, lsl #10
     ab8:	07080200 	streq	r0, [r8, -r0, lsl #4]
     abc:	000005f2 	strdeq	r0, [r0], -r2
     ac0:	0006ad04 	andeq	sl, r6, r4, lsl #26
     ac4:	56370200 	ldrtpl	r0, [r7], -r0, lsl #4
     ac8:	04000000 	streq	r0, [r0], #-0
     acc:	00000575 	andeq	r0, r0, r5, ror r5
     ad0:	007a8302 	rsbseq	r8, sl, r2, lsl #6
     ad4:	04020000 	streq	r0, [r2], #-0
     ad8:	00063a05 	andeq	r3, r6, r5, lsl #20
     adc:	0a7a0400 	beq	1e81ae4 <__bss_end__+0x1e5fd14>
     ae0:	84020000 	strhi	r0, [r2], #-0
     ae4:	00000064 	andeq	r0, r0, r4, rrx
     ae8:	bf070402 	svclt	0x00070402
     aec:	05000000 	streq	r0, [r0, #-0]
     af0:	9b040604 	blls	102308 <__bss_end__+0xe0538>
     af4:	02000000 	andeq	r0, r0, #0
     af8:	095c0801 	ldmdbeq	ip, {r0, fp}^
     afc:	9b070000 	blls	1c0b04 <__bss_end__+0x19ed34>
     b00:	04000000 	streq	r0, [r0], #-0
     b04:	000005b3 			; <UNDEFINED> instruction: 0x000005b3
     b08:	0033d803 	eorseq	sp, r3, r3, lsl #16
     b0c:	df080000 	svcle	0x00080000
     b10:	04000008 	streq	r0, [r0], #-8
     b14:	00be0222 	adcseq	r0, lr, r2, lsr #4
     b18:	04060000 	streq	r0, [r6], #-0
     b1c:	00000095 	muleq	r0, r5, r0
     b20:	00081209 	andeq	r1, r8, r9, lsl #4
     b24:	95390500 	ldrls	r0, [r9, #-1280]!	; 0xfffffb00
     b28:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     b2c:	00000825 	andeq	r0, r0, r5, lsr #16
     b30:	004f4705 	subeq	r4, pc, r5, lsl #14
     b34:	5f090000 	svcpl	0x00090000
     b38:	0500000a 	streq	r0, [r0, #-10]
     b3c:	00004f4c 	andeq	r4, r0, ip, asr #30
     b40:	09d60900 	ldmibeq	r6, {r8, fp}^
     b44:	50050000 	andpl	r0, r5, r0
     b48:	0000004f 	andeq	r0, r0, pc, asr #32
     b4c:	f004060a 			; <UNDEFINED> instruction: 0xf004060a
     b50:	0b000000 	bleq	b58 <printf@plt-0xfa5c>
     b54:	000000f1 	strdeq	r0, [r0], -r1
     b58:	0001170c 	andeq	r1, r1, ip, lsl #14
     b5c:	00010c00 	andeq	r0, r1, r0, lsl #24
     b60:	008c0d00 	addeq	r0, ip, r0, lsl #26
     b64:	00400000 	subeq	r0, r0, r0
     b68:	0000fc07 	andeq	pc, r0, r7, lsl #24
     b6c:	a2040600 	andge	r0, r4, #0, 12
     b70:	07000000 	streq	r0, [r0, -r0]
     b74:	00000111 	andeq	r0, r0, r1, lsl r1
     b78:	000a9f08 	andeq	r9, sl, r8, lsl #30
     b7c:	012d0600 			; <UNDEFINED> instruction: 0x012d0600
     b80:	0000010c 	andeq	r0, r0, ip, lsl #2
     b84:	000aa008 	andeq	sl, sl, r8
     b88:	012e0600 			; <UNDEFINED> instruction: 0x012e0600
     b8c:	0000010c 	andeq	r0, r0, ip, lsl #2
     b90:	0008450e 	andeq	r4, r8, lr, lsl #10
     b94:	f1079800 			; <UNDEFINED> instruction: 0xf1079800
     b98:	000002b1 			; <UNDEFINED> instruction: 0x000002b1
     b9c:	00068b0f 	andeq	r8, r6, pc, lsl #22
     ba0:	4ff20700 	svcmi	0x00f20700
     ba4:	00000000 	andeq	r0, r0, r0
     ba8:	0005880f 	andeq	r8, r5, pc, lsl #16
     bac:	95f70700 	ldrbls	r0, [r7, #1792]!	; 0x700
     bb0:	04000000 	streq	r0, [r0], #-0
     bb4:	0006770f 	andeq	r7, r6, pc, lsl #14
     bb8:	95f80700 	ldrbls	r0, [r8, #1792]!	; 0x700
     bbc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     bc0:	000a840f 	andeq	r8, sl, pc, lsl #8
     bc4:	95f90700 	ldrbls	r0, [r9, #1792]!	; 0x700
     bc8:	0c000000 	stceq	0, cr0, [r0], {-0}
     bcc:	000b440f 	andeq	r4, fp, pc, lsl #8
     bd0:	95fa0700 	ldrbls	r0, [sl, #1792]!	; 0x700
     bd4:	10000000 	andne	r0, r0, r0
     bd8:	0007670f 	andeq	r6, r7, pc, lsl #14
     bdc:	95fb0700 	ldrbls	r0, [fp, #1792]!	; 0x700
     be0:	14000000 	strne	r0, [r0], #-0
     be4:	00082c0f 	andeq	r2, r8, pc, lsl #24
     be8:	95fc0700 	ldrbls	r0, [ip, #1792]!	; 0x700
     bec:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     bf0:	000b530f 	andeq	r5, fp, pc, lsl #6
     bf4:	95fd0700 	ldrbls	r0, [sp, #1792]!	; 0x700
     bf8:	1c000000 	stcne	0, cr0, [r0], {-0}
     bfc:	0009610f 	andeq	r6, r9, pc, lsl #2
     c00:	95fe0700 	ldrbls	r0, [lr, #1792]!	; 0x700
     c04:	20000000 	andcs	r0, r0, r0
     c08:	0007b110 	andeq	fp, r7, r0, lsl r1
     c0c:	01000700 	tsteq	r0, r0, lsl #14
     c10:	00000095 	muleq	r0, r5, r0
     c14:	06091024 	streq	r1, [r9], -r4, lsr #32
     c18:	01070000 	mrseq	r0, (UNDEF: 7)
     c1c:	00009501 	andeq	r9, r0, r1, lsl #10
     c20:	92102800 	andsls	r2, r0, #0, 16
     c24:	0700000a 	streq	r0, [r0, -sl]
     c28:	00950102 	addseq	r0, r5, r2, lsl #2
     c2c:	102c0000 	eorne	r0, ip, r0
     c30:	00000932 	andeq	r0, r0, r2, lsr r9
     c34:	e9010407 	stmdb	r1, {r0, r1, r2, sl}
     c38:	30000002 	andcc	r0, r0, r2
     c3c:	00059510 	andeq	r9, r5, r0, lsl r5
     c40:	01060700 	tsteq	r6, r0, lsl #14
     c44:	000002ef 	andeq	r0, r0, pc, ror #5
     c48:	06681034 			; <UNDEFINED> instruction: 0x06681034
     c4c:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     c50:	00004f01 	andeq	r4, r0, r1, lsl #30
     c54:	c5103800 	ldrgt	r3, [r0, #-2048]	; 0xfffff800
     c58:	07000007 	streq	r0, [r0, -r7]
     c5c:	004f010c 	subeq	r0, pc, ip, lsl #2
     c60:	103c0000 	eorsne	r0, ip, r0
     c64:	0000090b 	andeq	r0, r0, fp, lsl #18
     c68:	6f010e07 	svcvs	0x00010e07
     c6c:	40000000 	andmi	r0, r0, r0
     c70:	00069710 	andeq	r9, r6, r0, lsl r7
     c74:	01120700 	tsteq	r2, r0, lsl #14
     c78:	0000002c 	andeq	r0, r0, ip, lsr #32
     c7c:	0b131044 	bleq	4c4d94 <__bss_end__+0x4a2fc4>
     c80:	13070000 	movwne	r0, #28672	; 0x7000
     c84:	00004101 	andeq	r4, r0, r1, lsl #2
     c88:	d0104600 	andsle	r4, r0, r0, lsl #12
     c8c:	07000005 	streq	r0, [r0, -r5]
     c90:	02f50114 	rscseq	r0, r5, #20, 2
     c94:	10470000 	subne	r0, r7, r0
     c98:	000007bf 			; <UNDEFINED> instruction: 0x000007bf
     c9c:	05011807 	streq	r1, [r1, #-2055]	; 0xfffff7f9
     ca0:	48000003 	stmdami	r0, {r0, r1}
     ca4:	00090f10 	andeq	r0, r9, r0, lsl pc
     ca8:	01210700 			; <UNDEFINED> instruction: 0x01210700
     cac:	00000081 	andeq	r0, r0, r1, lsl #1
     cb0:	0aac1050 	beq	feb04df8 <__bss_end__+0xfeae3028>
     cb4:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
     cb8:	00009301 	andeq	r9, r0, r1, lsl #6
     cbc:	b3105800 	tstlt	r0, #0, 16
     cc0:	0700000a 	streq	r0, [r0, -sl]
     cc4:	0093012a 	addseq	r0, r3, sl, lsr #2
     cc8:	105c0000 	subsne	r0, ip, r0
     ccc:	00000aba 			; <UNDEFINED> instruction: 0x00000aba
     cd0:	93012b07 	movwls	r2, #6919	; 0x1b07
     cd4:	60000000 	andvs	r0, r0, r0
     cd8:	000ac110 	andeq	ip, sl, r0, lsl r1
     cdc:	012c0700 			; <UNDEFINED> instruction: 0x012c0700
     ce0:	00000093 	muleq	r0, r3, r0
     ce4:	0ac81064 	beq	ff204e7c <__bss_end__+0xff1e30ac>
     ce8:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
     cec:	0000a701 	andeq	sl, r0, r1, lsl #14
     cf0:	cd106800 	ldcgt	8, cr6, [r0, #-0]
     cf4:	07000007 	streq	r0, [r0, -r7]
     cf8:	004f012f 	subeq	r0, pc, pc, lsr #2
     cfc:	106c0000 	rsbne	r0, ip, r0
     d00:	00000acf 	andeq	r0, r0, pc, asr #21
     d04:	0b013107 	bleq	4d128 <__bss_end__+0x2b358>
     d08:	70000003 	andvc	r0, r0, r3
     d0c:	083a1100 	ldmdaeq	sl!, {r8, ip}
     d10:	96070000 	strls	r0, [r7], -r0
     d14:	00071a0e 	andeq	r1, r7, lr, lsl #20
     d18:	9c070c00 	stcls	12, cr0, [r7], {-0}
     d1c:	000002e9 	andeq	r0, r0, r9, ror #5
     d20:	000a740f 	andeq	r7, sl, pc, lsl #8
     d24:	e99d0700 	ldmib	sp, {r8, r9, sl}
     d28:	00000002 	andeq	r0, r0, r2
     d2c:	00078d0f 	andeq	r8, r7, pc, lsl #26
     d30:	ef9e0700 	svc	0x009e0700
     d34:	04000002 	streq	r0, [r0], #-2
     d38:	0009060f 	andeq	r0, r9, pc, lsl #12
     d3c:	4fa20700 	svcmi	0x00a20700
     d40:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     d44:	b8040600 	stmdalt	r4, {r9, sl}
     d48:	06000002 	streq	r0, [r0], -r2
     d4c:	00013404 	andeq	r3, r1, r4, lsl #8
     d50:	009b0c00 	addseq	r0, fp, r0, lsl #24
     d54:	03050000 	movweq	r0, #20480	; 0x5000
     d58:	8c0d0000 	stchi	0, cr0, [sp], {-0}
     d5c:	00000000 	andeq	r0, r0, r0
     d60:	b1040600 	tstlt	r4, r0, lsl #12
     d64:	0c000002 	stceq	0, cr0, [r0], {2}
     d68:	0000009b 	muleq	r0, fp, r0
     d6c:	0000031b 	andeq	r0, r0, fp, lsl r3
     d70:	00008c0d 	andeq	r8, r0, sp, lsl #24
     d74:	12002700 	andne	r2, r0, #0, 14
     d78:	00000759 	andeq	r0, r0, r9, asr r7
     d7c:	0007f508 	andeq	pc, r7, r8, lsl #10
     d80:	013b0700 	teqeq	fp, r0, lsl #14
     d84:	0000031b 	andeq	r0, r0, fp, lsl r3
     d88:	0009a708 	andeq	sl, r9, r8, lsl #14
     d8c:	013c0700 	teqeq	ip, r0, lsl #14
     d90:	0000031b 	andeq	r0, r0, fp, lsl r3
     d94:	0005da08 	andeq	sp, r5, r8, lsl #20
     d98:	013d0700 	teqeq	sp, r0, lsl #14
     d9c:	0000031b 	andeq	r0, r0, fp, lsl r3
     da0:	00072509 	andeq	r2, r7, r9, lsl #10
     da4:	efa80800 	svc	0x00a80800
     da8:	09000002 	stmdbeq	r0, {r1}
     dac:	000007d3 	ldrdeq	r0, [r0], -r3
     db0:	02efa908 	rsceq	sl, pc, #8, 18	; 0x20000
     db4:	d8090000 	stmdale	r9, {}	; <UNPREDICTABLE>
     db8:	0800000a 	stmdaeq	r0, {r1, r3}
     dbc:	0002efaa 	andeq	lr, r2, sl, lsr #31
     dc0:	07840900 	streq	r0, [r4, r0, lsl #18]
     dc4:	1a090000 	bne	240dcc <__bss_end__+0x21effc>
     dc8:	0000004f 	andeq	r0, r0, pc, asr #32
     dcc:	0001170c 	andeq	r1, r1, ip, lsl #14
     dd0:	00037b00 	andeq	r7, r3, r0, lsl #22
     dd4:	07001300 	streq	r1, [r0, -r0, lsl #6]
     dd8:	00000370 	andeq	r0, r0, r0, ror r3
     ddc:	00091709 	andeq	r1, r9, r9, lsl #14
     de0:	7b1b0900 	blvc	6c31e8 <__bss_end__+0x6a1418>
     de4:	04000003 	streq	r0, [r0], #-3
     de8:	000007da 	ldrdeq	r0, [r0], -sl
     dec:	004f9503 	subeq	r9, pc, r3, lsl #10
     df0:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
     df4:	00081904 	andeq	r1, r8, r4, lsl #18
     df8:	00931400 	addseq	r1, r3, r0, lsl #8
     dfc:	03ac0000 			; <UNDEFINED> instruction: 0x03ac0000
     e00:	8b150000 	blhi	540e08 <__bss_end__+0x51f038>
     e04:	00000003 	andeq	r0, r0, r3
     e08:	000a4d09 	andeq	r4, sl, r9, lsl #26
     e0c:	b7470a00 	strblt	r0, [r7, -r0, lsl #20]
     e10:	06000003 	streq	r0, [r0], -r3
     e14:	00039d04 	andeq	r9, r3, r4, lsl #26
     e18:	0b220900 	bleq	883220 <__bss_end__+0x861450>
     e1c:	930a0000 	movwls	r0, #40960	; 0xa000
     e20:	000000f7 	strdeq	r0, [r0], -r7
     e24:	0003d816 	andeq	sp, r3, r6, lsl r8
     e28:	00931500 	addseq	r1, r3, r0, lsl #10
     e2c:	d8150000 	ldmdale	r5, {}	; <UNPREDICTABLE>
     e30:	00000003 	andeq	r0, r0, r3
     e34:	03de0406 	bicseq	r0, lr, #100663296	; 0x6000000
     e38:	09170000 	ldmdbeq	r7, {}	; <UNPREDICTABLE>
     e3c:	000006e9 	andeq	r0, r0, r9, ror #13
     e40:	03f0960a 	mvnseq	r9, #10485760	; 0xa00000
     e44:	04060000 	streq	r0, [r6], #-0
     e48:	000003c8 	andeq	r0, r0, r8, asr #7
     e4c:	0003ea0b 	andeq	lr, r3, fp, lsl #20
     e50:	00931400 	addseq	r1, r3, r0, lsl #8
     e54:	04090000 	streq	r0, [r9], #-0
     e58:	a7150000 	ldrge	r0, [r5, -r0]
     e5c:	15000000 	strne	r0, [r0, #-0]
     e60:	000003d8 	ldrdeq	r0, [r0], -r8
     e64:	08040900 	stmdaeq	r4, {r8, fp}
     e68:	990a0000 	stmdbls	sl, {}	; <UNPREDICTABLE>
     e6c:	0000041a 	andeq	r0, r0, sl, lsl r4
     e70:	03f50406 	mvnseq	r0, #100663296	; 0x6000000
     e74:	140b0000 	strne	r0, [fp], #-0
     e78:	14000004 	strne	r0, [r0], #-4
     e7c:	00000093 	muleq	r0, r3, r0
     e80:	00000438 	andeq	r0, r0, r8, lsr r4
     e84:	00009315 	andeq	r9, r0, r5, lsl r3
     e88:	00a71500 	adceq	r1, r7, r0, lsl #10
     e8c:	d8150000 	ldmdale	r5, {}	; <UNPREDICTABLE>
     e90:	00000003 	andeq	r0, r0, r3
     e94:	00099809 	andeq	r9, r9, r9, lsl #16
     e98:	499c0a00 	ldmibmi	ip, {r9, fp}
     e9c:	06000004 	streq	r0, [r0], -r4
     ea0:	00041f04 	andeq	r1, r4, r4, lsl #30
     ea4:	04430b00 	strbeq	r0, [r3], #-2816	; 0xfffff500
     ea8:	93140000 	tstls	r4, #0
     eac:	67000000 	strvs	r0, [r0, -r0]
     eb0:	15000004 	strne	r0, [r0, #-4]
     eb4:	000000a7 	andeq	r0, r0, r7, lsr #1
     eb8:	0000a715 	andeq	sl, r0, r5, lsl r7
     ebc:	03d81500 	bicseq	r1, r8, #0, 10
     ec0:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     ec4:	0000097e 	andeq	r0, r0, lr, ror r9
     ec8:	0478a00a 	ldrbteq	sl, [r8], #-10
     ecc:	04060000 	streq	r0, [r6], #-0
     ed0:	0000044e 	andeq	r0, r0, lr, asr #8
     ed4:	0004720b 	andeq	r7, r4, fp, lsl #4
     ed8:	0a230900 	beq	8c32e0 <__bss_end__+0x8a1510>
     edc:	a40a0000 	strge	r0, [sl], #-0
     ee0:	000000f7 	strdeq	r0, [r0], -r7
     ee4:	000b0304 	andeq	r0, fp, r4, lsl #6
     ee8:	25300b00 	ldrcs	r0, [r0, #-2816]!	; 0xfffff500
     eec:	04000000 	streq	r0, [r0], #-0
     ef0:	00000736 	andeq	r0, r0, r6, lsr r7
     ef4:	002c310b 	eoreq	r3, ip, fp, lsl #2
     ef8:	dd040000 	stcle	0, cr0, [r4, #-0]
     efc:	0b000009 	bleq	f28 <printf@plt-0xf68c>
     f00:	00003333 	andeq	r3, r0, r3, lsr r3
     f04:	05c70400 	strbeq	r0, [r7, #1024]	; 0x400
     f08:	3a0b0000 	bcc	2c0f10 <__bss_end__+0x29f140>
     f0c:	0000005d 	andeq	r0, r0, sp, asr r0
     f10:	00073f04 	andeq	r3, r7, r4, lsl #30
     f14:	9ef80c00 	cdpls	12, 15, cr0, cr8, cr0, {0}
     f18:	18000004 	stmdane	r0, {r2}
     f1c:	e1fe0c08 	mvns	r0, r8, lsl #24
     f20:	19000004 	stmdbne	r0, {r2}
     f24:	0c006466 	cfstrseq	mvf6, [r0], {102}	; 0x66
     f28:	004f0100 	subeq	r0, pc, r0, lsl #2
     f2c:	10000000 	andne	r0, r0, r0
     f30:	00000976 	andeq	r0, r0, r6, ror r9
     f34:	e101010c 	tst	r1, ip, lsl #2
     f38:	04000004 	streq	r0, [r0], #-4
     f3c:	02010200 	andeq	r0, r1, #0, 4
     f40:	000001a6 	andeq	r0, r0, r6, lsr #3
     f44:	0005ba1a 	andeq	fp, r5, sl, lsl sl
     f48:	01020c00 	tsteq	r2, r0, lsl #24
     f4c:	000004bf 			; <UNDEFINED> instruction: 0x000004bf
     f50:	090c101b 	stmdbeq	ip, {r0, r1, r3, r4, ip}
     f54:	00053201 	andeq	r3, r5, r1, lsl #4
     f58:	0b0b1000 	bleq	2c4f60 <__bss_end__+0x2a3190>
     f5c:	0a0c0000 	beq	300f64 <__bss_end__+0x2df194>
     f60:	00049e01 	andeq	r9, r4, r1, lsl #28
     f64:	fb100000 	blx	400f6e <__bss_end__+0x3df19e>
     f68:	0c00000a 	stceq	0, cr0, [r0], {10}
     f6c:	0493010b 	ldreq	r0, [r3], #267	; 0x10b
     f70:	10040000 	andne	r0, r4, r0
     f74:	00000619 	andeq	r0, r0, r9, lsl r6
     f78:	93010c0c 	movwls	r0, #7180	; 0x1c0c
     f7c:	06000004 	streq	r0, [r0], -r4
     f80:	00059c10 	andeq	r9, r5, r0, lsl ip
     f84:	010d0c00 	tsteq	sp, r0, lsl #24
     f88:	00000532 	andeq	r0, r0, r2, lsr r5
     f8c:	880c0008 	stmdahi	ip, {r3}
     f90:	42000004 	andmi	r0, r0, #4
     f94:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
     f98:	0000008c 	andeq	r0, r0, ip, lsl #1
     f9c:	b61a0007 	ldrlt	r0, [sl], -r7
     fa0:	0c000006 	stceq	0, cr0, [r0], {6}
     fa4:	04f4010e 	ldrbteq	r0, [r4], #270	; 0x10e
     fa8:	201b0000 	andscs	r0, fp, r0
     fac:	bf01200c 	svclt	0x0001200c
     fb0:	10000005 	andne	r0, r0, r5
     fb4:	00000a6d 	andeq	r0, r0, sp, ror #20
     fb8:	9301210c 	movwls	r2, #4364	; 0x110c
     fbc:	00000000 	andeq	r0, r0, r0
     fc0:	00094310 	andeq	r4, r9, r0, lsl r3
     fc4:	01220c00 			; <UNDEFINED> instruction: 0x01220c00
     fc8:	000000a7 	andeq	r0, r0, r7, lsr #1
     fcc:	068c1004 	streq	r1, [ip], r4
     fd0:	230c0000 	movwcs	r0, #49152	; 0xc000
     fd4:	00049e01 	andeq	r9, r4, r1, lsl #28
     fd8:	69190800 	ldmdbvs	r9, {fp}
     fdc:	270c0064 	strcs	r0, [ip, -r4, rrx]
     fe0:	00004f01 	andeq	r4, r0, r1, lsl #30
     fe4:	3b100c00 	blcc	403fec <__bss_end__+0x3e221c>
     fe8:	0c000009 	stceq	0, cr0, [r0], {9}
     fec:	00a70128 	adceq	r0, r7, r8, lsr #2
     ff0:	10100000 	andsne	r0, r0, r0
     ff4:	00000a66 	andeq	r0, r0, r6, ror #20
     ff8:	9301290c 	movwls	r2, #6412	; 0x190c
     ffc:	14000000 	strne	r0, [r0], #-0
    1000:	00074b10 	andeq	r4, r7, r0, lsl fp
    1004:	012a0c00 			; <UNDEFINED> instruction: 0x012a0c00
    1008:	0000004f 	andeq	r0, r0, pc, asr #32
    100c:	07e41018 			; <UNDEFINED> instruction: 0x07e41018
    1010:	2b0c0000 	blcs	301018 <__bss_end__+0x2df248>
    1014:	0004e101 	andeq	lr, r4, r1, lsl #2
    1018:	1a001c00 	bne	8020 <printf@plt-0x8594>
    101c:	000008f4 	strdeq	r0, [r0], -r4
    1020:	4e012c0c 	cdpmi	12, 0, cr2, cr1, cr12, {0}
    1024:	1b000005 	blne	1040 <printf@plt-0xf574>
    1028:	013a0c08 	teqeq	sl, r8, lsl #24
    102c:	000005ef 	andeq	r0, r0, pc, ror #11
    1030:	000a6d10 	andeq	r6, sl, r0, lsl sp
    1034:	013b0c00 	teqeq	fp, r0, lsl #24
    1038:	00000093 	muleq	r0, r3, r0
    103c:	09431000 	stmdbeq	r3, {ip}^
    1040:	3c0c0000 	stccc	0, cr0, [ip], {-0}
    1044:	0000a701 	andeq	sl, r0, r1, lsl #14
    1048:	1a000400 	bne	2050 <printf@plt-0xe564>
    104c:	000006f5 	strdeq	r0, [r0], -r5
    1050:	cb013d0c 	blgt	50488 <__bss_end__+0x2e6b8>
    1054:	1b000005 	blne	1070 <printf@plt-0xf544>
    1058:	014e0c0c 	cmpeq	lr, ip, lsl #24
    105c:	0000062c 	andeq	r0, r0, ip, lsr #12
    1060:	00068410 	andeq	r8, r6, r0, lsl r4
    1064:	014f0c00 	cmpeq	pc, r0, lsl #24
    1068:	0000062c 	andeq	r0, r0, ip, lsr #12
    106c:	09431000 	stmdbeq	r3, {ip}^
    1070:	500c0000 	andpl	r0, ip, r0
    1074:	0000a701 	andeq	sl, r0, r1, lsl #14
    1078:	10100400 	andsne	r0, r0, r0, lsl #8
    107c:	0c000009 	stceq	0, cr0, [r0], {9}
    1080:	00a70151 	adceq	r0, r7, r1, asr r1
    1084:	00080000 	andeq	r0, r8, r0
    1088:	05bf0406 	ldreq	r0, [pc, #1030]!	; 1496 <printf@plt-0xf11e>
    108c:	ff1a0000 			; <UNDEFINED> instruction: 0xff1a0000
    1090:	0c000009 	stceq	0, cr0, [r0], {9}
    1094:	05fb0152 	ldrbeq	r0, [fp, #338]!	; 0x152
    1098:	081b0000 	ldmdaeq	fp, {}	; <UNPREDICTABLE>
    109c:	5e015e0c 	cdppl	14, 0, cr5, cr1, cr12, {0}
    10a0:	19000006 	stmdbne	r0, {r1, r2}
    10a4:	5f0c0061 	svcpl	0x000c0061
    10a8:	00049e01 	andeq	r9, r4, r1, lsl #28
    10ac:	62190000 	andsvs	r0, r9, #0
    10b0:	01600c00 	cmneq	r0, r0, lsl #24
    10b4:	0000049e 	muleq	r0, lr, r4
    10b8:	2b1a0004 	blcs	6810d0 <__bss_end__+0x65f300>
    10bc:	0c000007 	stceq	0, cr0, [r0], {7}
    10c0:	063e0161 	ldrteq	r0, [lr], -r1, ror #2
    10c4:	0c1c0000 	ldceq	0, cr0, [ip], {-0}
    10c8:	9801710c 	stmdals	r1, {r2, r3, r8, ip, sp, lr}
    10cc:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
    10d0:	00000670 	andeq	r0, r0, r0, ror r6
    10d4:	ef01720c 	svc	0x0001720c
    10d8:	1d000005 	stcne	0, cr0, [r0, #-20]	; 0xffffffec
    10dc:	000005ac 	andeq	r0, r0, ip, lsr #11
    10e0:	3201730c 	andcc	r7, r1, #12, 6	; 0x30000000
    10e4:	1d000006 	stcne	0, cr0, [r0, #-24]	; 0xffffffe8
    10e8:	000004d7 	ldrdeq	r0, [r0], -r7
    10ec:	5e01740c 	cdppl	4, 0, cr7, cr1, cr12, {0}
    10f0:	00000006 	andeq	r0, r0, r6
    10f4:	0009231a 	andeq	r2, r9, sl, lsl r3
    10f8:	01750c00 	cmneq	r5, r0, lsl #24
    10fc:	0000066a 	andeq	r0, r0, sl, ror #12
    1100:	7b0c081b 	blvc	303174 <__bss_end__+0x2e13a4>
    1104:	0006c801 	andeq	ip, r6, r1, lsl #16
    1108:	74631900 	strbtvc	r1, [r3], #-2304	; 0xfffff700
    110c:	7d0c0078 	stcvc	0, cr0, [ip, #-480]	; 0xfffffe20
    1110:	0006c801 	andeq	ip, r6, r1, lsl #16
    1114:	7d100000 	ldcvc	0, cr0, [r0, #-0]
    1118:	0c000005 	stceq	0, cr0, [r0], {5}
    111c:	049e017e 	ldreq	r0, [lr], #382	; 0x17e
    1120:	00040000 	andeq	r0, r4, r0
    1124:	04e80406 	strbteq	r0, [r8], #1030	; 0x406
    1128:	401a0000 	andsmi	r0, sl, r0
    112c:	0c00000a 	stceq	0, cr0, [r0], {10}
    1130:	06a4017f 			; <UNDEFINED> instruction: 0x06a4017f
    1134:	3c1b0000 	ldccc	0, cr0, [fp], {-0}
    1138:	18018f0c 	stmdane	r1, {r2, r3, r8, r9, sl, fp, pc}
    113c:	10000007 	andne	r0, r0, r7
    1140:	000005ea 	andeq	r0, r0, sl, ror #11
    1144:	9e01900c 	cdpls	0, 0, cr9, cr1, cr12, {0}
    1148:	00000004 	andeq	r0, r0, r4
    114c:	00065d10 	andeq	r5, r6, r0, lsl sp
    1150:	01910c00 	orrseq	r0, r1, r0, lsl #24
    1154:	0000049e 	muleq	r0, lr, r4
    1158:	0a391004 	beq	e45170 <__bss_end__+0xe233a0>
    115c:	920c0000 	andls	r0, ip, #0
    1160:	00071801 	andeq	r1, r7, r1, lsl #16
    1164:	d7100800 	ldrle	r0, [r0, -r0, lsl #16]
    1168:	0c000008 	stceq	0, cr0, [r0], {8}
    116c:	07280194 			; <UNDEFINED> instruction: 0x07280194
    1170:	00380000 	eorseq	r0, r8, r0
    1174:	0006980c 	andeq	r9, r6, ip, lsl #16
    1178:	00072800 	andeq	r2, r7, r0, lsl #16
    117c:	008c0d00 	addeq	r0, ip, r0, lsl #26
    1180:	00030000 	andeq	r0, r3, r0
    1184:	06ce0406 	strbeq	r0, [lr], r6, lsl #8
    1188:	751a0000 	ldrvc	r0, [sl, #-0]
    118c:	0c000007 	stceq	0, cr0, [r0], {7}
    1190:	06da0195 			; <UNDEFINED> instruction: 0x06da0195
    1194:	950c0000 	strls	r0, [ip, #-0]
    1198:	4a000000 	bmi	11a0 <printf@plt-0xf414>
    119c:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    11a0:	0000008c 	andeq	r0, r0, ip, lsl #1
    11a4:	3b080001 	blcc	2011b0 <__bss_end__+0x1df3e0>
    11a8:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
    11ac:	073a011a 			; <UNDEFINED> instruction: 0x073a011a
    11b0:	e9080000 	stmdb	r8, {}	; <UNPREDICTABLE>
    11b4:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    11b8:	004f011b 	subeq	r0, pc, fp, lsl r1	; <UNPREDICTABLE>
    11bc:	2a080000 	bcs	2011c4 <__bss_end__+0x1df3f4>
    11c0:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
    11c4:	007a011c 	rsbseq	r0, sl, ip, lsl r1
    11c8:	3d080000 	stccc	0, cr0, [r8, #-0]
    11cc:	0d00000b 	stceq	0, cr0, [r0, #-44]	; 0xffffffd4
    11d0:	073a0121 	ldreq	r0, [sl, -r1, lsr #2]!
    11d4:	eb080000 	bl	2011dc <__bss_end__+0x1df40c>
    11d8:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    11dc:	004f0129 	subeq	r0, pc, r9, lsr #2
    11e0:	2c080000 	stccs	0, cr0, [r8], {-0}
    11e4:	0d000006 	stceq	0, cr0, [r0, #-24]	; 0xffffffe8
    11e8:	007a012a 	rsbseq	r0, sl, sl, lsr #2
    11ec:	721e0000 	andsvc	r0, lr, #0
    11f0:	01007365 	tsteq	r0, r5, ror #6
    11f4:	0004b427 	andeq	fp, r4, r7, lsr #8
    11f8:	90030500 	andls	r0, r3, r0, lsl #10
    11fc:	1e00021d 	mcrne	2, 0, r0, cr0, cr13, {0}
    1200:	00787463 	rsbseq	r7, r8, r3, ror #8
    1204:	04e82801 	strbteq	r2, [r8], #2049	; 0x801
    1208:	03050000 	movweq	r0, #20480	; 0x5000
    120c:	00021d7c 	andeq	r1, r2, ip, ror sp
    1210:	0006921f 	andeq	r9, r6, pc, lsl r2
    1214:	ce290100 	sufgte	f0, f1, f0
    1218:	05000006 	streq	r0, [r0, #-6]
    121c:	021d8803 	andseq	r8, sp, #196608	; 0x30000
    1220:	706f1e00 	rsbvc	r1, pc, r0, lsl #28
    1224:	2e2a0100 	sufcse	f0, f2, f0
    1228:	05000007 	streq	r0, [r0, #-7]
    122c:	021d9403 	andseq	r9, sp, #50331648	; 0x3000000
    1230:	0a1e1f00 	beq	788e38 <__bss_end__+0x767068>
    1234:	2b010000 	blcs	4123c <__bss_end__+0x1f46c>
    1238:	00000542 	andeq	r0, r0, r2, asr #10
    123c:	1d440305 	stclne	3, cr0, [r4, #-20]	; 0xffffffec
    1240:	c01f0002 	andsgt	r0, pc, r2
    1244:	01000006 	tsteq	r0, r6
    1248:	00049e2c 	andeq	r9, r4, ip, lsr #28
    124c:	84030500 	strhi	r0, [r3], #-1280	; 0xfffffb00
    1250:	1f00021d 	svcne	0x0000021d
    1254:	000006cb 	andeq	r0, r0, fp, asr #13
    1258:	04e12e01 	strbteq	r2, [r1], #3585	; 0xe01
    125c:	03050000 	movweq	r0, #20480	; 0x5000
    1260:	00021d58 	andeq	r1, r2, r8, asr sp
    1264:	0007a61f 	andeq	sl, r7, pc, lsl r6
    1268:	4f360100 	svcmi	0x00360100
    126c:	05000000 	streq	r0, [r0, #-0]
    1270:	021d5c03 	andseq	r5, sp, #768	; 0x300
    1274:	06d92000 	ldrbeq	r2, [r9], r0
    1278:	9e010000 	cdpls	0, 0, cr0, cr1, cr0, {0}
    127c:	0001183c 	andeq	r1, r1, ip, lsr r8
    1280:	00000016 	andeq	r0, r0, r6, lsl r0
    1284:	084b9c01 	stmdaeq	fp, {r0, sl, fp, ip, pc}^
    1288:	48210000 	stmdami	r1!, {}	; <UNPREDICTABLE>
    128c:	01000009 	tsteq	r0, r9
    1290:	00004f9e 	muleq	r0, lr, pc	; <UNPREDICTABLE>
    1294:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1298:	00096d21 	andeq	r6, r9, r1, lsr #26
    129c:	4f9e0100 	svcmi	0x009e0100
    12a0:	02000000 	andeq	r0, r0, #0
    12a4:	20007091 	mulcs	r0, r1, r0
    12a8:	000009b7 			; <UNDEFINED> instruction: 0x000009b7
    12ac:	18269a01 	stmdane	r6!, {r0, r9, fp, ip, pc}
    12b0:	00160001 	andseq	r0, r6, r1
    12b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    12b8:	0000086f 	andeq	r0, r0, pc, ror #16
    12bc:	00098e21 	andeq	r8, r9, r1, lsr #28
    12c0:	e19a0100 	orrs	r0, sl, r0, lsl #2
    12c4:	02000004 	andeq	r0, r0, #4
    12c8:	20007791 	mulcs	r0, r1, r7
    12cc:	00000a58 	andeq	r0, r0, r8, asr sl
    12d0:	180c9601 	stmdane	ip, {r0, r9, sl, ip, pc}
    12d4:	001a0001 	andseq	r0, sl, r1
    12d8:	9c010000 	stcls	0, cr0, [r1], {-0}
    12dc:	0000089d 	muleq	r0, sp, r8
    12e0:	01006122 	tsteq	r0, r2, lsr #2
    12e4:	0004a996 	muleq	r4, r6, r9
    12e8:	70910200 	addsvc	r0, r1, r0, lsl #4
    12ec:	01006222 	tsteq	r0, r2, lsr #4
    12f0:	0004a996 	muleq	r4, r6, r9
    12f4:	68910200 	ldmvs	r1, {r9}
    12f8:	0adf2300 	beq	ff7c9f00 <__bss_end__+0xff7a8130>
    12fc:	80010000 	andhi	r0, r1, r0
    1300:	00011788 	andeq	r1, r1, r8, lsl #15
    1304:	00000084 	andeq	r0, r0, r4, lsl #1
    1308:	43249c01 			; <UNDEFINED> instruction: 0x43249c01
    130c:	01000006 	tsteq	r0, r6
    1310:	0115f437 	tsteq	r5, r7, lsr r4	; <UNPREDICTABLE>
    1314:	00019400 	andeq	r9, r1, r0, lsl #8
    1318:	219c0100 	orrscs	r0, ip, r0, lsl #2
    131c:	0000070e 	andeq	r0, r0, lr, lsl #14
    1320:	004f3701 	subeq	r3, pc, r1, lsl #14
    1324:	91020000 	mrsls	r0, (UNDEF: 2)
    1328:	6370226c 	cmnvs	r0, #108, 4	; 0xc0000006
    132c:	4f370100 	svcmi	0x00370100
    1330:	02000000 	andeq	r0, r0, #0
    1334:	e6216891 			; <UNDEFINED> instruction: 0xe6216891
    1338:	01000009 	tsteq	r0, r9
    133c:	00004f37 	andeq	r4, r0, r7, lsr pc
    1340:	64910200 	ldrvs	r0, [r1], #512	; 0x200
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
   4:	0305130e 	movweq	r1, #21262	; 0x530e
   8:	1b17100e 	blne	5c4048 <__bss_end__+0x5a2278>
   c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
  10:	02000006 	andeq	r0, r0, #6
  14:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  18:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
  1c:	0b3b0b3a 	bleq	ec2d0c <__bss_end__+0xea0f3c>
  20:	00001802 	andeq	r1, r0, r2, lsl #16
  24:	03002403 	movweq	r2, #1027	; 0x403
  28:	0b0b3e0e 	bleq	2cf868 <__bss_end__+0x2ada98>
  2c:	0400000b 	streq	r0, [r0], #-11
  30:	13490101 	movtne	r0, #37121	; 0x9101
  34:	21050000 	mrscs	r0, (UNDEF: 5)
  38:	37134900 	ldrcc	r4, [r3, -r0, lsl #18]
  3c:	0600000b 	streq	r0, [r0], -fp
  40:	0e030024 	cdpeq	0, 0, cr0, cr3, cr4, {1}
  44:	0b3e0b0b 	bleq	f82c78 <__bss_end__+0xf60ea8>
  48:	26070000 	strcs	r0, [r7], -r0
  4c:	00134900 	andseq	r4, r3, r0, lsl #18
  50:	00160800 	andseq	r0, r6, r0, lsl #16
  54:	0e031349 	cdpeq	3, 0, cr1, cr3, cr9, {2}
  58:	0b3b0b3a 	bleq	ec2d48 <__bss_end__+0xea0f78>
  5c:	13090000 	movwne	r0, #36864	; 0x9000
  60:	0b0e0301 	bleq	380c6c <__bss_end__+0x35ee9c>
  64:	3b0b3a0b 	blcc	2ce898 <__bss_end__+0x2acac8>
  68:	0a00000b 	beq	9c <printf@plt-0x10518>
  6c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
  70:	0b3a1349 	bleq	e84d9c <__bss_end__+0xe62fcc>
  74:	0b380b3b 	bleq	e02d68 <__bss_end__+0xde0f98>
  78:	040b0000 	streq	r0, [fp], #-0
  7c:	3a0b0b01 	bcc	2c2c88 <__bss_end__+0x2a0eb8>
  80:	000b3b0b 	andeq	r3, fp, fp, lsl #22
  84:	00280c00 	eoreq	r0, r8, r0, lsl #24
  88:	0d1c0e03 	ldceq	14, cr0, [ip, #-12]
  8c:	2e0d0000 	cdpcs	0, 0, cr0, cr13, cr0, {0}
  90:	12011100 	andne	r1, r1, #0, 2
  94:	03184006 	tsteq	r8, #6
  98:	3b0b3a0e 	blcc	2ce8d8 <__bss_end__+0x2acb08>
  9c:	00193f0b 	andseq	r3, r9, fp, lsl #30
  a0:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
  a4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  a8:	0e031840 	cdpeq	8, 0, cr1, cr3, cr0, {2}
  ac:	0b3b0b3a 	bleq	ec2d9c <__bss_end__+0xea0fcc>
  b0:	193f1927 	ldmdbne	pc!, {r0, r1, r2, r5, r8, fp, ip}	; <UNPREDICTABLE>
  b4:	050f0000 	streq	r0, [pc, #-0]	; bc <printf@plt-0x104f8>
  b8:	03180200 	tsteq	r8, #0, 4
  bc:	3b0b3a0e 	blcc	2ce8fc <__bss_end__+0x2acb2c>
  c0:	0013490b 	andseq	r4, r3, fp, lsl #18
  c4:	00341000 	eorseq	r1, r4, r0
  c8:	0e031802 	cdpeq	8, 0, cr1, cr3, cr2, {0}
  cc:	0b3b0b3a 	bleq	ec2dbc <__bss_end__+0xea0fec>
  d0:	00001049 	andeq	r1, r0, r9, asr #32
  d4:	11012e11 	tstne	r1, r1, lsl lr
  d8:	40061201 	andmi	r1, r6, r1, lsl #4
  dc:	3a0e0318 	bcc	380d44 <__bss_end__+0x35ef74>
  e0:	3f0b3b0b 	svccc	0x000b3b0b
  e4:	12000019 	andne	r0, r0, #25
  e8:	0111010b 	tsteq	r1, fp, lsl #2
  ec:	00000612 	andeq	r0, r0, r2, lsl r6
  f0:	02003413 	andeq	r3, r0, #318767104	; 0x13000000
  f4:	3a0e0318 	bcc	380d5c <__bss_end__+0x35ef8c>
  f8:	490b3b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  fc:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 100:	1755010b 	ldrbne	r0, [r5, -fp, lsl #2]
 104:	34150000 	ldrcc	r0, [r5], #-0
 108:	03180200 	tsteq	r8, #0, 4
 10c:	3b0b3a0e 	blcc	2ce94c <__bss_end__+0x2acb7c>
 110:	00134905 	andseq	r4, r3, r5, lsl #18
 114:	012e1600 			; <UNDEFINED> instruction: 0x012e1600
 118:	06120111 			; <UNDEFINED> instruction: 0x06120111
 11c:	0e031840 	cdpeq	8, 0, cr1, cr3, cr0, {2}
 120:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 124:	0000193f 	andeq	r1, r0, pc, lsr r9
 128:	11012e17 	tstne	r1, r7, lsl lr
 12c:	40061201 	andmi	r1, r6, r1, lsl #4
 130:	3a0e0318 	bcc	380d98 <__bss_end__+0x35efc8>
 134:	27053b0b 	strcs	r3, [r5, -fp, lsl #22]
 138:	3f134919 	svccc	0x00134919
 13c:	18000019 	stmdane	r0, {r0, r3, r4}
 140:	18020005 	stmdane	r2, {r0, r2}
 144:	0b3a0e03 	bleq	e83958 <__bss_end__+0xe61b88>
 148:	1349053b 	movtne	r0, #38203	; 0x953b
 14c:	2e190000 	cdpcs	0, 1, cr0, cr9, cr0, {0}
 150:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 154:	03184006 	tsteq	r8, #6
 158:	3b0b3a0e 	blcc	2ce998 <__bss_end__+0x2acbc8>
 15c:	3f192705 	svccc	0x00192705
 160:	1a000019 	bne	1cc <printf@plt-0x103e8>
 164:	1349000f 	movtne	r0, #36879	; 0x900f
 168:	151b0000 	ldrne	r0, [fp, #-0]
 16c:	00192701 	andseq	r2, r9, r1, lsl #14
 170:	00051c00 	andeq	r1, r5, r0, lsl #24
 174:	00001349 	andeq	r1, r0, r9, asr #6
 178:	0200051d 	andeq	r0, r0, #121634816	; 0x7400000
 17c:	3a0e0318 	bcc	380de4 <__bss_end__+0x35f014>
 180:	490b3b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 184:	1e000010 	mcrne	0, 0, r0, cr0, cr0, {0}
 188:	0111012e 	tsteq	r1, lr, lsr #2
 18c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 190:	0b3a0e03 	bleq	e839a4 <__bss_end__+0xe61bd4>
 194:	19270b3b 	stmdbne	r7!, {r0, r1, r3, r4, r5, r8, r9, fp}
 198:	193f1049 	ldmdbne	pc!, {r0, r3, r6, ip}	; <UNPREDICTABLE>
 19c:	2e1f0000 	cdpcs	0, 1, cr0, cr15, cr0, {0}
 1a0:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 1a4:	03184006 	tsteq	r8, #6
 1a8:	3b0b3a0e 	blcc	2ce9e8 <__bss_end__+0x2acc18>
 1ac:	3f10490b 	svccc	0x0010490b
 1b0:	20000019 	andcs	r0, r0, r9, lsl r0
 1b4:	0111012e 	tsteq	r1, lr, lsr #2
 1b8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1bc:	0b3a0e03 	bleq	e839d0 <__bss_end__+0xe61c00>
 1c0:	13490b3b 	movtne	r0, #39739	; 0x9b3b
 1c4:	0000193f 	andeq	r1, r0, pc, lsr r9
 1c8:	49001621 	stmdbmi	r0, {r0, r5, r9, sl, ip}
 1cc:	3a0e0310 	bcc	380e14 <__bss_end__+0x35f044>
 1d0:	000b3b0b 	andeq	r3, fp, fp, lsl #22
 1d4:	002e2200 	eoreq	r2, lr, r0, lsl #4
 1d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1dc:	0e031840 	cdpeq	8, 0, cr1, cr3, cr0, {2}
 1e0:	0b3b0b3a 	bleq	ec2ed0 <__bss_end__+0xea1100>
 1e4:	193f1927 	ldmdbne	pc!, {r0, r1, r2, r5, r8, fp, ip}	; <UNPREDICTABLE>
 1e8:	0d230000 	stceq	0, cr0, [r3, #-0]
 1ec:	490e0300 	stmdbmi	lr, {r8, r9}
 1f0:	3b0b3a10 	blcc	2cea38 <__bss_end__+0x2acc68>
 1f4:	000b380b 	andeq	r3, fp, fp, lsl #16
 1f8:	00342400 	eorseq	r2, r4, r0, lsl #8
 1fc:	10490e03 	subne	r0, r9, r3, lsl #28
 200:	0b3a193f 	bleq	e86704 <__bss_end__+0xe64934>
 204:	18020b3b 	stmdane	r2, {r0, r1, r3, r4, r5, r8, r9, fp}
 208:	01000000 	mrseq	r0, (UNDEF: 0)
 20c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 210:	01120111 	tsteq	r2, r1, lsl r1
 214:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 218:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 21c:	01000000 	mrseq	r0, (UNDEF: 0)
 220:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 224:	0e030b13 	vmoveq.32	d3[0], r0
 228:	01110e1b 	tsteq	r1, fp, lsl lr
 22c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 230:	24020000 	strcs	r0, [r2], #-0
 234:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 238:	000e030b 	andeq	r0, lr, fp, lsl #6
 23c:	00240300 	eoreq	r0, r4, r0, lsl #6
 240:	0b3e0b0b 	bleq	f82e74 <__bss_end__+0xf610a4>
 244:	00000803 	andeq	r0, r0, r3, lsl #16
 248:	03001604 	movweq	r1, #1540	; 0x604
 24c:	3b0b3a0e 	blcc	2cea8c <__bss_end__+0x2accbc>
 250:	0013490b 	andseq	r4, r3, fp, lsl #18
 254:	000f0500 	andeq	r0, pc, r0, lsl #10
 258:	00000b0b 	andeq	r0, r0, fp, lsl #22
 25c:	0b000f06 	bleq	3e7c <printf@plt-0xc738>
 260:	0013490b 	andseq	r4, r3, fp, lsl #18
 264:	00260700 	eoreq	r0, r6, r0, lsl #14
 268:	00001349 	andeq	r1, r0, r9, asr #6
 26c:	03003408 	movweq	r3, #1032	; 0x408
 270:	3b0b3a0e 	blcc	2ceab0 <__bss_end__+0x2acce0>
 274:	3f134905 	svccc	0x00134905
 278:	00193c19 	andseq	r3, r9, r9, lsl ip
 27c:	00340900 	eorseq	r0, r4, r0, lsl #18
 280:	0b3a0e03 	bleq	e83a94 <__bss_end__+0xe61cc4>
 284:	13490b3b 	movtne	r0, #39739	; 0x9b3b
 288:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 28c:	150a0000 	strne	r0, [sl, #-0]
 290:	00192700 	andseq	r2, r9, r0, lsl #14
 294:	00350b00 	eorseq	r0, r5, r0, lsl #22
 298:	00001349 	andeq	r1, r0, r9, asr #6
 29c:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 2a0:	00130113 	andseq	r0, r3, r3, lsl r1
 2a4:	00210d00 	eoreq	r0, r1, r0, lsl #26
 2a8:	0b2f1349 	bleq	bc4fd4 <__bss_end__+0xba3204>
 2ac:	130e0000 	movwne	r0, #57344	; 0xe000
 2b0:	0b0e0301 	bleq	380ebc <__bss_end__+0x35f0ec>
 2b4:	3b0b3a0b 	blcc	2ceae8 <__bss_end__+0x2acd18>
 2b8:	0013010b 	andseq	r0, r3, fp, lsl #2
 2bc:	000d0f00 	andeq	r0, sp, r0, lsl #30
 2c0:	0b3a0e03 	bleq	e83ad4 <__bss_end__+0xe61d04>
 2c4:	13490b3b 	movtne	r0, #39739	; 0x9b3b
 2c8:	00000b38 	andeq	r0, r0, r8, lsr fp
 2cc:	03000d10 	movweq	r0, #3344	; 0xd10
 2d0:	3b0b3a0e 	blcc	2ceb10 <__bss_end__+0x2acd40>
 2d4:	38134905 	ldmdacc	r3, {r0, r2, r8, fp, lr}
 2d8:	1100000b 	tstne	r0, fp
 2dc:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end__+0xea1200>
 2e4:	13120000 	tstne	r2, #0
 2e8:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 2ec:	13000019 	movwne	r0, #25
 2f0:	00000021 	andeq	r0, r0, r1, lsr #32
 2f4:	27011514 	smladcs	r1, r4, r5, r1
 2f8:	01134919 	tsteq	r3, r9, lsl r9
 2fc:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 300:	13490005 	movtne	r0, #36869	; 0x9005
 304:	15160000 	ldrne	r0, [r6, #-0]
 308:	01192701 	tsteq	r9, r1, lsl #14
 30c:	17000013 	smladne	r0, r3, r0, r0
 310:	00000026 	andeq	r0, r0, r6, lsr #32
 314:	0b011318 	bleq	44f7c <__bss_end__+0x231ac>
 318:	3b0b3a0b 	blcc	2ceb4c <__bss_end__+0x2acd7c>
 31c:	0013010b 	andseq	r0, r3, fp, lsl #2
 320:	000d1900 	andeq	r1, sp, r0, lsl #18
 324:	0b3a0803 	bleq	e82338 <__bss_end__+0xe60568>
 328:	1349053b 	movtne	r0, #38203	; 0x953b
 32c:	00000b38 	andeq	r0, r0, r8, lsr fp
 330:	0300161a 	movweq	r1, #1562	; 0x61a
 334:	3b0b3a0e 	blcc	2ceb74 <__bss_end__+0x2acda4>
 338:	00134905 	andseq	r4, r3, r5, lsl #18
 33c:	01131b00 	tsteq	r3, r0, lsl #22
 340:	0b3a0b0b 	bleq	e82f74 <__bss_end__+0xe611a4>
 344:	1301053b 	movwne	r0, #5435	; 0x153b
 348:	171c0000 	ldrne	r0, [ip, -r0]
 34c:	3a0b0b01 	bcc	2c2f58 <__bss_end__+0x2a1188>
 350:	01053b0b 	tsteq	r5, fp, lsl #22
 354:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 358:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 35c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 360:	00001349 	andeq	r1, r0, r9, asr #6
 364:	0300341e 	movweq	r3, #1054	; 0x41e
 368:	3b0b3a08 	blcc	2ceb90 <__bss_end__+0x2acdc0>
 36c:	3f13490b 	svccc	0x0013490b
 370:	00180219 	andseq	r0, r8, r9, lsl r2
 374:	00341f00 	eorseq	r1, r4, r0, lsl #30
 378:	0b3a0e03 	bleq	e83b8c <__bss_end__+0xe61dbc>
 37c:	13490b3b 	movtne	r0, #39739	; 0x9b3b
 380:	1802193f 	stmdane	r2, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 384:	2e200000 	cdpcs	0, 2, cr0, cr0, cr0, {0}
 388:	03193f01 	tsteq	r9, #1, 30
 38c:	3b0b3a0e 	blcc	2cebcc <__bss_end__+0x2acdfc>
 390:	1119270b 	tstne	r9, fp, lsl #14
 394:	40061201 	andmi	r1, r6, r1, lsl #4
 398:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 39c:	00001301 	andeq	r1, r0, r1, lsl #6
 3a0:	03000521 	movweq	r0, #1313	; 0x521
 3a4:	3b0b3a0e 	blcc	2cebe4 <__bss_end__+0x2ace14>
 3a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 3ac:	22000018 	andcs	r0, r0, #24
 3b0:	08030005 	stmdaeq	r3, {r0, r2}
 3b4:	0b3b0b3a 	bleq	ec30a4 <__bss_end__+0xea12d4>
 3b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3bc:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 3c0:	03193f00 	tsteq	r9, #0, 30
 3c4:	3b0b3a0e 	blcc	2cec04 <__bss_end__+0x2ace34>
 3c8:	1201110b 	andne	r1, r1, #-1073741822	; 0xc0000002
 3cc:	96184006 	ldrls	r4, [r8], -r6
 3d0:	00001942 	andeq	r1, r0, r2, asr #18
 3d4:	3f012e24 	svccc	0x00012e24
 3d8:	3a0e0319 	bcc	381044 <__bss_end__+0x35f274>
 3dc:	270b3b0b 	strcs	r3, [fp, -fp, lsl #22]
 3e0:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
 3e4:	96184006 	ldrls	r4, [r8], -r6
 3e8:	00001942 	andeq	r1, r0, r2, asr #18
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	000005cf 	andeq	r0, r0, pc, asr #11
   4:	003d0002 	eorseq	r0, sp, r2
   8:	01010000 	mrseq	r0, (UNDEF: 1)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
  1c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
  20:	79730000 	ldmdbvc	r3!, {}^	; <UNPREDICTABLE>
  24:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
  28:	6d755065 	ldclvs	0, cr5, [r5, #-404]!	; 0xfffffe6c
  2c:	00632e70 	rsbeq	r2, r3, r0, ror lr
  30:	4c000000 	stcmi	0, cr0, [r0], {-0}
  34:	69757169 	ldmdbvs	r5!, {r0, r3, r5, r6, r8, ip, sp, lr}^
  38:	79724364 	ldmdbvc	r2!, {r2, r5, r6, r8, r9, lr}^
  3c:	6c617473 	cfstrdvs	mvd7, [r1], #-460	; 0xfffffe34
  40:	0100682e 	tsteq	r0, lr, lsr #16
  44:	00000000 	andeq	r0, r0, r0
  48:	08780205 	ldmdaeq	r8!, {r0, r2, r9}^
  4c:	e8030001 	stmda	r3, {r0}
  50:	02050100 	andeq	r0, r5, #0, 2
  54:	3d08840a 	cfstrscc	mvf8, [r8, #-40]	; 0xffffffd8
  58:	f50a0584 			; <UNDEFINED> instruction: 0xf50a0584
  5c:	4a060205 	bmi	180878 <__bss_end__+0x15eaa8>
  60:	054a0a05 	strbeq	r0, [sl, #-2565]	; 0xfffff5fb
  64:	0a054a02 	beq	152874 <__bss_end__+0x130aa4>
  68:	02054b06 	andeq	r4, r5, #6144	; 0x1800
  6c:	0a054a06 	beq	15288c <__bss_end__+0x130abc>
  70:	4a02054a 	bmi	815a0 <__bss_end__+0x5f7d0>
  74:	4b060f05 	blmi	183c90 <__bss_end__+0x161ec0>
  78:	4a060205 	bmi	180894 <__bss_end__+0x15eac4>
  7c:	83060f05 	movwhi	r0, #28421	; 0x6f05
  80:	4a060205 	bmi	18089c <__bss_end__+0x15eacc>
  84:	85060a05 	strhi	r0, [r6, #-2565]	; 0xfffff5fb
  88:	4a060205 	bmi	1808a4 <__bss_end__+0x15ead4>
  8c:	054a0a05 	strbeq	r0, [sl, #-2565]	; 0xfffff5fb
  90:	0a054a02 	beq	1528a0 <__bss_end__+0x130ad0>
  94:	02054b06 	andeq	r4, r5, #6144	; 0x1800
  98:	0a054a06 	beq	1528b8 <__bss_end__+0x130ae8>
  9c:	4a02054a 	bmi	815cc <__bss_end__+0x5f7fc>
  a0:	01055006 	tsteq	r5, r6
  a4:	03000583 	movweq	r0, #1411	; 0x583
  a8:	05ac080b 	streq	r0, [ip, #2059]!	; 0x80b
  ac:	0d030a14 	vstreq	s0, [r3, #-80]	; 0xffffffb0
  b0:	061205ba 			; <UNDEFINED> instruction: 0x061205ba
  b4:	060f054a 	streq	r0, [pc], -sl, asr #10
  b8:	4b11054b 	blmi	4415ec <__bss_end__+0x41f81c>
  bc:	05480a05 	strbeq	r0, [r8, #-2565]	; 0xfffff5fb
  c0:	054a0614 	strbeq	r0, [sl, #-1556]	; 0xfffff9ec
  c4:	0583060f 	streq	r0, [r3, #1551]	; 0x60f
  c8:	1205bb11 	andne	fp, r5, #17408	; 0x4400
  cc:	060c0548 	streq	r0, [ip], -r8, asr #10
  d0:	4a0a054a 	bmi	281600 <__bss_end__+0x25f830>
  d4:	50061105 	andpl	r1, r6, r5, lsl #2
  d8:	4a060f05 	bmi	183cf4 <__bss_end__+0x161f24>
  dc:	4b060505 	blmi	1814f8 <__bss_end__+0x15f728>
  e0:	03054a06 	movweq	r4, #23046	; 0x5a06
  e4:	0f054d06 	svceq	0x00054d06
  e8:	4b2c054f 	blmi	b0162c <__bss_end__+0xadf85c>
  ec:	4a063b05 	bmi	18ed08 <__bss_end__+0x16cf38>
  f0:	054a0205 	strbeq	r0, [sl, #-517]	; 0xfffffdfb
  f4:	0549060d 	strbeq	r0, [r9, #-1549]	; 0xfffff9f3
  f8:	39054b2c 	stmdbcc	r5, {r2, r3, r5, r8, r9, fp, lr}
  fc:	02054a06 	andeq	r4, r5, #24576	; 0x6000
 100:	0601054a 	streq	r0, [r1], -sl, asr #10
 104:	030005f4 	movweq	r0, #1524	; 0x5f4
 108:	01240228 			; <UNDEFINED> instruction: 0x01240228
 10c:	bc0a0505 	cfstr32lt	mvfx0, [sl], {5}
 110:	03058206 	movweq	r8, #20998	; 0x5206
 114:	0a058306 	beq	160d34 <__bss_end__+0x13ef64>
 118:	054a0685 	strbeq	r0, [sl, #-1669]	; 0xfffff97b
 11c:	46830603 	strmi	r0, [r3], r3, lsl #12
 120:	0311054b 	tsteq	r1, #314572800	; 0x12c00000
 124:	0f054a10 	svceq	0x00054a10
 128:	8111054b 	tsthi	r1, fp, asr #10
 12c:	054b0f05 	strbeq	r0, [fp, #-3845]	; 0xfffff0fb
 130:	1c054b01 			; <UNDEFINED> instruction: 0x1c054b01
 134:	05827403 	streq	r7, [r2, #1027]	; 0x403
 138:	054a060a 	strbeq	r0, [sl, #-1546]	; 0xfffff9f6
 13c:	0a054a1c 	beq	1529b4 <__bss_end__+0x130be4>
 140:	11054a4a 	tstne	r5, sl, asr #20
 144:	23058306 	movwcs	r8, #21254	; 0x5306
 148:	11054a06 	tstne	r5, r6, lsl #20
 14c:	060d054a 	streq	r0, [sp], -sl, asr #10
 150:	061c054b 	ldreq	r0, [ip], -fp, asr #10
 154:	4a0b054a 	bmi	2c1684 <__bss_end__+0x29f8b4>
 158:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 15c:	05490607 	strbeq	r0, [r9, #-1543]	; 0xfffff9f9
 160:	1c054b0d 			; <UNDEFINED> instruction: 0x1c054b0d
 164:	0d054a06 	vstreq	s8, [r5, #-24]	; 0xffffffe8
 168:	4a0b054a 	bmi	2c1698 <__bss_end__+0x29f8c8>
 16c:	86060305 	strhi	r0, [r6], -r5, lsl #6
 170:	061b05bb 			; <UNDEFINED> instruction: 0x061b05bb
 174:	4a03054a 	bmi	c16a4 <__bss_end__+0x9f8d4>
 178:	00054b06 	andeq	r4, r5, r6, lsl #22
 17c:	05183402 	ldreq	r3, [r8, #-1026]	; 0xfffffbfe
 180:	05be0a1a 	ldreq	r0, [lr, #2586]!	; 0xa1a
 184:	05820610 	streq	r0, [r2, #1552]	; 0x610
 188:	10054a1a 	andne	r4, r5, sl, lsl sl
 18c:	4a180582 	bmi	60179c <__bss_end__+0x5df9cc>
 190:	054a0705 	strbeq	r0, [sl, #-1797]	; 0xfffff8fb
 194:	064b0605 	strbeq	r0, [fp], -r5, lsl #12
 198:	0607054a 	streq	r0, [r7], -sl, asr #10
 19c:	890a0549 	stmdbhi	sl, {r0, r3, r6, r8, sl}
 1a0:	03054a06 	movweq	r4, #23046	; 0x5a06
 1a4:	10058306 	andne	r8, r5, r6, lsl #6
 1a8:	0603054b 	streq	r0, [r3], -fp, asr #10
 1ac:	4a10054a 	bmi	4016dc <__bss_end__+0x3df90c>
 1b0:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 1b4:	054b0607 	strbeq	r0, [fp, #-1543]	; 0xfffff9f9
 1b8:	054a060e 	strbeq	r0, [sl, #-1550]	; 0xfffff9f2
 1bc:	0d054a07 	vstreq	s8, [r5, #-28]	; 0xffffffe4
 1c0:	4a06054a 	bmi	1816f0 <__bss_end__+0x15f920>
 1c4:	bb060e05 	bllt	1839e0 <__bss_end__+0x161c10>
 1c8:	4a060b05 	bmi	182de4 <__bss_end__+0x161014>
 1cc:	03060305 	movweq	r0, #25349	; 0x6305
 1d0:	1005f277 	andne	pc, r5, r7, ror r2	; <UNPREDICTABLE>
 1d4:	0603054b 	streq	r0, [r3], -fp, asr #10
 1d8:	4a10054a 	bmi	401708 <__bss_end__+0x3df938>
 1dc:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 1e0:	054b0615 	strbeq	r0, [fp, #-1557]	; 0xfffff9eb
 1e4:	15054b0a 	strne	r4, [r5, #-2826]	; 0xfffff4f6
 1e8:	060b0549 	streq	r0, [fp], -r9, asr #10
 1ec:	4a13054a 	bmi	4c171c <__bss_end__+0x49f94c>
 1f0:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 1f4:	054b060a 	strbeq	r0, [fp, #-1546]	; 0xfffff9f6
 1f8:	0d054909 	vstreq.16	s8, [r5, #-18]	; 0xffffffee	; <UNPREDICTABLE>
 1fc:	060a054b 	streq	r0, [sl], -fp, asr #10
 200:	060b054a 	streq	r0, [fp], -sl, asr #10
 204:	05ba0903 	ldreq	r0, [sl, #2307]!	; 0x903
 208:	08058910 	stmdaeq	r5, {r4, r8, fp, pc}
 20c:	f40b0547 	vst3.16	{d0,d2,d4}, [fp], r7
 210:	05831005 	streq	r1, [r3, #5]
 214:	054a0603 	strbeq	r0, [sl, #-1539]	; 0xfffff9fd
 218:	05830615 	streq	r0, [r3, #1557]	; 0x615
 21c:	054a0603 	strbeq	r0, [sl, #-1539]	; 0xfffff9fd
 220:	054c0610 	strbeq	r0, [ip, #-1552]	; 0xfffff9f0
 224:	054a0603 	strbeq	r0, [sl, #-1539]	; 0xfffff9fd
 228:	05830615 	streq	r0, [r3, #1557]	; 0x615
 22c:	054a0603 	strbeq	r0, [sl, #-1539]	; 0xfffff9fd
 230:	0402001c 	streq	r0, [r2], #-28	; 0xffffffe4
 234:	05450602 	strbeq	r0, [r5, #-1538]	; 0xfffff9fe
 238:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 23c:	05ba0601 	ldreq	r0, [sl, #1537]!	; 0x601
 240:	04020010 	streq	r0, [r2], #-16
 244:	02054a01 	andeq	r4, r5, #4096	; 0x1000
 248:	01040200 	mrseq	r0, R12_usr
 24c:	0601054a 	streq	r0, [r1], -sl, asr #10
 250:	0300058a 	movweq	r0, #1418	; 0x58a
 254:	e40800da 	str	r0, [r8], #-218	; 0xffffff26
 258:	f90a0505 			; <UNDEFINED> instruction: 0xf90a0505
 25c:	4b7f0605 	blmi	1fc1a78 <__bss_end__+0x1f9fca8>
 260:	064c0505 	strbeq	r0, [ip], -r5, lsl #10
 264:	060a054a 	streq	r0, [sl], -sl, asr #10
 268:	054a0686 	strbeq	r0, [sl, #-1670]	; 0xfffff97a
 26c:	0583060b 	streq	r0, [r3, #1547]	; 0x60b
 270:	0905bb25 	stmdbeq	r5, {r0, r2, r5, r8, r9, fp, ip, sp, pc}
 274:	4b320549 	blmi	c817a0 <__bss_end__+0xc5f9d0>
 278:	4a062505 	bmi	189694 <__bss_end__+0x1678c4>
 27c:	054a3205 	strbeq	r3, [sl, #-517]	; 0xfffffdfb
 280:	32054a0b 	andcc	r4, r5, #45056	; 0xb000
 284:	4a20054a 	bmi	8017b4 <__bss_end__+0x7df9e4>
 288:	054a3205 	strbeq	r3, [sl, #-517]	; 0xfffffdfb
 28c:	32054a20 	andcc	r4, r5, #32, 20	; 0x20000
 290:	062d054a 	strteq	r0, [sp], -sl, asr #10
 294:	063505ed 	ldrteq	r0, [r5], -sp, ror #11
 298:	822d054a 	eorhi	r0, sp, #310378496	; 0x12800000
 29c:	054a0b05 	strbeq	r0, [sl, #-2821]	; 0xfffff4fb
 2a0:	28058235 	stmdacs	r5, {r0, r2, r4, r5, r9, pc}
 2a4:	4a35054a 	bmi	d417d4 <__bss_end__+0xd1fa04>
 2a8:	054a2805 	strbeq	r2, [sl, #-2053]	; 0xfffff7fb
 2ac:	0b054a35 	bleq	152b88 <__bss_end__+0x130db8>
 2b0:	2e057408 	cdpcs	4, 0, cr7, cr5, cr8, {0}
 2b4:	09054b06 	stmdbeq	r5, {r1, r2, r8, r9, fp, lr}
 2b8:	4b2e0549 	blmi	b817e4 <__bss_end__+0xb5fa14>
 2bc:	4a060b05 	bmi	182ed8 <__bss_end__+0x161108>
 2c0:	054a3705 	strbeq	r3, [sl, #-1797]	; 0xfffff8fb
 2c4:	37054a29 	strcc	r4, [r5, -r9, lsr #20]
 2c8:	4a29054a 	bmi	a417f8 <__bss_end__+0xa1fa28>
 2cc:	054a3705 	strbeq	r3, [sl, #-1797]	; 0xfffff8fb
 2d0:	40080632 	andmi	r0, r8, r2, lsr r6
 2d4:	82060b05 	andhi	r0, r6, #5120	; 0x1400
 2d8:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 2dc:	bc4e0602 	mcrrlt	6, 0, r0, lr, cr2
 2e0:	05f31605 	ldrbeq	r1, [r3, #1541]!	; 0x605
 2e4:	06820602 	streq	r0, [r2], r2, lsl #12
 2e8:	f3160584 	vrshl.u16	d0, d4, d22
 2ec:	82060205 	andhi	r0, r6, #1342177280	; 0x50000000
 2f0:	83060105 	movwhi	r0, #24837	; 0x6105
 2f4:	b0030005 	andlt	r0, r3, r5
 2f8:	0144027e 	hvceq	16430	; 0x402e
 2fc:	bc0a2505 	cfstr32lt	mvfx2, [sl], {5}
 300:	82061905 	andhi	r1, r6, #81920	; 0x14000
 304:	054a0605 	strbeq	r0, [sl, #-1541]	; 0xfffff9fb
 308:	054b061e 	strbeq	r0, [fp, #-1566]	; 0xfffff9e2
 30c:	04020021 	streq	r0, [r2], #-33	; 0xffffffdf
 310:	05820601 	streq	r0, [r2, #1537]	; 0x601
 314:	04020005 	streq	r0, [r2], #-5
 318:	03058201 	movweq	r8, #20993	; 0x5201
 31c:	05838306 	streq	r8, [r3, #774]	; 0x306
 320:	0e054f24 	cdpeq	15, 0, cr4, cr5, cr4, {1}
 324:	06100547 	ldreq	r0, [r0], -r7, asr #10
 328:	0624054a 	strteq	r0, [r4], -sl, asr #10
 32c:	470e054d 	strmi	r0, [lr, -sp, asr #10]
 330:	054d1805 	strbeq	r1, [sp, #-2053]	; 0xfffff7fb
 334:	054a0606 	strbeq	r0, [sl, #-1542]	; 0xfffff9fa
 338:	054b061d 	strbeq	r0, [fp, #-1565]	; 0xfffff9e3
 33c:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 340:	05820601 	streq	r0, [r2, #1537]	; 0x601
 344:	04020005 	streq	r0, [r2], #-5
 348:	0d058201 	sfmeq	f0, 1, [r5, #-4]
 34c:	17058506 	strne	r8, [r5, -r6, lsl #10]
 350:	4b0d0549 	blmi	34187c <__bss_end__+0x31faac>
 354:	05491705 	strbeq	r1, [r9, #-1797]	; 0xfffff8fb
 358:	03054b0b 	movweq	r4, #23307	; 0x5b0b
 35c:	4809054b 	stmdami	r9, {r0, r1, r3, r6, r8, sl}
 360:	054c0305 	strbeq	r0, [ip, #-773]	; 0xfffffcfb
 364:	0b054b0d 	bleq	152fa0 <__bss_end__+0x1311d0>
 368:	03054a06 	movweq	r4, #23046	; 0x5a06
 36c:	11054c06 	tstne	r5, r6, lsl #24
 370:	0613054c 	ldreq	r0, [r3], -ip, asr #10
 374:	4a11054a 	bmi	4418a4 <__bss_end__+0x41fad4>
 378:	4b060105 	blmi	180794 <__bss_end__+0x15e9c4>
 37c:	e6080005 	str	r0, [r8], -r5
 380:	c00a1305 	andgt	r1, sl, r5, lsl #6
 384:	054d0e05 	strbeq	r0, [sp, #-3589]	; 0xfffff1fb
 388:	054a0604 	strbeq	r0, [sl, #-1540]	; 0xfffff9fc
 38c:	05470613 	strbeq	r0, [r7, #-1555]	; 0xfffff9ed
 390:	1e05850e 	cfsh32ne	mvfx8, mvfx5, #14
 394:	1c054a06 			; <UNDEFINED> instruction: 0x1c054a06
 398:	0610054a 	ldreq	r0, [r0], -sl, asr #10
 39c:	0009054b 	andeq	r0, r9, fp, asr #10
 3a0:	03010402 	movweq	r0, #5122	; 0x1402
 3a4:	0205ba79 	andeq	fp, r5, #495616	; 0x79000
 3a8:	01040200 	mrseq	r0, R12_usr
 3ac:	17054a06 	strne	r4, [r5, -r6, lsl #20]
 3b0:	08058306 	stmdaeq	r5, {r1, r2, r8, r9, pc}
 3b4:	07054a06 	streq	r4, [r5, -r6, lsl #20]
 3b8:	4a064b06 	bmi	192fd8 <__bss_end__+0x171208>
 3bc:	83061305 	movwhi	r1, #25349	; 0x6305
 3c0:	05890105 	streq	r0, [r9, #261]	; 0x105
 3c4:	083c0300 	ldmdaeq	ip!, {r8, r9}
 3c8:	0a0f053c 	beq	3c18c0 <__bss_end__+0x39faf0>
 3cc:	060d05c0 	streq	r0, [sp], -r0, asr #11
 3d0:	060805ba 			; <UNDEFINED> instruction: 0x060805ba
 3d4:	06060583 	streq	r0, [r6], -r3, lsl #11
 3d8:	0615054a 	ldreq	r0, [r5], -sl, asr #10
 3dc:	4b290584 	blmi	a419f4 <__bss_end__+0xa1fc24>
 3e0:	054d0605 	strbeq	r0, [sp, #-1541]	; 0xfffff9fb
 3e4:	0a054607 	beq	151c08 <__bss_end__+0x12fe38>
 3e8:	4829054d 	stmdami	r9!, {r0, r2, r3, r6, r8, sl}
 3ec:	4a062805 	bmi	18a408 <__bss_end__+0x168638>
 3f0:	054a0705 	strbeq	r0, [sl, #-1797]	; 0xfffff8fb
 3f4:	054d0611 	strbeq	r0, [sp, #-1553]	; 0xfffff9ef
 3f8:	054a0606 	strbeq	r0, [sl, #-1542]	; 0xfffff9fa
 3fc:	2d054a15 	vstrcs	s8, [r5, #-84]	; 0xffffffac
 400:	01040200 	mrseq	r0, R12_usr
 404:	00180582 	andseq	r0, r8, r2, lsl #11
 408:	4a010402 	bmi	41418 <__bss_end__+0x1f648>
 40c:	02002d05 	andeq	r2, r0, #320	; 0x140
 410:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 414:	04020006 	streq	r0, [r2], #-6
 418:	12054a01 	andne	r4, r5, #4096	; 0x1000
 41c:	05054b06 	streq	r4, [r5, #-2822]	; 0xfffff4fa
 420:	06190584 	ldreq	r0, [r9], -r4, lsl #11
 424:	0031054a 	eorseq	r0, r1, sl, asr #10
 428:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
 42c:	02001c05 	andeq	r1, r0, #1280	; 0x500
 430:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 434:	04020031 	streq	r0, [r2], #-49	; 0xffffffcf
 438:	05054a01 	streq	r4, [r5, #-2561]	; 0xfffff5ff
 43c:	01040200 	mrseq	r0, R12_usr
 440:	0612054a 	ldreq	r0, [r2], -sl, asr #10
 444:	8405054b 	strhi	r0, [r5], #-1355	; 0xfffffab5
 448:	12054a06 	andne	r4, r5, #24576	; 0x6000
 44c:	0c054b06 			; <UNDEFINED> instruction: 0x0c054b06
 450:	060a0585 	streq	r0, [sl], -r5, lsl #11
 454:	0605054a 	streq	r0, [r5], -sl, asr #10
 458:	054a064c 	strbeq	r0, [sl, #-1612]	; 0xfffff9b4
 45c:	0583060f 	streq	r0, [r3, #1551]	; 0x60f
 460:	054a0603 	strbeq	r0, [sl, #-1539]	; 0xfffff9fd
 464:	054b0615 	strbeq	r0, [fp, #-1557]	; 0xfffff9eb
 468:	054a0613 	strbeq	r0, [sl, #-1555]	; 0xfffff9ed
 46c:	054c0601 	strbeq	r0, [ip, #-1537]	; 0xfffff9ff
 470:	00d70300 	sbcseq	r0, r7, r0, lsl #6
 474:	0905e408 	stmdbeq	r5, {r3, sl, sp, lr, pc}
 478:	1205bc0a 	andne	fp, r5, #2560	; 0xa00
 47c:	01040200 	mrseq	r0, R12_usr
 480:	1d054a06 	vstrne	s8, [r5, #-24]	; 0xffffffe8
 484:	02004b06 	andeq	r4, r0, #6144	; 0x1800
 488:	05810204 	streq	r0, [r1, #516]	; 0x204
 48c:	0402000e 	streq	r0, [r2], #-14
 490:	05ba0601 	ldreq	r0, [sl, #1537]!	; 0x601
 494:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 498:	02054a01 	andeq	r4, r5, #4096	; 0x1000
 49c:	01040200 	mrseq	r0, R12_usr
 4a0:	0629054a 	strteq	r0, [r9], -sl, asr #10
 4a4:	06070583 	streq	r0, [r7], -r3, lsl #11
 4a8:	4a1d054a 	bmi	7419d8 <__bss_end__+0x71fc08>
 4ac:	054a0705 	strbeq	r0, [sl, #-1797]	; 0xfffff8fb
 4b0:	05be0606 	ldreq	r0, [lr, #1542]!	; 0x606
 4b4:	054a060b 	strbeq	r0, [sl, #-1547]	; 0xfffff9f5
 4b8:	4b064a06 	blmi	192cd8 <__bss_end__+0x170f08>
 4bc:	05840905 	streq	r0, [r4, #2309]	; 0x905
 4c0:	054a0602 	strbeq	r0, [sl, #-1538]	; 0xfffff9fe
 4c4:	054b0601 	strbeq	r0, [fp, #-1537]	; 0xfffff9ff
 4c8:	7fa00300 	svcvc	0x00a00300
 4cc:	05053c08 	streq	r3, [r5, #-3080]	; 0xfffff3f8
 4d0:	0686f30a 	streq	pc, [r6], sl, lsl #6
 4d4:	0606054a 	streq	r0, [r6], -sl, asr #10
 4d8:	05820683 	streq	r0, [r2, #1667]	; 0x683
 4dc:	474e060c 	strbmi	r0, [lr, -ip, lsl #12]
 4e0:	4e05054d 	cfsh32mi	mvfx0, mvfx5, #45
 4e4:	0a058206 	beq	160d04 <__bss_end__+0x13ef34>
 4e8:	82130306 	andshi	r0, r3, #402653184	; 0x18000000
 4ec:	06054a06 	streq	r4, [r5], -r6, lsl #20
 4f0:	4a068906 	bmi	1a2910 <__bss_end__+0x180b40>
 4f4:	83060705 	movwhi	r0, #26373	; 0x6705
 4f8:	13058206 	movwne	r8, #20998	; 0x5206
 4fc:	054b8306 	strbeq	r8, [fp, #-774]	; 0xfffffcfa
 500:	054a0611 	strbeq	r0, [sl, #-1553]	; 0xfffff9ef
 504:	83490613 	movthi	r0, #38419	; 0x9613
 508:	4a061105 	bmi	184924 <__bss_end__+0x162b54>
 50c:	4d060605 	stcmi	6, cr0, [r6, #-20]	; 0xffffffec
 510:	07054a06 	streq	r4, [r5, -r6, lsl #20]
 514:	82068306 	andhi	r8, r6, #402653184	; 0x18000000
 518:	83061405 	movwhi	r1, #25605	; 0x6405
 51c:	054b1305 	strbeq	r1, [fp, #-773]	; 0xfffffcfb
 520:	054a0611 	strbeq	r0, [sl, #-1553]	; 0xfffff9ef
 524:	05490614 	strbeq	r0, [r9, #-1556]	; 0xfffff9ec
 528:	11058313 	tstne	r5, r3, lsl r3
 52c:	06054a06 	streq	r4, [r5], -r6, lsl #20
 530:	825e0306 	subshi	r0, lr, #402653184	; 0x18000000
 534:	04054a06 	streq	r4, [r5], #-2566	; 0xfffff5fa
 538:	06054b06 	streq	r4, [r5], -r6, lsl #22
 53c:	054a0684 	strbeq	r0, [sl, #-1668]	; 0xfffff97c
 540:	05830604 	streq	r0, [r3, #1540]	; 0x604
 544:	4a068406 	bmi	1a1564 <__bss_end__+0x17f794>
 548:	83060f05 	movwhi	r0, #28421	; 0x6f05
 54c:	4a060c05 	bmi	183568 <__bss_end__+0x161798>
 550:	054a0f05 	strbeq	r0, [sl, #-3845]	; 0xfffff0fb
 554:	06054a0c 	streq	r4, [r5], -ip, lsl #20
 558:	4a06bc06 	bmi	1af578 <__bss_end__+0x18d7a8>
 55c:	83061205 	movwhi	r1, #25093	; 0x6205
 560:	4a060805 	bmi	18257c <__bss_end__+0x1607ac>
 564:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
 568:	10054a08 	andne	r4, r5, r8, lsl #20
 56c:	4a07054a 	bmi	1c1a9c <__bss_end__+0x19fccc>
 570:	bb061005 	bllt	18458c <__bss_end__+0x1627bc>
 574:	4a060d05 	bmi	183990 <__bss_end__+0x161bc0>
 578:	0205f506 	andeq	pc, r5, #25165824	; 0x1800000
 57c:	05821903 	streq	r1, [r2, #2307]	; 0x903
 580:	04020001 	streq	r0, [r2], #-1
 584:	00054b01 	andeq	r4, r5, r1, lsl #22
 588:	ac083d03 	stcge	13, cr3, [r8], {3}
 58c:	bb0a0205 	bllt	280da8 <__bss_end__+0x25efd8>
 590:	bf0005f3 	svclt	0x000005f3
 594:	bb0a0205 	bllt	280db0 <__bss_end__+0x25efe0>
 598:	05837508 	streq	r7, [r3, #1288]	; 0x508
 59c:	02054c09 	andeq	r4, r5, #2304	; 0x900
 5a0:	4909054b 	stmdbmi	r9, {r0, r1, r3, r6, r8, sl}
 5a4:	054b0205 	strbeq	r0, [fp, #-517]	; 0xfffffdfb
 5a8:	02054d10 	andeq	r4, r5, #16, 26	; 0x400
 5ac:	b910054b 	ldmdblt	r0, {r0, r1, r3, r6, r8, sl}
 5b0:	054b0205 	strbeq	r0, [fp, #-517]	; 0xfffffdfb
 5b4:	09054c06 	stmdbeq	r5, {r1, r2, sl, fp, lr}
 5b8:	bb0305bc 	bllt	c1cb0 <__bss_end__+0x9fee0>
 5bc:	02000805 	andeq	r0, r0, #327680	; 0x50000
 5c0:	05480104 	strbeq	r0, [r8, #-260]	; 0xfffffefc
 5c4:	04020002 	streq	r0, [r2], #-2
 5c8:	064a0601 	strbeq	r0, [sl], -r1, lsl #12
 5cc:	24028486 	strcs	r8, [r2], #-1158	; 0xfffffb7a
 5d0:	51010100 	mrspl	r0, (UNDEF: 17)
 5d4:	02000001 	andeq	r0, r0, #1
 5d8:	00006200 	andeq	r6, r0, r0, lsl #4
 5dc:	fb010100 	blx	409e6 <__bss_end__+0x1ec16>
 5e0:	01000d0e 	tsteq	r0, lr, lsl #26
 5e4:	00010101 	andeq	r0, r1, r1, lsl #2
 5e8:	00010000 	andeq	r0, r1, r0
 5ec:	6d2f0100 	stfvss	f0, [pc, #-0]	; 5f4 <printf@plt-0xffc0>
 5f0:	61696465 	cmnvs	r9, r5, ror #8
 5f4:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 5f8:	7273752f 	rsbsvc	r7, r3, #197132288	; 0xbc00000
 5fc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 600:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 604:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 608:	6e696c2d 	cdpvs	12, 6, cr6, cr9, cr13, {1}
 60c:	672d7875 			; <UNDEFINED> instruction: 0x672d7875
 610:	6165756e 	cmnvs	r5, lr, ror #10
 614:	66686962 	strbtvs	r6, [r8], -r2, ror #18
 618:	7469622f 	strbtvc	r6, [r9], #-559	; 0xfffffdd1
 61c:	75000073 	strvc	r0, [r0, #-115]	; 0xffffff8d
 620:	2e6c6974 			; <UNDEFINED> instruction: 0x2e6c6974
 624:	00000063 	andeq	r0, r0, r3, rrx
 628:	70797400 	rsbsvc	r7, r9, r0, lsl #8
 62c:	682e7365 	stmdavs	lr!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
 630:	00000100 	andeq	r0, r0, r0, lsl #2
 634:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 638:	0100682e 	tsteq	r0, lr, lsr #16
 63c:	00000000 	andeq	r0, r0, r0
 640:	131c0205 	tstne	ip, #1342177280	; 0x50000000
 644:	05190001 	ldreq	r0, [r9, #-1]
 648:	05f30a02 	ldrbeq	r0, [r3, #2562]!	; 0xa02
 64c:	05ba0639 	ldreq	r0, [sl, #1593]!	; 0x639
 650:	bb064a02 	bllt	192e60 <__bss_end__+0x171090>
 654:	05f50005 	ldrbeq	r0, [r5, #5]!
 658:	f3f40a02 	vtbl.8	d16, {d4-d6}, d2
 65c:	05bb0905 	ldreq	r0, [fp, #2309]!	; 0x905
 660:	054a0602 	strbeq	r0, [sl, #-1538]	; 0xfffff9fe
 664:	3f080600 	svccc	0x00080600
 668:	bc0a0205 	sfmlt	f0, 4, [sl], {5}
 66c:	05850005 	streq	r0, [r5, #5]
 670:	f3f30a02 	vtbl.8	d16, {d3-d5}, d2
 674:	05f50005 	ldrbeq	r0, [r5, #5]!
 678:	05bd0a06 	ldreq	r0, [sp, #2566]!	; 0xa06
 67c:	054a0604 	strbeq	r0, [sl, #-1540]	; 0xfffff9fc
 680:	054c0602 	strbeq	r0, [ip, #-1538]	; 0xfffff9fe
 684:	05820622 	streq	r0, [r2, #1570]	; 0x622
 688:	06054a02 	streq	r4, [r5], -r2, lsl #20
 68c:	4a068406 	bmi	1a16ac <__bss_end__+0x17f8dc>
 690:	4d060305 	stcmi	3, cr0, [r6, #-20]	; 0xffffffec
 694:	01054c48 	tsteq	r5, r8, asr #24
 698:	0800054b 	stmdaeq	r0, {r0, r1, r3, r6, r8, sl}
 69c:	0a06053e 	beq	181b9c <__bss_end__+0x15fdcc>
 6a0:	060405bd 			; <UNDEFINED> instruction: 0x060405bd
 6a4:	0609054a 	streq	r0, [r9], -sl, asr #10
 6a8:	0602054c 	streq	r0, [r2], -ip, asr #10
 6ac:	0600054a 	streq	r0, [r0], -sl, asr #10
 6b0:	0a020585 	beq	81ccc <__bss_end__+0x5fefc>
 6b4:	063d05f3 			; <UNDEFINED> instruction: 0x063d05f3
 6b8:	4a0205ba 	bmi	81da8 <__bss_end__+0x5ffd8>
 6bc:	0005bb06 	andeq	fp, r5, r6, lsl #22
 6c0:	02053f08 	andeq	r3, r5, #8, 30
 6c4:	05bbf40a 	ldreq	pc, [fp, #1034]!	; 0x40a
 6c8:	0205bb09 	andeq	fp, r5, #9216	; 0x2400
 6cc:	00054a06 	andeq	r4, r5, r6, lsl #20
 6d0:	0205f506 	andeq	pc, r5, #25165824	; 0x1800000
 6d4:	2c05f50a 	cfstr32cs	mvfx15, [r5], {10}
 6d8:	060f0584 	streq	r0, [pc], -r4, lsl #11
 6dc:	4a2c054a 	bmi	b01c0c <__bss_end__+0xadfe3c>
 6e0:	05ba1605 	ldreq	r1, [sl, #1541]!	; 0x605
 6e4:	02054a1d 	andeq	r4, r5, #118784	; 0x1d000
 6e8:	0600054a 	streq	r0, [r0], -sl, asr #10
 6ec:	0a0205be 	beq	81dec <__bss_end__+0x6001c>
 6f0:	841d05f5 	ldrhi	r0, [sp], #-1525	; 0xfffffa0b
 6f4:	4a060f05 	bmi	184310 <__bss_end__+0x162540>
 6f8:	054a1d05 	strbeq	r1, [sl, #-3333]	; 0xfffff2fb
 6fc:	02054a24 	andeq	r4, r5, #36, 20	; 0x24000
 700:	0600054a 	streq	r0, [r0], -sl, asr #10
 704:	0a090586 	beq	241d24 <__bss_end__+0x21ff54>
 708:	060205f3 			; <UNDEFINED> instruction: 0x060205f3
 70c:	06010582 	streq	r0, [r1], -r2, lsl #11
 710:	8400054b 	strhi	r0, [r0], #-1355	; 0xfffffab5
 714:	f40a0d05 			; <UNDEFINED> instruction: 0xf40a0d05
 718:	82060805 	andhi	r0, r6, #327680	; 0x50000
 71c:	054a0605 	strbeq	r0, [sl, #-1541]	; 0xfffff9fb
 720:	024b0602 	subeq	r0, fp, #2097152	; 0x200000
 724:	01010008 	tsteq	r1, r8
 728:	00000045 	andeq	r0, r0, r5, asr #32
 72c:	001c0002 	andseq	r0, ip, r2
 730:	01010000 	mrseq	r0, (UNDEF: 1)
 734:	000d0efb 	strdeq	r0, [sp], -fp
 738:	01010101 	tsteq	r1, r1, lsl #2
 73c:	01000000 	mrseq	r0, (UNDEF: 0)
 740:	00010000 	andeq	r0, r1, r0
 744:	2e64656c 	cdpcs	5, 6, cr6, cr4, cr12, {3}
 748:	00000063 	andeq	r0, r0, r3, rrx
 74c:	05000000 	streq	r0, [r0, #-0]
 750:	01159c02 	tsteq	r5, r2, lsl #24
 754:	0e051800 	cdpeq	8, 0, cr1, cr5, cr0, {0}
 758:	0205830a 	andeq	r8, r5, #671088640	; 0x28000000
 75c:	810e054b 	tsthi	lr, fp, asr #10
 760:	4bbb0205 	blmi	feec0f7c <__bss_end__+0xfee9f1ac>
 764:	05f50005 	ldrbeq	r0, [r5, #5]!
 768:	bb830a02 	bllt	fe0c2f78 <__bss_end__+0xfe0a11a8>
 76c:	01000c02 	tsteq	r0, r2, lsl #24
 770:	0000a001 	andeq	sl, r0, r1
 774:	3f000200 	svccc	0x00000200
 778:	01000000 	mrseq	r0, (UNDEF: 0)
 77c:	0d0efb01 	vstreq	d15, [lr, #-4]
 780:	01010100 	mrseq	r0, (UNDEF: 17)
 784:	00000001 	andeq	r0, r0, r1
 788:	01000001 	tsteq	r0, r1
 78c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 790:	4c000062 	stcmi	0, cr0, [r0], {98}	; 0x62
 794:	69757169 	ldmdbvs	r5!, {r0, r3, r5, r6, r8, ip, sp, lr}^
 798:	79724364 	ldmdbvc	r2!, {r2, r5, r6, r8, r9, lr}^
 79c:	6c617473 	cfstrdvs	mvd7, [r1], #-460	; 0xfffffe34
 7a0:	0000632e 	andeq	r6, r0, lr, lsr #6
 7a4:	694c0000 	stmdbvs	ip, {}^	; <UNPREDICTABLE>
 7a8:	64697571 	strbtvs	r7, [r9], #-1393	; 0xfffffa8f
 7ac:	73797243 	cmnvc	r9, #805306372	; 0x30000004
 7b0:	2e6c6174 	mcrcs	1, 3, r6, cr12, cr4, {3}
 7b4:	00010068 	andeq	r0, r1, r8, rrx
 7b8:	05000000 	streq	r0, [r0, #-0]
 7bc:	01068402 	tsteq	r6, r2, lsl #8
 7c0:	0e051700 	cdpeq	7, 0, cr1, cr5, cr0, {0}
 7c4:	0205bc0a 	andeq	fp, r5, #2560	; 0xa00
 7c8:	68053e08 	stmdavs	r5, {r3, r9, sl, fp, ip, sp}
 7cc:	0e054a06 	vmlaeq.f32	s8, s10, s12
 7d0:	6d054806 	stcvs	8, cr4, [r5, #-24]	; 0xffffffe8
 7d4:	06020584 	streq	r0, [r2], -r4, lsl #11
 7d8:	4a73054a 	bmi	1cc1d08 <__bss_end__+0x1c9ff38>
 7dc:	064a0205 	strbeq	r0, [sl], -r5, lsl #4
 7e0:	08000583 	stmdaeq	r0, {r0, r1, r7, r8, sl}
 7e4:	0a02053f 	beq	81ce8 <__bss_end__+0x5ff18>
 7e8:	053d08bb 	ldreq	r0, [sp, #-2235]!	; 0xfffff745
 7ec:	0205f500 	andeq	pc, r5, #0, 10
 7f0:	053d080a 	ldreq	r0, [sp, #-2058]!	; 0xfffff7f6
 7f4:	054a0659 	strbeq	r0, [sl, #-1625]	; 0xfffff9a7
 7f8:	02054a5e 	andeq	r4, r5, #385024	; 0x5e000
 7fc:	7508064a 	strvc	r0, [r8, #-1610]	; 0xfffff9b6
 800:	05f50005 	ldrbeq	r0, [r5, #5]!
 804:	05bb0a02 	ldreq	r0, [fp, #2562]!	; 0xa02
 808:	05f2064f 	ldrbeq	r0, [r2, #1615]!	; 0x64f
 80c:	f3068202 	vhsub.u8	d8, d6, d2
 810:	01001002 	tsteq	r0, r2
 814:	00007501 	andeq	r7, r0, r1, lsl #10
 818:	54000200 	strpl	r0, [r0], #-512	; 0xfffffe00
 81c:	01000000 	mrseq	r0, (UNDEF: 0)
 820:	0d0efb01 	vstreq	d15, [lr, #-4]
 824:	01010100 	mrseq	r0, (UNDEF: 17)
 828:	00000001 	andeq	r0, r0, r1
 82c:	01000001 	tsteq	r0, r1
 830:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 77c <printf@plt-0xfe38>
 834:	736f2f65 	cmnvc	pc, #404	; 0x194
 838:	65786f62 	ldrbvs	r6, [r8, #-3938]!	; 0xfffff09e
 83c:	65442f73 	strbvs	r2, [r4, #-3955]	; 0xfffff08d
 840:	6f746b73 	svcvs	0x00746b73
 844:	6f632f70 	svcvs	0x00632f70
 848:	7474616e 	ldrbtvc	r6, [r4], #-366	; 0xfffffe92
 84c:	2f747365 	svccs	0x00747365
 850:	6d617274 	sfmvs	f7, 2, [r1, #-464]!	; 0xfffffe30
 854:	696c6f70 	stmdbvs	ip!, {r4, r5, r6, r8, r9, sl, fp, sp, lr}^
 858:	6c5f656e 	cfldr64vs	mvdx6, [pc], {110}	; 0x6e
 85c:	00006269 	andeq	r6, r0, r9, ror #4
 860:	5f746369 	svcpl	0x00746369
 864:	63656863 	cmnvs	r5, #6488064	; 0x630000
 868:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
 86c:	0100632e 	tsteq	r0, lr, lsr #6
 870:	00000000 	andeq	r0, r0, r0
 874:	12ac0205 	adcne	r0, ip, #1342177280	; 0x50000000
 878:	05180001 	ldreq	r0, [r8, #-1]
 87c:	05860a02 	streq	r0, [r6, #2562]	; 0xa02
 880:	0205bd00 	andeq	fp, r5, #0, 26
 884:	0105830a 	tsteq	r5, sl, lsl #6
 888:	00080284 	andeq	r0, r8, r4, lsl #5
 88c:	005d0101 	subseq	r0, sp, r1, lsl #2
 890:	00030000 	andeq	r0, r3, r0
 894:	00000023 	andeq	r0, r0, r3, lsr #32
 898:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 89c:	0101000d 	tsteq	r1, sp
 8a0:	00000101 	andeq	r0, r0, r1, lsl #2
 8a4:	00000100 	andeq	r0, r0, r0, lsl #2
 8a8:	72740001 	rsbsvc	r0, r4, #1
 8ac:	6f706d61 	svcvs	0x00706d61
 8b0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
 8b4:	0000532e 	andeq	r5, r0, lr, lsr #6
 8b8:	00000000 	andeq	r0, r0, r0
 8bc:	18540205 	ldmdane	r4, {r0, r2, r9}^
 8c0:	0a030001 	beq	c08cc <__bss_end__+0x9eafc>
 8c4:	2f2f2f01 	svccs	0x002f2f01
 8c8:	2f2f2f2f 	svccs	0x002f2f2f
 8cc:	2f2f2f2f 	svccs	0x002f2f2f
 8d0:	2f2f2f2f 	svccs	0x002f2f2f
 8d4:	2f2f2f2f 	svccs	0x002f2f2f
 8d8:	2f2f2f2f 	svccs	0x002f2f2f
 8dc:	2f2f2f2f 	svccs	0x002f2f2f
 8e0:	2f2f2f2f 	svccs	0x002f2f2f
 8e4:	2f2f2f2f 	svccs	0x002f2f2f
 8e8:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 8ec:	41010100 	mrsmi	r0, (UNDEF: 17)
 8f0:	02000002 	andeq	r0, r0, #2
 8f4:	00020100 	andeq	r0, r2, r0, lsl #2
 8f8:	fb010200 	blx	41102 <__bss_end__+0x1f332>
 8fc:	01000d0e 	tsteq	r0, lr, lsl #26
 900:	00010101 	andeq	r0, r1, r1, lsl #2
 904:	00010000 	andeq	r0, r1, r0
 908:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 90c:	2f656d6f 	svccs	0x00656d6f
 910:	6f62736f 	svcvs	0x0062736f
 914:	2f736578 	svccs	0x00736578
 918:	65766564 	ldrbvs	r6, [r6, #-1380]!	; 0xfffffa9c
 91c:	706f2f6c 	rsbvc	r2, pc, ip, ror #30
 920:	2f656574 	svccs	0x00656574
 924:	6c6f6f74 	stclvs	15, cr6, [pc], #-464	; 75c <printf@plt-0xfe58>
 928:	69616863 	stmdbvs	r1!, {r0, r1, r5, r6, fp, sp, lr}^
 92c:	612f736e 			; <UNDEFINED> instruction: 0x612f736e
 930:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
 934:	612f3233 			; <UNDEFINED> instruction: 0x612f3233
 938:	6c2d6d72 	stcvs	13, cr6, [sp], #-456	; 0xfffffe38
 93c:	78756e69 	ldmdavc	r5!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 940:	756e672d 	strbvc	r6, [lr, #-1837]!	; 0xfffff8d3
 944:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
 948:	6c2f6668 	stcvs	6, cr6, [pc], #-416	; 7b0 <printf@plt-0xfe04>
 94c:	2f636269 	svccs	0x00636269
 950:	2f727375 	svccs	0x00727375
 954:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 958:	2f656475 	svccs	0x00656475
 95c:	73746962 	cmnvc	r4, #1605632	; 0x188000
 960:	6f682f00 	svcvs	0x00682f00
 964:	6f2f656d 	svcvs	0x002f656d
 968:	786f6273 	stmdavc	pc!, {r0, r1, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
 96c:	642f7365 	strtvs	r7, [pc], #-869	; 974 <printf@plt-0xfc40>
 970:	6c657665 	stclvs	6, cr7, [r5], #-404	; 0xfffffe6c
 974:	74706f2f 	ldrbtvc	r6, [r0], #-3887	; 0xfffff0d1
 978:	742f6565 	strtvc	r6, [pc], #-1381	; 980 <printf@plt-0xfc34>
 97c:	636c6f6f 	cmnvs	ip, #444	; 0x1bc
 980:	6e696168 	powvsez	f6, f1, #0.0
 984:	61612f73 	smcvs	4851	; 0x12f3
 988:	33686372 	cmncc	r8, #-939524095	; 0xc8000001
 98c:	696c2f32 	stmdbvs	ip!, {r1, r4, r5, r8, r9, sl, fp, sp}^
 990:	63672f62 	cmnvs	r7, #392	; 0x188
 994:	72612f63 	rsbvc	r2, r1, #396	; 0x18c
 998:	696c2d6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, sl, fp, sp}^
 99c:	2d78756e 	cfldr64cs	mvdx7, [r8, #-440]!	; 0xfffffe48
 9a0:	65756e67 	ldrbvs	r6, [r5, #-3687]!	; 0xfffff199
 9a4:	68696261 	stmdavs	r9!, {r0, r5, r6, r9, sp, lr}^
 9a8:	2e362f66 	cdpcs	15, 3, cr2, cr6, cr6, {3}
 9ac:	2f312e32 	svccs	0x00312e32
 9b0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 9b4:	00656475 	rsbeq	r6, r5, r5, ror r4
 9b8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 904 <printf@plt-0xfcb0>
 9bc:	736f2f65 	cmnvc	pc, #404	; 0x194
 9c0:	65786f62 	ldrbvs	r6, [r8, #-3938]!	; 0xfffff09e
 9c4:	65642f73 	strbvs	r2, [r4, #-3955]!	; 0xfffff08d
 9c8:	2f6c6576 	svccs	0x006c6576
 9cc:	6574706f 	ldrbvs	r7, [r4, #-111]!	; 0xffffff91
 9d0:	6f742f65 	svcvs	0x00742f65
 9d4:	68636c6f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r6, sl, fp, sp, lr}^
 9d8:	736e6961 	cmnvc	lr, #1589248	; 0x184000
 9dc:	7261612f 	rsbvc	r6, r1, #-1073741813	; 0xc000000b
 9e0:	32336863 	eorscc	r6, r3, #6488064	; 0x630000
 9e4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 9e8:	6e696c2d 	cdpvs	12, 6, cr6, cr9, cr13, {1}
 9ec:	672d7875 			; <UNDEFINED> instruction: 0x672d7875
 9f0:	6165756e 	cmnvs	r5, lr, ror #10
 9f4:	66686962 	strbtvs	r6, [r8], -r2, ror #18
 9f8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 9fc:	73752f63 	cmnvc	r5, #396	; 0x18c
 a00:	6e692f72 	mcrvs	15, 3, r2, cr9, cr2, {3}
 a04:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 a08:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
 a0c:	2f656d6f 	svccs	0x00656d6f
 a10:	6f62736f 	svcvs	0x0062736f
 a14:	2f736578 	svccs	0x00736578
 a18:	6b736544 	blvs	1cd9f30 <__bss_end__+0x1cb8160>
 a1c:	2f706f74 	svccs	0x00706f74
 a20:	70736172 	rsbsvc	r6, r3, r2, ror r1
 a24:	6e616962 	vnmulvs.f16	s13, s2, s5	; <UNPREDICTABLE>
 a28:	6565742d 	strbvs	r7, [r5, #-1069]!	; 0xfffffbd3
 a2c:	74706f2f 	ldrbtvc	r6, [r0], #-3887	; 0xfffff0d1
 a30:	635f6565 	cmpvs	pc, #423624704	; 0x19400000
 a34:	6e65696c 	vnmulvs.f16	s13, s10, s25	; <UNPREDICTABLE>
 a38:	756f2f74 	strbvc	r2, [pc, #-3956]!	; fffffacc <__bss_end__+0xfffddcfc>
 a3c:	78652f74 	stmdavc	r5!, {r2, r4, r5, r6, r8, r9, sl, fp, sp}^
 a40:	74726f70 	ldrbtvc	r6, [r2], #-3952	; 0xfffff090
 a44:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 a48:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 a4c:	61740000 	cmnvs	r4, r0
 a50:	6172745f 	cmnvs	r2, pc, asr r4
 a54:	6c6f706d 	stclvs	0, cr7, [pc], #-436	; 8a8 <printf@plt-0xfd0c>
 a58:	2e656e69 	cdpcs	14, 6, cr6, cr5, cr9, {3}
 a5c:	00000063 	andeq	r0, r0, r3, rrx
 a60:	70797400 	rsbsvc	r7, r9, r0, lsl #8
 a64:	682e7365 	stmdavs	lr!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}
 a68:	00000100 	andeq	r0, r0, r0, lsl #2
 a6c:	64647473 	strbtvs	r7, [r4], #-1139	; 0xfffffb8d
 a70:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 a74:	00000200 	andeq	r0, r0, r0, lsl #4
 a78:	73696e75 	cmnvc	r9, #1872	; 0x750
 a7c:	682e6474 	stmdavs	lr!, {r2, r4, r5, r6, sl, sp, lr}
 a80:	00000300 	andeq	r0, r0, r0, lsl #6
 a84:	6f746567 	svcvs	0x00746567
 a88:	682e7470 	stmdavs	lr!, {r4, r5, r6, sl, ip, sp, lr}
 a8c:	00000300 	andeq	r0, r0, r0, lsl #6
 a90:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
 a94:	682e6c61 	stmdavs	lr!, {r0, r5, r6, sl, fp, sp, lr}
 a98:	00000300 	andeq	r0, r0, r0, lsl #6
 a9c:	6962696c 	stmdbvs	r2!, {r2, r3, r5, r6, r8, fp, sp, lr}^
 aa0:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 aa4:	73000003 	movwvc	r0, #3
 aa8:	6f696474 	svcvs	0x00696474
 aac:	0300682e 	movweq	r6, #2094	; 0x82e
 ab0:	79730000 	ldmdbvc	r3!, {}^	; <UNPREDICTABLE>
 ab4:	72655f73 	rsbvc	r5, r5, #460	; 0x1cc
 ab8:	73696c72 	cmnvc	r9, #29184	; 0x7200
 abc:	00682e74 	rsbeq	r2, r8, r4, ror lr
 ac0:	6d000001 	stcvs	0, cr0, [r0, #-4]
 ac4:	6f6c6c61 	svcvs	0x006c6c61
 ac8:	00682e63 	rsbeq	r2, r8, r3, ror #28
 acc:	73000003 	movwvc	r0, #3
 ad0:	6e696474 	mcrvs	4, 3, r6, cr9, cr4, {3}
 ad4:	00682e74 	rsbeq	r2, r8, r4, ror lr
 ad8:	74000003 	strvc	r0, [r0], #-3
 adc:	635f6565 	cmpvs	pc, #423624704	; 0x19400000
 ae0:	6e65696c 	vnmulvs.f16	s13, s10, s25	; <UNPREDICTABLE>
 ae4:	70615f74 	rsbvc	r5, r1, r4, ror pc
 ae8:	00682e69 	rsbeq	r2, r8, r9, ror #28
 aec:	74000004 	strvc	r0, [r0], #-4
 af0:	2e656d69 	cdpcs	13, 6, cr6, cr5, cr9, {3}
 af4:	00030068 	andeq	r0, r3, r8, rrx
 af8:	05000000 	streq	r0, [r0, #-0]
 afc:	0115f402 	tsteq	r5, r2, lsl #8	; <UNPREDICTABLE>
 b00:	01370300 	teqeq	r7, r0, lsl #6
 b04:	44087a86 	strmi	r7, [r8], #-2694	; 0xfffff57a
 b08:	9f594d84 	svcls	0x00594d84
 b0c:	3e08a559 	cfrshl32cc	mvfx8, mvfx9, sl
 b10:	5e75b159 	mrcpl	1, 3, fp, cr5, cr9, {2}
 b14:	694b4b4b 	stmdbvs	fp, {r0, r1, r3, r6, r8, r9, fp, lr}^
 b18:	550359ca 	strpl	r5, [r3, #-2506]	; 0xfffff636
 b1c:	203703ac 	eorscs	r0, r7, ip, lsr #7
 b20:	7550be08 	ldrbvc	fp, [r0, #-3592]	; 0xfffff1f8
 b24:	59ca695a 	stmibpl	sl, {r1, r3, r4, r6, r8, fp, sp, lr}^
 b28:	6876e6b0 	ldmdavs	r6!, {r4, r5, r7, r9, sl, sp, lr, pc}^
 b2c:	025b685a 	subseq	r6, fp, #5898240	; 0x5a0000
 b30:	01010006 	tsteq	r1, r6

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	00000010 	andeq	r0, r0, r0, lsl r0
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	00040004 	andeq	r0, r4, r4
   c:	0c0e7c01 	stceq	12, cr7, [lr], {1}
  10:	0000000d 	andeq	r0, r0, sp
  14:	0000001c 	andeq	r0, r0, ip, lsl r0
  18:	00000000 	andeq	r0, r0, r0
  1c:	00010878 	andeq	r0, r1, r8, ror r8
  20:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
  24:	8e100e44 	cdphi	14, 1, cr0, cr0, cr4, {2}
  28:	85028b01 	strhi	r8, [r2, #-2817]	; 0xfffff4ff
  2c:	44048403 	strmi	r8, [r4], #-1027	; 0xfffffbfd
  30:	00080b0c 	andeq	r0, r8, ip, lsl #22
  34:	0000001c 	andeq	r0, r0, ip, lsl r0
  38:	00000000 	andeq	r0, r0, r0
  3c:	00010928 	andeq	r0, r1, r8, lsr #18
  40:	000000a8 	andeq	r0, r0, r8, lsr #1
  44:	8e100e44 	cdphi	14, 1, cr0, cr0, cr4, {2}
  48:	85028b01 	strhi	r8, [r2, #-2817]	; 0xfffff4ff
  4c:	44048403 	strmi	r8, [r4], #-1027	; 0xfffffbfd
  50:	00080b0c 	andeq	r0, r8, ip, lsl #22
  54:	0000001c 	andeq	r0, r0, ip, lsl r0
  58:	00000000 	andeq	r0, r0, r0
  5c:	000109d0 	ldrdeq	r0, [r1], -r0	; <UNPREDICTABLE>
  60:	000000f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
  64:	8e100e44 	cdphi	14, 1, cr0, cr0, cr4, {2}
  68:	8a028b01 	bhi	a2c74 <__bss_end__+0x80ea4>
  6c:	44048403 	strmi	r8, [r4], #-1027	; 0xfffffbfd
  70:	00080b0c 	andeq	r0, r8, ip, lsl #22
  74:	0000001c 	andeq	r0, r0, ip, lsl r0
  78:	00000000 	andeq	r0, r0, r0
  7c:	00010ac0 	andeq	r0, r1, r0, asr #21
  80:	00000154 	andeq	r0, r0, r4, asr r1
  84:	8e100e44 	cdphi	14, 1, cr0, cr0, cr4, {2}
  88:	85028b01 	strhi	r8, [r2, #-2817]	; 0xfffff4ff
  8c:	44048403 	strmi	r8, [r4], #-1027	; 0xfffffbfd
  90:	00080b0c 	andeq	r0, r8, ip, lsl #22
  94:	00000024 	andeq	r0, r0, r4, lsr #32
  98:	00000000 	andeq	r0, r0, r0
  9c:	00010c18 	andeq	r0, r1, r8, lsl ip
  a0:	00000194 	muleq	r0, r4, r1
  a4:	8e100e44 	cdphi	14, 1, cr0, cr0, cr4, {2}
  a8:	8a028b01 	bhi	a2cb4 <__bss_end__+0x80ee4>
  ac:	44048403 	strmi	r8, [r4], #-1027	; 0xfffffbfd
  b0:	44080b0c 	strmi	r0, [r8], #-2828	; 0xfffff4f4
  b4:	06028905 	streq	r8, [r2], -r5, lsl #18
  b8:	08028805 	stmdaeq	r2, {r0, r2, fp, pc}
  bc:	0000001c 	andeq	r0, r0, ip, lsl r0
  c0:	00000000 	andeq	r0, r0, r0
  c4:	00010dac 	andeq	r0, r1, ip, lsr #27
  c8:	000000cc 	andeq	r0, r0, ip, asr #1
  cc:	8e100e44 	cdphi	14, 1, cr0, cr0, cr4, {2}
  d0:	8a028b01 	bhi	a2cdc <__bss_end__+0x80f0c>
  d4:	44048403 	strmi	r8, [r4], #-1027	; 0xfffffbfd
  d8:	00080b0c 	andeq	r0, r8, ip, lsl #22
  dc:	00000020 	andeq	r0, r0, r0, lsr #32
  e0:	00000000 	andeq	r0, r0, r0
  e4:	00010e78 	andeq	r0, r1, r8, ror lr
  e8:	00000074 	andeq	r0, r0, r4, ror r0
  ec:	8e180e44 	cdphi	14, 1, cr0, cr8, cr4, {2}
  f0:	87028b01 	strhi	r8, [r2, -r1, lsl #22]
  f4:	85048603 	strhi	r8, [r4, #-1539]	; 0xfffff9fd
  f8:	44068405 	strmi	r8, [r6], #-1029	; 0xfffffbfb
  fc:	00080b0c 	andeq	r0, r8, ip, lsl #22
 100:	00000020 	andeq	r0, r0, r0, lsr #32
 104:	00000000 	andeq	r0, r0, r0
 108:	00010eec 	andeq	r0, r1, ip, ror #29
 10c:	000000ec 	andeq	r0, r0, ip, ror #1
 110:	8e180e44 	cdphi	14, 1, cr0, cr8, cr4, {2}
 114:	8a028b01 	bhi	a2d20 <__bss_end__+0x80f50>
 118:	85048603 	strhi	r8, [r4, #-1539]	; 0xfffff9fd
 11c:	44068405 	strmi	r8, [r6], #-1029	; 0xfffffbfb
 120:	00080b0c 	andeq	r0, r8, ip, lsl #22
 124:	00000010 	andeq	r0, r0, r0, lsl r0
 128:	00000000 	andeq	r0, r0, r0
 12c:	00010fd8 	ldrdeq	r0, [r1], -r8
 130:	00000080 	andeq	r0, r0, r0, lsl #1
 134:	000c0e44 	andeq	r0, ip, r4, asr #28
 138:	00000018 	andeq	r0, r0, r8, lsl r0
 13c:	00000000 	andeq	r0, r0, r0
 140:	00011058 	andeq	r1, r1, r8, asr r0
 144:	0000017c 	andeq	r0, r0, ip, ror r1
 148:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 14c:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 150:	00000b0d 	andeq	r0, r0, sp, lsl #22
 154:	00000018 	andeq	r0, r0, r8, lsl r0
 158:	00000000 	andeq	r0, r0, r0
 15c:	000111d4 	ldrdeq	r1, [r1], -r4
 160:	00000028 	andeq	r0, r0, r8, lsr #32
 164:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 168:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 16c:	00000b0d 	andeq	r0, r0, sp, lsl #22
 170:	00000018 	andeq	r0, r0, r8, lsl r0
 174:	00000000 	andeq	r0, r0, r0
 178:	000111fc 	strdeq	r1, [r1], -ip
 17c:	000000ac 	andeq	r0, r0, ip, lsr #1
 180:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 184:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 188:	00000b0d 	andeq	r0, r0, sp, lsl #22
 18c:	00000018 	andeq	r0, r0, r8, lsl r0
 190:	00000000 	andeq	r0, r0, r0
 194:	0001131c 	andeq	r1, r1, ip, lsl r3
 198:	0000003c 	andeq	r0, r0, ip, lsr r0
 19c:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 1a0:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 1a4:	00000b0d 	andeq	r0, r0, sp, lsl #22
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000000 	andeq	r0, r0, r0
 1b0:	00011358 	andeq	r1, r1, r8, asr r3
 1b4:	00000044 	andeq	r0, r0, r4, asr #32
 1b8:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 1bc:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 1c0:	00000b0d 	andeq	r0, r0, sp, lsl #22
 1c4:	00000010 	andeq	r0, r0, r0, lsl r0
 1c8:	00000000 	andeq	r0, r0, r0
 1cc:	0001139c 	muleq	r1, ip, r3
 1d0:	00000014 	andeq	r0, r0, r4, lsl r0
 1d4:	00080e44 	andeq	r0, r8, r4, asr #28
 1d8:	00000018 	andeq	r0, r0, r8, lsl r0
 1dc:	00000000 	andeq	r0, r0, r0
 1e0:	000113b0 			; <UNDEFINED> instruction: 0x000113b0
 1e4:	00000030 	andeq	r0, r0, r0, lsr r0
 1e8:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 1ec:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 1f0:	00000b0d 	andeq	r0, r0, sp, lsl #22
 1f4:	00000018 	andeq	r0, r0, r8, lsl r0
 1f8:	00000000 	andeq	r0, r0, r0
 1fc:	000113e0 	andeq	r1, r1, r0, ror #7
 200:	00000050 	andeq	r0, r0, r0, asr r0
 204:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 208:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 20c:	00000b0d 	andeq	r0, r0, sp, lsl #22
 210:	00000018 	andeq	r0, r0, r8, lsl r0
 214:	00000000 	andeq	r0, r0, r0
 218:	00011430 	andeq	r1, r1, r0, lsr r4
 21c:	00000020 	andeq	r0, r0, r0, lsr #32
 220:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 224:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 228:	00000b0d 	andeq	r0, r0, sp, lsl #22
 22c:	00000018 	andeq	r0, r0, r8, lsl r0
 230:	00000000 	andeq	r0, r0, r0
 234:	00011450 	andeq	r1, r1, r0, asr r4
 238:	00000040 	andeq	r0, r0, r0, asr #32
 23c:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 240:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 244:	00000b0d 	andeq	r0, r0, sp, lsl #22
 248:	00000018 	andeq	r0, r0, r8, lsl r0
 24c:	00000000 	andeq	r0, r0, r0
 250:	00011490 	muleq	r1, r0, r4
 254:	0000003c 	andeq	r0, r0, ip, lsr r0
 258:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 25c:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 260:	00000b0d 	andeq	r0, r0, sp, lsl #22
 264:	00000018 	andeq	r0, r0, r8, lsl r0
 268:	00000000 	andeq	r0, r0, r0
 26c:	000114cc 	andeq	r1, r1, ip, asr #9
 270:	00000040 	andeq	r0, r0, r0, asr #32
 274:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 278:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 27c:	00000b0d 	andeq	r0, r0, sp, lsl #22
 280:	00000018 	andeq	r0, r0, r8, lsl r0
 284:	00000000 	andeq	r0, r0, r0
 288:	0001150c 	andeq	r1, r1, ip, lsl #10
 28c:	00000030 	andeq	r0, r0, r0, lsr r0
 290:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 294:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 298:	00000b0d 	andeq	r0, r0, sp, lsl #22
 29c:	00000018 	andeq	r0, r0, r8, lsl r0
 2a0:	00000000 	andeq	r0, r0, r0
 2a4:	0001153c 	andeq	r1, r1, ip, lsr r5
 2a8:	00000024 	andeq	r0, r0, r4, lsr #32
 2ac:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 2b0:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 2b4:	00000b0d 	andeq	r0, r0, sp, lsl #22
 2b8:	00000018 	andeq	r0, r0, r8, lsl r0
 2bc:	00000000 	andeq	r0, r0, r0
 2c0:	00011560 	andeq	r1, r1, r0, ror #10
 2c4:	00000028 	andeq	r0, r0, r8, lsr #32
 2c8:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 2cc:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 2d0:	00000b0d 	andeq	r0, r0, sp, lsl #22
 2d4:	00000018 	andeq	r0, r0, r8, lsl r0
 2d8:	00000000 	andeq	r0, r0, r0
 2dc:	0001159c 	muleq	r1, ip, r5
 2e0:	00000034 	andeq	r0, r0, r4, lsr r0
 2e4:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 2e8:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 2ec:	00000b0d 	andeq	r0, r0, sp, lsl #22
 2f0:	00000018 	andeq	r0, r0, r8, lsl r0
 2f4:	00000000 	andeq	r0, r0, r0
 2f8:	000115d0 	ldrdeq	r1, [r1], -r0
 2fc:	00000020 	andeq	r0, r0, r0, lsr #32
 300:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 304:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 308:	00000b0d 	andeq	r0, r0, sp, lsl #22
 30c:	00000018 	andeq	r0, r0, r8, lsl r0
 310:	00000000 	andeq	r0, r0, r0
 314:	00010684 	andeq	r0, r1, r4, lsl #13
 318:	00000058 	andeq	r0, r0, r8, asr r0
 31c:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 320:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 324:	00000b0d 	andeq	r0, r0, sp, lsl #22
 328:	00000018 	andeq	r0, r0, r8, lsl r0
 32c:	00000000 	andeq	r0, r0, r0
 330:	000106dc 	ldrdeq	r0, [r1], -ip
 334:	00000030 	andeq	r0, r0, r0, lsr r0
 338:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 33c:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 340:	00000b0d 	andeq	r0, r0, sp, lsl #22
 344:	00000018 	andeq	r0, r0, r8, lsl r0
 348:	00000000 	andeq	r0, r0, r0
 34c:	0001070c 	andeq	r0, r1, ip, lsl #14
 350:	00000048 	andeq	r0, r0, r8, asr #32
 354:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 358:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 35c:	00000b0d 	andeq	r0, r0, sp, lsl #22
 360:	00000018 	andeq	r0, r0, r8, lsl r0
 364:	00000000 	andeq	r0, r0, r0
 368:	00010754 	andeq	r0, r1, r4, asr r7
 36c:	00000044 	andeq	r0, r0, r4, asr #32
 370:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 374:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 378:	00000b0d 	andeq	r0, r0, sp, lsl #22
 37c:	00000010 	andeq	r0, r0, r0, lsl r0
 380:	00000000 	andeq	r0, r0, r0
 384:	000112ac 	andeq	r1, r1, ip, lsr #5
 388:	00000014 	andeq	r0, r0, r4, lsl r0
 38c:	00040e44 	andeq	r0, r4, r4, asr #28
 390:	00000018 	andeq	r0, r0, r8, lsl r0
 394:	00000000 	andeq	r0, r0, r0
 398:	000112c0 	andeq	r1, r1, r0, asr #5
 39c:	00000018 	andeq	r0, r0, r8, lsl r0
 3a0:	8e080e44 	cdphi	14, 0, cr0, cr8, cr4, {2}
 3a4:	44028b01 	strmi	r8, [r2], #-2817	; 0xfffff4ff
 3a8:	00000b0d 	andeq	r0, r0, sp, lsl #22
 3ac:	0000000c 	andeq	r0, r0, ip
 3b0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3b4:	7c020001 	stcvc	0, cr0, [r2], {1}
 3b8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3bc:	00000024 	andeq	r0, r0, r4, lsr #32
 3c0:	000003ac 	andeq	r0, r0, ip, lsr #7
 3c4:	000115f4 	strdeq	r1, [r1], -r4
 3c8:	00000194 	muleq	r0, r4, r1
 3cc:	840c0e41 	strhi	r0, [ip], #-3649	; 0xfffff1bf
 3d0:	8e028703 	cdphi	7, 0, cr8, cr2, cr3, {0}
 3d4:	300e4101 	andcc	r4, lr, r1, lsl #2
 3d8:	20070c41 	andcs	r0, r7, r1, asr #24
 3dc:	0c0eab02 			; <UNDEFINED> instruction: 0x0c0eab02
 3e0:	000d0d41 	andeq	r0, sp, r1, asr #26
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003ac 	andeq	r0, r0, ip, lsr #7
 3ec:	00011788 	andeq	r1, r1, r8, lsl #15
 3f0:	00000084 	andeq	r0, r0, r4, lsl #1
 3f4:	83100e41 	tsthi	r0, #1040	; 0x410
 3f8:	87038404 	strhi	r8, [r3, -r4, lsl #8]
 3fc:	41018e02 	tstmi	r1, r2, lsl #28
 400:	0000070d 	andeq	r0, r0, sp, lsl #14
 404:	00000024 	andeq	r0, r0, r4, lsr #32
 408:	000003ac 	andeq	r0, r0, ip, lsr #7
 40c:	0001180c 	andeq	r1, r1, ip, lsl #16
 410:	0000001a 	andeq	r0, r0, sl, lsl r0
 414:	87040e41 	strhi	r0, [r4, -r1, asr #28]
 418:	180e4101 	stmdane	lr, {r0, r8, lr}
 41c:	46070d41 	strmi	r0, [r7], -r1, asr #26
 420:	0d41040e 	cfstrdeq	mvd0, [r1, #-56]	; 0xffffffc8
 424:	0ec7420d 	cdpeq	2, 12, cr4, cr7, cr13, {0}
 428:	00000000 	andeq	r0, r0, r0
 42c:	00000024 	andeq	r0, r0, r4, lsr #32
 430:	000003ac 	andeq	r0, r0, ip, lsr #7
 434:	00011826 	andeq	r1, r1, r6, lsr #16
 438:	00000016 	andeq	r0, r0, r6, lsl r0
 43c:	87040e41 	strhi	r0, [r4, -r1, asr #28]
 440:	100e4101 	andne	r4, lr, r1, lsl #2
 444:	44070d41 	strmi	r0, [r7], #-3393	; 0xfffff2bf
 448:	0d41040e 	cfstrdeq	mvd0, [r1, #-56]	; 0xffffffc8
 44c:	0ec7420d 	cdpeq	2, 12, cr4, cr7, cr13, {0}
 450:	00000000 	andeq	r0, r0, r0
 454:	00000024 	andeq	r0, r0, r4, lsr #32
 458:	000003ac 	andeq	r0, r0, ip, lsr #7
 45c:	0001183c 	andeq	r1, r1, ip, lsr r8
 460:	00000016 	andeq	r0, r0, r6, lsl r0
 464:	87040e41 	strhi	r0, [r4, -r1, asr #28]
 468:	100e4101 	andne	r4, lr, r1, lsl #2
 46c:	44070d41 	strmi	r0, [r7], #-3393	; 0xfffff2bf
 470:	0d41040e 	cfstrdeq	mvd0, [r1, #-56]	; 0xffffffc8
 474:	0ec7420d 	cdpeq	2, 12, cr4, cr7, cr13, {0}
 478:	00000000 	andeq	r0, r0, r0

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	6e616c63 	cdpvs	12, 6, cr6, cr1, cr3, {3}
   4:	65762067 	ldrbvs	r2, [r6, #-103]!	; 0xffffff99
   8:	6f697372 	svcvs	0x00697372
   c:	2e33206e 	cdpcs	0, 3, cr2, cr3, cr14, {3}
  10:	20302e39 	eorscs	r2, r0, r9, lsr lr
  14:	72797300 	rsbsvc	r7, r9, #0, 6
  18:	65676e69 	strbvs	r6, [r7, #-3689]!	; 0xfffff197
  1c:	706d7550 	rsbvc	r7, sp, r0, asr r5
  20:	2f00632e 	svccs	0x0000632e
  24:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  28:	62736f2f 	rsbsvs	r6, r3, #47, 30	; 0xbc
  2c:	7365786f 	cmnvc	r5, #7274496	; 0x6f0000
  30:	7365442f 	cmnvc	r5, #788529152	; 0x2f000000
  34:	706f746b 	rsbvc	r7, pc, fp, ror #8
  38:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
  3c:	65747461 	ldrbvs	r7, [r4, #-1121]!	; 0xfffffb9f
  40:	6f2f7473 	svcvs	0x002f7473
  44:	652d7461 	strvs	r7, [sp, #-1121]!	; 0xfffffb9f
  48:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
  4c:	6f697461 	svcvs	0x00697461
  50:	79732f6e 	ldmdbvc	r3!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
  54:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
  58:	62632d65 	rsbvs	r2, r3, #6464	; 0x1940
  5c:	6f6c6700 	svcvs	0x006c6700
  60:	5f6c6162 	svcpl	0x006c6162
  64:	61746164 	cmnvs	r4, r4, ror #2
  68:	74737500 	ldrbtvc	r7, [r3], #-1280	; 0xfffffb00
  6c:	50737065 	rsbspl	r7, r3, r5, rrx
  70:	4d4d7265 	sfmmi	f7, 2, [sp, #-404]	; 0xfffffe6c
  74:	74737500 	ldrbtvc	r7, [r3], #-1280	; 0xfffffb00
  78:	50737065 	rsbspl	r7, r3, r5, rrx
  7c:	4c4d7265 	sfmmi	f7, 2, [sp], {101}	; 0x65
  80:	746f6d00 	strbtvc	r6, [pc], #-3328	; 88 <printf@plt-0x1052c>
  84:	6944726f 	stmdbvs	r4, {r0, r1, r2, r3, r5, r6, r9, ip, sp, lr}^
  88:	6e695072 	mcrvs	0, 3, r5, cr9, cr2, {3}
  8c:	746f6d00 	strbtvc	r6, [pc], #-3328	; 94 <printf@plt-0x10520>
  90:	7453726f 	ldrbvc	r7, [r3], #-623	; 0xfffffd91
  94:	69507065 	ldmdbvs	r0, {r0, r2, r5, r6, ip, sp, lr}^
  98:	7274006e 	rsbsvc	r0, r4, #110	; 0x6e
  9c:	65676769 	strbvs	r6, [r7, #-1897]!	; 0xfffff897
  a0:	6e695072 	mcrvs	0, 3, r5, cr9, cr2, {3}
  a4:	67696200 	strbvs	r6, [r9, -r0, lsl #4]!
  a8:	67697254 			; <UNDEFINED> instruction: 0x67697254
  ac:	50726567 	rsbspl	r6, r2, r7, ror #10
  b0:	61006e69 	tstvs	r0, r9, ror #28
  b4:	6b5f6364 	blvs	17d8e4c <__bss_end__+0x17b707c>
  b8:	765f7965 	ldrbvc	r7, [pc], -r5, ror #18
  bc:	73006c61 	movwvc	r6, #3169	; 0xc61
  c0:	74657a69 	strbtvc	r7, [r5], #-2665	; 0xfffff597
  c4:	00657079 	rsbeq	r7, r5, r9, ror r0
  c8:	5f4d554e 	svcpl	0x004d554e
  cc:	5359454b 	cmppl	r9, #314572800	; 0x12c00000
  d0:	424c6d00 	submi	r6, ip, #0, 26
  d4:	73756c6f 	cmnvc	r5, #28416	; 0x6f00
  d8:	70657453 	rsbvc	r7, r5, r3, asr r4
  dc:	6e654c73 	mcrvs	12, 3, r4, cr5, cr3, {3}
  e0:	00687467 	rsbeq	r7, r8, r7, ror #8
  e4:	6f424c6d 	svcvs	0x00424c6d
  e8:	5373756c 	cmnpl	r3, #108, 10	; 0x1b000000
  ec:	73706574 	cmnvc	r0, #116, 10	; 0x1d000000
  f0:	6f6c6600 	svcvs	0x006c6600
  f4:	6d007461 	cfstrsvs	mvf7, [r0, #-388]	; 0xfffffe7c
  f8:	6c6f424c 	sfmvs	f4, 2, [pc], #-304	; ffffffd0 <__bss_end__+0xfffde200>
  fc:	6d007375 	stcvs	3, cr7, [r0, #-468]	; 0xfffffe2c
 100:	6769424c 	strbvs	r4, [r9, -ip, asr #4]!
 104:	756c6f42 	strbvc	r6, [ip, #-3906]!	; 0xfffff0be
 108:	4c6d0073 	stclmi	0, cr0, [sp], #-460	; 0xfffffe34
 10c:	64657355 	strbtvs	r7, [r5], #-853	; 0xfffffcab
 110:	424c6d00 	submi	r6, ip, #0, 26
 114:	73756c6f 	cmnvc	r5, #28416	; 0x6f00
 118:	70657453 	rsbvc	r7, r5, r3, asr r4
 11c:	00786449 	rsbseq	r6, r8, r9, asr #8
 120:	6f424c6d 	svcvs	0x00424c6d
 124:	5373756c 	cmnpl	r3, #108, 10	; 0x1b000000
 128:	00706574 	rsbseq	r6, r0, r4, ror r5
 12c:	70657473 	rsbvc	r7, r5, r3, ror r4
 130:	50726570 	rsbspl	r6, r2, r0, ror r5
 134:	6c00736f 	stcvs	3, cr7, [r0], {111}	; 0x6f
 138:	4b747361 	blmi	1d1cec4 <__bss_end__+0x1cfb0f4>
 13c:	65527965 	ldrbvs	r7, [r2, #-2405]	; 0xfffff69b
 140:	74616570 	strbtvc	r6, [r1], #-1392	; 0xfffffa90
 144:	6b007441 	blvs	1d250 <mLBolusStepsLength+0xb964>
 148:	65527965 	ldrbvs	r7, [r2, #-2405]	; 0xfffff69b
 14c:	74616570 	strbtvc	r6, [r1], #-1392	; 0xfffffa90
 150:	616c6544 	cmnvs	ip, r4, asr #10
 154:	656b0079 	strbvs	r0, [fp, #-121]!	; 0xffffff87
 158:	62654479 	rsbvs	r4, r5, #2030043136	; 0x79000000
 15c:	636e756f 	cmnvs	lr, #465567744	; 0x1bc00000
 160:	72700065 	rsbsvc	r0, r0, #101	; 0x65
 164:	654b7665 	strbvs	r7, [fp, #-1637]	; 0xfffff99b
 168:	69750079 	ldmdbvs	r5!, {r0, r3, r4, r5, r6}^
 16c:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
 170:	72700065 	rsbsvc	r0, r0, #101	; 0x65
 174:	69427665 	stmdbvs	r2, {r0, r2, r5, r6, r9, sl, ip, sp, lr}^
 178:	69725467 	ldmdbvs	r2!, {r0, r1, r2, r5, r6, sl, ip, lr}^
 17c:	72656767 	rsbvc	r6, r5, #27000832	; 0x19c0000
 180:	65727000 	ldrbvs	r7, [r2, #-0]!
 184:	69725476 	ldmdbvs	r2!, {r1, r2, r4, r5, r6, sl, ip, lr}^
 188:	72656767 	rsbvc	r6, r5, #27000832	; 0x19c0000
 18c:	72657300 	rsbvc	r7, r5, #0, 6
 190:	536c6169 	cmnpl	ip, #1073741850	; 0x4000001a
 194:	73007274 	movwvc	r7, #628	; 0x274
 198:	61697265 	cmnvs	r9, r5, ror #4
 19c:	7274536c 	rsbsvc	r5, r4, #108, 6	; 0xb0000001
 1a0:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
 1a4:	425f0079 	subsmi	r0, pc, #121	; 0x79
 1a8:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
 1ac:	69726573 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, r8, sl, sp, lr}^
 1b0:	74536c61 	ldrbvc	r6, [r3], #-3169	; 0xfffff39f
 1b4:	6e654c72 	mcrvs	12, 3, r4, cr5, cr2, {3}
 1b8:	63646100 	cmnvs	r4, #0, 2
 1bc:	79656b5f 	stmdbvc	r5!, {r0, r1, r2, r3, r4, r6, r8, r9, fp, sp, lr}^
 1c0:	006e695f 	rsbeq	r6, lr, pc, asr r9
 1c4:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
 1c8:	00667542 	rsbeq	r7, r6, r2, asr #10
 1cc:	0064636c 	rsbeq	r6, r4, ip, ror #6
 1d0:	7571694c 	ldrbvc	r6, [r1, #-2380]!	; 0xfffff6b4
 1d4:	72436469 	subvc	r6, r3, #1761607680	; 0x69000000
 1d8:	61747379 	cmnvs	r4, r9, ror r3
 1dc:	7274536c 	rsbsvc	r5, r4, #108, 6	; 0xb0000001
 1e0:	00746375 	rsbseq	r6, r4, r5, ror r3
 1e4:	7571694c 	ldrbvc	r6, [r1, #-2380]!	; 0xfffff6b4
 1e8:	72436469 	subvc	r6, r3, #1761607680	; 0x69000000
 1ec:	61747379 	cmnvs	r4, r9, ror r3
 1f0:	4e49006c 	cdpmi	0, 4, cr0, cr9, cr12, {3}
 1f4:	00545550 	subseq	r5, r4, r0, asr r5
 1f8:	5054554f 	subspl	r5, r4, pc, asr #10
 1fc:	48005455 	stmdami	r0, {r0, r2, r4, r6, sl, ip, lr}
 200:	00484749 	subeq	r4, r8, r9, asr #14
 204:	00574f4c 	subseq	r4, r7, ip, asr #30
 208:	48535550 	ldmdami	r3, {r4, r6, r8, sl, ip, lr}^
 20c:	4c555000 	mrami	r5, r5, acc0
 210:	454b004c 	strbmi	r0, [fp, #-76]	; 0xffffffb4
 214:	49525f59 	ldmdbmi	r2, {r0, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
 218:	00544847 	subseq	r4, r4, r7, asr #16
 21c:	5f59454b 	svcpl	0x0059454b
 220:	4b005055 	blmi	1437c <mLBolusStepsLength+0x2a90>
 224:	445f5945 	ldrbmi	r5, [pc], #-2373	; 22c <printf@plt-0x10388>
 228:	004e574f 	subeq	r5, lr, pc, asr #14
 22c:	5f59454b 	svcpl	0x0059454b
 230:	5446454c 	strbpl	r4, [r6], #-1356	; 0xfffffab4
 234:	59454b00 	stmdbpl	r5, {r8, r9, fp, lr}^
 238:	4c45535f 	mcrrmi	3, 5, r5, r5, cr15
 23c:	00544345 	subseq	r4, r4, r5, asr #6
 240:	5f59454b 	svcpl	0x0059454b
 244:	454e4f4e 	strbmi	r4, [lr, #-3918]	; 0xfffff0b2
 248:	49414d00 	stmdbmi	r1, {r8, sl, fp, lr}^
 24c:	4f42004e 	svcmi	0x0042004e
 250:	5f53554c 	svcpl	0x0053554c
 254:	554e454d 	strbpl	r4, [lr, #-1357]	; 0xfffffab3
 258:	69747500 	ldmdbvs	r4!, {r8, sl, ip, sp, lr}^
 25c:	00632e6c 	rsbeq	r2, r3, ip, ror #28
 260:	2e64656c 	cdpcs	5, 6, cr6, cr4, cr12, {3}
 264:	694c0063 	stmdbvs	ip, {r0, r1, r5, r6}^
 268:	64697571 	strbtvs	r7, [r9], #-1393	; 0xfffffa8f
 26c:	73797243 	cmnvc	r9, #805306372	; 0x30000004
 270:	2e6c6174 	mcrcs	1, 3, r6, cr12, cr4, {3}
 274:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 278:	2f656d6f 	svccs	0x00656d6f
 27c:	6f62736f 	svcvs	0x0062736f
 280:	2f736578 	svccs	0x00736578
 284:	6b736544 	blvs	1cd979c <__bss_end__+0x1cb79cc>
 288:	2f706f74 	svccs	0x00706f74
 28c:	616e6f63 	cmnvs	lr, r3, ror #30
 290:	73657474 	cmnvc	r5, #116, 8	; 0x74000000
 294:	72742f74 	rsbsvc	r2, r4, #116, 30	; 0x1d0
 298:	6f706d61 	svcvs	0x00706d61
 29c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
 2a0:	62696c5f 	rsbvs	r6, r9, #24320	; 0x5f00
 2a4:	7463692f 	strbtvc	r6, [r3], #-2351	; 0xfffff6d1
 2a8:	6568635f 	strbvs	r6, [r8, #-863]!	; 0xfffffca1
 2ac:	6e696b63 	vnmulvs.f64	d22, d9, d19
 2b0:	00632e67 	rsbeq	r2, r3, r7, ror #28
 2b4:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
 2b8:	5f746e65 	svcpl	0x00746e65
 2bc:	5f747063 	svcpl	0x00747063
 2c0:	73006469 	movwvc	r6, #1129	; 0x469
 2c4:	70757465 	rsbsvc	r7, r5, r5, ror #8
 2c8:	6f6f6c00 	svcvs	0x006f6c00
 2cc:	72700070 	rsbsvc	r0, r0, #112	; 0x70
 2d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 2d4:	72655373 	rsbvc	r5, r5, #-872415231	; 0xcc000001
 2d8:	006c6169 	rsbeq	r6, ip, r9, ror #2
 2dc:	61647075 	smcvs	18181	; 0x4705
 2e0:	63536574 	cmpvs	r3, #116, 10	; 0x1d000000
 2e4:	6e656572 	mcrvs	5, 3, r6, cr5, cr2, {3}
 2e8:	65686300 	strbvs	r6, [r8, #-768]!	; 0xfffffd00
 2ec:	72546b63 	subsvc	r6, r4, #101376	; 0x18c00
 2f0:	65676769 	strbvs	r6, [r7, #-1897]!	; 0xfffff897
 2f4:	72007372 	andvc	r7, r0, #-939524095	; 0xc8000001
 2f8:	53646165 	cmnpl	r4, #1073741849	; 0x40000019
 2fc:	61697265 	cmnvs	r9, r5, ror #4
 300:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
 304:	654b6461 	strbvs	r6, [fp, #-1121]	; 0xfffffb9f
 308:	65670079 	strbvs	r0, [r7, #-121]!	; 0xffffff87
 30c:	656b5f74 	strbvs	r5, [fp, #-3956]!	; 0xfffff08c
 310:	6f640079 	svcvs	0x00640079
 314:	4179654b 	cmnmi	r9, fp, asr #10
 318:	6f697463 	svcvs	0x00697463
 31c:	6f66006e 	svcvs	0x0066006e
 320:	72617772 	rsbvc	r7, r1, #29884416	; 0x1c80000
 324:	61745f64 	cmnvs	r4, r4, ror #30
 328:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
 32c:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 330:	6970006e 	ldmdbvs	r0!, {r1, r2, r3, r5, r6}^
 334:	646f4d6e 	strbtvs	r4, [pc], #-3438	; 33c <printf@plt-0x10278>
 338:	69640065 	stmdbvs	r4!, {r0, r2, r5, r6}^
 33c:	61746967 	cmnvs	r4, r7, ror #18
 340:	6165526c 	cmnvs	r5, ip, ror #4
 344:	69640064 	stmdbvs	r4!, {r2, r5, r6}^
 348:	61746967 	cmnvs	r4, r7, ror #18
 34c:	6972576c 	ldmdbvs	r2!, {r2, r3, r5, r6, r8, r9, sl, ip, lr}^
 350:	53006574 	movwpl	r6, #1396	; 0x574
 354:	61697265 	cmnvs	r9, r5, ror #4
 358:	65625f6c 	strbvs	r5, [r2, #-3948]!	; 0xfffff094
 35c:	006e6967 	rsbeq	r6, lr, r7, ror #18
 360:	69726553 	ldmdbvs	r2!, {r0, r1, r4, r6, r8, sl, sp, lr}^
 364:	615f6c61 	cmpvs	pc, r1, ror #24
 368:	6c696176 	stfvse	f6, [r9], #-472	; 0xfffffe28
 36c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
 370:	72655300 	rsbvc	r5, r5, #0, 6
 374:	5f6c6169 	svcpl	0x006c6169
 378:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
 37c:	72655300 	rsbvc	r5, r5, #0, 6
 380:	5f6c6169 	svcpl	0x006c6169
 384:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 388:	6e610065 	cdpvs	0, 6, cr0, cr1, cr5, {3}
 38c:	676f6c61 	strbvs	r6, [pc, -r1, ror #24]!
 390:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
 394:	6c696d00 	stclvs	13, cr6, [r9], #-0
 398:	0073696c 	rsbseq	r6, r3, ip, ror #18
 39c:	63657375 	cmnvs	r5, #-738197503	; 0xd4000001
 3a0:	65640073 	strbvs	r0, [r4, #-115]!	; 0xffffff8d
 3a4:	4d79616c 	ldfmie	f6, [r9, #-432]!	; 0xfffffe50
 3a8:	6f726369 	svcvs	0x00726369
 3ac:	6f636573 	svcvs	0x00636573
 3b0:	0073646e 	rsbseq	r6, r3, lr, ror #8
 3b4:	49556f74 	ldmdbmi	r5, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
 3b8:	6c00746e 	cfstrsvs	mvf7, [r0], {110}	; 0x6e
 3bc:	6f5f6465 	svcvs	0x005f6465
 3c0:	656c006e 	strbvs	r0, [ip, #-110]!	; 0xffffff92
 3c4:	666f5f64 	strbtvs	r5, [pc], -r4, ror #30
 3c8:	636c0066 	cmnvs	ip, #102	; 0x66
 3cc:	65625f64 	strbvs	r5, [r2, #-3940]!	; 0xfffff09c
 3d0:	006e6967 	rsbeq	r6, lr, r7, ror #18
 3d4:	5f64636c 	svcpl	0x0064636c
 3d8:	61656c63 	cmnvs	r5, r3, ror #24
 3dc:	636c0072 	cmnvs	ip, #114	; 0x72
 3e0:	72705f64 	rsbsvc	r5, r0, #100, 30	; 0x190
 3e4:	00746e69 	rsbseq	r6, r4, r9, ror #28
 3e8:	5f64636c 	svcpl	0x0064636c
 3ec:	43746573 	cmnmi	r4, #482344960	; 0x1cc00000
 3f0:	6f737275 	svcvs	0x00737275
 3f4:	63690072 	cmnvs	r9, #114	; 0x72
 3f8:	68635f74 	stmdavs	r3!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
 3fc:	696b6365 	stmdbvs	fp!, {r0, r2, r5, r6, r8, r9, sp, lr}^
 400:	6500676e 	strvs	r6, [r0, #-1902]	; 0xfffff892
 404:	726f7272 	rsbvc	r7, pc, #536870919	; 0x20000007
 408:	756f665f 	strbvc	r6, [pc, #-1631]!	; fffffdb1 <__bss_end__+0xfffddfe1>
 40c:	6300646e 	movwvs	r6, #1134	; 0x46e
 410:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
 414:	61747300 	cmnvs	r4, r0, lsl #6
 418:	75007472 	strvc	r7, [r0, #-1138]	; 0xfffffb8e
 41c:	6c6f624c 	sfmvs	f6, 2, [pc], #-304	; 2f4 <printf@plt-0x102c0>
 420:	64007375 	strvs	r7, [r0], #-885	; 0xfffffc8b
 424:	63657269 	cmnvs	r5, #-1879048186	; 0x90000006
 428:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
 42c:	65747300 	ldrbvs	r7, [r4, #-768]!	; 0xfffffd00
 430:	75007370 	strvc	r7, [r0, #-880]	; 0xfffffc90
 434:	6c654473 	cfstrdvs	mvd4, [r5], #-460	; 0xfffffe34
 438:	69007961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp, lr}
 43c:	00317300 	eorseq	r7, r1, r0, lsl #6
 440:	654c3173 	strbvs	r3, [ip, #-371]	; 0xfffffe8d
 444:	3273006e 	rsbscc	r0, r3, #110	; 0x6e
 448:	006e654c 	rsbeq	r6, lr, ip, asr #10
 44c:	68737570 	ldmdavs	r3!, {r4, r5, r6, r8, sl, ip, sp, lr}^
 450:	67697254 			; <UNDEFINED> instruction: 0x67697254
 454:	56726567 	ldrbtpl	r6, [r2], -r7, ror #10
 458:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
 45c:	67696200 	strbvs	r6, [r9, -r0, lsl #4]!
 460:	67697254 			; <UNDEFINED> instruction: 0x67697254
 464:	56726567 	ldrbtpl	r6, [r2], -r7, ror #10
 468:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
 46c:	424c6d00 	submi	r6, ip, #0, 26
 470:	73756c6f 	cmnvc	r5, #28416	; 0x6f00
 474:	706d6554 	rsbvc	r6, sp, r4, asr r5
 478:	436e6900 	cmnmi	lr, #0, 18
 47c:	00726168 	rsbseq	r6, r2, r8, ror #2
 480:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
 484:	54746e65 	ldrbtpl	r6, [r4], #-3685	; 0xfffff19b
 488:	00656d69 	rsbeq	r6, r5, r9, ror #26
 48c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 490:	636e6953 	cmnvs	lr, #1359872	; 0x14c000
 494:	73614c65 	cmnvc	r1, #25856	; 0x6500
 498:	65725074 	ldrbvs	r5, [r2, #-116]!	; 0xffffff8c
 49c:	70007373 	andvc	r7, r0, r3, ror r3
 4a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 4a4:	68547373 	ldmdavs	r4, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}^
 4a8:	654b7369 	strbvs	r7, [fp, #-873]	; 0xfffffc97
 4ac:	6e690079 	mcrvs	0, 3, r0, cr9, cr9, {3}
 4b0:	00747570 	rsbseq	r7, r4, r0, ror r5
 4b4:	63677261 	cmnvs	r7, #268435462	; 0x10000006
 4b8:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
 4bc:	75660073 	strbvc	r0, [r6, #-115]!	; 0xffffff8d
 4c0:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
 4c4:	646e6900 	strbtvs	r6, [lr], #-2304	; 0xfffff700
 4c8:	63657269 	cmnvs	r5, #-1879048186	; 0x90000006
 4cc:	75665f74 	strbvc	r5, [r6, #-3956]!	; 0xfffff08c
 4d0:	7000636e 	andvc	r6, r0, lr, ror #6
 4d4:	76006e69 	strvc	r6, [r0], -r9, ror #28
 4d8:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
 4dc:	75616200 	strbvc	r6, [r1, #-512]!	; 0xfffffe00
 4e0:	756f0064 	strbvc	r0, [pc, #-100]!	; 484 <printf@plt-0x10130>
 4e4:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
 4e8:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
 4ec:	5f767400 	svcpl	0x00767400
 4f0:	00636573 	rsbeq	r6, r3, r3, ror r5
 4f4:	69745f5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
 4f8:	745f656d 	ldrbvc	r6, [pc], #-1389	; 500 <printf@plt-0x100b4>
 4fc:	5f767400 	svcpl	0x00767400
 500:	63657375 	cmnvs	r5, #-738197503	; 0xd4000001
 504:	735f5f00 	cmpvc	pc, #0, 30
 508:	63657375 	cmnvs	r5, #-738197503	; 0xd4000001
 50c:	73646e6f 	cmnvc	r4, #1776	; 0x6f0
 510:	7400745f 	strvc	r7, [r0], #-1119	; 0xfffffba1
 514:	76656d69 	strbtvc	r6, [r5], -r9, ror #26
 518:	63006c61 	movwvs	r6, #3169	; 0xc61
 51c:	00736c6f 	rsbseq	r6, r3, pc, ror #24
 520:	73776f72 	cmnvc	r7, #456	; 0x1c8
 524:	61727400 	cmnvs	r2, r0, lsl #8
 528:	6c6f706d 	stclvs	0, cr7, [pc], #-436	; 37c <printf@plt-0x10238>
 52c:	2e656e69 	cdpcs	14, 6, cr6, cr5, cr9, {3}
 530:	682f0053 	stmdavs	pc!, {r0, r1, r4, r6}	; <UNPREDICTABLE>
 534:	2f656d6f 	svccs	0x00656d6f
 538:	6f62736f 	svcvs	0x0062736f
 53c:	2f736578 	svccs	0x00736578
 540:	6b736544 	blvs	1cd9a58 <__bss_end__+0x1cb7c88>
 544:	2f706f74 	svccs	0x00706f74
 548:	2d54414f 	ldfcse	f4, [r4, #-316]	; 0xfffffec4
 54c:	6a6f7250 	bvs	1bdce94 <__bss_end__+0x1bbb0c4>
 550:	2f746365 	svccs	0x00746365
 554:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
 558:	6d617274 	sfmvs	f7, 2, [r1, #-464]!	; 0xfffffe30
 55c:	696c6f70 	stmdbvs	ip!, {r4, r5, r6, r8, r9, sl, fp, sp, lr}^
 560:	6c2d656e 	cfstr32vs	mvfx6, [sp], #-440	; 0xfffffe48
 564:	47006269 	strmi	r6, [r0, -r9, ror #4]
 568:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
 56c:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
 570:	312e3533 			; <UNDEFINED> instruction: 0x312e3533
 574:	6f5f5f00 	svcvs	0x005f5f00
 578:	745f6666 	ldrbvc	r6, [pc], #-1638	; 580 <printf@plt-0x10034>
 57c:	73657300 	cmnvc	r5, #0, 6
 580:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
 584:	0064695f 	rsbeq	r6, r4, pc, asr r9
 588:	5f4f495f 	svcpl	0x004f495f
 58c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
 590:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
 594:	68635f00 	stmdavs	r3!, {r8, r9, sl, fp, ip, lr}^
 598:	006e6961 	rsbeq	r6, lr, r1, ror #18
 59c:	636f6c63 	cmnvs	pc, #25344	; 0x6300
 5a0:	7165536b 	cmnvc	r5, fp, ror #6
 5a4:	4e646e41 	cdpmi	14, 6, cr6, cr4, cr1, {2}
 5a8:	0065646f 	rsbeq	r6, r5, pc, ror #8
 5ac:	726d656d 	rsbvc	r6, sp, #457179136	; 0x1b400000
 5b0:	73006665 	movwvc	r6, #1637	; 0x665
 5b4:	5f657a69 	svcpl	0x00657a69
 5b8:	45540074 	ldrbmi	r0, [r4, #-116]	; 0xffffff8c
 5bc:	435f4345 	cmpmi	pc, #335544321	; 0x14000001
 5c0:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
 5c4:	75007478 	strvc	r7, [r0, #-1144]	; 0xfffffb88
 5c8:	36746e69 	ldrbtcc	r6, [r4], -r9, ror #28
 5cc:	00745f34 	rsbseq	r5, r4, r4, lsr pc
 5d0:	6f68735f 	svcvs	0x0068735f
 5d4:	75627472 	strbvc	r7, [r2, #-1138]!	; 0xfffffb8e
 5d8:	495f0066 	ldmdbmi	pc, {r1, r2, r5, r6}^	; <UNPREDICTABLE>
 5dc:	5f325f4f 	svcpl	0x00325f4f
 5e0:	74735f31 	ldrbtvc	r5, [r3], #-3889	; 0xfffff0cf
 5e4:	72726564 	rsbsvc	r6, r2, #100, 10	; 0x19000000
 5e8:	7473005f 	ldrbtvc	r0, [r3], #-95	; 0xffffffa1
 5ec:	65747261 	ldrbvs	r7, [r4, #-609]!	; 0xfffffd9f
 5f0:	6f6c0064 	svcvs	0x006c0064
 5f4:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
 5f8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
 5fc:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
 600:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
 604:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
 608:	4f495f00 	svcmi	0x00495f00
 60c:	6361625f 	cmnvs	r1, #-268435451	; 0xf0000005
 610:	5f70756b 	svcpl	0x0070756b
 614:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
 618:	6d697400 	cfstrdvs	mvd7, [r9, #-0]
 61c:	41694865 	cmnmi	r9, r5, ror #16
 620:	6556646e 	ldrbvs	r6, [r6, #-1134]	; 0xfffffb92
 624:	6f697372 	svcvs	0x00697372
 628:	5f5f006e 	svcpl	0x005f006e
 62c:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
 630:	656e6f7a 	strbvs	r6, [lr, #-3962]!	; 0xfffff086
 634:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
 638:	6f6c2067 	svcvs	0x006c2067
 63c:	6920676e 	stmdbvs	r0!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
 640:	7600746e 	strvc	r7, [r0], -lr, ror #8
 644:	5f776569 	svcpl	0x00776569
 648:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
 64c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 654 <printf@plt-0xff60>
 650:	64725f6f 	ldrbtvs	r5, [r2], #-3951	; 0xfffff091
 654:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
 658:	676f6c5f 			; <UNDEFINED> instruction: 0x676f6c5f
 65c:	72617000 	rsbvc	r7, r1, #0
 660:	79546d61 	ldmdbvc	r4, {r0, r5, r6, r8, sl, fp, sp, lr}^
 664:	00736570 	rsbseq	r6, r3, r0, ror r5
 668:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
 66c:	006f6e65 	rsbeq	r6, pc, r5, ror #28
 670:	72706d74 	rsbsvc	r6, r0, #116, 26	; 0x1d00
 674:	5f006665 	svcpl	0x00006665
 678:	725f4f49 	subsvc	r4, pc, #292	; 0x124
 67c:	5f646165 	svcpl	0x00646165
 680:	00646e65 	rsbeq	r6, r4, r5, ror #28
 684:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
 688:	5f00746e 	svcpl	0x0000746e
 68c:	67616c66 	strbvs	r6, [r1, -r6, ror #24]!
 690:	65730073 	ldrbvs	r0, [r3, #-115]!	; 0xffffff8d
 694:	5f007373 	svcpl	0x00007373
 698:	5f727563 	svcpl	0x00727563
 69c:	756c6f63 	strbvc	r6, [ip, #-3939]!	; 0xfffff09d
 6a0:	73006e6d 	movwvc	r6, #3693	; 0xe6d
 6a4:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
 6a8:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
 6ac:	715f5f00 	cmpvc	pc, r0, lsl #30
 6b0:	5f646175 	svcpl	0x00646175
 6b4:	45540074 	ldrbmi	r0, [r4, #-116]	; 0xffffff8c
 6b8:	555f4345 	ldrbpl	r4, [pc, #-837]	; 37b <printf@plt-0x10239>
 6bc:	00444955 	subeq	r4, r4, r5, asr r9
 6c0:	5f727265 	svcpl	0x00727265
 6c4:	6769726f 	strbvs	r7, [r9, -pc, ror #4]!
 6c8:	72006e69 	andvc	r6, r0, #1680	; 0x690
 6cc:	706f5f64 	rsbvc	r5, pc, r4, ror #30
 6d0:	5f656574 	svcpl	0x00656574
 6d4:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
 6d8:	745f5f00 	ldrbvc	r5, [pc], #-3840	; 6e0 <printf@plt-0xfed4>
 6dc:	725f6673 	subsvc	r6, pc, #120586240	; 0x7300000
 6e0:	726f6365 	rsbvc	r6, pc, #-1811939327	; 0x94000001
 6e4:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
 6e8:	665f5f00 	ldrbvs	r5, [pc], -r0, lsl #30
 6ec:	5f656572 	svcpl	0x00656572
 6f0:	6b6f6f68 	blvs	1bdc498 <__bss_end__+0x1bba6c8>
 6f4:	45455400 	strbmi	r5, [r5, #-1024]	; 0xfffffc00
 6f8:	65545f43 	ldrbvs	r5, [r4, #-3907]	; 0xfffff0bd
 6fc:	654d706d 	strbvs	r7, [sp, #-109]	; 0xffffff93
 700:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 704:	65666552 	strbvs	r6, [r6, #-1362]!	; 0xfffffaae
 708:	636e6572 	cmnvs	lr, #478150656	; 0x1c800000
 70c:	65640065 	strbvs	r0, [r4, #-101]!	; 0xffffff9b
 710:	6e697473 	mcrvs	4, 3, r7, cr9, cr3, {3}
 714:	6f697461 	svcvs	0x00697461
 718:	495f006e 	ldmdbmi	pc, {r1, r2, r3, r5, r6}^	; <UNPREDICTABLE>
 71c:	616d5f4f 	cmnvs	sp, pc, asr #30
 720:	72656b72 	rsbvc	r6, r5, #116736	; 0x1c800
 724:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 728:	54006e69 	strpl	r6, [r0], #-3689	; 0xfffff197
 72c:	5f434545 	svcpl	0x00434545
 730:	756c6156 	strbvc	r6, [ip, #-342]!	; 0xfffffeaa
 734:	69750065 	ldmdbvs	r5!, {r0, r2, r5, r6}^
 738:	3631746e 	ldrtcc	r7, [r1], -lr, ror #8
 73c:	5400745f 	strpl	r7, [r0], #-1119	; 0xfffffba1
 740:	5f434545 	svcpl	0x00434545
 744:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
 748:	7200746c 	andvc	r7, r0, #108, 8	; 0x6c000000
 74c:	73696765 	cmnvc	r9, #26476544	; 0x1940000
 750:	65726574 	ldrbvs	r6, [r2, #-1396]!	; 0xfffffa8c
 754:	64665f64 	strbtvs	r5, [r6], #-3940	; 0xfffff09c
 758:	4f495f00 	svcmi	0x00495f00
 75c:	4c49465f 	mcrrmi	6, 5, r4, r9, cr15
 760:	6c705f45 	ldclvs	15, cr5, [r0], #-276	; 0xfffffeec
 764:	5f007375 	svcpl	0x00007375
 768:	775f4f49 	ldrbvc	r4, [pc, -r9, asr #30]
 76c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
 770:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
 774:	45455400 	strbmi	r5, [r5, #-1024]	; 0xfffffc00
 778:	704f5f43 	subvc	r5, pc, r3, asr #30
 77c:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
 780:	006e6f69 	rsbeq	r6, lr, r9, ror #30
 784:	5f737973 	svcpl	0x00737973
 788:	7272656e 	rsbsvc	r6, r2, #461373440	; 0x1b800000
 78c:	62735f00 	rsbsvs	r5, r3, #0, 30
 790:	73006675 	movwvc	r6, #1653	; 0x675
 794:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
 798:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
 79c:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
 7a0:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
 7a4:	6e690074 	mcrvs	0, 3, r0, cr9, cr4, {3}
 7a8:	656b6f76 	strbvs	r6, [fp, #-3958]!	; 0xfffff08a
 7ac:	746e635f 	strbtvc	r6, [lr], #-863	; 0xfffffca1
 7b0:	4f495f00 	svcmi	0x00495f00
 7b4:	7661735f 			; <UNDEFINED> instruction: 0x7661735f
 7b8:	61625f65 	cmnvs	r2, r5, ror #30
 7bc:	5f006573 	svcpl	0x00006573
 7c0:	6b636f6c 	blvs	18dc578 <__bss_end__+0x18ba7a8>
 7c4:	6c665f00 	stclvs	15, cr5, [r6], #-0
 7c8:	32736761 	rsbscc	r6, r3, #25427968	; 0x1840000
 7cc:	6f6d5f00 	svcvs	0x006d5f00
 7d0:	73006564 	movwvc	r6, #1380	; 0x564
 7d4:	756f6474 	strbvc	r6, [pc, #-1140]!	; 368 <printf@plt-0x1024c>
 7d8:	74700074 	ldrbtvc	r0, [r0], #-116	; 0xffffff8c
 7dc:	66696472 			; <UNDEFINED> instruction: 0x66696472
 7e0:	00745f66 	rsbseq	r5, r4, r6, ror #30
 7e4:	66667562 	strbtvs	r7, [r6], -r2, ror #10
 7e8:	615f7265 	cmpvs	pc, r5, ror #4
 7ec:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
 7f0:	64657461 	strbtvs	r7, [r5], #-1121	; 0xfffffb9f
 7f4:	4f495f00 	svcmi	0x00495f00
 7f8:	315f325f 	cmpcc	pc, pc, asr r2	; <UNPREDICTABLE>
 7fc:	6474735f 	ldrbtvs	r7, [r4], #-863	; 0xfffffca1
 800:	005f6e69 	subseq	r6, pc, r9, ror #28
 804:	616d5f5f 	cmnvs	sp, pc, asr pc
 808:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
 80c:	6f6f685f 	svcvs	0x006f685f
 810:	706f006b 	rsbvc	r0, pc, fp, rrx
 814:	67726174 			; <UNDEFINED> instruction: 0x67726174
 818:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
 81c:	6f642067 	svcvs	0x00642067
 820:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
 824:	74706f00 	ldrbtvc	r6, [r0], #-3840	; 0xfffff100
 828:	00646e69 	rsbeq	r6, r4, r9, ror #28
 82c:	5f4f495f 	svcpl	0x004f495f
 830:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 834:	6e655f65 	cdpvs	15, 6, cr5, cr5, cr5, {3}
 838:	495f0064 	ldmdbmi	pc, {r2, r5, r6}^	; <UNPREDICTABLE>
 83c:	6f6c5f4f 	svcvs	0x006c5f4f
 840:	745f6b63 	ldrbvc	r6, [pc], #-2915	; 848 <printf@plt-0xfd6c>
 844:	4f495f00 	svcmi	0x00495f00
 848:	4c49465f 	mcrrmi	6, 5, r4, r9, cr15
 84c:	4e470045 	cdpmi	0, 4, cr0, cr7, cr5, {2}
 850:	31432055 	qdaddcc	r2, r5, r3
 854:	2e362031 	mrccs	0, 1, r2, cr6, cr1, {1}
 858:	20312e32 	eorscs	r2, r1, r2, lsr lr
 85c:	36313032 			; <UNDEFINED> instruction: 0x36313032
 860:	36313031 			; <UNDEFINED> instruction: 0x36313031
 864:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
 868:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
 86c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
 870:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
 874:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
 878:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
 87c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
 880:	612d3776 			; <UNDEFINED> instruction: 0x612d3776
 884:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
 888:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
 88c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
 890:	612d7865 			; <UNDEFINED> instruction: 0x612d7865
 894:	6d2d2039 	stcvs	0, cr2, [sp, #-228]!	; 0xffffff1c
 898:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
 89c:	76706676 			; <UNDEFINED> instruction: 0x76706676
 8a0:	31642d33 	cmncc	r4, r3, lsr sp
 8a4:	6d2d2036 	stcvs	0, cr2, [sp, #-216]!	; 0xffffff28
 8a8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
 8ac:	6d2d2062 	stcvs	0, cr2, [sp, #-392]!	; 0xfffffe78
 8b0:	2d736c74 	ldclcs	12, cr6, [r3, #-464]!	; 0xfffffe30
 8b4:	6c616964 			; <UNDEFINED> instruction: 0x6c616964
 8b8:	3d746365 	ldclcc	3, cr6, [r4, #-404]!	; 0xfffffe6c
 8bc:	20756e67 	rsbscs	r6, r5, r7, ror #28
 8c0:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
 8c4:	61776467 	cmnvs	r7, r7, ror #8
 8c8:	352d6672 	strcc	r6, [sp, #-1650]!	; 0xfffff98e
 8cc:	304f2d20 	subcc	r2, pc, r0, lsr #26
 8d0:	50662d20 	rsbpl	r2, r6, r0, lsr #26
 8d4:	73004349 	movwvc	r4, #841	; 0x349
 8d8:	69737365 	ldmdbvs	r3!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^
 8dc:	5f006e6f 	svcpl	0x00006e6f
 8e0:	766e655f 			; <UNDEFINED> instruction: 0x766e655f
 8e4:	6e6f7269 	cdpvs	2, 6, cr7, cr15, cr9, {3}
 8e8:	645f5f00 	ldrbvs	r5, [pc], #-3840	; 8f0 <printf@plt-0xfcc4>
 8ec:	696c7961 	stmdbvs	ip!, {r0, r5, r6, r8, fp, ip, sp, lr}^
 8f0:	00746867 	rsbseq	r6, r4, r7, ror #16
 8f4:	43454554 	movtmi	r4, #21844	; 0x5554
 8f8:	6168535f 	cmnvs	r8, pc, asr r3
 8fc:	4d646572 	cfstr64mi	mvdx6, [r4, #-456]!	; 0xfffffe38
 900:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
 904:	705f0079 	subsvc	r0, pc, r9, ror r0	; <UNPREDICTABLE>
 908:	5f00736f 	svcpl	0x0000736f
 90c:	5f646c6f 	svcpl	0x00646c6f
 910:	7366666f 	cmnvc	r6, #116391936	; 0x6f00000
 914:	73007465 	movwvc	r7, #1125	; 0x465
 918:	655f7379 	ldrbvs	r7, [pc, #-889]	; 5a7 <printf@plt-0x1000d>
 91c:	696c7272 	stmdbvs	ip!, {r1, r4, r5, r6, r9, ip, sp, lr}^
 920:	54007473 	strpl	r7, [r0], #-1139	; 0xfffffb8d
 924:	5f434545 	svcpl	0x00434545
 928:	61726150 	cmnvs	r2, r0, asr r1
 92c:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
 930:	6d5f0072 	ldclvs	0, cr0, [pc, #-456]	; 770 <printf@plt-0xfe44>
 934:	656b7261 	strbvs	r7, [fp, #-609]!	; 0xfffffd9f
 938:	61007372 	tstvs	r0, r2, ror r3
 93c:	636f6c6c 	cmnvs	pc, #108, 24	; 0x6c00
 940:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
 944:	00657a69 	rsbeq	r7, r5, r9, ror #20
 948:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 94c:	635f6563 	cmpvs	pc, #415236096	; 0x18c00000
 950:	75007470 	strvc	r7, [r0, #-1136]	; 0xfffffb90
 954:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
 958:	2064656e 	rsbcs	r6, r4, lr, ror #10
 95c:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
 960:	4f495f00 	svcmi	0x00495f00
 964:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
 968:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
 96c:	73656400 	cmnvc	r5, #0, 8
 970:	70635f74 	rsbvc	r5, r3, r4, ror pc
 974:	65720074 	ldrbvs	r0, [r2, #-116]!	; 0xffffff8c
 978:	656d5f67 	strbvs	r5, [sp, #-3943]!	; 0xfffff099
 97c:	5f5f006d 	svcpl	0x005f006d
 980:	616d656d 	cmnvs	sp, sp, ror #10
 984:	6e67696c 	vnmulvs.f16	s13, s14, s25	; <UNPREDICTABLE>
 988:	6f6f685f 	svcvs	0x006f685f
 98c:	6f63006b 	svcvs	0x0063006b
 990:	7469646e 	strbtvc	r6, [r9], #-1134	; 0xfffffb92
 994:	006e6f69 	rsbeq	r6, lr, r9, ror #30
 998:	65725f5f 	ldrbvs	r5, [r2, #-3935]!	; 0xfffff0a1
 99c:	6f6c6c61 	svcvs	0x006c6c61
 9a0:	6f685f63 	svcvs	0x00685f63
 9a4:	5f006b6f 	svcpl	0x00006b6f
 9a8:	325f4f49 	subscc	r4, pc, #292	; 0x124
 9ac:	735f315f 	cmpvc	pc, #-1073741801	; 0xc0000017
 9b0:	756f6474 	strbvc	r6, [pc, #-1140]!	; 544 <printf@plt-0x10070>
 9b4:	5f005f74 	svcpl	0x00005f74
 9b8:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
 9bc:	69746964 	ldmdbvs	r4!, {r2, r5, r6, r8, fp, sp, lr}^
 9c0:	6c616e6f 	stclvs	14, cr6, [r1], #-444	; 0xfffffe44
 9c4:	6172625f 	cmnvs	r2, pc, asr r2
 9c8:	5f68636e 	svcpl	0x0068636e
 9cc:	6f636572 	svcvs	0x00636572
 9d0:	6e696472 	mcrvs	4, 3, r6, cr9, cr2, {3}
 9d4:	706f0067 	rsbvc	r0, pc, r7, rrx
 9d8:	74706f74 	ldrbtvc	r6, [r0], #-3956	; 0xfffff08c
 9dc:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
 9e0:	5f323374 	svcpl	0x00323374
 9e4:	66630074 			; <UNDEFINED> instruction: 0x66630074
 9e8:	79745f65 	ldmdbvc	r4!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
 9ec:	74006570 	strvc	r6, [r0], #-1392	; 0xfffffa90
 9f0:	72745f61 	rsbsvc	r5, r4, #388	; 0x184
 9f4:	6f706d61 	svcvs	0x00706d61
 9f8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
 9fc:	5400632e 	strpl	r6, [r0], #-814	; 0xfffffcd2
 a00:	5f434545 	svcpl	0x00434545
 a04:	69676552 	stmdbvs	r7!, {r1, r4, r6, r8, sl, sp, lr}^
 a08:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 a0c:	654d6465 	strbvs	r6, [sp, #-1125]	; 0xfffffb9b
 a10:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
 a14:	65666552 	strbvs	r6, [r6, #-1362]!	; 0xfffffaae
 a18:	636e6572 	cmnvs	lr, #478150656	; 0x1c800000
 a1c:	75750065 	ldrbvc	r0, [r5, #-101]!	; 0xffffff9b
 a20:	5f006469 	svcpl	0x00006469
 a24:	7466615f 	strbtvc	r6, [r6], #-351	; 0xfffffea1
 a28:	6d5f7265 	lfmvs	f7, 2, [pc, #-404]	; 89c <printf@plt-0xfd18>
 a2c:	6365726f 	cmnvs	r5, #-268435450	; 0xf0000006
 a30:	5f65726f 	svcpl	0x0065726f
 a34:	6b6f6f68 	blvs	1bdc7dc <__bss_end__+0x1bbaa0c>
 a38:	72617000 	rsbvc	r7, r1, #0
 a3c:	00736d61 	rsbseq	r6, r3, r1, ror #26
 a40:	43454554 	movtmi	r4, #21844	; 0x5554
 a44:	7365535f 	cmnvc	r5, #2080374785	; 0x7c000001
 a48:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
 a4c:	6d5f5f00 	ldclvs	15, cr5, [pc, #-0]	; a54 <printf@plt-0xfb60>
 a50:	6365726f 	cmnvs	r5, #-268435450	; 0xf0000006
 a54:	0065726f 	rsbeq	r7, r5, pc, ror #4
 a58:	65745f5f 	ldrbvs	r5, [r4, #-3935]!	; 0xfffff0a1
 a5c:	6f007473 	svcvs	0x00007473
 a60:	72657470 	rsbvc	r7, r5, #112, 8	; 0x70000000
 a64:	68730072 	ldmdavs	r3!, {r1, r4, r5, r6}^
 a68:	776f6461 	strbvc	r6, [pc, -r1, ror #8]!
 a6c:	6675625f 			; <UNDEFINED> instruction: 0x6675625f
 a70:	00726566 	rsbseq	r6, r2, r6, ror #10
 a74:	78656e5f 	stmdavc	r5!, {r0, r1, r2, r3, r4, r6, r9, sl, fp, sp, lr}^
 a78:	5f5f0074 	svcpl	0x005f0074
 a7c:	3666666f 	strbtcc	r6, [r6], -pc, ror #12
 a80:	00745f34 	rsbseq	r5, r4, r4, lsr pc
 a84:	5f4f495f 	svcpl	0x004f495f
 a88:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
 a8c:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
 a90:	495f0065 	ldmdbmi	pc, {r0, r2, r5, r6}^	; <UNPREDICTABLE>
 a94:	61735f4f 	cmnvs	r3, pc, asr #30
 a98:	655f6576 	ldrbvs	r6, [pc, #-1398]	; 52a <printf@plt-0x1008a>
 a9c:	5f00646e 	svcpl	0x0000646e
 aa0:	5f737973 	svcpl	0x00737973
 aa4:	6c676973 			; <UNDEFINED> instruction: 0x6c676973
 aa8:	00747369 	rsbseq	r7, r4, r9, ror #6
 aac:	61705f5f 	cmnvs	r0, pc, asr pc
 ab0:	5f003164 	svcpl	0x00003164
 ab4:	6461705f 	strbtvs	r7, [r1], #-95	; 0xffffffa1
 ab8:	5f5f0032 	svcpl	0x005f0032
 abc:	33646170 	cmncc	r4, #112, 2
 ac0:	705f5f00 	subsvc	r5, pc, r0, lsl #30
 ac4:	00346461 	eorseq	r6, r4, r1, ror #8
 ac8:	61705f5f 	cmnvs	r0, pc, asr pc
 acc:	5f003564 	svcpl	0x00003564
 ad0:	73756e75 	cmnvc	r5, #1872	; 0x750
 ad4:	00326465 	eorseq	r6, r2, r5, ror #8
 ad8:	65647473 	strbvs	r7, [r4, #-1139]!	; 0xfffffb8d
 adc:	76007272 			; <UNDEFINED> instruction: 0x76007272
 ae0:	5f776569 	svcpl	0x00776569
 ae4:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
 ae8:	745f6863 	ldrbvc	r6, [pc], #-2147	; af0 <printf@plt-0xfac4>
 aec:	65745f6f 	ldrbvs	r5, [r4, #-3951]!	; 0xfffff091
 af0:	615f7478 	cmpvs	pc, r8, ror r4	; <UNPREDICTABLE>
 af4:	6c5f646e 	cfldrdvs	mvd6, [pc], {110}	; 0x6e
 af8:	7400676f 	strvc	r6, [r0], #-1903	; 0xfffff891
 afc:	4d656d69 	stclmi	13, cr6, [r5, #-420]!	; 0xfffffe5c
 b00:	75006469 	strvc	r6, [r0, #-1129]	; 0xfffffb97
 b04:	38746e69 	ldmdacc	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 b08:	7400745f 	strvc	r7, [r0], #-1119	; 0xfffffba1
 b0c:	4c656d69 	stclmi	13, cr6, [r5], #-420	; 0xfffffe5c
 b10:	5f00776f 	svcpl	0x0000776f
 b14:	62617476 	rsbvs	r7, r1, #1979711488	; 0x76000000
 b18:	6f5f656c 	svcvs	0x005f656c
 b1c:	65736666 	ldrbvs	r6, [r3, #-1638]!	; 0xfffff99a
 b20:	5f5f0074 	svcpl	0x005f0074
 b24:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
 b28:	695f636f 	ldmdbvs	pc, {r0, r1, r2, r3, r5, r6, r8, r9, sp, lr}^	; <UNPREDICTABLE>
 b2c:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
 b30:	7a696c61 	bvc	1a5bcbc <__bss_end__+0x1a39eec>
 b34:	6f685f65 	svcvs	0x00685f65
 b38:	5f006b6f 	svcpl	0x00006b6f
 b3c:	6e7a745f 	mrcvs	4, 3, r7, cr10, cr15, {2}
 b40:	00656d61 	rsbeq	r6, r5, r1, ror #26
 b44:	5f4f495f 	svcpl	0x004f495f
 b48:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
 b4c:	61625f65 	cmnvs	r2, r5, ror #30
 b50:	5f006573 	svcpl	0x00006573
 b54:	625f4f49 	subsvs	r4, pc, #292	; 0x124
 b58:	625f6675 	subsvs	r6, pc, #122683392	; 0x7500000
 b5c:	00657361 	rsbeq	r7, r5, r1, ror #6

Disassembly of section .debug_macinfo:

00000000 <.debug_macinfo>:
	...

Disassembly of section .debug_pubtypes:

00000000 <.debug_pubtypes>:
   0:	0000007b 	andeq	r0, r0, fp, ror r0
   4:	00000002 	andeq	r0, r0, r2
   8:	05f90000 	ldrbeq	r0, [r9, #0]!
   c:	023d0000 	eorseq	r0, sp, #0
  10:	425f0000 	subsmi	r0, pc, #0
  14:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
  18:	00000124 	andeq	r0, r0, r4, lsr #2
  1c:	616f6c66 	cmnvs	pc, r6, ror #24
  20:	02b40074 	adcseq	r0, r4, #116	; 0x74
  24:	6e750000 	cdpvs	0, 7, cr0, cr5, cr0, {0}
  28:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
  2c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
  30:	9400746e 	strls	r7, [r0], #-1134	; 0xfffffb92
  34:	4c000002 	stcmi	0, cr0, [r0], {2}
  38:	69757169 	ldmdbvs	r5!, {r0, r3, r5, r6, r8, ip, sp, lr}^
  3c:	79724364 	ldmdbvc	r2!, {r2, r5, r6, r8, r9, lr}^
  40:	6c617473 	cfstrdvs	mvd7, [r1], #-460	; 0xfffffe34
  44:	00003700 	andeq	r3, r0, r0, lsl #14
  48:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
  4c:	00004f00 	andeq	r4, r0, r0, lsl #30
  50:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
  54:	6e692067 	cdpvs	0, 6, cr2, cr9, cr7, {3}
  58:	02250074 	eoreq	r0, r5, #116	; 0x74
  5c:	68630000 	stmdavs	r3!, {}^	; <UNPREDICTABLE>
  60:	9f007261 	svcls	0x00007261
  64:	4c000002 	stcmi	0, cr0, [r0], {2}
  68:	69757169 	ldmdbvs	r5!, {r0, r3, r5, r6, r8, ip, sp, lr}^
  6c:	79724364 	ldmdbvc	r2!, {r2, r5, r6, r8, r9, lr}^
  70:	6c617473 	cfstrdvs	mvd7, [r1], #-460	; 0xfffffe34
  74:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
  78:	00007463 	andeq	r7, r0, r3, ror #8
  7c:	4f000000 	svcmi	0x00000000
  80:	02000000 	andeq	r0, r0, #0
  84:	0005f900 	andeq	pc, r5, r0, lsl #18
  88:	00026700 	andeq	r6, r2, r0, lsl #14
  8c:	00025000 	andeq	r5, r2, r0
  90:	745f5f00 	ldrbvc	r5, [pc], #-3840	; 98 <printf@plt-0x1051c>
  94:	5f656d69 	svcpl	0x00656d69
  98:	022f0074 	eoreq	r0, pc, #116	; 0x74
  9c:	69740000 	ldmdbvs	r4!, {}^	; <UNPREDICTABLE>
  a0:	6176656d 	cmnvs	r6, sp, ror #10
  a4:	0228006c 	eoreq	r0, r8, #108	; 0x6c
  a8:	6f6c0000 	svcvs	0x006c0000
  ac:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
  b0:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
  b4:	2064656e 	rsbcs	r6, r4, lr, ror #10
  b8:	00746e69 	rsbseq	r6, r4, r9, ror #28
  bc:	0000025b 	andeq	r0, r0, fp, asr r2
  c0:	75735f5f 	ldrbvc	r5, [r3, #-3935]!	; 0xfffff0a1
  c4:	6f636573 	svcvs	0x00636573
  c8:	5f73646e 	svcpl	0x0073646e
  cc:	00000074 	andeq	r0, r0, r4, ror r0
  d0:	00380000 	eorseq	r0, r8, r0
  d4:	00020000 	andeq	r0, r2, r0
  d8:	000008a9 	andeq	r0, r0, r9, lsr #17
  dc:	00000120 	andeq	r0, r0, r0, lsr #2
  e0:	000000ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
  e4:	7571694c 	ldrbvc	r6, [r1, #-2380]!	; 0xfffff6b4
  e8:	72436469 	subvc	r6, r3, #1761607680	; 0x69000000
  ec:	61747379 	cmnvs	r4, r9, ror r3
  f0:	010a006c 	tsteq	sl, ip, rrx
  f4:	694c0000 	stmdbvs	ip, {}^	; <UNPREDICTABLE>
  f8:	64697571 	strbtvs	r7, [r9], #-1393	; 0xfffffa8f
  fc:	73797243 	cmnvc	r9, #805306372	; 0x30000004
 100:	536c6174 	cmnpl	ip, #116, 2
 104:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
 108:	00000074 	andeq	r0, r0, r4, ror r0
	...

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	00000320 	andeq	r0, r0, r0, lsr #6
   4:	00000324 	andeq	r0, r0, r4, lsr #6
   8:	00000334 	andeq	r0, r0, r4, lsr r3
   c:	00000380 	andeq	r0, r0, r0, lsl #7
	...
  18:	0000060c 	andeq	r0, r0, ip, lsl #12
  1c:	00000638 	andeq	r0, r0, r8, lsr r6
  20:	00000644 	andeq	r0, r0, r4, asr #12
  24:	00000660 	andeq	r0, r0, r0, ror #12
	...
