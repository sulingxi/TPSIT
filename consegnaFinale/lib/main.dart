import 'package:flutter/material.dart';
import 'helper.dart';
import 'model.dart';
import 'widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Gestione Scadenze',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProdottiScreen(),
    );
  }
}

class ProdottiScreen extends StatefulWidget {
  const ProdottiScreen({super.key});

  @override
  State<ProdottiScreen> createState() => _ProdottiScreenState();
}

class _ProdottiScreenState extends State<ProdottiScreen> {
  List<Prodotto> _tuttiProdotti = [];
  String _categoriaSelezionata = 'Tutte';
  String _ordinamentoSelezionato = 'scadenza_asc';

  final Map<String, String> categorieMap = {
    '1': 'Latticini e Uova',
    '2': 'Panetteria e Dolci',
    '3': 'Carne e Pesce',
    '4': 'Frutta e Verdura',
    '5': 'Gastronomia',
  };

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await DataHelper.init();
    _loadData();
  }

  // carico dati (online o offline cache)
  Future<void> _loadData() async {
    try {
      final data = await DataHelper.fetchFromServer();
      setState(() { _tuttiProdotti = data; });
    } catch (e) {
      final cachedData = await DataHelper.getCachedProdotti();
      setState(() { _tuttiProdotti = cachedData; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline: Dati caricati dal DB locale (Cache)'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ordino e filtro
  List<Prodotto> get _prodottiFiltrati {
    List<Prodotto> filtrate = _tuttiProdotti.where((p) {
      if (_categoriaSelezionata == 'Tutte') return true;
      return p.categoriaId.toString() == _categoriaSelezionata;
    }).toList();

    filtrate.sort((a, b) {
      switch (_ordinamentoSelezionato) {
        case 'scadenza_asc': return a.giorniScadenza.compareTo(b.giorniScadenza);
        case 'scadenza_desc': return b.giorniScadenza.compareTo(a.giorniScadenza);
        case 'sconto_desc': return b.percentualeSconto.compareTo(a.percentualeSconto);
        case 'sconto_asc': return a.percentualeSconto.compareTo(b.percentualeSconto);
        default: return a.giorniScadenza.compareTo(b.giorniScadenza);
      }
    });
    return filtrate;
  }

  void _eseguiAzioneOffline() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Azione inibita: Sei Offline')));
  }

  // apro una finestra per aggiungere o modificare
  Future<void> _finestraProdotto({Prodotto? pEsistente}) async {
    final nomeCtrl = TextEditingController(text: pEsistente?.nome ?? '');
    final prezzoOrigCtrl = TextEditingController(text: pEsistente?.prezzoOriginale ?? '');
    final prezzoScontCtrl = TextEditingController(text: pEsistente?.prezzoScontato ?? '');
    final giorniCtrl = TextEditingController(text: pEsistente?.giorniScadenza.toString() ?? '');
    String catTemp = pEsistente != null ? pEsistente.categoriaId.toString() : '1';
    if (!categorieMap.containsKey(catTemp)) catTemp = '1';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setStateDialog) {
              return AlertDialog(
                title: Text(pEsistente != null ? 'Modifica Prodotto' : 'Nuovo Prodotto'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
                      TextField(controller: prezzoOrigCtrl, decoration: const InputDecoration(labelText: 'Prezzo Originale (€)'), keyboardType: TextInputType.number),
                      TextField(controller: prezzoScontCtrl, decoration: const InputDecoration(labelText: 'Prezzo Scontato (€)'), keyboardType: TextInputType.number),
                      TextField(controller: giorniCtrl, decoration: const InputDecoration(labelText: 'Giorni alla Scadenza'), keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Categoria'),
                        value: catTemp,
                        items: categorieMap.entries.map((entry) => DropdownMenuItem(value: entry.key, child: Text(entry.value))).toList(),
                        onChanged: (val) => setStateDialog(() => catTemp = val!),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annulla')),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Prodotto nuovoP = Prodotto(
                        id: pEsistente?.id,
                        nome: nomeCtrl.text,
                        prezzoOriginale: prezzoOrigCtrl.text,
                        prezzoScontato: prezzoScontCtrl.text,
                        giorniScadenza: int.tryParse(giorniCtrl.text) ?? 0,
                        categoriaId: int.parse(catTemp),
                      );

                      bool success = pEsistente != null
                          ? await DataHelper.updateProdotto(nuovoP)
                          : await DataHelper.insertProdotto(nuovoP);

                      if (success) {
                        _loadData();
                      } else {
                        _eseguiAzioneOffline();
                      }
                    },
                    child: const Text('Salva'),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listaMostrata = _prodottiFiltrati;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controllo Rimanenze'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Categoria:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: _categoriaSelezionata,
                      items: [
                        const DropdownMenuItem(value: 'Tutte', child: Text('Tutte le Categorie')),
                        ...categorieMap.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))),
                      ],
                      onChanged: (val) => setState(() => _categoriaSelezionata = val!),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ordina per:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: _ordinamentoSelezionato,
                      items: const [
                        DropdownMenuItem(value: 'scadenza_asc', child: Text('⏳ Scadenza: Vicina')),
                        DropdownMenuItem(value: 'scadenza_desc', child: Text('⏳ Scadenza: Lontana')),
                        DropdownMenuItem(value: 'sconto_desc', child: Text('🏷️ Sconto: Maggiore')),
                        DropdownMenuItem(value: 'sconto_asc', child: Text('🏷️ Sconto: Minore')),
                      ],
                      onChanged: (val) => setState(() => _ordinamentoSelezionato = val!),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: listaMostrata.isEmpty
                ? const Center(child: Text('Nessun prodotto trovato'))
                : ListView.builder(
              itemCount: listaMostrata.length,
              itemBuilder: (context, index) {
                final prodotto = listaMostrata[index];
                final catName = categorieMap[prodotto.categoriaId.toString()] ?? 'Sconosciuta';

                return ProdottoCard(
                  prodotto: prodotto,
                  nomeCategoria: catName,
                  onEdit: () => _finestraProdotto(pEsistente: prodotto),
                  onDelete: () async {
                    if (prodotto.id != null) {
                      bool success = await DataHelper.deleteProdotto(prodotto.id!);
                      if (success) {
                        _loadData();
                      } else {
                        _eseguiAzioneOffline();
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () => _finestraProdotto(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}