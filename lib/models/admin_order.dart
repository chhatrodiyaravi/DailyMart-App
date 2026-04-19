class OrderLine {
  const OrderLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  double get lineTotal => unitPrice * quantity;
}

class AdminOrder {
  const AdminOrder({
    required this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.lines,
  });

  final String id;
  final String customer;
  final double amount;
  final String status;
  final DateTime createdAt;
  final List<OrderLine> lines;

  AdminOrder copyWith({
    String? id,
    String? customer,
    double? amount,
    String? status,
    DateTime? createdAt,
    List<OrderLine>? lines,
  }) {
    return AdminOrder(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lines: lines ?? this.lines,
    );
  }
}
