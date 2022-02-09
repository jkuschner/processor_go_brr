`timescale 1ns/ 1ps

// Test bench
// Look up table
/*
* INPUT: pFlip (0000_p8_p4_p2_p1)
* OUTPUT: bFlip
* This only runs tests on LUT_LSW. LUT_MSW follows the same concept/implementation so if LUT_LSW works it can be assumed that LUT_MSW does as well.
*/

module LUT_tb;
logic [7:0] PFLIP;
wire  [7:0] BFLIP;
logic [7:0] expected;
logic [7:0] flipped;

// CONNECTION
LUT_LSW lutLsw(
  .pFlip(PFLIP),
  .bFlip(BFLIP)
  );
  
initial begin
  // TEST IF B1 WAS FLIPPED
  flipped = 1;
  PFLIP = 'b00000011;
  test_lut_func;
  #5;
  
  // more tests? ...
end
  
task test_lut_func;
begin
      case(flipped)
      // add cases along with further tests later
        1: expected = 'b00000001; // b1 flipped
      endcase
      #1; if(expected == BFLIP)
            begin
              $display("%t YAY!! inputs = %h %h, opcode = %b, Zero %b",$time, INPUTA,INPUTB,op, Zero);
            end
          else begin 
              $display("%t FAIL! inputs = %h %h, opcode = %b, zero %b",$time, INPUTA,INPUTB,op, Zero);
            end
end
endtask
  
endmodule
