Voici notre fichier de suivi pour le travail sur le RISC-V


## 13 mars

Nous avons d'abord discuté avec l'encadrant de notre avancement et de nos objectifs proches (notamment la conception d'un schéma de RISC-V avec étages).
Nous nous sommes donc atteler à faire ce schéma pendant le reste de la séance, et nous l'avons fini _(le lien est prochainement dans le git)_


## 20 mars

Après avoir conçu le schéma du RISC-V, nous avons écrit en SystemVerilog les différents modules utiles au processeur et non-fourni (ALU, decoder, Program Counter), ainsi que le squelette du RISC-V.


## 26 mars

Nous avons d'abord fini l'implémentation du RISC-V et corrigé quelques erreurs.
Les fichiers ont réussi à se compiler sur Quartus.


### Mois d'avril

Nous arrivons à visualiser les chronogrammes de notre RISC-V sur QuestaSim.
Le mois d'avril a été consacré à continuer de débugger le processeur en testant tous les types d'instructions (I-Type, B-Type, ...).
C'est un processus assez fastidieux qui demande à faire beaucoup de tests et vérifier de nombreuses données.

En parallèle, un assembleur a commencé à être programmé en Python.
Pour le moment, il peut transformer des instructions en hexadécimal.

## 24 avril

Après le rendez-vous avec l'encadrant, nous nous sommes divisés les tâches à faire :
 - une implémentation basique de périphériques (leds, switchs et afficheurs 7 segments en bonus) a été réalisée
 - un code de test difficile pour tester la robustesse du RISC-V a été créé (mais le processeur n'a pas encore été testé)
 - on a commencé le début du travail sur le pipelining en divisant le RISC-V en 5 parties (une par étage)
   on pourra ainsi savoir où mettre les bascules


## 2 mai

Nous avons avancé sur plusieurs points :
 - L'implémentation du pipeline a bien avancé (première implémentation SVL)
 - On a tenté d'injecter le code dans le FPGA sur Quartus, mais nous n'avons pas réussi
 - Nous avons avancé sur l'assembleur
 - Nous avons avancé sur la conception d'un code de test très complet, avec périphériques (plus de 50 instructions)

## 15 mai

Nous avons passé cette séance à implémenter les périphériques du RISC-V
Après une longue séance de débuggage et de création d'un code en assembleur, nous avons réussi à allumer des leds avec les switchs.
Nous avons donc réussi à répondre à une partie du cahier des charges lors de cette séance !

## 22 mai 

Nous nous sommes répartis les tâches pour les deux derniers points à réaliser :
 - Pour le assembleur, le code a été amélioré pour les B-instructions et les J-instructions
 - Pour le pipeline, nous avons (déjà !) réussi à implémenter en SystemVerilog une première version fonctionnelle
   qui semble fonctionner après essais sur simulateur (tests avec load, store, et opération avec immediate)

## 29 mai 

Cette séance était concerné à l'audit des autres projets ARTISHOW, nous n'avons par conséquent pas avancé sur notre projet.
Pendant la présentation de notre projet, les auditeurs ne semblaient pas avoir de remarques concernant la réalisation du processeur, mais étaient plutôt intéressé sur la manière dont nous avons procédé pour réaliser le projet (car notre projet /ressemble sur beaucoup de points aux cours d'INF107/INF108)

## 5 juin

Nous avons continué de travailler en deux groupes :
 - L'assembleur continue d'être améliorer, en permettant notamment à certaines pseudo-instructions d'être lu (des instructions "raccourcis")
  - Pour le processeur pipeliné, nous avons compilé notre code sur la carte FPGA, et nous avons commencé à résoudre quelques soucis lié au pipelining (le fait que la parallélisation des instructions doit être interrompu parfois (data forwarding))

## 12 juin

Il s'agit de la dernière séance avant la semaine banalisée ARTISHOW
 - L'assembleur est maintenant complètement fonctionnel, des pseudo-instructions supplémentaires ont été ajoutées.
 - Le processeur arrive maintenant à supporter les soucis liés au pipelining, et fonctionne. Nous avons donc un processeur 5x plus rapide maintenant

Le cahier des charges initial a été complété aujourd'hui, nous avons rempli tout ce qui a été demandé



# Semaine ARTISHOW

Comme nous avons fini de faire tout ce qui a été initialement prévu, l'encadrant a rajouté un nouvel objectif : faire fonctionner un périphérique vidéo avec le processeur et le FPGA.

## Lundi

La journée a été consacré à la prise en main des signaux VGA. Nous avons réussi à afficher sur un écran des bandes de couleur rouge, vert et bleu.

## Mardi

Nous avons commencé à implémenter un nouveau périphérique pour gérer les signaux VGA. Le processeur est maintenant capable de communiquer avec ce périphérique.
Nous avons commencé à coder une carte graphique, qui permettra de s'occuper des tâches d'affichage sur un écran, plutôt que de coder à la main en assembleur chaque pixel à dessiner

## Mercredi

La journée a été consacrée au débuggage et à la création d'un programme test de jeu vidéo pour montrer ce qu'est capable de faire le processeur avec tous ses périphériques.
Un générateur de nombre aléatoire a aussi été rajouté, ainsi que la gestion des boutons pressoirs.
Le code n'est cependant pas encore fonctionnel, il y a des erreurs à régler avec la carte graphique et le programme du jeu

## Jeudi

Nous avons finalement réussi à faire fonctionner la carte graphique !
Pour le jeu, nous avons opté pour deux programmes un peu moins ambitieux que le projet de base (un générateur de rectangle aléatoire et un carré qui se déplace sur l'écran)

## Vendredi

Séance de présentation du projet dans le hall


