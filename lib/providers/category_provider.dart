import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<GroceryCategory> _categories = [];
  bool _loaded = false;

  List<GroceryCategory> get categories =>
      List<GroceryCategory>.unmodifiable(_categories);

  int get totalCount => _categories.length;

  /// Seed data — used when Firestore 'categories' collection is empty
  static const List<Map<String, String>> _seedCategories = [
    {'name': 'Fruits', 'iconName': 'apple', 'colorHex': '#FFF4D6'},
    {'name': 'Dairy', 'iconName': 'local_drink', 'colorHex': '#DFF4FF'},
    {'name': 'Snacks', 'iconName': 'cookie', 'colorHex': '#FFE6E1'},
    {'name': 'Bakery', 'iconName': 'breakfast_dining', 'colorHex': '#FFF0DF'},
    {'name': 'Beverages', 'iconName': 'local_cafe', 'colorHex': '#E4F7EA'},
    {'name': 'Essentials', 'iconName': 'home', 'colorHex': '#EDEBFF'},
  ];

  /// Fetch categories from Firestore. Seed if empty.
  Future<void> fetchCategories() async {
    final QuerySnapshot snapshot = await _db.collection('categories').get();

    if (snapshot.docs.isEmpty && !_loaded) {
      // Seed Firestore
      for (final seed in _seedCategories) {
        await _db.collection('categories').add(seed);
      }
      // Re-fetch after seeding
      final QuerySnapshot seeded = await _db.collection('categories').get();
      _categories = seeded.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GroceryCategory.fromMap(doc.id, data);
      }).toList();
    } else {
      _categories = snapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GroceryCategory.fromMap(doc.id, data);
      }).toList();
    }

    _loaded = true;
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

      final DocumentReference ref =
          await _db.collection('categories').add(data);
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
