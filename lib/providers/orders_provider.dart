import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_order.dart';
import '../models/product.dart';

class OrdersProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<AdminOrder> _orders = [];

  static const List<String> statuses = <String>[
    'Placed',
    'Packed',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
  ];

  List<AdminOrder> get orders => List<AdminOrder>.unmodifiable(_orders);

  int get ordersToday => _orders.length;

  double get revenueToday => _orders
      .where((order) => order.status != 'Cancelled')
      .fold<double>(0, (sum, order) => sum + order.amount);

  /// Fetch orders by customer email from Firestore
  Future<List<AdminOrder>> fetchUserOrders(String email) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('orders')
          .where('customer', isEqualTo: email)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) =>
                AdminOrder.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Fetch all orders from Firestore
  Future<void> fetchOrders() async {
    final QuerySnapshot snapshot = await _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .get();

    _orders = snapshot.docs
        .map(
          (doc) =>
              AdminOrder.fromMap(doc.id, doc.data() as Map<String, dynamic>),
        )
        .toList();
    notifyListeners();
  }

  /// Update order status in Firestore
  Future<void> updateStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({'status': status});
    final int index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      notifyListeners();
    }
  }

  /// Place a new order and save to Firestore
  Future<void> placeOrder({
    required String customer,
    required List<Product> products,
    required Map<String, int> quantities,
    required double amount,
  }) async {
    final List<Map<String, dynamic>> linesMaps = products
        .map(
          (product) => OrderLine(
            productId: product.id,
            productName: product.name,
            quantity: quantities[product.id] ?? 0,
            unitPrice: product.price,
          ),
        )
        .where((line) => line.quantity > 0)
        .map((line) => line.toMap())
        .toList();

    final Map<String, dynamic> data = {
      'customer': customer,
      'amount': amount,
      'status': 'Placed',
      'createdAt': DateTime.now().toIso8601String(),
      'lines': linesMaps,
    };

    final DocumentReference ref = await _db.collection('orders').add(data);

    _orders.insert(0, AdminOrder.fromMap(ref.id, data));
    notifyListeners();
  }
}
