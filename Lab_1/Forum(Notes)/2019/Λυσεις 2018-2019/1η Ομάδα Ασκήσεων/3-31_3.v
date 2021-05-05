// Περιγραφή Verilog με μοντελοποίηση επιπέδου πυλών
// για το πρόβλημα 3-31, σχήμα 3.24
module Circuit_3_24_gates (A, B, C, D, E, F);
	output F;
	input A, B, C, D, E;
	wire w1, w2, w3;
	
	not G1(w1, E);
	nor G2(w2, A, B), G3(w3, C, D);
	nand G4(F, w2, w3);
endmodule
