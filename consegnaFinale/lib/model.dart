// Classe base per definire come è fatto un prodotto
class Prodotto {
  int? id;
  String nome;
  String prezzoOriginale;
  String prezzoScontato;
  int giorniScadenza;
  int categoriaId;

  Prodotto({
    this.id,
    required this.nome,
    required this.prezzoOriginale,
    required this.prezzoScontato,
    required this.giorniScadenza,
    required this.categoriaId,
  });

  // Trasforma i dati ricevuti dal database in un oggetto Dart
  factory Prodotto.fromMap(Map<String, dynamic> map) {
    return Prodotto(
      id: map['id'] != null ? int.parse(map['id'].toString()) : null,
      nome: map['nome'].toString(),
      prezzoOriginale: map['prezzo_originale'].toString(),
      prezzoScontato: map['prezzo_scontato'].toString(),
      giorniScadenza: int.parse(map['giorni_scadenza'].toString()),
      categoriaId: int.parse(map['categoria_id'].toString()),
    );
  }

  // Prepara i dati per salvarli nel database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'prezzo_originale': prezzoOriginale,
      'prezzo_scontato': prezzoScontato,
      'giorni_scadenza': giorniScadenza,
      'categoria_id': categoriaId,
    };
  }
}
