; Brian McIlwain
; Lab 3.1
; Your inputs are four different word-length numbers that your program
; will place in registers r1-r4. Your program will be responsible for: 
; (1) adding the high 16 bits from r1 and the low 16 bits from r2, 
; placing the word-size sum in r5; and (2) adding the middle 16 bits 
; from r3 and the middle 16 bits from r4, placing the word-size sum in r6.

		AREA Prob1, CODE, READONLY
		ENTRY
start
		; Load inputs
		LDR r1, =0x2A078CE2
		LDR	r2, =0x0C82B182
		LDR	r3, =0x9F46452E
		LDR	r4, =0x31F1D1B9
		
		; Class input
		;LDR r1, =0x12345678
		;LDR	r2, =0x0042CA9E
		;LDR	r3, =0x00334400
		;LDR	r4, =0x00AABB00
		
		ADD r5, r1, LSR #16 ; Add high 4 bits of r1
		
		; Isolate low 4 bits of r2
		ROR r2, r2, #16
		
		ADD r5, r5, r2, LSR #16 ; Add r5 with now high bits of r2
		ROR r2, r2, #16 ; put r2 back to the way it was
		
		; Isolate middle 4 bits of r3 and r4
		ROR r3, r3, #24
		ROR r4, r4, #24
		
		; Add now high 4 bits of r3 and r4
		ADD r6, r6, r3, LSR #16
		ADD r6, r6, r4, LSR #16
		
		; Put r3 and r4 back to what they were
		ROR r3, r3, #8
		ROR r4, r4, #8
		
stop	B	stop
		END