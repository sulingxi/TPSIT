import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class DataHelper {
  static Database? _database;
  static const String baseUrl = 'http://10.82.183.59/supermecato';

  // inizializzo il database
  static Future<void> init() async {
    String path = join(await getDatabasesPath(), 'supermercato_cache.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE cache_prodotti (
            id INTEGER PRIMARY KEY,
            nome TEXT,
            prezzo_originale TEXT,
            prezzo_scontato TEXT,
            giorni_scadenza INTEGER,
            categoria_id INTEGER
          )
        ''');
      },
    );
  }

  // salvo in cache
  static Future<void> _salvaInCache(List<Prodotto> prodotti) async {
    if (_database == null) return;
    await _database!.delete('cache_prodotti');
    for (var p in prodotti) {
      await _database!.insert('cache_prodotti', p.toMap());
    }
  }

  // prendere tutti i prodotti dal server (se fallisce, lancia errore)
  static Future<List<Prodotto>> fetchFromServer() async {
    final response = await http.get(Uri.parse('$baseUrl/prodotti.php')).timeout(const Duration(seconds: 3));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<Prodotto> prodotti = data.map((item) => Prodotto.fromMap(item)).toList();
      await _salvaInCache(prodotti);
      return prodotti;
    }
    throw Exception('Server error');
  }

  // prendere i prodotti dalla cache sqlite
  static Future<List<Prodotto>> getCachedProdotti() async {
    if (_database == null) return [];
    final List<Map<String, dynamic>> cachedData = await _database!.query('cache_prodotti');
    return cachedData.map((item) => Prodotto.fromMap(item)).toList();
  }

  // salvo un nuovo prodotto (POST)
  static Future<bool> insertProdotto(Prodotto p) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addprodotti.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(p.toMap()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // aggiorno prodotto (PUT)
  static Future<bool> updateProdotto(Prodotto p) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/modificaprodotto.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(p.toMap()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // cancello un prodotto (DELETE)
  static Future<bool> deleteProdotto(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/deleteprodotto.php?id=$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}