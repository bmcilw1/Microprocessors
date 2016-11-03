; Brian McIlwain
; Lab 4.3
; For numbers that are 128-bit unsigned integers, write a program that will
; subtract number yellow from number orange that are stored in memory and store the
; difference back into memory at red.

		AREA Prob3, CODE, READONLY
		ENTRY
start
		LDR r1, =orange ; Get address of input
		LDR r2, =yellow ; Get address of input
		LDR r0, =red ; Get address of output

		LDR r3, [r1], #4 ; Get the words
		LDR r4, [r2], #4
		SUBS r5, r3, r4  ; subtract the least significant words
		STR r5, [r0], #4 ; Store the result
		MOV r5, #0
		
		LDR r3, [r1], #4 ; Get the words
		LDR r4, [r2], #4
		SBCS r5, r3, r4  ; subtract the middle words with carry
		STR r5, [r0], #4 ; Store the result
		MOV r5, #0
		
		LDR r3, [r1], #4 ; Get the words
		LDR r4, [r2], #4
		SBCS r5, r3, r4  ; subtract the middle words with carry
		STR r5, [r0], #4 ; Store the result
		MOV r5, #0
		
		LDR r3, [r1], #4 ; Get the words
		LDR r5, [r2], #4
		SBC r5, r3, r4   ; subtract the most significant words with carry
		STR r5, [r0], #4 ; Store the result

stop	B	stop

; Numbers are stored LITTLE ENDIAN
orange	DCD 0xE00700B2, 0x12003E11, 0x00456700, 0x000ABCDE
yellow	DCD 0x320002B1, 0x08002177, 0x80111100, 0x00011000
				
		AREA myData3, DATA, READWRITE
		ALIGN
			
red		DCD 0, 0, 0, 0
		
		END