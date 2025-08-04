
class ImagemProduto {
  final int id;
  final int produtoId;
  final String caminhoImagem;

  const ImagemProduto({
    required this.id,
    required this.produtoId,
    required this.caminhoImagem,
  });

  factory ImagemProduto.fromMap(Map<String, dynamic> map) {
    return ImagemProduto(
      id: map['id'],
      produtoId: map['produto_id'],
      caminhoImagem: map['caminho_imagem'],
    );
  }
}
