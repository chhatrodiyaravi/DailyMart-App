import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/admin_order.dart';
import '../../providers/orders_provider.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final OrdersProvider ordersProvider = context.watch<OrdersProvider>();
    final List<AdminOrder> orders = ordersProvider.orders;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final AdminOrder order = orders[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(order.id),
            subtitle: Text(
              '${order.customer} • Rs ${order.amount.toStringAsFixed(0)}',
            ),
            trailing: DropdownButton<String>(
              value: order.status,
              items: OrdersProvider.statuses
                  .map(
                    (status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                context.read<OrdersProvider>().updateStatus(order.id, value);
              },
            ),
          ),
        );
      },
    );
  }
}
