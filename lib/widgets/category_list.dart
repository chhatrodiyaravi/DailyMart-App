import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../screens/product_list_screen.dart';
import 'category_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 114,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: DummyData.categories.length,
        itemBuilder: (context, index) {
          final category = DummyData.categories[index];
          return CategoryItem(
            category: category,
            width: 88,
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
