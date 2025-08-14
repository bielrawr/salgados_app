import 'package:flutter/material.dart';
import 'package:salgados_app/models/categoria.dart';
import 'package:salgados_app/services/category_firestore_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryFirestoreService _firestoreService = CategoryFirestoreService();
  List<Categoria> _categories = [];

  List<Categoria> get categories => _categories;

  CategoryProvider() {
    print("CategoryProvider: Inicializado.");
    _listenToCategories();
  }

  void _listenToCategories() {
    _firestoreService.getCategories().listen((categories) {
      _categories = categories;
      print("CategoryProvider: Categorias atualizadas: ${_categories.length} itens. Chamando notifyListeners().");
      notifyListeners();
    });
  }

  Future<void> addCategory(Categoria category) async {
    print("CategoryProvider: Adicionando categoria: ${category.nome}");
    await _firestoreService.addCategory(category);
    print("CategoryProvider: Categoria adicionada ao Firestore.");
  }

  Future<void> updateCategory(Categoria category) async {
    print("CategoryProvider: Atualizando categoria ID: ${category.id} para ${category.nome}");
    await _firestoreService.updateCategory(category);
    print("CategoryProvider: Categoria atualizada no Firestore.");
  }

  Future<void> deleteCategory(String categoryId) async {
    print("CategoryProvider: Deletando categoria ID: $categoryId");
    await _firestoreService.deleteCategory(categoryId);
    print("CategoryProvider: Categoria deletada do Firestore.");
  }
}