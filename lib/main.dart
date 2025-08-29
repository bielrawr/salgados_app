/// Aplicativo Salgados App - Ponto de entrada principal
/// 
/// Este arquivo configura e inicializa o aplicativo Flutter
/// com Firebase, providers e configurações necessárias.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants/app_constants.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'services/category_provider.dart';
import 'services/cart_provider.dart';
import 'utils/logger.dart';
import 'firebase_options.dart';

/// Função principal que inicializa o aplicativo
void main() async {
  // Garante que os widgets estão inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Configura o logger
    AppLogger.configure(
      enabled: true,
      minLevel: LogLevel.debug,
    );
    
    AppLogger.info('Iniciando aplicativo Salgados App');
    
    // Inicializa o Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.info('Firebase inicializado com sucesso');

    // Configura SQLite para desktop (se necessário)
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    AppLogger.info('SQLite configurado');
    
    // Inicia o aplicativo
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthService()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
        ],
        child: const SalgadosApp(),
      ),
    );
    
  } catch (e, stackTrace) {
    AppLogger.critical('Erro crítico na inicialização do app', 'MAIN', e);
    AppLogger.error('Stack trace', 'MAIN', null, stackTrace);
    
    // Em caso de erro crítico, ainda tenta iniciar o app
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Erro ao inicializar o aplicativo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Erro: $e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget principal do aplicativo
class SalgadosApp extends StatelessWidget {
  const SalgadosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
      home: Consumer<AuthService>(
        builder: (context, authService, child) {
          // Debug: Log do estado atual
          AppLogger.debug('AuthService state - isInitialized: ${authService.isInitialized}, isAuthenticated: ${authService.isAuthenticated}, user: ${authService.user?.uid}', 'MAIN');
          
          // Mostra tela de carregamento enquanto inicializa
          if (!authService.isInitialized) {
            AppLogger.debug('Showing loading screen', 'MAIN');
            return _buildLoadingScreen();
          }
          
          // Se autenticado, vai para home
          if (authService.isAuthenticated) {
            AppLogger.debug('User authenticated, showing HomeScreen', 'MAIN');
            return const HomeScreen();
          }
          
          // Se não autenticado, vai para login
          AppLogger.debug('User not authenticated, showing LoginScreen', 'MAIN');
          return const LoginScreen();
        },
      ),
    );
  }

  /// Constrói o tema do aplicativo
  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: AppColors.primarySwatch,
      primaryColor: AppColors.primary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Configuração de cards
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.defaultBorderRadius),
        ),
        elevation: AppDimensions.defaultElevation,
      ),
      
      // Configuração de botões elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.smallBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.largePadding,
            vertical: AppDimensions.defaultPadding,
          ),
        ),
      ),
      
      // Configuração da AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppDimensions.defaultElevation,
      ),
      
      // Configuração de cores
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        background: AppColors.background,
      ),
    );
  }

  /// Constrói a tela de carregamento
  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: AppDimensions.defaultPadding),
            Text(
              AppStrings.loading,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}