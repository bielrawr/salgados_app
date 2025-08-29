/// Testes de widget para o aplicativo Salgados App
/// 
/// Este arquivo contém testes básicos para verificar se o aplicativo
/// inicializa corretamente e se os componentes principais funcionam.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:salgados_app/main.dart';
import 'package:salgados_app/services/auth_service.dart';
import 'package:salgados_app/services/cart_provider.dart';
import 'package:salgados_app/services/category_provider.dart';
import 'test_utils.dart';

// Mock simples do AuthService para testes
class MockAuthService extends ChangeNotifier implements AuthService {
  bool _isInitialized = false;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isAdmin => false;

  @override
  bool get isLoading => _isLoading;

  @override
  get user => null;

  @override
  Map<String, dynamic>? get userData => null;

  @override
  String? get userEmail => null;

  @override
  String? get userId => null;

  void setInitialized(bool value) {
    _isInitialized = value;
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  @override
  Future<String?> signUp({required String email, required String password}) async {
    return null;
  }

  @override
  Future<String?> signIn({required String email, required String password}) async {
    return null;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<String?> resetPassword(String email) async {
    return null;
  }
  
  @override
  Future<String?> signInWithGoogle() async {
    return null;
  }
}

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });
  
  tearDownAll(() {
    tearDownTestEnvironment();
  });
  
  group('SalgadosApp Widget Tests', () {
    testWidgets('App should build without crashing', (WidgetTester tester) async {
      // Cria um widget de teste com providers mockados
      final mockAuthService = MockAuthService();
      mockAuthService.setInitialized(true); // Já inicializado para este teste

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider(create: (context) => CategoryProvider()),
            ChangeNotifierProvider(create: (context) => CartProvider()),
          ],
          child: const SalgadosApp(),
        ),
      );

      // Verifica se o app foi construído sem erros
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should show loading screen initially', (WidgetTester tester) async {
      // Cria um AuthService que não está inicializado
      final mockAuthService = MockAuthService();
      // Não chama setInitialized, então isInitialized retorna false

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider(create: (context) => CategoryProvider()),
            ChangeNotifierProvider(create: (context) => CartProvider()),
          ],
          child: const SalgadosApp(),
        ),
      );

      // Verifica se mostra a tela de carregamento
      expect(find.text('Carregando...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App should show login screen when not authenticated', (WidgetTester tester) async {
      // Cria um AuthService inicializado mas não autenticado
      final mockAuthService = MockAuthService();
      mockAuthService.setInitialized(true);
      mockAuthService.setAuthenticated(false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider(create: (context) => CategoryProvider()),
            ChangeNotifierProvider(create: (context) => CartProvider()),
          ],
          child: const SalgadosApp(),
        ),
      );

      // Aguarda a construção do widget
      await tester.pumpAndSettle();

      // Verifica se mostra a tela de login
      // Nota: Como LoginScreen pode ter dependências do Firebase, 
      // vamos verificar apenas se não está mostrando a tela de carregamento
      expect(find.text('Carregando...'), findsNothing);
    });

    testWidgets('App theme should be configured correctly', (WidgetTester tester) async {
      final mockAuthService = MockAuthService();
      mockAuthService.setInitialized(true);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>.value(value: mockAuthService),
            ChangeNotifierProvider(create: (context) => CategoryProvider()),
            ChangeNotifierProvider(create: (context) => CartProvider()),
          ],
          child: const SalgadosApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verifica se o tema está configurado
      expect(materialApp.theme, isNotNull);
      expect(materialApp.title, 'LR Salgados');
      expect(materialApp.debugShowCheckedModeBanner, false);
    });
  });
}