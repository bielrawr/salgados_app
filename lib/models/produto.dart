/// Modelo de dados para representar um produto no aplicativo
/// 
/// Esta classe define a estrutura de um produto com validações
/// e métodos para conversão de/para Firestore.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';

/// Exceção personalizada para erros de validação de produto
class ProdutoValidationException implements Exception {
  final String message;
  const ProdutoValidationException(this.message);
  
  @override
  String toString() => 'ProdutoValidationException: $message';
}

/// Classe que representa um produto no sistema
class Produto {
  /// ID único do produto (gerado pelo Firestore)
  String? id;
  
  /// Nome do produto (obrigatório, não pode estar vazio)
  final String nome;
  
  /// Descrição detalhada do produto
  final String descricao;
  
  /// Preço do produto (deve ser maior que zero)
  final double preco;
  
  /// ID da categoria à qual o produto pertence
  final String categoryId;
  
  /// Lista de URLs das imagens do produto
  final List<String> imageUrls;
  
  /// Indica se o produto está disponível para venda
  final bool isAvailable;
  
  /// Data de criação do produto
  final DateTime? createdAt;
  
  /// Data da última atualização do produto
  final DateTime? updatedAt;

  /// Construtor da classe Produto com validações
  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoryId,
    this.imageUrls = const [],
    this.isAvailable = true,
    this.createdAt,
    this.updatedAt,
  }) {
    _validateProduto();
  }

  /// Valida os dados do produto
  void _validateProduto() {
    if (nome.trim().isEmpty) {
      throw const ProdutoValidationException('Nome do produto não pode estar vazio');
    }
    
    if (nome.trim().length < 2) {
      throw const ProdutoValidationException('Nome do produto deve ter pelo menos 2 caracteres');
    }
    
    if (preco < 0) {
      throw const ProdutoValidationException('Preço não pode ser negativo');
    }
    
    if (preco == 0) {
      throw const ProdutoValidationException('Preço deve ser maior que zero');
    }
    
    if (categoryId.trim().isEmpty) {
      throw const ProdutoValidationException('ID da categoria é obrigatório');
    }
    
    // Valida URLs das imagens
    for (String url in imageUrls) {
      if (url.isNotEmpty && !_isValidUrl(url)) {
        throw ProdutoValidationException('URL de imagem inválida: $url');
      }
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

  /// Cria um produto a partir de um documento do Firestore
  factory Produto.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      
      if (data == null) {
        throw const ProdutoValidationException('Dados do produto não encontrados');
      }
      
      return Produto(
        id: doc.id,
        nome: data['nome']?.toString().trim() ?? '',
        descricao: data['descricao']?.toString().trim() ?? '',
        preco: _parsePrice(data['preco']),
        categoryId: data['categoryId']?.toString().trim() ?? '',
        imageUrls: _parseImageUrls(data['imageUrls']),
        isAvailable: data['isAvailable'] as bool? ?? true,
        createdAt: _parseTimestamp(data[FirebaseConstants.fieldCreatedAt]),
        updatedAt: _parseTimestamp(data[FirebaseConstants.fieldUpdatedAt]),
      );
    } catch (e) {
      throw ProdutoValidationException('Erro ao criar produto do Firestore: $e');
    }
  }
  
  /// Converte valor para preço válido
  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    
    if (value is num) {
      return value.toDouble();
    }
    
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    
    return 0.0;
  }
  
  /// Converte lista de URLs de imagens
  static List<String> _parseImageUrls(dynamic value) {
    if (value == null) return [];
    
    if (value is List) {
      return value
          .map((e) => e?.toString().trim() ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }
    
    return [];
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

  /// Converte o produto para um Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'nome': nome.trim(),
      'descricao': descricao.trim(),
      'preco': preco,
      'categoryId': categoryId.trim(),
      'imageUrls': imageUrls.where((url) => url.isNotEmpty).toList(),
      'isAvailable': isAvailable,
      FirebaseConstants.fieldCreatedAt: createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(),
      FirebaseConstants.fieldUpdatedAt: FieldValue.serverTimestamp(),
    };
  }
  
  /// Cria uma cópia do produto com novos valores
  Produto copyWith({
    String? id,
    String? nome,
    String? descricao,
    double? preco,
    String? categoryId,
    List<String>? imageUrls,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Produto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      preco: preco ?? this.preco,
      categoryId: categoryId ?? this.categoryId,
      imageUrls: imageUrls ?? this.imageUrls,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Retorna a primeira imagem do produto ou null se não houver
  String? get primaryImageUrl {
    return imageUrls.isNotEmpty ? imageUrls.first : null;
  }
  
  /// Retorna o preço formatado como string
  String get precoFormatado {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }
  
  /// Verifica se o produto tem imagens
  bool get hasImages => imageUrls.isNotEmpty;
  
  /// Retorna uma representação em string do produto
  @override
  String toString() {
    return 'Produto{id: $id, nome: $nome, preco: $preco, categoryId: $categoryId, isAvailable: $isAvailable}';
  }
  
  /// Compara dois produtos
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Produto &&
        other.id == id &&
        other.nome == nome &&
        other.descricao == descricao &&
        other.preco == preco &&
        other.categoryId == categoryId;
  }
  
  /// Gera hash code para o produto
  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        descricao.hashCode ^
        preco.hashCode ^
        categoryId.hashCode;
  }
}