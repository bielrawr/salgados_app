/// Testes unitários para o CategoryProvider
/// 
/// Este arquivo testa funcionalidades básicas do CategoryProvider
/// sem dependências do Firebase.

import 'package:flutter_test/flutter_test.dart';
import 'package:salgados_app/models/categoria.dart';
import '../test_utils.dart';

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });
  
  tearDownAll(() {
    tearDownTestEnvironment();
  });

  group('CategoryProvider Tests', () {
    test('should handle categoria creation', () {
      final categoria = Categoria(
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );

      // Verifica se a categoria foi criada corretamente
      expect(categoria.nome, 'Pizzas');
      expect(categoria.imageUrl, 'https://example.com/pizza.jpg');
      expect(categoria.hasImage, true);
    });

    test('should handle categoria with empty image', () {
      final categoria = Categoria(
        nome: 'Salgados',
        imageUrl: '',
      );

      expect(categoria.nome, 'Salgados');
      expect(categoria.hasImage, false);
    });

    test('should handle categoria name formatting', () {
      final categoria = Categoria(
        nome: 'bebidas geladas',
        imageUrl: 'https://example.com/bebidas.jpg',
      );

      expect(categoria.nomeUpperCase, 'BEBIDAS GELADAS');
    });

    test('should validate categoria equality', () {
      final categoria1 = Categoria(
        id: 'cat123',
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );

      final categoria2 = Categoria(
        id: 'cat123',
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );

      final categoria3 = Categoria(
        id: 'cat456',
        nome: 'Salgados',
        imageUrl: 'https://example.com/salgados.jpg',
      );

      expect(categoria1, equals(categoria2));
      expect(categoria1, isNot(equals(categoria3)));
    });

    test('should handle categoria copyWith', () {
      final categoria = Categoria(
        id: 'cat123',
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );

      final categoriaAtualizada = categoria.copyWith(
        nome: 'Pizzas Especiais',
      );

      expect(categoriaAtualizada.nome, 'Pizzas Especiais');
      expect(categoriaAtualizada.id, categoria.id);
      expect(categoriaAtualizada.imageUrl, categoria.imageUrl);
    });

    test('should handle categoria toString', () {
      final categoria = Categoria(
        id: 'cat123',
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );

      final stringRepresentation = categoria.toString();
      
      expect(stringRepresentation, contains('cat123'));
      expect(stringRepresentation, contains('Pizzas'));
      expect(stringRepresentation, contains('https://example.com/pizza.jpg'));
    });

    test('should handle categoria hashCode', () {
      final categoria1 = Categoria(
        id: 'cat123',
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );

      final categoria2 = Categoria(
        id: 'cat123',
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );

      expect(categoria1.hashCode, equals(categoria2.hashCode));
    });

    test('should validate categoria with different properties', () {
      final categoria = Categoria(
        nome: 'Categoria Teste',
        imageUrl: 'https://example.com/test.jpg',
      );

      expect(categoria.nome, isA<String>());
      expect(categoria.imageUrl, isA<String>());
      expect(categoria.hasImage, true);
      expect(categoria.nomeUpperCase, 'CATEGORIA TESTE');
    });

    test('should handle categoria validation', () {
      // Testa categoria válida
      expect(
        () => Categoria(
          nome: 'Categoria Válida',
          imageUrl: 'https://example.com/valid.jpg',
        ),
        returnsNormally,
      );

      // Testa categoria com nome vazio
      expect(
        () => Categoria(
          nome: '',
          imageUrl: 'https://example.com/test.jpg',
        ),
        throwsA(isA<CategoriaValidationException>()),
      );

      // Testa categoria com nome muito curto
      expect(
        () => Categoria(
          nome: 'A',
          imageUrl: 'https://example.com/test.jpg',
        ),
        throwsA(isA<CategoriaValidationException>()),
      );
    });

    test('should handle categoria with invalid URL', () {
      expect(
        () => Categoria(
          nome: 'Categoria Teste',
          imageUrl: 'url-invalida',
        ),
        throwsA(isA<CategoriaValidationException>()),
      );
    });
  });
}