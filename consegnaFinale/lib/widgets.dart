import 'package:flutter/material.dart';
import 'model.dart';

// Componente visivo per mostrare un singolo prodotto nella lista
class ProdottoCard extends StatelessWidget {
  final Prodotto prodotto;
  final String nomeCategoria;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProdottoCard({
    super.key,
    required this.prodotto,
    required this.nomeCategoria,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Colore rosso se scade entro 3 giorni, altrimenti verde
    Color coloreIcona = prodotto.giorniScadenza <= 3 ? Colors.red : Colors.green;

    // Controllo per evitare che scriva "null" se il prezzo originale è vuoto nel database
    String prezzoOrig = prodotto.prezzoOriginale == 'null' ? '0.00' : prodotto.prezzoOriginale;

    return Card(
      child: ListTile(
        leading: Icon(Icons.inventory_2, size: 40, color: coloreIcona),
        title: Text(prodotto.nome, style: const TextStyle(fontWeight: FontWeight.bold)),

        // Uso una Column per mettere la categoria sopra e i prezzi sotto
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cat: $nomeCategoria | Scade in: ${prodotto.giorniScadenza} gg'),
            const SizedBox(height: 4), 
            // Uso una Row per mettere i due prezzi vicini
            Row(
              children: [
                // Prezzo Originale (Rosso)
                Text('€$prezzoOrig', style: const TextStyle(color: Colors.red, decoration: TextDecoration.lineThrough)),
                const Text('  ➔  '),
                // Prezzo Scontato (Verde e Grassetto)
                Text('€${prodotto.prezzoScontato}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.grey), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
