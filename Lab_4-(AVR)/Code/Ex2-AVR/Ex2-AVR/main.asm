.include "m16def.inc"
.DEF A = r16	;input A - PORTA LSB(0)
.DEF B = r17	;input B - PORTA LSB(1)
.DEF C = r18	;input C - PORTA LSB(2)
.DEF D = r19	;input D - PORTA LSB(3)
.DEF I = r20	;register to store input
.DEF E = r21	;register for temporary calculations
.DEF F = r22	;register for temporary calculations

;========== INITIALIZE STACK POINTER , I/O ==========
reset:	
		ldi r24 , low(RAMEND)		;initialize stack pointer (LOW)
		out SPL , r24
		ldi r24 , high(RAMEND)		;initialize stack pointer (HIGH)
		out SPH , r24
		ser r26
		out DDRB, r26				;initialize PORTB
		clr r26
		out DDRA, r26				;initialize PORTA

;========== DATA INPUT ==========
main:	
		clr E			; CLEAR E
		clr F			; CLEAR F
		in I, PINA		; I <- INPUT

		mov A, I		; LSB(0) = A
		lsr I			; rotate right INPUT
		mov B, I		; LSB(1) = B
		lsr I			; rotate right INPUT
		mov C, I		; LSB(2) = C
		lsr I			; rotate right INPUT
		mov D, I		; LSB(3) = D

;========== ROUTINE FOR F0 =============
		mov F, C		; F = C
		com F			; F = C'
		and F, A		; F = AC'
		and F, B		; F = ABC'
		mov E, C		; E = C
		and E, D		; E = CD
		or  F, E		; F = (ABC' + CD)
		com F			; F = (ABC' + CD)' -> F0

;========== ROUTINE FOR F1 ==============
		or A, B			; A = A + B
		or C, D			; C = C + D
		and A, C		; A = (A + B)(C + D) -> F1
		lsl A			; rotate left A
		
		andi F, 1		; F = F0 (0000 0001 MASK)
		andi A, 2		; A = F1 (0000 0010 MASK)
		or F, A			; COMBINE F0, F1
		out PORTB, F	; OUTPUT F0-F1 IN PORTB

		rjmp reset