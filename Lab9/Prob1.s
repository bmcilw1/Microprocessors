; Brian McIlwain
; Wenxiu Hu
; Lab 9
; Configure	UART0 to	receive	and	transmit	(as	in	Lab 8)
; Output	"Enter	A:		0x" (as	in	Lab 8)
; Receive	user	input	of	a	number in	hexadecimal,	echoing	it	to	the	screen (as	in	
; Lab 8),	and	store	as	a	null-terminated	array	(ending	with	0).		Assume	that the	
; number	can	have from 1	to	8	digits and	the	input	of	the	number	ends	with	a	
; carriage	return.
; Convert	the	entered	number	to	binary
; Output	"Enter	B:		0x"
; Receive	user input	of	a	number in	hexadecimal,	echoing	it	to	the	screen,	and	
; store	as	a	null-terminated	array	(ending	with	0).		Assume	that the	number	
; can	have	from	1	to	8	digits	and	the	input	of	the	number	ends	with	a	carriage	
; return.
; Convert	the	entered	number	to	binary
; Compute	A +	B
; Convert	the hexadecimal	representation	of	this sum to	ASCII (as	in	Lab	6)
; Output	"A	+	B	=		0x"
; Output	the	ASCII	form	of	the	sum

; Modified UARTdemo_mod.s
; modified UART code for LPC2104 from Hohl and Hinds, Section 16.2.5
;   The modifications are to use push/pop instead of stmia/ldmdb

	area uartdemo, code, readonly
pinsel0  equ  0xe002c000	; controls function of pins
u0start  equ  0xe000c000	; start of UART0 registers
lcr0  equ  0xc		; line control register for UART0
lsr0  equ  0x14		; line status register for UART0
ramstart  equ  0x40000000	; start of onboard RAM for 2104
stackstart  equ  0x40000200  ; start of stack

	entry

start
	ldr sp, = stackstart	; set up stack pointer
	; Configure	UART0 to	receive	and	transmit
	bl UARTConfig	; initialize/configure UART0
	; Output	"Enter	A:		0x"
	ldr r1, =msgA
	bl Write
	; Receive	user	input	of	a	number in	hexadecimal
	ldr r1, =hexA
	bl Read
	; Convert	the	entered	number	to	binary
	bl toBinary
	mov r2, r0 ; save binary number A to r2
	; Output	"Enter	B:		0x"
	ldr r1, =msgB
	bl Write
	; Receive	user input	of	a	number in	hexadecimal
	ldr r1, =hexB
	bl Read
	; Convert	the	entered	number	to	binary
	bl toBinary
	; Compute	A +	B
	add r0, r0, r2 ; r0 = A + B
	; Output	"A	+	B	=		0x"
	ldr r1, =msgAdd
	bl Write
	; Convert	the hexadecimal	representation	of	this sum to	ASCII
	ldr r1, =hexSum
	bl toAsciiArr
	; Output	the	ASCII	form	of	the	sum
	bl Write
done	b done			; otherwise, we are done

; subroutine toAsciiChar
;   converts an input hex char to ascii
;   Registers used:
;   inputs:  r2 - hex char
;   outputs:  r2 - ascii char

toAsciiChar
	push{lr}
	cmp r2, #9 ; highest number
	addle r2, r2, #48 ; convert 0-9 to char 0-9
	addgt r2, r2, #55 ; convert A-F to char A-F
	pop {pc}
	
; subroutine toAsciiArr
;   converts a binary string to ascii hex array
;   Registers used:
; 	r2 - scratch
;	r3 - scratch counter
;   inputs:  r1 - start of ascii array
;			 r0 - hex string
;   outputs:  none

toAsciiArr
	push{r0 - r3, lr}
	mov r3, #0
asciiArrLoop
	mov r2, #0
	add r2, r0, lsr #28 ; r2 gets most significant hex of r0
	lsl r0, #4 ; prep next hex
	bl toAsciiChar ; convert r2 to ascii version of char
	strb r2, [r1], #1	; store character, increment address
	add r3, r3, #1 ; increment counter
	cmp r3, #8 ; finished storing array?
	blt asciiArrLoop		; continue if not finished
	mov r0, #0
	strb r0, [r1]	; store null terminator
	pop {r0 - r3, pc}

; subroutine toBinary
;   converts an input char to hex
;   Registers used:
; 	r2 - scratch
;   inputs:  r1 - start of ascii array
;   outputs:  r0 - binary number

