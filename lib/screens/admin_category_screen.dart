import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/category_provider.dart';
import '../models/categoria.dart';
import 'admin_product_screen.dart';

class AdminCategoryScreen extends StatelessWidget {
  AdminCategoryScreen({super.key});

  final TextEditingController _categoryNameController = TextEditingController();

  void _showAddEditCategoryDialog({required BuildContext context, Categoria? category}) {
    if (category != null) {
      _categoryNameController.text = category.nome;
    } else {
      _categoryNameController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(category == null ? 'Adicionar Categoria' : 'Editar Categoria'),
          content: TextField(
            controller: _categoryNameController,
            decoration: const InputDecoration(
              hintText: 'Nome da Categoria',
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
              child: Text(category == null ? 'Adicionar' : 'Salvar'),
              onPressed: () async {
                if (_categoryNameController.text.isNotEmpty) {
                  final categoryProvider = Provider.of<CategoryProvider>(dialogContext, listen: false);
                  if (category == null) {
                    await categoryProvider.addCategory(_categoryNameController.text);
                  } else {
                    await categoryProvider.updateCategory(category.id, _categoryNameController.text);
                  }
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(BuildContext context, int id) async {
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
            return ListView.builder(
              key: UniqueKey(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.nome),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminProductScreen(categoryId: category.id, categoryName: category.nome)));
                    categoryProvider.refreshCategories(); // Força a reconstrução da lista ao retornar
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
                        onPressed: () => _deleteCategory(context, category.id),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}