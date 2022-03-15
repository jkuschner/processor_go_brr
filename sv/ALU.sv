// Create Date:    2018.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2021.07.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			          // includes package "definitions"

/*
Inputs: InputA/InputB(from reg file)
        OP(from decoder)
  NOTE: Possibly require another input for register 8? Doesn't seem necessary yet, depends on top level
Outputs: Out(goes to reg_file)
         Zero(goes to Prog_Ctr)
For shift operations, InputA is the data to be shifted, InputB is the shift amount.
Need to add an RXR ALU op and set signals accordingly.
*/
module ALU #(parameter W=8, Ops=4)(
  input        [W-1:0]   InputA,          // data inputs
                         InputB,
  input        [Ops-1:0] OP,		  // ALU opcode, part of microcode
  //input                  SC_in,           // shift or carry in
  output logic [W-1:0]   Out,		  // data output 
  output logic           Zero            // output = zero flag	 !(Out)
                         //Parity,          // outparity flag  ^(Out)
                        // Odd		  // output odd flag (Out[0])
// you may provide additional status flags, if desired
    );								    
	 
  op_mne op_mnemonic;			          // type enum: used for convenient waveform viewing
  always_comb begin
    Out = 0;                              // No Op = default
    case(OP)							  
      ADD : Out = InputA + InputB;        // add 
      LSH : Out = InputA << InputB;       // logical shift left (InputB is grabbed from r8)
      RSH : Out = InputA >> InputB;       // logical shift right (InputB is grabbed from r8)
      XOR : Out = InputA ^ InputB;        // bitwise XOR
      RXR : Out = ^InputA;                // reduction XOR
      SUB : Out = InputA + (~InputB) + 1; // sub
      ORR : Out = InputA | InputB;        // bitwise OR
      SB1 : Out = {InputA[4:0], 3'b000};  // write 5-bit substring into top 5 bits of output
      SB2 : Out = {InputA[5:1], 3'b000};
      SB3 : Out = {InputA[6:2], 3'b000};
      SB4 : Out = {InputA[7:3], 3'b000};
      DB1 : Out = {InputB[0], InputA[7:4], 3'b000};
      DB2 : Out = {InputB[1:0], InputA[7:5], 3'b000};
      DB3 : Out = {InputB[2:0], InputA[7:6], 3'b000};
      DB4 : Out = {InputB[3:0], InputA[7], 3'b000};
		default: Out = 0;
    endcase  
  end
  assign Zero = !Out;
 // assign Parity = ^Out;                   // reduction XOR
 // assign Odd    = Out[0];		  // odd/even -- just the value of the LSB

  //always_comb
  //  op_mnemonic = op_mne'(OP);			  // displays operation name in waveform viewer

endmodule
