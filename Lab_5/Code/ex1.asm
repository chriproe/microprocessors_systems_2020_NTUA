;======EXERCISE 1========

INCLUDE MACROS.ASM
DATA_SEG    SEGMENT
    TABLE DB 128 DUP(?)
    TWO DB DUP(2)
DATA_SEG ENDS

CODE_SEG SEGMENT
    ASSUME CS:CODE, DS:DATA
    
    MAIN PROC FAR
        MOV AX,DATA_SEG
        MOV DS,AX
        
        MOV DI,0
        MOV CX,128          ;array TABLE of 128 unsigned items
        
    FILL_ARRAY:
        MOV TABLE[DI],CL
        INC DI
        LOOP FILL_ARRAY
        
        MOV DH,0
        MOV AX,0
        MOV BX,0
        MOV DI,0
        MOV CX,128         ;repeat 128 times
        
    ODD:
        PUSH AX
        MOV  AH,0
        MOV  AL,TABLE[DI]
        DIV  TWO             ;div 2
        CMP  AH,0            ;check if even
        POP  AX
        JE   EVEN
        MOV  DL,TABLE[DI]
        ADD  AX,DX
        INC  BX
        
    EVEN:
        INC  DI
        LOOP ODD
        MOV  DX,0
        DIV  BX
        
        PRINT_DEC:           ;print in decimal form
        
        PUSH    DX
        PUSH    BX
        MOV     AX,BX
        MOV     BL,10
        MOV     CX,1
      
     LOOP_1:
        DIV     BL
        MOV     DX,AX
        SAR     AX,8
        PUSH    AX
        MOV     DH,0        
        MOV     AX,DX        
        CMP     AX,0
        JE      PRINTDEC
        INC     CX
        JNE     LOOP_1
        
        
     PRINTDEC:
        POP     AX
        ADD     AX,48
        PRINT   AL
        LOOP    PRINTDEC
  
        POP     BX
        POP     DX  
        

        
        
        
        
        PRINTLN
        MOV  AL,TABLE[0]              ;min
        MOV  BL,TABLE[127]            ;max
        MOV  DI,0
        MOV  CX,128
        
        
    MAX:                              ;if number > max then update max
        CMP  AL,TABLE[DI]             ;or check if min
        JC   NEW_MAX
        JMP  MIN
    MIN:                              ;same for min
        CMP  TABLE[DI],BL
        JC   NEW_MIN
        JMP  CONTINUE
    NEW_MAX:
        MOV  AL,TABLE[DI]             ;update max
        JMP  CONTINUE
        
    NEW_MIN:                          ;update min
        MOV  BL,TABLE[DI]
    CONTINUE:
        INC  DI
        LOOP MAX
        
        CALL PRINT_HEX_
        PRINTCH ' ' 
        MOV AL,BL
        CALL PRINT_HEX
        
        EXIT
MAIN ENDP
    
    

PRINT_HEX_ PROC NEAR
			MOV DL,AL
			AND DL,0F0H		
			MOV CL,4
			ROR DL,CL
			CMP DL,0			
			JE SKIPZERO
			CALL PRINT_HEX
		SKIPZERO:
			MOV DL,AL
			AND DL,0FH			
			CALL PRINT_HEX
			RET
	PRINT_HEX_ ENDP
						
	PRINT_HEX PROC NEAR	
			CMP DL,9			
			JG LETTER
			ADD DL,48
			JMP SHOW
		LETTER:
			ADD DL,55			
		SHOW:
			PRINTCH DL
			RET
	PRINT_HEX ENDP
CODE_SEG ENDS
END MAIN
    
    