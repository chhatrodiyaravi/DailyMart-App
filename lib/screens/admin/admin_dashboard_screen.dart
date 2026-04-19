import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders_provider.dart';
import '../../providers/product_catalog_provider.dart';
import '../../providers/users_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductCatalogProvider catalog = context
        .watch<ProductCatalogProvider>();
    final OrdersProvider orders = context.watch<OrdersProvider>();
    final UsersProvider users = context.watch<UsersProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Store Overview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        _MetricTile(
          icon: Icons.shopping_basket,
          title: 'Total Products',
          value: '${catalog.totalCount}',
        ),
        _MetricTile(
          icon: Icons.assignment_turned_in,
          title: 'Orders Today',
          value: '${orders.ordersToday}',
        ),
        _MetricTile(
          icon: Icons.payments_outlined,
          title: 'Revenue Today',
          value: 'Rs ${orders.revenueToday.toStringAsFixed(0)}',
        ),
        _MetricTile(
          icon: Icons.warning_amber_rounded,
          title: 'Low Stock Alerts',
          value: '${catalog.outOfStockCount}',
        ),
        _MetricTile(
          icon: Icons.group,
          title: 'Active Customers',
          value: '${users.activeCustomers}',
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green.shade800),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
