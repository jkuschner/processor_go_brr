
// Module Name:    reg_file 

/*
Inputs: RaddrA/RaddrB/Waddr(from decoder)
        WriteEn(from decoder)
        DataIn(from ALU, from data_memory, from LUT)

Outputs: DataOutA/DataOutB(to ALU, to LUT, to data_memory, to Program Counter)
*/
module RegFile #(parameter W=8, A=4)(		 // W = data path width (leave at 8); A = address pointer width
  input                Clk,
                       Reset,
                       WriteEn,
  input        [3:0]   RaddrA,				 // address pointers
                       RaddrB,
                       Waddr,
  input        [W-1:0] DataIn,
  output logic [W-1:0] DataOutA,			 
  output logic [W-1:0] DataOutB,				 
  output logic [1:0]   Reg3IndexOut // sends lower 2 bits of r3 back to decoder
    );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] Registers[2**A];	             // or just registers[16] if we know A=4 always

// combinational reads 
always_comb begin
    DataOutA = Registers[RaddrA];	 
    DataOutB = Registers[RaddrB];   
    Reg3IndexOut = Registers[4'b0011][1:0]; 
end

// sequential (clocked) writes 
always_ff @ (posedge Clk) begin
  if (Reset) begin
    for(int i = 0; i < 16; i++)
	    Registers[i] <= 0;
  end else if (WriteEn) begin	                  
    Registers[Waddr] <= DataIn;
  end
end

endmodule
