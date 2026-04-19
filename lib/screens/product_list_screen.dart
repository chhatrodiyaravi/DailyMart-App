import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_catalog_provider.dart';
import '../widgets/product_grid.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    super.key,
    required this.title,
    required this.categoryId,
  });

  final String title;
  final String categoryId;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _sortBy = 'Popular';

  @override
  Widget build(BuildContext context) {
    final ProductCatalogProvider catalog = context
        .watch<ProductCatalogProvider>();
    final List<Product> baseProducts = catalog.productsForCategory(
      widget.categoryId,
    );

    final List<Product> sortedProducts = List<Product>.from(baseProducts)
      ..sort((a, b) {
        if (_sortBy == 'Price: Low to High') {
          return a.price.compareTo(b.price);
        }
        if (_sortBy == 'Price: High to Low') {
          return b.price.compareTo(a.price);
        }
        return a.name.compareTo(b.name);
      });

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _sortBy,
                    decoration: const InputDecoration(
                      labelText: 'Sort by',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Popular',
                        child: Text('Popular'),
                      ),
                      DropdownMenuItem(
                        value: 'Price: Low to High',
                        child: Text('Price: Low to High'),
                      ),
                      DropdownMenuItem(
                        value: 'Price: High to Low',
                        child: Text('Price: High to Low'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _sortBy = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Filter options are UI-only for now.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filter'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ProductGrid(
              products: sortedProducts,
              shrinkWrap: false,
              physics: const BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
