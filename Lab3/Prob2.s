; Brian McIlwain
; Lab 3.2
; Add to prog 3.1
; r5 = sum from r1 and r2 as in part 1
; r6 = sum from r3 and r4 as in part 1 // this is part 1
; if (r0 == r5) // you will have 5 inputs in part 2 instead of 4
; 	end program
; else
;	r5 = sum of middle 16 bits from r1 and the middle 16 bits from r2
; 	r6 = sum of high 16 bits from r3 and low 16 bits from r4
;	end program

		AREA Prob2, CODE, READONLY
		ENTRY
start
		; Load inputs
		;LDR r0, =0x0000DB89
		LDR r1, =0x2A078CE2
		LDR	r2, =0x0C82B182
		LDR	r3, =0x9F46452E
		LDR	r4, =0x31F1D1B9
		
		; Class input
		;LDR r1, =0x12345678
		;LDR	r2, =0x0042CA9E
		;LDR	r3, =0x00334400
		;LDR	r4, =0x00AABB00
		
		ADD r5, r1, LSR #16 ; Add high 16 bits of r1
		
		; Isolate low 4 bits of r2
		ROR r2, r2, #16
		
		ADD r5, r5, r2, LSR #16 ; Add r5 with now high 16 bits of r2
		ROR r2, r2, #16 ; put r2 back to the way it was
		
		; Isolate middle 4 hex of r3 and r4
		ROR r3, r3, #24
		ROR r4, r4, #24
		
		; Add now high 4 hex of r3 and r4
		ADD r6, r6, r3, LSR #16
		ADD r6, r6, r4, LSR #16
		
		; Put r3 and r4 back to what they were
		ROR r3, r3, #8
		ROR r4, r4, #8
		
		CMP r0, r5 ; Check if r5 = r0
		BEQ	stop ; if it does, stop the program
		
		; Prep middle 16 bits of r1 and r2 for adding
		ROR r1, r1, #24
		ROR r2, r2, #24
		
		MOV r5, #0 ; Clear r5
		
		; Get sum of now high 16 bits r1 and r2 
		ADD r5, r1, LSR #16
		ADD r5, r5, r2, LSR #16
		
		; Put r1 and r2 back to the way they were
		ROR r1, r1, #8
		ROR r2, r2, #8
		
		; Prep low 16 bits of r4 for adding
		ROR r4, r4, #16
		
		MOV r6, #0 ; Clear r6
		; Add now high 16 bits of r3 and r4
		ADD r6, r3, LSR #16
		ADD r6, r6, r4, LSR #16
		
		; Put r4 back to what it was
		ROR r4, r4, #16
stop	B	stop
		END