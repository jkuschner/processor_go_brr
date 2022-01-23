typedef unsigned char byte;
typedef int bit; //techincally a boolean

void program2(unsigned int* data_mem, unsigned int* mLUT, 
                unsigned int * lLUT) {
    for(int i = 64; i < 94; i+=2) {
        byte LSW = data_mem[i]; // LSW = b4:2_p4_b1_p2:p1_p16
        byte MSW = data_mem[i+1];// MSW = b11:b5_p8

        byte parity, tLSW, tMSW, tmp;

        // set up parity
        parity = LSW << 5; // parity = p2:p1_p16_0_0000
        parity = parity >> 6; // parity = 0000_00_p2:p1
        tmp = LSW << 3; // tmp= p4_b1_p2:p1_p16_000
        tmp = tmp >> 7; // tmp = 0000_000_p4
        tmp = tmp << 2; // tmp = 0000_0_p4_00
        parity = parity | tmp; // parity = 0000_0_p4_p2:p1
        tmp = MSW << 7; // tmp = p8_000_0000
        tmp = tmp >> 4; // tmp = 0000_p8_000
        parity = parity | tmp; //parity = 0000_p8_p4_p2:p1 

        // set up tLSW
        tLSW = LSW << 4; //tLSW = b1_p2:p1_p16
        tLSW = tLSW >> 7; // tLSW = 0000_000_b1
        tmp = LSW >> 5; // tmp = 00000_b4:b2
        tmp = tmp << 1; // tmp = 0000_b4:b2_0
        tLSW = tLSW | tmp; //tLSW = 0000_b4:b1
        tmp = MSW >> 1; //tmp = 0_b11:b9_b8:b5
        tmp = MSW << 4; //tmp = b8:b5_0000
        tLSW = tLSW | tmp; //tLSW = b8:b1

        // set up tRSW
        tMSW = MSW >> 5; // tMSW = 00000_b11:b9

        byte nParity;
        // calc p8
        LSW = LSW >> 4;
        MSW = MSW << 4;
        byte tmp = MSW;
        tmp = tmp | LSW;
        bit p8 = ^tmp; //reduction xor

        // calc p4
        LSW = data_mem[i];
        MSW = data_mem[i+1];

        MSW = MSW << 4;
        tmp = MSW;
        //TODO: finish parity calcs
        //...

        //nParity = 0000_p8_p4_p2_p1 calculated from tLSW and tMSW

        byte mflip = mLUT[parity ^ nParity];
        byte lflip = lLUT[parity ^ nParity]; 

        MSW = MSW ^ mflip;
        LSW = LSW ^ lflip;

        data_mem[i+30] = LSW;
        data_mem[i+31] = MSW;
    }
}