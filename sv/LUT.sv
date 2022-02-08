/* CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 
*/

/*
  In Program 2, we calculated the parity bits based on the data bits stored in memory and we extracted the parity bits that were already in memory.

  Input: 8-bit register that is the result of xor'ing the 2 parity registers.
  Output: 8-bit value that is all 0's except for the bit that is supposed to be flipped based on the discrepencies in the parity registers.
*/

module LUT(
  input       [ 1:0] Addr,
  output logic[ 9:0] Target
  );

always_comb begin
  Target = 10'h001;	   // default to 1 (or PC+1 for relative)
  case(Addr)		   
	2'b00:   Target = 10'h3f0;   // -16, i.e., move back 16 lines of machine code
	2'b01:	 Target = 10'h003;
	2'b10:	 Target = 10'h007;
  endcase
end

endmodule