; Brian McIlwain
; Wenxiu Hu
; Lab 6 a
; 1- Write	a	program	that	converts	an ASCII text string from	memory
; into	all	uppercase	and	stores	the	output	to	memory.		The input string	can	
; contain	uppercase	and lowercase letters	as	well	as	spaces.
; Example:	Convert	the string “Arm	pROceSsor”	to	“ARM	PROCESSOR”.
; Make	sure	the	input	string is null-terminated (that	is,	ends with	a	0	byte).

		AREA Prog1, CODE, READONLY
		ENTRY
		
		MACRO 
		cap $rt
		; If not in a-z lower case range, do nothing
		CMP $rt, #'a'
		BLT DONE
		CMP $rt, #'z'
		BGT DONE
		SUB $rt, $rt, #32 ; Capitilize char
DONE
		MEND
		
		LDR r0, =input
		LDR r1, =output
		
		; Loop over each char in string, pass to cap, store result
loop	LDRB r2, [r0], #1
		CMP r2, #0 ; End at null terminator in string
		BEQ last
		cap r2
		STRB r2, [r1], #1 ; Store result little endian
		B loop
		
		; Save null terminator
last	MOV r2, #0
		STRB r2, [r1]
stop 	B stop

input 	DCB "EE MiCro lab\0" 
		AREA myData, DATA, READWRITE
		ALIGN
output	DCB 0
		END