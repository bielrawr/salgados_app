import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onTap;
  final String? imageUrl;

  const CategoriaCard({super.key, required this.categoria, required this.onTap, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) =>
                          const Center(child: Icon(Icons.image_not_supported, size: 50)))
                  : const Center(child: Icon(Icons.image, size: 50)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(categoria.nome.toUpperCase()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
