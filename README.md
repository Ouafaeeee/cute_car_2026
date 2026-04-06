# Nios II Embedded System - FPGA Project

Ce dépôt contient différentes versions d'un système embarqué basé sur le processeur **Nios II (Intel/Altera)**, implémenté en VHDL pour des cartes de développement de type DE-series (DE0/DE1/DE2).

## 📌 Présentation du projet
L'objectif de ce projet est de démontrer l'interaction entre un processeur logiciel (Soft-Core) et le matériel physique d'un FPGA. Le projet a évolué en trois étapes majeures :

1.  **Contrôle LED & Switch (Basic)** : Communication simple via PIO (Parallel I/O).
2.  **Extension Mémoire (SDRAM)** : Intégration d'un contrôleur mémoire pour des applications plus lourdes.
3.  **Contrôle Robotique (Motor PWM)** : Gestion de moteurs CC avec signaux PWM générés par le FPGA.

## 📂 Contenu des fichiers
Le projet se décline en trois versions du fichier `lights.vhd` :

| Version | Caractéristiques principales | Périphériques supportés |
| :--- | :--- | :--- |
| **V1 (Minimal)** | Base du système Nios II. | SW, LEDG, KEY (Reset). |
| **V2 (SDRAM)** | Ajout de l'interface mémoire externe. | SW, LED, SDRAM (DRAM_DQ, ADDR...). |
| **V3 (Moteur/PWM)**| Contrôle de puissance et mouvement. | SW, LED, SDRAM, PWM (L/R Motors). |

##  Architecture Matérielle
* **FPGA** : Famille Cyclone (Intel/Altera).
* **Processeur** : Nios II (Fast ou Economy).
* **Horloge** : 50 MHz (CLOCK_50).
* **Reset** : KEY(0) (actif à l'état bas).
### Logique de contrôle des moteurs (Version 3)
Dans la version avancée, les registres moteur suivent la logique suivante (14 bits) :
* **Bit 13** : Start/Stop.
* **Bit 12** : Direction (0: Avant, 1: Arrière).
* **Bits [11:0]** : Vitesse (Duty Cycle PWM).

##  Installation & Utilisation
1.  Ouvrez **Quartus Prime**.
2.  Importez le fichier `.qsys` (généré via Platform Designer) correspondant à la version choisie.
3.  Compilez le design pour générer le fichier `.sof`.
4.  Utilisez **Nios II Software Build Tools (SBT)** pour compiler votre code C et le charger dans le processeur.

* **Quartus Prime** (Design Hardware & Synthèse VHDL).
* **Platform Designer (Qsys)** (Architecture du système Nios II).
* **ModelSim** (Simulation optionnelle).
