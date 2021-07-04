.include "m16def.inc"
reset: ldi r24 , low(RAMEND) 			; initialize stack pointer
out SPL , r24
ldi r24 , high(RAMEND)
out SPH , r24
ser r24 								; initialize PORTA for output
out DDRA , r24
clr r26 								; clear time counter

main: 

	out PORTA , r26
	ldi r24 , low(1000) 					; load r25:r24 with 1000
	ldi r25 , high(1000) 					; delay 1 second
											;rcall wait_msec
	inc r26 								; increment time counter, one second passed
	cpi r26 , 16 							; compare time counter with 16
	brlo main 								; if lower goto main, else clear time counter
	clr r26 								; and then goto main
	rjmp main

wait_msec:
	push r24 								; 2 ������ (0.250 �sec)
	push r25 								; 2 ������
	ldi r24 , low(998) 						; ������� ��� �����. r25:r24 �� 998 (1 ������ - 0.125 �sec)
	ldi r25 , high(998) 					; 1 ������ (0.125 �sec)
	rcall wait_usec 						; 3 ������ (0.375 �sec), �������� �������� ����������� 998.375 �sec
	pop r25 								; 2 ������ (0.250 �sec)
	pop r24 								; 2 ������
	sbiw r24 , 1 							; 2 ������
	brne wait_msec 							; 1 � 2 ������ (0.125 � 0.250 �sec)
	ret 									; 4 ������ (0.500 �sec)

wait_usec:
	sbiw r24 ,1 							; 2 ������ (0.250 �sec)
	nop 									; 1 ������ (0.125 �sec)
	nop 									; 1 ������ (0.125 �sec)
	nop 									; 1 ������ (0.125 �sec)
	nop 									; 1 ������ (0.125 �sec)
	brne wait_usec 							; 1 � 2 ������ (0.125 � 0.250 �sec)
	ret 									; 4 ������ (0.500 �sec)