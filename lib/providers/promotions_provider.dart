import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/promotion_model.dart';

/// Manager for all promotions and banners shown in the app
/// Connects to Firebase to load, save, and update promotions
class PromotionsProvider extends ChangeNotifier {
  // Connect to Firebase database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // List to store all promotions loaded from Firebase
  List<Promotion> _promotions = [];

  // Returns all promotions as read-only list (cannot be modified from outside)
  List<Promotion> get promotions => List<Promotion>.unmodifiable(_promotions);

  // Returns only active promotions (ones that should be displayed)
  List<Promotion> get activePromotions => List<Promotion>.unmodifiable(
    _promotions.where((promotion) => promotion.isActive).toList(),
  );

  // Total count of promotions
  int get totalCount => _promotions.length;

  /// Load all active promotions from Firebase.
  Future<void> fetchPromotions() async {
    final QuerySnapshot snapshot = await _db
        .collection('promotions')
        .where('isActive', isEqualTo: true)
        .get();

    _promotions = snapshot.docs
        .map((doc) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Promotion.fromMap(doc.id, data);
        })
        .toList(growable: false);

    notifyListeners();
  }

  /// Add a new promotion to Firebase
  /// Returns true if success, false if failed
  Future<bool> addPromotion({
    required String title,
    required String imageUrl,
    required int discount,
    required String description,
  }) async {
    try {
      // Prepare the promotion data
      final Map<String, dynamic> promotionData = {
        'title': title.trim(), // Remove extra spaces
        'imageUrl': imageUrl.trim(), // Remove extra spaces
        'discount': discount, // Discount percentage
        'description': description.trim(), // Remove extra spaces
        'isActive': true, // Active by default
      };

      // Add to Firebase and get the new document ID
      final DocumentReference newDoc = await _db
          .collection('promotions')
          .add(promotionData);

      // Add to local list
      _promotions.add(Promotion.fromMap(newDoc.id, promotionData));

      // Tell everyone listening that data changed
      notifyListeners();
      return true; // Success!
    } catch (error) {
      debugPrint('Error adding promotion: $error');
      return false; // Failed
    }
  }

  /// Update an existing promotion
  /// Returns true if success, false if failed
  Future<bool> updatePromotion({
    required String promotionId, // Which one to update
    required String title,
    required String imageUrl,
    required int discount,
    required String description,
    required bool isActive, // Turn on/off
  }) async {
    try {
      // Prepare updated data
      final Map<String, dynamic> updatedData = {
        'title': title.trim(),
        'imageUrl': imageUrl.trim(),
        'discount': discount,
        'description': description.trim(),
        'isActive': isActive,
      };

      // Update in Firebase
      await _db.collection('promotions').doc(promotionId).update(updatedData);

      // Find in local list
      final int index = _promotions.indexWhere((p) => p.id == promotionId);

      // Update local copy if found
      if (index != -1) {
        _promotions[index] = Promotion.fromMap(promotionId, updatedData);
        notifyListeners(); // Tell everyone data changed
      }
      return true; // Success!
    } catch (error) {
      debugPrint('Error updating promotion: $error');
      return false; // Failed
    }
  }

  /// Delete a promotion
  /// Returns true if success, false if failed
  Future<bool> deletePromotion(String promotionId) async {
    try {
      // Delete from Firebase
      await _db.collection('promotions').doc(promotionId).delete();

      // Remove from local list
      _promotions.removeWhere((p) => p.id == promotionId);

      // Tell everyone listening that data changed
      notifyListeners();
      return true; // Success!
    } catch (error) {
      debugPrint('Error deleting promotion: $error');
      return false; // Failed
    }
  }
}
