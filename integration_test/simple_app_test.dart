/// Testes de integração simples para o aplicativo Salgados App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:salgados_app/services/cart_provider.dart';
import 'package:salgados_app/models/produto.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple Integration Tests', () {
    testWidgets('should create and use CartProvider', (WidgetTester tester) async {
      final cartProvider = CartProvider();
      
      // Testa estado inicial
      expect(cartProvider.isEmpty, true);
      expect(cartProvider.totalAmount, 0.0);
      expect(cartProvider.itemCount, 0);
      
      // Cria um produto de teste
      final produto = Produto(
        id: 'test_product',
        nome: 'Pizza Teste',
        descricao: 'Pizza para teste',
        preco: 25.0,
        categoryId: 'test_category',
      );
      
      // Adiciona produto ao carrinho
      cartProvider.addItem(produto, 2);
      
      // Verifica se foi adicionado corretamente
      expect(cartProvider.isEmpty, false);
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.totalAmount, 50.0);
      expect(cartProvider.getQuantity('test_product'), 2);
      
      // Remove produto
      cartProvider.removeItem('test_product');
      
      // Verifica se foi removido
      expect(cartProvider.isEmpty, true);
      expect(cartProvider.totalAmount, 0.0);
    });

    testWidgets('should handle cart operations', (WidgetTester tester) async {
      final cartProvider = CartProvider();
      
      final produto1 = Produto(
        id: 'prod1',
        nome: 'Pizza',
        descricao: 'Pizza deliciosa',
        preco: 30.0,
        categoryId: 'cat1',
      );
      
      final produto2 = Produto(
        id: 'prod2',
        nome: 'Coxinha',
        descricao: 'Coxinha crocante',
        preco: 8.0,
        categoryId: 'cat2',
      );
      
      // Adiciona produtos
      cartProvider.addItem(produto1, 1);
      cartProvider.addItem(produto2, 3);
      
      expect(cartProvider.itemCount, 2);
      expect(cartProvider.totalAmount, 54.0); // 30 + (8 * 3)
      
      // Aumenta quantidade
      cartProvider.increaseQuantity('prod1');
      expect(cartProvider.getQuantity('prod1'), 2);
      expect(cartProvider.totalAmount, 84.0); // (30 * 2) + (8 * 3)
      
      // Diminui quantidade
      cartProvider.decreaseQuantity('prod2');
      expect(cartProvider.getQuantity('prod2'), 2);
      expect(cartProvider.totalAmount, 76.0); // (30 * 2) + (8 * 2)
      
      // Limpa carrinho
      cartProvider.clearCart();
      expect(cartProvider.isEmpty, true);
    });

    testWidgets('should handle cart with MaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Test App')),
              body: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Items: ${cart.itemCount}'),
                        Text('Total: R\$ ${cart.totalAmount.toStringAsFixed(2)}'),
                        ElevatedButton(
                          onPressed: () {
                            final produto = Produto(
                              id: 'test_prod',
                              nome: 'Produto Teste',
                              descricao: 'Descrição teste',
                              preco: 15.0,
                              categoryId: 'test_cat',
                            );
                            cart.addItem(produto, 1);
                          },
                          child: const Text('Adicionar Item'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Verifica se a tela foi renderizada
      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total: R\$ 0.00'), findsOneWidget);

      // Toca no botão para adicionar item
      await tester.tap(find.text('Adicionar Item'));
      await tester.pumpAndSettle();

      // Verifica se o item foi adicionado
      expect(find.text('Items: 1'), findsOneWidget);
      expect(find.text('Total: R\$ 15.00'), findsOneWidget);
    });

    testWidgets('should handle produto validation', (WidgetTester tester) async {
      // Testa criação de produto válido
      final produtoValido = Produto(
        id: 'valid_id',
        nome: 'Produto Válido',
        descricao: 'Descrição válida',
        preco: 10.0,
        categoryId: 'valid_category',
      );

      expect(produtoValido.nome, 'Produto Válido');
      expect(produtoValido.preco, 10.0);
      expect(produtoValido.precoFormatado, 'R\$ 10,00');

      // Testa produto com preço decimal
      final produtoDecimal = Produto(
        id: 'decimal_id',
        nome: 'Produto Decimal',
        descricao: 'Com preço decimal',
        preco: 12.99,
        categoryId: 'decimal_category',
      );

      expect(produtoDecimal.precoFormatado, 'R\$ 12,99');

      // Testa copyWith
      final produtoCopiado = produtoValido.copyWith(
        nome: 'Produto Modificado',
        preco: 20.0,
      );

      expect(produtoCopiado.nome, 'Produto Modificado');
      expect(produtoCopiado.preco, 20.0);
      expect(produtoCopiado.id, produtoValido.id); // Mantém ID original
    });

    testWidgets('should handle cart error cases', (WidgetTester tester) async {
      final cartProvider = CartProvider();

      // Testa produto sem ID
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

      // Testa quantidade inválida
      final produtoValido = Produto(
        id: 'valid_id',
        nome: 'Produto Válido',
        descricao: 'Produto válido',
        preco: 10.0,
        categoryId: 'test_cat',
      );

      expect(
        () => cartProvider.addItem(produtoValido, 0),
        throwsA(isA<CartException>()),
      );

      expect(
        () => cartProvider.addItem(produtoValido, -1),
        throwsA(isA<CartException>()),
      );
    });
  });
}