// Constantes globais do aplicativo Salgados App
library app_constants;
/// 
/// Este arquivo centraliza todas as constantes utilizadas no aplicativo,
/// incluindo cores, strings, dimensões e configurações.

import 'package:flutter/material.dart';

/// Constantes de cores do aplicativo
class AppColors {
  /// Cor primária laranja do aplicativo
  static const Color primary = Color(0xFFFF6600);
  
  /// Cor secundária para elementos de destaque
  static const Color secondary = Colors.orange;
  
  /// MaterialColor personalizado para o tema
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFFF6600,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF6600),
      600: Color(0xFFFF5722),
      700: Color(0xFFE64A19),
      800: Color(0xFFD84315),
      900: Color(0xFFBF360C),
    },
  );
  
  /// Cor de sucesso (verde)
  static const Color success = Colors.green;
  
  /// Cor de erro (vermelho)
  static const Color error = Colors.red;
  
  /// Cor de aviso (amarelo)
  static const Color warning = Colors.amber;
  
  /// Cor de fundo padrão
  static const Color background = Colors.white;
  
  /// Cor do texto principal
  static const Color textPrimary = Colors.black;
  
  /// Cor do texto secundário
  static const Color textSecondary = Colors.grey;
}

/// Constantes de dimensões e espaçamentos
class AppDimensions {
  /// Padding padrão
  static const double defaultPadding = 16.0;
  
  /// Padding pequeno
  static const double smallPadding = 8.0;
  
  /// Padding grande
  static const double largePadding = 24.0;
  
  /// Raio de borda padrão
  static const double defaultBorderRadius = 12.0;
  
  /// Raio de borda pequeno
  static const double smallBorderRadius = 8.0;
  
  /// Elevação padrão para cards
  static const double defaultElevation = 4.0;
  
  /// Elevação pequena
  static const double smallElevation = 2.0;
  
  /// Altura da toolbar personalizada
  static const double customToolbarHeight = 120.0;
  
  /// Tamanho do logo
  static const double logoSize = 100.0;
}

/// Constantes de strings do aplicativo
class AppStrings {
  /// Nome do aplicativo
  static const String appName = 'L&R Produtos Caseiros';
  
  /// Slogan do aplicativo
  static const String appSlogan = 'Sabor e Qualidade';
  
  /// Mensagens de carregamento
  static const String loading = 'Carregando...';
  static const String loadingCategories = 'Carregando categorias...';
  static const String loadingProducts = 'Carregando produtos...';
  
  /// Mensagens de erro
  static const String errorGeneric = 'Ocorreu um erro inesperado';
  static const String errorNetwork = 'Erro de conexão com a internet';
  static const String errorAuth = 'Erro de autenticação';
  static const String errorPermission = 'Permissão negada';
  
  /// Mensagens de sucesso
  static const String successLogin = 'Login realizado com sucesso';
  static const String successLogout = 'Logout realizado com sucesso';
  static const String successAddToCart = 'Produto adicionado ao carrinho';
  
  /// Labels de botões
  static const String buttonLogin = 'Entrar';
  static const String buttonLogout = 'Sair';
  static const String buttonSignUp = 'Cadastrar';
  static const String buttonAddToCart = 'Adicionar ao Carrinho';
  static const String buttonRemove = 'Remover';
  static const String buttonCancel = 'Cancelar';
  static const String buttonConfirm = 'Confirmar';
  
  /// Labels de campos
  static const String fieldEmail = 'E-mail';
  static const String fieldPassword = 'Senha';
  static const String fieldName = 'Nome';
  static const String fieldDescription = 'Descrição';
  static const String fieldPrice = 'Preço';
  
  /// Mensagens de validação
  static const String validationRequired = 'Este campo é obrigatório';
  static const String validationEmail = 'Digite um e-mail válido';
  static const String validationPassword = 'A senha deve ter pelo menos 6 caracteres';
  static const String validationPrice = 'Digite um preço válido';
}

/// Constantes de configuração do Firebase
class FirebaseConstants {
  /// Nome da coleção de usuários
  static const String usersCollection = 'users';
  
  /// Nome da coleção de produtos
  static const String productsCollection = 'products';
  
  /// Nome da coleção de categorias
  static const String categoriesCollection = 'categories';
  
  /// Nome da coleção de pedidos
  static const String ordersCollection = 'orders';
  
  /// Campos padrão
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';
  static const String fieldUserId = 'userId';
  static const String fieldRole = 'role';
  
  /// Roles de usuário
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';
}

/// Constantes de assets (imagens, ícones, etc.)
class AppAssets {
  /// Caminho base para imagens
  static const String imagesPath = 'assets/images/';
  
  /// Logo do aplicativo
  static const String logo = '${imagesPath}logo.jpg';
  
  /// Imagens de placeholder
  static const String placeholderImage = '${imagesPath}placeholder.png';
  static const String noImageAvailable = '${imagesPath}no_image.png';
  
  /// Ícones personalizados
  static const String iconCart = '${imagesPath}cart_icon.png';
  static const String iconUser = '${imagesPath}user_icon.png';
}

/// Constantes de configuração do aplicativo
class AppConfig {
  /// Versão do banco de dados local
  static const int databaseVersion = 3;
  
  /// Nome do banco de dados local
  static const String databaseName = 'salgados_app.db';
  
  /// Timeout para requisições de rede (em segundos)
  static const int networkTimeout = 30;
  
  /// Número máximo de tentativas para operações de rede
  static const int maxRetryAttempts = 3;
  
  /// Tamanho máximo de imagem para upload (em MB)
  static const int maxImageSizeMB = 5;
  
  /// Formatos de imagem aceitos
  static const List<String> acceptedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
}

/// Constantes de animação
class AppAnimations {
  /// Duração padrão das animações
  static const Duration defaultDuration = Duration(milliseconds: 300);
  
  /// Duração rápida
  static const Duration fastDuration = Duration(milliseconds: 150);
  
  /// Duração lenta
  static const Duration slowDuration = Duration(milliseconds: 500);
  
  /// Curvas de animação
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeOut;
  static const Curve slowCurve = Curves.easeIn;
}