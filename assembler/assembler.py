
import sys
import re

# opcodes
opcode = {
		'ld': '01000',
		'str': '01001',
		'lsl': '000',
        'lsr': '001',        
        'or': '1101',
        'xor': '0110',
        'rxr': '0111',
        'add': '1110',
        'mov': '1111',
        'je':  '10000',
        'jne': '10001',
        'spc': '1001',
        'lut': '1010',
        'ctc': '101100',
        'cti': '101101',
        'cts': '101110',
        'cbf': '101111',
        'sbs': '01010',
        'dbs': '01011',
        'cpy': '1100'
		}

counter_ref = {
    'a':'00',
    'b':'01',
    'c':'10',
    'b_flag':'11'
}


# python3 assembler.py <assembly file> <name of machine code file to write to>
def main():
    if (len(sys.argv) != 3):
            print("Incorrect # of args \nUsage: python3 assembler.py <assembly file to read> <mcode file to write to>");
            sys.exit();
    with open(sys.argv[1], 'r') as file,  open(sys.argv[2], 'w') as mcode:
        for lineno, line in enumerate(file):
            try:
                # Skip over blank lines, remove comments
                line = line.strip()
                line = line.split('# ')[0].strip()  # decide later
                line = line.split('//')[0].strip() 
                if line == '':
                    continue

                line = re.sub('[\[\]]','',line)
                stuff = re.split(r'[\s,]+', line)
                op, args = stuff[0], stuff[1:]
                argm = []

                if (op == 'mov'):          # mov imm5
                    argm.append('{:05b}'.format(int(args[0][1:])))

                elif (op == 'ctc' or op == 'cti' or op == 'cts' or op == 'cbf'):   # ctc, cti, cts, cbf
                    if (op != 'cbf'):
                        rc = counter_ref[args[0]]
                        argm.append(rc)

                elif (op == 'je' or op == 'jne'): # je, jne
                    ch = '{:02b}'.format(int(args[0][1:]))
                    argm.append(ch)

                elif (op == 'spc'): # spc
                    rc = '{:02b}'.format(int(args[0][1:]))
                    off = '{:01b}'.format(int(args[1][1:]))
                    argm.extend((rc, off))
                
                elif (op == 'lut' or op == 'add'): # lut, add
                    rc = '{:03b}'.format(int(args[0].split('r')[1]))
                    ch = '{:01b}'.format(int(args[1][1:]))
                    argm.extend((rc, ch))

                else:
                    r1 = '{:03b}'.format(int(args[0].split('r')[1]))
                    r2 = ''
                    if (op == 'lsl' or op == 'lsr'): # lsl, lsr
                        r2 = '{:03b}'.format(int(args[1].split('r')[1]))
                    elif (op == 'or'):                      # or
                        r2 = '{:02b}'.format(int(args[1].split('r')[1]))[1:]
                    argm.extend((r1, r2))

                # Build the instruction:
                machine_code = opcode[op] + ''.join(argm)

                # add padding for unused bits
                if (len(machine_code) < 9):
	                machine_code = machine_code + ((9-len(machine_code))*'0')

                # Write the machine code
                mcode.write(machine_code + '\n')

            except:
                print("Error Parsing Line ", lineno)
                print(">>>{}<<<".format(line))
                print()
                raise
        mcode.write('111111111') # halt

if __name__=="__main__":
    main()
