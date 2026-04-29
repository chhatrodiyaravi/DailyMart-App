class OrderLine {
  const OrderLine({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.imageUrl = '',
    this.unit = '1 unit',
  });

  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final String imageUrl;
  final String unit;

  double get lineTotal => unitPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'imageUrl': imageUrl,
      'unit': unit,
    };
  }

  factory OrderLine.fromMap(Map<String, dynamic> map) {
    return OrderLine(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      unit: map['unit'] ?? '1 unit',
    );
  }
}

class AdminOrder {
  const AdminOrder({
    required this.id,
    required this.userId,
    required this.customer,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.lines,
  });

  final String id;
  final String userId;
  final String customer;
  final double amount;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final List<OrderLine> lines;

  int get itemCount => lines.fold<int>(0, (sum, line) => sum + line.quantity);

  AdminOrder copyWith({
    String? id,
    String? userId,
    String? customer,
    double? amount,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    DateTime? createdAt,
    List<OrderLine>? lines,
  }) {
    return AdminOrder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customer: customer ?? this.customer,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      lines: lines ?? this.lines,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'customer': customer,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'lines': lines.map((line) => line.toMap()).toList(),
    };
  }

  factory AdminOrder.fromMap(String id, Map<String, dynamic> map) {
    return AdminOrder(
      id: id,
      userId: map['userId'] ?? '',
      customer: map['customer'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      status: map['status'] ?? 'Placed',
      paymentMethod: map['paymentMethod'] ?? 'Cash on Delivery',
      paymentStatus: map['paymentStatus'] ?? 'Pending',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      lines: (map['lines'] as List<dynamic>?)
              ?.map((line) => OrderLine.fromMap(line as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
