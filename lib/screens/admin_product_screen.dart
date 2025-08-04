
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminProductScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const AdminProductScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _products = [];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _dbHelper.getProdutosPorCategoria(widget.categoryId);
    setState(() {
      _products = products;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = image;
    });
  }

  void _showAddEditProductDialog({Map<String, dynamic>? product}) {
    if (product != null) {
      _productNameController.text = product['nome'];
      _productDescriptionController.text = product['descricao'];
      _productPriceController.text = product['preco'].toString();
      _pickedImage = null; // Clear image when editing, user can pick new one
    } else {
      _productNameController.clear();
      _productDescriptionController.clear();
      _productPriceController.clear();
      _pickedImage = null;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product == null ? 'Adicionar Produto' : 'Editar Produto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    hintText: 'Nome do Produto',
                  ),
                ),
                TextField(
                  controller: _productDescriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Descrição do Produto',
                  ),
                ),
                TextField(
                  controller: _productPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Preço',
                  ),
                ),
                const SizedBox(height: 10),
                _pickedImage != null
                    ? Image.file(File(_pickedImage!.path), height: 100)
                    : (product != null && product['caminho_imagem'] != null
                        ? Image.file(File(product['caminho_imagem']), height: 100)
                        : const Text('Nenhuma imagem selecionada')),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Selecionar Imagem'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(product == null ? 'Adicionar' : 'Salvar'),
              onPressed: () async {
                if (_productNameController.text.isNotEmpty &&
                    _productPriceController.text.isNotEmpty) {
                  final newProduct = {
                    'nome': _productNameController.text,
                    'descricao': _productDescriptionController.text,
                    'preco': double.parse(_productPriceController.text),
                    'categoria_id': widget.categoryId,
                  };

                  int productId;
                  if (product == null) {
                    productId = await _dbHelper.salvarProduto(newProduct);
                  } else {
                    productId = product['id'];
                    await _dbHelper.atualizarProduto({'id': productId, ...newProduct});
                  }

                  if (_pickedImage != null) {
                    // Save image path to database
                    await _dbHelper.salvarImagemProduto({
                      'produto_id': productId,
                      'caminho_imagem': _pickedImage!.path,
                    });
                  }

                  _loadProducts();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int id) async {
    await _dbHelper.deletarProduto(id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos de ${widget.categoryName}'),
        backgroundColor: const Color(0xFFFF6600),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditProductDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product['nome']),
            subtitle: Text('R\$ ${product['preco'].toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showAddEditProductDialog(product: product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteProduct(product['id']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
