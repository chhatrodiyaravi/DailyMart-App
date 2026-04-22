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
    return Product(
      id: id,
      name: map['name'] ?? '',
      categoryId: map['categoryId'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      price: (map['price'] ?? 0).toDouble(),
      unit: map['unit'] ?? '1 unit',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      deliveryMinutes: map['deliveryMinutes'] ?? 10,
      section: map['section'] ?? '',
    );
  }
}
