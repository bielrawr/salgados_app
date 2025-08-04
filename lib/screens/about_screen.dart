import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'admin_menu_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final TextEditingController _passwordController = TextEditingController();

  void _showAdminLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Acesso Restrito'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Palavra-chave',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                _passwordController.clear();
              },
            ),
            ElevatedButton(
              child: const Text('Entrar'),
              onPressed: () {
                final authService = Provider.of<AuthService>(context, listen: false);
                authService.loginAdmin(_passwordController.text);
                Navigator.of(context).pop();
                _passwordController.clear();
                if (authService.isAdminLoggedIn) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminMenuScreen()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: const Color(0xFFFF6600),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Aplicativo de delivery de produtos caseiros.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Consumer<AuthService>(
              builder: (context, authService, child) {
                if (authService.isAdminLoggedIn) {
                  return Column(
                    children: [
                      const Text('Você está logado como administrador.'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminMenuScreen()));
                        },
                        child: const Text('Ir para Painel Admin'),
                      ),
                    ],
                  );
                } else {
                  return ElevatedButton(
                    onPressed: _showAdminLoginDialog,
                    child: const Text('Login de Administrador'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}