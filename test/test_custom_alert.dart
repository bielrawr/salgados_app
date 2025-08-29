/// Versão de teste do CustomAlert sem timers para evitar problemas nos testes
/// 
/// Esta versão remove os timers automáticos que causam problemas nos testes

import 'package:flutter/material.dart';

/// Tipos de alerta disponíveis
enum TestAlertType {
  success,
  error,
  warning,
  info,
}

/// Versão de teste do CustomAlert sem timers
class TestCustomAlert {
  /// Exibe um dialog popup simples para testes (sem auto-close)
  static Future<void> showDialog({
    required BuildContext context,
    required String title,
    required String message,
    required TestAlertType type,
  }) async {
    final alertConfig = _getAlertConfig(type);
    
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 100), // Mais rápido para testes
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: alertConfig.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      alertConfig.icon,
                      color: alertConfig.color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Título
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Mensagem
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Botão OK
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: alertConfig.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Métodos de conveniência para cada tipo (sem auto-close)
  static Future<void> success({
    required BuildContext context,
    required String message,
    String title = '🎉 Sucesso!',
  }) async {
    await showDialog(
      context: context,
      title: title,
      message: message,
      type: TestAlertType.success,
    );
  }

  static Future<void> error({
    required BuildContext context,
    required String message,
    String title = '❌ Erro!',
  }) async {
    await showDialog(
      context: context,
      title: title,
      message: message,
      type: TestAlertType.error,
    );
  }

  /// Configuração de cores e ícones para cada tipo de alerta
  static _TestAlertConfig _getAlertConfig(TestAlertType type) {
    switch (type) {
      case TestAlertType.success:
        return _TestAlertConfig(
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case TestAlertType.error:
        return _TestAlertConfig(
          color: Colors.red,
          icon: Icons.error,
        );
      case TestAlertType.warning:
        return _TestAlertConfig(
          color: Colors.orange,
          icon: Icons.warning,
        );
      case TestAlertType.info:
        return _TestAlertConfig(
          color: Colors.blue,
          icon: Icons.info,
        );
    }
  }
}

/// Configuração interna para alertas de teste
class _TestAlertConfig {
  final Color color;
  final IconData icon;

  _TestAlertConfig({
    required this.color,
    required this.icon,
  });
}