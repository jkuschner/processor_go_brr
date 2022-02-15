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
  {Start, Eq, Neq, Zero, DestAddr, InstOut} = 0;   // initializing inputs
  #150ps; // testing program ctr incrementing
  $display("PC: %d", ctr);

  #10ps
  DestAddr = 100;     //  instr rom[100]: InstOut = 'b001_011_010;
  expected = 'b001_011_010;
  Zero = 1;
  Eq = 1;
  test_fetch;


  #10ps
  DestAddr = 50;     //  instr rom[50]: InstOut = 'b000_001_100;
  expected = 'b000_001_100;
  Eq = 0;
  Neq = 1;
  Zero = 0;
  test_fetch;

  #10ps
  expected = 0;
  Zero = 1;
  test_fetch;

  #10ps
  expected = 0;
  Zero = 0;
  Eq = 1;
  Neq = 0;
  test_fetch;

  #30ps;

  end

task test_fetch;
 begin
  if(expected == InstOut) 
  begin
   $display("@%t YAY!! Inst: %b", $time, InstOut);
  end
     else begin $display("@%t UH oh!! Inst: %b", $time, InstOut);

 end
endtask 

always begin   
  #5ps  Clk = ~Clk;
end

endmodule
