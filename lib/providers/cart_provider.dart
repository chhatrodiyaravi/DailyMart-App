import 'package:flutter/foundation.dart';

import '../models/product.dart';

class _CartLine {
  const _CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  _CartLine copyWith({Product? product, int? quantity}) {
    return _CartLine(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartProvider extends ChangeNotifier {
  final Map<String, _CartLine> _items = <String, _CartLine>{};

  Map<String, int> get items => Map<String, int>.fromEntries(
    _items.entries.map(
      (entry) => MapEntry<String, int>(entry.key, entry.value.quantity),
    ),
  );

  int quantityFor(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  void addProduct(Product product) {
    final _CartLine? existing = _items[product.id];
    if (existing == null) {
      _items[product.id] = _CartLine(product: product, quantity: 1);
    } else {
      _items[product.id] = existing.copyWith(quantity: existing.quantity + 1);
    }
    notifyListeners();
  }

  void increase(Product product) {
    addProduct(product);
  }

  void decrease(Product product) {
    final int quantity = _items[product.id]?.quantity ?? 0;
    if (quantity <= 1) {
      _items.remove(product.id);
    } else {
      _items[product.id] = _items[product.id]!.copyWith(quantity: quantity - 1);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems {
    return _items.values.fold<int>(0, (sum, line) => sum + line.quantity);
  }

  double get totalPrice {
    return _items.values.fold<double>(
      0,
      (sum, line) => sum + (line.product.price * line.quantity),
    );
  }

  List<Product> get cartProducts {
    return _items.values.map((line) => line.product).toList(growable: false);
  }
}
