# ZKeep

Una semplice applicazione ispirata a Google Keep sviluppata in Flutter + Dart + SQLite.

Questo programma include:
Un'app Flutter che permette di creare più note
Ogni nota contiene una lista di promemoria
Un database SQLite locale con due tabelle: notes e todos
Una schermata principale con le card delle note
Una schermata di dettaglio per vedere i todo della nota scelta
Un FloatingActionButton per aggiungere una nota o un promemoria

Funzionalità principali
Inserisci il titolo di una nuova nota
Apri una nota con un click
Aggiungi uno o più promemoria dentro la nota
Cambia stato del promemoria con un click
Cancella una nota o un promemoria con pressione lunga
Salvataggio locale dei dati anche dopo la chiusura dell'app

Struttura del progetto
main.dart contiene la logica principale dell'app
model.dart contiene le classi Note e Todo
helper.dart contiene la gestione del database SQLite
widgets.dart contiene i widget NoteCard e TodoItem

Autore
Su Leo
