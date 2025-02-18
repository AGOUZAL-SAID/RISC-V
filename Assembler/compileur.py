Binstruction = ["BEQ", "BNE","BLT","BGE","BLTU","BGEU"]
Linstruction = ["LB","LH","LW","LBU","LHU"]
Sinstruction = ["SB","SH","SW"]
Rinstruction = ["ADD","SUB","SLL","SLT","SLTU","XOR","SRL","SRA","OR","AND"]
Iinstruction = ["ADDI","SLTI","SLTIU","XORI","ORI","ANDI","SLLI","SRLI","SRAI"]
Registers ={
    "X0": 0,
    "X1": 1,
    "X2": 2,
    "X3": 3,
    "X4": 4,
    "X5": 5,
    "X6": 6,
    "X7": 7,
    "X8": 8,
    "X9": 9,
    "X10": 10,
    "X11": 11,
    "X12": 12,
    "X13": 13,
    "X14": 14,
    "X15": 15,
    "X16": 16,
    "X17": 17,
    "X18": 18,
    "X19": 19,
    "X20": 20,
    "X21": 21,
    "X22": 22,
    "X23": 23,
    "X24": 24,
    "X25": 25,
    "X26": 26,
    "X27": 27,
    "X28": 28,
    "X29": 29,
    "X30": 30,
    "X31": 31,
    "ZERO":0,
    "RA":1,
    "SP":2,
    "GP":3,
    "TP":4,
    "T0":5,
    "T1":6,
    "T2":7,
    "S0":8,
    "S1":9,
    "A0":10,
    "A1":11,
    "A2":12,
    "A3":13,
    "A4":14,
    "A5":15,
    "A6":16,
    "A7":17,
    "S2":18,
    "S3":19,
    "S4":20,
    "S5":21,
    "S6":22,
    "S7":23,
    "S8":24,
    "S9":25,
    "S10":26,
    "S11":27,
    "T3":28,
    "T4":29,
    "T5":30,
    "T6":31
}

LUI = ["LUI"]
AUIPC = ["AUIPC"]
JAL = ["JAL"]
JALR = ["JALR"]
instructions = {
    "ADD": "000",
    "SUB": "000",
    "SLL": "001",
    "SLT": "010",
    "SLTU": "011",
    "XOR": "100",
    "SRL": "101",
    "SRA": "101",  # Même code que SRL
    "OR": "110",
    "AND": "111",
    "ADDI": "000",
    "SLTI": "010",
    "SLTIU": "011",
    "XORI": "100",
    "ORI": "110",
    "ANDI": "111",
    "SLLI": "001",
    "SRLI": "101",
    "SRAI": "101",  # Même code que SRLI
    "LUI": "000",
    "AUIPC": "000",
    "BEQ": "000",
    "BNE": "001",
    "BLT": "100",
    "BGE": "101",
    "BLTU": "110",
    "BGEU": "111",
    "LB": "000",
    "LH": "001",
    "LW": "010",
    "LBU": "100",
    "LHU": "101",
    "SB": "000",
    "SH": "001",
    "SW": "010",
    "JAL": "000",
    "JALR": "000"
}

def binary_to_decimal(binary_str):
    """
    Convert a binary string to its decimal equivalent.
    
    :param binary_str: A string representing a binary number (e.g., "111111111111").
    :return: The decimal equivalent of the binary number.
    """
    decimal_value = 0
    power = 0

    # Reverse the binary string to process from least significant bit to most significant bit
    binary_str = binary_str[::-1]

    for digit in binary_str:
        if digit == '1':
            decimal_value += 2**power
        power += 1

    return decimal_value


def decimal_to_binary(decimal,n):
    # Convertir le nombre en binaire sous forme de chaîne
    binary_str = bin(decimal & (2**n - 1))[2:]
    # Vérifier si le nombre est négatif
    if decimal < 0:
        # Si oui, étendre le signe en ajoutant des bits de signe
        binary_str = '1' * (n - len(binary_str)) + binary_str
    else:
        # Si le nombre est positif ou nul, pas besoin d'extension de signe
        binary_str = '0' * (n - len(binary_str)) + binary_str

    return binary_str


