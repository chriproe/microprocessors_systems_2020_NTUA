// Περιγραφή Verilog με μοντελοποίηση ροής δεδομένων
// για το πρόβλημα 3-32, σχήμα 3.25
module Circuit_3_25_dataflow (F, A, B, C, D);
	output F;
	input A, B, C, D;
	
	assign F=(!(!(((!(!A))&&(!B))||((!A)&&(!(!B))))))&&(!(!(C||(!D))));
endmodule
