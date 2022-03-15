// Module Name:    InstROM 
// Description: Instruction ROM with instruction values (case statement)

/*
Input: InstAddress(from Program Counter): Address of the instruction to be read and sent to the decoder

Output: InstOut(send to Decoder): The machine code instruction located at the given address. Ultimately, it will be produced by our assembler and read from a file.
*/
module InstROM #(parameter A=10, W=9) (
  input [A-1:0] InstAddress,
  output logic[W-1:0] InstOut);
	 
// Uncomment this part if reading from machine_code.txt
// Second option (usually recommended) alternative expression
//   need $readmemh or $readmemb to initialize all of the elements
// declare 2-dimensional array, W bits wide, 2**A words deep
  logic[W-1:0] inst_rom[2**A];
  
  always_comb InstOut = inst_rom[InstAddress];
 
  /* Load instruction memory from external file
  initial begin
	$readmemb("C:\Users\optim\OneDrive\Desktop\processor_go_brr-main\sv\program1_machine_code.txt",inst_rom);
	
  end */
  
  
endmodule
