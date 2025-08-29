/// Testes de integração para operações do carrinho

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:salgados_app/services/cart_provider.dart';
import 'package:salgados_app/models/produto.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cart Integration Tests', () {
    late CartProvider cartProvider;
    late Produto produto1;
    late Produto produto2;

    setUp(() {
      cartProvider = CartProvider();
      
      produto1 = Produto(
        id: 'prod1',
        nome: 'Pizza Calabresa',
        descricao: 'Deliciosa pizza de calabresa',
        preco: 25.50,
        categoryId: 'cat1',
      );

      produto2 = Produto(
        id: 'prod2',
        nome: 'Coxinha de Frango',
        descricao: 'Coxinha crocante de frango',
        preco: 7.50,
        categoryId: 'cat2',
      );
    });

    testWidgets('complete cart workflow', (WidgetTester tester) async {
      // Estado inicial
      expect(cartProvider.isEmpty, true);
      expect(cartProvider.totalAmount, 0.0);

      // Adiciona produtos
      cartProvider.addItem(produto1, 2);
      cartProvider.addItem(produto2, 3);
      
      expect(cartProvider.itemCount, 2);
      expect(cartProvider.totalAmount, 73.5);

      // Modifica quantidades
      cartProvider.increaseQuantity('prod1');
      cartProvider.decreaseQuantity('prod2');
      
      expect(cartProvider.totalAmount, 91.5);

      // Remove e limpa
      cartProvider.removeItem('prod2');
      expect(cartProvider.itemCount, 1);
      
      cartProvider.clearCart();
      expect(cartProvider.isEmpty, true);
    });

    testWidgets('cart calculations', (WidgetTester tester) async {
      cartProvider.addItem(produto1, 2);
      expect(cartProvider.totalAmountFormatted, 'R\$ 51,00');
      
      cartProvider.addItem(produto2, 1);
      expect(cartProvider.totalAmountFormatted, 'R\$ 58,50');
    });

    testWidgets('cart error handling', (WidgetTester tester) async {
      final produtoSemId = Produto(
        nome: 'Produto Sem ID',
        descricao: 'Produto inválido',
        preco: 10.0,
        categoryId: 'test_cat',
      );

      expect(
        () => cartProvider.addItem(produtoSemId, 1),
        throwsA(isA<CartException>()),
      );
    });
  });
}