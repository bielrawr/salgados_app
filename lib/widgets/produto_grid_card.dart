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
            child: produto.imageUrls.isNotEmpty
                ? Image.network(
                    produto.imageUrls.first,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => const Icon(Icons.error),
                  )
                : Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${produto.preco.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                      onPressed: onAdicionarCarrinho,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  produto.descricao,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
