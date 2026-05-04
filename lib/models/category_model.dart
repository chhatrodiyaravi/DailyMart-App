import 'package:flutter/material.dart';

class GroceryCategory {
  const GroceryCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
  });

  final String id;
  final String name;
  final String iconName;
  final String colorHex;

  /// Runtime helper — convert stored icon name to IconData
  IconData get iconData => _iconMap[iconName] ?? Icons.category;

  /// Runtime helper — convert stored hex to Color
  Color get colorValue {
    try {
      final String hex = colorHex.replaceFirst('#', '').trim();
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {
      // Fallback to default green if color string is invalid
    }
    return const Color(0xFFE8F5E9);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
    };
  }

  factory GroceryCategory.fromMap(String id, Map<String, dynamic> map) {
    return GroceryCategory(
      id: id,
      name: map['name']?.toString() ?? '',
      iconName: map['iconName']?.toString() ?? 'category',
      colorHex: map['colorHex']?.toString() ?? '#E8F5E9',
    );
  }

  /// Predefined icon map for category icon picker
  static const Map<String, IconData> _iconMap = {
    'apple': Icons.apple,
    'local_drink': Icons.local_drink,
    'cookie': Icons.cookie,
    'breakfast_dining': Icons.breakfast_dining,
    'local_cafe': Icons.local_cafe,
    'home': Icons.home,
    'egg': Icons.egg,
    'rice_bowl': Icons.rice_bowl,
    'icecream': Icons.icecream,
    'cake': Icons.cake,
    'restaurant': Icons.restaurant,
    'local_pizza': Icons.local_pizza,
    'set_meal': Icons.set_meal,
    'water_drop': Icons.water_drop,
    'spa': Icons.spa,
    'grass': Icons.grass,
    'category': Icons.category,
    'shopping_basket': Icons.shopping_basket,
    'local_grocery_store': Icons.local_grocery_store,
    'kitchen': Icons.kitchen,
    'blender': Icons.blender,
    'soup_kitchen': Icons.soup_kitchen,
    'bakery_dining': Icons.bakery_dining,
    'liquor': Icons.liquor,
    'coffee': Icons.coffee,
  };

  /// Expose icon map for the admin picker UI
  static Map<String, IconData> get availableIcons => _iconMap;
}
