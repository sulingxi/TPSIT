package org.example;

import java.util.Random;
import java.util.Scanner;

public class Matrice {
    private final int righe, colonne;
    private int[][] matrice;

    public Matrice(int righe, int colonne) {
        this.righe = righe;
        this.colonne = colonne;
    }

    public static void manuale(Scanner scanner, int[][] matrix) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                System.out.print("Inserisci l'elemento [" + i + "][" + j + "]: ");
                matrix[i][j] = scanner.nextInt();
            }
        }
    }

    public static void causuale(Random random, int[][] matrix) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                matrix[i][j] = random.nextInt(10);
            }
        }
    }

    public static void printMatrix(int[][] matrix) {
        for (int[] row : matrix) {
            for (int num : row) {
                System.out.print(num + "\t");
            }
            System.out.println();
        }
    }

    public void creaMarice() {
        matrice = new int[righe][colonne];
        System.out.print("Scegli il metodo di riempimento della matrice (1- Inserimento manuale, 2- Generazione casuale): ");
        Scanner scanner = new Scanner(System.in);
        int choice = scanner.nextInt();
        if (choice == 1) {
            manuale(scanner, matrice);
        } else if (choice == 2) {
            causuale(new Random(), matrice);
        }
        printMatrix(matrice);
    }

    public int[][] getMatrice() {
        return matrice;
    }
}
