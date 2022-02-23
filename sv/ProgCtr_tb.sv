`timescale 1ns/ 1ps

//Test bench
// Instruction Fetch (pc + instruction ROM)

module ProgCtr_tb;

bit Reset = 'b1; 
bit Clk = 'b1;
bit Eq, Neq, Zero, Start, OffsetEn;
// logic [8:0] InstOut, expected;
wire [9:0] ctr;
logic [1:0] PCRegAddr;
logic [7:0] offset;


// CONNECTIONS
ProgCtr pc(
    .Reset(Reset),  
    .Start(Start), 
    .Clk(Clk),      
    .JmpEq(Eq), 
    .JmpNe(Neq), 
    .Zero(Zero),  
    .OffsetEn(OffsetEn),
    .PCRegAddr(PCRegAddr), 
	 .offset(offset),
    .ProgCtr(ctr) 
  );



initial begin

  {Start, Eq, Neq, Zero, OffsetEn} = 0;   // initializing inputs
  #10ns
  Reset = 0;
  $display("PC: %d", ctr);
  offset = 100;
  PCRegAddr = 'b01;
  
  #10ns
  $display("PC: %d", ctr);
  Eq = 1;
  Zero = 1;
  OffsetEn = 1;
 
  #10ns;
  OffsetEn = 0;
  
  #50ns;
  $display("PC: %d", ctr); // Show jump
  Eq = 0;
  Zero = 0;
  
  #90ns;
  $display("PC: %d", ctr); // Let counter run
  offset = 25;
  PCRegAddr = 'b10;
  #10ns
  Neq = 1;
  OffsetEn = 1;
 
  #10ns;
  OffsetEn = 0;
  #10ns;
  $display("PC: %d", ctr); // Show jump

 
  #30ps;

  end

/* task test_fetch;
 begin
  if(expected == InstOut) 
    $display("YAY!! Inst: %b", InstOut);
  else $display("UH oh!! Inst: %b", InstOut);
  end
endtask 

task not_taken;
 begin
  if(expected != InstOut) 
    $display("YAY!! Inst %b not taken", InstOut);
  else $display("UH oh!! Inst %b was taken", InstOut);
  end
endtask */

always begin   
  #5ns  Clk = ~Clk;
end

endmodule