; Brian McIlwain
; Lab 5 Microprocessors
; Macro to calculate 2*(xvar) + xvar

		AREA Prob1, CODE, READONLY
		ENTRY

		MACRO 
$top	macro1 $rst, $xvar
$top
		MUL $rst, $xvar, $xvar
		ADD $rst, $xvar, $rst, LSL #1
		MEND
start
		LDR r1, =input
		LDR r1, [r1]
		macro1 r0, r1
		LDR r1, =output
		STR r0, [r1]

stop 	B stop

input 	DCD 3

	AREA myData, DATA, READWRITE
	ALIGN
		
output	DCD 0
	END