toBinary
	push{r1, r2, lr}
	mov r2, #0 ; Zero r2
binLoop	
	ldrb r0, [r1], #1	; load character, increment address
	cmp r0, #0		; null terminated?
	blne toHex		; convert to hex/binary
	lslne r2, r2, #4	; make room for next hex digit
	addne r2, r2, r0  ; add new bit onto end of string
	bne binLoop		; continue if not a '0'
	mov r0, r2		; send output to r0
	pop {r1, r2, pc}

; subroutine toHex
;   converts an input char to hex
;   Registers used:
;   inputs:  r0 - ascii char
;   outputs:  r0 - hex char

toHex
	push{lr}
	cmp r0, #57 ; highest number
	suble r0, r0, #48 ; convert char 0-9 to 0-9
	subgt r0, r0, #55 ; convert char A-F to A-F
	pop {pc}
	
; subroutine Read
;   Reads a message from uart
;   Registers used:
;	r0 - scratch
;   inputs:  r1 - memory address to write to
;   outputs:  none

Read
	push{r0, r1, lr}
readLoop
	bl Recieve		; get character from UART
	cmp r0, #'\r'		; carriage return?
	blne Transmit
	strbne r0, [r1], #1	; store char, increment address
	bne readLoop		; continue if not a '0'
	mov r0, #0
	strb r0, [r1]	; store null terminator
	pop {r0, r1, pc}


; subroutine Write
;   Writes a message to uart
;   Registers used:
;	r0 - scratch register
;   inputs:  r1 - address of start of message in memory
;   outputs:  none

Write
	push{r0, r1, lr}
writeLoop	
	ldrb r0, [r1], #1	; load character, increment address
	bl Transmit		; send character to UART
	cmp r0, #0		; null terminated?
	bne writeLoop		; continue if not a '0'
	pop {r0, r1, pc}
	
; subroutine UARTConfig
;   Configures the I/O pins first.
;   Then sets up the UART control register.
;   Parameters set to 8 bits, no parity, and 1 stop bit.
;   Registers used:
;   r5 - scratch register
;   r6 - scratch register
;   inputs:  none
;   outputs:  none

UARTConfig
	push {r5, r6, lr}
	ldr r5, = pinsel0	; base address of register
	ldr r6, [r5]		; get contents
	bic r6, r6, #0xf		; clear out lower nibble
	orr r6, r6, #0x5	; sets P0.0 to Tx0 and P0.1 to Rx0
	str r6, [r5]		; r/modify/w back to register
	ldr r5, = u0start
	mov r6, #0x83		; set 8 bits, no parity, 1 stop bit
	strb r6, [r5, #lcr0]	; write control byte to LCR
	mov r6, #0x61		; 9600 baud @ 15MHz VPB clock
	strb r6, [r5]		; store control byte
	mov r6, #3		; set DLAB = 0
	strb r6, [r5, #lcr0]	; Tx and Rx buffers set up
	pop {r5, r6, pc}

; subroutine Recieve
;   Recieves one byte from the UART
;   Registers used:
;   r5 - scratch register
;   r6 - scratch register
;   inputs:  none
;   outputs:  r0 - byte recieved

Recieve
	push {r5, r6, lr}
	ldr r5, = u0start
waitR	ldrb r6, [r5, #lsr0]	; get status of buffer
	tst r6, #0x1		; buffer full?
				; in above instruction, text uses cmp, but should be tst
	beq waitR		; spin until buffer is not empty
	ldrb r0, [r5]
	pop {r5, r6, pc}


; subroutine Transmit
;   Puts one byte into the UART for transmitting
;   Registers used:
;   r5 - scratch register
;   inputs:  r0 - byte to transmit
;   outputs:  none

Transmit
	push {r5, r6, lr}
	ldr r5, = u0start
waitT	ldrb r6, [r5, #lsr0]	; get status of buffer
	tst r6, #0x20		; buffer empty?
				; in above instruction, text uses cmp, but should be tst
	beq waitT		; spin until buffer is empty
	strb r0, [r5]
	pop {r5, r6, pc}

msgA dcb "Enter A: 0x\0"
msgB dcb " Enter B: 0x\0"
msgAdd dcb " A + B = 0x\0"
		
	AREA myData, DATA, READWRITE
	ALIGN
hexA	dcb 0, 0, 0, 0, 0, 0, 0, 0, 0
hexB	dcb 0, 0, 0, 0, 0, 0, 0, 0, 0
hexSum	dcd 0
	END