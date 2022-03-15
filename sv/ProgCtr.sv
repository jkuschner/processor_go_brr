// Module Name:    ProgCtr
// Description:    instruction fetch (pgm ctr) for processor

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
  input     Reset,      // reset, init, etc. -- force PC to 0
			Start,      // Signal to jump to next program; currently unused 
            Clk,        // PC can change on pos. edges only
			JmpEq, 		// je (jump if equal) insn
			JmpNe,  	// jne (jump if not equal) insn
			Zero,  		// Zero flag only
			OffsetEn,	// enable offset mode
  input[1:0]	PCRegAddr,
  input[7:0]	offset,

  //input        [L-1:0] DestAddr,     // jump ... "how high?"
  output logic [L-1:0] ProgCtr     // the program counter register itself
  );

  logic [9:0] PCRegisters[3];

  always_comb begin
	if (!(JmpEq || JmpNe)) begin
	  if (OffsetEn) begin
		if (PCRegAddr == 2'b01)
			PCRegisters[0] = ProgCtr + offset;
		else if (PCRegAddr == 2'b10)
			PCRegisters[1] = ProgCtr + offset;
		else if (PCRegAddr == 2'b11)
			PCRegisters[2] = ProgCtr + offset;
	  end else begin
		if (PCRegAddr == 2'b01)
			PCRegisters[0] = ProgCtr;
		else if (PCRegAddr == 2'b10)
			PCRegisters[1] = ProgCtr;
		else if (PCRegAddr == 2'b11)
			PCRegisters[2] = ProgCtr;
	  end
	end  
  end
	 
  // program counter can clear to 0, increment, or jump
  always_ff @(posedge Clk)	           // or just always; always_ff is a linting construct
	  if(Reset || Start)
	  ProgCtr <= 0;				   
	else if(JmpEq && !Zero) begin	           // check if je and zero are set
	  ProgCtr <= PCRegisters[PCRegAddr - 1];
	end
	else if (JmpNe && Zero) begin		 // if jne is set + zero is not set		
	  ProgCtr <= PCRegisters[PCRegAddr - 1];
	end
	else
	  ProgCtr <= ProgCtr+'b1; 	       // default increment

endmodule
