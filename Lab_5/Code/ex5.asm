;========== EXERCISE 5 ==========

INCLUDE MACROS.ASM

DATA_SEG    SEGMENT
    ARRAY DB 20 DUP(?)
    BOOT_MSG      DB 0AH,0DH,'START (Y, N):$'
    NEWLINE       DB 0AH,0DH,'$'
    TERMINATE_MSG DB 0AH,0DH,'Exiting...$'
    ERROR_MSG     DB 0AH,0DH,'ERROR$'
    NUM_1     DB ?
    NUM_2     DB ?
    NUM_3     DB ?
DATA_SEG    ENDS

CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG

;========== MAIN ==========
MAIN PROC FAR
    MOV AX,DATA_SEG
    MOV DS,AX
START:
    PRINT_STR BOOT_MSG
BOOT_LOOP:
    READ
    CMP AL,'Y'
    JE  PROGRAM_START
    CMP AL,'N'
    JE  EXIT
    JMP BOOT_LOOP
PROGRAM_START:
    CALL HEX_KEYB
    MOV  NUM_1,AL
    CALL HEX_KEYB
    MOV  NUM_2,AL
    CALL HEX_KEYB
    MOV  NUM_3,AL

    CALL INPUT_SUM

    ; calculate ADC output
    ; (Input / Volts = 4095 / 2) => (Input / Volts = 20475 / 10)
    ; (Volts(AX) = (INPUT * 10 / 20475))
    MOV BX,10
    MUL BX
    MOV BX,20475
    DIV BX
    CMP AX,2                ; check if temperature is over 999,9C
    JL  VALID_TEMP
    PRINT_STR ERROR_MSG
    JMP PROGRAM_START
VALID_TEMP:
;=========

;continue here ...

;=========

EXIT:
    PRINT_STR TERMINATE_MSG
    EXIT
MAIN ENDP

;========== SUPLEMENTARY ROUTINES ==========

;========== READ HEXADECIMAL NUMBER ==========
HEX_KEYB PROC NEAR
IGNORE:
    READ
    CMP AL,30H        ; if input < 30H ('0') then ignore it
    JL IGNORE
    CMP AL,39H        ; if input > 39H ('9') then it may be a hex letter
    JG CHECK_LETTER
    SUB AL,30H        ; otherwise make it a hex number
    JMP INPUT_OK

CHECK_LETTER:
    CMP AL,'N'        ; if input = N then exit program
    JE  EXIT
    CMP AL,'A'        ; if input < 'A' then ignore it
    JL IGNORE
    CMP AL,'F'        ; if input > 'F' then ignore it
    JG IGNORE
    SUB AL,37H        ; otherwise make it a hex number

INPUT_OK:
    RET
HEX_KEYB ENDP

;========== SUMS 3 HEX INPUT AND PUTS IT TO AX ==========
INPUT_SUM PROC NEAR
    PUSH BX
    MOV AH,NUM_1        ; AH = 0000XXXX

    MOV AL,NUM_2        ; AL = 0000YYYY
    SAL AL,4
    AND AL,0F0H         ; AL = YYYY0000

    MOV BL,NUM_3
    AND BL,0FH          ; BL = 0000ZZZZ
    OR  AL,BL           ; AL = YYYYZZZZ
                        ; AX = 0000XXXX YYYYZZZZ (FULL NUMBER)
    POP BX
    RET
INPUT_SUM ENDP

;========== PRINTS TEMPERATURE ON SCREEN (stored in AX) ==========
PRINT_TEMPERATURE PROC NEAR
    MOV CX,0        ; initialize counter
SPLIT:
    MOV DX,0
    MOV BX,10
    DIV BX          ; take the last decimal digit
    PUSH DX         ; save it
    INC CX
    CMP AX,0
    JNE SPLIT       ; continue, till we split the whole number

    DEC CX
    CMP CX,0
    JNE PRINT_
    PRINT '0'
    JMP ONLY_DECIMAL

PRINT_:
    POP DX          ; print the digits we saved in reverse
    CALL PRINT_DEC
    LOOP PRINT_

ONLY_DECIMAL:
    PRINT '.'       ; the last digit is the decimal
    POP DX
    CALL PRINT_DEC

    PRINT ' '
    PRINT 0F8H
    PRINT 'C'
    PRINT_STR NEWLINE

    RET
PRINT_TEMPERATURE ENDP

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


CODE_SEG    ENDS
END MAIN
