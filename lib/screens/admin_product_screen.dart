import 'package:flutter/material.dart';
import 'package:salgados_app/models/produto.dart';
import 'package:salgados_app/services/product_firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AdminProductScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const AdminProductScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  final ProductFirestoreService _productFirestoreService = ProductFirestoreService();
  List<Produto> _products = [];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  XFile? _selectedImageFile;

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImageFile = image;
      });
    }
  }

  void _showAddEditProductDialog({Produto? product}) {
    String? dialogImageUrl;
    if (product != null) {
      _productNameController.text = product.nome;
      _productDescriptionController.text = product.descricao;
      _productPriceController.text = product.preco.toString();
      dialogImageUrl = product.imageUrls.isNotEmpty ? product.imageUrls.first : null;
      _selectedImageFile = null;
    } else {
      _productNameController.clear();
      _productDescriptionController.clear();
      _productPriceController.clear();
      dialogImageUrl = null;
      _selectedImageFile = null;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                    _selectedImageFile != null
                        ? Image.file(File(_selectedImageFile!.path), height: 100)
                        : (dialogImageUrl != null
                            ? Image.network(dialogImageUrl, height: 100)
                            : const Text('Nenhuma imagem selecionada')),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickImage();
                        setState(() {});
                      },
                      child: const Text('Selecionar Imagem'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  child: Text(product == null ? 'Adicionar' : 'Salvar'),
                  onPressed: () {
                    if (_productNameController.text.isNotEmpty &&
                        _productPriceController.text.isNotEmpty) {
                      final productName = _productNameController.text;
                      final productDescription = _productDescriptionController.text;
                      final newPrice = double.parse(_productPriceController.text);
                      final selectedImage = _selectedImageFile;
                      final existingImageUrl = dialogImageUrl;
                      final existingProduct = product;

                      Navigator.of(dialogContext).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(existingProduct == null ? 'Adicionando produto...' : 'Atualizando produto...')),
                      );

                      Future.microtask(() async {
                        try {
                          String? finalImageUrl;

                          if (selectedImage != null) {
                            final storageRef = FirebaseStorage.instance.ref();
                            final imagesRef = storageRef.child('product_images/${DateTime.now().millisecondsSinceEpoch}_${selectedImage.name}');
                            await imagesRef.putFile(File(selectedImage.path));
                            finalImageUrl = await imagesRef.getDownloadURL();
                          } else {
                            finalImageUrl = existingImageUrl;
                          }

                          final List<String> imageUrls = finalImageUrl != null ? [finalImageUrl] : [];

                          if (existingProduct == null) {
                            final newProduct = Produto(
                              nome: productName,
                              descricao: productDescription,
                              preco: newPrice,
                              categoryId: widget.categoryId,
                              imageUrls: imageUrls,
                            );
                            await _productFirestoreService.addProduct(newProduct);
                          } else {
                            final updatedProduct = Produto(
                              id: existingProduct.id,
                              nome: productName,
                              descricao: productDescription,
                              preco: newPrice,
                              categoryId: widget.categoryId,
                              imageUrls: imageUrls,
                            );
                            await _productFirestoreService.updateProduct(updatedProduct);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(existingProduct == null ? 'Produto adicionado com sucesso!' : 'Produto atualizado com sucesso!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ocorreu um erro: $e')),
                          );
                        }
                      });
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteProduct(String id) async {
    await _productFirestoreService.deleteProduct(id);
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
                  subtitle: Text('R\$ ${product.preco.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAddEditProductDialog(product: product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('Confirmar Exclusão'),
                                content: Text('Você tem certeza que deseja excluir o produto "${product.nome}"?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('VOLTAR'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('SIM'),
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop();
                                      _deleteProduct(product.id!);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}