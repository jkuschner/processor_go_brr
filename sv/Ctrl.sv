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
  input[1:0]  SubstringIndex,  // lower 2-bits of r3(combinationally comes from reg_file)
                               // indicates position of substring to determine ALUOp for sbs and dbs instructions

  output logic  JumpEqual     , // tells PC if it's a je instruction
                JumpNotEqual  , // tells PC if it's a jne instruction
                OffsetEn      , // tells PC if it need to save address w/ offset
	              RegWrEn       ,	// write to reg_file (common)
	              MemWrEn       ,	// write to mem (store only)
	              Ack           ,	// "done w/ program"

  output logic [1:0] PCRegSelect,   // tells the PC which reg to use for saving/jumping address
                     // 00 -> no jump/save
                     // 01 -> jump/save with PCreg1
                     // 10 -> jump/save with PCreg2
                     // 11 -> jump/save with PCreg3

  output logic [2:0] WriteSource,   // tells top_level what data to route to the reg_file for writing
                    // if is 000 then input is from ALU
                    // if is 001 then input is from data_mem
                    // if is 010 then input is from lLUT
                    // if is 011 then input is from mLUT
                    // if is 100 then input is from ImmOut
  output logic [3:0] ReadRegAddrA,  // tells reg_file which register to read
                     ReadRegAddrB,
                     WriteRegAddr,  // tells reg_file which reg to write to
                     ALUOp       ,
  output logic [7:0] ImmOut         // wire to send immidieate data directly to reg file
);

