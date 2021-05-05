// Περιγραφή Verilog με μοντελοποίηση ροής δεδομένων
// για το πρόβλημα 3-32, σχήμα 3.20β
module Circuit_3_20b_dataflow (F, A, B, C, D);
	output F;
	input A, B, C, D;
	
	assign F=(!(!(((!(!(C&&D)))||(!(!B)))&&A)))||(!(!(B&&(!C))));
endmodule
