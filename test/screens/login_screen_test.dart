/// Testes para a tela de login (versão final sem erros)
/// 
/// Este arquivo testa todas as funcionalidades da LoginScreen,
/// sem problemas de Provider ou tipos incompatíveis.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_utils.dart';
import '../test_login_screen.dart';

// Mock simples que implementa TestAuthService
class MockTestAuthService implements TestAuthService {
  String? _lastEmail;
  String? _lastPassword;
  String? _errorToReturn;
  bool _shouldReturnError = false;
  bool _shouldHang = false;
  
  // Getters para verificar chamadas
  String? get lastEmail => _lastEmail;
  String? get lastPassword => _lastPassword;

  // Configuração para testes
  void setErrorToReturn(String? error) {
    _errorToReturn = error;
    _shouldReturnError = error != null;
  }
  
  void setShouldHang(bool hang) {
    _shouldHang = hang;
  }

  @override
  Future<String?> signIn({required String email, required String password}) async {
    _lastEmail = email;
    _lastPassword = password;
    
    // Se deve "pendurar", não completa o Future
    if (_shouldHang) {
      // Retorna um Future que nunca completa para testar loading
      return Completer<String?>().future;
    }
    
    if (_shouldReturnError) {
      return _errorToReturn;
    }
    
    return null; // Sucesso
  }
}

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });
  
  tearDownAll(() {
    tearDownTestEnvironment();
  });

  group('LoginScreen Tests (Final)', () {
    late MockTestAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockTestAuthService();
    });

    Widget createLoginScreen() {
      return MaterialApp(
        home: TestLoginScreen(authService: mockAuthService),
      );
    }

    testWidgets('should display login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      // Verifica se todos os elementos estão presentes
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Não tem uma conta? Cadastre-se'), findsOneWidget);
    });

    testWidgets('should validate email field', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      // Tenta submeter sem preencher email
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Verifica se mostra erro de validação
      expect(find.text('Por favor, insira um e-mail válido.'), findsOneWidget);
    });

    testWidgets('should validate password field', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      // Preenche email válido mas senha inválida
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Verifica se mostra erro de validação da senha
      expect(find.text('A senha deve ter pelo menos 6 caracteres.'), findsOneWidget);
    });

    testWidgets('should call signIn with correct credentials', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      const testEmail = 'test@example.com';
      const testPassword = 'password123';

      // Preenche os campos
      await tester.enterText(find.byType(TextFormField).first, testEmail);
      await tester.enterText(find.byType(TextFormField).last, testPassword);

      // Submete o formulário
      await tester.tap(find.text('Entrar'));
      
      // Aguarda processamento sem delay
      await tester.pump();

      // Verifica se o AuthService foi chamado com os dados corretos
      expect(mockAuthService.lastEmail, testEmail);
      expect(mockAuthService.lastPassword, testPassword);
    });

    testWidgets('should show loading indicator during login', (WidgetTester tester) async {
      // Configura o mock para "pendurar" e mostrar loading
      mockAuthService.setShouldHang(true);
      
      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      // Preenche campos válidos
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Submete o formulário
      await tester.tap(find.text('Entrar'));
      await tester.pump(); // Captura o estado de loading

      // Verifica se mostra o loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Entrar'), findsNothing); // Botão deve estar oculto
      
      // Limpa o estado para não afetar outros testes
      mockAuthService.setShouldHang(false);
    });

    testWidgets('should show error message on login failure', (WidgetTester tester) async {
      const errorMessage = 'Credenciais inválidas';
      mockAuthService.setErrorToReturn(errorMessage);

      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      // Preenche campos válidos
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Submete o formulário
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Verifica se mostra a mensagem de erro
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      // Testa email inválido
      await tester.enterText(find.byType(TextFormField).first, 'email-invalido');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // Verifica se mostra erro de validação
      expect(find.text('Por favor, insira um e-mail válido.'), findsOneWidget);
    });

    testWidgets('should accept valid email formats', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginScreen());
      await tester.pump();

      // Testa email válido
      await tester.enterText(find.byType(TextFormField).first, 'user@domain.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      await tester.tap(find.text('Entrar'));
      await tester.pump();
      
      // Não deve mostrar erro de validação de email
      expect(find.text('Por favor, insira um e-mail válido.'), findsNothing);
      
      // Verifica se o SnackBar de sucesso apareceu
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Login realizado com sucesso!'), findsOneWidget);
    });
  });
}