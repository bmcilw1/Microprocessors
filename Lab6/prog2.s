; Brian McIlwain
; Wenxiu Hu
; Lab 6 b
; 2- 	Given	a	number	held	in r8,	convert	it	into	an	ASCII	string	of	8	
; characters	corresponding	to	the	hexadecimal	representation	of	the	contents	
; of	r8.		Store	this	ASCII	string	in	memory.
; For	example, let	the	(binary)	contents	of	r8	be:
; 0101	1100	0000	0000	1110	1010	0001	1000.
; Expressed	in	hexadecimal,	this	is	0x5C00EA18.		So	the	output	ASCII	string	
; should	be the	ASCII	codes	for “5C00EA18”,	that	is,	0x35,	0x43,	0x30,	0x30,	
; 0x45,	0x41,	0x31,	0x38

		AREA Prog2, CODE, READONLY
		ENTRY
		
		MACRO
		hex2char $rt
		CMP $rt, #10 ; Test if 0-9
		ADDLT $rt, $rt, #48 ; convert 0-9 to char 0-9
		ADDGE $rt, $rt, #55 ; convert A-F to char A-F
		MEND
		
		MOV r1, #0 ; Counter
		LDR r8, =0x4BEE023D ; Initilize input word
loop	AND r2, r8, #0xF ; Get least significant hex digit
		LSR r8, r8, #4 ; Shift right by 4 to prep for next hex digit
		hex2char r2 ; Convert to char
		LDR r0, =output
		STRB r2, [r0, r1] ; Store result at end of output
		ADD r1, r1, #1 ; Increment counter
		CMP r1, #8 ; End when r1 is 8
		BNE loop
stop 	B stop

		AREA myData, DATA, READWRITE
		ALIGN
output	DCD 0
		END