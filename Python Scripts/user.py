

string="00000000\n"
string_16="0000000000000000\n"
array_in_reset=[string]*501
array_in_reset[500]="00000001\n"
array_in_reg_reset=[string_16]*8
with open(r"C:\Users\arin weling\Desktop\Apple_M69\Memory.txt", 'r') as file_2:
    array_in = file_2.readlines()
with open(r"C:\Users\arin weling\Desktop\Apple_M69\Register.txt", 'r') as file_3:
    array_in_reg = file_3.readlines()

clock_cycles=int(array_in[500],2)
reset_1=int(input("Reset Memory? [1 for Yes, 0 for No]: "))
reset_2=int(input("Reset Register File?[1 for Yes, 0 for No]: "))
if reset_1==1:
    array_in=array_in_reset
    clock_cycles=1
if reset_2==1:
    array_in_reg=array_in_reg_reset

while True:
    option=input("Enter option: [0 for Data_input_memory, 1 for Data_input_register, 2 for Instruction input, -1 to stop]\n")
    if option=="-1":
        print("End")
        array_in[500]= format(clock_cycles,'08b')+"\n"
        with open (r"C:\Users\arin weling\Desktop\Apple_M69\Memory.txt", 'w') as file:
            file.writelines(array_in)
        with open (r"C:\Users\arin weling\Desktop\Apple_M69\Register.txt", 'w') as file_1:
            file_1.writelines(array_in_reg)

        break
    elif option=="0":
        data=format(int(input("Enter data:")),'016b')
        data_up=data[:8]
        data_down=data[8:16]
        address=format(int(input("Enter address:")),'016b')
        array_in[int(address,2)]=data_up+"\n"
        array_in[(int(address,2))+1]=data_down+"\n"
    elif option=="1":
        data_1=format(int(input("Enter data:")),'016b')
        address_reg=format(int(input("Enter address of register:")),'03b')
        array_in_reg[int(address_reg,2)]=data_1+"\n"

    elif option == "2":

        op=input("Enter operation type[ADD,SUB,MUL,ADI,AND,ORA,IMP,LHI,LLI,LW,SW,BEQ,JAL,JLR]: ")
        address_instr=format(int(input("Enter address:")),'016b')+"\n"
        if op=="ADD" or op=="SUB" or op=="MUL" or op=="ORA" or op=="AND" or op=="IMP":
            reg_a=format(int(input("Enter address of register_a:")),'03b')
            reg_b=format(int(input("Enter address of register_b:")),'03b')
            reg_c=format(int(input("Enter address of register_c:")),'03b')
            clock_cycles=clock_cycles+3
            if op=="ADD":
                array_in[int(address_instr,2)]="0000"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+reg_c+"000\n"
            elif op=="SUB":
                array_in[int(address_instr,2)]="0010"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+reg_c+"000\n"
            elif op=="MUL":
                array_in[int(address_instr,2)]="0011"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+reg_c+"000\n"
            elif op=="AND":
                array_in[int(address_instr,2)]="0100"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+reg_c+"000\n"
            elif op=="ORA":
                array_in[int(address_instr,2)]="0101"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+reg_c+"000\n"
            elif op=="IMP":
                array_in[int(address_instr,2)]="0110"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+reg_c+"000\n"
            

        elif op=="ADI" or op=="LW" or op=="SW" or op=="BEQ":
            reg_a=format(int(input("Enter address of register_a:")),'03b')
            reg_b=format(int(input("Enter address of register_b:")),'03b')
            immd=format(int(input("Enter immediate value:")),'06b')
            clock_cycles=clock_cycles+3
            if op=="ADI":
                array_in[int(address_instr,2)]="0001"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+immd+"\n"
            elif op=="LW":
                array_in[int(address_instr,2)]="1010"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+immd+"\n"
            elif op=="SW":
                array_in[int(address_instr,2)]="1011"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+immd+"\n"
            elif op=="BEQ":
                array_in[int(address_instr,2)]="1100"+reg_a+reg_b[0]+"\n"
                array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+immd+"\n"
        elif op=="JLR":
            reg_a=format(int(input("Enter address of register_a:")),'03b')
            reg_b=format(int(input("Enter address of register_b:")),'03b')
            array_in[int(address_instr,2)]="1111"+reg_a+reg_b[0]+"\n"
            array_in[(int(address_instr,2))+1]=reg_b[1]+reg_b[2]+"000000\n"
            clock_cycles=clock_cycles+3
        elif op=="LHI":
            reg_a=format(int(input("Enter address of register_a:")),'03b')
            immd=format(int(input("Enter immediate:")),'09b')
            array_in[int(address_instr,2)]="1000"+reg_a+immd[0]+"\n"
            array_in[(int(address_instr,2))+1]=immd[1:9]+"\n"
            clock_cycles=clock_cycles+2
        elif op=="LLI":
            reg_a=format(int(input("Enter address of register_a:")),'03b')
            immd=format(int(input("Enter immediate:")),'09b')
            array_in[int(address_instr,2)]="1001"+reg_a+immd[0]+"\n"
            array_in[(int(address_instr,2))+1]=immd[1:9]+"\n"
            clock_cycles=clock_cycles+2
        elif op=="JAL":
            reg_a=format(int(input("Enter address of register_a:")),'03b')
            immd=format(int(input("Enter immediate:")),'09b')
            array_in[int(address_instr,2)]="1101"+reg_a+immd[0]+"\n"
            array_in[(int(address_instr,2))+1]=immd[1:9]+"\n"
            clock_cycles=clock_cycles+3