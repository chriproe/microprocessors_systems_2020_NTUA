// Περιγραφή Verilog με μοντελοποίηση ροής δεδομένων
// για το πρόβλημα 3-32, σχήμα 3.21α
module Circuit_3_21a_dataflow (F, A, B, C, D);
	output F;
	input A, B, C, D;
	
	assign F=((A&&(!B))||((!A)&&B))&&(C||(!D));
endmodule
