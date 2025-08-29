/// Testes unitários para o CartProvider

import 'package:flutter_test/flutter_test.dart';
import 'package:salgados_app/services/cart_provider.dart';
import 'package:salgados_app/models/produto.dart';
import '../test_utils.dart';

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });
  
  tearDownAll(() {
    tearDownTestEnvironment();
  });
  
  group('CartProvider Tests', () {
    late CartProvider cartProvider;
    late Produto produto;

    setUp(() {
      cartProvider = CartProvider();
      produto = Produto(
        id: 'prod123',
        nome: 'Pizza Calabresa',
        descricao: 'Deliciosa pizza',
        preco: 25.50,
        categoryId: 'cat123',
      );
    });

    test('should start with empty cart', () {
      expect(cartProvider.isEmpty, true);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.totalAmount, 0.0);
    });

    test('should add item to cart', () {
      cartProvider.addItem(produto, 2);

      expect(cartProvider.isEmpty, false);
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.totalAmount, 51.0); // 25.50 * 2
      expect(cartProvider.getQuantity('prod123'), 2);
    });

    test('should increase quantity when adding existing item', () {
      cartProvider.addItem(produto, 1);
      cartProvider.addItem(produto, 2);

      expect(cartProvider.itemCount, 1);
      expect(cartProvider.getQuantity('prod123'), 3);
      expect(cartProvider.totalAmount, 76.5); // 25.50 * 3
    });

    test('should remove item from cart', () {
      cartProvider.addItem(produto, 2);
      cartProvider.removeItem('prod123');

      expect(cartProvider.isEmpty, true);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.totalAmount, 0.0);
    });

    test('should clear entire cart', () {
      cartProvider.addItem(produto, 2);
      cartProvider.clearCart();

      expect(cartProvider.isEmpty, true);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.totalAmount, 0.0);
    });

    test('should throw exception for invalid product ID', () {
      final produtoSemId = Produto(
        nome: 'Produto',
        descricao: 'Descrição',
        preco: 10.0,
        categoryId: 'cat123',
      );

      expect(
        () => cartProvider.addItem(produtoSemId, 1),
        throwsA(isA<CartException>()),
      );
    });

    test('should throw exception for zero quantity', () {
      expect(
        () => cartProvider.addItem(produto, 0),
        throwsA(isA<CartException>()),
      );
    });
  });
}