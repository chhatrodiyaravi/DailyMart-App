import 'package:flutter/foundation.dart';

import '../models/admin_order.dart';
import '../models/product.dart';

class OrdersProvider extends ChangeNotifier {
  final List<AdminOrder> _orders = <AdminOrder>[
    AdminOrder(
      id: 'ORD-1001',
      customer: 'aman@email.com',
      amount: 560,
      status: 'Placed',
      createdAt: DateTime.now(),
      lines: const <OrderLine>[],
    ),
    AdminOrder(
      id: 'ORD-1002',
      customer: 'riya@email.com',
      amount: 1140,
      status: 'Packed',
      createdAt: DateTime.now(),
      lines: const <OrderLine>[],
    ),
  ];

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

  void updateStatus(String orderId, String status) {
    final int index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) {
      return;
    }
    _orders[index] = _orders[index].copyWith(status: status);
    notifyListeners();
  }

  void placeOrder({
    required String customer,
    required List<Product> products,
    required Map<String, int> quantities,
    required double amount,
  }) {
    final List<OrderLine> lines = products
        .map(
          (product) => OrderLine(
            productId: product.id,
            productName: product.name,
            quantity: quantities[product.id] ?? 0,
            unitPrice: product.price,
          ),
        )
        .where((line) => line.quantity > 0)
        .toList(growable: false);

    final String id = 'ORD-${1000 + _orders.length + 1}';
    _orders.insert(
      0,
      AdminOrder(
        id: id,
        customer: customer,
        amount: amount,
        status: 'Placed',
        createdAt: DateTime.now(),
        lines: lines,
      ),
    );
    notifyListeners();
  }
}
