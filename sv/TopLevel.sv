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
wire [ 2:0] ReadRegAddrA,	// Ctrl -> RegFile
			ReadRegAddrB,	// Ctrl -> RegFile
			WriteRegAddr,	// Ctrl -> RegFile
			WriteSource;	// Ctrl -> 8:1 mux (only 5 used)
wire [ 3:0] ALUOp;			// Ctrl -> ALU
wire        MemWrite,		// data_memory write enable, Ctrl -> dataMem
	    	RegWrEn,	   	// reg_file write enable, Ctrl -> RegFile
	    	Zero,          	// ALU output = 0 flag, ALU -> PC
logic[15:0] CycleCt;	   	// standalone; NOT PC!

// Fetch stage = Program Counter + Instruction ROM
  ProgCtr PC1 (		       // this is the program counter module
	.Reset        (Reset   ) ,  // reset to 0
	.Start        (Start   ) ,  // SystemVerilog shorthand for .grape(grape) is just .grape 
	.Clk          (Clk     ) ,  //    here, (Clk) is required in Verilog, optional in SystemVerilog
	.BranchAbs    (Jump    ) ,  // jump enable
	.BranchRel    (BranchEn) ,  // branch enable
	.ALU_flag	  (Zero    ) ,  // 
	.Target       (PCTarg  ) ,  // "where to?" or "how far?" during a jump or branch
	.ProgCtr      (PgmCtr  )	   // program count = index to instruction memory
	);					  

LUT LUT1(.Addr         (TargSel ) ,
         .Target       (PCTarg  )
    );

// instruction ROM -- holds the machine code pointed to by program counter
  InstROM #(.W(9)) IR1(
	.InstAddress  (PgmCtr     ) , 
	.InstOut      (Instruction)
	);

// Decode stage = Control Decoder + Reg_file
// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction) ,  // from instr_ROM
	.Jump         (Jump       ) ,  // to PC to handle jump/branch instructions
	.BranchEn     (BranchEn   )	,  // to PC
	.RegWrEn      (RegWrEn    )	,  // register file write enable
	.MemWrEn      (MemWrite   ) ,  // data memory write enable
    .LoadInst     (LoadInst   ) ,  // selects memory vs ALU output as data input to reg_file
    .StoreInst    (StoreInst),
    .TargSel      (TargSel    ) ,  // index into lookup table 
    .Ack          (Ack        )	   // "done" flag
  );

// reg file
	RegFile #(.W(8),.A(3)) RF1 (			  // A(3) makes this 2**3=8 elements deep
		.Clk    				  ,
		.Reset     (Reset),
		.WriteEn   (RegWrEn)    , 
		.RaddrA    (Instruction[5:3]),        //concatenate with 0 to give us 4 bits
		.RaddrB    (Instruction[2:0]), 
		.Waddr     (Instruction[5:3]), 	      // mux above
		.DataIn    (RegWriteValue) , 
		.DataOutA  (ReadA        ) , 
		.DataOutB  (ReadB		 )
	);
/* one pointer, two adjacent read accesses: 
  (sample optional approach)
	.raddrA ({Instruction[5:3],1'b0});
	.raddrB ({Instruction[5:3],1'b1});
*/
    assign InA = ReadA;						  // connect RF out to ALU in
	assign InB = ReadB;	          			  // interject switch/mux if needed/desired
// controlled by Ctrl1 -- must be high for load from data_mem; otherwise usually low
	assign RegWriteValue = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB), 
	  .SC_in   (1'b1),
	  .OP      (Instruction[8:6]),
	  .Out     (ALU_out),//regWriteValue),
	  .Zero		                              // status flag; may have others, if desired
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