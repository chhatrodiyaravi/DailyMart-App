class Promotion {
  const Promotion({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.discount,
    required this.description,
    required this.isActive,
  });

  final String id;
  final String title;
  final String imageUrl;
  final int discount;
  final String description;
  final bool isActive;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'discount': discount,
      'description': description,
      'isActive': isActive,
    };
  }

  factory Promotion.fromMap(String id, Map<String, dynamic> data) {
    return Promotion(
      id: id,
      title: data['title'] ?? 'Promotion',
      imageUrl: data['imageUrl'] ?? '',
      discount: data['discount'] ?? 0,
      description: data['description'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }
}
