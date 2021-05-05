// Περιγραφή Verilog με μοντελοποίηση ροής δεδομένων
// για το πρόβλημα 3-32, σχήμα 3.24
module Circuit_3_24_dataflow (F, A, B, C, D, E);
	output F;
	input A, B, C, D, E;
	
	assign F=(!(!(A||B)))&&(!(!(C||D)))&&(!(!E));
endmodule
