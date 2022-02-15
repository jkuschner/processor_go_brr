`timescale 1ns/ 1ps

//Test bench
// Instruction Fetch (pc + instruction ROM)

module InstFetch_tb;

bit Reset = 'b1; 
bit Clk = 'b1;
bit Eq, Neq, Zero, Start;
logic [9:0] DestAddr;
logic [8:0] InstOut, expected;
wire [9:0] ctr;


// CONNECTIONS
ProgCtr pc(
    .Reset(Reset),  
    .Start(Start), 
    .Clk(Clk),      
    .JmpEq(Eq), 
    .JmpNe(Neq), 
    .Zero(Zero),  
    .DestAddr(DestAddr), 
    .ProgCtr(ctr) 
  );

InstROM insr(
  .InstAddress(ctr),
  .InstOut(InstOut)
  );


initial begin
Reset = 0;
  {Start, Eq, Neq, Zero, DestAddr, InstOut} = 0;   // initializing inputs
  #150ps; // testing program ctr incrementing
  $display("PC: %d", ctr);

  #10ps
  DestAddr = 100;     //  instr rom[100]: InstOut = 'b001_011_010;
  expected = 'b001_011_010;
  Zero = 1;
  Eq = 1;
  #10ps
  test_fetch;


  #100ps
  DestAddr = 50;     //  instr rom[50]: InstOut = 'b000_001_100;
  expected = 'b000_001_100;
  Eq = 0;
  Neq = 1;
  Zero = 0;
  #10ps
  test_fetch;

  #100ps
  DestAddr = 4;
  expected = 'b01000_100_0;
  Zero = 1;
  #10ps
  not_taken;

  #100ps
  DestAddr = 60;
  expected = 'b000_011_101;
  Zero = 0;
  Eq = 1;
  Neq = 0;
  #10ps
  not_taken;

  #30ps;

  end

task test_fetch;
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
endtask 

always begin   
  #5ns  Clk = ~Clk;
end

endmodule
