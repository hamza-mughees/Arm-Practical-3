	AREA	AsmTemplate, CODE, READONLY
;	AREA	reset, CODE, READONLY
	IMPORT	main

; sample program makes the 4 LEDs P1.16, P1.17, P1.18, P1.19 go on and off in sequence
; (c) Mike Brady, 2011 -- 2019.

	EXPORT	start
start

IO1DIR	EQU	0xE0028018
IO1SET	EQU	0xE0028014
IO1CLR	EQU	0xE002801C
IO1PIN	EQU	0xE0028010
	
	ldr sp,=0x40002000

	ldr	r1,=IO1DIR
	ldr	r2,=0x000f0000	;select P1.19--P1.16
	str	r2,[r1]		;make them outputs
	ldr	r1,=IO1SET
	str	r2,[r1]		;set them to turn the LEDs off
	ldr	r2,=IO1CLR

	ldr r3, =0
	ldr r4, =0

Main
	bl pressButtons
	
	cmp r0, #-21
	beq clrOpr
	cmp r0, #-20
	beq clear
	cmp r0, #23
	beq	addOne
	cmp r0, #22
	beq subOne
	cmp r0, #21
	beq getSecNumToAdd
	cmp r0, #20
	beq getSecNumToSub
	b 	Main
addOne
	add r3, r3, #1
	bl display
	b	Main
subOne
	sub r3, r3, #1
	bl display
	b 	Main
getSecNumToAdd
	add r4, r3, r4
	mov r3, r4
	bl	display
	mov	r3, #0
	b	Main
getSecNumToSub
	cmp r4,#0
	beq	dispFirstNum
	sub	r4, r4, r3
	mov r3, r4
dispFirstNum
	bl	display
	mov r4, r3;
	mov r3, #0
	b	Main

clear
	mov r0, #0
	mov r3, #0
	mov r4, #0
	bl display
	b  Main
	
clrOpr
	mov r3,r4
	bl display
	b Main
	
stop	B	stop


pressButtons
	push{r3-r12, lr}
	
loop
	ldr	r5, =IO1PIN
	ldr r6,[r5]
	and r6, r6, #0x00f00000
	cmp	r6, #0x00E00000
	beq	button1
	cmp r6,#0x00D00000
	beq button2
	cmp r6,#0x00B00000
	beq button3
	cmp r6,#0x00700000
	beq button4
	b	loop
button1
	mov r0, #20
	b	delay
button2
	mov r0, #21
	b	delay
button3
	mov r0, #22
	b	delay
button4
	mov r0, #23
	b	delay
	
delay
	ldr r10, =1600000
deLoop
	sub r10, r10, #1
	cmp r10, #0
	beq longTest
	b deLoop
	
longTest

	ldr r6,[r5]
	and r6, r6, #0x00f00000

	cmp	r6, #0x00E00000
	beq	button1lp
	cmp r6,#0x00D00000
	beq button2lp
	cmp r6,#0x00B00000
	beq button3lp
	cmp r6,#0x00700000
	beq button4lp
	
	b finish
	
button1lp
	mov r0, #-20
	b	finish
button2lp
	mov r0, #-21
	b	finish
button3lp
	mov r0, #22
	b	finish
button4lp
	mov r0, #23
	b	finish
	
	

finish
	pop{r3-r12, pc}
	bx lr
	
display
	push{r4-r12,lr}
	
	ldr	r4, =2000000				; delay value
deloop	
	subs r4,r4,#1
	cmp  r4,#0	
	bne	deloop
	
	mov r11, #0x000f0000
	str r11, [r1]
	
	ldr r11, =0x000f0000
	cmp r3, #0
	bne cmpOne
    str r11, [r1]
	b done
cmpOne	
	cmp r3, #1
	beq dispOne
	cmp r3, #-15
	bne cmpTwo
dispOne
	mov r11, #0x00080000
	str r11, [r2]
	b done
cmpTwo
	cmp r3, #2
	beq dispTwo
	cmp r3, #-14
	bne cmpThree
dispTwo
	mov r11, #0x00040000
	str r11, [r2]
	b done
cmpThree
	cmp r3, #3
	beq dispThree
	cmp r3, #-13
	bne cmpFour
dispThree
	mov r11, #0x000C0000
	str r11, [r2]
	b done
cmpFour
	cmp r3, #4
	beq dispFour
	cmp r3, #-12
	bne cmpFive
dispFour
	mov r11, #0x00020000
	str r11, [r2]
	b done
cmpFive
	cmp r3, #5
	beq dispFive
	cmp r3, #-11
	bne cmpSix
dispFive
	mov r11, #0x000A0000
	str r11, [r2]
	b done
cmpSix
	cmp r3, #6
	beq dispSix
	cmp r3, #-10
	bne cmpSeven
dispSix
	mov r11, #0x00060000
	str r11, [r2]
	b done
cmpSeven
	cmp r3, #7
	beq dispSeven
	cmp r3, #-9
	bne cmpEight
dispSeven
	mov r11, #0x000E0000
	str r11, [r2]
	b done
cmpEight
	cmp r3, #8
	beq dispEight
	cmp r3, #-8
	bne cmpNine
dispEight
	mov r11, #0x00010000
	str r11, [r2]
	b done
cmpNine
	cmp r3, #9
	beq dispNine
	cmp r3, #-7
	bne cmpTen
dispNine
	mov r11, #0x00090000
	str r11, [r2]
	b done
cmpTen
	cmp r3, #10
	beq dispTen
	cmp r3, #-6
	bne cmpEleven
dispTen
	mov r11, #0x00050000
	str r11, [r2]
	b done
cmpEleven
	cmp r3, #11
	beq dispEleven
	cmp r3, #-5
	bne cmpTwelve
dispEleven
	mov r11, #0x000D0000
	str r11, [r2]
	b done
cmpTwelve
	cmp r3, #12
	beq dispTwelve
	cmp r3, #-4
	bne cmpThirteen
dispTwelve
	mov r11, #0x00030000
	str r11, [r2]
	b done
cmpThirteen
	cmp r3, #13
	beq dispThirteen
	cmp r3, #-3
	bne cmpFourteen
dispThirteen
	mov r11, #0x000B0000
	str r11, [r2]
	b done
cmpFourteen
	cmp r3, #14
	beq dispFourteen
	cmp r3, #-2
	bne cmpFifteen
dispFourteen
	mov r11, #0x00070000
	str r11, [r2]
	b done
cmpFifteen
	cmp r3, #15
	beq dispFifteen
	cmp r3, #-1
	bne done
dispFifteen
	mov r11, #0x000F0000
	str r11, [r2]
done
	ldr	r4, =2000000
dloop	
	subs r4,r4,#1
	cmp  r4,#0	
	bne	dloop
	mov r11, #0x000f0000
	;str r11, [r1]
	pop{r4-r12,pc}
	bx lr
	
	END