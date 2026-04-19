import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/category_model.dart';
import '../widgets/category_item.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final int crossAxisCount = width < 380 ? 2 : 3;

    return Scaffold(
      appBar: AppBar(title: const Text('Shop by Category')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final GroceryCategory category = DummyData.categories[index];
          return CategoryItem(
            category: category,
            margin: EdgeInsets.zero,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: category.name,
                    categoryId: category.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
