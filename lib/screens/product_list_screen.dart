
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salgados_app/models/produto.dart';
import 'package:salgados_app/services/product_firestore_service.dart';
import 'package:salgados_app/widgets/produto_grid_card.dart';
import 'package:salgados_app/services/cart_provider.dart';
import 'package:salgados_app/screens/cart_screen.dart'; // Added this line

class ProductListScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductFirestoreService _productFirestoreService = ProductFirestoreService();
  List<Produto> _products = [];

  @override
  void initState() {
    super.initState();
    _listenToProducts();
  }

  void _listenToProducts() {
    _productFirestoreService.getProductsByCategory(widget.categoryId).listen((products) {
      setState(() {
        _products = products;
      });
    });
  }

  void _addToCart(Produto product) {
    Provider.of<CartProvider>(context, listen: false).addItem(product, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.nome} adicionado ao carrinho!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos de ${widget.categoryName}'),
        backgroundColor: const Color(0xFFFF6600),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.black.withOpacity(0.8)), // Black with 20% transparency
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const CartScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0); // From right
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.green, // Green color for the badge
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cart.itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ), 
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: _products.isEmpty
          ? const Center(child: Text('Nenhum produto encontrado nesta categoria.'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProdutoGridCard(
                  produto: product,
                  onAdicionarCarrinho: () => _addToCart(product),
                );
              },
            ),
    );
  }
}
