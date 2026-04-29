import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class CatalogProduct {
  const CatalogProduct({required this.product, required this.inStock});

  final Product product;
  final bool inStock;

  CatalogProduct copyWith({Product? product, bool? inStock}) {
    return CatalogProduct(
      product: product ?? this.product,
      inStock: inStock ?? this.inStock,
    );
  }
}

class ProductCatalogProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<CatalogProduct> _items = [];

  List<CatalogProduct> get allProducts =>
      List<CatalogProduct>.unmodifiable(_items);

  List<Product> get availableProducts => _items
      .where((item) => item.inStock)
      .map((item) => item.product)
      .toList(growable: false);

  int get totalCount => _items.length;
  int get outOfStockCount => _items.where((item) => !item.inStock).length;

  /// Fetch all products from Firestore.
  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await _db.collection('products').get();

      _items = snapshot.docs
          .map((doc) {
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;
            return CatalogProduct(
              product: Product.fromMap(doc.id, data),
              inStock: data['inStock'] ?? true,
            );
          })
          .toList(growable: false);
    } catch (error) {
      debugPrint('Failed to load products from Firestore: $error');
    }

    notifyListeners();
  }

  Product productById(String id) {
    return _items.firstWhere((item) => item.product.id == id).product;
  }

  List<Product> productsForSection(String section) {
    return availableProducts
        .where((product) => product.section == section)
        .toList(growable: false);
  }

  List<Product> productsForCategory(String categoryId) {
    return availableProducts
        .where((product) => product.categoryId == categoryId)
        .toList(growable: false);
  }

  /// Toggle stock status in Firestore
  Future<void> toggleStock(
    String productId,
    bool inStock, {
    String actor = 'system',
  }) async {
    await _db.collection('products').doc(productId).update({
      'inStock': inStock,
    });
    final int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(inStock: inStock);
      notifyListeners();
    }
  }

  /// Delete product from Firestore
  Future<void> removeProduct(String productId) async {
    await _db.collection('products').doc(productId).delete();
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Add new product to Firestore
  Future<void> addProduct({
    required String name,
    required String categoryId,
    required double price,
    required double rating,
    required String unit,
    int deliveryMinutes = 10,
    String? imageUrl,
    String? description,
    String actor = 'system',
  }) async {
    final String normalizedCategory = categoryId.trim().toLowerCase();
    final String section =
        '${normalizedCategory[0].toUpperCase()}${normalizedCategory.substring(1)}';

    final Map<String, dynamic> data = {
      'name': name.trim(),
      'categoryId': normalizedCategory,
      'rating': rating,
      'price': price,
      'unit': unit.trim().isEmpty ? '1 unit' : unit.trim(),
      'imageUrl': (imageUrl ?? '').trim().isEmpty
          ? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600'
          : imageUrl!.trim(),
      'description': (description ?? '').trim().isEmpty
          ? 'Fresh grocery item added from admin panel.'
          : description!.trim(),
      'deliveryMinutes': deliveryMinutes,
      'section': section,
      'inStock': true,
    };

    final DocumentReference ref = await _db.collection('products').add(data);

    _items.add(
      CatalogProduct(product: Product.fromMap(ref.id, data), inStock: true),
    );
    notifyListeners();
  }

  /// Update product in Firestore
  Future<void> updateProduct({
    required String productId,
    required String name,
    required String categoryId,
    required double price,
    required double rating,
    required String unit,
    required String imageUrl,
    required String description,
    required int deliveryMinutes,
    String actor = 'system',
  }) async {
    final String normalizedCategory = categoryId.trim().toLowerCase();
    final String section =
        '${normalizedCategory[0].toUpperCase()}${normalizedCategory.substring(1)}';

    final Map<String, dynamic> data = {
      'name': name.trim(),
      'categoryId': normalizedCategory,
      'rating': rating,
      'price': price,
      'unit': unit.trim().isEmpty ? '1 unit' : unit.trim(),
      'imageUrl': imageUrl.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600'
          : imageUrl.trim(),
      'description': description.trim().isEmpty
          ? 'Fresh grocery item added from admin panel.'
          : description.trim(),
      'deliveryMinutes': deliveryMinutes,
      'section': section,
    };

    await _db.collection('products').doc(productId).update(data);

    final int index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        product: Product.fromMap(productId, {
          ..._items[index].product.toMap(),
          ...data,
        }),
      );
      notifyListeners();
    }
  }
}
