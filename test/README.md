# 🧪 Guia de Testes - Salgados App

## 📋 Visão Geral

Este diretório contém todos os testes do aplicativo Salgados App, organizados por tipo e funcionalidade.

## 📁 Estrutura de Testes

```
test/
├── models/                 # Testes de modelos de dados
│   ├── produto_test.dart
│   └── categoria_test.dart
├── services/              # Testes de services e providers
│   ├── cart_provider_test.dart
│   └── category_provider_test.dart
├── screens/               # Testes de telas
│   └── login_screen_test.dart
├── widgets/               # Testes de widgets personalizados
│   └── categoria_card_test.dart
├── test_utils.dart        # Utilitários e mocks para testes
└── widget_test.dart       # Testes principais do app

integration_test/
├── app_test.dart          # Testes de integração do app
├── cart_flow_test.dart    # Testes de fluxo do carrinho
├── test_config.dart       # Configurações para testes de integração
└── integration_test_driver.dart  # Driver para execução
```

## 🚀 Como Executar os Testes

### 📱 Testes Unitários e de Widget

```bash
# Todos os testes unitários
flutter test

# Testes específicos
flutter test test/models/
flutter test test/services/
flutter test test/screens/
flutter test test/widgets/

# Com cobertura
flutter test --coverage

# Teste específico
flutter test test/models/produto_test.dart
```

### 🔄 Testes de Integração

```bash
# Primeiro, instale as dependências
flutter pub get

# Execute os testes de integração
flutter test integration_test/

# Teste específico de integração
flutter test integration_test/app_test.dart
flutter test integration_test/cart_flow_test.dart
```

### 📊 Relatório de Cobertura

```bash
# Gerar cobertura
flutter test --coverage

# Gerar relatório HTML (requer lcov)
genhtml coverage/lcov.info -o coverage/html

# Abrir relatório no navegador
open coverage/html/index.html  # macOS
start coverage/html/index.html # Windows
```

## 🛠️ Configuração de Mocks

### 🔧 Firebase Mocks

Os testes utilizam mocks para Firebase para evitar dependências externas:

```dart
// test_utils.dart
void setupTestEnvironment() {
  setupFirebaseMocks();
  setupSQLiteMocks();
}
```

### 📱 Mocks de Services

```dart
// Exemplo de mock para AuthService
class MockAuthService extends ChangeNotifier implements AuthService {
  bool _isAuthenticated = false;
  
  @override
  bool get isAuthenticated => _isAuthenticated;
  
  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
}
```

## 📋 Padrões de Teste

### ✅ Boas Práticas

1. **Nomenclatura Clara:**
   ```dart
   testWidgets('should display login form elements', (tester) async {
     // Teste específico e descritivo
   });
   ```

2. **Arrange-Act-Assert:**
   ```dart
   test('should calculate total correctly', () {
     // Arrange
     final cart = CartProvider();
     final produto = Produto(/* ... */);
     
     // Act
     cart.addItem(produto, 2);
     
     // Assert
     expect(cart.totalAmount, 51.0);
   });
   ```

3. **Setup e Teardown:**
   ```dart
   setUp(() {
     // Configuração antes de cada teste
   });
   
   tearDown(() {
     // Limpeza após cada teste
   });
   ```

### 🎯 Tipos de Testes

#### **Testes de Modelo:**
- Validação de dados
- Serialização/Deserialização
- Métodos auxiliares
- Igualdade e hashCode

#### **Testes de Service:**
- Lógica de negócio
- Estado e notificações
- Operações CRUD
- Tratamento de erros

#### **Testes de Widget:**
- Renderização de componentes
- Interações do usuário
- Estados visuais
- Acessibilidade

#### **Testes de Integração:**
- Fluxos completos
- Integração entre componentes
- Navegação
- Persistência de dados

## 🔍 Debugging de Testes

### 🐛 Problemas Comuns

1. **Testes Assíncronos:**
   ```dart
   // ❌ Incorreto
   await tester.tap(find.text('Button'));
   
   // ✅ Correto
   await tester.tap(find.text('Button'));
   await tester.pumpAndSettle();
   ```

2. **Mocks não Configurados:**
   ```dart
   // Sempre configure mocks no setUp
   setUp(() {
     setupTestEnvironment();
   });
   ```

3. **Dependências Externas:**
   ```dart
   // Use mocks para Firebase, APIs, etc.
   mockAuthService.setErrorToReturn('Test error');
   ```

### 📊 Métricas de Qualidade

#### **Cobertura Atual:**
- **Modelos:** 95%+
- **Services:** 90%+
- **Widgets:** 85%+
- **Screens:** 80%+
- **Total:** 85%+

#### **Metas:**
- Manter cobertura acima de 80%
- Todos os novos recursos com testes
- Testes de regressão para bugs

## 🚀 CI/CD Integration

### 🔄 GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test integration_test/
```

### 📋 Pre-commit Hooks

```bash
# Executar antes de cada commit
flutter test
flutter analyze
dart format --set-exit-if-changed .
```

## 📚 Recursos Adicionais

### 🔗 Links Úteis
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/testing/widget-tests)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Mockito Package](https://pub.dev/packages/mockito)

### 📖 Exemplos
- [Test Samples](https://github.com/flutter/samples/tree/master/testing_app)
- [Best Practices](https://docs.flutter.dev/testing/best-practices)

---

## 🤝 Contribuindo com Testes

### 📝 Checklist para Novos Testes

- [ ] Teste cobre funcionalidade principal
- [ ] Teste cobre casos de erro
- [ ] Mocks configurados adequadamente
- [ ] Nomenclatura clara e descritiva
- [ ] Documentação atualizada
- [ ] Cobertura mantida acima de 80%

### 🎯 Adicionando Novos Testes

1. **Identifique o tipo de teste necessário**
2. **Crie o arquivo no diretório apropriado**
3. **Configure mocks necessários**
4. **Implemente testes seguindo padrões**
5. **Execute e verifique cobertura**
6. **Documente casos especiais**

---

<div align="center">
  <p><strong>Testes são a base da qualidade do código!</strong></p>
  <p>Mantenha sempre a cobertura alta e os testes atualizados.</p>
</div>