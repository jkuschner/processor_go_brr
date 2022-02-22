
import sys
import re

# opcodes
opcodes = {
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


def main():
    with open(sys.argv[1], 'r') as file,  open('machine_code.txt', 'w') as mcode:
        for lineno, line in enumerate(file):
            try:
                # Skip over blank lines, remove comments
                line = line.strip()
                line = line.split('#')[0].strip()  # decide later
                line = line.split('//')[0].strip() 
                if line == '':
                    continue

                line = re.sub('[\[\]]','',line)
                stuff = re.split(' |, ', line)
                op, args = stuff[0], stuff[1:]
                argm = []

                if (opcode[op] == '1111'):          # mov imm5
                    argm.append('{:05b}'.format(int(args[0][1:])))

                elif (opcode[op] == '101100' or opcode[op] == '101101' or opcode[op] == '101110'):   # ctc, cti, cts
                    rc = '{:02b}'.format(int(args[0].split('r')[1]))
                    argm.append(rc)

                elif (opcode[op] == '10000' or opcode[op] == '10001'): # je, jne
                    ch = '{:02b}'.format(int(args[0][1:]))
                    argm.append(ch)

                elif (opcode[op] == '1001'): # spc
                    rc = '{:02b}'.format(int(args[0][1:]))
                    off = '{:01b}'.format(int(args[1][1:]))
                    argm.extend((rc, off))
                
                elif (opcode[op] == '1010' or opcode[op] == '1110'): # lut
                    rc = '{:03b}'.format(int(args[0].split('r')[1]))
                    ch = '{:01b}'.format(int(args[1][1:]))
                    argm.extend((rc, ch))

                else:
                    r1 = '{:03b}'.format(int(args[0].split('r')[1]))
                    r2 = ''
                    if (opcode[op] == '000' or opcode[op] == '001'): # lsl, lsr
                        r2 = '{:03b}'.format(int(args[1].split('r')[1]))
                    elif (opcode[op] = '1101'):                      # or
                        r2 = '{:02b}'.format(int(args[1].split('r')[1]))
                    argm.extend((r1, r2))

                # Build the instruction:
                machine_code = opcode[op] + ''.join(argm)

                # add padding for unused bits
                if (len(machine_code) < 9):
	                s = s + ((9-len(machine_code))*'0')

                # Write the machine code
                mcode.write(machine_code + '\n')

            except:
                print("Error Parsing Line ", lineno)
                print(">>>{}<<<".format(line))
                print()
                raise


if __name__=="__main__":
    main()