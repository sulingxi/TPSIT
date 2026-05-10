import 'package:flutter/material.dart';
import 'model.dart';

class ProdottoCard extends StatelessWidget {
  const ProdottoCard({
    super.key,
    required this.prodotto,
    required this.nomeCategoria,
    required this.onEdit,
    required this.onDelete,
  });

  final Prodotto prodotto;
  final String nomeCategoria;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  Color _getColor(int giorni) {
    if (giorni <= 1) return Colors.red.shade700;
    if (giorni <= 3) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getColor(prodotto.giorniScadenza);
    final bool haPrezzoOriginale = prodotto.prezzoOriginale != null && prodotto.prezzoOriginale!.isNotEmpty && prodotto.prezzoOriginale != '0.00';
    final String prezzoOriginaleStr = haPrezzoOriginale ? '€${prodotto.prezzoOriginale} ' : '';
    final double percentuale = prodotto.percentualeSconto;
    final String stringaPercentuale = percentuale > 0 ? ' (-${percentuale.toInt()}%)' : '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.inventory_2, size: 36, color: urgencyColor),
        title: Text(
          prodotto.nome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
            children: [
              TextSpan(text: 'Cat: $nomeCategoria\n'),
              TextSpan(text: prezzoOriginaleStr, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
              TextSpan(text: '€${prodotto.prezzoScontato}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              TextSpan(text: stringaPercentuale, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              const TextSpan(text: ' | '),
              TextSpan(text: 'Scade in: ${prodotto.giorniScadenza} gg', style: TextStyle(color: urgencyColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.grey), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}