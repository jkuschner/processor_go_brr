// Module Name:    InstROM 
// Description: Instruction ROM with instruction values (case statement)

/*
Input: InstAddress(from Program Counter): Address of the instruction to be read and sent to the decoder

Output: InstOut(send to Decoder): The machine code instruction located at the given address. Ultimately, it will be produced by our assembler and read from a file.
*/
module InstROM #(parameter A=10, W=9) (
  input [A-1:0] InstAddress,
  output logic[W-1:0] InstOut);
	 
// First option - manually populating instructions
  always_comb begin 
	InstOut = 'b000_000_000;  // default
	case (InstAddress)
//opcode = 8 load, rt = 0-7
      0 : InstOut = 'b01000_000_0; // load from addr at r1 to rt
      1 : InstOut = 'b01000_001_0;
      2 : InstOut = 'b01000_010_0;
      3 : InstOut = 'b01000_011_0;
      4 : InstOut = 'b01000_100_0;
      5 : InstOut = 'b01000_101_0;
      6 : InstOut = 'b01000_110_0;
      7 : InstOut = 'b01000_111_0;

// opcode = 9 str, rt = 0-7
      8 : InstOut = 'b01001_000_0; // str into the addr at r1 from rt
      9 : InstOut = 'b01001_001_0;
      10 : InstOut = 'b01001_010_0;
      11 : InstOut = 'b01001_011_0;
      12 : InstOut = 'b01001_100_0;
      13 : InstOut = 'b01001_101_0;
      14 : InstOut = 'b01001_110_0;
      15 : InstOut = 'b01001_111_0;

// opcode = 0 lsl, rs = 0-7, rt = 0-7
      16 : InstOut = 'b000_000_000;
      17 : InstOut = 'b000_001_000;
      18 : InstOut = 'b000_010_000;
      19 : InstOut = 'b000_011_000;
      20 : InstOut = 'b000_100_000;
      21 : InstOut = 'b000_101_000;
      22 : InstOut = 'b000_110_000;
      23 : InstOut = 'b000_111_000;
      24 : InstOut = 'b000_000_001;
      25 : InstOut = 'b000_001_001;
      26 : InstOut = 'b000_010_001;
      27 : InstOut = 'b000_011_001;
      28 : InstOut = 'b000_100_001;
      29 : InstOut = 'b000_101_001;
      30 : InstOut = 'b000_110_001;
      31 : InstOut = 'b000_111_001;
      32 : InstOut = 'b000_000_010;
      34 : InstOut = 'b000_001_010;
      35 : InstOut = 'b000_010_010;
      36 : InstOut = 'b000_011_010;
      37 : InstOut = 'b000_100_010;
      38 : InstOut = 'b000_101_010;
      39 : InstOut = 'b000_110_010;
      40 : InstOut = 'b000_111_010;
      41 : InstOut = 'b000_000_011;
      42 : InstOut = 'b000_001_011;
      43 : InstOut = 'b000_010_011;
      44 : InstOut = 'b000_011_011;
      45 : InstOut = 'b000_100_011;
      46 : InstOut = 'b000_101_011;
      47 : InstOut = 'b000_110_011;
      48 : InstOut = 'b000_111_011;
      49 : InstOut = 'b000_000_100;
      50 : InstOut = 'b000_001_100;
      51 : InstOut = 'b000_010_100;
      52 : InstOut = 'b000_011_100;
      53 : InstOut = 'b000_100_100;
      54 : InstOut = 'b000_101_100;
      55 : InstOut = 'b000_110_100;
      56 : InstOut = 'b000_111_100;
      57 : InstOut = 'b000_000_101;
      58 : InstOut = 'b000_001_101;
      59 : InstOut = 'b000_010_101;
      60 : InstOut = 'b000_011_101;
      61 : InstOut = 'b000_100_101;
      62 : InstOut = 'b000_101_101;
      63 : InstOut = 'b000_110_101;
      64 : InstOut = 'b000_111_101;
      65 : InstOut = 'b000_000_110;
      66 : InstOut = 'b000_001_110;
      67 : InstOut = 'b000_010_110;
      68 : InstOut = 'b000_011_110;
      69 : InstOut = 'b000_100_110;
      70 : InstOut = 'b000_101_110;
      71 : InstOut = 'b000_110_110;
      72 : InstOut = 'b000_111_110;
      73 : InstOut = 'b000_000_111;
      74 : InstOut = 'b000_001_111;
      75 : InstOut = 'b000_010_111;
      76 : InstOut = 'b000_011_111;
      77 : InstOut = 'b000_100_111;
      78 : InstOut = 'b000_101_111;
      79 : InstOut = 'b000_110_111;
      80 : InstOut = 'b000_111_111;

