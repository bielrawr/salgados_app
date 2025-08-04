
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/produto.dart';
import '../models/imagem_produto.dart';
import 'dart:io';

class ProductListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductListScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Produto> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productsData = await _dbHelper.getProdutosPorCategoria(widget.categoryId);
    List<Produto> loadedProducts = [];
    for (var productMap in productsData) {
      final product = Produto.fromMap(productMap);
      loadedProducts.add(product);
    }
    setState(() {
      _products = loadedProducts;
    });
  }

  Future<List<ImagemProduto>> _loadProductImages(int productId) async {
    final imagesData = await _dbHelper.getImagensPorProduto(productId);
    return imagesData.map((imageMap) => ImagemProduto.fromMap(imageMap)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos de ${widget.categoryName}'),
        backgroundColor: const Color(0xFFFF6600),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return FutureBuilder<List<ImagemProduto>>(
            future: _loadProductImages(product.id),
            builder: (context, snapshot) {
              String? imageUrl;
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                imageUrl = snapshot.data!.first.caminhoImagem;
              }
              return ListTile(
                leading: imageUrl != null
                    ? Image.file(File(imageUrl), width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported),
                title: Text(product.nome),
                subtitle: Text(product.descricao),
                trailing: Text('R\$ ${product.preco.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
