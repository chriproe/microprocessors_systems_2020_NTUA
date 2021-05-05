// Περιγραφή Verilog με μοντελοποίηση επιπέδου πυλών
// για το πρόβλημα 3-31, σχήμα 3.25
module Circuit_3_25_gates (A, B, C, D, F);
	output F;
	input A, B, C, D;
	wire w1, w2, w3, w4, w5, w6, w7;
	
	not G1(w1, A), G2(w2, B), G3(w3, D);
	nand G4(w4, w1, B), G5(w5, A, w2), G8(F, w7, w6);
	nor G6(w6, C, w3), G7(w7, w4, w5);
endmodule
