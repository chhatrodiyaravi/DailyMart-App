import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_catalog_provider.dart';
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomSearchBar(),
            const BannerSlider(),
            const SectionHeader(title: 'Shop by Category'),
            const CategoryList(),
            const SectionHeader(title: 'All Products'),
            ProductGrid(
              products: catalog.availableProducts,
              showAddButton: false,
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
