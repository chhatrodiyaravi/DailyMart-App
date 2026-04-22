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

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory OrderLine.fromMap(Map<String, dynamic> map) {
    return OrderLine(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] ?? 0).toDouble(),
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'customer': customer,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'lines': lines.map((line) => line.toMap()).toList(),
    };
  }

  factory AdminOrder.fromMap(String id, Map<String, dynamic> map) {
    return AdminOrder(
      id: id,
      customer: map['customer'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      status: map['status'] ?? 'Placed',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      lines: (map['lines'] as List<dynamic>?)
              ?.map((line) => OrderLine.fromMap(line as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
