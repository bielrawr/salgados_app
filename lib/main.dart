import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SalgadosApp());
}

class SalgadosApp extends StatelessWidget {
  const SalgadosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LR Salgados',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}