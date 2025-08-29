import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/custom_alert.dart';
import '../widgets/social_buttons.dart';
import '../constants/messages.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final error = await authService.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (error != null) {
        // Exibe erro com popup customizado
        await CustomAlert.error(
          context: context,
          message: error,
          title: AuthMessages.signupErrorTitle,
        );
      } else {
        // Mostra sucesso com popup elegante
        await CustomAlert.success(
          context: context,
          message: AuthMessages.signupSuccess,
          title: AuthMessages.signupSuccessTitle,
          useDialog: true, // Popup elegante
        );
        
        // Aguarda um pouco para garantir que o estado foi atualizado
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Força navegação manual já que o Consumer não está reagindo
        if (mounted && authService.isAuthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          );
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isGoogleLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final error = await authService.signInWithGoogle();

    if (mounted) {
      setState(() {
        _isGoogleLoading = false;
      });

      if (error != null) {
        await CustomAlert.error(
          context: context,
          message: error,
          title: '❌ Erro no Login com Google',
        );
      } else {
        await CustomAlert.success(
          context: context,
          message: 'Login com Google realizado com sucesso!\nBem-vindo à L&R Produtos Caseiros!',
          title: '🎉 Bem-vindo!',
          useDialog: true,
        );
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted && authService.isAuthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Botão de cadastro
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_isLoading || _isGoogleLoading) ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6600),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Cadastrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Botão de autenticação social (apenas Google)
                SocialAuthButtons(
                  onGooglePressed: _signInWithGoogle,
                  isLoading: _isGoogleLoading,
                ),
                
                const SizedBox(height: 30),
                
                // Link para login
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Já tem uma conta? Faça login',
                    style: TextStyle(
                      color: Color(0xFFFF6600),
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
  }
}