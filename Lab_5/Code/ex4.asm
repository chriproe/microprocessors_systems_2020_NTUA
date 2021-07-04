;========== EXERCISE 4 ==========

INCLUDE MACROS.ASM

DATA_SEG    SEGMENT
    ARRAY DB 20 DUP(?)
    NEWLINE DB 0AH,0DH,'$'
    TERMINATE_MSG DB 0AH,0DH,'Exiting...$'
DATA_SEG    ENDS

CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG

;========== PART 1 ==========
MAIN PROC FAR
    MOV AX,DATA_SEG
    MOV DS,AX
START:
    MOV CX,20       ; set counter to 20
    MOV DI,0
INPUT_LOOP:
    READ
    CMP AL,3DH          ; check if input is '='
    JE EXIT
    CMP AL,30H          ; compare with 0
    JL  INPUT_LOOP      ; if smaller repeat
    CMP AL,39H          ; compare with 9
    JLE CONTINUE_LOOP   ; if smaller then number is valid
    CMP AL,'a'          ; compare with 'a'
    JL  INPUT_LOOP      ; if smaller repeat
    CMP AL,'z'          ; compare with 'z'
    JG  INPUT_LOOP      ; if greater repeat (else valid)
CONTINUE_LOOP:
    MOV [ARRAY + DI],AL
    INC DI
    LOOP INPUT_LOOP

    MOV CX,20
    MOV DI,0
PRINT_LINE1:
    MOV AL,[ARRAY + DI]
    PRINT AL
    INC DI
    LOOP PRINT_LINE1       ; loops 20 times (CX)
    PRINT_STR NEWLINE

;========== PART 2 ==========
    MOV CX,20
    MOV DI,0
PRINT_LINE2_LET:
    MOV AL,[ARRAY + DI]
    CMP AL,39H
    JLE  LINE2_LET_CONTINUE   ; if it is a number continue to next
    SUB AL,20H                ; convert letters to upper case
    PRINT AL
LINE2_LET_CONTINUE:
    INC DI
    LOOP PRINT_LINE2_LET
    PRINT '-'

    MOV CX,20
    MOV DI,0
PRINT_LINE2_NUM:
    MOV AL,[ARRAY + DI]
    CMP AL,39H
    JG  LINE2_NUM_CONTINUE
    PRINT AL
LINE2_NUM_CONTINUE:
    INC DI
    LOOP PRINT_LINE2_NUM

    PRINT_STR NEWLINE
    JMP START

EXIT:
    PRINT_STR TERMINATE_MSG
    EXIT
MAIN ENDP


CODE_SEG    ENDS
END MAIN
