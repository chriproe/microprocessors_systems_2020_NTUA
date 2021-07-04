#include <avr/io.h>

char x = 1;

int main(void)
{
	DDRC = 0x00;  // Αρχικοποίηση PORTC ως input
	DDRA = 0xFF; // Αρχικοποίηση PORTA ως output
	PORTA = x;  //  Θέτουμε output το x

    while (1) 
    {
		if(PINC == 1)  {       // Push Button SW0
			if  (x==128) x=1;
			else x=x<<1;      // ολίσθηση-περιστροφή του led αριστερά
		}
		else if(PINC == 2) {  //  Push Button SW1
			if (x==1) x=128;
			else x=x>>1;      // ολίσθηση-περιστροφή του led δεξιά
		}
	
		else if(PINC == 4)    // Push Button SW2
			x=128;			               // output -> MSB
		
		else if(PINC == 8)    // Push Button SW3
			x=1;                          // output -> 1st LSB	
	
		while(PINC!=0);                   // waiting to apply changes after release of button
		PORTA = x;            // show output

    }
}