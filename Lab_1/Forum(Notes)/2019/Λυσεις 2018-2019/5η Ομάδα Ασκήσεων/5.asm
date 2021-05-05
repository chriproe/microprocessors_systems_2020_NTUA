INCLUDE macros.asm

DATA SEGMENT
	STARTPROMPT DB "START(Y,N):$";Αρχικό μήνυμα
	ERRORMSG DB "ERROR$"		 ;Μήνυμα σφάλματος
ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA
	
	MAIN PROC FAR
			MOV AX,DATA
			MOV DS,AX
			
			PRINTSTR STARTPROMPT
		START:			;Εισαγωγή χαρακτήρα εκκίνησης
			READCH
			CMP AL,'N'			;= N ?
			JE FINISH			;Τερματισμός
			CMP AL,'Y'			;= Y ?
			JE CONT				;Λειτουργία
			JMP START
		CONT:
			PRINTCH AL			;Εμφάνιση χαρακτήρα εκκίνησης
			PRINTLN
			PRINTLN
		NEWTEMP:
			MOV DX,0
			MOV CX,3			;3 δεκαεξαδικά ψηφία
		READTEMP:		;Είσοδος
			CALL HEX_KEYB		;Εισαγωγή ψηφίου
			CMP AL,'N'			;Έλεγχος τερματισμού
			JE FINISH
						;Ένωση ψηφίων στον DX
			PUSH CX
			DEC CL				;Για την ολίσθηση
			ROL CL,2			;
			MOV AH,0
			ROL AX,CL			;Ολίσθηση αριστερά 8, 4, 0 ψηφία
			OR DX,AX			;Προσθήκη ψηφίου στον αριθμό
			POP CX
			LOOP READTEMP
			
			PRINTTAB
			MOV AX,DX
			CMP AX,2047			;V<=2 ?
			JBE BRANCH1
			CMP AX,3071			;V<=3 ?
			JBE BRANCH2
			PRINTSTR ERRORMSG	;V>3
			PRINTLN
			JMP NEWTEMP
			
		BRANCH1:		;1ος κλάδος: V<=2, T=(800*V) div 4095
			MOV BX,800
			MUL BX
			MOV BX,4095
			DIV BX
			JMP SHOWTEMP
		BRANCH2:		;2ος κλάδος: 2<V<=3, T=((3200*V) div 4095)-1200
			MOV BX,3200
			MUL BX
			MOV BX,4095
			DIV BX
			SUB AX,1200
		SHOWTEMP:
			CALL PRINT_DEC16	;Εμφάνιση ακέραιου μέρους (AX)
						;Κλασματικό μέρος = (υπόλοιπο*10) div 4095
			MOV AX,DX
			MOV BX,10
			MUL BX
			MOV BX,4095
			DIV BX
			
			PRINTCH ','			;Υποδιαστολή
			ADD AL,48			;Κωδικός ASCII
			PRINTCH AL			;Εμφάνιση κλασματικού μέρους
			PRINTLN
			JMP NEWTEMP
			
		FINISH:
			PRINTCH AL
			EXIT
	MAIN ENDP
						;Εισαγωγή δεκαεξαδικού ψηφίου (στον AL)
	HEX_KEYB PROC NEAR	;βλ. mP11_80x86_programs.pdf σελ. 20-21
		READ:
			READCH
			CMP AL,'N'			;=N ?
			JE RETURN
			CMP AL,48			;<0 ?
			JL READ
			CMP AL,57			;>9 ?
			JG LETTER
			PRINTCH AL
			SUB AL,48			;Κωδικός ASCII
			JMP RETURN
		LETTER:					;A...F
			CMP AL,'A'			;<A ?
			JL READ
			CMP AL,'F'			;>F ?
			JG READ
			PRINTCH AL
			SUB AL,55			;Κωδικός ASCII
		RETURN:
			
			RET
	HEX_KEYB ENDP
							;Εμφάνιση 16-bit δεκαδικού αριθμού (από τον AX)
	PRINT_DEC16 PROC NEAR	;βλ. mP11_80x86_programs.pdf σελ. 26-27
			PUSH DX
			
			MOV BX,10			;Δεκαδικός => διαιρέσεις με 10
			MOV CX,0			;Μετρητής ψηφίων
		GETDEC:			;Εξαγωγή ψηφίων
			MOV DX,0			;Αριθμός mod 10 (υπόλοιπο)
			DIV BX				;Διαίρεση με 10
			PUSH DX				;Προσωρινή αποθήκευση
			INC CL
			CMP AX,0			;Αριθμός div 10 = 0 ? (πηλίκο)
			JNE GETDEC
		PRINTDEC:		;Εμφάνιση ψηφίων
			POP DX
			ADD DL,48			;Κωδικός ASCII
			PRINTCH DL
			LOOP PRINTDEC
			
			POP DX
			RET
	PRINT_DEC16 ENDP
CODE ENDS
END MAIN
