`timescale 1ns/ 1ps

//Test bench
// Instruction ROMß

module InstROM_tb;

bit Clk = 'b1;
logic [9:0] DestAddr;
logic [8:0] InstOut, expected;


// CONNECTION
InstROM insr(
  .InstAddress(DestAddr),
  .InstOut(InstOut)
  );


initial begin
  #10ps
  DestAddr = 100;     //  instr rom[100]: InstOut = 'b001_011_010;
  expected = 'b001_011_010;
  #10ps
  test_instROM;


  #100ps
  DestAddr = 50;     //  instr rom[50]: InstOut = 'b000_001_100;
  expected = 'b000_001_100;
  #10ps
  test_instROM;

  #100ps
  DestAddr = 4;
  expected = 'b01000_100_0;
  #10ps
  test_instROM;

  #100ps
  DestAddr = 60;
  expected = 'b000_011_101;
  #10ps
  test_instROM;

  #30ps;

  end

task test_instROM;
 begin
  if(expected == InstOut) 
    $display("YAY!! Inst: %b", InstOut);
  else $display("UH oh!! Inst: %b", InstOut);
  end
endtask 

always begin   
  #5ns  Clk = ~Clk;
end

endmodule