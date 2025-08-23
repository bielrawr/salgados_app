import 'package:flutter/foundation.dart';
import '../models/item_carrinho.dart';
import '../models/produto.dart'; // Assuming Produto model is needed

class CartProvider with ChangeNotifier {
  Map<String, ItemCarrinho> _items = {};

  Map<String, ItemCarrinho> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.total;
    });
    return total;
  }

  void addItem(Produto produto, int quantidade) {
    if (_items.containsKey(produto.id)) {
      // Update quantity
      _items.update(
        produto.id!, // Added !
        (existingItem) => ItemCarrinho(
          produto: existingItem.produto,
          quantidade: existingItem.quantidade + quantidade,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        produto.id!, // Added !
        () => ItemCarrinho(
          produto: produto,
          quantidade: quantidade,
        ),
      );
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => ItemCarrinho(
          produto: existingItem.produto,
          quantidade: existingItem.quantidade + 1,
        ),
      );
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantidade > 1) {
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
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}