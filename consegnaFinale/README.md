Progetto: Controllo Rimanenze Supermercato
Sviluppatore: Suleo

Tecnologie: Flutter, PHP, MySQL, SQLite

Abstract
Questa applicazione serve per gestire i prodotti di un supermercato. L'app mostra i prodotti, calcola gli sconti e avvisa l'utente quando un prodotto sta per scadere usando diversi colori. La caratteristica principale è che l'app funziona anche senza internet (offline) grazie a un database interno.

Struttura del Codice (Spiegazione delle Classi)
Il progetto è diviso in quattro file principali per rendere il codice più ordinato e professionale:

1. File model.dart
In questo file c'è la classe Prodotto:

Cosa fa: Definisce come è fatto un prodotto (id, nome, prezzi, giorni alla scadenza e categoria).

Metodi importanti: * fromMap: Trasforma i dati che arrivano dal database in un oggetto che Flutter può usare.

toMap: Trasforma l'oggetto in una mappa per salvarlo nel database o inviarlo al server.

percentualeSconto: Calcola automaticamente lo sconto tra il prezzo originale e quello scontato.

2. File helper.dart
In questo file c'è la classe DataHelper:

Cosa fa: Gestisce tutta la comunicazione. Si occupa di inviare e ricevere dati da internet (PHP) e di gestire la memoria interna (SQLite).

Metodi importanti:

fetchFromServer: Scarica la lista dei prodotti dal server.

getCachedProdotti: Se non c'è internet, legge i prodotti salvati nella memoria del telefono (cache).

insertProdotto, updateProdotto, deleteProdotto: Gestiscono le operazioni CRUD (aggiungere, modificare, eliminare) sul server.

3. File widgets.dart
In questo file c'è la classe ProdottoCard:

Cosa fa: Gestisce solo la parte visiva di un singolo prodotto nella lista.

Dettagli: Crea una "Card" con l'icona colorata (rosso, arancione o verde) in base ai giorni che mancano alla scadenza e mostra il prezzo barrato.

4. File main.dart
Qui ci sono le classi MyApp e ProdottiScreen:

MyApp: È il punto di partenza dell'app e imposta il tema blu.

ProdottiScreen: È la classe più importante per l'utente. Controlla lo stato dell'app, gestisce i filtri per categoria e l'ordinamento (per scadenza o per sconto). Apre anche la finestra (Dialog) per inserire o modificare i dati.

Motivazione delle scelte
Modularità: Ho diviso il codice in più classi per rispettare il principio di "singola responsabilità". Questo rende l'app più facile da correggere e migliorare.

Usabilità: Ho aggiunto colori e calcoli automatici per aiutare l'impiegato del supermercato a lavorare più velocemente.

Resilienza: L'uso di SQLite permette di vedere i dati anche se il Wi-Fi della scuola o del negozio non funziona.
