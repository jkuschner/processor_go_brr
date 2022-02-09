/*
  In Program 2, we calculated the parity bits based on the data bits stored in memory and we extracted the parity bits that were already in memory.

  Input: 8-bit register that is the result of xor'ing the 2 parity registers.
  Output: 8-bit value that is all 0's except for the bit that is supposed to be flipped based on the discrepancies in the parity registers.
*/

module LUT_MSW(
	input       [7:0] pFlip;
	output logic[7:0] bFlip;
	);
	
// NOTE: This is specifically the LSW LUT (LUTs are limited to 16 elements each, so we need one per MSW/LSW)
// pFlip is 0000_p8_p4_p2_p1
always_comb begin
	case(pFlip)
    8'b00000011:  bFlip = 8'b00000001; // flip b1
    8'b00000100:  bFlip = 8'b00000100; // flip b3
    8'b00000101:  bFlip = 8'b00000010; // flip b2
    8'b00000111:  bFlip = 8'b00001000; // flip b4
    8'b00001001:  bFlip = 8'b00010000; // flip b5
    8'b00001010:  bFlip = 8'b00100000; // flip b6
    8'b00001011:  bFlip = 8'b01000000; // flip b7
    8'b00001100:  bFlip = 8'b10000000; // flip b8
		default:      bFlip = 8'b00000000; // no flip needed
	endcase
end
	
/* Cases based on this table:
   | b11  b10  b9  b8  b7  b6  b5  b4  b3  b2  b1
p8 | x    x    x   x   x   x   x
p4 | x    x    x   x               x   x   x
p2 | x    x            x   x       x           x
p1 | x         x       x       x   x       x   x
*/
	
/*CAN CHOOSE TO DELETE THIS LATER, KEPT FOR REFERENCE:
   CSE141L
   possible lookup table for PC target
   leverage a few-bit pointer to a wider number
   Lookup table acts like a function: here Target = f(Addr);
 in general, Output = f(Input); lots of potential applications 

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
*/

endmodule