def binary_to_hex(binary):
    # Convertit chaque groupe de 4 bits en hexadécimal
    hex_string = ''
    for i in range(0, len(binary), 4):
        hex_digit = hex(int(binary[i:i+4], 2))[2:]  # Convertit en hexadécimal et supprime le préfixe '0x'
        hex_string += hex_digit.upper()  # Convertit en majuscule pour correspondre à la convention hexadécimale

    return hex_string
    

def Rtransforme(instruction):
    opecode = "0110011"
    rd =  decimal_to_binary(Registers[instruction[1]],5)
    rs1 = decimal_to_binary(Registers[instruction[2]],5)
    rs2 = decimal_to_binary(Registers[instruction[3]],5)
    funct3 = instructions[instruction[0]]
    funct7= "0000000"
    if (instruction[0]=="SUB" or instruction[0]=="SRA"):
        funct7 = "0100000"
    binaryInstruction = funct7 + rs2 + rs1 + funct3 + rd + opecode 
    return binary_to_hex(binaryInstruction)


def Itransforme(instruction):
    opecode = "0010011"
    rd =  decimal_to_binary(Registers[instruction[1]],5)
    rs1 = decimal_to_binary(Registers[instruction[2]],5)
    Imm = decimal_to_binary(int(instruction[3]),12)
    funct3 = instructions[instruction[0]]
    if (instruction[0]=="SLLI" or instruction[0]=="SRLI" or instruction[0]=="SRAI"):
        imm1 = "0000000"
        if((instruction[0]=="SRAI")):
            imm1 = "0100000"
        imm2 = decimal_to_binary(int(instruction[3]),5)    
        Imm = imm1 + imm2
    binaryInstruction = Imm + rs1 + funct3 + rd + opecode 
    return binary_to_hex(binaryInstruction)

def Stransforme(instruction):
    opecode = "0100011"
    rs1 = decimal_to_binary(Registers[instruction[2]],5)
    Imm = decimal_to_binary(int(instruction[3]),12)
    rs2 = decimal_to_binary(Registers[instruction[1]],5)
    funct3 = instructions[instruction[0]]
    binaryInstruction = Imm[0:7]+ rs2 + rs1 + funct3 + Imm[-5:] + opecode
    return binary_to_hex(binaryInstruction)


def Ltransforme(instruction):
    opecode = "0000011"
    rd =  decimal_to_binary(Registers[instruction[1]],5)
    rs1 = decimal_to_binary(Registers[instruction[2]],5)
    Imm = decimal_to_binary(int(instruction[3]),12)
    funct3 = instructions[instruction[0]]
    binaryInstruction = Imm + rs1 + funct3 + rd + opecode 
    return binary_to_hex(binaryInstruction)


def Btransforme(instruction):
    global i 
    i=0
    opecode = "1100011"
    rs1 = decimal_to_binary(Registers[instruction[1]],5)
    Imm = decimal_to_binary(int(instruction[3])*4,13)     
    rs2 = decimal_to_binary(Registers[instruction[2]],5)
    funct3 = instructions[instruction[0]]
    binaryInstruction = Imm[0]+Imm[2:8]+ rs2 + rs1 + funct3 + Imm[8:12]+Imm[1] + opecode
    #print(len(binaryInstruction))
    return binary_to_hex(binaryInstruction)


def JalrTransforme(instruction):
    opecode = "1100111"
    rd =  decimal_to_binary(Registers[instruction[1]],5)
    rs1 = decimal_to_binary(Registers[instruction[2]],5)
    Imm = decimal_to_binary(int(instruction[3]),12)
    funct3 = instructions[instruction[0]]
    binaryInstruction = Imm + rs1 + funct3 + rd + opecode 
    return binary_to_hex(binaryInstruction)


