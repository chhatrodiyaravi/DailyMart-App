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
}
