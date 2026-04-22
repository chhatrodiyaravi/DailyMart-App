import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../models/product.dart';
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
    final Set<String> availableSections = catalog.availableProducts
        .map((product) => product.section)
        .toSet();
    final List<String> sections = <String>[
      'Fruits',
      'Dairy',
      'Snacks',
    ].where(availableSections.contains).toList(growable: false);

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
            for (final section in sections) ...[
              SectionHeader(
                title: section,
                onSeeAll: () {
                  final String categoryId = section.isNotEmpty
                      ? section.toLowerCase()
                      : 'fruits';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductListScreen(
                        title: section,
                        categoryId: categoryId,
                      ),
                    ),
                  );
                },
              ),
              ProductGrid(products: catalog.productsForSection(section)),
            ],
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
