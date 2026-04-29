import '../models/product.dart';

class DummyData {

  static const List<Product> products = [
    Product(
      id: 'p1',
      name: 'Fresh Bananas',
      categoryId: 'fruits',
      rating: 4.6,
      price: 42,
      unit: '6 pcs',
      imageUrl:
          'https://images.unsplash.com/photo-1574226516831-e1dff420e8f8?w=600',
      description: 'Naturally sweet bananas sourced fresh every morning.',
      deliveryMinutes: 10,
      section: 'Fruits',
    ),
    Product(
      id: 'p2',
      name: 'Royal Gala Apple',
      categoryId: 'fruits',
      rating: 4.7,
      price: 125,
      unit: '1 kg',
      imageUrl:
          'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=600',
      description: 'Crunchy, premium apples rich in flavor and freshness.',
      deliveryMinutes: 9,
      section: 'Fruits',
    ),
    Product(
      id: 'p3',
      name: 'Farm Fresh Milk',
      categoryId: 'dairy',
      rating: 4.5,
      price: 58,
      unit: '1 L',
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600',
      description: 'Pasteurized full cream milk delivered chilled.',
      deliveryMinutes: 8,
      section: 'Dairy',
    ),
    Product(
      id: 'p4',
      name: 'Greek Yogurt',
      categoryId: 'dairy',
      rating: 4.4,
      price: 95,
      unit: '400 g',
      imageUrl:
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=600',
      description: 'Thick and creamy yogurt packed with protein.',
      deliveryMinutes: 10,
      section: 'Dairy',
    ),
    Product(
      id: 'p5',
      name: 'Masala Chips',
      categoryId: 'snacks',
      rating: 4.3,
      price: 35,
      unit: '52 g',
      imageUrl:
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=600',
      description: 'Crispy potato chips with a spicy masala twist.',
      deliveryMinutes: 12,
      section: 'Snacks',
    ),
    Product(
      id: 'p6',
      name: 'Chocolate Cookies',
      categoryId: 'snacks',
      rating: 4.8,
      price: 79,
      unit: '200 g',
      imageUrl:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600',
      description: 'Baked crunchy cookies loaded with chocolate chips.',
      deliveryMinutes: 11,
      section: 'Snacks',
    ),
    Product(
      id: 'p7',
      name: 'Whole Wheat Bread',
      categoryId: 'bakery',
      rating: 4.5,
      price: 48,
      unit: '400 g',
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600',
      description: 'Soft whole wheat loaf baked with wholesome grains.',
      deliveryMinutes: 10,
      section: 'Bakery',
    ),
    Product(
      id: 'p8',
      name: 'Orange Juice',
      categoryId: 'beverages',
      rating: 4.6,
      price: 110,
      unit: '1 L',
      imageUrl:
          'https://images.unsplash.com/photo-1600271886742-f049cd5bba3f?w=600',
      description: '100% fruit juice with no added preservatives.',
      deliveryMinutes: 9,
      section: 'Beverages',
    ),
  ];

  static Product productById(String id) {
    return products.firstWhere((product) => product.id == id);
  }
}
