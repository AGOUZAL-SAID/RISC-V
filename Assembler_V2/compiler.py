# [fichier]: compile.py
# [description]: Ce script convertit des instructions assembleur RISC-V en code machine hexadécimal.

# Liste des instructions de type B (branchement conditionnel)
Binstruction = ["BEQ", "BNE", "BLT", "BGE", "BLTU", "BGEU"]

# Liste des instructions de chargement (load)
Linstruction = ["LB", "LH", "LW", "LBU", "LHU"]

# Liste des instructions de stockage (store)
Sinstruction = ["SB", "SH", "SW"]

# Liste des instructions de type R (registre-registre)
Rinstruction = ["ADD", "SUB", "SLL", "SLT", "SLTU", "XOR", "SRL", "SRA", "OR", "AND"]

# Liste des instructions de type I (immédiat)
Iinstruction = ["ADDI", "SLTI", "SLTIU", "XORI", "ORI", "ANDI", "SLLI", "SRLI", "SRAI"]

# Dictionnaire des registres RISC-V avec leurs numéros
Registers = {
    # Registres standard X0-X31
    "X0": 0, "X1": 1, "X2": 2, "X3": 3, "X4": 4, "X5": 5, "X6": 6, "X7": 7,
    "X8": 8, "X9": 9, "X10": 10, "X11": 11, "X12": 12, "X13": 13, "X14": 14,
    "X15": 15, "X16": 16, "X17": 17, "X18": 18, "X19": 19, "X20": 20, "X21": 21,
    "X22": 22, "X23": 23, "X24": 24, "X25": 25, "X26": 26, "X27": 27, "X28": 28,
    "X29": 29, "X30": 30, "X31": 31,
    
    # Alias courants
    "ZERO": 0, "RA": 1, "SP": 2, "GP": 3, "TP": 4, "T0": 5, "T1": 6, "T2": 7,
    "S0": 8, "S1": 9, "A0": 10, "A1": 11, "A2": 12, "A3": 13, "A4": 14, "A5": 15,
    "A6": 16, "A7": 17, "S2": 18, "S3": 19, "S4": 20, "S5": 21, "S6": 22, "S7": 23,
    "S8": 24, "S9": 25, "S10": 26, "S11": 27, "T3": 28, "T4": 29, "T5": 30, "T6": 31
}

# Instructions spéciales
LUI = ["LUI"]
AUIPC = ["AUIPC"]
JAL = ["JAL"]
JALR = ["JALR"]

# Mappage des instructions vers leurs codes funct3/funct7
instructions = {
    # Instructions de type R
    "ADD": "000", "SUB": "000", "SLL": "001", "SLT": "010", "SLTU": "011",
    "XOR": "100", "SRL": "101", "SRA": "101", "OR": "110", "AND": "111",
    
    # Instructions de type I
    "ADDI": "000", "SLTI": "010", "SLTIU": "011", "XORI": "100", "ORI": "110",
    "ANDI": "111", "SLLI": "001", "SRLI": "101", "SRAI": "101",
    
    # Instructions de branchement (B)
    "BEQ": "000", "BNE": "001", "BLT": "100", "BGE": "101", "BLTU": "110", "BGEU": "111",
    
    # Instructions de chargement (L) et stockage (S)
    "LB": "000", "LH": "001", "LW": "010", "LBU": "100", "LHU": "101",
    "SB": "000", "SH": "001", "SW": "010",
    
    # Autres instructions
    "JAL": "000", "JALR": "000", "LUI": "000", "AUIPC": "000"
}

# ------------------- Fonctions de conversion -------------------

def binary_to_decimal(binary_str):
    """
    Convertit une chaîne binaire en nombre décimal.
    
    Args:
        binary_str (str): Chaîne binaire (ex: "1010").
        
    Returns:
        int: Valeur décimale correspondante.
    """
    decimal_value = 0
    power = 0
    binary_str = binary_str[::-1]  # Inverse la chaîne pour traiter les bits de droite à gauche
    
    for digit in binary_str:
        if digit == '1':
            decimal_value += 2 ** power
        power += 1
    
    return decimal_value


def decimal_to_binary(decimal, n):
    """
    Convertit un nombre décimal en binaire signé sur n bits.
    
    Args:
        decimal (int): Valeur décimale à convertir.
        n (int): Nombre de bits du résultat.
        
    Returns:
        str: Chaîne binaire signée.
    """
    binary_str = bin(decimal & (2**n - 1))[2:]  # Gère les nombres négatifs via complément à deux
    padding = '1' if decimal < 0 else '0'      # Détermine le bit de padding
    return padding * (n - len(binary_str)) + binary_str  # Complète avec des zéros ou uns


