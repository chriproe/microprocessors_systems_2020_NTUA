;========== EXERCISE 2 ==========

INCLUDE MACROS.ASM

DATA_SEG    SEGMENT
    NEWLINE DB 0AH,0DH,'$'
DATA_SEG    ENDS

CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG

;========== PART 1 ==========
MAIN PROC FAR
    MOV AX,DATA_SEG
    MOV DS,AX
START:
    MOV BX,0
    ; routine for 1st decimal number
    CALL DEC_KEYB      ; read 1st digit
    MOV BL,10          ; multiply 1st digit x 10
    MUL BL
    MOV BL,AL          ; store 1st number in BL
    CALL DEC_KEYB      ; read 2nd digit
    ADD AL,BL          ; add two numbers
    MOV BL,AL          ; store sum in BL

    ; routine for 2nd decimal number
    CALL DEC_KEYB      ; read 1st digit
    MOV CL,10          ; multiply 1st digit x 10
    MUL CL
    MOV CL,AL          ; store 1st number in CL
    CALL DEC_KEYB      ; read 2nd digit
    ADD AL,CL          ; add two numbers
    MOV CL,AL          ; store sum in CL

    PRINT 'Z'          ; printing routine
    PRINT '='
    MOV DL,BL
    CALL PRINT_DEC
    PRINT ' '
    PRINT 'W'
    PRINT '='
    MOV DL,CL
    CALL PRINT_DEC

    PRINT_STR NEWLINE

;========== PART 2 ==========
    ; calculate sum
    MOV AX,0
    MOV AL,BL
    ADD AX,CX
    PRINT 'Z'
    PRINT '+'
    PRINT 'W'
    PRINT '='
    MOV DX,AX
    CALL PRINT_HEX
    PRINT 'H'

    ; calculate diff
    PRINT ' '
    PRINT 'Z'
    PRINT '-'
    PRINT 'W'
    PRINT '='

    MOV AX,0
    CMP BL,CL
    JAE POSITIVE_DIF
    SUB CX,BX
    PRINT '-'
    MOV DL,CL
    JMP PRINT_DIF
POSITIVE_DIF:
    SUB BX,CX
    MOV DL,BL
PRINT_DIF:
    CALL PRINT_HEX
    PRINT 'H'

    JMP START
MAIN ENDP


;========== SUPLEMENTARY ROUTINES ==========

;========== READ DECIMAL NUMBER ==========
DEC_KEYB PROC NEAR
    PUSH DX
IGNORE:
    READ
    CMP AL,'Q'
    JE  ADDR2
    CMP AL,30H
    JL  IGNORE
    CMP AL,39H
    JG  IGNORE
    PUSH AX
    POP AX
    SUB AL,30H
ADDR2:
    POP DX
    RET
DEC_KEYB ENDP

;========== PRINT DECIMAL NUMBER (DL) ==========
PRINT_DEC PROC NEAR

    PUSH AX ; save registers
    PUSH CX
    PUSH DX

    MOV CX,1    ; initialize digit counter

    MOV AL,DL
    MOV DL,10

LD:
    MOV AH,0    ; divide number by 10
    DIV DL
    PUSH AX     ; save
    CMP AL,0    ; if quot = 0, start printing
    JE PRNT_10
    INC CX      ; increase counter (aka digits number)
    JMP LD      ; repeat dividing quotients by 10
PRNT_10:
    POP AX      ; get digit
    MOV AL,AH
    MOV AH,0
    ADD AX,'0'  ; ASCII coded
    PRINT AL    ; print
    LOOP PRNT_10 ; repeat till no more digits

    POP DX
    POP CX ; restore registers
    POP AX
    RET

PRINT_DEC ENDP

;========== PRINT DECIMAL NUMBER (DX) ==========
PRINT_DEC_2 PROC NEAR

 PUSH AX ; save registers
 PUSH BX
 PUSH CX
 PUSH DX

 MOV CX,1 ; initialize digit counter

 MOV AX,DX
 MOV BX,10

LD_2:
    MOV DX,0
    DIV BX
    PUSH DX ; save
    CMP AX,0 ; if quot = 0, start printing
    JE PRNT_10_2
    INC CX ; increase counter (aka digits number)
    JMP LD_2 ; repeat dividing quotients by 10
PRNT_10_2:
    POP DX ; get digit
    MOV AL,DL
    MOV AH,0
    ADD AX,'0' ; ASCII coded
    PRINT AL ; print
    LOOP PRNT_10_2 ; repeat till no more digits

    POP DX
    POP CX ; restore registers
    POP BX
    POP AX
    RET

PRINT_DEC_2 ENDP


;========== PRINT HEXIMAL NUMBER (DL) ==========

PRINT_HEX PROC NEAR

    PUSH AX
    MOV AL,DL
    SAR AL,4
    AND AL,0FH ; isolate 4 MSB
    ADD AL,30H ; ASCII code it
    CMP AL,39H
    JLE NEX
    ADD AL,07H ; if it's a letter, fix ASCII
NEX:
    CMP AL,'0'
    JE DONT_PRINT_IT
    PRINT AL ; print the first hex digit
DONT_PRINT_IT:
    MOV AL,DL
    AND AL,0FH ; isolate 4 LSB
    ADD AL,30H ; ASCII code it
    CMP AL,39H
    JLE OK
    ADD AL,07H ; if it's a letter, fix ASCII
OK:
    PRINT AL ; print the second hex digit

    POP AX
    RET

PRINT_HEX ENDP


CODE_SEG    ENDS
END MAIN
