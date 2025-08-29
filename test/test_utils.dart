/// Utilitários para testes do aplicativo Salgados App
/// 
/// Este arquivo contém funções auxiliares e configurações
/// necessárias para executar testes de forma consistente.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Configura o ambiente de teste
/// 
/// Esta função deve ser chamada no início de cada arquivo de teste
/// que precisa de configurações específicas.
void setupTestEnvironment() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock do Firebase Core
  setupFirebaseMocks();
  
  // Mock do SQLite
  setupSQLiteMocks();
}

/// Configura mocks para o Firebase
void setupFirebaseMocks() {
  // Mock básico para Firebase Core
  const MethodChannel('plugins.flutter.io/firebase_core')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Firebase#initializeCore':
        return [
          {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': 'test-api-key',
              'appId': 'test-app-id',
              'messagingSenderId': 'test-sender-id',
              'projectId': 'test-project-id',
            },
            'pluginConstants': {},
          }
        ];
      case 'Firebase#initializeApp':
        return {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'test-api-key',
            'appId': 'test-app-id',
            'messagingSenderId': 'test-sender-id',
            'projectId': 'test-project-id',
          },
          'pluginConstants': {},
        };
      default:
        return null;
    }
  });

  // Mock para Firebase Auth
  const MethodChannel('plugins.flutter.io/firebase_auth')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Auth#registerIdTokenListener':
        return null;
      case 'Auth#registerAuthStateListener':
        return null;
      case 'Auth#signInWithEmailAndPassword':
        return {
          'user': {
            'uid': 'test-uid',
            'email': 'test@example.com',
          }
        };
      case 'Auth#createUserWithEmailAndPassword':
        return {
          'user': {
            'uid': 'test-uid',
            'email': 'test@example.com',
          }
        };
      case 'Auth#signOut':
        return null;
      default:
        return null;
    }
  });

  // Mock para Firestore
  const MethodChannel('plugins.flutter.io/cloud_firestore')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'Firestore#settings':
        return null;
      case 'DocumentReference#get':
        return {
          'data': {},
          'metadata': {'isFromCache': false}
        };
      case 'DocumentReference#set':
        return null;
      case 'Query#snapshots':
        return null;
      default:
        return null;
    }
  });
}

/// Configura mocks para SQLite
void setupSQLiteMocks() {
  // Mock básico para SQLite - pode ser expandido conforme necessário
  const MethodChannel('com.tekartik.sqflite')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'openDatabase':
        return 1; // Database ID
      case 'execute':
        return null;
      case 'insert':
        return 1; // Row ID
      case 'query':
        return [];
      case 'update':
        return 1; // Number of rows affected
      case 'delete':
        return 1; // Number of rows affected
      case 'closeDatabase':
        return null;
      default:
        return null;
    }
  });
}

/// Limpa todos os mocks após os testes
void tearDownTestEnvironment() {
  // Remove todos os mock handlers
  const MethodChannel('plugins.flutter.io/firebase_core')
      .setMockMethodCallHandler(null);
  const MethodChannel('plugins.flutter.io/firebase_auth')
      .setMockMethodCallHandler(null);
  const MethodChannel('plugins.flutter.io/cloud_firestore')
      .setMockMethodCallHandler(null);
  const MethodChannel('com.tekartik.sqflite')
      .setMockMethodCallHandler(null);
}