def binary_to_hex(binary):
    """
    Convertit une chaîne binaire en hexadécimal.
    
    Args:
        binary (str): Chaîne binaire (longueur multiple de 4).
        
    Returns:
        str: Chaîne hexadécimale correspondante.
    """
    hex_str = ''
    for i in range(0, len(binary), 4):
        nibble = binary[i:i+4]
        hex_str += hex(int(nibble, 2))[2:].upper()  # Convertit chaque quartet en hexa
    return hex_str


# ------------------- Fonctions de transformation -------------------

def Rtransforme(instruction):
    """
    Génère le code machine pour les instructions de type R.
    Format: funct7 | rs2 | rs1 | funct3 | rd | opcode (0110011)
    """
    opcode = "0110011"
    rd = decimal_to_binary(Registers[instruction[1]], 5)
    rs1 = decimal_to_binary(Registers[instruction[2]], 5)
    rs2 = decimal_to_binary(Registers[instruction[3]], 5)
    funct3 = instructions[instruction[0]]
    funct7 = "0100000" if instruction[0] in ["SUB", "SRA"] else "0000000"  # Cas spéciaux
    
    binary = funct7 + rs2 + rs1 + funct3 + rd + opcode
    return binary_to_hex(binary)


def Itransforme(instruction):
    """
    Génère le code machine pour les instructions de type I.
    Format: imm[11:0] | rs1 | funct3 | rd | opcode (0010011)
    """
    opcode = "0010011"
    rd = decimal_to_binary(Registers[instruction[1]], 5)
    rs1 = decimal_to_binary(Registers[instruction[2]], 5)
    funct3 = instructions[instruction[0]]
    
    # Gestion des décalages (SLLI/SRLI/SRAI)
    if instruction[0] in ["SLLI", "SRLI", "SRAI"]:
        shamt = decimal_to_binary(int(instruction[3]), 5)
        imm = "0100000" + shamt if instruction[0] == "SRAI" else "0000000" + shamt
    else:
        imm = decimal_to_binary(int(instruction[3]), 12)
    
    binary = imm + rs1 + funct3 + rd + opcode
    return binary_to_hex(binary)


def Stransforme(instruction):
    """
    Génère le code machine pour les instructions de type S.
    Format: imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode (0100011)
    """
    opcode = "0100011"
    rs1 = decimal_to_binary(Registers[instruction[2]], 5)
    rs2 = decimal_to_binary(Registers[instruction[1]], 5)
    funct3 = instructions[instruction[0]]
    imm = decimal_to_binary(int(instruction[3]), 12)
    
    binary = imm[:7] + rs2 + rs1 + funct3 + imm[-5:] + opcode
    return binary_to_hex(binary)


def Ltransforme(instruction):
    """
    Génère le code machine pour les instructions de chargement (L).
    Format: imm[11:0] | rs1 | funct3 | rd | opcode (0000011)
    """
    opcode = "0000011"
    rd = decimal_to_binary(Registers[instruction[1]], 5)
    rs1 = decimal_to_binary(Registers[instruction[2]], 5)
    imm = decimal_to_binary(int(instruction[3]), 12)
    funct3 = instructions[instruction[0]]
    
    binary = imm + rs1 + funct3 + rd + opcode
    return binary_to_hex(binary)


def Btransforme(instruction):
    """
    Génère le code machine pour les instructions de branchement (B).
    Format: imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode (1100011)
    """
    opcode = "1100011"
    rs1 = decimal_to_binary(Registers[instruction[1]], 5)
    rs2 = decimal_to_binary(Registers[instruction[2]], 5)
    funct3 = instructions[instruction[0]]
    imm = decimal_to_binary(int(instruction[3]) * 4, 13)  # Offset en multiples de 4
    
    # Réorganisation des bits de l'immédiat
    binary = (
        imm[0] + imm[2:8] + rs2 + rs1 + funct3 + 
        imm[8:12] + imm[1] + opcode
    )
    return binary_to_hex(binary)


def JalrTransforme(instruction):
    """
    Génère le code machine pour JALR.
    Format: imm[11:0] | rs1 | funct3 | rd | opcode (1100111)
    """
    opcode = "1100111"
    rd = decimal_to_binary(Registers[instruction[1]], 5)
    rs1 = decimal_to_binary(Registers[instruction[2]], 5)
    imm = decimal_to_binary(int(instruction[3]), 12)
    funct3 = instructions["JALR"]
    
    binary = imm + rs1 + funct3 + rd + opcode
    return binary_to_hex(binary)


