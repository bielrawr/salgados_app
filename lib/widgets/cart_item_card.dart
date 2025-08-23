import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import '../models/item_carrinho.dart';

class CartItemCard extends StatelessWidget {
  final ItemCarrinho item;
  final String productId;

  const CartItemCard({
    super.key,
    required this.item,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            // Product Image
            if (item.produto.imageUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.produto.imageUrls.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ), // Added missing parenthesis here
              )
            else
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            const SizedBox(width: 10), // Spacing between image and text

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.produto.nome,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'R\$ ${item.produto.preco.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  if (item.produto.descricao.isNotEmpty) // Display description if available
                    Text(
                      item.produto.descricao,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    cart.decreaseQuantity(productId);
                  },
                ),
                Text('${item.quantidade}', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    cart.increaseQuantity(productId);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    cart.removeItem(productId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}