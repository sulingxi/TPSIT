# ZKeep

autore: Su Leo

## Descrizione
ZKeep è una applicazione semplice ispirata a Google Keep.

In questa app ci sono più note e ogni nota contiene una lista di promemoria.
L'utente può creare una nuova nota e poi aggiungere i todo dentro la nota scelta.

## Scelte di sviluppo
Ho mantenuto una struttura semplice con 4 file principali, simile all'esempio del professore.
Ho usato SQLite perché i dati devono restare salvati anche dopo la chiusura dell'app.
Ho creato due tabelle: `notes` e `todos`.
Ho separato note e todo perché una nota può contenere più promemoria.
Ho usato le card per mostrare le note nella pagina principale in modo più chiaro.
Ho usato il FloatingActionButton per aggiungere una nota o un promemoria.
Ho fatto una schermata principale per vedere le note e una schermata di dettaglio per vedere i todo della nota scelta.

## Funzioni principali
aggiunta di una nuova nota
visualizzazione di più note
apertura di una nota
aggiunta di promemoria dentro una nota
cambio stato del promemoria
cancellazione di una nota
cancellazione di un promemoria
salvataggio locale dei dati

## Per cancellare è necessaria una pressione prolungata.
