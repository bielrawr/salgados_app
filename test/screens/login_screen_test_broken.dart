/// Testes para a tela de login (versão sem timeout)
/// 
/// Este arquivo testa todas as funcionalidades da LoginScreen,
/// evitando problemas de timeout com pumpAndSettle.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:salgados_app/services/auth_service.dart';
import '../test_utils.dart';
import '../test_login_screen.dart';

// Mock do AuthService para testes de login
class MockAuthServiceForLogin extends ChangeNotifier implements AuthService {
  String? _lastEmail;
  String? _lastPassword;
  String? _errorToReturn;
  bool _shouldReturnError = false;

  // Getters para verificar chamadas
  String? get lastEmail => _lastEmail;
  String? get lastPassword => _lastPassword;

  // Configuração para testes
  void setErrorToReturn(String? error) {
    _errorToReturn = error;
    _shouldReturnError = error != null;
  }

  @override
  Future<String?> signIn({required String email, required String password}) async {
    _lastEmail = email;
    _lastPassword = password;
    
    // Simula delay de rede mais curto para testes
    await Future.delayed(const Duration(milliseconds: 50));
    
    if (_shouldReturnError) {
      return _errorToReturn;
    }
    
    return null; // Sucesso
  }

  // Implementações obrigatórias (não usadas nos testes de login)
  @override
  bool get isInitialized => true;
  @override
  bool get isAuthenticated => false;
  @override
  bool get isAdmin => false;
  @override
  bool get isLoading => false;
  @override
  get user => null;
  @override
  Map<String, dynamic>? get userData => null;
  @override
  String? get userEmail => null;
  @override
  String? get userId => null;
  @override
  Future<String?> signUp({required String email, required String password}) async => null;
  @override
  Future<void> signOut() async {}
  @override
  Future<String?> resetPassword(String email) async => null;
  
  @override
  Future<String?> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _shouldReturnError ? _errorToReturn : null;
  }
}

void main() {
  setUpAll(() {
    setupTestEnvironment();
  });
  
  tearDownAll(() {
    tearDownTestEnvironment();
  });

  group('LoginScreen Tests (Fixed)', () {
    late MockAuthServiceForLogin mockAuthService;

    setUp(() {
      mockAuthService = MockAuthServiceForLogin();
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
      
      // Aguarda processamento
      await tester.pump(const Duration(milliseconds: 100));

      // Verifica se o AuthService foi chamado com os dados corretos
      expect(mockAuthService.lastEmail, testEmail);
      expect(mockAuthService.lastPassword, testPassword);
    });

    testWidgets('should show loading indicator during login', (WidgetTester tester) async {
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
      await tester.pump(const Duration(milliseconds: 100));

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
      await tester.pump(const Duration(milliseconds: 100));
      
      // Não deve mostrar erro de validação de email
      expect(find.text('Por favor, insira um e-mail válido.'), findsNothing);
      
      // Verifica se o SnackBar de sucesso apareceu
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Login realizado com sucesso!'), findsOneWidget);
    });
  });
}