
		AREA	Prog2, CODE, READONLY
		ENTRY
		MOV		r6, #10		; load n into r6
		MOV		r7, #1		; if n=0, at least n! = 1
loop	CMP		r6, #0
		MULGT	r7, r6, r7
		SUBGT	r6, r6, #1	; decrement n
		BGT		loop		; do another mul if counter !=0
stop	B 		stop		; stop program
		END