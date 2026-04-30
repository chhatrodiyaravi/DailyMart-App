import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.showAddButton = true,
  });

  final List<Product> products;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          showAddButton: showAddButton,
        );
      },
    );
  }
}
