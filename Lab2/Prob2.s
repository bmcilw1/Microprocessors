; Brian McIlwain
; Implement the following:
; h = 1
;	for i = 0 to 5
;		if h < 102
;			h = (h * 3) - i

		AREA	Prog2, CODE, READONLY
		ENTRY
		MOV		r0, #1		; load h into r0
		MOV		r1, #0		; load i into r1, set to 0
		MOV		r2, #3		; load 3 into r2
loop	CMP		r0, #102	; compare h with r2
		MULLT	r0, r2, r0	; multiply h by 3 if h still less than 102
		SUBLT	r0, r0, r1	; subtract (h*3) by i if h still less than 102
		ADD		r1, r1, #1	; increment i
		CMP		r1, #6		; as long as i <= 5
		BLT		loop		; iterate if i <= 5
stop	B 		stop		; stop program
		END