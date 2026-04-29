import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../screens/product_list_screen.dart';
import 'category_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GroceryCategory> categories =
        context.watch<CategoryProvider>().categories;

    if (categories.isEmpty) {
      return const SizedBox(height: 114);
    }

    return SizedBox(
      height: 114,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryItem(
            category: category,
            width: 88,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: category.name,
                    categoryId: category.name.toLowerCase(),
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
