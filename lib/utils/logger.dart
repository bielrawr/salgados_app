/// Sistema de logging para o aplicativo Salgados App
/// 
/// Este arquivo fornece um sistema de logging estruturado que pode
/// ser facilmente configurado para diferentes ambientes (dev/prod).

import 'package:flutter/foundation.dart';

/// Níveis de log disponíveis
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

/// Classe principal para logging
class AppLogger {
  static bool _isEnabled = kDebugMode; // Só ativa em modo debug por padrão
  static LogLevel _minLevel = LogLevel.debug;
  
  /// Configura o logger
  static void configure({
    bool enabled = true,
    LogLevel minLevel = LogLevel.debug,
  }) {
    _isEnabled = enabled;
    _minLevel = minLevel;
  }
  
  /// Desabilita completamente o logging (para produção)
  static void disable() {
    _isEnabled = false;
  }
  
  /// Log de debug (apenas em desenvolvimento)
  static void debug(String message, [String? tag]) {
    _log(LogLevel.debug, message, tag);
  }
  
  /// Log de informação
  static void info(String message, [String? tag]) {
    _log(LogLevel.info, message, tag);
  }
  
  /// Log de aviso
  static void warning(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag);
  }
  
  /// Log de erro
  static void error(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, tag);
    if (error != null) {
      _log(LogLevel.error, 'Error details: $error', tag);
    }
    if (stackTrace != null && kDebugMode) {
      _log(LogLevel.error, 'Stack trace: $stackTrace', tag);
    }
  }
  
  /// Log crítico (sempre exibido, mesmo em produção)
  static void critical(String message, [String? tag, Object? error]) {
    _log(LogLevel.critical, message, tag, forceLog: true);
    if (error != null) {
      _log(LogLevel.critical, 'Critical error details: $error', tag, forceLog: true);
    }
  }
  
  /// Método interno para realizar o log
  static void _log(LogLevel level, String message, String? tag, {bool forceLog = false}) {
    if (!_isEnabled && !forceLog) return;
    if (level.index < _minLevel.index && !forceLog) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = _getLevelString(level);
    final tagStr = tag != null ? '[$tag] ' : '';
    
    final logMessage = '$timestamp $levelStr $tagStr$message';
    
    // Em modo debug, usa debugPrint para melhor formatação
    if (kDebugMode) {
      debugPrint(logMessage);
    } else if (forceLog) {
      // Em produção, só logs críticos são exibidos
      print(logMessage); // ignore: avoid_print
    }
  }
  
  /// Retorna a string do nível de log
  static String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG]';
      case LogLevel.info:
        return '[INFO] ';
      case LogLevel.warning:
        return '[WARN] ';
      case LogLevel.error:
        return '[ERROR]';
      case LogLevel.critical:
        return '[CRIT] ';
    }
  }
}

/// Extensão para facilitar o uso do logger em classes
extension LoggerExtension on Object {
  /// Retorna o nome da classe para usar como tag
  String get _className => runtimeType.toString();
  
  /// Log de debug com tag automática
  void logDebug(String message) {
    AppLogger.debug(message, _className);
  }
  
  /// Log de info com tag automática
  void logInfo(String message) {
    AppLogger.info(message, _className);
  }
  
  /// Log de warning com tag automática
  void logWarning(String message) {
    AppLogger.warning(message, _className);
  }
  
  /// Log de erro com tag automática
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    AppLogger.error(message, _className, error, stackTrace);
  }
  
  /// Log crítico com tag automática
  void logCritical(String message, [Object? error]) {
    AppLogger.critical(message, _className, error);
  }
}

/// Logger específico para operações de autenticação
class AuthLogger {
  static const String _tag = 'AUTH';
  
  static void userStateChanged(String? userId) {
    AppLogger.info('User state changed: ${userId ?? 'null'}', _tag);
  }
  
  static void loginAttempt(String email) {
    AppLogger.info('Login attempt for: $email', _tag);
  }
  
  static void loginSuccess(String userId) {
    AppLogger.info('Login successful for user: $userId', _tag);
  }
  
  static void loginError(String error) {
    AppLogger.error('Login failed: $error', _tag);
  }
  
  static void signupAttempt(String email) {
    AppLogger.info('Signup attempt for: $email', _tag);
  }
  
  static void signupSuccess(String userId) {
    AppLogger.info('Signup successful for user: $userId', _tag);
  }
  
  static void signupError(String error) {
    AppLogger.error('Signup failed: $error', _tag);
  }
  
  static void logout(String userId) {
    AppLogger.info('User logged out: $userId', _tag);
  }
}

/// Logger específico para operações do carrinho
class CartLogger {
  static const String _tag = 'CART';
  
  static void itemAdded(String productId, int quantity) {
    AppLogger.info('Item added: $productId (qty: $quantity)', _tag);
  }
  
  static void itemRemoved(String productId) {
    AppLogger.info('Item removed: $productId', _tag);
  }
  
  static void quantityChanged(String productId, int oldQty, int newQty) {
    AppLogger.info('Quantity changed for $productId: $oldQty -> $newQty', _tag);
  }
  
  static void cartCleared() {
    AppLogger.info('Cart cleared', _tag);
  }
  
  static void cartError(String error) {
    AppLogger.error('Cart operation failed: $error', _tag);
  }
}

/// Logger específico para operações do Firestore
class FirestoreLogger {
  static const String _tag = 'FIRESTORE';
  
  static void documentRead(String collection, String docId) {
    AppLogger.debug('Document read: $collection/$docId', _tag);
  }
  
  static void documentWrite(String collection, String docId) {
    AppLogger.debug('Document written: $collection/$docId', _tag);
  }
  
  static void documentDelete(String collection, String docId) {
    AppLogger.info('Document deleted: $collection/$docId', _tag);
  }
  
  static void queryExecuted(String collection, int resultCount) {
    AppLogger.debug('Query executed on $collection: $resultCount results', _tag);
  }
  
  static void firestoreError(String operation, String error) {
    AppLogger.error('Firestore $operation failed: $error', _tag);
  }
}