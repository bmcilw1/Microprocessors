; Brian McIlwain
; Wenxiu Hu
; Lab 8 Part 2
; Modify and extend the code from Part 1 so that your code instead receives input
; from the keyboard and mirrors it to the display in Keil.
; Your overall order of operations should be:
; 1) Configure UART0 to receive and transmit, including setting up P0.0, P0.1
; 2) Loop:
; a. Receive a character from UART0 by waiting for the buffer to be full then
; loading in a byte from the address of U0START
; b. Transmit this same character to UART0 by waiting for the buffer to be
; clear then storing a byte at the address of U0START

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
	bl UARTConfig	; initialize/configure UART0
	
loop
	bl Recieve
	bl Transmit		; send character to UART
	cmp r0, #0		; null terminated?
	bne loop		; continue if not a '0'
done	b done			; otherwise, we are done

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
	cmp r6, #0x61		; buffer full?
				; in above instruction, text uses cmp, but should be tst
	bne waitR		; spin until buffer is not empty
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

	end