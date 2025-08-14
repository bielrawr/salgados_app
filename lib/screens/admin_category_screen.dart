import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_provider.dart';
import '../models/categoria.dart';
import 'admin_product_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  final TextEditingController _categoryNameController = TextEditingController();
  XFile? _selectedImageFile;

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
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

  void _showAddEditCategoryDialog({required BuildContext context, Categoria? category}) {
    String? _dialogImageUrl;
    if (category != null) {
      _categoryNameController.text = category.nome;
      _dialogImageUrl = category.imageUrl;
      _selectedImageFile = null;
    } else {
      _categoryNameController.clear();
      _dialogImageUrl = null;
      _selectedImageFile = null;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(category == null ? 'Adicionar Categoria' : 'Editar Categoria'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _categoryNameController,
                    decoration: const InputDecoration(
                      hintText: 'Nome da Categoria',
                    ),
                  ),
                  const SizedBox(height: 10),
                  _selectedImageFile != null
                      ? Image.file(File(_selectedImageFile!.path), height: 100)
                      : (_dialogImageUrl != null
                          ? Image.network(_dialogImageUrl!, height: 100)
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
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  child: Text(category == null ? 'Adicionar' : 'Salvar'),
                  onPressed: () {
                    if (_categoryNameController.text.isNotEmpty) {
                      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
                      final categoryName = _categoryNameController.text;
                      final selectedImage = _selectedImageFile;
                      final existingImageUrl = _dialogImageUrl;
                      final existingCategory = category;

                      Navigator.of(dialogContext).pop();

                      Future.microtask(() async {
                        String? finalImageUrl;
                        if (selectedImage != null) {
                          final storageRef = FirebaseStorage.instance.ref();
                          final imagesRef = storageRef.child('category_images/${DateTime.now().millisecondsSinceEpoch}_${selectedImage.name}');
                          try {
                            await imagesRef.putFile(File(selectedImage.path));
                            finalImageUrl = await imagesRef.getDownloadURL();
                          } on FirebaseException catch (e) {
                            print('Error uploading image: $e');
                          }
                        } else {
                          finalImageUrl = existingImageUrl;
                        }

                        if (finalImageUrl != null) {
                          if (existingCategory == null) {
                            final newCategory = Categoria(
                              nome: categoryName,
                              imageUrl: finalImageUrl,
                            );
                            await categoryProvider.addCategory(newCategory);
                          } else {
                            final updatedCategory = Categoria(
                              id: existingCategory.id,
                              nome: categoryName,
                              imageUrl: finalImageUrl,
                            );
                            await categoryProvider.updateCategory(updatedCategory);
                          }
                        } else {
                          print('Please select an image or ensure existing image URL is valid.');
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

  Future<void> _deleteCategory(BuildContext context, String id) async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.deleteCategory(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Categorias'),
        backgroundColor: const Color(0xFFFF6600),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditCategoryDialog(context: context),
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final categories = categoryProvider.categories;
          if (categories.isEmpty) {
            return const Center(child: Text('Nenhuma categoria encontrada.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                key: UniqueKey(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    leading: category.imageUrl.isNotEmpty
                        ? Image.network(
                            category.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) =>
                                const Icon(Icons.image_not_supported),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(category.nome),
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminProductScreen(categoryId: category.id!, categoryName: category.nome)));
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showAddEditCategoryDialog(context: context, category: category),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteCategory(context, category.id!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}