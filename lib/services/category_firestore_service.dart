import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salgados_app/models/categoria.dart';
import 'package:salgados_app/services/product_firestore_service.dart';

class CategoryFirestoreService {
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  // Create/Add a new category
  Future<void> addCategory(Categoria category) async {
    await _categoriesCollection.add(category.toMap());
  }

  // Get all categories (real-time updates)
  Stream<List<Categoria>> getCategories() {
    return _categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Categoria.fromFirestore(doc);
      }).toList();
    });
  }

  // Update an existing category
  Future<void> updateCategory(Categoria category) async {
    await _categoriesCollection.doc(category.id).update(category.toMap());
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      // 1. Get the category to get the image URL
      DocumentSnapshot doc = await _categoriesCollection.doc(categoryId).get();
      if (doc.exists) {
        Categoria category = Categoria.fromFirestore(doc);

        // 2. Delete category image from storage
        if (category.imageUrl.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(category.imageUrl).delete();
        }

        // 3. Delete all products in the category
        QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: categoryId)
            .get();
            
        for (QueryDocumentSnapshot productDoc in productsSnapshot.docs) {
          await ProductFirestoreService().deleteProduct(productDoc.id);
        }

        // 4. Delete the category document
        await _categoriesCollection.doc(categoryId).delete();
      }
    } catch (e) {
      print("Error deleting category: $e");
      // Optionally re-throw or handle the error as needed
    }
  }
}
