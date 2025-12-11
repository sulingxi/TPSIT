import 'package:flutter/material.dart';
import 'dart:io';       // Stream di input/output
import 'dart:convert';  // Codifica e decodifica dei dati

void main() {
  runApp(const MyApp()); // Punto di ingresso dell'app
}

// Widget principale dell'app (non cambia stato)
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Costruttore

  @override
  Widget build(BuildContext context) {  // Metodo che costruisce l'interfaccia
    return const MaterialApp(
      home: ChatPage(), // Pagina iniziale
    );
  }
}

// Pagina della chat (Widget con stato)
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Socket? _socket; // Socket per la connessione al server

  final TextEditingController _username =
  TextEditingController(); // Controlla l'input dello username

  final TextEditingController _message =
  TextEditingController(); // Controlla l'input del messaggio

  final List<String> _messagi = []; // Lista dei messaggi della chat

  bool collegare = false; // Stato della connessione (true = connesso)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('chatroom di su')),
      body: Padding(
        padding: const EdgeInsets.all(12), // Margine interno di 12 pixel
        child: Column( // I widget sono disposti in verticale
          children: [
            Row( // Riga orizzontale
              children: [
                Expanded( // Occupa tutto lo spazio disponibile
                  child: TextField(
                    controller: _username, // Controlla il campo username
                    decoration: const InputDecoration(
                      labelText: 'username', // Testo sopra il campo
                      border: OutlineInputBorder(), // Bordo del campo
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async { // Quando si preme il pulsante
                    final username =
                    _username.text.trim(); // Prende lo username
                    if (username.isEmpty) return; // Se è vuoto, esce

                    try {
                      // Connessione al server
                      final socket =
                      await Socket.connect('192.168.0.0', 3000);//ip reale di computer

                      _socket = socket; // Salva il socket

                      setState(() {
                        collegare = true; // Imposta lo stato come connesso
                      });

                      // Ascolta i messaggi dal server
                      _socket?.listen((data) {
                        final msg = utf8.decode(data).trim();
                        setState(() {
                          _messagi.add(msg); // Aggiunge il messaggio alla lista
                        });
                      });

                    } catch (e) {
                      print('abbiamo perso: $e'); // Errore di connessione
                    }
                  },
                  child: const Text('collegare'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Mostra lo stato della connessione
            Text(collegare ? 'collegato' : 'non collegato'),

            // Lista dei messaggi con scorrimento
            Expanded(
              child: ListView.builder(
                itemCount: _messagi.length, // Numero di messaggi
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 4), // Spaziatura
                    child: Text(_messagi[index]), // Mostra il messaggio
                  );
                },
              ),
            ),

            // Barra per scrivere e inviare messaggi
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _message,
                    decoration: const InputDecoration(
                      labelText: 'inserisci',
                      border: OutlineInputBorder(),
                    ),
                    enabled: collegare, // Attivo solo se connesso
                    onSubmitted: (_) =>
                        _sendMessage(), // Invio con Enter
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: collegare ? _sendMessage : null,
                  child: const Text('indiviare'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Metodo per inviare un messaggio
  void _sendMessage() {
    if (_socket == null) return;

    final text = _message.text.trim();
    if (text.isEmpty) return;

    final username = _username.text.trim();
    final fullMessage = "$username: $text";

    _socket!.write(fullMessage + "\n"); // Invia il messaggio al server

    _message.clear(); // Pulisce il campo di input
  }
}
