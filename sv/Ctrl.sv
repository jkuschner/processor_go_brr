// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)

/*
Output:
MemWrEn(to data_memory): set for store instructions(str and cts)
RegWrEn(to reg_file): set for all instructions that write to a register
ReadRegAddress(to reg_file): tell the reg_file which register it needs to read from
WriteRegAddress(to reg_file): tell the reg_file which register it needs to write to
JumpEqual(to program counter): set if its a je instruction
JumpNotEqual(to program counter): set if its a jne instruction
WriteSource(to top_level): will ultimately tell the reg_file where the the input is coming from(LUT, data_memory, or ALU).
ALUOp(to ALU): Tells the ALU which op it is doing on its input data.


*/
module Ctrl (
  input[ 8:0] Instruction,	   // machine code (comes from the Instruction ROM)

  output logic  JumpEqual     , // tells PC if it's a je instruction
                JumpNotEqual,   // tells PC if it's a jne instruction
               // BranchEn ,
	              RegWrEn  ,	   // write to reg_file (common)
	              MemWrEn  ,	   // write to mem (store only)
	              LoadInst	,	   // mem or ALU to reg_file ?
      	        StoreInst,          // mem write enable
	              Ack,		   // "done w/ program"

  output logic [1:0] TargSel       // Select signal for LUT
  output logic [2:0] ReadRegAddr,  // tells reg_file which register to read
                     WriteRegAddr, // tells reg_file which reg to write to
                     ALUOp,
  );

assign MemWrEn = Instruction[8:6]==3'b110;	 //111  110
assign StoreInst = Instruction[8:6]==3'b110;  // calls out store specially

assign RegWrEn = Instruction[8:7]!=2'b11;  // !111  !110 
assign LoadInst = Instruction[8:6] == 3'b011;
// reserve instruction = 9'b111111111; for Ack

// jump on right shift that generates a zero
// equiv to simply: assign Jump = Instrucxtion[2:0] == kRSH;
always_comb
  if(Instruction[2:0] ==  kRSH)
    Jump = 1;
  else
    Jump = 0;

// branch every time instruction = 9'b?????1111;
assign BranchEn = &Instruction[3:0];

// route data memory --> reg_file for loads
//   whenever instruction = 9'b110??????; 
assign TargSel  = Instruction[3:2];

assign Ack = &Instruction;

endmodule

