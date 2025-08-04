import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../widgets/categoria_card.dart';
import '../widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Dados de exemplo
  final List<Categoria> _categorias = const [
    const Categoria(nome: 'PIZZAS', imageUrls: ['assets/images/pizzas.jpg', 'assets/images/pizza_carousel_1.jpg', 'assets/images/pizza_carousel_2.jpg']),
    const Categoria(nome: 'SALGADOS', imageUrls: [
      'assets/images/salgado_1.jpg',
      'assets/images/salgado_2.jpg',
      'assets/images/salgado_3.jpg',
      'assets/images/salgado_4.jpg',
      'assets/images/salgado_5.jpg',
      'assets/images/salgado_6.jpg',
      'assets/images/salgado_7.jpg',
      'assets/images/salgado_8.jpg',
      'assets/images/salgado_9.jpg',
      'assets/images/salgado_10.jpg',
    ]),
    const Categoria(nome: 'Doces', imageUrls: ['https://via.placeholder.com/150']),
    const Categoria(nome: 'Bebidas', imageUrls: ['https://via.placeholder.com/150']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: const Color(0xFFFF6600),
        toolbarHeight: 120, // Define a altura da área principal da AppBar
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Desce o logo
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.jpg',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Opacity(
              opacity: 0.85,
              child: Text(
                'Produtos Caseiros',
                style: const TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      drawer: const MainDrawer(),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          return CategoriaCard(
            categoria: categoria,
            onTap: () {
              // TODO: Navegar para a tela de produtos da categoria
              print('Categoria selecionada: ${categoria.nome}');
            },
          );
        },
      ),
    );
  }
}
