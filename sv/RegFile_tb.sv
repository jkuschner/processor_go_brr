`timescale 1ns/ 1ps

//Test bench
// Register file
/*
* INPUT: 
* Please refer to definitions.sv for support ops(make changes if necessary)
* OUTPUT:
*/


module RegFile_tb;

bit Reset = 'b1; 
bit WriteEn;
bit Clk = 'b1;
logic [2:0] RaddrA, RaddrB;
logic [2:0] Waddr;
logic [7:0] DataIn;
logic [7:0] DataOutA, DataOutB;
// logic [7:0] expectedA, expectedB;


// CONNECTION
RegFile regfile(
  .Clk(Clk),
  .Reset(Reset),
  .WriteEn(WriteEn),
  .RaddrA(RaddrA),
  .RaddrB(RaddrB),
  .Waddr(Waddr),
  .DataIn(DataIn),
  .DataOutA(DataOutA),			 
  .DataOutB	(DataOutB)
);

initial begin
#10;
Reset = 'b0;
WriteEn = 'b1;
Waddr = 'b10;
DataIn = 'b10110;   // write 22 to reg 2
#10;
Waddr = 'b11;
DataIn = 'b10000;   // write 16 to reg 3
#10;

WriteEn = 'b0;
RaddrA = 'b10;
RaddrB = 'b11;
//test_regf;
#10;
$display("reg %d: %d, reg %d: %d", RaddrA, DataOutA, RaddrB, DataOutB);

WriteEn = 'b1;
Waddr = 'b01;
DataIn = 'b1000;   // write 8 to reg 1
#10;
Waddr = 'b111;
DataIn = 'b1111;   // write 15 to reg 7
#10;

WriteEn = 'b0;
RaddrA = 'b1;
RaddrB = 'b111;
//test_regf;
#10;
$display("reg %d: %d, reg %d: %d", RaddrA, DataOutA, RaddrB, DataOutB);

end
  
/*task test_regf;
 begin
   if(ExpA == DataOutA && ExpB == DataOutB) 
  begin
   $display("%t YAY!! reg %d: %d, reg %d: %d", $time, RaddrA, DataOutA, RaddrB, DataOutB);
  end
     else begin $display("%t YAY!! reg %d: %d, reg %d: %d", $time, RaddrA, DataOutA, RaddrB, DataOutB);end

 end
endtask */


always begin   
  #5ns  Clk = ~Clk;
end

endmodule
