import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Re-added url_launcher import
import '../services/cart_provider.dart';
import '../models/item_carrinho.dart'; // Assuming ItemCarrinho is needed for display
import '../widgets/cart_item_card.dart'; // Import the CartItemCard


class CartScreen extends StatelessWidget { // Changed class name
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    Future<void> _launchWhatsApp() async {
      final String phoneNumber = '+5537999385971'; // User's WhatsApp number
      String message = 'Olá! Gostaria de fazer o seguinte pedido:\n\n';

      if (cart.itemCount == 0) {
        message += 'Meu carrinho está vazio.';
      } else {
        cart.items.forEach((productId, item) {
          message += '${item.produto.nome} - ${item.quantidade}x - R\$ ${item.total.toStringAsFixed(2)}\n';
        });
        message += '\nTotal do Pedido: R\$ ${cart.totalAmount.toStringAsFixed(2)}';
        message += '\n\nObservação: '; // Empty observation field
      }

      final Uri whatsappUrl = Uri.parse('whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}');

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else {
        throw 'Could not launch $whatsappUrl';
      }
    }





    return Scaffold( // Changed from Container to Scaffold for a full screen
      appBar: AppBar(
        title: const Text('Seu Carrinho'),
        backgroundColor: const Color(0xFFFF6600),
        // Removed actions as requested (X button)
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: cart.itemCount == 0
                ? const Center(
                    child: Text('Seu carrinho está vazio!', style: TextStyle(fontSize: 18)),
                  )
                : ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (ctx, i) {
                      final item = cart.items.values.toList()[i];
                      return CartItemCard(
                        item: item,
                        productId: item.produto.id!,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: cart.itemCount > 0 ? _launchWhatsApp : null,
                  icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                  label: const Text('Finalizar Pedido', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // WhatsApp green
                    minimumSize: const Size(double.infinity, 50), // Full width button
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
