import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/product_catalog_provider.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _formatDateTime(DateTime value) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} ${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  void _showHistoryDialog(CatalogProduct item) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Product History'),
          content: SizedBox(
            width: 360,
            child: item.history.isEmpty
                ? const Text('No history available.')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: item.history.length,   
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (context, index) {
                      final ProductAuditEntry entry = item.history[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.action.toUpperCase()} • ${entry.actor}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(entry.details),
                          const SizedBox(height: 2),
                          Text(
                            _formatDateTime(entry.at),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _openProductDialog({CatalogProduct? existing}) {
    final bool isEdit = existing != null;
    final TextEditingController nameController = TextEditingController(
      text: existing?.product.name ?? '',
    );
    final TextEditingController categoryController = TextEditingController(
      text: existing?.product.categoryId ?? '',
    );
    final TextEditingController priceController = TextEditingController(
      text: existing == null ? '' : existing.product.price.toStringAsFixed(0),
    );
    final TextEditingController ratingController = TextEditingController(
      text: existing == null ? '' : existing.product.rating.toStringAsFixed(1),
    );
    final TextEditingController unitController = TextEditingController(
      text: existing?.product.unit ?? '',
    );
    final TextEditingController imageUrlController = TextEditingController(
      text: existing?.product.imageUrl ?? '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: existing?.product.description ?? '',
    );

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Product' : 'Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: ratingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Rating'),
                ),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit (eg: 1 kg, 500 g)',
                  ),
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final String name = nameController.text.trim();
                final String category = categoryController.text.trim();
                final double? price = double.tryParse(priceController.text);
                final double? rating = double.tryParse(ratingController.text);
                final String unit = unitController.text.trim();
                final String imageUrl = imageUrlController.text.trim();
                final String description = descriptionController.text.trim();

                if (name.isEmpty ||
                    category.isEmpty ||
                    price == null ||
                    rating == null ||
                    unit.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields.')),
                  );
                  return;
                }

                if (isEdit) {
                  context.read<ProductCatalogProvider>().updateProduct(
                    productId: existing.product.id,
                    name: name,
                    categoryId: category,
                    price: price,
                    rating: rating,
                    unit: unit,
                    imageUrl: imageUrl,
                    description: description,
                    actor: context.read<AuthProvider>().currentEmail,
                  );
                } else {
                  context.read<ProductCatalogProvider>().addProduct(
                    name: name,
                    categoryId: category,
                    price: price,
                    rating: rating,
                    unit: unit,
                    imageUrl: imageUrl,
                    description: description,
                    actor: context.read<AuthProvider>().currentEmail,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductCatalogProvider catalog = context
        .watch<ProductCatalogProvider>();
    final String adminEmail = AuthProvider.adminEmail.toLowerCase();
    final List<CatalogProduct> products = catalog.allProducts;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final CatalogProduct item = products[index];
          final bool inStock = item.inStock;
          final product = item.product;

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _showHistoryDialog(item);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(Icons.local_grocery_store),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (item.lastEditedBy.toLowerCase() ==
                                      adminEmail)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        'Admin Edited',
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${product.section} • Rs ${product.price.toStringAsFixed(0)} • ${product.rating.toStringAsFixed(1)}',
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Updated: ${_formatDateTime(item.updatedAt)} • History: ${item.history.length}',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 0,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              inStock ? 'In stock' : 'Out of stock',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Switch(
                              value: inStock,
                              onChanged: (value) {
                                context
                                    .read<ProductCatalogProvider>()
                                    .toggleStock(
                                      product.id,
                                      value,
                                      actor: context
                                          .read<AuthProvider>()
                                          .currentEmail,
                                    );
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          tooltip: 'View history',
                          onPressed: () {
                            _showHistoryDialog(item);
                          },
                          icon: const Icon(Icons.history),
                        ),
                        IconButton(
                          tooltip: 'Edit product',
                          onPressed: () {
                            _openProductDialog(existing: item);
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Delete product',
                          onPressed: () {
                            context
                                .read<ProductCatalogProvider>()
                                .removeProduct(product.id);
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openProductDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
