import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_catalog_provider.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  void _openProductDialog({CatalogProduct? existing}) {
    final bool isEdit = existing != null;
    final TextEditingController nameController = TextEditingController(
      text: existing?.product.name ?? '',
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
    final TextEditingController deliveryMinutesController =
        TextEditingController(
      text: existing == null
          ? '10'
          : existing.product.deliveryMinutes.toString(),
    );

    // Category dropdown state
    final List<GroceryCategory> categories =
        context.read<CategoryProvider>().categories;
    String? selectedCategoryId = existing?.product.categoryId;

    // If editing, verify selected category still exists
    if (selectedCategoryId != null &&
        !categories.any(
          (c) => c.name.toLowerCase() == selectedCategoryId,
        )) {
      selectedCategoryId = null;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Product' : 'Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.name.toLowerCase(),
                      child: Row(
                        children: [
                          Icon(cat.iconData, size: 18, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(cat.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategoryId = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Price (Rs)',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ratingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Rating (0.0 - 5.0)',
                    prefixIcon: Icon(Icons.star_outline),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit (eg: 1 kg, 500 g, 6 pcs)',
                    prefixIcon: Icon(Icons.straighten),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: deliveryMinutesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Delivery Time (minutes)',
                    prefixIcon: Icon(Icons.delivery_dining),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    prefixIcon: Icon(Icons.image_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
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
                final String category = selectedCategoryId ?? '';
                final double? price = double.tryParse(priceController.text);
                final double? rating = double.tryParse(ratingController.text);
                final String unit = unitController.text.trim();
                final String imageUrl = imageUrlController.text.trim();
                final String description = descriptionController.text.trim();
                final int? deliveryMins =
                    int.tryParse(deliveryMinutesController.text);

                if (name.isEmpty ||
                    category.isEmpty ||
                    price == null ||
                    rating == null ||
                    unit.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields.'),
                    ),
                  );
                  return;
                }

                if (rating < 0 || rating > 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rating must be between 0 and 5.'),
                    ),
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
                    deliveryMinutes: deliveryMins ?? 10,
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
                    deliveryMinutes: deliveryMins ?? 10,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProductCatalogProvider catalog = context
        .watch<ProductCatalogProvider>();
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
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: Image + Name/Price/Rating ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.green.shade100,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.local_grocery_store,
                                size: 28,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Rs ${product.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    product.unit,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${product.rating.toStringAsFixed(1)} rating',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Info chips: Category, Delivery, Section ──
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _infoChip(
                        icon: Icons.category_outlined,
                        label: product.categoryId,
                        color: Colors.blue,
                      ),
                      _infoChip(
                        icon: Icons.bolt,
                        label: '${product.deliveryMinutes} min delivery',
                        color: Colors.green,
                      ),
                      _infoChip(
                        icon: Icons.view_module_outlined,
                        label: product.section,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ── Description ──
                  if (product.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ),

                  // ── Action row: Stock toggle + Edit + Delete ──
                  Row(
                    children: [
                      // Stock toggle
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: inStock
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: inStock
                                    ? Colors.green.shade200
                                    : Colors.red.shade200,
                              ),
                            ),
                            child: Text(
                              inStock ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: inStock
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                              ),
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
                      const Spacer(),
                      IconButton(
                        tooltip: 'Edit product',
                        onPressed: () {
                          _openProductDialog(existing: item);
                        },
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete product',
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Product'),
                              content: Text(
                                'Are you sure you want to delete "${product.name}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<ProductCatalogProvider>()
                                        .removeProduct(product.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
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

  Widget _infoChip({
    required IconData icon,
    required String label,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
