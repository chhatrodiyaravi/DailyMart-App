import 'package:flutter/foundation.dart';

import '../data/dummy_data.dart';
import '../models/product.dart';

class ProductAuditEntry {
  const ProductAuditEntry({
    required this.action,
    required this.actor,
    required this.at,
    required this.details,
  });

  final String action;
  final String actor;
  final DateTime at;
  final String details;
}

class CatalogProduct {
  const CatalogProduct({
    required this.product,
    required this.inStock,
    required this.updatedAt,
    required this.lastEditedBy,
    required this.history,
  });

  final Product product;
  final bool inStock;
  final DateTime updatedAt;
  final String lastEditedBy;
  final List<ProductAuditEntry> history;

  CatalogProduct copyWith({
    Product? product,
    bool? inStock,
    DateTime? updatedAt,
    String? lastEditedBy,
    List<ProductAuditEntry>? history,
  }) {
    return CatalogProduct(
      product: product ?? this.product,
      inStock: inStock ?? this.inStock,
      updatedAt: updatedAt ?? this.updatedAt,
      lastEditedBy: lastEditedBy ?? this.lastEditedBy,
      history: history ?? this.history,
    );
  }
}

class ProductCatalogProvider extends ChangeNotifier {
  ProductCatalogProvider()
    : _items = DummyData.products
          .map(
            (product) => CatalogProduct(
              product: product,
              inStock: product.id != 'p5',
              updatedAt: DateTime.now(),
              lastEditedBy: 'system',
              history: <ProductAuditEntry>[
                ProductAuditEntry(
                  action: 'seed',
                  actor: 'system',
                  at: DateTime.now(),
                  details: 'Loaded from dummy catalog',
                ),
              ],
            ),
          )
          .toList(growable: true);

  final List<CatalogProduct> _items;

  List<CatalogProduct> get allProducts =>
      List<CatalogProduct>.unmodifiable(_items);

  List<Product> get availableProducts => _items
      .where((item) => item.inStock)
      .map((item) => item.product)
      .toList(growable: false);

  int get totalCount => _items.length;
  int get outOfStockCount => _items.where((item) => !item.inStock).length;

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

  void toggleStock(String productId, bool inStock, {String actor = 'system'}) {
    final int index = _items.indexWhere((item) => item.product.id == productId);
    if (index == -1) {
      return;
    }
    final CatalogProduct current = _items[index];
    final List<ProductAuditEntry> history =
        List<ProductAuditEntry>.from(current.history)..insert(
          0,
          ProductAuditEntry(
            action: 'stock',
            actor: actor,
            at: DateTime.now(),
            details: inStock ? 'Marked in stock' : 'Marked out of stock',
          ),
        );

    _items[index] = _items[index].copyWith(
      inStock: inStock,
      updatedAt: DateTime.now(),
      lastEditedBy: actor,
      history: history,
    );
    notifyListeners();
  }

  void removeProduct(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void addProduct({
    required String name,
    required String categoryId,
    required double price,
    required double rating,
    required String unit,
    String? imageUrl,
    String? description,
    String actor = 'system',
  }) {
    final String id = 'p${DateTime.now().millisecondsSinceEpoch}';
    final String normalizedCategory = categoryId.trim().toLowerCase();
    final String section =
        '${normalizedCategory[0].toUpperCase()}${normalizedCategory.substring(1)}';

    final Product product = Product(
      id: id,
      name: name.trim(),
      categoryId: normalizedCategory,
      rating: rating,
      price: price,
      unit: unit.trim().isEmpty ? '1 unit' : unit.trim(),
      imageUrl: (imageUrl ?? '').trim().isEmpty
          ? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600'
          : imageUrl!.trim(),
      description: (description ?? '').trim().isEmpty
          ? 'Fresh grocery item added from admin panel.'
          : description!.trim(),
      deliveryMinutes: 10,
      section: section,
    );

    _items.add(
      CatalogProduct(
        product: product,
        inStock: true,
        updatedAt: DateTime.now(),
        lastEditedBy: actor,
        history: <ProductAuditEntry>[
          ProductAuditEntry(
            action: 'create',
            actor: actor,
            at: DateTime.now(),
            details: 'Created product ${name.trim()}',
          ),
        ],
      ),
    );
    notifyListeners();
  }

  void updateProduct({
    required String productId,
    required String name,
    required String categoryId,
    required double price,
    required double rating,
    required String unit,
    required String imageUrl,
    required String description,
    String actor = 'system',
  }) {
    final int index = _items.indexWhere((item) => item.product.id == productId);
    if (index == -1) {
      return;
    }

    final CatalogProduct current = _items[index];
    final List<ProductAuditEntry> history =
        List<ProductAuditEntry>.from(current.history)..insert(
          0,
          ProductAuditEntry(
            action: 'update',
            actor: actor,
            at: DateTime.now(),
            details: 'Updated basic details',
          ),
        );
    final String normalizedCategory = categoryId.trim().toLowerCase();
    final String section =
        '${normalizedCategory[0].toUpperCase()}${normalizedCategory.substring(1)}';

    final Product updated = Product(
      id: current.product.id,
      name: name.trim(),
      categoryId: normalizedCategory,
      rating: rating,
      price: price,
      unit: unit.trim().isEmpty ? '1 unit' : unit.trim(),
      imageUrl: imageUrl.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600'
          : imageUrl.trim(),
      description: description.trim().isEmpty
          ? 'Fresh grocery item added from admin panel.'
          : description.trim(),
      deliveryMinutes: current.product.deliveryMinutes,
      section: section,
    );

    _items[index] = current.copyWith(
      product: updated,
      updatedAt: DateTime.now(),
      lastEditedBy: actor,
      history: history,
    );
    notifyListeners();
  }
}
