import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xFFFF6600),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.of(context).pop(); // Fecha o menu
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre'),
            onTap: () {
              // TODO: Navegar para a tela Sobre
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contato'),
            onTap: () {
              // TODO: Navegar para a tela Contato
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
