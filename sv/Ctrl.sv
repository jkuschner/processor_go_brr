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

  output logic [1:0] WriteSource   // tells top_level what data to route to the reg_file for writing
  // if is 00 then input is from ALU
  // if is 01 then input is from data_mem
  // if is 10 then input is from lLUT
  // if is 11 then input is from mLUT
  output logic [2:0] ReadRegAddrA,  // tells reg_file which register to read
                     ReadRegAddrB,
                     WriteRegAddr, // tells reg_file which reg to write to
                     ALUOp,
  );

always_comb begin
  // default to no jumping
  JumpEqual = '0;
  JumpNotEqual = '0;
  // default to non-memory instructions
  MemWrEn = '0;
  LoadInst = '0;
  StoreInst = '0;
  // default to ALU input
  WriteSource = '00;

  if (Instruction[8:6] == 3'b000) begin // lsl instruction
    // shifts write to reg at addr inst[5:3]
    // data to be shifted is in at reg addr inst[2:0]
    // shift amount read from r8
    RegWrEn = '1;
    WriteRegAddr = Instruction[5:3];
    ReadRegAddrA = 3'b100; //r8
    ReadRegAddrB = Instruction[2:0];
    ALUOp = kLSH;
  end else if (Instruction[8:6] == 3'b001) begin // lsr instruction
    // shifts write to reg at addr inst[5:3]
    // data to be shifted is in at reg addr inst[2:0]
    // shift amount read from r8
    RegWrEn = '1;
    WriteRegAddr = Instruction[5:3];
    ReadRegAddrA = 3'b100; //r8
    ReadRegAddrB = Instruction[2:0];
    ALUOp = kRSH;
  end else if (Instruction[8:5] == 4'b1101) begin // or instruction
    // or writes to reg at addr inst[4:2]
    // other reg is 1'b1 + inst[1:0]
    RegWrEn = '1;
    WriteRegAddr = Instruction[4:2];
    ReadRegAddrA = Instruction[4:2];
    ReadRegAddrB = {1'b1, Instruction[1:0]};
    ALUOp = kORR;
  end else if (Instruction[8:5] == 4'b0110) begin // xor instruction
    // xor write to reg at addr inst[4:2]
    // other reg is r8
    RegWrEn = '1;
    WriteRegAddr = Instruction[4:2];
    ReadRegAddrA = Instruction[4:2];
    ReadRegAddrB = 3'b100; // r8
    ALUOp = kXOR;
  end else if (Instruction[8:5] == 4'b0111) begin // rxr instruction
    //rxr writes to reg at addr inst[4:2]
    // reduction xor the data in that register
    RegWrEn = '1;
    WriteRegAddr = Instruction[4:2];
    ReadRegAddrA = Instruction[4:2];
    ALUOp = kRXR;
  end else if (Instruction[8:5]) == 4'b1110) begin // add instruction
      // writes to reg at addr inst[4:2]
      // other operand comes from r8
      RegWrEn = '1;
      WriteRegAddr = Instruction[4:2];
      ReadRegAddrA = Instruction[4:2];
      ReadRegAddrB = 3'b100; // r8
      if (Instruction[1] == 1'b0)
        ALUOp = kADD;
      else 
        // Negative should be applied to r8
        ALUOp = kSUB;

  end
  
end
/*
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

*/
assign Ack = &Instruction;


endmodule

