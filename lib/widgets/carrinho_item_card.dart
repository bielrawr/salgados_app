import 'package:flutter/material.dart';
import '../models/item_carrinho.dart';

class CarrinhoItemCard extends StatelessWidget {
  final ItemCarrinho item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CarrinhoItemCard({super.key, required this.item, required this.onIncrement, required this.onDecrement, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(item.produto.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.produto.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(item.produto.descricao, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('Preço Unitário: R\$ ${item.produto.preco.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                _buildQuantityButton(context, Icons.add_circle_outline, onIncrement, Colors.green),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(item.quantidade.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                _buildQuantityButton(context, Icons.remove_circle_outline, onDecrement, Colors.orange),
                const SizedBox(width: 8),
                _buildQuantityButton(context, Icons.delete_outline, onRemove, Colors.red),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, IconData icon, VoidCallback onPressed, Color color) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
