import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:salgados_app/screens/mercadopago_webview_screen.dart';
import 'package:salgados_app/services/mercadopago_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/cart_provider.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  Future<void> _launchWhatsApp(CartProvider cart) async {
    final String phoneNumber = '+5537999385971';
    String message = 'Olá! Gostaria de fazer o seguinte pedido:\n\n';

    if (cart.itemCount == 0) {
      message += 'Meu carrinho está vazio.';
    } else {
      cart.items.forEach((productId, item) {
        message += '${item.produto.nome} - ${item.quantidade}x - R\$ ${item.total.toStringAsFixed(2)}\n';
      });
      message += '\nTotal do Pedido: R\$ ${cart.totalAmount.toStringAsFixed(2)}';
      message += '\n\nObservação: ';
    }

    final Uri whatsappUrl = Uri.parse('whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  Future<void> _startMercadoPagoCheckout(CartProvider cart) async {
    if (cart.itemCount == 0) return;

    setState(() {
      _isLoading = true;
    });

    final mercadoPagoService = MercadoPagoService();
    final items = cart.items.values.toList();

    final initPoint = await mercadoPagoService.createPaymentPreference(items: items);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (initPoint != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MercadoPagoWebViewScreen(initialUrl: initPoint),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao iniciar o pagamento. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Carrinho'),
        backgroundColor: const Color(0xFFFF6600),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: cart.itemCount == 0
                ? const Center(
                    child: Text('Seu carrinho está vazio!',
                        style: TextStyle(fontSize: 18)),
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
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
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
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: (cart.itemCount > 0 && !_isLoading)
                      ? () => _launchWhatsApp(cart)
                      : null,
                  icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                  label: const Text('Finalizar via WhatsApp',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: (cart.itemCount > 0 && !_isLoading)
                      ? () => _startMercadoPagoCheckout(cart)
                      : null,
                  icon: const Icon(Icons.payment, color: Colors.white),
                  label: const Text('Pagar com Mercado Pago',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009EE3), // Cor do Mercado Pago
                    minimumSize: const Size(double.infinity, 50),
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
