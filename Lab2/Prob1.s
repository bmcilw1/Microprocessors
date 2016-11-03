; Brian McIlwain
; Implement the following:
; h = 1
;	for i = 0 to 5
;		h = (h * 3) - i


		AREA	Prog1, CODE, READONLY
		ENTRY
		MOV		r0, #1		; load h into r0
		MOV		r1, #0		; load i into r1, set to 0
		MOV		r2, #3		; load 3 into r2
loop	MUL		r0, r2, r0	; multiply h by 3
		SUB		r0, r0, r1	; subtract (h*3) by i
		ADD		r1, r1, #1	; increment i
		CMP		r1, #6		; as long as i <= 5
		BLT		loop		; iterate if condition still holds
stop	B 		stop		; stop program
		END