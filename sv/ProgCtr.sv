// Design Name:    basic_proc
// Module Name:    InstFetch 
// Project Name:   CSE141L
// Description:    instruction fetch (pgm ctr) for processor
//
// Revision:  2019.01.27
//

/*
Inputs:
	Zero flag(from ALU): For both je and jne instructions
	Jump Equal(from decoder): On if decoder got a jump equal instruction
	Jump NotEqual(from decoder): On if decoder got a jne instruction
	Destination address(from the reg_file): Stored in 1 of 3 dedicated branching registers

Output: Updated Program Counter value

Functionality:

	If either Jump signals are on, then check ALU flag. If ALU flag says to jump, then update Program Counter to the value from the Destination Address input. Otherwise, increment Program Counter by 1.

*/
module ProgCtr #(parameter L=10) (
  input                Reset,      // reset, init, etc. -- force PC to 0
                       Start,      // Signal to jump to next program; currently unused 
                       Clk,        // PC can change on pos. edges only
                       BranchRel,  // jump to Target + PC
					        BranchAbs,  // jump to Target
							  ALU_flag,   // Zero flag only
  input        [L-1:0] Target,     // jump ... "how high?"
  output logic [L-1:0] ProgCtr     // the program counter register itself
  );
  
	 
  // program counter can clear to 0, increment, or jump
  always_ff @(posedge Clk)	           // or just always; always_ff is a linting construct
	if(Reset)
	  ProgCtr <= 0;				       // for first program; want different value for 2nd or 3rd
	else if(BranchAbs)	               // unconditional absolute jump
	  ProgCtr <= Target;			   //   how would you make it conditional and/or relative?
	else if(BranchRel)   // conditional relative jump
	  ProgCtr <= Target + ProgCtr;	   //   how would you make it unconditional and/or absolute
	else
	  ProgCtr <= ProgCtr+'b1; 	       // default increment (no need for ARM/MIPS +4 -- why?)

endmodule

