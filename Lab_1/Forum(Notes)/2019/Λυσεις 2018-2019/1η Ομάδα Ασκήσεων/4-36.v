// Περιγραφή Verilog με μοντελοποίηση επιπέδου πυλών
// για το πρόβλημα 4-36 (σχήμα 4.23)
module Circuit_4_36_gates (x, y, V, D);
	output x, y, V;
	input [3:0]D;
	wire w1, w2;
	
	not
		G1(w1, D[2]);
	and
		G2(w2, w1, D[1]);
	or
		G3(y, D[3], w2),
		G4(x, D[3], D[2]),
		G5(V, x, D[1], D[0]);
endmodule
