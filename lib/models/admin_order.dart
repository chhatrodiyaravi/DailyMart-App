import 'package:cloud_firestore/cloud_firestore.dart';

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
    double toDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int toInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return OrderLine(
      productId: map['productId']?.toString() ?? '',
      productName: map['productName']?.toString() ?? '',
      quantity: toInt(map['quantity']),
      unitPrice: toDouble(map['unitPrice']),
      imageUrl: map['imageUrl']?.toString() ?? '',
      unit: map['unit']?.toString() ?? '1 unit',
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
    required this.deliveryAddress,
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
  final String deliveryAddress;
  final DateTime createdAt;
  final List<OrderLine> lines;

  int get itemCount => lines.fold<int>(0, (total, line) => total + line.quantity);

  AdminOrder copyWith({
    String? id,
    String? userId,
    String? customer,
    double? amount,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    String? deliveryAddress,
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
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
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
      'deliveryAddress': deliveryAddress,
      'createdAt': createdAt.toIso8601String(),
      'lines': lines.map((line) => line.toMap()).toList(),
    };
  }

  factory AdminOrder.fromMap(String id, Map<String, dynamic> map) {
    double toDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    final dynamic createdAtValue = map['createdAt'];
    final DateTime createdAt = createdAtValue is Timestamp
        ? createdAtValue.toDate()
        : createdAtValue is DateTime
            ? createdAtValue
            : DateTime.tryParse(createdAtValue?.toString() ?? '') ??
                DateTime.now();

    return AdminOrder(
      id: id,
      userId: map['userId']?.toString() ?? '',
      customer: map['customer']?.toString() ?? '',
      amount: toDouble(map['amount']),
      status: map['status']?.toString() ?? 'Placed',
      paymentMethod: map['paymentMethod']?.toString() ?? 'Cash on Delivery',
      paymentStatus: map['paymentStatus']?.toString() ?? 'Pending',
      deliveryAddress: map['deliveryAddress']?.toString() ?? '',
      createdAt: createdAt,
      lines: (map['lines'] as List<dynamic>?)
              ?.map((line) => OrderLine.fromMap(line as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
