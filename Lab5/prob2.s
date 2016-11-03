; Brian McIlwain
; Lab 5 Microprocessors
; Macro to calculate 2*(xvar) + xvar

		AREA Prob1, CODE, READONLY
		ENTRY
	
		MACRO 
$top	macro1 $xvar
$top
		MUL r1, $xvar, $xvar
		ADD r1, $xvar, r1, LSL #1
		MEND
		
		MACRO 
$top	macro2 $yvar, $zvar
$top
		LSL r2, $yvar, #4
		SUB r2, r2, $zvar, LSL #3
		MEND
		
		MACRO 
$top	macro3 $xvar, $yvar, $zvar
$top
		macro1 $xvar
		macro2 $yvar, $zvar
		SUB r0, r1, r2
		MEND
start	
		LDR r5, =input
		LDR r3, [r5], #4
		LDR r4, [r5], #4
		LDR r5, [r5]
		macro3 r3, r4, r5
		LDR r5, =output
		STR r0, [r5]
		
stop 	B stop

input 	DCD 3, 4, 5

	AREA myData, DATA, READWRITE
	ALIGN
		
output	DCD 0,0,0
	END