import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salgados_app/models/produto.dart';

class ProductFirestoreService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  // Create/Add a new product
  Future<void> addProduct(Produto product) async {
    await _productsCollection.add(product.toMap());
  }

  // Get all products (real-time updates)
  Stream<List<Produto>> getProducts() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Produto.fromFirestore(doc);
      }).toList();
    });
  }

  // Get products by category (real-time updates)
  Stream<List<Produto>> getProductsByCategory(String categoryId) {
    return _productsCollection
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Produto.fromFirestore(doc);
      }).toList();
    });
  }

  // Update an existing product
  Future<void> updateProduct(Produto product) async {
    await _productsCollection.doc(product.id).update(product.toMap());
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      DocumentSnapshot doc = await _productsCollection.doc(productId).get();
      if (doc.exists) {
        Produto product = Produto.fromFirestore(doc);
        if (product.imageUrls.isNotEmpty) {
          for (String imageUrl in product.imageUrls) {
            if (imageUrl.isNotEmpty) {
              await FirebaseStorage.instance.refFromURL(imageUrl).delete();
            }
          }
        }
        await _productsCollection.doc(productId).delete();
      }
    } catch (e) {
      print("Error deleting product: $e");
      // Optionally re-throw the error if you want calling code to handle it
      // throw e;
    }
  }
}