// opcode = 1 lsr, rs = 0-7, rt = 0-7
      81 : InstOut = 'b001_000_000;
      82 : InstOut = 'b001_001_000;
      83 : InstOut = 'b001_010_000;
      84 : InstOut = 'b001_011_000;
      85 : InstOut = 'b001_100_000;
      86 : InstOut = 'b001_101_000;
      87 : InstOut = 'b001_110_000;
      88 : InstOut = 'b001_111_000;
      89 : InstOut = 'b001_000_001;
      90: InstOut = 'b001_001_001;
      91: InstOut = 'b001_010_001;
      92: InstOut = 'b001_011_001;
      93: InstOut = 'b001_100_001;
      94: InstOut = 'b001_101_001;
      95: InstOut = 'b001_110_001;
      96: InstOut = 'b001_111_001;
      97: InstOut = 'b001_000_010;
      98: InstOut = 'b001_001_010;
      99: InstOut = 'b001_010_010;
      100: InstOut = 'b001_011_010;
      101: InstOut = 'b001_100_010;
      102: InstOut = 'b001_101_010;
      103: InstOut = 'b001_110_010;
      104: InstOut = 'b001_111_010;
      105: InstOut = 'b001_000_011;
      106: InstOut = 'b001_001_011;
      107: InstOut = 'b001_010_011;
      108: InstOut = 'b001_011_011;
      109: InstOut = 'b001_100_011;
      110: InstOut = 'b001_101_011;
      111: InstOut = 'b001_110_011;
      112: InstOut = 'b001_111_011;
      113: InstOut = 'b001_000_100;
      114: InstOut = 'b001_001_100;
      115: InstOut = 'b001_010_100;
      116: InstOut = 'b001_011_100;
      117: InstOut = 'b001_100_100;
      118: InstOut = 'b001_101_100;
      119: InstOut = 'b001_110_100;
      120: InstOut = 'b001_111_100;
      121: InstOut = 'b001_000_101;
      122: InstOut = 'b001_001_101;
      123: InstOut = 'b001_010_101;
      124: InstOut = 'b001_011_101;
      125: InstOut = 'b001_100_101;
      126: InstOut = 'b001_101_101;
      127: InstOut = 'b001_110_101;
      128: InstOut = 'b001_111_101;
      129: InstOut = 'b001_000_110;
      130: InstOut = 'b001_001_110;
      131: InstOut = 'b001_010_110;
      132: InstOut = 'b001_011_110;
      133: InstOut = 'b001_100_110;
      134: InstOut = 'b001_101_110;
      135: InstOut = 'b001_110_110;
      136: InstOut = 'b001_111_110;
      137: InstOut = 'b001_000_111;
      138: InstOut = 'b001_001_111;
      139: InstOut = 'b001_010_111;
      140: InstOut = 'b001_011_111;
      141: InstOut = 'b001_100_111;
      142: InstOut = 'b001_101_111;
      143: InstOut = 'b001_110_111;
      144: InstOut = 'b001_111_111;

// opcode = 13 or, rs = 0-7, rt = 0-3
      145: InstOut = 'b110_1_000_00;
      146: InstOut = 'b110_1_001_00;
      147: InstOut = 'b110_1_010_00;
      148: InstOut = 'b110_1_011_00;
      149: InstOut = 'b110_1_100_00;
      150: InstOut = 'b110_1_101_00;
      151: InstOut = 'b110_1_110_00;
      152: InstOut = 'b110_1_111_00;

      153: InstOut = 'b110_1_000_01;
      154: InstOut = 'b110_1_001_01;
      155: InstOut = 'b110_1_010_01;
      156: InstOut = 'b110_1_011_01;
      157: InstOut = 'b110_1_100_01;
      158: InstOut = 'b110_1_101_01;
      159: InstOut = 'b110_1_110_01;
      160: InstOut = 'b110_1_111_01;

      161: InstOut = 'b110_1_000_10;
      162: InstOut = 'b110_1_001_10;
      163: InstOut = 'b110_1_010_10;
      164: InstOut = 'b110_1_011_10;
      165: InstOut = 'b110_1_100_10;
      166: InstOut = 'b110_1_101_10;
      167: InstOut = 'b110_1_110_10;
      168: InstOut = 'b110_1_111_10;

      169: InstOut = 'b110_1_000_11;
      170: InstOut = 'b110_1_001_11;
      171: InstOut = 'b110_1_010_11;
      172: InstOut = 'b110_1_011_11;
      173: InstOut = 'b110_1_100_11;
      174: InstOut = 'b110_1_101_11;
      175: InstOut = 'b110_1_110_11;
      176: InstOut = 'b110_1_111_11;  
      
