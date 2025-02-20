package org.example;

import java.util.concurrent.Semaphore;

public class Calocolare extends Thread {
    private int righe, colonne;
    private Matrice matrice, matrice2;
    private int[][] matrice3;
    private Semaphore[][] semaphores;
    private Semaphore somma;

    public Calocolare(int righe, int colonne, Matrice matrice, Matrice matrice2, int[][] matrice3, Semaphore[][] semaphores, Semaphore sumSemaphore) {
        this.righe = righe;
        this.colonne = colonne;
        this.matrice = matrice;
        this.matrice2 = matrice2;
        this.matrice3 = matrice3;
        this.semaphores = semaphores;
        this.somma = sumSemaphore;
    }

    @Override
    public void run() {
        int sommanum = 0;
        try {
            semaphores[righe][colonne].acquire();
            matrice3[righe][colonne] = 0;
            int n = matrice.getMatrice().length;
            for (int k = 0; k < n; k++) {
                matrice3[righe][colonne] += matrice.getMatrice()[righe][k] * matrice2.getMatrice()[k][colonne];
            }
            sleep(500);

            if (colonne + 1 < matrice3[0].length) {
                semaphores[righe][colonne + 1].release();
            } else if (righe + 1 < matrice3.length) {
                semaphores[righe + 1][0].release();
            } else {
                somma.release();
                for (int i = 0; i < matrice3.length; i++) {
                    for (int j = 0; j < matrice3[i].length; j++) {
                        sommanum += matrice3[i][j];
                    }
                }
                System.out.println("Somma totale della matrice: " + sommanum);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
