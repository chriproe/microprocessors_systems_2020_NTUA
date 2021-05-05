// Περιγραφή Verilog με μοντελοποίηση επιπέδου πυλών
// για το πρόβλημα 3-31, σχήμα 3.20α
module Circuit_3_20a_gates (A, B, C, D, F);
	output F;
	input A, B, C, D;
	wire w1, w2, w3, w4, w5;
	
	not G1 (w1, C);
	and G2 (w2, B, w1);
	and G3 (w3, C, D);
	or G4 (w4, w3, B);
	and G5 (w5, w4, A);
	or G6 (F, w5, w2);
endmodule
