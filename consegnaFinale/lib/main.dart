import 'package:flutter/material.dart';
import 'helper.dart';
import 'model.dart';
import 'widgets.dart';

// Punto di partenza dell'applicazione.
void main() => runApp(const MaterialApp(home: ProdottiScreen()));

// Schermata principale.
class ProdottiScreen extends StatefulWidget {
  const ProdottiScreen({super.key});
  @override
  State<ProdottiScreen> createState() => _ProdottiScreenState();
}

class _ProdottiScreenState extends State<ProdottiScreen> {
  // Lista vuota per i prodotti
  List<Prodotto> _tuttiProdotti = [];
  // Categoria di default
  String _categoriaSelezionata = 'Tutte';

  @override
  void initState() {
    super.initState();
    DataHelper.init().then((_) => _loadData());
  }

  // Funzione per caricare i dati
  Future<void> _loadData() async {
    try {
      _tuttiProdotti = await DataHelper.fetchFromServer();
    } catch (e) {
      _tuttiProdotti = await DataHelper.getCachedProdotti();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Modalità Offline!')));
      }
    }
    setState(() {});
  }

  Future<void> _finestraProdotto({Prodotto? pEsistente}) async {

    // 1. Prima creo le caselle di testo vuote
    final nomeCtrl = TextEditingController();
    final pOrigCtrl = TextEditingController();
    final pScontCtrl = TextEditingController();
    final giorniCtrl = TextEditingController();
    final catCtrl = TextEditingController();

    // 2. Uso un IF classico per riempire le caselle se sto modificando
    String titoloFinestra = 'Nuovo Prodotto';

    if (pEsistente != null) {
      // Se il prodotto esiste già, riempio le caselle con i vecchi dati
      titoloFinestra = 'Modifica Prodotto';
      nomeCtrl.text = pEsistente.nome;
      pOrigCtrl.text = pEsistente.prezzoOriginale;
      pScontCtrl.text = pEsistente.prezzoScontato;
      giorniCtrl.text = pEsistente.giorniScadenza.toString();
      catCtrl.text = pEsistente.categoriaId.toString();
    } else {
      // Se è nuovo, metto solo la categoria 1 di default
      catCtrl.text = '1';
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titoloFinestra),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: pOrigCtrl, decoration: const InputDecoration(labelText: 'Prezzo Originale')),
              TextField(controller: pScontCtrl, decoration: const InputDecoration(labelText: 'Prezzo Scontato')),
              TextField(controller: giorniCtrl, decoration: const InputDecoration(labelText: 'Giorni (Scadenza)')),
              TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'ID Categoria (1-5)')),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Leggo i testi inseriti per creare il pacchetto
              int giorni = int.tryParse(giorniCtrl.text) ?? 0;
              int categoria = int.tryParse(catCtrl.text) ?? 1;

              Prodotto nuovoP = Prodotto(
                id: pEsistente?.id,
                nome: nomeCtrl.text,
                prezzoOriginale: pOrigCtrl.text,
                prezzoScontato: pScontCtrl.text,
                giorniScadenza: giorni,
                categoriaId: categoria,
              );

              // 3. Uso un IF classico per decidere se Aggiornare o Inserire
              bool ok = false;
              if (pEsistente != null) {
                // Se esisteva, aggiorno
                ok = await DataHelper.updateProdotto(nuovoP);
              } else {
                // Se è nuovo, inserisco
                ok = await DataHelper.insertProdotto(nuovoP);
              }

              if (ok) {
                _loadData();
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
