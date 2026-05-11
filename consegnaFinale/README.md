Progetto: Controllo Rimanenze Supermercato
Sviluppatore: Suleo

Tecnologie: Flutter, PHP, MySQL, SQLite

Abstract
Questa applicazione serve per gestire i prodotti di un supermercato. L'app mostra i prodotti, calcola gli sconti e avvisa l'utente quando un prodotto sta per scadere usando diversi colori. La caratteristica principale è che l'app funziona anche senza internet (offline) grazie a un database interno.

Struttura del Codice
Il progetto è diviso in 4 file principali:

model.dart (Classe Prodotto): Definisce i dati di ogni prodotto (nome, prezzo, scadenza) e calcola automaticamente la percentuale di sconto.

helper.dart (Classe DataHelper): Gestisce la comunicazione con il server (PHP) e salva i dati nella memoria del telefono (SQLite) per l'uso offline.

widgets.dart (Classe ProdottoCard): Gestisce l'interfaccia grafica di ogni prodotto nella lista, cambiando colore in base alla scadenza.

main.dart (Classe ProdottiScreen): È la schermata principale dell'app. Gestisce i filtri per categoria, l'ordinamento e l'inserimento di nuovi dati.
