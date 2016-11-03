; Brian McIlwain
; Wenxiu Hu
; Lab 8 Part 1
; Execute the code in UARTdemo_mod.s (provided on the course Moodle site and
; modified from Section 16.2.5 of the Hohl and Hinds textbook) and confirm that you
; can get it to work properly.
; This code is for the LPC2104 device, manufactured by
; NXP – make sure you choose this device in the simulator before running. The code
; here does all of the initialization necessary to configure the UART to display
; characters on the screen, then transmits one character at a time to the screen from
; the test string given (“Watson. Come quickly!” in this case). You can view the output
; by choosing view->serial->UART #1 within the debugger in the Keil tool. It is
; recommended that you view the operation by setting a breakpoint in your code at
; the STRB r0, [r5] instruction within the Transmit subroutine and then using the Run
; button, as stepping through line by line can take a long time due to the way the
; subroutine is implemented (though you may want to do it this way once to see for
; yourself). All you need to show the instructor/TA during lab time is that you’ve
; written this and the proper output is displayed in UART #1. Try some other strings as
; well.

; UARTdemo_mod.s
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
	ldr r1, = CharData	; starting address of characters
loop
	ldrb r0, [r1], #1	; load character, increment address
	cmp r0, #0		; null terminated?
	blne Transmit		; send character to UART
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

; subroutine Transmit
;   Puts one byte into the UART for transmitting
;   Registers used:
;   r5 - scratch register
;   r6 - scratch register
;   inputs:  r0 - byte to transmit
;   outputs:  none

Transmit
	push {r5, r6, lr}
	ldr r5, = u0start
wait	ldrb r6, [r5, #lsr0]	; get status of buffer
	tst r6, #0x20		; buffer empty?
				; in above instruction, text uses cmp, but should be tst
	beq wait		; spin until buffer is empty
	strb r0, [r5]
	pop {r5, r6, pc}

CharData  dcb  "Watson.  Come quickly!", 0

	end

