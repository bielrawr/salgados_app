import 'package:flutter/material.dart';

class AddItemCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddItemCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              const Text('Adicionar Item'),
            ],
          ),
        ),
      ),
    );
  }
}
