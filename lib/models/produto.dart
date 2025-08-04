class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final int categoriaId;

  const Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoriaId,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      preco: map['preco'],
      categoriaId: map['categoria_id'],
    );
  }
}