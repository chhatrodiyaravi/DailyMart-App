import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

/// Represents one item in the shopping cart
/// Shows the product and how many user wants
class _CartLine {
  const _CartLine({required this.product, required this.quantity});

  final Product product; // The product
  final int quantity; // How many user wants

  // Create a copy with some changes
  _CartLine copyWith({Product? product, int? quantity}) {
    return _CartLine(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Manages the shopping cart
/// - Keeps track of items and quantities
/// - Can save/load cart from Firebase so cart is not lost
/// - Tells UI when cart changes
class CartProvider extends ChangeNotifier {
  // Storage for all items in cart (uses productId as key for fast lookup)
  final Map<String, _CartLine> _items = <String, _CartLine>{};

  // Connection to Firebase database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Returns all cart items as a simple map (productId -> quantity)
  Map<String, int> get items => Map<String, int>.fromEntries(
    _items.entries.map(
      (entry) => MapEntry<String, int>(entry.key, entry.value.quantity),
    ),
  );

  // Get quantity of a specific product in cart
  int quantityFor(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  // Add product to cart, or increase quantity if already there
  void addProduct(Product product) {
    final _CartLine? existing = _items[product.id];
    if (existing == null) {
      // First time - add with quantity 1
      _items[product.id] = _CartLine(product: product, quantity: 1);
    } else {
      // Already in cart - just increase quantity
      _items[product.id] = existing.copyWith(quantity: existing.quantity + 1);
    }
    notifyListeners(); // Tell UI to update
  }

  // Increase quantity of a product
  void increase(Product product) {
    addProduct(product);
  }

  // Decrease quantity, or remove completely if quantity becomes 0
  void decrease(Product product) {
    final int currentQty = _items[product.id]?.quantity ?? 0;
    if (currentQty <= 1) {
      // Remove item completely
      _items.remove(product.id);
    } else {
      // Just decrease quantity
      _items[product.id] = _items[product.id]!.copyWith(
        quantity: currentQty - 1,
      );
    }
    notifyListeners(); // Tell UI to update
  }

  // Remove all items from cart
  void clear() {
    _items.clear();
    notifyListeners(); // Tell UI to update
  }

  // Total count of items (if you have 2 apples and 3 oranges, this is 5)
  int get totalItems {
    return _items.values.fold<int>(0, (sum, line) => sum + line.quantity);
  }

  // Total price of all items combined
  double get totalPrice {
    return _items.values.fold<double>(
      0,
      (sum, line) => sum + (line.product.price * line.quantity),
    );
  }

  // Get all products in cart as a list
  List<Product> get cartProducts {
    return _items.values.map((line) => line.product).toList(growable: false);
  }

  /// Save cart to Firebase for user
  /// This way, when user logs in again, their cart is restored
  /// Returns true if saved successfully, false if failed
  Future<bool> saveCartToFirestore(String userEmail) async {
    try {
      // Convert cart items to Firebase format
      final Map<String, dynamic> cartDataForFirebase = {};
      for (final entry in _items.entries) {
        cartDataForFirebase[entry.key] = {
          'quantity': entry.value.quantity,
          'productId': entry.key,
        };
      }

      // Save to Firebase under user's cart folder
      await _db
          .collection('users') // Go to users collection
          .doc(userEmail) // Find this user
          .collection('cart') // Go to their cart sub-collection
          .doc('items') // Save as 'items' document
          .set({
            'items': cartDataForFirebase,
            'lastUpdated': FieldValue.serverTimestamp(), // When we saved it
          });
      return true; // Success!
    } catch (error) {
      debugPrint('Error saving cart to Firestore: $error');
      return false; // Failed
    }
  }

  /// Load saved cart from Firebase for user
  /// Restores what was in their cart before they logged out
  /// Returns true if found saved cart, false if not found or failed
  Future<bool> restoreCartFromFirestore(String userEmail) async {
    try {
      // Get the saved cart from Firebase
      final DocumentSnapshot savedCartDoc = await _db
          .collection('users') // Go to users collection
          .doc(userEmail) // Find this user
          .collection('cart') // Go to their cart sub-collection
          .doc('items') // Get 'items' document
          .get();

      // Check if saved cart exists
      if (savedCartDoc.exists) {
        final Map<String, dynamic> cartData =
            savedCartDoc.data() as Map<String, dynamic>;
        final Map<String, dynamic> savedItems = cartData['items'] ?? {};

        // Clear current cart and load saved items
        _items.clear();
        for (final itemEntry in savedItems.entries) {
          debugPrint(
            'Restored item: ${itemEntry.key} - Qty: ${itemEntry.value["quantity"]}',
          );
        }
        notifyListeners(); // Tell UI to update
        return true; // Found and restored!
      }
      return false; // No saved cart found
    } catch (error) {
      debugPrint('Error restoring cart from Firestore: $error');
      return false; // Failed
    }
  }

  /// Delete saved cart from Firebase for user
  /// Called when user logs out or clears cart permanently
  /// Returns true if deleted successfully, false if failed
  Future<bool> clearCartFromFirestore(String userEmail) async {
    try {
      // Delete the saved cart from Firebase
      await _db
          .collection('users') // Go to users collection
          .doc(userEmail) // Find this user
          .collection('cart') // Go to their cart sub-collection
          .doc('items') // Delete 'items' document
          .delete();
      return true; // Success!
    } catch (error) {
      debugPrint('Error clearing cart from Firestore: $error');
      return false; // Failed
    }
  }
}
