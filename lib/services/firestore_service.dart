import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<GroceryCategory>> categoriesStream() {
    return _db.collection('categories').snapshots().map((snap) {
      return snap.docs
          .map((d) => GroceryCategory.fromMap(d.id, d.data()))
          .toList(growable: false);
    });
  }

  Stream<List<Product>> productsByCategoryStream(
    String categoryId, {
    int limit = 20,
  }) {
    return _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Product.fromMap(d.id, d.data()))
              .toList(growable: false),
        );
  }

  Stream<List<Product>> productsStream({int limit = 30}) {
    return _db
        .collection('products')
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => Product.fromMap(d.id, d.data()))
              .toList(growable: false),
        );
  }

  Future<void> addToCart(String userId, String productId, int quantity) async {
    final docRef = _db.collection('carts').doc(userId);
    await docRef.set({
      'items': {
        productId: {'quantity': quantity},
      },
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> cartStream(String userId) {
    return _db.collection('carts').doc(userId).snapshots();
  }
}
