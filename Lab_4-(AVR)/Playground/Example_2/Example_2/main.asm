reset: 
ldi r24 , low(RAMEND) ; ������������ stack pointer
out SPL , r24
ldi r24 , high(RAMEND)
out SPH , r24
ser r26 ; ������������ ��� PORTA
out DDRA , r26 ; ��� �����

flash: 
	rcall on ; ����� �� LEDs
	nop ; �� ��������������� ��������� �� 2 ������� nop
	nop ; ��� �������� ������������ 200 ms
	rcall off ; ����� �� LEDs
	nop ; �� ��������������� ��������� �� 2 ������� nop
	nop ; ��� �������� ������������ 200 ms
	rjmp flash ; ���������

; ���������� ��� �� ������� �� LEDs
on: 
	ser r26 ; ���� �� ���� ������ ��� LED
	out PORTA , r26
	ret ; ������ ��� ����� ���������

; ���������� ��� �� ������� �� LEDs
off: 
	clr r26 ; �������� �� ���� ������ ��� LED
	out PORTA , r26
	ret ; ������ ��� ����� ���������