/// Testes unitários para o modelo Produto

import 'package:flutter_test/flutter_test.dart';
import 'package:salgados_app/models/produto.dart';
import '../test_utils.dart';

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });
  
  tearDownAll(() {
    tearDownTestEnvironment();
  });
  
  group('Produto Model Tests', () {
    test('should create valid product', () {
      final produto = Produto(
        nome: 'Pizza Calabresa',
        descricao: 'Deliciosa pizza de calabresa',
        preco: 25.50,
        categoryId: 'cat123',
      );

      expect(produto.nome, 'Pizza Calabresa');
      expect(produto.descricao, 'Deliciosa pizza de calabresa');
      expect(produto.preco, 25.50);
      expect(produto.categoryId, 'cat123');
      expect(produto.isAvailable, true);
      expect(produto.imageUrls, isEmpty);
    });

    test('should throw exception for empty name', () {
      expect(
        () => Produto(
          nome: '',
          descricao: 'Descrição',
          preco: 10.0,
          categoryId: 'cat123',
        ),
        throwsA(isA<ProdutoValidationException>()),
      );
    });

    test('should throw exception for negative price', () {
      expect(
        () => Produto(
          nome: 'Produto',
          descricao: 'Descrição',
          preco: -5.0,
          categoryId: 'cat123',
        ),
        throwsA(isA<ProdutoValidationException>()),
      );
    });

    test('should return formatted price', () {
      final produto = Produto(
        nome: 'Pizza Margherita',
        descricao: 'Pizza com molho de tomate e queijo',
        preco: 30.75,
        categoryId: 'cat123',
      );

      expect(produto.precoFormatado, 'R\$ 30,75');
    });

    test('should create copy with new values', () {
      final produto = Produto(
        id: 'prod123',
        nome: 'Pizza Original',
        descricao: 'Descrição original',
        preco: 25.00,
        categoryId: 'cat123',
      );

      final novoProduto = produto.copyWith(
        nome: 'Pizza Pepperoni',
        preco: 35.00,
      );

      expect(novoProduto.nome, 'Pizza Pepperoni');
      expect(novoProduto.preco, 35.00);
      expect(novoProduto.descricao, produto.descricao);
      expect(novoProduto.categoryId, produto.categoryId);
    });
  });
}