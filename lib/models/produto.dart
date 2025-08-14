import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String? id;
  final String nome;
  final String descricao;
  final double preco;
  final String categoryId;
  final List<String> imageUrls;
  final bool isAvailable;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoryId,
    this.imageUrls = const [],
    this.isAvailable = true,
  });

  factory Produto.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Produto(
      id: doc.id,
      nome: data['nome'] ?? '',
      descricao: data['descricao'] ?? '',
      preco: (data['preco'] as num?)?.toDouble() ?? 0.0,
      categoryId: data['categoryId'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      isAvailable: data['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'categoryId': categoryId,
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}