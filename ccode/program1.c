typedef unsigned char byte;
typedef int bit; //techincally a boolean

void program1(unsigned int* data_mem) {
    for (int i = 0; i < 30; i+=2) {
        byte parity;
        // calc p8
        byte LSW = data_mem[i];
        byte MSW = data_mem[i+1];

        byte tLSW = LSW >> 4;
        byte tMSW = MSW << 4;
        tMSW = tMSW | tLSW;
        parity = ^tMSW; //reduction xor
        parity = parity << 4; //parity = 000_p8_0000

        // calc p4
        LSW = data_mem[i];
        MSW = data_mem[i+1];

        tmp = MSW << 4; // tmp = b0_11:b9_0_000
        LSW = LSW >> 7; // LSW = 0000_000_b8
        LSW = LSW << 3; // LSW = 0000_b8_000
        tmp = tmp | LSW; // tmp = b11:b8_0000
        //TODO: finish parity calcs
        //...

        // parity = 000_p8_p4_p2_p1_p16;
        MSW = MSW << 5; // MSW = b11:b9_00000
        LSW = LSW >> 4; // LSW = 0000_b8:b5
        LSW = LSW << 1; // LSW = 000_b8:b5_0
        MSW = MSW | LSW; // MSW = b11:b5_0
        tmp = parity >> 4; // tmp = 0000000_p8
        MSW = MSW | parity; // MSW = b11:b5_p8;

        LSW = LSW >> 1; // LSW = 0_b8:b5_b4:b2
        LSW = LSW << 5; // LSW = b4:b2_00000
        tmp = parity << 4; // tmp = p4_p2_p1_p16_0000
        tmp = tmp >> 7; // tmp = 0000_000_p4
        tmp = tmp << 4; // tmp = 000_p4_0000
        LSW = LSW | tmp; // LSW = b4:b2_p4_0000
        byte tmp2 = data_mem[i]; // reload LSW
        tmp2 = tmp2 << 7; // tmp2 = b1_000_0000
        tmp2 = tmp2 >> 4; // tmp2 = 0000_b1_000
        LSW = LSW | tmp2; // LSW = b4:b2_p4_b1_000
        tmp = parity << 5; // tmp = p2:p1_p16_00000
        tmp = tmp >> 5; // tmp = 00000_p2:p1_p16
        LSW = LSW | tmp; //LSW = b4:b2_p4_b1_p2:p1_p16

        data_mem[i+30] = LSW;
        data_mem[i+31] = MSW;

    }


}