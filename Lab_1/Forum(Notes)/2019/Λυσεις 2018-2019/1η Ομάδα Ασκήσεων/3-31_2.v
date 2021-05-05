// Περιγραφή Verilog με μοντελοποίηση επιπέδου πυλών
// για το πρόβλημα 3-31, σχήμα 3.21β
module Circuit_3_21b_gates (A, B, C, D, F);
	output F;
	input A, B, C, D;
	wire w1, w2, w3, w4, w5, w6, w7, w8;
	
	not G1(w1, A), G2(w2, B), G3(w3, C), G9(F, w8);
	nand G4(w4, A, w2), G5(w5, w1, B), G8(w8, w6, w7);
	nor G6(w7, w3, D), G7(w6, w4, w5);
endmodule
