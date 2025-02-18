import compileur as cp  
def process_and_write():
    instructions = []
    eticket= []
    instructions_sans_etiket = []
    ligne_faut_sauter=[]
    instructions_final = []
    instructions_sans_ligne_vide=[]
    symboles = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    L= []
    L2=[]
    lines = []
    with open("C:/Users/BIG#MONSTER/Desktop/Transformation ASM to HEX/input.txt", 'r') as input_file, open("C:/Users/BIG#MONSTER/Desktop/Transformation ASM to HEX/output.txt", 'w') as output_file:
        k = 1
        l = 1 
        
        for line in input_file : 
            instructions+=[line.upper()]
        conteur_ligne = 1
        
        for line in instructions:
            for i in symboles : 
                if i in line :
                    instructions_sans_ligne_vide+=[line]
                    break
        for ligne in instructions_sans_ligne_vide:
            instruction_diviser = ligne.replace(",", " ").split()
            if ":" in ligne : 
                ligne = ligne.replace(":"," ")
                a = ligne.split()[0].upper()
                eticket+=[a]
                ligne_faut_sauter+=[conteur_ligne]    
            elif instruction_diviser[0] == "LI":
                if int(instruction_diviser[-1])<=4095:
                    if int(instruction_diviser[-1])<=2047:
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+"X0"+","+instruction_diviser[-1]+'\n']
                        conteur_ligne+=1
                    elif     (int(instruction_diviser[-1])>2047) and int(instruction_diviser[-1])<=4094:
                        a = int(instruction_diviser[-1])-2047
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+"X0"+","+"2047"+'\n']
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+str(a)+'\n']
                        conteur_ligne+=2
                    else : 
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+"X0"+","+"2047"+'\n']
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+"2047"+'\n']
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+"1"+'\n']
                        conteur_ligne+=3

                else : 
                    nombre_binaire_32_bit = cp.decimal_to_binary(int(instruction_diviser[-1]),32)
                    nombre_ADDI =cp.binary_to_decimal(nombre_binaire_32_bit[20:32]) 
                    nombre_LUI  =cp.binary_to_decimal(nombre_binaire_32_bit[0:20])
                    instructions_sans_etiket+= ["LUI  " + instruction_diviser[1]+","+str(nombre_LUI)+'\n']
                    if(nombre_ADDI)<=2047:
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+str(nombre_ADDI)+'\n']
                        conteur_ligne+=2
                    elif     ((nombre_ADDI)>2047) and (nombre_ADDI)<=4094:
                        a = int(nombre_ADDI)-2047
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+"2047"+'\n']
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+str(a)+'\n']
                        conteur_ligne+=3
                    else : 
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+"2047"+'\n']
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+"2047"+'\n']
                        instructions_sans_etiket+= ["ADDI  " + instruction_diviser[1]+","+instruction_diviser[1]+","+"1"+'\n']
                        conteur_ligne+=4
            elif instruction_diviser[0]=="LW" or instruction_diviser[0]== "LB" or instruction_diviser[0]=="LH":
                instructions_sans_etiket+=[ligne]
                conteur_ligne+=1
                try:
                    registre = instruction_diviser[1]
                except:
                    registre = "amongos,jiji,soprator,kiki,ADDI X63?SJDGTDKEYKEGDFVBLDIEYYDHSVDNSJFDHBDHVZDJEGJDFHBEJVHDJE"    
                indice = instructions_sans_ligne_vide.index(ligne)
                if ((indice<(len(instructions_sans_ligne_vide)-1))):
                    if ":" not in instructions_sans_ligne_vide[indice+1]:
                        if registre in instructions_sans_ligne_vide[indice+1]:
                            instructions_sans_etiket+=["NOP\n"]
                            conteur_ligne+=1
                    else : 
                        if registre in instructions_sans_ligne_vide[indice+2]:
                            instructions_sans_etiket+=["NOP\n"]
                            conteur_ligne+=1
            else : 
                instructions_sans_etiket+=[ligne]
                conteur_ligne+=1
        i=1        
        for ligne in instructions_sans_etiket:
            ligne_a_enregistrer = ligne
            eticket1 = ligne_a_enregistrer.split(',')[-1]
            eticket2= eticket1.split()
            eticket3= eticket2[0].split('\n')[0]
            for mot in eticket:
                if mot == eticket3:
                    intermediere = ligne.split()
                    utile  =  intermediere[1].split(',')
                    t= ""
                    for lm in range(len(utile)-1):
                        t+= utile[lm]+","
                    indice =  eticket.index(mot)
                    jump_to_line = ligne_faut_sauter[indice]
                    ligne_instruction = i
                    #print(mot + "  jump T0: " + str(jump_to_line)+ "  ligne instruction: "+ str(ligne_instruction))
                    valeur_de_jump = jump_to_line-ligne_instruction
                    ligne_a_enregistrer = intermediere[0]+"  "+t+str(valeur_de_jump)
                    
                    break
            instructions_final+=[ligne_a_enregistrer]    
            i+=1

        for line in instructions_final:
            print(line)
            output_file.write(cp.compilationEnHexa(line.upper(),l,L,L2)+'\n')
process_and_write()