def JalTransforme(instruction):
     opecode = "1101111"
     rd =  decimal_to_binary(Registers[instruction[1]],5)
     Imm = decimal_to_binary(int(instruction[2])*4,21)
     binaryInstruction = Imm[0] + Imm[10:20] + Imm[9] + Imm[1:9] + rd + opecode 
     return binary_to_hex(binaryInstruction)

def AuipcTransforme(instruction):
     opecode = "0010111"
     rd =  decimal_to_binary(Registers[instruction[1]],5)
     Imm = decimal_to_binary(int(instruction[2]),20)
     binaryInstruction = Imm[0:20] + rd + opecode 
     return binary_to_hex(binaryInstruction)


def LuiTransforme(instruction):
     opecode = "0110111"
     rd =  decimal_to_binary(Registers[instruction[1]],5)
     Imm = decimal_to_binary(int(instruction[2]),20)
     binaryInstruction = Imm[0:20] + rd + opecode 
     return binary_to_hex(binaryInstruction)



def compilationEnHexa(instruction_base,n,liste,liste2):
    global goto 
    goto = n
    global liste_goto
    liste_goto = liste 
    global liste_position_goto
    liste_position_goto = liste2
    A = instruction_base.replace(",", " ").split()
    if A ==[]:
        return "[]"
    elif  A[0] in  Rinstruction : 
         return Rtransforme(A)
    elif A[0] in Iinstruction : 
         return Itransforme(A)
    elif A[0] in Binstruction:
         return Btransforme(A)    
    elif A[0] in Linstruction :   
         second_split = A[2].split('(')
         rs1 = second_split[1].strip(')')
         offset = second_split[0]
         rd = A[1]
         instruction_total = [A[0],rd,rs1,offset]
         return Ltransforme(instruction_total)
    elif A[0] in Sinstruction : 
         second_split = A[2].split('(')
         rs1 = second_split[1].strip(')')
         offset = second_split[0]
         rs2 = A[1]
         instruction_total = [A[0],rs2,rs1,offset]
         return Stransforme(instruction_total)
    elif A[0] in LUI : 
        return LuiTransforme(A)
    elif A[0] in AUIPC : 
        return AuipcTransforme(A)
    elif A[0] in JAL :    
        return JalTransforme(A)
    elif   A[0] in JALR : 
        return JalrTransforme(A)
    elif A[0] == "NOP":
        return "00000000"
    elif A[0] == "MV":
        instruction = ["ADDI"]+A[1:]+["0"]
        return Itransforme(instruction)
    elif A[0]=="BEQZ":
        instruction = ["BEQ"] +[A[1]]+["X0"]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BNEZ":
        instruction = ["BNE"] +[A[1]]+["X0"]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BLEZ":
        instruction = ["BGE"] +["X0"]+[A[1]]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BGEZ":
        instruction = [A[0]]+A[1].split(',')
        instruction = ["BGE"] +[A[1]]+["X0"]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BLTZ":
        instruction = ["BLT"] +[A[1]]+["X0"]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BGTZ":
        instruction = ["BLT"] +["X0"]+[A[1]]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BGT":
        instruction = ["BLT"] +[A[2]]+[A[1]]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BLE":
        instruction = ["BGE"] +[A[2]]+[A[1]]+[A[-1]]
        return Btransforme(instruction)
    elif A[0]=="BGTU":
        instruction = ["BLTU"] +[A[2]]+[A[1]]+[A[-1]]
        return Btransforme(instruction)
    elif "%HI(" in A[0]:
        instruction = A[0].split("(")
        instruction = instruction[1].split(')')
        instruction = instruction[0]
        binaire_return = decimal_to_binary(int(instruction),32)
        return binaire_return[0:20]
    elif "%LO(" in A[0]:
        instruction = A[0].split("(")
        instruction = instruction[1].split(')')
        instruction = instruction[0]
        binaire_return = decimal_to_binary(int(instruction),32)
        return binaire_return[20:32]

    else : 
        print("cette instruction n'existe pas :  " + "'"+A[0]+"'")    
        return "cette instruction n'existe pas :  " + "'" + A[0] + "'"
    







