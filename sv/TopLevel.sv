// Revision Date:    2020.08.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input     	Reset,	   // init/reset, active high
			    Start,     // start next program
	            Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );

wire [ 9:0] PgmCtr;        	// PC -> Inst_ROM
wire [ 1:0] PCRegAddr;		// decoder -> PC
wire 		JumpEq,			// decoder -> PC
			JumpNotEq,		// decoder -> PC
			OffsetEn;		// decoder -> PC
wire [ 8:0] Instruction;   	// our 9-bit opcode, Inst_ROM -> Ctrl
wire [ 7:0] RegOutA, 		// RegFile -> ALU, DataMem, LUT_LSW
			RegOutB;  		// RegFile -> ALU, DataMem, LUT_MSW, PC
wire [ 1:0] Reg3IndexOut;	// RegFile -> Ctrl
wire [ 7:0] RegWriteValue, 	// data in to reg file, 8:1 mux -> RegFile
	    	DataMemOut,  	// data out from data_memory, DataMem -> 8:1 mux
			ALU_out,       	// ALU -> 8:1 mux
			bFlip_MSW,		// LUT_MSW -> 8:1 mux
			bFlip_LSW,		// LUT_LSW -> 8:1 mux
			ImmOut;			// Ctrl -> 8:1 mux
wire [ 3:0] ReadRegAddrA,	// Ctrl -> RegFile
			ReadRegAddrB,	// Ctrl -> RegFile
			WriteRegAddr,	// Ctrl -> RegFile
			ALUOp;			// Ctrl -> ALU
wire [ 2:0] WriteSource,	// Ctrl -> 8:1 mux (only 5 used)
wire        MemWrite,		// data_memory write enable, Ctrl -> dataMem
	    	RegWrEn,	   	// reg_file write enable, Ctrl -> RegFile
	    	Zero,          	// ALU output = 0 flag, ALU -> PC
logic[15:0] CycleCt;	   	// standalone; NOT PC!

// Fetch stage = Program Counter + Instruction ROM
ProgCtr PC1 (		       // this is the program counter module
	.Reset        (Reset	   ) ,  // reset to 0
	.Start        (Start	   ) ,  
	.Clk          (Clk  	   ) ,  
	.JmpEq		  (JumpEq	   ) ,
	.JmpNe		  (JumpNotEq   ) ,
	.Zero	  	  (Zero    	   ) ,  // 
	.OffsetEn	  (OffsetEn	   ) ,
	.ProgCtr      (PgmCtr  	   )	   // program count = index to instruction memory
);					  

LUT_LSW LUTL(
	.pFlip        (RegOutA	   ) ,
    .bFlip        (bFlip_LSW   )
);

LUT_MSW LUTM(
	.pFlip        (RegOutB	   ) ,
    .bFlip        (bFlip_MSW   )
);

// instruction ROM -- holds the machine code pointed to by program counter
InstROM #(.W(9)) IR1(
	.InstAddress  (PgmCtr     ) , 
	.InstOut      (Instruction)
);

// Decode stage = Control Decoder + Reg_file
// Control decoder
Ctrl Ctrl1 (
	.SubstringIndex(Reg3IndexOut),
	.Instruction  (Instruction) ,  // from instr_ROM
	.JumpEqual	  (JumpEq     ) ,
	.JumpNotEqual (JumpNotEq  ) ,
	.OffsetEn	  (OffsetEn   ) ,
	.RegWrEn      (RegWrEn    )	,  // register file write enable
	.MemWrEn      (MemWrite   ) ,  // data memory write enable
    .Ack          (Ack        ) ,  // "done" flag
	.PCRegSelect  (PCRegAddr  ) ,
	.WriteSource  (WriteSource) ,
	.ReadRegAddrA (ReadRegAddrA),
	.ReadRegAddrB (ReadRegAddrB),
	.WriteRegAddr (WriteRegAddr),
	.ALUOp		  (ALUOp	  ) ,
	.ImmOut	  	  (ImmOut     )
);

// 5-input mux that selects RegFile input
MUX5 M5 (
	.ALU_m		  (ALU_out	  ) ,
	.data_mem_m	  (DataMemOut ) ,
	.LUT_LSW_m	  (bFlip_LSW  ) ,
	.LUT_MSW_m	  (bFlip_MSW  ) ,
	.ImmOut_m	  (ImmOut	  ) ,
	.muxSelect	  (WriteSource) ,
	.dataOut_m 	  (RegWriteValue)
);

// reg file
RegFile #(.W(8),.A(4)) RF1 (			  // A(3) makes this 2**3=8 elements deep
	.Clk	   (Clk			  ) ,
	.Reset     (Reset		  ) ,
	.WriteEn   (RegWrEn		  ) , 
	.RaddrA    (ReadRegAddrA  ) ,
	.RaddrB    (ReadRegAddrB  ) ,
	.Waddr     (WriteRegAddr  ) , // mux above
	.DataIn    (RegWriteValue ) , 
	.DataOutA  (RegOutA       ) , 
	.DataOutB  (RegOutB 	  )
);

ALU ALU1  (
	.InputA    (RegOutA		  ) ,
	.InputB    (RegOutB		  ) , 
	.OP        (ALUOp		  ) ,
	.Out       (ALU_out		  ) ,  	//regWriteValue),
	.Zero	   (Zero		  )	
);
  
	DataMem DM1(
		.DataAddress  (ReadB)    , 
		.WriteEn      (MemWrite), 
		.DataIn       (ReadA), 
		.DataOut      (MemReadValue)  , 
		.Clk 		  		     ,
		.Reset		  (Reset)
	);
	
/* count number of instructions executed
      not part of main design, potentially useful
      This one halts when Ack is high  
*/
always_ff @(posedge Clk)
  if (Reset)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule