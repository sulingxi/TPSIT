// classe per un prodotto
class Prodotto {
  Prodotto({
    this.id,
    required this.nome,
    this.prezzoOriginale,
    required this.prezzoScontato,
    required this.giorniScadenza,
    required this.categoriaId,
  });

  final int? id;
  final String nome;
  final String? prezzoOriginale;
  final String prezzoScontato;
  final int giorniScadenza;
  final int categoriaId;

  // prendo una mappa (dal db o json) e faccio oggetto prodotto
  factory Prodotto.fromMap(Map<String, dynamic> map) {
    return Prodotto(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      nome: map['nome'],
      prezzoOriginale: map['prezzo_originale']?.toString(),
      prezzoScontato: map['prezzo_scontato'].toString(),
      giorniScadenza: int.parse(map['giorni_scadenza'].toString()),
      categoriaId: int.parse(map['categoria_id'].toString()),
    );
  }

  // trasformo oggetto in mappa per database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'prezzo_originale': prezzoOriginale ?? '',
      'prezzo_scontato': prezzoScontato,
      'giorni_scadenza': giorniScadenza,
      'categoria_id': categoriaId,
    };
  }

  // calcolo percentuale sconto
  double get percentualeSconto {
    if (prezzoOriginale == null || prezzoOriginale!.isEmpty) return 0.0;
    double orig = double.tryParse(prezzoOriginale!) ?? 0.0;
    double scont = double.tryParse(prezzoScontato) ?? 0.0;
    if (orig <= 0) return 0.0;
    return ((orig - scont) / orig) * 100;
  }
}