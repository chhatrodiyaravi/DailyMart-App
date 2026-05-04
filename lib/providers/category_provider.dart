import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<GroceryCategory> _categories = [];

  List<GroceryCategory> get categories =>
      List<GroceryCategory>.unmodifiable(_categories);

  int get totalCount => _categories.length;

  /// Fetch categories from Firestore.
  Future<void> fetchCategories() async {
    final QuerySnapshot snapshot = await _db.collection('categories').get();

    _categories = snapshot.docs
        .map((doc) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return GroceryCategory.fromMap(doc.id, data);
        })
        .toList();

    notifyListeners();
  }

  /// Add a new category
  Future<bool> addCategory({
    required String name,
    required String iconName,
    required String colorHex,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name.trim(),
        'iconName': iconName,
        'colorHex': colorHex,
      };

      final DocumentReference ref = await _db
          .collection('categories')
          .add(data);
      _categories.add(GroceryCategory.fromMap(ref.id, data));
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding category: $e');
      return false;
    }
  }

  /// Update an existing category
  Future<bool> updateCategory({
    required String categoryId,
    required String name,
    required String iconName,
    required String colorHex,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name.trim(),
        'iconName': iconName,
        'colorHex': colorHex,
      };

      await _db.collection('categories').doc(categoryId).update(data);

      final int index = _categories.indexWhere((c) => c.id == categoryId);
      if (index != -1) {
        _categories[index] = GroceryCategory.fromMap(categoryId, data);
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint('Error updating category: $e');
      return false;
    }
  }

  /// Delete a category
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _db.collection('categories').doc(categoryId).delete();
      _categories.removeWhere((c) => c.id == categoryId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting category: $e');
      return false;
    }
  }
}
