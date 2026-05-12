import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

// Classe per gestire tutte le comunicazioni con il server e il database locale
class DataHelper {
  static Database? _db;
  static const String url = 'http://10.82.183.59/supermecato';

  // Inizializzazione del database locale (SQLite)
  static Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'cache.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
          'CREATE TABLE cache_prodotti (id INTEGER PRIMARY KEY, nome TEXT, prezzo_originale TEXT, prezzo_scontato TEXT, giorni_scadenza INTEGER, categoria_id INTEGER)'
      ),
    );
  }

  // Scarico i dati dal server e li salvo nella cache per l'uso offline
  static Future<List<Prodotto>> fetchFromServer() async {
    final res = await http.get(Uri.parse('$url/prodotti.php')).timeout(const Duration(seconds: 3));
    if (res.statusCode == 200) {
      List<Prodotto> lista = (json.decode(res.body) as List).map((i) => Prodotto.fromMap(i)).toList();
      await _db!.delete('cache_prodotti');
      for (var p in lista) { await _db!.insert('cache_prodotti', p.toMap()); }
      return lista;
    }
    throw Exception('Errore Server');
  }

  // Lettura dati offline dalla memoria del telefono
  static Future<List<Prodotto>> getCachedProdotti() async {
    final data = await _db!.query('cache_prodotti');
    return data.map((i) => Prodotto.fromMap(i)).toList();
  }

  // Funzioni base per aggiungere, modificare e cancellare prodotti
  static Future<bool> insertProdotto(Prodotto p) async {
    try {
      final res = await http.post(Uri.parse('$url/addprodotti.php'), body: json.encode(p.toMap()));
      return res.statusCode == 200;
    } catch (e) { return false; }
  }

  static Future<bool> updateProdotto(Prodotto p) async {
    try {
      final res = await http.put(Uri.parse('$url/modificaprodotto.php'), body: json.encode(p.toMap()));
      return res.statusCode == 200;
    } catch (e) { return false; }
  }

  static Future<bool> deleteProdotto(int id) async {
    try {
      final res = await http.delete(Uri.parse('$url/deleteprodotto.php?id=$id'));
      return res.statusCode == 200;
    } catch (e) { return false; }
  }
}
