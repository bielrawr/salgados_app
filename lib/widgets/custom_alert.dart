/// Sistema de alertas customizados para o Salgados App
/// 
/// Este arquivo fornece diferentes tipos de alertas elegantes
/// para substituir os SnackBars padrão.

import 'package:flutter/material.dart';

/// Tipos de alerta disponíveis
enum AlertType {
  success,
  error,
  warning,
  info,
}

/// Classe principal para exibir alertas customizados
class CustomAlert {
  /// Exibe um dialog popup elegante
  static Future<void> showDialog({
    required BuildContext context,
    required String title,
    required String message,
    required AlertType type,
    Duration duration = const Duration(seconds: 3),
    bool autoClose = true,
  }) async {
    final alertConfig = _getAlertConfig(type);
    
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.elasticOut),
              ),
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
          ),
        );
      },
    );

    // Auto-close se especificado
    if (autoClose) {
      Future.delayed(duration, () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  /// Exibe um toast overlay elegante (mais discreto)
  static void showToast({
    required BuildContext context,
    required String message,
    required AlertType type,
    Duration duration = const Duration(seconds: 2),
  }) {
    final alertConfig = _getAlertConfig(type);
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: alertConfig.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  alertConfig.icon,
                  color: alertConfig.color,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove após duração especificada
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  /// Métodos de conveniência para cada tipo
  static Future<void> success({
    required BuildContext context,
    required String message,
    String title = '🎉 Sucesso!',
    bool useDialog = true,
  }) async {
    if (useDialog) {
      await showDialog(
        context: context,
        title: title,
        message: message,
        type: AlertType.success,
      );
    } else {
      showToast(
        context: context,
        message: message,
        type: AlertType.success,
      );
    }
  }

  static Future<void> error({
    required BuildContext context,
    required String message,
    String title = '❌ Erro!',
    bool useDialog = true,
  }) async {
    if (useDialog) {
      await showDialog(
        context: context,
        title: title,
        message: message,
        type: AlertType.error,
        autoClose: false, // Erros não fecham automaticamente
      );
    } else {
      showToast(
        context: context,
        message: message,
        type: AlertType.error,
        duration: const Duration(seconds: 3),
      );
    }
  }

  static Future<void> warning({
    required BuildContext context,
    required String message,
    String title = '⚠️ Atenção!',
    bool useDialog = true,
  }) async {
    if (useDialog) {
      await showDialog(
        context: context,
        title: title,
        message: message,
        type: AlertType.warning,
      );
    } else {
      showToast(
        context: context,
        message: message,
        type: AlertType.warning,
      );
    }
  }

  static Future<void> info({
    required BuildContext context,
    required String message,
    String title = '📝 Informação',
    bool useDialog = true,
  }) async {
    if (useDialog) {
      await showDialog(
        context: context,
        title: title,
        message: message,
        type: AlertType.info,
      );
    } else {
      showToast(
        context: context,
        message: message,
        type: AlertType.info,
      );
    }
  }

  /// Método especial para confirmações (retorna true/false)
  static Future<bool> confirm({
    required BuildContext context,
    required String message,
    String title = '🤔 Confirmar Ação',
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    bool? result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.elasticOut),
              ),
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
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: Colors.orange,
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
                    
                    // Botões
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              cancelText,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              confirmText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    
    return result ?? false;
  }

  /// Configuração de cores e ícones para cada tipo de alerta
  static _AlertConfig _getAlertConfig(AlertType type) {
    switch (type) {
      case AlertType.success:
        return _AlertConfig(
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case AlertType.error:
        return _AlertConfig(
          color: Colors.red,
          icon: Icons.error,
        );
      case AlertType.warning:
        return _AlertConfig(
          color: Colors.orange,
          icon: Icons.warning,
        );
      case AlertType.info:
        return _AlertConfig(
          color: Colors.blue,
          icon: Icons.info,
        );
    }
  }
}

/// Configuração interna para alertas
class _AlertConfig {
  final Color color;
  final IconData icon;

  _AlertConfig({
    required this.color,
    required this.icon,
  });
}