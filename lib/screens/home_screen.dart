import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/categoria.dart';
import '../widgets/categoria_card.dart';
import '../widgets/main_drawer.dart';
import '../helpers/database_helper.dart';
import '../services/category_provider.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        toolbarHeight: 120,
        title: ClipOval(
          child: Image.asset(
            'assets/images/logo.jpg',
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // We handle the drawer icon manually
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const MainDrawer(),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
          final categories = categoryProvider.categories;
          if (categories.isEmpty) {
            return const Center(child: Text('Nenhuma categoria encontrada.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16.0, 64.0, 16.0, 16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoria = categories[index];
              final DatabaseHelper _dbHelper = DatabaseHelper(); // Instanciar aqui ou passar como dependência
              return FutureBuilder<String?>(
                future: _dbHelper.getRepresentativeImageForCategory(categoria.id),
                builder: (context, snapshot) {
                  return CategoriaCard(
                    categoria: categoria,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductListScreen(categoryId: categoria.id, categoryName: categoria.nome)));
                    },
                    imageUrl: snapshot.data,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