// opcode = 6 xor, rt = 0-7
      177: InstOut = 'b0110_000_00;
      178: InstOut = 'b0110_001_00;
      179: InstOut = 'b0110_010_00;
      180: InstOut = 'b0110_011_00;
      181: InstOut = 'b0110_100_00;
      182: InstOut = 'b0110_101_00;
      183: InstOut = 'b0110_110_00;
      184: InstOut = 'b0110_111_00;

// opcode = 7 rxr, rt = 0-7
      185: InstOut = 'b011_1_000_00;
      186: InstOut = 'b011_1_001_00;
      187: InstOut = 'b011_1_010_00;
      188: InstOut = 'b011_1_011_00;
      189: InstOut = 'b011_1_100_00;
      190: InstOut = 'b011_1_101_00;
      191: InstOut = 'b011_1_110_00;
      192: InstOut = 'b011_1_111_00;

// opcode = 14 add, rt = 0-7, imm = 0-3
      193: InstOut = 'b1110_00000;
      194: InstOut = 'b1110_00100;
      195: InstOut = 'b1110_01000;
      196: InstOut = 'b1110_01100;
      197: InstOut = 'b1110_10000;
      198: InstOut = 'b1110_10100;
      199: InstOut = 'b1110_11000;
      200: InstOut = 'b1110_11100;
      201: InstOut = 'b1110_00001;
      202: InstOut = 'b1110_00101;
      203: InstOut = 'b1110_01001;
      204: InstOut = 'b1110_01101;
      205: InstOut = 'b1110_10001;
      206: InstOut = 'b1110_10101;
      207: InstOut = 'b1110_11001;
      208: InstOut = 'b1110_11101;
      209: InstOut = 'b1110_00010;
      210: InstOut = 'b1110_00110;
      211: InstOut = 'b1110_01010;
      212: InstOut = 'b111001110;
      213: InstOut = 'b111010010;
      214: InstOut = 'b111010110;
      215: InstOut = 'b111011010;
      216: InstOut = 'b111011110;
      217: InstOut = 'b111000011;
      218: InstOut = 'b111000111;
      219: InstOut = 'b111001011;
      220: InstOut = 'b111001111;
      221: InstOut = 'b111010011;
      222: InstOut = 'b111010111;
      223: InstOut = 'b111011011;
      224: InstOut = 'b111011111;

// opcode = 15 mov, imm = 0-31
      225: InstOut = 'b111_1_00000;
      226: InstOut = 'b111_1_00001;
      227: InstOut = 'b111_1_00010;
      228: InstOut = 'b111_1_00011;
      229: InstOut = 'b111_1_00100;
      230: InstOut = 'b111_1_00101;
      231: InstOut = 'b111_1_00110;
      232: InstOut = 'b111_1_00111;
      233: InstOut = 'b111_1_01000;
      234: InstOut = 'b111_1_01001;
      235: InstOut = 'b111_1_01010;
      236: InstOut = 'b111_1_01011;
      237: InstOut = 'b111_1_01100;
      238: InstOut = 'b111_1_01101;
      239: InstOut = 'b111_1_01110;
      240: InstOut = 'b111_1_01111;
      241: InstOut = 'b111_1_10000;
      242: InstOut = 'b111_1_10001;
      243: InstOut = 'b111_1_10010;
      244: InstOut = 'b111_1_10011;
      245: InstOut = 'b111_1_10100;
      246: InstOut = 'b111_1_10101;
      247: InstOut = 'b111_1_10110;
      248: InstOut = 'b111_1_10111;
      249: InstOut = 'b111_1_11000;
      250: InstOut = 'b111_1_11001;
      251: InstOut = 'b111_1_11010;
      252: InstOut = 'b111_1_11011;
      253: InstOut = 'b111_1_11100;
      254: InstOut = 'b111_1_11101;
      255: InstOut = 'b111_1_11110;
      256: InstOut = 'b111_1_11111;

// opcode = 16 je, choice = 0-7
      257: InstOut = 'b100_00_000_0;
      258: InstOut = 'b100_00_001_0;
      259: InstOut = 'b100_00_010_0;
      260: InstOut = 'b100_00_011_0;
      261: InstOut = 'b100_00_100_0;
      262: InstOut = 'b100_00_101_0;
      263: InstOut = 'b100_00_110_0;
      264: InstOut = 'b100_00_111_0;

