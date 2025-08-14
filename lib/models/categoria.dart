
import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  String? id;
  final String nome;
  final String imageUrl;

  Categoria({this.id, required this.nome, required this.imageUrl});

  factory Categoria.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Categoria(
      id: doc.id,
      nome: data['nome'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
