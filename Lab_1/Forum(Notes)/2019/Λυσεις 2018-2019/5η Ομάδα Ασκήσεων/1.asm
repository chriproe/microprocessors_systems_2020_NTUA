INCLUDE macros.asm

DATA SEGMENT
	TABLE DB 128 DUP(?)			;Το σύνολο δεδομένων
	TWO DB DUP(2)				;Για τον έλεγχο της ισοτιμίας των αριθμών
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA

	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
						;Αποθήκευση των αριθμών στη μνήμη
			MOV DI,0			;Δείκτης πίνακα αριθμών
			MOV CX,128			;Πλήθος αριθμών
		STORE:
			MOV TABLE[DI],CL
			INC DI
			LOOP STORE
						;Έλεγχος ισοτιμίας, άθροιση και μέτρηση
			MOV DH,0			;Για την πρόσθεση AX+DL
			MOV AX,0			;Άθροισμα περιττών
			MOV BX,0			;Πλήθος περιττών
			MOV DI,0
			MOV CX,128
		FINDADDODD:
			PUSH AX
			MOV AH,0			;Για τη διαίρεση AX/2
			MOV AL,TABLE[DI]	;Έλεγχος ισοτιμίας
			DIV TWO				;
			CMP AH,0			;
			POP AX
			JE SKIPEVEN			;AX div 2 = 0 ?
			MOV DL,TABLE[DI]	;Προσωρινή αποθήκευση
			ADD AX,DX			;Άθροιση
			INC BX				;Περιττός
		SKIPEVEN:				;Άρτιος
			INC DI
			LOOP FINDADDODD
						;Υπολογισμός μέσου όρου
			MOV DX,0			;Για τη διαίρεση AX/BX
			DIV BX				;Άθροισμα/πλήθος
						;Εκτύπωση μέσου όρου
			CALL PRINT_NUM8_HEX	;Εκτύπωση του ακέραιου μέρους (πηλίκο)
			PRINTLN
						;Εύρεση μέγιστου, ελάχιστου
			MOV AL,TABLE[0]		;Αρχικό μέγιστο
			MOV BL,TABLE[127]	;Αρχικό ελάχιστο
			MOV DI,0
			MOV CX,128
		MAXMIN:
			CMP AL,TABLE[DI]	;Έλεγχος για μέγιστο
			JC NEWMAX
			JMP TOMIN
		NEWMAX:					;Νέο μέγιστο
			MOV AL,TABLE[DI]
			JMP NEXTNUM
		TOMIN:					;Έλεγχος για ελάχιστο
			CMP TABLE[DI],BL
			JC NEWMIN
			JMP NEXTNUM
		NEWMIN:					;Νέο ελάχιστο
			MOV BL,TABLE[DI]
		NEXTNUM:
			INC DI
			LOOP MAXMIN
						;Εκτύπωση μέγιστου, ελάχιστου
			CALL PRINT_NUM8_HEX	;Εκτύπωση μέγιστου
			PRINTCH ' '
			MOV AL,BL
			CALL PRINT_NUM8_HEX	;Εκτύπωση ελάχιστου
			
			EXIT
	MAIN ENDP
						;Εκτύπωση 8-bit αριθμού σε δεκαεξαδική μορφή (από τον AL)
	PRINT_NUM8_HEX PROC NEAR;βλ. mP11_80x86_programs.pdf σελ. 17
			MOV DL,AL
			AND DL,0F0H			;1ο δεκαεξαδικό ψηφίο
			MOV CL,4
			ROR DL,CL
			CMP DL,0			;Αγνόηση αρχικού μηδενικού
			JE SKIPZERO
			CALL PRINT_HEX
		SKIPZERO:
			MOV DL,AL
			AND DL,0FH			;2ο δεκαεξαδικό ψηφίο
			CALL PRINT_HEX
			RET
	PRINT_NUM8_HEX ENDP
						;Εκτύπωση δεκαεξαδικού ψηφίου (από τον DL)
	PRINT_HEX PROC NEAR	;βλ. mP11_80x86_programs.pdf σελ. 18
			CMP DL,9			;0...9
			JG LETTER
			ADD DL,48
			JMP SHOW
		LETTER:
			ADD DL,55			;A...F
		SHOW:
			PRINTCH DL
			RET
	PRINT_HEX ENDP
CODE ENDS
END MAIN
