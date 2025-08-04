import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/categoria.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onTap;

  const CategoriaCard({super.key, required this.categoria, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias, // Garante que o carrossel não ultrapasse as bordas do card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: categoria.imageUrls.length > 1
                  ? CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 1.0, // Mantém o card quadrado
                        viewportFraction: 1.0, // A imagem ocupa todo o espaço do carrossel
                      ),
                      items: categoria.imageUrls.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return _buildImage(imageUrl);
                          },
                        );
                      }).toList(),
                    )
                  : _buildImage(categoria.imageUrls.first),
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

  // Widget auxiliar para construir a imagem, evitando repetição de código
  Widget _buildImage(String imageUrl) {
    return imageUrl.startsWith('http')
        ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (ctx, err, st) => const Icon(Icons.error))
        : Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder: (ctx, err, st) => const Icon(Icons.error));
  }
}
