
class Categoria {
  final int id;
  final String nome;

  const Categoria({required this.id, required this.nome});

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      nome: map['nome'],
    );
  }
}
