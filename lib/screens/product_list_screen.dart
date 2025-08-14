
import 'package:flutter/material.dart';
import 'package:salgados_app/models/produto.dart';
import 'package:salgados_app/services/product_firestore_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos de ${widget.categoryName}'),
        backgroundColor: const Color(0xFFFF6600),
      ),
      body: _products.isEmpty
          ? const Center(child: Text('Nenhum produto encontrado nesta categoria.'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: product.imageUrls.isNotEmpty
                      ? Image.network(
                          product.imageUrls.first,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, st) =>
                              const Icon(Icons.image_not_supported),
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(product.nome),
                  subtitle: Text(product.descricao),
                  trailing: Text('R\$ ${product.preco.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
