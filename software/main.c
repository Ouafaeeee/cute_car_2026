#include <stdio.h>

// ====================================================================
// 1. REMPLACEZ CES ADRESSES PAR CELLES DE LA COLONNE "BASE" DANS QSYS
// ====================================================================
#define ADDR_OP_SEL   0x00003010  // Exemple : Base address de PIO_OP_SEL
#define ADDR_CAPTURE  0x00003000  // Exemple : Base address de PIO_CAPTURE
#define ADDR_READY    0x00003020  // Exemple : Base address de PIO_READY
#define ADDR_DATA_A   0x00003040  // Exemple : Base address de PIO_DATA0
#define ADDR_DATA_B   0x00003050  // Exemple : Base address de PIO_DATA0_0
#define ADDR_RESULT   0x00003030  // Exemple : Base address de PIO_RESULT
// ====================================================================
// Accès mémoire direct (PIO)
// ====================================================================
#define ECRIRE_PIO(adresse, donnee) (*(volatile unsigned int *)(adresse) = (donnee))
#define LIRE_PIO(adresse)           (*(volatile unsigned int *)(adresse))

// ====================================================================
// Delay logiciel (compatible bare-metal)
// ====================================================================
void delay_cycles(volatile int cycles) {
    while (cycles--) {
        // boucle vide
    }
}

int main() {
    printf("\n=== Demarrage du Test Codesign (Acces Direct) ===\n");

    while (1) {

        // =========================
        // TEST : ADDITION (0x00)
        // =========================
        ECRIRE_PIO(ADDR_OP_SEL, 0x00);

        // Impulsion de capture
        ECRIRE_PIO(ADDR_CAPTURE, 1);
        delay_cycles(200);   // remplace usleep(20)
        ECRIRE_PIO(ADDR_CAPTURE, 0);

        // Attente data_ready (Polling)
        while (LIRE_PIO(ADDR_READY) == 0) {
            // attente active
        }

        // Lecture des données
        int dataA = LIRE_PIO(ADDR_DATA_A);
        int dataB = LIRE_PIO(ADDR_DATA_B);
        int resHW = LIRE_PIO(ADDR_RESULT);

        // Vérification
        printf("Addition HW: %d | SW attendu: %d\n", resHW, (dataA + dataB));

        // =========================
        // Pause (~1 seconde approx)
        // =========================
        delay_cycles(10000000);

        // -----------------------------------------------------
        // Tu peux dupliquer ce bloc pour :
        // - Soustraction : 0x01
        // - Multiplication : 0x02
        // etc.
        // -----------------------------------------------------
    }

    return 0;
}