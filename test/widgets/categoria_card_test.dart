/// Testes para o widget CategoriaCard
/// 
/// Este arquivo testa todas as funcionalidades do CategoriaCard,
/// incluindo renderização, interações e tratamento de imagens.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salgados_app/widgets/categoria_card.dart';
import 'package:salgados_app/models/categoria.dart';
import '../test_utils.dart';

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });
  
  tearDownAll(() {
    tearDownTestEnvironment();
  });

  group('CategoriaCard Widget Tests', () {
    late Categoria testCategoria;
    bool onTapCalled = false;

    setUp(() {
      testCategoria = Categoria(
        id: 'cat123',
        nome: 'Pizzas',
        imageUrl: 'https://example.com/pizza.jpg',
      );
      onTapCalled = false;
    });

    Widget createCategoriaCard({String? customImageUrl, bool useCustomUrl = false}) {
      return MaterialApp(
        home: Scaffold(
          body: CategoriaCard(
            categoria: testCategoria,
            imageUrl: useCustomUrl ? customImageUrl : (customImageUrl ?? testCategoria.imageUrl),
            onTap: () {
              onTapCalled = true;
            },
          ),
        ),
      );
    }

    testWidgets('should display categoria name in uppercase', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      // Verifica se o nome da categoria está em maiúsculas
      expect(find.text('PIZZAS'), findsOneWidget);
      expect(find.text('Pizzas'), findsNothing);
    });

    testWidgets('should display card with correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      // Verifica se os elementos principais estão presentes
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      // Toca no card (primeiro InkWell)
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      // Verifica se o callback foi chamado
      expect(onTapCalled, true);
    });

    testWidgets('should call onTap when button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      // Toca no botão
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verifica se o callback foi chamado
      expect(onTapCalled, true);
    });

    testWidgets('should show network image when imageUrl is provided', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      // Verifica se há uma imagem de rede
      expect(find.byType(Image), findsOneWidget);
      
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<NetworkImage>());
    });

    testWidgets('should show placeholder icon when imageUrl is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard(customImageUrl: ''));

      // Verifica se mostra o ícone placeholder
      expect(find.byIcon(Icons.image), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('should show placeholder icon when imageUrl is null', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard(customImageUrl: null, useCustomUrl: true));

      // Verifica se mostra o ícone placeholder
      expect(find.byIcon(Icons.image), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('should have correct button styling', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = elevatedButton.style;
      
      // Verifica se o estilo está aplicado
      expect(buttonStyle, isNotNull);
    });

    testWidgets('should have correct card styling', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      final card = tester.widget<Card>(find.byType(Card));
      
      // Verifica propriedades do card
      expect(card.elevation, 3);
      expect(card.clipBehavior, Clip.antiAlias);
      expect(card.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('should handle different categoria names', (WidgetTester tester) async {
      final categoriaComNomeLongo = Categoria(
        id: 'cat456',
        nome: 'Salgados Especiais da Casa',
        imageUrl: 'https://example.com/salgados.jpg',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoriaCard(
              categoria: categoriaComNomeLongo,
              imageUrl: categoriaComNomeLongo.imageUrl,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verifica se o nome longo é exibido corretamente
      expect(find.text('SALGADOS ESPECIAIS DA CASA'), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      // Verifica se o widget é acessível (pode ser tocado)
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));
      expect(find.byType(ElevatedButton), findsOneWidget);
      
      // Verifica se não há problemas de acessibilidade óbvios
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    });

    testWidgets('should handle tap on different areas', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      // Reset do flag
      onTapCalled = false;

      // Toca na área do card (mas não no botão)
      await tester.tapAt(tester.getTopLeft(find.byType(Card)));
      await tester.pumpAndSettle();

      // Verifica se o callback foi chamado
      expect(onTapCalled, true);
    });

    testWidgets('should maintain aspect ratio', (WidgetTester tester) async {
      await tester.pumpWidget(createCategoriaCard());

      final card = find.byType(Card);
      final cardSize = tester.getSize(card);
      
      // Verifica se o card tem dimensões razoáveis
      expect(cardSize.width, greaterThan(0));
      expect(cardSize.height, greaterThan(0));
    });
  });
}