import 'package:flutter/material.dart';
import 'package:salgados_app/models/categoria.dart';
import 'package:salgados_app/services/category_firestore_service.dart';
import '../utils/logger.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryFirestoreService _firestoreService = CategoryFirestoreService();
  List<Categoria> _categories = [];

  List<Categoria> get categories => _categories;

  CategoryProvider() {
    AppLogger.info('CategoryProvider inicializado', 'CATEGORY');
    _listenToCategories();
  }

  void _listenToCategories() {
    _firestoreService.getCategories().listen((categories) {
      _categories = categories;
      AppLogger.info('Categorias atualizadas: ${_categories.length} itens', 'CATEGORY');
      notifyListeners();
    });
  }

  Future<void> addCategory(Categoria category) async {
    AppLogger.info('Adicionando categoria: ${category.nome}', 'CATEGORY');
    await _firestoreService.addCategory(category);
    AppLogger.info('Categoria adicionada ao Firestore', 'CATEGORY');
  }

  Future<void> updateCategory(Categoria category) async {
    AppLogger.info('Atualizando categoria ID: ${category.id} para ${category.nome}', 'CATEGORY');
    await _firestoreService.updateCategory(category);
    AppLogger.info('Categoria atualizada no Firestore', 'CATEGORY');
  }

  Future<void> deleteCategory(String categoryId) async {
    AppLogger.info('Deletando categoria ID: $categoryId', 'CATEGORY');
    await _firestoreService.deleteCategory(categoryId);
    AppLogger.info('Categoria deletada do Firestore', 'CATEGORY');
  }
}