
import 'package:flutter/material.dart';
import 'admin_category_screen.dart';

class AdminMenuScreen extends StatelessWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Cardápio'),
        backgroundColor: const Color(0xFFFF6600),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bem-vindo, Administrador!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminCategoryScreen()));
              },
              child: const Text('Gerenciar Categorias'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navegar para a tela de gerenciamento de produtos
                print('Gerenciar Produtos');
              },
              child: const Text('Gerenciar Produtos'),
            ),
          ],
        ),
      ),
    );
  }
}
