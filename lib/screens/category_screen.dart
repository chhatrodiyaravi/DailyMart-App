import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../widgets/category_item.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final int crossAxisCount = width < 380 ? 2 : 3;
    final List<GroceryCategory> categories =
        context.watch<CategoryProvider>().categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Shop by Category')),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final GroceryCategory category = categories[index];
                return CategoryItem(
                  category: category,
                  margin: EdgeInsets.zero,
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
