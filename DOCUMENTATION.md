# 📚 Documentação Completa - Salgados App

## 🎯 Visão Geral

O Salgados App é um aplicativo Flutter completo para gerenciamento de negócios de alimentação, com foco em salgados brasileiros. Esta documentação fornece informações detalhadas sobre arquitetura, configuração e uso.

## 🏗️ Arquitetura Detalhada

### 📐 Padrões Arquiteturais

#### **Provider Pattern**
- **AuthService**: Gerencia autenticação e estado do usuário
- **CartProvider**: Controla o carrinho de compras
- **CategoryProvider**: Gerencia categorias de produtos

#### **Repository Pattern**
- **FirestoreService**: Abstração para operações do Firestore
- **DatabaseHelper**: Gerencia banco local SQLite

#### **Model-View-ViewModel (MVVM)**
- **Models**: Representam dados (Produto, Categoria, ItemCarrinho)
- **Views**: Telas e widgets da interface
- **ViewModels**: Providers que conectam dados à interface

### 🔄 Fluxo de Dados

```
UI (Screens/Widgets)
    ↕️
Providers (State Management)
    ↕️
Services (Business Logic)
    ↕️
Data Sources (Firebase/SQLite)
```

## 🔧 Configuração Detalhada

### 🔥 Firebase Setup

#### **1. Configuração Inicial**
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Configurar projeto
flutterfire configure
```

#### **2. Serviços Necessários**
- **Authentication**: Email/Password
- **Firestore**: Banco de dados NoSQL
- **Storage**: Armazenamento de imagens
- **Functions**: Lógica server-side (opcional)

#### **3. Regras de Segurança**
```bash
# Deploy das regras
firebase deploy --only firestore:rules
firebase deploy --only storage
```

### 📱 Configuração de Dependências

#### **Principais Dependências**
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1          # State management
  firebase_core: ^4.0.0       # Firebase core
  cloud_firestore: ^6.0.0     # Firestore
  firebase_auth: ^6.0.1       # Authentication
  firebase_storage: ^13.0.0   # Storage
  sqflite: ^2.3.3+1          # Local database
  image_picker: ^1.2.0        # Image selection
  carousel_slider: ^5.1.1     # UI component
```

#### **Dependências de Desenvolvimento**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0       # Linting rules
  integration_test:            # Integration tests
    sdk: flutter
```

## 🧪 Estratégia de Testes

### 📊 Cobertura de Testes

#### **Tipos de Testes Implementados**
1. **Testes Unitários** (60% da cobertura)
   - Models: Produto, Categoria, ItemCarrinho
   - Services: CartProvider, AuthService
   - Utils: Logger, Validators

2. **Testes de Widget** (25% da cobertura)
   - Screens: LoginScreen, HomeScreen
   - Widgets: CategoriaCard, CartItemCard
   - Components: Custom widgets

3. **Testes de Integração** (15% da cobertura)
   - Fluxos completos: Login → Navegação → Compra
   - Sincronização de dados
   - Operações offline/online

#### **Estrutura de Testes**
```
test/
├── models/                 # Testes de modelos
├── services/              # Testes de services
├── screens/               # Testes de telas
├── widgets/               # Testes de widgets
├── test_utils.dart        # Utilitários de teste
└── widget_test.dart       # Testes principais

integration_test/
├── app_test.dart          # Testes de integração
└── cart_flow_test.dart    # Fluxo do carrinho
```

### 🔬 Executando Testes

#### **Comandos Básicos**
```bash
# Todos os testes
flutter test

# Com cobertura
flutter test --coverage

# Testes específicos
flutter test test/models/
flutter test test/services/
flutter test integration_test/

# Gerar relatório HTML
genhtml coverage/lcov.info -o coverage/html
```

#### **Mocks e Configuração**
```dart
// test_utils.dart
void setupTestEnvironment() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseMocks();
  setupSQLiteMocks();
}
```

## 🔒 Segurança

### 🛡️ Regras do Firestore

#### **Estrutura de Segurança**
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários podem ler apenas seus dados
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Produtos são públicos para leitura
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
  }
}
```

#### **Validações Implementadas**
- ✅ Autenticação obrigatória
- ✅ Autorização baseada em roles
- ✅ Validação de dados de entrada
- ✅ Sanitização de inputs
- ✅ Rate limiting (via Functions)

### 🔐 Boas Práticas de Segurança

#### **Client-Side**
- Validação de entrada em todos os formulários
- Sanitização de dados antes do envio
- Tratamento seguro de erros
- Logging sem exposição de dados sensíveis

#### **Server-Side**
- Regras de segurança Firebase rigorosas
- Validação dupla de dados
- Controle de acesso baseado em roles
- Auditoria de operações críticas

## 🚀 Performance

### ⚡ Otimizações Implementadas

#### **Flutter Performance**
- **Widgets Otimizados**: Uso de `const` constructors
- **State Management**: Provider com Selector para rebuilds específicos
- **Lazy Loading**: Carregamento sob demanda de listas
- **Image Caching**: Cache automático de imagens

