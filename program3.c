typedef unsigned char byte;
typedef int bool;

void program3(unsigned int* data_mem) {
    byte pattern, act, bct, cct;
    pattern = data_mem[160];
    for( int i = 128; i < 160; i++) {
        bool b_flag;
        byte LSW = data_mem[i];
        if(i != 159) { // compare with xor
            byte MSW = data_mem[i+1];
        }

        for(int j = 0; j < 4; j++) {
            if(LSW[j:j+5] == pattern) {
                b_flag = 1;
                act++;
                cct++;
            }
        }

        if (b_flag) {
            bct++;
            b_flag = 0;
        }

        if(i != 159) { // compare with xor
            for(int j = 0; j < 4; j++) {
                if(LSW[j:] + MSW[:j+5] == pattern) {
                    cct++;
                }
            }
        }
    }

    data_mem[192] = act;
    data_mem[193] = bct;
    data_mem[194] = cct;
}