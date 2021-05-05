// Περιγραφή Verilog με μοντελοποίηση συμπεριφοράς
// για το πρόβλημα 4-45 (σχήμα 4.23)
module Circuit_4_45_behavioral (x, y, V, D);
	output reg x, y, V;
	input [3:0]D;
	
	always @(D)
		if (D[3]) begin y=1; x=1; V=1; end
		if (D[2]) begin y=0; x=1; V=1; end
		if (D[1]) begin y=1; x=0; V=1; end
		if (D[0]) begin y=0; x=0; V=1; end
		else V=0;
endmodule
