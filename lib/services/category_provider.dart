import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/categoria.dart';

class CategoryProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Categoria> _categories = [];

  List<Categoria> get categories => _categories;

  CategoryProvider() {
    print("CategoryProvider: Inicializado.");
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    print("CategoryProvider: Carregando categorias...");
    final categoriesMap = await _dbHelper.getCategorias();
    _categories = categoriesMap.map((map) => Categoria.fromMap(map)).toList();
    print("CategoryProvider: Categorias carregadas: ${_categories.length} itens. Chamando notifyListeners().");
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    print("CategoryProvider: Adicionando categoria: $name");
    final id = await _dbHelper.salvarCategoria({'nome': name});
    _categories.add(Categoria(id: id, nome: name));
    print("CategoryProvider: Categoria adicionada. Nova lista: ${_categories.length} itens. Chamando notifyListeners().");
    notifyListeners();
  }

  Future<void> updateCategory(int id, String name) async {
    print("CategoryProvider: Atualizando categoria ID: $id para $name");
    await _dbHelper.atualizarCategoria({'id': id, 'nome': name});
    final index = _categories.indexWhere((cat) => cat.id == id);
    if (index != -1) {
      _categories[index] = Categoria(id: id, nome: name);
      print("CategoryProvider: Categoria atualizada na lista. Chamando notifyListeners().");
      notifyListeners();
    } else {
      print("CategoryProvider: Categoria ID $id não encontrada na lista para atualização.");
    }
  }

  Future<void> deleteCategory(int id) async {
    print("CategoryProvider: Deletando categoria ID: $id");
    await _dbHelper.deletarCategoria(id);
    _categories.removeWhere((cat) => cat.id == id);
    print("CategoryProvider: Categoria deletada da lista. Nova lista: ${_categories.length} itens. Chamando notifyListeners().");
    notifyListeners();
  }

  Future<void> refreshCategories() async {
    print("CategoryProvider: Refreshing categories...");
    await _loadCategories();
  }
}