import 'package:flutter/material.dart';
import '../models/produto.dart';

class ProdutoGridCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onAdicionarCarrinho;

  const ProdutoGridCard({super.key, required this.produto, required this.onAdicionarCarrinho});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(produto.imageUrl, fit: BoxFit.cover, errorBuilder: (ctx, err, st) => const Icon(Icons.error)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(produto.nome, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('R\$ ${produto.preco.toStringAsFixed(2)}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAdicionarCarrinho,
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text('Adicionar'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