always_comb begin
  // default to no jumping
  JumpEqual = '0;
  JumpNotEqual = '0;
  OffsetEn = 0;
  PCRegSelect = '0;
  // default to non-memory instructions
  MemWrEn = '0;
  RegWrEn = 0;
  // default to ALU input
  WriteSource = '0;
  // ImmOut is only used for mov instruction, so is always the same
  ImmOut = { 3'b000, Instruction[4:0]};

  if (Instruction[8:6] == 3'b000) begin // lsl instruction
    // shifts write to reg at addr inst[5:3]
    // data to be shifted is in at reg addr inst[2:0]
    // shift amount read from r8
    RegWrEn = '1;
    WriteRegAddr = {1'b0, Instruction[5:3]};
    ReadRegAddrA = 4'b1000; //r8
    ReadRegAddrB = {1'b0, Instruction[2:0]};
    ALUOp = kLSH;
  end else if (Instruction[8:6] == 3'b001) begin // lsr instruction
    // shifts write to reg at addr inst[5:3]
    // data to be shifted is in at reg addr inst[2:0]
    // shift amount read from r8
    RegWrEn = '1;
    WriteRegAddr = {1'b0, Instruction[5:3]};
    ReadRegAddrA = 4'b1000; //r8
    ReadRegAddrB = {1'b0, Instruction[2:0]};
    ALUOp = kRSH;
  end else if (Instruction[8:5] == 4'b1101) begin // or instruction
    // or writes to reg at addr inst[4:2]
    // other reg is 1'b1 + inst[1:0]
    RegWrEn = '1;
    WriteRegAddr = {1'b0, Instruction[4:2]};
    ReadRegAddrA = {1'b0, Instruction[4:2]};
    ReadRegAddrB = {2'b01, Instruction[1:0]};
    ALUOp = kORR;
  end else if (Instruction[8:5] == 4'b0110) begin // xor instruction
    // xor write to reg at addr inst[4:2]
    // other reg is r8
    RegWrEn = '1;
    WriteRegAddr = {1'b0, Instruction[4:2]};
    ReadRegAddrA = {1'b0, Instruction[4:2]};
    ReadRegAddrB = 4'b1000; // r8
    ALUOp = kXOR;
  end else if (Instruction[8:5] == 4'b0111) begin // rxr instruction
    //rxr writes to reg at addr inst[4:2]
    // reduction xor the data in that register
    RegWrEn = '1;
    WriteRegAddr = {1'b0, Instruction[4:2]};
    ReadRegAddrA = {1'b0, Instruction[4:2]};
    ALUOp = kRXR;
  end else if (Instruction[8:5] == 4'b1110) begin // add instruction
      // writes to reg at addr inst[4:2]
      // other operand comes from r8
      RegWrEn = '1;
      WriteRegAddr = {1'b0, Instruction[4:2]};
      ReadRegAddrA = {1'b0, Instruction[4:2]};
      ReadRegAddrB = 4'b1000; // r8
      if (Instruction[1] == 1'b0)
        ALUOp = kADD;
      else 
        // Negative should be applied to r8
        ALUOp = kSUB;
  end else if (Instruction[8:5] == 4'b1111) begin // mov instruction
      // writes inst[4:0] into r8 using ImmOut
      RegWrEn = 1;
      WriteRegAddr = 4'b1000; //write to r8
      WriteSource = 3'b100;
  end else if (Instruction[8:5] == 4'b1000) begin // je and jne instruction
      // set PCRegSelect to Instruction[3:2]
      PCRegSelect = Instruction[3:2];
      if(Instruction[4] == 0)
        JumpEqual = 1;
      else 
        JumpNotEqual = 1;
  end else if (Instruction[8:5] == 4'b1001) begin // spc instruction
      PCRegSelect = Instruction[4:3];
      OffsetEn = Instruction[2];
      ReadRegAddrB = 4'b1000;
  end else if (Instruction[8:5] == 4'b1010) begin // lut instruction
      RegWrEn = 1;
      WriteRegAddr = {1'b0, Instruction[4:2]}; // write to specified register
      if (Instruction[1] == 0) begin
        WriteSource = 3'b010; //tells regfile to read from LUT_LSW
        ReadRegAddrA = 4'b0110; // always read from r6
      end else begin
        WriteSource = 3'b011; // tells regfile to read from LUT_MSW
        ReadRegAddrB = 4'b0110; // always read from r6
      end
  end else if (Instruction[8:4] == 5'b01000) begin // load instruction
    RegWrEn = 1;
    WriteRegAddr = {1'b0, Instruction[3:1]};
    ReadRegAddrA = 4'b0001; //memory addr stored in r1
    WriteSource = 3'b001; //write to reg_file from datamem
  end else if (Instruction[8:4] == 5'b01001) begin // store instruction
    RegWrEn = 0;
    MemWrEn = 1;
    ReadRegAddrA = 4'b0001; //memory addr stored in r1
    ReadRegAddrB = {1'b0, Instruction[3:1]}; // reg addr that holds data to be stored
  end else if (Instruction[8:5] == 4'b1100) begin // cpy instruction
    RegWrEn = 1; 
    WriteRegAddr = {1'b0, Instruction[4:2]};
    ReadRegAddrA = 4'b1000; // adding r8 + 0
    ReadRegAddrB = 4'b0000; // r0 always contains 0
    WriteSource = 3'b000;
    ALUOp = kADD;
  end else if (Instruction[8:3] == 6'b101100) begin // ctc instruction
    RegWrEn = 1;
    WriteRegAddr = {2'b10, Instruction[2:1]} + 1'b1; // r9-12 are counter reg
    ReadRegAddrA = 4'b0000;
    ReadRegAddrB = 4'b0000; // essentially doing an add of 0+0 into r9
    WriteSource = 3'b000;
    ALUOp = kADD;
  end else if (Instruction[8:3] == 6'b101101) begin // cti instruction
    RegWrEn = 1;
    WriteRegAddr = {2'b10, Instruction[2:1]} + 1'b1;
    ReadRegAddrA = 4'b1000; //assumes r8 has 1
    ReadRegAddrB = {2'b10, Instruction[2:1]} + 1'b1;
    WriteSource = 3'b000;
    ALUOp = kADD;
  end else if (Instruction[8:3] == 6'b101110) begin // cts instruction
    RegWrEn = 0;
    MemWrEn = 1;
    ReadRegAddrA = {2'b11, Instruction[2:1]} + 1'b1; // r13-15 hold mem addresses
    ReadRegAddrB = {2'b10, Instruction[2:1]} + 1'b1; // r9-11 hold counter data
  end else if (Instruction[8:3] == 6'b101111) begin // cbf instruction
    // adds b_flag to 0. If bflag is 0, then zero flag is set. Otherwise zero flag is unset.
    RegWrEn = 0;
    ReadRegAddrA = 4'b1100; // r12 holds b_flag
    ReadRegAddrB = 4'b0000;
    ALUOp = kADD;
  end else if (Instruction[8:4] == 5'b01010) begin // sbs instruction
    RegWrEn = 1;
    WriteRegAddr = {1'b0, Instruction[3:1]};
    ReadRegAddrA = 4'b0101; // takes substring from r5
    WriteSource = 3'b000;
    case(SubstringIndex)
      0 : ALUOp = kSB1;
      1 : ALUOp = kSB2;
      2 : ALUOp = kSB3;
      3 : ALUOp = kSB4;
    endcase
  end else if (Instruction[8:4] == 5'b01011) begin // dbs instruction
    RegWrEn = 1;
    WriteRegAddr = {1'b0, Instruction[3:1]};
    ReadRegAddrA = 4'b0101; // takes part of substr from r5
    ReadRegAddrB = 4'b0110; // takes other part from r6
    WriteSource = 3'b000;
    case(SubstringIndex)
      0 : ALUOp = kDB1;
      1 : ALUOp = kDB2;
      2 : ALUOp = kDB3;
      3 : ALUOp = kDB4;
    endcase
  end
end

assign Ack = &Instruction;


endmodule

