package org.example;

import java.util.Scanner;
import java.util.concurrent.Semaphore;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Inserisci il numero di righe della matrice: ");
        int righe = scanner.nextInt();
        System.out.print("Inserisci il numero di colonne della matrice: ");
        int colonne = scanner.nextInt();
        Matrice matrice1 = new Matrice(righe, colonne);
        matrice1.creaMarice();

        System.out.print("Inserisci il numero di righe della seconda matrice: ");
        int righe2 = scanner.nextInt();
        System.out.print("Inserisci il numero di colonne della seconda matrice: ");
        int colonne2 = scanner.nextInt();
        Matrice matrice2 = new Matrice(righe2, colonne2);
        matrice2.creaMarice();

        int[][] matrice3 = new int[righe][colonne2];

        if (colonne == righe2) {
            Semaphore[][] semaphores = new Semaphore[righe][colonne2];
            Semaphore somma = new Semaphore(0);

            for (int i = 0; i < righe; i++) {
                for (int j = 0; j < colonne2; j++) {
                    semaphores[i][j] = new Semaphore(0);
                }
            }

            Thread[][] threads = new Thread[righe][colonne2];
            for (int i = 0; i < righe; i++) {
                for (int j = 0; j < colonne2; j++) {
                    threads[i][j] = new Calocolare(i, j, matrice1, matrice2, matrice3, semaphores, somma);
                    threads[i][j].start();
                }
            }

            semaphores[0][0].release();

            try {
                somma.acquire();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Non puoi fare moltiplicazione di matrice, perché colonne non uguale a righe");
        }
    }
}
