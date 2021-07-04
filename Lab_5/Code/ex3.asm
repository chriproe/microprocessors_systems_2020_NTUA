;=====EXERCISE 3======

INCLUDE     MACROS.ASM

DATA_SEG    SEGMENT
DATA_SEG    ENDS

CODE_SEG    SEGMENT
    ASSUME  CS:CODE_SEG, DS_DATA_SEG
    
MAIN PROC FAR
    START:
        CALL    HEX_KEYB        ;third digit
        CMP     AL,'T'          ;if T is given then STOP
        JE      STOP
        MOV     BH,AL
         
        CALL    HEX_KEYB        ;second digit   
        CMP     AL,'T'
        JE      STOP
        ROL     AL,4
        MOV     BL,AL
           
        
        CALL    HEX_KEYB        ;first digit
        CMP     AL,'T'
        JE      STOP
        OR      BL,AL
        
        PRINTCH '='
        CALL    PRINT_DEC       ;decimal
        PRINTCH '='             ;oct
        CALL    PRINT_OCT       ;binary
        PRINTCH '='
        CALL    PRINT_BIN
        
        PRINTLN
        JMP     START
        
     STOP:
        EXIT
MAIN ENDP



HEX_KEYB PROC NEAR    
    
    PUSH DX
IGNORE:
    READ            
    CMP AL,'T'          
    JE QUIT
    CMP AL,30H
    JL IGNORE
    CMP AL,39H
    JG LETTER
    PUSH AX 
    PRINT AL 
    POP AX 
    SUB AL,48   
    JMP QUIT
    
LETTER:
    CMP AL,'A'
    JL IGNORE 
    CMP AL,'F'
    JG IGNORE
    PUSH AX
    PRINT AL
    POP AX 
    SUB AL,37H
    
QUIT:
    POP DX
    RET  
    
HEX_KEYB ENDP
               
              
PRINT_DEC PROC NEAR
        
        PUSH    DX              ;save registers
        PUSH    BX
        MOV     AX,BX
        MOV     BL,10
        MOV     CX,1            ;initialize digit counter
      
     LOOP_1:
        DIV     BL              ;divide number by 10
        MOV     DX,AX
        SAR     AX,8            ;shift in order to fit next number
        PUSH    AX              ;save
        MOV     DH,0        
        MOV     AX,DX        
        CMP     AX,0
        JE      PRINTDEC
        INC     CX              ;increase counter(aka digits number)
        JNE     LOOP_1          ;repeat dividing
        
        
     PRINTDEC:
        POP     AX              ;get digit
        ADD     AX,48           ;ASCII coded
        PRINTCH   AL            ;print
        LOOP    PRINTDEC        ;repeat till no more digits
  
        POP     BX
        POP     DX
        RET  
        
PRINT_DEC ENDP
   



PRINT_OCT PROC NEAR
        
        PUSH    DX
        PUSH    BX
        MOV     AX,BX
        MOV     BL,8
        MOV     CX,1
      
     LOOP_2:
        DIV     BL
        MOV     DX,AX
        SAR     AX,8
        PUSH    AX
        MOV     DH,0        
        MOV     AX,DX        
        CMP     AX,0
        JE      PRINTOCT
        INC     CX
        JNE     LOOP_2
        
        
     PRINTOCT:
        POP     AX
        ADD     AX,48
        PRINTCH   AL
        LOOP    PRINTOCT
  
        POP     BX
        POP     DX
        RET  
        
PRINT_OCT ENDP  


PRINT_BIN PROC NEAR
    
        PUSH    BX
        PUSH    DX
        MOV     AX,BX
        MOV     BL,2
        MOV     CX,1
      
     LOOP_3:
        DIV     BL
        MOV     DX,AX
        SAR     AX,8
        PUSH    AX
        MOV     DH,0        
        MOV     AX,DX        
        CMP     AX,0
        JE      PRINTOCT
        INC     CX
        JNE     LOOP_3        
        
     PRINTBIN:
        POP     AX
        ADD     AX,48
        PRINTCH   AL
        LOOP    PRINTBIN
  
        POP     BX
        POP     DX
        RET  
        
PRINT_BIN ENDP







CODE_SEG ENDS
END MAIN

        
        
        
        
        

                    
    
    
    