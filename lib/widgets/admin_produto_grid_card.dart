import 'package:flutter/material.dart';
import '../models/produto.dart';

class AdminProdutoGridCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminProdutoGridCard({
    super.key,
    required this.produto,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.05),
              child: Image.network(
                produto.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => const Center(child: Icon(Icons.error, color: Colors.red)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(produto.nome, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.green), onPressed: onEdit),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
            ],
          )
        ],
      ),
    );
  }
}