// opcode = 17 jne, choice = 0-7
      265: InstOut = 'b100_01_000_0;
      266: InstOut = 'b100_01_001_0;
      267: InstOut = 'b100_01_010_0;
      268: InstOut = 'b100_01_011_0;
      269: InstOut = 'b100_01_100_0;
      270: InstOut = 'b100_01_101_0;
      271: InstOut = 'b100_01_110_0;
      272: InstOut = 'b100_01_111_0;

 // opcode = 9 sbs, rt = 0-3, offset = 0-1
      273: InstOut = 'b1001_00_0_0;
      274: InstOut = 'b1001_01_0_0;
      275: InstOut = 'b1001_10_0_0;
      276: InstOut = 'b1001_11_0_0;
      277: InstOut = 'b1001_00_1_0;
      278: InstOut = 'b1001_01_1_0;
      279: InstOut = 'b1001_10_1_0;
      280: InstOut = 'b1001_11_1_0;

 // opcode = 10 lut, rt = 0-3, choice = 0-1
      281: InstOut = 'b1010_000_0_0;
      282: InstOut = 'b1010_001_0_0;
      283: InstOut = 'b1010_010_0_0;
      284: InstOut = 'b1010_011_0_0;
      285: InstOut = 'b1010_100_0_0;
      286: InstOut = 'b1010_101_0_0;
      287: InstOut = 'b1010_110_0_0;
      288: InstOut = 'b1010_111_0_0;

      289: InstOut = 'b1010_000_1_0;
      290: InstOut = 'b1010_001_1_0;
      291: InstOut = 'b1010_010_1_0;
      292: InstOut = 'b1010_011_1_0;
      293: InstOut = 'b1010_100_1_0;
      294: InstOut = 'b1010_101_1_0;
      295: InstOut = 'b1010_110_1_0;
      296: InstOut = 'b1010_111_1_0;

 // opcode = 11/0 ctc, rt = 0-3, regchoice = 0-3 
      297: InstOut = 'b1011_00_00_0;
      298: InstOut = 'b1011_00_01_0;
      299: InstOut = 'b1011_00_10_0;
      300: InstOut = 'b1011_00_11_0;

// opcode = 11/1 cti, rt = 0-3, regchoice = 0-3 
      301: InstOut = 'b1011_01_00_0;
      302: InstOut = 'b1011_01_01_0;
      303: InstOut = 'b1011_01_10_0;
      304: InstOut = 'b1011_01_11_0;

// opcode = 11/2 cts, rt = 0-3, regchoice = 0-3 
      305: InstOut = 'b1011_10_00_0;
      306: InstOut = 'b1011_10_01_0;
      307: InstOut = 'b1011_10_10_0;
      308: InstOut = 'b1011_10_11_0;

// opcode = 11/3 cbf, rt = 0-3, regchoice = 0-3 
      309: InstOut = 'b1011_11_00_0;
      310: InstOut = 'b1011_11_01_0;
      311: InstOut = 'b1011_11_10_0;
      312: InstOut = 'b1011_11_11_0;

// opcode = 'd010 sbs, rt = 0-7
      313: InstOut =   'b010_10_000_0;
      314: InstOut =   'b010_10_001_0;
      315: InstOut =   'b010_10_010_0;
      316: InstOut =   'b010_10_011_0;
      317: InstOut =   'b010_10_100_0;
      318: InstOut =   'b010_10_101_0;
      319: InstOut =   'b010_10_110_0;
      320: InstOut =   'b010_10_111_0;


// opcode = 'd011 dbs, rt = 0-7
      321: InstOut = 'b010_11_000_0;  
      322: InstOut = 'b010_11_001_0; 
      323: InstOut = 'b010_11_010_0;
      324: InstOut = 'b010_11_011_0;
      325: InstOut = 'b010_11_100_0;
      326: InstOut = 'b010_11_101_0;
      327: InstOut = 'b010_11_110_0;
      328: InstOut = 'b010_11_111_0;

//opcode 12 cpy, rt = 0-7
      329: InstOut = 'b110_0_000_00;
      330: InstOut ='b110_0_001_00;
      331: InstOut ='b110_0_010_00;
      332: InstOut ='b110_0_011_00;
      333: InstOut ='b110_0_100_00;
      334: InstOut ='b110_0_101_00;
      335: InstOut ='b110_0_110_00;
      336: InstOut ='b110_0_111_00;
      default: InstOut = 0;

    endcase
  end

// Uncomment this part if reading from machine_code.txt
// Second option (usually recommended) alternative expression
//   need $readmemh or $readmemb to initialize all of the elements
// declare 2-dimensional array, W bits wide, 2**A words deep
  /* logic[W-1:0] inst_rom[2**A];
  always_comb InstOut = inst_rom[InstAddress];
  // Load instruction memory from external file
  initial begin
  	// NOTE: This may not work depending on your simulator
	// e.g. Questa needs the file in path of the application .exe, it
	// doesn't care where you project code is
	//$readmemb("machine_code.txt",inst_rom);
	
	// So you are probably better off with an absolute path,
	// but you will have to change this example path when you
	// try this on your machine most likely:
	//$readmemb("//vmware-host/Shared Folders/Downloads/basic_proc2/machine_code.txt", inst_rom);
  end 
  */
//
  
endmodule
