
		AREA	Prog3, CODE, READONLY
		ENTRY
		MOV		r1, #50		; load A into r1
		MOV		r2, #15		; load B into r2
		MOV		r3, #3		; load C into r3
		MOV		r4, #18		; load D into r4
		MUL r5, r2, r3		; mult B*C and put in r5
		SUB r0, r1, r5		; subtract r5 from A and put in r0
		ADD r0, r0, r4		; add D + (B*C) and put in r6
stop	B 		stop		; stop program
		END