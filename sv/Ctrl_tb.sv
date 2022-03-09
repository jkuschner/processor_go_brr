import definitions::*;

`timescale 1ns/1ps

module Ctrl_tb;

logic [8:0] Instruction;
logic [1:0] SubstringIndex = 2'b00;

logic [1:0] PCRegSelect, PCRegSelect_e;
logic [2:0] WriteSource, WriteSource_e;
logic [3:0] ReadRegAddrA, ReadRegAddrA_e;
logic [3:0] ReadRegAddrB, ReadRegAddrB_e;
logic [3:0] WriteRegAddr, WriteRegAddr_e;
logic [3:0] ALUOp, ALUOp_e;
logic [7:0] ImmOut, ImmOut_e;
bit         JumpEqual, JumpEqual_e;
bit         JumpNotEqual, JumpNotEqual_e;
bit         OffsetEn, OffsetEn_e;
bit         RegWrEn, RegWrEn_e;
bit         MemWrEn MemWrEn_e;
bit         Ack, Ack_e;

// CONNECTIONS
Ctrl ctrl(
    .Instruction(Instruction),
    .SubstringIndex(SubstringIndex),
    .JumpEqual(JumpEqual),
    .JumpNotEqual(JumpNotEqual),
    .OffsetEn(OffsetEn),
    .RegWrEn(RegWrEn),
    .MemWrEn(MemWrEn),
    .Ack(Ack),
    .PCRegSelect(PCRegSelect),
    .WriteSource(WriteSource),
    .ReadRegAddrA(ReadRegAddrA),
    .ReadRegAddrB(ReadRegAddrB),
    .WriteRegAddr(WriteRegAddr),
    .ALUOp(ALUOp),
    .ImmOut(ImmOut)
);

initial begin
#5ps;
Instruction = 9'b01000_010_0; // load into r2
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b001;
ReadRegAddrA_e = 4'b0001;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = 4'b0010;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b01001_011_0; // store the data from r3
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = WriteSource;
ReadRegAddrA_e = 4'b0001;
ReadRegAddrB_e = 4'b0011;
WriteRegAddr_e = WriteRegAddr;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b0;
MemWrEn_e = 1'b1;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b000_100_101; //left shift contents of r5 and store result in r4
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b1000;
ReadRegAddrB_e = 4'b0101;
WriteRegAddr_e = 4'b0100;
ALUOp_e = kLSH;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b001_110_111; //right shift contents of r7 and store result in r6
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b1000;
ReadRegAddrB_e = 4'b0111;
WriteRegAddr_e = 4'b0110;
ALUOp_e = kRSH;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1101_010_10 // or data in r2 w/ data in r6 and store in r2
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0010;
ReadRegAddrB_e = 4'b0110;
WriteRegAddr_e = 4'b0010;
ALUOp_e = kORR;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b0111_011_00; //rxr data in r3 and store back into r3
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0011;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = 4'b0011;
ALUOp_e = kRXR;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1110_100_0_0; // add r4+r8 and store in r4
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0100;
ReadRegAddrB_e = 4'b1000;
WriteRegAddr_e = 4'b0100;
ALUOp_e = kADD;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1110_100_1_0; // subtract r4-r8 and store in r4
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0100;
ReadRegAddrB_e = 4'b1000;
WriteRegAddr_e = 4'b0100;
ALUOp_e = kSUB;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1111_11110; // mov an immi5 into r8
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b100;
ReadRegAddrA_e = ReadRegAddrA;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = 4'b1000;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b10000_01_00; // jump on equal to PCreg1
#5ps;
PCRegSelect_e = 2'b01;
WriteSource_e = WriteSource;
ReadRegAddrA_e = ReadRegAddrA;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = WriteRegAddr;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b1;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b0;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b10001_10_00; // jump not equal to PCreg2
#5ps;
PCRegSelect_e = 2'b10;
WriteSource_e = WriteSource;
ReadRegAddrA_e = ReadRegAddrA;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = WriteRegAddr;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b1;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b0;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1001_11_0_0; // store current PC into PCreg3
#5ps;
PCRegSelect_e = 2'b11;
WriteSource_e = WriteSource;
ReadRegAddrA_e = ReadRegAddrA;
ReadRegAddrB_e = 4'b1000;
WriteRegAddr_e = WriteRegAddr;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b0;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1001_01_1_0; // store current PC + offset into PCreg1
#5ps;
PCRegSelect_e = 2'b01;
WriteSource_e = WriteSource;
ReadRegAddrA_e = ReadRegAddrA;
ReadRegAddrB_e = 4'b1000;
WriteRegAddr_e = WriteRegAddr;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b1;
RegWrEn_e = 1'b0;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1010_010_0_0; // store value from LUT_LSW into r2
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b010;
ReadRegAddrA_e = 4'b0010;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = 4'b1000;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b1010_011_1_0; //store value from LUT_MSW into r3
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b011;
ReadRegAddrA_e = ReadRegAddrA;
ReadRegAddrB_e = 4'b0011;
WriteRegAddr_e = 4'b1000;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b101100_00_0; // clear r9
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0000; //r0 should always have 0
ReadRegAddrB_e = 4'b0000;
WriteRegAddr_e = 4'b1001;
ALUOp_e = kADD;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b101101_01_0; // increment r10
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b1000; //r8 needs to be 1
ReadRegAddrB_e = 4'b1010;
WriteRegAddr_e = 4'b1010;
ALUOp_e = kADD;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b101110_10_0; //store data in r11 into address in r15
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = WriteSource
ReadRegAddrA_e = 4'b1111;
ReadRegAddrB_e = 4'b1011;
WriteRegAddr_e = WriteRegAddr;
ALUOp_e = ALUOp;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b0;
MemWrEn_e = 1'b1;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b101111_000; // adds r12 to r0 w/o storing(just to set zero flag)
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = WriteSource
ReadRegAddrA_e = 4'b1100;
ReadRegAddrB_e = 4'b0000;
WriteRegAddr_e = WriteRegAddr;
ALUOp_e = kADD;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b0;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;










#5ps;
Instruction = 9'b 01010_111_0; // sbs r7, from index 0
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0101;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = 4'b0111;
ALUOp_e = 'b1000;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
SubstringIndex = 'b10;
Instruction = 9'b 01010_010_0; // sbs r2, from index 2
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0101;
ReadRegAddrB_e = ReadRegAddrB;
WriteRegAddr_e = 4'b0010;
ALUOp_e = '1001;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
SubstringIndex = 2'b11;
Instruction = 9'b 01011_011_0; // dbs r3; index 3
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0101;
ReadRegAddrB_e = 4'b0110;
WriteRegAddr_e = 4'b0011;
ALUOp_e = 'b1110;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
SubstringIndex = 2'b00;
Instruction = 9'b 01011_100_0; // dbs r4; index 0
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b0101;
ReadRegAddrB_e = 4'b0110;
WriteRegAddr_e = 4'b0100;
ALUOp_e = 'b1100;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

#5ps;
Instruction = 9'b 1100_100_00; // cpy r8 into r4
#5ps;
PCRegSelect_e = 2'b00;
WriteSource_e = 3'b000;
ReadRegAddrA_e = 4'b1000;
ReadRegAddrB_e = 4'b0000;
WriteRegAddr_e = 4'b0100;
ALUOp_e = 'b0000;
ImmOut_e = ImmOut;
JumpEqual_e = 1'b0;
JumpNotEqual_e = 1'b0;
OffsetEn_e = 1'b0;
RegWrEn_e = 1'b1;
MemWrEn_e = 1'b0;
Ack_e = 1'b0;
#5ps;
test_ctrl;

end

task test_ctrl;
    begin
    $display ("Checking Instruction: %b", Instruction);
    if (PCRegSelect != PCRegSelect_e)
        $display("PCRegSelect");
    if (WriteSource != WriteSource_e)
        $display("WriteSource");
    if (ReadRegAddrA != ReadRegAddrA_e)
        $display("ReadRegAddrA");
    if (ReadRegAddrB != ReadRegAddrB_e)
        $display("ReadRegAddrB");
    if (WriteRegAddr != WriteRegAddr_e)
        $display("WriteRegAddr");
    if (ALUOp != ALUOp_e)
        $display("ALUOp");
    if (ImmOut != ImmOut_e)
        $display("ImmOut");
    if (JumpEqual != JumpEqual_e)
        $display("JumpEqual");
    if (JumpNotEqual != JumpNotEqual_e)
        $display("JumpNotEqual");
    if (OffsetEn != OffsetEn_e)
        $display("OffsetEn");
    if (RegWrEn != RegWrEn_e)
        $display("RegWrEn");
    if (MemWrEn != MemWrEn_e)
        $display("MemWrEn");
    if (Ack != Ack_e)
        $display("Ack");
    $display("----");
end

endtask

endmodule