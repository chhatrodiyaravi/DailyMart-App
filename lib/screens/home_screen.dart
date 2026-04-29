import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/category_provider.dart';
import '../providers/product_catalog_provider.dart';
import '../screens/product_list_screen.dart';
import '../widgets/cart_button.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_list.dart';
import '../widgets/product_grid.dart';
import '../widgets/banner_slider.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductCatalogProvider catalog = context
        .watch<ProductCatalogProvider>();
    final List<GroceryCategory> categories =
        context.watch<CategoryProvider>().categories;

    // Build sections dynamically from database categories
    final Set<String> availableSections = catalog.availableProducts
        .map((product) => product.section)
        .toSet();
    final List<GroceryCategory> activeSections = categories
        .where((cat) => availableSections.contains(cat.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: Color(0xFF1FA64A), size: 18),
                SizedBox(width: 4),
                Text(
                  'Deliver to Home',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Text(
              'Delivery in 10 minutes',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
        actions: const [CartButton(), SizedBox(width: 6)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomSearchBar(),
            const BannerSlider(),
            const SectionHeader(title: 'Shop by Category'),
            const CategoryList(),
            for (final cat in activeSections) ...[
              SectionHeader(
                title: cat.name,
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductListScreen(
                        title: cat.name,
                        categoryId: cat.name.toLowerCase(),
                      ),
                    ),
                  );
                },
              ),
              ProductGrid(
                products: catalog.productsForSection(cat.name),
              ),
            ],
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
