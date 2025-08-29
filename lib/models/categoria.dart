/// Modelo de dados para representar uma categoria no aplicativo
/// 
/// Esta classe define a estrutura de uma categoria com validações
/// e métodos para conversão de/para Firestore.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';

/// Exceção personalizada para erros de validação de categoria
class CategoriaValidationException implements Exception {
  final String message;
  const CategoriaValidationException(this.message);
  
  @override
  String toString() => 'CategoriaValidationException: $message';
}

/// Classe que representa uma categoria de produtos no sistema
class Categoria {
  /// ID único da categoria (gerado pelo Firestore)
  String? id;
  
  /// Nome da categoria (obrigatório, não pode estar vazio)
  final String nome;
  
  /// URL da imagem representativa da categoria
  final String imageUrl;
  
  /// Data de criação da categoria
  final DateTime? createdAt;
  
  /// Data da última atualização da categoria
  final DateTime? updatedAt;

  /// Construtor da classe Categoria com validações
  Categoria({
    this.id,
    required this.nome,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  }) {
    _validateCategoria();
  }

  /// Valida os dados da categoria
  void _validateCategoria() {
    if (nome.trim().isEmpty) {
      throw const CategoriaValidationException('Nome da categoria não pode estar vazio');
    }
    
    if (nome.trim().length < 2) {
      throw const CategoriaValidationException('Nome da categoria deve ter pelo menos 2 caracteres');
    }
    
    if (imageUrl.isNotEmpty && !_isValidUrl(imageUrl)) {
      throw CategoriaValidationException('URL de imagem inválida: $imageUrl');
    }
  }
  
  /// Verifica se uma URL é válida
  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Cria uma categoria a partir de um documento do Firestore
  factory Categoria.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      
      if (data == null) {
        throw const CategoriaValidationException('Dados da categoria não encontrados');
      }
      
      return Categoria(
        id: doc.id,
        nome: data['nome']?.toString().trim() ?? '',
        imageUrl: data['imageUrl']?.toString().trim() ?? '',
        createdAt: _parseTimestamp(data[FirebaseConstants.fieldCreatedAt]),
        updatedAt: _parseTimestamp(data[FirebaseConstants.fieldUpdatedAt]),
      );
    } catch (e) {
      throw CategoriaValidationException('Erro ao criar categoria do Firestore: $e');
    }
  }
  
  /// Converte timestamp do Firestore para DateTime
  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    
    if (value is Timestamp) {
      return value.toDate();
    }
    
    if (value is DateTime) {
      return value;
    }
    
    return null;
  }

  /// Converte a categoria para um Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'nome': nome.trim(),
      'imageUrl': imageUrl.trim(),
      FirebaseConstants.fieldCreatedAt: createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(),
      FirebaseConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
    };
  }
  
  /// Cria uma cópia da categoria com novos valores
  Categoria copyWith({
    String? id,
    String? nome,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Retorna o nome da categoria em maiúsculas
  String get nomeUpperCase => nome.toUpperCase();
  
  /// Verifica se a categoria tem imagem
  bool get hasImage => imageUrl.isNotEmpty;
  
  /// Retorna uma representação em string da categoria
  @override
  String toString() {
    return 'Categoria{id: $id, nome: $nome, imageUrl: $imageUrl}';
  }
  
  /// Compara duas categorias
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Categoria &&
        other.id == id &&
        other.nome == nome &&
        other.imageUrl == imageUrl;
  }
  
  /// Gera hash code para a categoria
  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        imageUrl.hashCode;
  }
}