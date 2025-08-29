import 'package:flutter/material.dart';
import '../models/categoria.dart';
import 'cached_image_widget.dart';

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
                  ? CachedImageWidget(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                    )
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
