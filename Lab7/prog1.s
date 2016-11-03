; Brian McIlwain
; Wenxiu Hu
; Micro Lab Exp 7
; Using	Example	12.1	in	the	Hohl	and	Hinds textbook	as	a	guide,	implement	a	
; full	program that	performs	the	following	operations,	using read-only data	flip,	gray,	and	
; silver and a lookup table directory, where	each	of	these	holds word-sized unsigned	
; integers.		Store	the	output	in	word	flip_result in	memory.
;  If	flip =	0: Compare	gray and	silver.		If	gray > silver,	then	calculate	the	
; difference	gray - silver.		If	gray =	silver,	then	calculate	silver +	7.		If	
; gray <	silver,	then	rotate	silver to	the	right	by	gray.		Store	the	
; calculated	value	in	word	flip_result in	memory.
;  If	flip =	1: Load	an	element	with	index	gray from	table	directory.		Let	x
; denote	this	element.		If	silver >	3000,	then	calculate	x +	3000.		If	
; silver £ 3000,	then	calculate	2x
; 2 +	3x. Store	the calculated	value in	
; word	flip_result in	memory.
;  Else: do	nothing.

; Create	your	own	table	directory for	use	by	the	flip = 1 function.	 It	should	contain at	
; least	5	elements.	You	will	be	given	test	data	during	lab	time	for	which	your	code	must	
; work	to	receive	credit.

; To	receive	full	credit,	your	code	must	not	only	be	functional,	but	efficient as	well	(so,	for	
; example,	no	excessive	branches, unnecessary	“brute	force”	methods,	or	exploiting	some	
; unforeseen	loophole).

		AREA Prog1, CODE, READONLY
		ENTRY
		; find if flip=1
		LDR r0, =flip
		LDR r0, [r0] ; Get flip
		CMP r0, #1
		BEQ flip1 ; flip=1 go to flip1
		CMP r0, #0
		BEQ flip0 ; flip=0 go to flip0
		B stop ; else do nothing
		
		; if flip = 0
flip0	LDR r0, =gray
		LDR r0, [r0] ; Get gray
		LDR r1, =silver
		LDR r1, [r1] ; Get silver
		CMP r0, r1
		SUBHI r0, r0, r1 ; if gray > silver, r0=gray-silver
		ADDEQ r0, r1, #7 ; if gray = silver, r0=silver+7
		RORLO r0, r1, r0 ; if gray < silver, r0=silver(ROR grey)
		B done; Store result
		
		; if flip = 1
flip1	LDR r1, =silver
		LDR r1, [r1] ; Get silver
		LDR r0, =3000
		CMP r1, r0 ; CMP silver to 3000
		LDR r0, =gray
		LDR r0, [r0] ; Get gray
		LSL r0, r0, #2 ; multiply offset by 4
		LDR r1, =directory
		LDR r1, [r1, r0] ; Get x = directory[gray*4]
		
		LDRHI r0, =3000
		ADDHI r0, r1, r0 ; if silver > 3000, r0=x+3000
		; else r0=2x^2+3x
		MULLS r0, r1, r1 ; x^2
		LSLLS r0, r0, #1 ; 2x^2
		LDRLS r2, =3
		MULLS r1, r2, r1 ; 3x
		ADDLS r0, r1, r0 ; r0=2x^2+3x
		
		; Store result
done	LDR r1, =flip_result
		STR r0, [r1]
		
stop 	B stop

; Input, all UNSIGNED integers
;flip 	DCD 0
;gray 	DCD 14
;silver 	DCD 8
directory DCD 57, 3, 0, 128, 257
	
;flip 	DCD 0
;gray 	DCD 8
;silver 	DCD 8

;flip 	DCD 0
;gray 	DCD 6
;silver 	DCD 8

;flip 	DCD 1
;gray 	DCD 4
;silver 	DCD 3145

;flip 	DCD 1
;gray 	DCD 4
;silver 	DCD 5

flip 	DCD 2
gray 	DCD 4
silver 	DCD 5

		AREA myData, DATA, READWRITE
		ALIGN
flip_result	DCD 0
		END