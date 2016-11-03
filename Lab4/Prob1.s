; Brian McIlwain
; Lab 4.1
; Your inputs are four different word-length numbers that your program
; will place in registers r1-r4. Your program will be responsible for: 
; (1) adding the high 16 bits from r1 and the low 16 bits from r2, 
; placing the word-size sum in r5; and (2) adding the middle 16 bits 
; from r3 and the middle 16 bits from r4, placing the word-size sum in r6.

; Convert part 1 from Lab 3 to take its inputs from memory and store its
; sums to memory instead of registers. Declare four words of input data in the same
; section as your code; they will form an array of four words starting at variable gold. You
; may use pre-indexed or post-indexed addressing. Store your final sums into memory in
; the read-write data section into two words starting at variable purple.
; Points will be given for:
; • Efficient use of registers
; • Efficient use of instructions

		AREA Prob1, CODE, READONLY
		ENTRY
		
start	LDR r0, =gold ; Load inputs
		LDR r1, [r0] ; Load first 2 words
		LDR r2, [r0, #4]
		LSL r2, r2, #16 ; Isolate low 4 bits of r2
		LSR r2, r2, #16
		ADD r2, r1, LSR #16 ; Add high 4 bits of r1
		; Store answers to memeory
		LDR r0, =purple
		STR r2, [r0]
		MOV r2, #0

		LDR r0, =gold ; Load inputs
		LDR r1, [r0, #8] ; Load the next 2 words
		LDR r2, [r0, #12]
		ROR r1, r1, #24 ; Isolate middle 4 bits of r3 and r4
		LSL r2, r2, #8
		LSR r2, r2, #16
		ADD r2, r2, r1, LSR #16 ; Add now high 4 bits of r3 and r4
		LDR r0, =purple
		; Store answers to memeory
		STR r2, [r0, #4]
		
stop	B	stop

gold	DCD 0x2A078CE2, 0x0C82B182, 0x9F46452E, 0x31F1D1B9
;gold	DCD 0x12345678, 0x0042CA9E, 0x00334400, 0x31F1D1B9
				
		AREA myData, DATA, READWRITE
		ALIGN
			
purple	DCD 0,0
		
		END