#### **Firebase Performance**
- **Índices Otimizados**: Consultas eficientes no Firestore
- **Paginação**: Carregamento incremental de dados
- **Offline Support**: Cache local com SQLite
- **Compression**: Imagens otimizadas no Storage

### 📊 Métricas de Performance

#### **Benchmarks Atuais**
- **Tempo de Inicialização**: < 2 segundos
- **Tempo de Login**: < 1 segundo
- **Carregamento de Produtos**: < 500ms
- **Sincronização Offline**: < 3 segundos

#### **Monitoramento**
```dart
// Performance monitoring
class PerformanceMonitor {
  static void trackScreenLoad(String screenName) {
    // Firebase Performance monitoring
  }
  
  static void trackNetworkRequest(String endpoint) {
    // Network performance tracking
  }
}
```

## 🔄 Sincronização Offline

### 📱 Estratégia Offline-First

#### **Arquitetura de Dados**
```
Firebase (Cloud)
    ↕️ Sync
SQLite (Local Cache)
    ↕️ Read/Write
App State (Memory)
```

#### **Implementação**
- **Cache Inteligente**: Dados frequentes em SQLite
- **Sync Automático**: Sincronização quando online
- **Conflict Resolution**: Estratégias de resolução de conflitos
- **Status Indicators**: Indicadores visuais de conectividade

### 🔄 Fluxo de Sincronização

#### **Quando Online**
1. Operações vão direto para Firebase
2. Cache local é atualizado
3. UI reflete mudanças imediatamente

#### **Quando Offline**
1. Operações ficam em fila local
2. Cache local é atualizado
3. UI funciona normalmente
4. Sync automático quando voltar online

## 📈 Analytics e Monitoramento

### 📊 Métricas Coletadas

#### **User Analytics**
- Telas mais visitadas
- Tempo de sessão
- Produtos mais visualizados
- Conversão de carrinho

#### **Performance Analytics**
- Tempo de carregamento
- Erros de rede
- Crashes da aplicação
- Uso de memória

#### **Business Analytics**
- Vendas por categoria
- Produtos mais vendidos
- Horários de pico
- Análise de abandono de carrinho

### 📈 Implementação

```dart
// Analytics service
class AnalyticsService {
  static void trackEvent(String event, Map<String, dynamic> parameters) {
    // Firebase Analytics
  }
  
  static void trackScreen(String screenName) {
    // Screen tracking
  }
  
  static void trackPurchase(double value, String currency) {
    // E-commerce tracking
  }
}
```

## 🛠️ Ferramentas de Desenvolvimento

### 🔧 IDE Configuration

#### **VS Code Extensions**
- Dart
- Flutter
- Firebase
- GitLens
- Error Lens

#### **Android Studio Plugins**
- Flutter
- Dart
- Firebase
- ADB Idea

### 📋 Scripts Úteis

#### **package.json Scripts**
```json
{
  "scripts": {
    "test": "flutter test",
    "test:coverage": "flutter test --coverage",
    "analyze": "flutter analyze",
    "format": "dart format .",
    "build:android": "flutter build apk --release",
    "build:web": "flutter build web --release"
  }
}
```

#### **Makefile**
```makefile
.PHONY: test build clean

test:
	flutter test --coverage

analyze:
	flutter analyze

format:
	dart format .

build-android:
	flutter build apk --release

clean:
	flutter clean && flutter pub get
```

## 🚀 Deploy e CI/CD

### 🔄 Pipeline de CI/CD

#### **GitHub Actions**
```yaml
name: CI/CD Pipeline
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test --coverage
      - run: flutter analyze
```

#### **Ambientes**
- **Development**: Branch `develop`
- **Staging**: Branch `staging`
- **Production**: Branch `main`

### 📦 Build e Deploy

#### **Android**
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Deploy para Play Store
# (via Play Console)
```

#### **Web**
```bash
# Build Web
flutter build web --release

# Deploy para Firebase Hosting
firebase deploy --only hosting
```

## 📞 Suporte e Manutenção

### 🐛 Debugging

#### **Logs Estruturados**
```dart
// Usando o sistema de logging
AppLogger.info('User logged in', 'AUTH');
AppLogger.error('Network error', 'NETWORK', error);
AppLogger.debug('Cache hit', 'CACHE');
```

#### **Error Tracking**
- Firebase Crashlytics
- Custom error reporting
- User feedback integration

### 🔧 Manutenção

#### **Tarefas Regulares**
- Atualização de dependências
- Limpeza de cache
- Backup de dados
- Monitoramento de performance

#### **Versionamento**
- Semantic Versioning (SemVer)
- Changelog automático
- Release notes

---

## 📚 Recursos Adicionais

### 🔗 Links Úteis
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

### 📖 Guias Específicos
- [Guia de Contribuição](CONTRIBUTING.md)
- [Guia de Deploy](DEPLOYMENT.md)
- [API Reference](API.md)
- [Troubleshooting](TROUBLESHOOTING.md)

---

<div align="center">
  <p><strong>Documentação mantida pela equipe de desenvolvimento</strong></p>
  <p>Última atualização: $(date)</p>
</div>