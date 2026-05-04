class Product {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.rating,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.description,
    required this.deliveryMinutes,
    required this.section,
  });

  final String id;
  final String name;
  final String categoryId;
  final double rating;
  final double price;
  final String unit;
  final String imageUrl;
  final String description;
  final int deliveryMinutes;
  final String section;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'rating': rating,
      'price': price,
      'unit': unit,
      'imageUrl': imageUrl,
      'description': description,
      'deliveryMinutes': deliveryMinutes,
      'section': section,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    // Safety helper to parse double/int from dynamic data
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

    return Product(
      id: id,
      name: map['name']?.toString() ?? '',
      categoryId: map['categoryId']?.toString() ?? '',
      rating: toDouble(map['rating']),
      price: toDouble(map['price']),
      unit: map['unit']?.toString() ?? '1 unit',
      imageUrl: map['imageUrl']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      deliveryMinutes: toInt(map['deliveryMinutes']),
      section: map['section']?.toString() ?? '',
    );
  }
}
