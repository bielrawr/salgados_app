/// Provedor de estado para gerenciar o carrinho de compras
/// 
/// Esta classe gerencia todos os itens do carrinho, incluindo
/// adição, remoção e cálculo de totais.

import 'package:flutter/foundation.dart';
import '../models/item_carrinho.dart';
import '../models/produto.dart';

/// Exceção personalizada para erros do carrinho
class CartException implements Exception {
  final String message;
  const CartException(this.message);
  
  @override
  String toString() => 'CartException: $message';
}

/// Provedor de estado para o carrinho de compras
class CartProvider with ChangeNotifier {
  /// Mapa interno dos itens do carrinho (ID do produto -> ItemCarrinho)
  Map<String, ItemCarrinho> _items = {};

  /// Retorna uma cópia dos itens do carrinho
  Map<String, ItemCarrinho> get items {
    return {..._items};
  }

  /// Retorna o número total de tipos de itens no carrinho
  int get itemCount {
    return _items.length;
  }
  
  /// Retorna a quantidade total de produtos no carrinho
  int get totalQuantity {
    int total = 0;
    _items.forEach((key, item) {
      total += item.quantidade;
    });
    return total;
  }

  /// Retorna o valor total do carrinho
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.total;
    });
    return total;
  }
  
  /// Retorna o valor total formatado como string
  String get totalAmountFormatted {
    return 'R\$ ${totalAmount.toStringAsFixed(2).replaceAll('.', ',')}';
  }
  
  /// Verifica se o carrinho está vazio
  bool get isEmpty => _items.isEmpty;
  
  /// Verifica se o carrinho não está vazio
  bool get isNotEmpty => _items.isNotEmpty;

  /// Adiciona um produto ao carrinho ou atualiza a quantidade se já existir
  /// 
  /// [produto] O produto a ser adicionado
  /// [quantidade] A quantidade a ser adicionada (deve ser maior que 0)
  void addItem(Produto produto, int quantidade) {
    // Validações de entrada
    if (produto.id == null || produto.id!.isEmpty) {
      throw const CartException('Produto deve ter um ID válido');
    }
    
    if (quantidade <= 0) {
      throw const CartException('Quantidade deve ser maior que zero');
    }
    
    if (!produto.isAvailable) {
      throw const CartException('Produto não está disponível');
    }
    
    final productId = produto.id!;
    
    try {
      if (_items.containsKey(productId)) {
        // Atualiza quantidade do item existente
        _items.update(
          productId,
          (existingItem) => ItemCarrinho(
            produto: existingItem.produto,
            quantidade: existingItem.quantidade + quantidade,
          ),
        );
      } else {
        // Adiciona novo item
        _items.putIfAbsent(
          productId,
          () => ItemCarrinho(
            produto: produto,
            quantidade: quantidade,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      throw CartException('Erro ao adicionar item ao carrinho: $e');
    }
  }

  /// Aumenta a quantidade de um produto no carrinho
  /// 
  /// [productId] ID do produto
  void increaseQuantity(String productId) {
    if (productId.isEmpty) {
      throw const CartException('ID do produto não pode estar vazio');
    }
    
    if (!_items.containsKey(productId)) {
      throw const CartException('Produto não encontrado no carrinho');
    }
    
    try {
      _items.update(
        productId,
        (existingItem) => ItemCarrinho(
          produto: existingItem.produto,
          quantidade: existingItem.quantidade + 1,
        ),
      );
      notifyListeners();
    } catch (e) {
      throw CartException('Erro ao aumentar quantidade: $e');
    }
  }

  /// Diminui a quantidade de um produto no carrinho
  /// Remove o item se a quantidade chegar a zero
  /// 
  /// [productId] ID do produto
  void decreaseQuantity(String productId) {
    if (productId.isEmpty) {
      throw const CartException('ID do produto não pode estar vazio');
    }
    
    if (!_items.containsKey(productId)) {
      return; // Item não existe, não faz nada
    }
    
    try {
      final currentItem = _items[productId]!;
      
      if (currentItem.quantidade > 1) {
        _items.update(
          productId,
          (existingItem) => ItemCarrinho(
            produto: existingItem.produto,
            quantidade: existingItem.quantidade - 1,
          ),
        );
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    } catch (e) {
      throw CartException('Erro ao diminuir quantidade: $e');
    }
  }

  /// Remove um item completamente do carrinho
  /// 
  /// [productId] ID do produto a ser removido
  void removeItem(String productId) {
    if (productId.isEmpty) {
      throw const CartException('ID do produto não pode estar vazio');
    }
    
    try {
      _items.remove(productId);
      notifyListeners();
    } catch (e) {
      throw CartException('Erro ao remover item: $e');
    }
  }

  /// Limpa todos os itens do carrinho
  void clearCart() {
    try {
      _items.clear();
      notifyListeners();
    } catch (e) {
      throw CartException('Erro ao limpar carrinho: $e');
    }
  }
  
  /// Retorna a quantidade de um produto específico no carrinho
  /// 
  /// [productId] ID do produto
  /// Retorna 0 se o produto não estiver no carrinho
  int getQuantity(String productId) {
    if (productId.isEmpty) return 0;
    return _items[productId]?.quantidade ?? 0;
  }
  
  /// Verifica se um produto está no carrinho
  /// 
  /// [productId] ID do produto
  bool containsProduct(String productId) {
    if (productId.isEmpty) return false;
    return _items.containsKey(productId);
  }
  
  /// Retorna uma lista de todos os itens do carrinho
  List<ItemCarrinho> get itemsList {
    return _items.values.toList();
  }
  
  /// Atualiza a quantidade de um produto para um valor específico
  /// Remove o item se a quantidade for 0 ou menor
  /// 
  /// [productId] ID do produto
  /// [newQuantity] Nova quantidade
  void updateQuantity(String productId, int newQuantity) {
    if (productId.isEmpty) {
      throw const CartException('ID do produto não pode estar vazio');
    }
    
    if (newQuantity < 0) {
      throw const CartException('Quantidade não pode ser negativa');
    }
    
    if (!_items.containsKey(productId)) {
      throw const CartException('Produto não encontrado no carrinho');
    }
    
    try {
      if (newQuantity == 0) {
        _items.remove(productId);
      } else {
        _items.update(
          productId,
          (existingItem) => ItemCarrinho(
            produto: existingItem.produto,
            quantidade: newQuantity,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      throw CartException('Erro ao atualizar quantidade: $e');
    }
  }
}