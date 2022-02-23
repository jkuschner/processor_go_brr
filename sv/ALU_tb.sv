`timescale 1ns/ 1ps

//Test bench
//Arithmetic Logic Unit
/*
* INPUT: A, B
* op: 000, A ADD B
* op: 100, A_AND B
* ...
* Pleaser refer to definitions.sv for support ops(make changes if necessary)
* OUTPUT A op B
* equal: is A == B?
* even: is the output even?
*/


module ALU_tb;
logic [ 7:0] INPUTA;        // data inputs
logic [ 7:0] INPUTB;
logic [ 2:0] op;  // ALU opcode, part of microcode
bit SC_IN = 'b0;
wire[ 7:0] OUT;
wire Zero;
logic [ 7:0] expected;

// CONNECTION
ALU uut(
  .InputA(INPUTA),
  .InputB(INPUTB),
  .SC_in(SC_IN),
  .OP(op),
  .Out(OUT),
  .Zero(Zero)
    );

initial begin
 // TESTING ADD
 INPUTA = 1;
 INPUTB = 1;
 op= 'b000;
 test_alu_func; // void function call
 #5;
  
 // TESTING LSH
 INPUTA = 'b00001000;
 INPUTB = 1;
 op= 'b001;
 test_alu_func;
 #5;
  
 // TESTING RSH
 INPUTA = 'b00001000;
 INPUTB = 1;
 op= 'b010;
 test_alu_func;
 #5;
  
 // TESTING XOR
 INPUTA = 'b00001111;
 INPUTB = 'b11110000;
 op= 'b011;
 test_alu_func;
 #5;
  
 // TESTING ORR
 INPUTA = 'b00001111;
 INPUTB = 'b11110000;
 op= 'b100;
 test_alu_func;
 #5;
  
 // TESTING SUB
 INPUTA = 4;
 INPUTB = 1;
 op= 'b101;
 test_alu_func;
 #5;
  
 // TESTING RXR
 INPUTA = 'b00000001;
 op= 'b111;
 test_alu_func;
 #5;
 
 // TESTING SBS2
 INPUTA = 'b00001101;
 op= 'b1001;
 test_alu_func;
 #5;
 
 // TESTING DBS3
 INPUTA = 'b10100001;
 INPUTB = 'b01101001;
 op= 'b1110;
 test_alu_func;
 #5;
 
 // TESTING SBS1
 INPUTA = 'b10100001;
 INPUTB = 'b01011001;
 op= 'b1000;
 test_alu_func;
 #5;
 
 // TESTING DB4
 INPUTA = 'b10101101;
 INPUTB = 'b01101011;
 op= 'b1111;
 test_alu_func;
 #5;
 end
  
 task test_alu_func;
 begin
   case (op)
  0: expected = INPUTA + INPUTB;      // ADD 
  1: expected = {INPUTA[6:0], SC_IN}; // LSH
  2: expected = {1'b0, INPUTA[7:1]};  // RSH
  3: expected = INPUTA ^ INPUTB;      // XOR
  4: expected = INPUTA | INPUTB;      // ORR
  5: expected = INPUTA - INPUTB;      // SUB
  7: expected = ^INPUTA;              // RXR
  8: expected = {INPUTA[4:0], 3'b000};  // SBS
  9: expected = {INPUTA[5:1], 3'b000};
  10: expected = {INPUTA[6:2], 3'b000};
  11: expected = {INPUTA[7:3], 3'b000};
  12: expected = {INPUTB[0], INPUTA[7:4], 3'b000}; //DBS
  13: expected = {INPUTB[1:0], INPUTA[7:5], 3'b000};
  14: expected = {INPUTB[2:0], INPUTA[7:6], 3'b000};
  15: expected = {INPUTB[3:0], INPUTA[7], 3'b000};
  default: expected = 0;
   endcase
   #1; if(expected == OUT)
  begin
   $display(" YAY!! inputs = %h %h, opcode = %b, Zero %b", INPUTA,INPUTB,op, Zero);
  end
     else begin $display(" FAIL! inputs = %h %h, opcode = %b, zero %b", INPUTA,INPUTB,op, Zero);end

 end
 endtask

endmodule
