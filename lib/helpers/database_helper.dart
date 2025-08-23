import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "salgados_app.db");
    print("Database path: $path");
    var theDb = await openDatabase(path, version: 3, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    print("Creating database tables...");
    // Cria a tabela de categorias
    await db.execute(
      "CREATE TABLE categorias (id INTEGER PRIMARY KEY, nome TEXT)"
    );

    // Cria a tabela de produtos
    await db.execute(
      "CREATE TABLE produtos (id INTEGER PRIMARY KEY, nome TEXT, descricao TEXT, preco REAL, categoria_id INTEGER, FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE)"
    );

    // Cria a tabela de imagens de produtos
    await db.execute(
      "CREATE TABLE imagens_produto (id INTEGER PRIMARY KEY, produto_id INTEGER, caminho_imagem TEXT, FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE)"
    );

    // Inserir dados de exemplo
    int pizzaId = await db.insert('categorias', {'nome': 'PIZZAS'});
    int salgadoId = await db.insert('categorias', {'nome': 'SALGADOS'});
    int doceId = await db.insert('categorias', {'nome': 'DOCES'});
    int bebidaId = await db.insert('categorias', {'nome': 'BEBIDAS'});

    // Produtos de exemplo para Pizzas
    int pizza1Id = await db.insert('produtos', {'nome': 'Pizza Calabresa', 'descricao': 'Deliciosa pizza de calabresa com queijo', 'preco': 35.00, 'categoria_id': pizzaId});
    await db.insert('imagens_produto', {'produto_id': pizza1Id, 'caminho_imagem': 'assets/images/pizzas.jpg'});

    // Produtos de exemplo para Salgados
    int salgado1Id = await db.insert('produtos', {'nome': 'Coxinha de Frango', 'descricao': 'Coxinha crocante com recheio de frango', 'preco': 7.50, 'categoria_id': salgadoId});
    await db.insert('imagens_produto', {'produto_id': salgado1Id, 'caminho_imagem': 'assets/images/salgado_1.jpg'});

    // Produtos de exemplo para Doces
    int doce1Id = await db.insert('produtos', {'nome': 'Bolo de Chocolate', 'descricao': 'Fatia de bolo de chocolate com cobertura', 'preco': 12.00, 'categoria_id': doceId});
    await db.insert('imagens_produto', {'produto_id': doce1Id, 'caminho_imagem': 'assets/images/bolo.jpg'});

    // Produtos de exemplo para Bebidas
    int bebida1Id = await db.insert('produtos', {'nome': 'Refrigerante Lata', 'descricao': 'Refrigerante de cola 350ml', 'preco': 6.00, 'categoria_id': bebidaId});
    await db.insert('imagens_produto', {'produto_id': bebida1Id, 'caminho_imagem': 'assets/images/bebidas.jpg'});
  }

  // Métodos CRUD para Categorias

  Future<int> salvarCategoria(Map<String, dynamic> categoria) async {
    var dbClient = await db;
    int res = await dbClient!.insert("categorias", categoria);
    print("DatabaseHelper: Categoria salva: $categoria, ID: $res");
    return res;
  }

  Future<List<Map<String, dynamic>>> getCategorias() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient!.rawQuery('SELECT * FROM categorias');
    print("DatabaseHelper: Categorias carregadas: $list");
    return list;
  }

  Future<int> deletarCategoria(int id) async {
    var dbClient = await db;
    int res = await dbClient!.delete("categorias", where: 'id = ?', whereArgs: [id]);
    print("DatabaseHelper: Categoria deletada com ID: $id, Resultado: $res");
    return res;
  }

  Future<int> atualizarCategoria(Map<String, dynamic> categoria) async {
    var dbClient = await db;
    int res = await dbClient!.update("categorias", categoria, where: "id = ?", whereArgs: [categoria['id']]);
    print("DatabaseHelper: Categoria atualizada: $categoria, Resultado: $res");
    return res;
  }

  // Métodos CRUD para Produtos

  Future<int> salvarProduto(Map<String, dynamic> produto) async {
    var dbClient = await db;
    int res = await dbClient!.insert("produtos", produto);
    return res;
  }

  Future<List<Map<String, dynamic>>> getProdutosPorCategoria(int categoriaId) async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient!.rawQuery('SELECT * FROM produtos WHERE categoria_id = ?', [categoriaId]);
    return list;
  }

  Future<int> deletarProduto(int id) async {
    var dbClient = await db;
    return await dbClient!.delete("produtos", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> atualizarProduto(Map<String, dynamic> produto) async {
    var dbClient = await db;
    return await dbClient!.update("produtos", produto, where: "id = ?", whereArgs: [produto['id']]);
  }

  // Métodos CRUD para Imagens de Produtos

  Future<int> salvarImagemProduto(Map<String, dynamic> imagem) async {
    var dbClient = await db;
    int res = await dbClient!.insert("imagens_produto", imagem);
    return res;
  }

  Future<List<Map<String, dynamic>>> getImagensPorProduto(int produtoId) async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient!.rawQuery('SELECT * FROM imagens_produto WHERE produto_id = ?', [produtoId]);
    return list;
  }

  Future<int> deletarImagemProduto(int id) async {
    var dbClient = await db;
    return await dbClient!.delete("imagens_produto", where: 'id = ?', whereArgs: [id]);
  }

  Future<String?> getRepresentativeImageForCategory(int categoryId) async {
    var dbClient = await db;
    print("DatabaseHelper: Buscando imagem representativa para categoria ID: $categoryId");
    // Busca o primeiro produto da categoria
    List<Map<String, dynamic>> products = await dbClient!.rawQuery(
        'SELECT id FROM produtos WHERE categoria_id = ? LIMIT 1',
        [categoryId]);

    if (products.isNotEmpty) {
      int productId = products.first['id'];
      print("DatabaseHelper: Produto encontrado para categoria ID $categoryId: Produto ID $productId");
      // Busca a primeira imagem para esse produto
      List<Map<String, dynamic>> images = await dbClient.rawQuery(
          'SELECT caminho_imagem FROM imagens_produto WHERE produto_id = ? LIMIT 1',
          [productId]);
      if (images.isNotEmpty) {
        print("DatabaseHelper: Imagem encontrada para produto ID $productId: ${images.first['caminho_imagem']}");
        return images.first['caminho_imagem'];
      }
    }
    print("DatabaseHelper: Nenhuma imagem representativa encontrada para categoria ID $categoryId. Retornando null.");
    return null;
  }
}