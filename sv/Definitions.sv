//This file defines the parameters used in the alu
// CSE141L
//	Rev. 2020.5.27
// import package into each module that needs it
//   packages very useful for declaring global variables
package definitions;
    
// Instruction map
    const logic [3:0]kADD  = 4'b0000;
    const logic [3:0]kLSH  = 4'b0001;
    const logic [3:0]kRSH  = 4'b0010;
    const logic [3:0]kXOR  = 4'b0011;
    const logic [3:0]kORR  = 4'b0100;
	const logic [3:0]kSUB  = 4'b0101;
	const logic [3:0]kCLR  = 4'b0110;
	const logic [3:0]kRXR  = 4'b0111;
    const logic [3:0]kSB1  = 4'b1000;
    const logic [3:0]kSB2  = 4'b1001;
    const logic [3:0]kSB3  = 4'b1010;
    const logic [3:0]kSB4  = 4'b1011;
    const logic [3:0]kDB1  = 4'b1100;
    const logic [3:0]kDB2  = 4'b1101;
    const logic [3:0]kDB3  = 4'b1110;
    const logic [3:0]kDB4  = 4'b1111;
// enum names will appear in timing diagram
    typedef enum logic[3:0] {
        ADD, LSH, RSH, XOR,
        ORR, SUB, CLR, RXR,
        SB1, SB2, SB3, SB4,
        DB1, DB2, DB3, DB4 } op_mne;
// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions
