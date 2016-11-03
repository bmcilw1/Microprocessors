; Brian McIlwain
; Lab 4.2
; Write a program that will load an input word from memory and count the
; number of halfwords that are all 0’s, then store this count into memory.

		AREA Prob2, CODE, READONLY
		ENTRY
		
start	LDR r0, =input ; Get address of input
		LDRH r1, [r0] ; Get first half word
		CMP r1, #0
		ADDEQ r3, r1, #1 ; Add zero flags
		
		LDRH r1, [r0, #2] ; Get second half word
		CMP r1, #0
		ADDEQ r3, r1, #1 ; Add zero flags
		LDR r0, =ans ; Store it back in memory
		STR r3, [r0]
stop	B	stop

;input	DCD 0x00008CE2
;input	DCD 0x0007B002
input	DCD 0x0000B002
;input	DCD 0x0
				
		AREA myData2, DATA, READWRITE
		ALIGN
			
ans		DCD 0
		
		END