def JalTransforme(instruction):
    """
    Génère le code machine pour JAL.
    Format: imm[20|10:1|11|19:12] | rd | opcode (1101111)
    """
    opcode = "1101111"
    rd = decimal_to_binary(Registers[instruction[1]], 5)
    imm = decimal_to_binary(int(instruction[2]) * 4, 21)  # Adresse relative
    
    binary = imm[0] + imm[10:20] + imm[9] + imm[1:9] + rd + opcode
    return binary_to_hex(binary)


def AuipcTransforme(instruction):
    """
    Génère le code machine pour AUIPC.
    Format: imm[31:12] | rd | opcode (0010111)
    """
    opcode = "0010111"
    rd = decimal_to_binary(Registers[instruction[1]], 5)
    imm = decimal_to_binary(int(instruction[2]), 20)
    
    binary = imm + rd + opcode
    return binary_to_hex(binary)


def LuiTransforme(instruction):
    """
    Génère le code machine pour LUI.
    Format: imm[31:12] | rd | opcode (0110111)
    """
    opcode = "0110111"
    rd = decimal_to_binary(Registers[instruction[1]], 5)
    imm = decimal_to_binary(int(instruction[2]), 20)
    
    binary = imm + rd + opcode
    return binary_to_hex(binary)


# ------------------- Fonction de compilation principale -------------------

def compilationEnHexa(instruction_base, n, liste, liste2):
    """
    Convertit une instruction assembleur en code machine hexadécimal.
    
    Args:
        instruction_base (str): Instruction assembleur (ex: "ADD X1, X2, X3").
        n (int): Position dans le code (pour gestion des labels).
        liste (list): Liste des labels.
        liste2 (list): Liste des positions des labels.
        
    Returns:
        str: Code machine en hexadécimal ou message d'erreur.
    """
    global goto, liste_goto, liste_position_goto
    goto = n
    liste_goto = liste
    liste_position_goto = liste2
    
    # Nettoyage et découpage de l'instruction
    A = instruction_base.replace(",", " ").split()
    if not A:
        return "[]"
    
    # Dispatch vers les fonctions de transformation appropriées
    try:
        if A[0] in Rinstruction:
            return Rtransforme(A)
        elif A[0] in Iinstruction:
            return Itransforme(A)
        elif A[0] in Binstruction:
            return Btransforme(A)
        elif A[0] in Linstruction:
            # Extraction de l'offset et du registre (ex: "4(X5)")
            parts = A[2].split('(')
            return Ltransforme([A[0], A[1], parts[1].strip(')'), parts[0]])
        elif A[0] in Sinstruction:
            parts = A[2].split('(')
            return Stransforme([A[0], A[1], parts[1].strip(')'), parts[0]])
        elif A[0] in LUI:
            return LuiTransforme(A)
        elif A[0] in AUIPC:
            return AuipcTransforme(A)
        elif A[0] in JAL:
            return JalTransforme(A)
        elif A[0] in JALR:
            return JalrTransforme(A)
        elif A[0] == "NOP":
            return "00000000"  # NOP = ADDI X0, X0, 0
        elif A[0] == "MV":
            return Itransforme(["ADDI", A[1], A[2], "0"])  # MV rd, rs = ADDI rd, rs, 0
        # Gestion des pseudo-instructions de branchement
        elif A[0] == "BEQZ":
            return Btransforme(["BEQ", A[1], "X0", A[2]])
        elif A[0] == "BNEZ":
            return Btransforme(["BNE", A[1], "X0", A[2]])
        elif A[0] == "BLEZ":
            return Btransforme(["BGE", "X0", A[1], A[2]])
        elif A[0] == "BGEZ":
            return Btransforme(["BGE", A[1], "X0", A[2]])
        elif A[0] == "BLTZ":
            return Btransforme(["BLT", A[1], "X0", A[2]])
        elif A[0] == "BGTZ":
            return Btransforme(["BLT", "X0", A[1], A[2]])
        elif A[0] == "BGT":
            return Btransforme(["BLT", A[2], A[1], A[3]])
        elif A[0] == "BLE":
            return Btransforme(["BGE", A[2], A[1], A[3]])
        elif A[0] == "BGTU":
            return Btransforme(["BLTU", A[2], A[1], A[3]])
        # Gestion des directives d'adressage
        elif "%HI(" in A[0]:
            value = A[0].split("(")[1].split(")")[0]
            return decimal_to_binary(int(value), 32)[:20]  # Bits 31-12
        elif "%LO(" in A[0]:
            value = A[0].split("(")[1].split(")")[0]
            return decimal_to_binary(int(value), 32)[20:]   # Bits 11-0
        else:
            raise ValueError(f"Instruction inconnue: {A[0]}")
    
    except Exception as e:
        return f"Erreur: {str(e)}"