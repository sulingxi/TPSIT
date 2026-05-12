import 'package:flutter/material.dart';
import 'helper.dart';
import 'model.dart';
import 'widgets.dart';

void main() => runApp(const MaterialApp(home: ProdottiScreen()));

class ProdottiScreen extends StatefulWidget {
  const ProdottiScreen({super.key});
  @override
  State<ProdottiScreen> createState() => _ProdottiScreenState();
}

class _ProdottiScreenState extends State<ProdottiScreen> {
  List<Prodotto> _tuttiProdotti = [];
  String _categoriaSelezionata = 'Tutte'; // Mantengo solo questa variabile per il filtro

  @override
  void initState() {
    super.initState();
    DataHelper.init().then((_) => _loadData()); // Inizializzazione rapida
  }

  // Logica semplice per caricare i dati (da internet o dalla cache)
  Future<void> _loadData() async {
    try {
      _tuttiProdotti = await DataHelper.fetchFromServer();
    } catch (e) {
      _tuttiProdotti = await DataHelper.getCachedProdotti();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Modalità Offline!')));
      }
    }
    setState(() {}); // Aggiorna l'interfaccia
  }

  // Finestra semplice: uso solo campi di testo per non complicare il codice
  Future<void> _finestraProdotto({Prodotto? pEsistente}) async {
    final nomeCtrl = TextEditingController(text: pEsistente?.nome ?? '');
    final pOrigCtrl = TextEditingController(text: pEsistente?.prezzoOriginale ?? '');
    final pScontCtrl = TextEditingController(text: pEsistente?.prezzoScontato ?? '');
    final giorniCtrl = TextEditingController(text: pEsistente?.giorniScadenza.toString() ?? '');
    final catCtrl = TextEditingController(text: pEsistente?.categoriaId.toString() ?? '1'); // L'ID si inserisce a mano

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pEsistente != null ? 'Modifica' : 'Nuovo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: pOrigCtrl, decoration: const InputDecoration(labelText: 'Prezzo Originale')),
            TextField(controller: pScontCtrl, decoration: const InputDecoration(labelText: 'Prezzo Scontato')),
            TextField(controller: giorniCtrl, decoration: const InputDecoration(labelText: 'Giorni (Scadenza)')),
            TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'ID Categoria (1-5)')),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              Prodotto nuovoP = Prodotto(
                id: pEsistente?.id,
                nome: nomeCtrl.text,
                prezzoOriginale: pOrigCtrl.text,
                prezzoScontato: pScontCtrl.text,
                giorniScadenza: int.tryParse(giorniCtrl.text) ?? 0,
                categoriaId: int.tryParse(catCtrl.text) ?? 1,
              );

              bool ok = pEsistente != null
                  ? await DataHelper.updateProdotto(nuovoP)
                  : await DataHelper.insertProdotto(nuovoP);

              if (ok) _loadData(); // Se ha successo, ricarico la lista
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtro per categoria e ordino automaticamente per scadenza più vicina
    List<Prodotto> lista = _tuttiProdotti.where((p) =>
    _categoriaSelezionata == 'Tutte' || p.categoriaId.toString() == _categoriaSelezionata
    ).toList();
    lista.sort((a, b) => a.giorniScadenza.compareTo(b.giorniScadenza));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rimanenze'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body: Column(
        children: [
          // Menu a tendina per filtrare la lista
          DropdownButton<String>(
            value: _categoriaSelezionata,
            items: const [
              DropdownMenuItem(value: 'Tutte', child: Text('Tutte le Categorie')),
              DropdownMenuItem(value: '1', child: Text('1. Latticini')),
              DropdownMenuItem(value: '2', child: Text('2. Dolci')),
              DropdownMenuItem(value: '3', child: Text('3. Carne')),
              DropdownMenuItem(value: '4', child: Text('4. Frutta')),
              DropdownMenuItem(value: '5', child: Text('5. Gastronomia')),
            ],
            onChanged: (val) => setState(() => _categoriaSelezionata = val!),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, i) {
                return ProdottoCard(
                  prodotto: lista[i],
                  nomeCategoria: 'ID Cat: ${lista[i].categoriaId}',
                  onEdit: () => _finestraProdotto(pEsistente: lista[i]),
                  onDelete: () async {
                    await DataHelper.deleteProdotto(lista[i].id!);
                    _loadData();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _finestraProdotto(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
