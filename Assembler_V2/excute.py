# [fichier]: excute.py
# [description]: Script de traitement d'assemblage RISC-V. Lit un fichier assembleur,
#                gère les pseudo-instructions, les étiquettes, et produit du code machine hexadécimal.
# [Regles] : -Pas d'instruction devant une eticket, éticket doit etre tout seul
#            -Pas de nombres en hexadecimale
#            -Utiliser les l'écriture normalisé voir site : https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html
#            -Li pseudo instruction doit contenir necessairement un nombre immidiate non signé
#            -les nombre en binaire ou hex decimal ne sont pas supporté pour le moment juste les nombres decimal sont  supporté 

import compiler as cp  # Module personnalisé pour la compilation

# ------------------- Configuration des chemins -------------------
INPUT_PATH = "C:/Users/BIG#MONSTER/Desktop/Transformation ASM to HEX/input.txt"
OUTPUT_PATH = "C:/Users/BIG#MONSTER/Desktop/Transformation ASM to HEX/output.txt"

# ------------------- Caractères valides pour le parsing -------------------
SYMBOLES_VALIDES = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 
                   'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 
                   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

def process_and_write():
    """
    Traite le fichier assembleur d'entrée et génère le code machine hexadécimal.
    Étapes principales :
    1. Lecture et prétraitement des lignes
    2. Gestion des étiquettes et pseudo-instructions
    3. Résolution des sauts relatifs
    4. Compilation finale en hexadécimal
    """
    # Structures de données
    lignes_brutes = []          # Lignes lues du fichier
    labels = []                 # Noms des étiquettes (ex: "LOOP:")
    positions_labels = []       # Positions mémoire des étiquettes
    lignes_sans_labels = []     # Instructions sans les lignes d'étiquettes
    lignes_finales = []         # Instructions avec sauts résolus
    lignes_non_vides = []       # Filtrage des lignes vides

    # Phase 1: Lecture et prétraitement initial
    with open(INPUT_PATH, 'r') as f_in, open(OUTPUT_PATH, 'w') as f_out:
        # Chargement et normalisation des lignes
        for ligne in f_in:
            lignes_brutes.append(ligne.upper().strip())

        # Filtrage des lignes non vides
        for ligne in lignes_brutes:
            if any(car in ligne for car in SYMBOLES_VALIDES):
                lignes_non_vides.append(ligne)

        # Phase 2: Traitement des étiquettes et pseudo-instructions
        compteur_ligne = 1
        for idx, ligne in enumerate(lignes_non_vides):
            elements = ligne.replace(",", " ").split()

            # Gestion des étiquettes (ex: "LOOP:")
            if ":" in ligne:
                nom_label = ligne.split(":")[0].strip()
                labels.append(nom_label)
                positions_labels.append(compteur_ligne)
                continue  # On ignore la ligne contenant uniquement l'étiquette

            # Traitement de la pseudo-instruction LI (Load Immediate)
            elif elements[0] == "LI":
                valeur = int(elements[-1])
                registre = elements[1]

                # Stratégie de décomposition selon la valeur
                if valeur <= 4095:
                    # Cas simples avec 1-3 instructions ADDI
                    if valeur <= 2047:
                        lignes_sans_labels.append(f"ADDI {registre}, X0, {valeur}")
                    elif 2047 < valeur <= 4094:
                        a = valeur - 2047
                        lignes_sans_labels.extend([
                            f"ADDI {registre}, X0, 2047",
                            f"ADDI {registre}, {registre}, {a}"
                        ])
                    else:
                        lignes_sans_labels.extend([
                            f"ADDI {registre}, X0, 2047",
                            f"ADDI {registre}, {registre}, 2047",
                            f"ADDI {registre}, {registre}, 1"
                        ])
                else:
                    # Cas complexes utilisant LUI + ADDI
                    bits = cp.decimal_to_binary(valeur, 32)
                    lui_val = cp.binary_to_decimal(bits[:20])
                    addi_val = cp.binary_to_decimal(bits[20:32])
                    
                    lignes_sans_labels.append(f"LUI {registre}, {lui_val}")
                    if addi_val <= 2047:
                        lignes_sans_labels.append(f"ADDI {registre}, {registre}, {addi_val}")
                    elif 2047 < addi_val <= 4094:
                        a = addi_val - 2047
                        lignes_sans_labels.extend([
                            f"ADDI {registre}, X0, 2047",
                            f"ADDI {registre}, {registre}, {a}"
                        ])
                    else:
                        lignes_sans_labels.extend([
                            f"ADDI {registre}, X0, 2047",
                            f"ADDI {registre}, {registre}, 2047",
                            f"ADDI {registre}, {registre}, 1"
                        ])

                compteur_ligne += 1

            # Insertion de NOP après les load pour éviter les aléas
            elif elements[0] in ["LW", "LB", "LH"]:
                lignes_sans_labels.append(ligne)
                # Vérification de la dépendance sur la ligne suivante
                if idx < len(lignes_non_vides) - 1:
                    next_line = lignes_non_vides[idx + 1]
                    if elements[1] in next_line and ":" not in next_line:
                        lignes_sans_labels.append("NOP")
                        compteur_ligne += 1

            # Cas général
            else:
                lignes_sans_labels.append(ligne)
            
            compteur_ligne += 1

        # Phase 3: Résolution des sauts relatifs
        for idx, ligne in enumerate(lignes_sans_labels):
            ligne_modifiee = ligne
            elements = ligne.split()

            # Remplacement des étiquettes par des offsets
            for label in labels:
                if label in ligne:
                    pos_label = positions_labels[labels.index(label)]
                    offset = pos_label - (idx + 1)  # +1 car les lignes commencent à 1
                    ligne_modifiee = ligne.replace(label, str(offset))
                    break
            
            lignes_finales.append(ligne_modifiee)

        # Phase 4: Compilation finale
        for ligne in lignes_finales:
            hex_code = cp.compilationEnHexa(ligne, 0, [], [])  # Paramètres globaux simulés
            f_out.write(hex_code + "\n")

# Exécution du pipeline
process_and_write()
