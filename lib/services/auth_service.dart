/// Serviço de autenticação para o aplicativo Salgados App
/// 
/// Este serviço gerencia toda a autenticação de usuários usando Firebase Auth
/// e mantém os dados do usuário sincronizados com o Firestore.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/app_constants.dart';
import '../constants/messages.dart';
import '../utils/logger.dart';

/// Exceção personalizada para erros de autenticação
class AuthException implements Exception {
  final String message;
  final String? code;
  
  const AuthException(this.message, [this.code]);
  
  @override
  String toString() => 'AuthException: $message';
}

/// Serviço de autenticação com Firebase
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isInitialized = false;
  bool _isLoading = false;

  /// Construtor que inicia o listener de mudanças de estado
  AuthService() {
    _initializeAuthListener();
  }

  // Getters públicos
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _userData?[FirebaseConstants.fieldRole] == FirebaseConstants.roleAdmin;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;
  String? get userEmail => _user?.email;
  String? get userId => _user?.uid;

  /// Inicializa o listener de mudanças de estado de autenticação
  void _initializeAuthListener() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  /// Callback chamado quando o estado de autenticação muda
  Future<void> _onAuthStateChanged(User? user) async {
    try {
      AuthLogger.userStateChanged(user?.uid);
      logInfo('Auth state changed - User: ${user?.uid}, isAuthenticated: ${user != null}');
      
      if (user == null) {
        // Usuário deslogado
        _user = null;
        _userData = null;
        _isInitialized = true;
        logInfo('Notifying listeners - user logged out');
        notifyListeners();
        return;
      }

      // Usuário logado
      _user = user;
      await _loadUserData(user.uid);
      
    } catch (e, stackTrace) {
      logError('Erro no listener de autenticação', e, stackTrace);
      _userData = null;
    } finally {
      _isInitialized = true;
      logInfo('Notifying listeners - auth state change complete');
      notifyListeners();
    }
  }

  /// Carrega os dados do usuário do Firestore
  Future<void> _loadUserData(String userId) async {
    try {
      FirestoreLogger.documentRead(FirebaseConstants.usersCollection, userId);
      
      DocumentSnapshot userDoc = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        // Cria documento do usuário se não existir
        await _createUserDocument(userId);
        userDoc = await _firestore
            .collection(FirebaseConstants.usersCollection)
            .doc(userId)
            .get();
      }
      
      _userData = userDoc.data() as Map<String, dynamic>?;
      logInfo('Dados do usuário carregados com sucesso');
      
    } catch (e, stackTrace) {
      FirestoreLogger.firestoreError('load user data', e.toString());
      logError('Erro ao carregar dados do usuário', e, stackTrace);
      _userData = null;
    }
  }

  /// Cria documento do usuário no Firestore
  Future<void> _createUserDocument(String userId) async {
    try {
      final userData = {
        'email': _user?.email,
        FirebaseConstants.fieldRole: FirebaseConstants.roleUser,
        FirebaseConstants.fieldCreatedAt: FieldValue.serverTimestamp(),
        FirebaseConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
      };
      
      await _firestore
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .set(userData);
      
      FirestoreLogger.documentWrite(FirebaseConstants.usersCollection, userId);
      logInfo('Documento do usuário criado com sucesso');
      
    } catch (e, stackTrace) {
      FirestoreLogger.firestoreError('create user document', e.toString());
      logError('Erro ao criar documento do usuário', e, stackTrace);
      rethrow;
    }
  }

  /// Realiza cadastro de novo usuário
  /// 
  /// [email] Email do usuário
  /// [password] Senha do usuário
  /// Retorna null em caso de sucesso ou mensagem de erro
  Future<String?> signUp({
    required String email, 
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      return ValidationMessages.emailRequired;
    }
    
    if (password.length < 6) {
      return ValidationMessages.passwordTooShort;
    }
    
    _setLoading(true);
    
    try {
      AuthLogger.signupAttempt(email);
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (credential.user != null) {
        AuthLogger.signupSuccess(credential.user!.uid);
        logInfo('Cadastro realizado com sucesso');
        return null; // Sucesso
      }
      
      return 'Erro inesperado durante o cadastro';
      
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getAuthErrorMessage(e);
      AuthLogger.signupError(errorMessage);
      logError('Erro no cadastro', e);
      return errorMessage;
      
    } catch (e, stackTrace) {
      const errorMessage = 'Erro inesperado durante o cadastro';
      AuthLogger.signupError(errorMessage);
      logError(errorMessage, e, stackTrace);
      return errorMessage;
      
    } finally {
      _setLoading(false);
    }
  }

  /// Realiza login do usuário
  /// 
  /// [email] Email do usuário
  /// [password] Senha do usuário
  /// Retorna null em caso de sucesso ou mensagem de erro
  Future<String?> signIn({
    required String email, 
    required String password,
  }) async {
    if (email.trim().isEmpty) {
      return ValidationMessages.emailRequired;
    }
    
    if (password.isEmpty) {
      return ValidationMessages.passwordRequired;
    }
    
    _setLoading(true);
    
    try {
      AuthLogger.loginAttempt(email);
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      if (credential.user != null) {
        AuthLogger.loginSuccess(credential.user!.uid);
        logInfo('Login realizado com sucesso');
        return null; // Sucesso
      }
      
      return 'Erro inesperado durante o login';
      
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getAuthErrorMessage(e);
      AuthLogger.loginError(errorMessage);
      logError('Erro no login', e);
      return errorMessage;
      
    } catch (e, stackTrace) {
      const errorMessage = 'Erro inesperado durante o login';
      AuthLogger.loginError(errorMessage);
      logError(errorMessage, e, stackTrace);
      return errorMessage;
      
    } finally {
      _setLoading(false);
    }
  }

  /// Realiza logout do usuário
  Future<void> signOut() async {
    try {
      final currentUserId = _user?.uid;
      
      // Logout do Firebase
      await _auth.signOut();
      
      // Logout do Google (se estiver logado)
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        // Ignora erro se não estiver logado com Google
        logInfo('Não estava logado com Google ou erro no logout do Google');
      }
      
      if (currentUserId != null) {
        AuthLogger.logout(currentUserId);
      }
      
      logInfo('Logout realizado com sucesso');
      
    } catch (e, stackTrace) {
      logError('Erro durante logout', e, stackTrace);
      rethrow;
    }
  }

  /// Envia email de redefinição de senha
  /// 
  /// [email] Email do usuário
  /// Retorna null em caso de sucesso ou mensagem de erro
  Future<String?> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      return ValidationMessages.emailRequired;
    }
    
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      logInfo('Email de redefinição de senha enviado');
      return null; // Sucesso
      
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getAuthErrorMessage(e);
      logError('Erro ao enviar email de redefinição', e);
      return errorMessage;
      
    } catch (e, stackTrace) {
      const errorMessage = 'Erro inesperado ao enviar email de redefinição';
      logError(errorMessage, e, stackTrace);
      return errorMessage;
    }
  }

  /// Realiza login com Google
  /// 
  /// Retorna null em caso de sucesso ou mensagem de erro
  Future<String?> signInWithGoogle() async {
    _setLoading(true);
    
    try {
      AuthLogger.loginAttempt('Google Sign-In');
      
      // Inicia o fluxo de autenticação do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // Usuário cancelou o login
        return 'Login cancelado pelo usuário';
      }
      
      // Obtém os detalhes de autenticação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Cria credencial para o Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Faz login no Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        AuthLogger.loginSuccess(userCredential.user!.uid);
        logInfo('Login com Google realizado com sucesso');
        return null; // Sucesso
      }
      
      return 'Erro inesperado durante o login com Google';
      
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getAuthErrorMessage(e);
      AuthLogger.loginError('Google: $errorMessage');
      logError('Erro no login com Google', e);
      return errorMessage;
      
    } catch (e, stackTrace) {
      const errorMessage = 'Erro inesperado durante o login com Google';
      AuthLogger.loginError(errorMessage);
      logError(errorMessage, e, stackTrace);
      return errorMessage;
      
    } finally {
      _setLoading(false);
    }
  }



  /// Atualiza o estado de loading
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Converte códigos de erro do Firebase Auth em mensagens amigáveis em português
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      // Erros de usuário
      case 'user-not-found':
        return AuthMessages.userNotFound;
      case 'user-disabled':
        return AuthMessages.userDisabled;
      
      // Erros de senha
      case 'wrong-password':
        return AuthMessages.wrongPassword;
      case 'weak-password':
        return AuthMessages.weakPassword;
      
      // Erros de email
      case 'email-already-in-use':
        return AuthMessages.emailAlreadyInUse;
      case 'invalid-email':
        return AuthMessages.invalidEmail;
      case 'invalid-credential':
        return AuthMessages.invalidCredential;
      
      // Erros de rede e sistema
      case 'network-request-failed':
        return AuthMessages.networkError;
      case 'too-many-requests':
        return AuthMessages.tooManyRequests;
      case 'operation-not-allowed':
        return AuthMessages.operationNotAllowed;
      
      // Erros de autenticação social
      case 'account-exists-with-different-credential':
        return AuthMessages.accountExistsWithDifferentCredential;
      case 'credential-already-in-use':
        return AuthMessages.credentialAlreadyInUse;
      case 'popup-closed-by-user':
        return AuthMessages.loginCancelled;
      case 'popup-blocked':
        return AuthMessages.popupBlocked;
      
      // Erros de sessão
      case 'requires-recent-login':
        return AuthMessages.requiresRecentLogin;
      case 'user-token-expired':
        return AuthMessages.tokenExpired;
      
      // Erros de validação
      case 'missing-email':
        return ValidationMessages.emailRequired;
      case 'missing-password':
        return ValidationMessages.passwordRequired;
      case 'invalid-action-code':
        return 'Código de ação inválido ou expirado.';
      
      // Erro padrão
      default:
        // Se a mensagem original estiver em inglês, traduzimos algumas comuns
        String message = e.message ?? 'Erro de autenticação';
        
        // Traduções de mensagens comuns em inglês
        if (message.toLowerCase().contains('password')) {
          return 'Erro relacionado à senha. Verifique os dados digitados.';
        }
        if (message.toLowerCase().contains('email')) {
          return 'Erro relacionado ao email. Verifique o formato digitado.';
        }
        if (message.toLowerCase().contains('network')) {
          return 'Erro de conexão. Verifique sua internet.';
        }
        if (message.toLowerCase().contains('user')) {
          return 'Erro relacionado ao usuário. Verifique os dados de login.';
        }
        
        return AuthMessages.unexpectedError;
    }
  }

  /// Limpa os dados quando o serviço é descartado
  @override
  void dispose() {
    super.dispose();
  }
}