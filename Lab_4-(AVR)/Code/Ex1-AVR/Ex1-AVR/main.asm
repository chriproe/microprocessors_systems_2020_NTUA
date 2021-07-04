;Ex1Lab4 - AVR

.include "m16def.inc"

	ldi r24, low(RAMEND)	; initialize stack pointer
	out	SPL, r24
	ldi r24, high(RAMEND)
	out SPH, r24

	clr	r24
	out DDRB, r24	;PORT B - input
	ser r24
	out DDRA, r24	;PORTA - output

	clr r24			;count LEDs
	ldi	r25, 0x01	
	
GO_LEFT:
	in r26, PINB	;input in r26
	andi r26, 0x01	;keep PB0
	cpi	r26, 0x01	;check if PB0 is 1
	breq GO_LEFT	;if it is, stop
	out	PORTA, r25	;turn on LSB
	inc	r24			;r24++
	lsl r25			;left rotation (r25 == 0x02 - first rotation)
	cpi r24, 7		;check if r24 == 7
	breq GO_RIGHT	;if so, MSB is turned on - rotate and go right
	rjmp GO_LEFT	;if not, keep going left

GO_RIGHT:
	in r26, PINB	
	andi r26, 0x01
	cpi r26, 0x01
	breq GO_RIGHT
	out PORTA, r25
	dec r24			;r24 --
	lsr r25			;right rotation
	cpi r24, 0		;check if r24 == 0
	breq GO_LEFT	;if so, LSB is turned on - rotate and go left
	rjmp GO_RIGHT	;if not, keep going right

